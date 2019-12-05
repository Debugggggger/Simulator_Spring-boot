package com.drimsys.simulator.util;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class SerialReader extends Thread{
    private InputStream in;
    private List<Byte> readData = new ArrayList<>();
    private boolean stop = false;

    List<Byte> getReadData() {
        return readData;
    }
    void clearReadData(){ this.readData = new ArrayList<>(); }
    public void setStop(boolean stop){
        this.stop = stop;
    }

    SerialReader(InputStream in) {
        this.in = in;
    }

    public synchronized void run() {
        try {
            byte[] buffer = new byte[1024];
            int len;
                while ((len = this.in.read(buffer)) > -1) {
                    if(stop){
                        return;
                    }
                    for(int i = 0; i<len; i++){
                        readData.add(buffer[i]);
                    }
                }
        } catch (Exception e) {
//            e.printStackTrace();
        }
    }
}