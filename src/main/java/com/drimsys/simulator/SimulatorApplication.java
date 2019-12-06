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

@SpringBootApplication
public class SimulatorApplication {
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

	public static void main(String[] args) {
		final ConfigurableApplicationContext[] app = {null};
		initDir();

		TrayIconHandler.registerTrayIcon(
				Toolkit.getDefaultToolkit().getImage("resource/icon/icon.png"),
				"Simulator",
				new ActionListener() {
					@Override
					public void actionPerformed(ActionEvent e) {
						if(app[0] == null) {
							JOptionPane.showMessageDialog(null, "서버가 실행되었습니다.");
							app[0] = SpringApplication.run(SimulatorApplication.class, args);
						} else {
							JOptionPane.showMessageDialog(null, "서버가 종료되었습니다.");
							app[0].close();
						}
					}
				}
		);

		TrayIconHandler.addItem("Startup", new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if(app[0] != null) {
					JOptionPane.showMessageDialog(null, "이미 서버가 실행중입니다.");
				} else {
					JOptionPane.showMessageDialog(null, "서버가 실행되었습니다.");
					app[0] = SpringApplication.run(SimulatorApplication.class, args);
				}
			}
		});

		TrayIconHandler.addItem("Shutdown", new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if(app[0] == null) {
					JOptionPane.showMessageDialog(null, "이미 서버가 종료되었습니다.");
				} else {
					JOptionPane.showMessageDialog(null, "서버가 종료되었습니다.");
					app[0].close();
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

		JOptionPane.showMessageDialog(null, "서버가 실행되었습니다.");
		app[0] = SpringApplication.run(SimulatorApplication.class, args);
	}

}
