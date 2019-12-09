package com.drimsys.simulator;

import com.drimsys.simulator.systemtray.TrayIconHandler;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;

import static com.drimsys.simulator.util.Monitor.*;

@SpringBootApplication
public class SimulatorApplication {
	private static boolean ablePort() {
		return true;
//		try {
//			Socket socket = new Socket();
//			socket.connect(new InetSocketAddress("127.0.0.1", 8080), 200);
//			socket.close();
//			return true;
//		} catch (Exception e) {
//			return false;
//		}
	}

	private static void initDir() {
		File file = new java.io.File("resource");
		if(!file.exists()) {
			try {
				file.mkdir();
			} catch (Exception e) { }
		}

		file = new java.io.File("resource/xml");
		if(!file.exists()) {
			try {
				file.mkdir();
			} catch (Exception e) { }
		}

		file = new java.io.File("resource/manual");
		if(!file.exists()) {
			try {
				file.mkdir();
			} catch (Exception e) { }
		}
	}

	private static void start(ConfigurableApplicationContext[] app, String[] args) {
		try {
			monitering(TOMCAT_SOCKET);
			app[0] = SpringApplication.run(SimulatorApplication.class, args);
			JOptionPane.showMessageDialog(null, "서버가 실행되었습니다.");
		} catch (Exception e) {
			JOptionPane.showMessageDialog(null, "8080포트가 이미 사용중 입니다.");
		}
	}

	private static void stop(ConfigurableApplicationContext[] app) {
		app[0].close();
		JOptionPane.showMessageDialog(null, "서버가 종료되었습니다.");
	}

	private static void restart(ConfigurableApplicationContext[] app, String[] args) {
		app[0].close();
		start(app, args);
	}

	public static void main(String[] args) {
		ServerSocket serverSocket;
		try {
			serverSocket = new ServerSocket(APP_SOCKET);
		} catch (Exception e) {
			JOptionPane.showMessageDialog(null, "프로그램이 이미 구동중 입니다.");
			System.exit(0);
		}

		final ConfigurableApplicationContext[] app = {null};
		initDir();

		TrayIconHandler.registerTrayIcon(
				Toolkit.getDefaultToolkit().getImage("resource/icon/icon.png"),
				"Simulator",
				new ActionListener() {
					@Override
					public void actionPerformed(ActionEvent e) {
						if(app[0] == null) {
							start(app, args);
						} else {
							stop(app);
						}
					}
				}
		);

		TrayIconHandler.addItem("Startup", new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if(app[0] != null) {
					int rst = JOptionPane.showConfirmDialog(null, "서버를 재실행 하시겠습니까?", "Confirm", JOptionPane.YES_NO_OPTION);

					if (rst == JOptionPane.YES_OPTION) {
						restart(app, args);
					}
				} else {
					start(app, args);
				}
			}
		});

		TrayIconHandler.addItem("Shutdown", new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if(app[0] == null) {
					JOptionPane.showMessageDialog(null, "이미 서버가 종료되었습니다.");
				} else {
					stop(app);
				}
			}
		});

		TrayIconHandler.addItem("Exit", new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if(app[0] != null) app[0].close();
				System.exit(0);
			}
		});

		start(app, args);
	}

}
