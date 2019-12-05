package com.drimsys.simulator;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.File;

@SpringBootApplication
public class SimulatorApplication {

	public static void main(String[] args) {
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

		try {
			String path = System.getProperty("user.dir")+"\\resource\\lib";
			System.setProperty("java.library.path", path);

		} catch(Exception e) {
			System.out.println("dll load failure");
		}

		SpringApplication.run(SimulatorApplication.class, args);
	}

}
