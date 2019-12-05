package com.drimsys.simulator.util;

import com.drimsys.simulator.dto.Component;
import com.drimsys.simulator.dto.MessageFrame;
import com.drimsys.simulator.dto.result.MessageFrameResult;

import java.util.List;

import static com.drimsys.simulator.util.Message.*;

public class Communication {

    public MessageFrameResult receive(SerialUtil serialUtil, MessageFrame messageFrame, long timeout, long waitTime, int loopIndex){
        long start = System.currentTimeMillis();
        long runtime;
        String messageFrameName = "";

        try {
            messageFrameName = messageFrame.getName().replaceAll(COMMAND_TYPE,"").replaceAll(RESPONSE_TYPE,"");
            List<Byte> savedBytes = Convert.frameToBytes(messageFrame, loopIndex);
            List<Byte> receivedBytes;
            boolean checkData;

            while (true) {
                if(serialUtil.isStop()){
                    return null;
                }
                runtime = System.currentTimeMillis() - start;
                if(runtime >= timeout){
                    return setExceptionResult(RESUlT_EXCEPTION, runtime, messageFrameName, RECV_MESSAGE);
                }
                else if(runtime >= waitTime){
                    timeout -= runtime;
                    break;
                }
            }

            while (true) {
                if(serialUtil.isStop()){
                    return null;
                }
                runtime = System.currentTimeMillis() - start;
                receivedBytes = serialUtil.getReadData();

                // TODO: print 안써도 될 수 있게 해결해야 함
                System.out.print("");

                if (runtime >= timeout) {
                    serialUtil.readDataClear();
                    break;
                } else if (receivedBytes.size() == savedBytes.size()) {
                    serialUtil.readDataClear();
                    break;
                }
            }
            checkData = compareBytes(savedBytes, receivedBytes);
            runtime = System.currentTimeMillis() - start;

            MessageFrameResult result = setResult(runtime, timeout, messageFrameName, receivedBytes, checkData, messageFrame);
            result.setCommunicationType(RECV_MESSAGE);

            return result;

        }catch (Exception e){
            if(serialUtil != null){
                serialUtil.readDataClear();
            }
            return setExceptionResult(RESUlT_EXCEPTION, System.currentTimeMillis() - start, messageFrameName, RECV_MESSAGE);
        }
    }

    public MessageFrameResult send(SerialUtil serialUtil, MessageFrame messageFrame, long timeout, long waitTime, int loopIndex){
        long start = System.currentTimeMillis();
        long runtime;
        String messageFrameName = "";
        try {
            messageFrameName = messageFrame.getName().replaceAll(COMMAND_TYPE,"").replaceAll(RESPONSE_TYPE,"");

            List<Byte> savedBytes = Convert.frameToBytes(messageFrame, loopIndex);
            List<Byte> writtenBytes;
            boolean checkData;

            if(!checkSendBytes(savedBytes)){
                return setExceptionResult(NULL_DATA_SEND,System.currentTimeMillis() - start, messageFrameName, SEND_MESSAGE);
            }

            while (true) {
                if(serialUtil.isStop()){
                    return null;
                }
                runtime = System.currentTimeMillis() - start;
                if(runtime >= timeout){
                    return setExceptionResult(RESUlT_EXCEPTION, runtime, messageFrameName, RECV_MESSAGE);
                }
                else if(runtime >= waitTime){
                    timeout -= runtime;
                    break;
                }
            }

            while (true) {
                if(serialUtil.isStop()){
                    return null;
                }
                runtime = System.currentTimeMillis() - start;
                writtenBytes = serialUtil.getWrittenData();
                if(runtime >= timeout){
                    break;
                } else if(serialUtil.writeData(savedBytes)){
                    serialUtil.WrittenDataClear();
                    break;
                }
            }
            checkData = compareBytes(savedBytes, writtenBytes);
            runtime = System.currentTimeMillis() - start;
            MessageFrameResult result = setResult(runtime, timeout, messageFrameName, writtenBytes, checkData, messageFrame);

            result.setCommunicationType(SEND_MESSAGE);

            return result;

        } catch (Exception e) {
            if(serialUtil != null){
                serialUtil.WrittenDataClear();
            }
            return setExceptionResult(RESUlT_EXCEPTION, System.currentTimeMillis() - start, messageFrameName, SEND_MESSAGE);
        }
    }

    private boolean compareBytes(List<Byte> savedBytes, List<Byte> receivedBytes){
        if(savedBytes == null || receivedBytes == null || savedBytes.size() != receivedBytes.size()) { return false; }

        // 저장된 프레임 값과 받은 프레임 값 비교(byte)
        int count = 0; // byte끼리 비교하고 맞으면 증가
        for(int i = 0; i<savedBytes.size(); i++) {
            if(savedBytes.get(i) == (byte)-0x01) { // 예상 불가능한 값일 경우 -0x01을 임의로 추가하게 됨
                count++;
            } else if(savedBytes.get(i).equals(receivedBytes.get(i))){ // 예상 가능한 값일 경우 비교
                count++;
            }
        }

        // 바이트 길이와 sameCount 값이 일치하면 true 리턴
        return (count == savedBytes.size());
    }

    private boolean checkSendBytes(List<Byte> savedBytes){
        if(savedBytes == null){ return false; }

        for(Byte temp : savedBytes){
            if(temp == (byte)-0x01){
                return false;
            }
        }
        return true;
    }

    private MessageFrameResult setResult(long runtime, long timeout, String messageFrameName, List<Byte> bytes, boolean checkData, MessageFrame messageframe){

        MessageFrameResult result = new MessageFrameResult();

        result.setRuntime(runtime);
        result.setFrameName(messageFrameName);

        result.setHexStrings(Convert.toStringList(bytes));
        result.setAscStrings(Convert.toASCIIList(bytes));
        
        for(Component component : messageframe.getComponents()) {
        	result.getComponentsLength().add(component.getLength());
        }
        
        if(runtime < timeout){
            if(checkData){
                result.setResultMessage(RESULT_OK);
            }else{
                result.setResultMessage(RESULT_NG);
            }
        }else{
            result.setResultMessage(RESULT_TRANSACTION);
        }
        return result;
    }

    public MessageFrameResult setExceptionResult(String errorMessage, long runtime, String messageFrameName, String communicationType){
        MessageFrameResult result = new MessageFrameResult();

        result.setRuntime(runtime);
        result.setResultMessage(errorMessage);
        result.setCommunicationType(communicationType);

        result.setFrameName(messageFrameName);

        return result;
    }
}

