package com.drimsys.simulator;

import com.drimsys.simulator.dto.Configuration;
import com.drimsys.simulator.model.ConfigurationModel;
import com.drimsys.simulator.systemtray.TrayIconHandler;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.context.ConfigurableApplicationContext;

import javax.swing.*;
import java.awt.*;
import java.lang.reflect.Field;
import java.net.ServerSocket;

@SpringBootApplication
public class SimulatorApplication implements EmbeddedServletContainerCustomizer {
	private static final ConfigurableApplicationContext[] app = {null};
	private static Configuration configuration;

    static {
		String osName = System.getProperty("os.name").toLowerCase();
		String rxtxLibPath = System.getProperty("user.dir");
		String[] libName = new String[2];

		if(osName.contains("mac")) {
			rxtxLibPath = rxtxLibPath + "/lib/osx;.";
			libName[0] = "librxtxParallel";
			libName[1] = "librxtxSerial";
		} else if(osName.contains("windows")) {
			switch(System.getProperty("sun.arch.data.model")) {
				case "32" :
					System.out.println("32");
					rxtxLibPath = rxtxLibPath + "\\lib\\windows\\x86;.";
					break;
				case "64" :
					System.out.println("64");
					rxtxLibPath = rxtxLibPath + "\\lib\\windows\\x64;.";
					break;
			}

			libName[0] = "rxtxParallel";
			libName[1] = "rxtxSerial";
		} else {
			showMessageDialog(osName + "은(는) 지원하지 않는 운영체제 입니다.");
			System.exit(0);
		}

        try {
            String libPath = System.getProperty("java.library.path");
            libPath = libPath.substring(0, libPath.length()-1) + rxtxLibPath;

            System.setProperty("java.library.path",libPath);
            Field fieldSysPath = ClassLoader.class.getDeclaredField( "sys_paths" );
            fieldSysPath.setAccessible( true );
            fieldSysPath.set( null, null );

            System.loadLibrary(libName[0]);
            System.loadLibrary(libName[1]);
        } catch (UnsatisfiedLinkError | IllegalAccessException | NoSuchFieldException e) {
			showMessageDialog("Native code library failed to load.\n" + e.getMessage());
			System.exit(1);
        }
    }

	private static void showMessageDialog(String message) {
		JDialog dialog = new JOptionPane(message).createDialog("Simulator");
		dialog.setAlwaysOnTop(true);
		dialog.setVisible(true);
	}

	private static int showConfirmDialog(Object[] message) {
		return JOptionPane.showConfirmDialog(null, message, "App Config", JOptionPane.OK_CANCEL_OPTION);
	}

	private static int showConfirmDialog(String message) {
		return showConfirmDialog(new Object[]{message});
	}

	private static void editConfig() {
		ConfigurationModel configModel = new ConfigurationModel();
		Configuration config = configModel.load();

		JTextField tomcatSockTextField = new JTextField(""+config.getTomcatSock());
		JTextField appSockTextField = new JTextField(""+config.getAppSock());

		Object[] message = {
				"Tomcat port :", tomcatSockTextField,
				"JVM port :", appSockTextField
		};

		int option = showConfirmDialog(message);
		if (option == JOptionPane.OK_OPTION) {
			try {
				// string to int
				int tomcatSock = Integer.parseInt(tomcatSockTextField.getText());
				int appSock = Integer.parseInt(appSockTextField.getText());

				// file save
				config = new Configuration(tomcatSock, appSock);
				if(config.toString().equals(configuration.toString())) {
					showMessageDialog("변경사항이 없습니다.");
					return;
				}

				if(configModel.save(config)) {
					if(configuration.getAppSock() != config.getAppSock()) {
						showMessageDialog("JVM port 가 변경되었습니다.\n\n프로그램 종료합니다.");
						System.exit(0);
					}
					showMessageDialog("변경 성공\n\n시뮬레이터를 재시작 합니다.");
					configuration = config;
					restart();
				} else {
					showMessageDialog("변경 내용을 저장하지 못하였습니다.");
				}

			} catch(Exception ex) {
				showMessageDialog("숫자만 입력 가능합니다.");
			}
		}
	}

	private static void start() {
		try {
			ServerSocket socket = new ServerSocket(8080);
			socket.close();

			app[0] = SpringApplication.run(SimulatorApplication.class, "");
			showMessageDialog("서버가 실행되었습니다.\n\n" +
							  "JVM port : " + configuration.getAppSock()  + "\n" +
							  "Tomcat port : " + configuration.getTomcatSock());
		} catch (Exception e) {
			showMessageDialog(configuration.getTomcatSock() + "포트가 이미 사용 중입니다.");
		}
	}

	private static void stop() {
		if(app[0] != null) app[0].close();
		showMessageDialog("서버가 종료되었습니다.");
	}

	private static void restart() {
		if(app[0] != null) app[0].close();
		start();
	}

	public static void main(String[] args) {
		configuration = new Initialization().initApplication();

		TrayIconHandler.registerTrayIcon(
				Toolkit.getDefaultToolkit().getImage("resource/icon/icon.png"),
				"Simulator",
				e -> {}
		);

		TrayIconHandler.addItem("Startup", e -> {
			if(app[0] != null) {
				int rst = showConfirmDialog("서버를 재실행 하시겠습니까?");
				if (rst == JOptionPane.YES_OPTION) restart();
			} else {
				start();
			}
		});

		TrayIconHandler.addItem("Restart", e -> restart());
		TrayIconHandler.addItem("Shutdown", e -> stop());

		TrayIconHandler.addSeparator();

		TrayIconHandler.addItem("App Config", e -> {
			editConfig();
		});

		TrayIconHandler.addSeparator();

		TrayIconHandler.addItem("Exit", e -> {
			stop();
			System.exit(0);
		});

		start();
	}

	@Override
	public void customize(ConfigurableEmbeddedServletContainer container) {
		if(configuration == null) return;
		if(configuration.getTomcatSock() < 1) return;
		container.setPort(configuration.getTomcatSock());
	}
}