package com.drimsys.simulator.websocket;

import com.drimsys.simulator.dto.*;
import com.drimsys.simulator.dto.result.*;
import com.drimsys.simulator.model.XmlModel;
import com.drimsys.simulator.util.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.socket.WebSocketSession;

import java.util.List;

import static com.drimsys.simulator.restAPI.PortAPI.bindPortString;
import static com.drimsys.simulator.util.Message.*;

public class ScenarioThread extends Thread{
    private WebSocketSession session;
    private ExeParam exeParam;
    @Setter private boolean stop;
    @Setter @Getter private Eq eq;
    private Statistics statistics = new Statistics();
    private SerialUtil serialUtil = null;

    public ScenarioThread(WebSocketSession session, ExeParam exeParam) {
        this.session = session;
        this.exeParam = exeParam;
        eq = new XmlModel().unmarshalling(exeParam.getEqName());
    }

    @Override
    public void run() {
        //예약
        try {
            Thread.sleep(checkReservation(exeParam.getReservationStart()));
        }catch (Exception e){
            e.printStackTrace();
        }

        //기본 셋팅
        long start = System.currentTimeMillis();
        Scenario scenario = null;
        EqSetting eqSetting = eq.getEqSetting();
        List<MessageFrame> messageFrames = null;
        MessageFrameResult messageFrameResult;
        if(eq.getScenarios() != null){
            scenario = eq.getScenarios().get(exeParam.getScenarioName());
            if(scenario == null){
                sendErrorMessage(404, "Scenario(" + exeParam.getScenarioName() + ") " + NOT_FOUND, start);
                sendEndMessage();

                return;
            }
        }else{
            sendErrorMessage(404, "Scenarios " + NOT_FOUND, start);
            sendEndMessage();

            return;
        }

        if(eqSetting == null) {
            sendErrorMessage(404, "EqSetting " + NOT_FOUND, start);
            sendEndMessage();

            return;
        }

        messageFrames = Convert.scenarioToMessageFrames(eq, scenario);
        if(messageFrames == null) {
            sendErrorMessage(404, "Messages " + NOT_FOUND, start);
            sendEndMessage();

            return;
        }

        serialUtil = SerialUtil.getSerialPort(exeParam.getPort(), eqSetting);
        if(serialUtil == null){
            sendErrorMessage(500, bindPortString.get(exeParam.getPort()) + " in use", start);
            sendEndMessage();

            return;
        }

        Communication communication = new Communication();
        statistics.setPort(bindPortString.get(exeParam.getPort()));
        int loop = 0;
        long[] timer = scenario.getTimer();
        start = System.currentTimeMillis();

        //통신 준비
        try {
            //종료 예약시간 확인
            if(checkReservationEnd(exeParam.getReservationEnd())){
                sendEndMessage();
                return;
            }

            //통신 셋팅
            ScenarioResult scenarioResult = new ScenarioResult();
            scenarioResult.setPort(bindPortString.get(exeParam.getPort()));
            scenarioResult.setScenarioName(exeParam.getScenarioName());
            statistics.setScenarioName(exeParam.getScenarioName());
            sendStartMessage();

            //통신 시작
            while (true) {
                long transaction = timer[0];
                int succesCount = 0;
                statistics.increase("ts");
                //메세지 프레임 전송
                for (int i = 0; i < messageFrames.size(); i++) {
                    String frameType = messageFrames.get(i).getType().toLowerCase();

                    if ((frameType.equals("command") && scenario.getSide().toLowerCase().equals("client"))
                            || (frameType.equals("response") && scenario.getSide().toLowerCase().equals("eq"))) {
                        messageFrameResult = communication.send(serialUtil, messageFrames.get(i), transaction, timer[i + 1], loop);
                    } else {
                        messageFrameResult = communication.receive(serialUtil, messageFrames.get(i), transaction, timer[i + 1], loop);
                    }

                    if(messageFrameResult == null || checkReservationEnd(exeParam.getReservationEnd())){
                        sendEndMessage();
                        return;
                    }

                    //메세지 프레임 결과값 전송
                    statistics.increase("tm");
                    messageFrameResult.setPort(bindPortString.get(exeParam.getPort()));
                    messageFrameResult.setChecksum(messageFrames.get(i).getChecksum());
                    messageFrameResult.setResultDate(DateUtil.getCurrentDate());
                    sendFrameMessage(messageFrameResult);

                    //강제 중지 || 종료시간 확인
                    if(checkStop(start) || checkReservationEnd(exeParam.getReservationEnd())){
                        sendEndMessage();
                        return;
                    }

                    //메세지 프레임 통계값 전송
                    if (!messageFrameResult.getResultMessage().equals(RESULT_OK)) {
                        statistics.increase("fm");
                        sendStatisticsMessage(start);
                        break;
                    } else {
                        transaction -= messageFrameResult.getRuntime();
                        succesCount++;
                        statistics.increase("sm");
                        sendStatisticsMessage(start);
                    }
                }

                //시나리오 결과 및 통계값 전송
                long scenarioWaitStart = System.currentTimeMillis();
                sendScenarioMessage(succesCount == messageFrames.size(), scenarioResult, start, scenarioWaitStart, transaction, timer[messageFrames.size() + 1]);
                sendStatisticsMessage(start);

                //반복 횟수 및 종료시간 확인
                if (checkLoop(++loop) || checkReservationEnd(exeParam.getReservationEnd())) {
                    sendEndMessage();
                    return;
                }
            }
        } catch (Exception e) {
            sendErrorMessage(500, RESUlT_EXCEPTION, start);
            sendStatisticsMessage(start);
        }
    }
    private boolean checkLoop(int loop){
        if(loop == exeParam.getLoop()){
            serialUtil.disconnect();
            return true;
        }
        return false;
    }

