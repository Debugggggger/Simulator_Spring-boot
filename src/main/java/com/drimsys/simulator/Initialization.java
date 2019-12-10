package com.drimsys.simulator;

import com.drimsys.simulator.dto.Configuration;
import com.drimsys.simulator.model.ConfigurationModel;

import javax.swing.*;
import java.io.File;
import java.net.ServerSocket;

import static com.drimsys.simulator.util.Monitor.monitering;

public class Initialization {
    private final ConfigurationModel configurationModel = new ConfigurationModel();

    Configuration initApplication() {
        Configuration configuration = getInitConfig();
        initDir();

        // 프로그램 중복실행 체크
        try {
            monitering(configuration.getAppSock());
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "프로그램이 이미 구동 중입니다.");
            System.exit(0);
        }

        // tomcat 포트 확인
        try {
            ServerSocket socket = new ServerSocket(8080);
            socket.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, configuration.getAppSock() + "포트가 이미 사용 중입니다.");
        }

        return configuration;
    }

    private void initDir() {
        File file = new File("resource");
        if(!file.exists()) {
            try {
                file.mkdir();
            } catch (Exception e) { }
        }

        file = new File("resource/xml");
        if(!file.exists()) {
            try {
                file.mkdir();
            } catch (Exception e) { }
        }

        file = new File("resource/manual");
        if(!file.exists()) {
            try {
                file.mkdir();
            } catch (Exception e) { }
        }
    }

    private Configuration getInitConfig() {
        Configuration configuration = configurationModel.load();
        if(configuration == null) {
            configuration =  new Configuration(8080, 1103);

            if(configurationModel.save(configuration)) {
                return configuration;
            }

            JOptionPane.showMessageDialog(null,
                                "프로그램 초기화 실패\n" +
                                          "App.config 파일 생성에 실패했습니다.");
            System.exit(0);
        } else {
            return  configuration;
        }

        return null;
    }
}
