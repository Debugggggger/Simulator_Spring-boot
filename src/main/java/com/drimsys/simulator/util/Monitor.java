package com.drimsys.simulator.util;

import java.net.DatagramSocket;

public class Monitor {
    public static final int TOMCAT_SOCKET = 8080;
    public static final int APP_SOCKET = 1103;

    private static DatagramSocket isRun;

    public static void monitering(int sock) {
        try {
            isRun = new DatagramSocket(sock);
        } catch (Exception e) { }
    }

    public static void close() {
        if(isRun != null) {
            isRun.close();
        }
    }
}