    private void sendErrorMessage(int code, String resultMessage, long start){
        TextResult textResult = getTextResult(resultMessage, System.currentTimeMillis() - start);

        Websocket.sendMessage(session,
                new JSONResult(code, "Exception", textResult.toString()).toString());
    }

    private void sendStatisticsMessage(long start){
        statistics.setResultDate(DateUtil.getCurrentDate());
        statistics.setRuntime(System.currentTimeMillis() - start);
        Websocket.sendMessage(session,
                new JSONResult(200,"Statistics",statistics.toString()).toString());
    }

    private void sendFrameMessage(MessageFrameResult messageFrameResult){
        if(messageFrameResult.getResultMessage().equals(RESULT_OK)){
            Websocket.sendMessage(session,
                    new JSONResult(200,"MessageFrame", messageFrameResult.toString()).toString());
        }else{
            Websocket.sendMessage(session,
                    new JSONResult(500,"MessageFrame", messageFrameResult.toString()).toString());
        }
    }

    private void sendScenarioMessage(boolean successMessages, ScenarioResult scenarioResult, long communicationStart, long scenarioWaitStart, long transaction, long wait){
        long runtime = 0;
        if(successMessages) {
            while (true) {
                if (checkStop(communicationStart)) {
                    return;
                }
                runtime = System.currentTimeMillis() - scenarioWaitStart;
                if (runtime >= transaction) {
                    scenarioResult.setResultDate(DateUtil.getCurrentDate());
                    scenarioResult.setResultMessage(RESULT_TRANSACTION);
                    statistics.increase("fs");
                    //실패
                    Websocket.sendMessage(session,
                            new JSONResult(500, "Scenario", scenarioResult.toString()).toString());
                    break;
                } else if (runtime >= wait) {
                    scenarioResult.setResultDate(DateUtil.getCurrentDate());
                    scenarioResult.setResultMessage(RESULT_OK);
                    statistics.increase("ss");
                    //성공
                    Websocket.sendMessage(session,
                            new JSONResult(200, "Scenario", scenarioResult.toString()).toString());
                    break;
                }
            }
        }else{
            scenarioResult.setResultDate(DateUtil.getCurrentDate());
            scenarioResult.setResultMessage("Scenario Failed");
            statistics.increase("fs");
            Websocket.sendMessage(session,
                    new JSONResult(500, "Scenario", scenarioResult.toString()).toString());
        }
    }

    private void sendStartMessage(){
        StartEndMessage startMessage = getStartEndMessage();

        Websocket.sendMessage(session,
                new JSONResult(200, "Start", startMessage.toString()).toString());
    }

    private void sendEndMessage(){
        StartEndMessage endMessage = getStartEndMessage();

        Websocket.sendMessage(session,
                new JSONResult(200, "End", endMessage.toString()).toString());
    }

    private boolean checkStop(long start){
        if(stop){
            sendStatisticsMessage(start);
            return true;
        }
        return false;
    }

    private TextResult getTextResult(String resultMessage, long runtime){
        return new TextResult(runtime, resultMessage, DateUtil.getCurrentDate());
    }

    private StartEndMessage getStartEndMessage(){
        return new StartEndMessage(bindPortString.get(exeParam.getPort()), DateUtil.getCurrentDate());
    }

    private long checkReservation(String date) {
        if (!date.equals("0")) {
            long time = DateUtil.dateToLong(date) - System.currentTimeMillis();
            if(time >= 0){
                return time;
            }
        }

        return 0;
    }

    private boolean checkReservationEnd(String date){
        if(!date.equals("0")){
            if(System.currentTimeMillis() - DateUtil.dateToLong(date) >= 0) {
                serialUtil.disconnect();
                return true;
            }
        }

        return false;
    }
}
