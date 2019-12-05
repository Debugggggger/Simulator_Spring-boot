package com.drimsys.simulator.websocket;

import com.drimsys.simulator.dto.ExeParam;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.SerialUtil;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import static com.drimsys.simulator.restAPI.PortAPI.bindPortString;
import static com.drimsys.simulator.util.Convert.decodeURL;

@Component
public class Websocket extends TextWebSocketHandler{
    public static Map<String, Thread> portMap = new HashMap<>();

    public static synchronized void sendMessage(WebSocketSession session, String msg) {
        try {
            session.sendMessage(new TextMessage(msg));
            return;
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception{
        super.afterConnectionEstablished(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception{
        super.afterConnectionClosed(session, status);
        SerialUtil.disconnectAllPort();
    }

    @Override
    public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception{
        super.handleMessage(session, message);

        // TODO: null check
        String request = (String) message.getPayload();
        if(request.equals("CLOSE ALL PORT")){
            if(SerialUtil.disconnectAllPort()){
                sendMessage(session, new JSONResult(200, "Port", 1).toString());
            }else{
                sendMessage(session, new JSONResult(500, "Port", 0).toString());
            }
        }else {
            request = decodeURL(request);

            JSONArray jsonArray = (JSONArray) new JSONParser().parse(request);
            List<ExeParam> exeParams = new LinkedList<>();
            for (Object jsonObject : jsonArray) {
                ExeParam ExeParam = (com.drimsys.simulator.dto.ExeParam) Convert.parse(jsonObject.toString(), com.drimsys.simulator.dto.ExeParam.class);
                exeParams.add(ExeParam);
            }


            if (exeParams.size() != 0) {
                for (ExeParam param : exeParams) {
                    param.setPort(bindPortString.get(param.getPort()));
                    Thread thread = new ScenarioThread(session, param);
                    portMap.put(param.getPort(), thread);
                    thread.start();
                }
            }
        }
    }
}
