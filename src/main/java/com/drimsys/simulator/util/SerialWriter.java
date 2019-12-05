package com.drimsys.simulator.util;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

class SerialWriter{
    private OutputStream out;
    private List<Byte> writtenData = new ArrayList<>();

    List<Byte> getWrittenData(){ return writtenData; }
    void clearWrittenData(){ this.writtenData = new ArrayList<>(); }

    SerialWriter(OutputStream out) {
        this.out = out;
    }

    boolean writeData(List<Byte> bytes){
        if(bytes == null){
            return false;
        }
        try {
            for (byte tempByte : bytes){
                this.out.write(tempByte);
                writtenData.add(tempByte);
            }
            return true;

        }catch (Exception e){
//            e.printStackTrace();
            return false;
        }
    }
}
