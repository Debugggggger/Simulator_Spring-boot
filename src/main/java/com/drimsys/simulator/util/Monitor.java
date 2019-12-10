package com.drimsys.simulator.util;

import java.net.DatagramSocket;

public class Monitor {
    private static DatagramSocket isRun;

    public static void monitering(int sock) throws Exception {
        isRun = new DatagramSocket(sock);
    }

    public static void close() {
        if(isRun != null) {
            isRun.close();
        }
    }
}
