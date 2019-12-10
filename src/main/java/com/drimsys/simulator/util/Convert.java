package com.drimsys.simulator.util;

import com.drimsys.simulator.dto.*;
import com.google.gson.Gson;

import java.lang.reflect.Type;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.drimsys.simulator.util.Message.COMMAND_TYPE;
import static com.drimsys.simulator.util.Message.RESPONSE_TYPE;

/**
 * 변환 유틸
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:07
 */

public class Convert {
    public synchronized static MessageFrame scenarioFrameToMessageFrame(Eq eq, ScenarioFrame scenarioFrame){
        if(eq == null || scenarioFrame == null){
            return null;
        }

        String mName = scenarioFrame.getName();
        String mType = scenarioFrame.getType().toLowerCase();

        Map<String, MessageFrame> map = eq.getMessageFrames();
        if(mType.equals("command")){
            mName = COMMAND_TYPE + mName;
        }else{
            mName = RESPONSE_TYPE + mName;
        }
        if(map == null){
            return null;
        }
        if(map.get(mName) == null){
            return null;
        }

        return map.get(mName);
    }

    public synchronized static List<MessageFrame> scenarioToMessageFrames(Eq eq, Scenario scenario){

        if(eq == null || scenario == null){
            return null;
        }
        List<MessageFrame> messageFrames = new ArrayList<>();
        for(ScenarioFrame scenarioFrame : scenario.getMessageFrames()) {
            MessageFrame tempMessageFrame = scenarioFrameToMessageFrame(eq, scenarioFrame);
            if (tempMessageFrame != null) {
                messageFrames.add(tempMessageFrame);
            }
        }
        if(messageFrames.size() == 0){
            return null;
        }

        return messageFrames;
    }

    public static String encodeURL(String str) {
        try{
            str = URLEncoder.encode(str, "UTF-8");
        } catch(Exception e) {
            e.printStackTrace();
        }

        str = str.replace("request=", "");

        return str;
    }

    public static String decodeURL(String str) {
        try{
            str = URLDecoder.decode(str, "UTF-8");
        } catch(Exception e) {
            e.printStackTrace();
        }

        str = str.replace("request=", "");

        return str;
    }

    public static Object parse(String str, Type className) {
        try {
            Gson gson = new Gson();
            return gson.fromJson(str, className);
        } catch (Exception e) {
            return null;
        }
    }

    public synchronized static List<Byte> frameToBytes(MessageFrame messageFrame, int loopIndex) {
        List<Byte> bytes = new ArrayList<>();

        if(messageFrame == null || loopIndex == -1){
            return bytes;
        }

        List<Component> components = messageFrame.getComponents();

        if(components == null) {
            return bytes;
        }

        for(Component component : components)  {
            String value;
            String type = component.getType().toLowerCase();
            int length = component.getLength();
            int valueSize = component.getValue().size();
            boolean existingMultiValue = component.isMultiValue();

            if (existingMultiValue) {
                value = component.getValue().get(((loopIndex) % valueSize));
            } else {
                value = component.getValue().get(0);
            }

            if (!value.equals("")) { // 예상 못하는 값이 아닐 경우
                if(type.equals("hex")) {
                    if (value.contains("0x")) { // 사용자가 0x를 붙였을 경우 0x를 없앰
                        value = value.substring(2);
                    }

                    for (int j = 0; j < length * 2; j += 2) { // ex)0000009e를 00, 00, 00, 9e로 바꿔서 바이트 배열에 값을 입력
                        bytes.add((byte) Integer.parseInt(value.substring(j, 2 + j), 16));
                    }
                }else if(type.equals("text")) {
                    for (char c : value.toCharArray()) {
                        if (c == '△') { // 빈 공간일 경우 ex)0x00을 text에서 표시 할 때
                            bytes.add((byte) 0x00);
                        } else { // 빈 공간 아닐 경우
                            bytes.add((byte) (int) c);
                        }
                    }
                }
            }else { // 예상 못하는 값일 경우 -0x01을 집어넣음(임의로 설정함)
                for (int j = 0; j < length; j++) {
                    bytes.add((byte) -0x01);
                }
            }
        }

        return bytes;
    }

    public static synchronized List<String> toStringList(List<Byte> bytes){
        List<String> strings = new ArrayList<>();
        for(Byte tempByte : bytes){
            strings.add(Integer.toHexString(tempByte));
        }
        return strings;
    }

    public static synchronized List<String> toASCIIList(List<Byte> bytes){
        List<String> ASCIIList = new ArrayList<>();
        for(Byte temp : bytes){
            ASCIIList.add(checkASCII(temp));
        }
        return ASCIIList;
    }

    public static synchronized String checkASCII(Byte tempByte){
        switch (tempByte){
            case 0x00:
                return "NUL";
            case 0x01:
                return "SOH";
            case 0x02:
                return "STX";
            case 0x03:
                return "ETX";
            case 0x04:
                return "EOT";
            case 0x05:
                return "ENQ";
            case 0x06:
                return "ACK";
            case 0x07:
                return "BEL";
            case 0x08:
                return "BS";
            case 0x09:
                return "HT";
            case 0x0A:
                return "LF";
            case 0x0B:
                return "VT";
            case 0x0C:
                return "FF";
            case 0x0D:
                return "CR";
            case 0x0E:
                return "SO";
            case 0x0F:
                return "SI";
            case 0x10:
                return "DLE";
            case 0x11:
                return "DC1";
            case 0x12:
                return "DC2";
            case 0x13:
                return "DC3";
            case 0x14:
                return "DC4";
            case 0x15:
                return "NAK";
            case 0x16:
                return "SYN";
            case 0x17:
                return "ETB";
            case 0x18:
                return "CAN";
            case 0x19:
                return "EM";
            case 0x1A:
                return "SUB";
            case 0x1B:
                return "ESC";
            case 0x1C:
                return "FS";
            case 0x1D:
                return "GS";
            case 0x1E:
                return "RS";
            case 0x1F:
                return "US";
            case 0x20:
                return "SP";
            case 0x7F:
                return "DEL";
            default:
                return ""+((char)(int)tempByte);
        }
    }
}
