package com.drimsys.simulator.util;

import com.drimsys.simulator.dto.EqSetting;
import com.drimsys.simulator.websocket.ScenarioThread;
import com.drimsys.simulator.websocket.Websocket;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import lombok.Getter;
import lombok.Setter;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

public class SerialUtil {
    private int parity;
    private int baudRate;
    private int dataBits;
    private int stopBits;

    @Getter @Setter private boolean stop;

    private String     port;
    private SerialPort serialPort;

    private SerialReader reader;
    private SerialWriter writer;

    private static Map<String, SerialUtil> serialConn = new HashMap<>();

    private static List<SerialUtil> serialUtilList = new ArrayList<>();
    public synchronized static boolean disconnectAllPort(){
        for(String port : getAllPorts()){
            SerialUtil serialUtil = serialConn.get(port);
            System.out.println("discon >> " + port);

            if(serialUtil != null){
                serialUtil.disconnect();
            }
        }
        return true;
    }

    public SerialUtil(String port, EqSetting eqSetting) {
        super();
        this.port = port;
        this.baudRate = eqSetting.getBaudRate();
        this.dataBits = eqSetting.getDataBits();
        this.stopBits = eqSetting.getStopBits();
        this.parity = eqSetting.getParity();
    }

    public SerialUtil(String port, int baudRate, int dataBits, int stopBits, int parity) {
        super();
        this.port = port;
        this.baudRate = baudRate;
        this.dataBits = dataBits;
        this.stopBits = stopBits;
        this.parity = parity;
    }

    public static synchronized SerialUtil getSerialPort(String port, EqSetting eqSetting){
        SerialUtil serialUtil = new SerialUtil(port, eqSetting);
        serialConn.put(port, serialUtil);
        if (serialUtil.connect()) {
            return serialUtil;
        } else {
            return null;
        }
    }
    public synchronized boolean connect() {
        try {
            CommPortIdentifier portIdentifier = CommPortIdentifier.getPortIdentifier(port);
            if (portIdentifier.isCurrentlyOwned()) {
                System.out.println("Error: Port is currently in use");

                return false;
            } else {
                CommPort commPort = portIdentifier.open(this.getClass().getName(), 2000);

                if (commPort instanceof SerialPort) {
                    this.serialPort = (SerialPort) commPort;
                    serialPort.setSerialPortParams(baudRate, dataBits, stopBits, parity);
                    InputStream inputStream = serialPort.getInputStream();
                    OutputStream outputStream = serialPort.getOutputStream();
                    this.reader = new SerialReader(inputStream);
                    this.writer = new SerialWriter(outputStream);

                    reader.start();
                    return true;
                } else {
                    System.out.println("Error: Only serial ports are handled by this example.");

                    return false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public synchronized boolean disconnect(){
        stop = true;
        serialConn.remove(port);
        try {
            ScenarioThread thread = (ScenarioThread)Websocket.portMap.get(port);
            if(thread != null){
                thread.setStop(true);
                Websocket.portMap.remove(port);
            }
            while(true) {
                reader.setStop(true);
                if(!reader.isAlive()){
                    serialPort.getInputStream().close();
                    serialPort.getOutputStream().close();
                    serialPort.close();
                    break;
                }
            }
            return true;
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public synchronized static List<String> listPorts() {
        List<String> ports = new LinkedList<>();

        try {
        	Enumeration<CommPortIdentifier> portEnum = CommPortIdentifier.getPortIdentifiers();
            while (portEnum.hasMoreElements()) {
                CommPortIdentifier portIdentifier = portEnum.nextElement();
                String port = portIdentifier.getName();
                if(port.contains("Bluetooth") || port.contains("/tty.")) continue;
                if(isAble(port)) {
                    ports.add(port);
                }
            }
        } catch(Exception e) { e.printStackTrace();}

        return ports;
    }

    public synchronized static List<String> getAllPorts() {
        List<String> ports = new LinkedList<>();

        try {
        	Enumeration<CommPortIdentifier> portEnum = CommPortIdentifier.getPortIdentifiers();
            while (portEnum.hasMoreElements()) {
                CommPortIdentifier portIdentifier = portEnum.nextElement();
                String port = portIdentifier.getName();
                if(port.contains("Bluetooth") || port.contains("/tty.")) continue;
                ports.add(port);
            }
        } catch(Exception e) {
        	e.printStackTrace();
        }

        return ports;
    }

    public synchronized static boolean isAble(String port) {
        try {
            return !CommPortIdentifier.getPortIdentifier(port).isCurrentlyOwned();
        } catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public List<Byte> getReadData() { return this.reader.getReadData(); }
    public void readDataClear() { this.reader.clearReadData(); }

    public List<Byte> getWrittenData(){ return this.writer.getWrittenData(); }
    public boolean writeData(List<Byte> bytes){ return this.writer.writeData(bytes); }
    public void WrittenDataClear(){ this.writer.clearWrittenData(); }

    public synchronized static SerialUtil getSerialConn(String port){ return serialConn.get(port); }

    public synchronized static void setSerialConn(String port, SerialUtil serialUtil){
        serialConn.put(port, serialUtil);
    }

}
