package com.drimsys.simulator.model;

import com.drimsys.simulator.dto.Configuration;
import com.drimsys.simulator.util.Convert;

import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;

public class ConfigurationModel{
    private final String PATH = "";
    private final String FILE_NAME = "App.config";

    public boolean save(Configuration config) {
        try {
            String contents = config.toString();

            BufferedOutputStream bs = new BufferedOutputStream(new FileOutputStream(PATH + FILE_NAME));
            bs.write(contents.getBytes());
            bs.close();
        } catch (Exception e) {
            return false;
        }

        return true;
    }

    public Configuration load() {
        try {
            // 바이트 단위로 파일읽기
            String filePath = PATH + FILE_NAME;

            FileInputStream fileStream = new FileInputStream( filePath );
            //버퍼 선언
            byte[] readBuffer = new byte[fileStream.available()];
            while (fileStream.read(readBuffer) != -1){}

            fileStream.close();

            return (Configuration) Convert.parse(new String(readBuffer), Configuration.class);
        } catch (Exception e) {
            return null;
        }
    }
}
