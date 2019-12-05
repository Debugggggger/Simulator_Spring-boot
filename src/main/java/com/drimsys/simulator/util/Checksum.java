package com.drimsys.simulator.util;

import com.drimsys.simulator.dto.Component;
import com.drimsys.simulator.dto.MessageFrame;

import java.util.LinkedList;
import java.util.List;

public class Checksum{
    public static String sum(MessageFrame messageFrame, String from, String to) {
        if(messageFrame == null) return "null";
        if(messageFrame.getComponents() == null) return "null";
        if(messageFrame.getComponents().isEmpty()) return "null";

        int result = 0;
        String value = "";
        List<String> componentOrder = new LinkedList<>();

        int idx = 0, start = 0, end = 0;

        for(Component component : messageFrame.getComponents()) {
            if(component.getName().toLowerCase().equals(from.toLowerCase())) {
                start = idx;
            }
            if(component.getName().toLowerCase().equals(to.toLowerCase())) {
                end = idx;
                break;
            }
            idx++;
        }

        if(start > end) return "Error";

        if(start == end) {
            Component component = messageFrame.getComponents().get(start);

            switch(component.getType().toLowerCase()) {
                case "text" :
                    value = component.getValue().get(0);
                    for(char c : value.toCharArray()) {
                        result += (int)c;
                    }
                    break;
                case "hex":
                    value = component.getValue().get(0);
                    if(value.toLowerCase().contains("0x")) value = value.replace("0x", "");
                    for(char c : value.toCharArray()) {
                        result += Integer.parseInt(String.valueOf(c), 16);
                    }

                    break;
                default:
                    return "null";
            }
            return "0x" + Integer.toString(result, 16);
        } else {
           
        }

//        for(Component component : messageFrame.getComponents()) {
//            switch(component.getType().toLowerCase()) {
//                case "text" :
//                    value = component.getValue().get(0);
//                    for(char c : value.toCharArray()) {
//                        result += (int)c;
//                    }
//                    break;
//                case "hex":
//                    value = component.getValue().get(0);
//                    if(value.toLowerCase().contains("0x")) value = value.replace("0x", "");
//                    for(char c : value.toCharArray()) {
//                        result += Integer.parseInt(String.valueOf(c), 16);
//                    }
//
//                    break;
//                default:
//                    return "null";
//            }
//
//            if(component.getName().toLowerCase().equals(to.toLowerCase())) break;
//        }


        return "0x" + Integer.toString(result, 16);
    }
}
