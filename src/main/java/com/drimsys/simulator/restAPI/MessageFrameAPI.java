package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.dto.MessageFrame;
import com.drimsys.simulator.model.XmlModel;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.File;
import com.drimsys.simulator.util.JSONUtil;
import com.google.gson.Gson;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;


import static com.drimsys.simulator.util.Message.*;

/**
 * 메시지 프레임 데이터를 처리하기 위한 REST 컨트롤러
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:07
 */

@RestController
@RequestMapping("/api/messageFrame/{eqName}")
public class MessageFrameAPI {
    private final XmlModel xmlModel = new XmlModel();

    @RequestMapping(method = RequestMethod.GET)
    public JSONResult messageFrameGET(@PathVariable String eqName) {
        Eq eq = xmlModel.unmarshalling(eqName);

        if(eq != null) {
            if(eq.getMessageFrames().size() != 0) {
                try {
                    Gson gson = new Gson();
                    String sMessageFrame = gson.toJson(eq.getMessageFrames());
                    sMessageFrame = sMessageFrame.replaceAll(COMMAND_TYPE, "").replaceAll(RESPONSE_TYPE, "");
                    
                    List<MessageFrame> result = new LinkedList<>();
                    
                    JSONObject obj = (JSONObject) new JSONParser().parse(sMessageFrame);
                    
                	Iterator<String> iter = obj.keySet().iterator();
                	while(iter.hasNext()) {
                		String key = iter.next();
                		JSONObject value = (JSONObject) obj.get(key);
                		
                		result.add((MessageFrame) Convert.parse(value.toString(), MessageFrame.class));
                	}
                    
                    return new JSONResult(200, RESULT_OK, result);
                } catch (Exception e) {
                	e.printStackTrace();
                    return new JSONResult(500, RESULT_NG, e.getMessage());
                }
            }
        }

        return new JSONResult(404, NOT_FOUND, null);
    }

    // TODO : POST, PUT 분리
    @RequestMapping(method = {RequestMethod.POST, RequestMethod.PUT})
    public JSONResult messageFramePOSTandPUT(@PathVariable String eqName,
                                             @RequestBody String request) {
        request = Convert.decodeURL(request);
        Eq eq = xmlModel.unmarshalling(eqName);

        if(eq == null) return new JSONResult(404, FILE_NOT_FOUND, null);

        MessageFrame messageFrame = (MessageFrame) Convert.parse(request, MessageFrame.class);

        if(messageFrame == null) {
            return new JSONResult(500, RESULT_NG, null);
        }

        if(eq.getMessageFrames() == null) eq.setMessageFrames(new HashMap<>());

        if(messageFrame.getType().toLowerCase().equals("command")) {
            messageFrame.setName(COMMAND_TYPE + messageFrame.getName());
            eq.getMessageFrames().put(messageFrame.getName(), messageFrame);
        } else {
            messageFrame.setName(RESPONSE_TYPE + messageFrame.getName());
            eq.getMessageFrames().put(messageFrame.getName(), messageFrame);
        }

        return JSONUtil.returnResult(xmlModel.marshalling(eqName, eq));
    }

    @RequestMapping(method = RequestMethod.DELETE)
    public JSONResult messageFrameDELETE(@PathVariable String eqName,
                                         @RequestBody String request) {
        request = Convert.decodeURL(request);
        Eq eq = xmlModel.unmarshalling(eqName);

        if(eq == null) new JSONResult(404, FILE_NOT_FOUND, null);

        if(eq.getMessageFrames() == null) {
            new JSONResult(404, NOT_FOUND, null);
        }

        JSONObject object =  (JSONObject) Convert.parse(request, JSONObject.class);

        if(object == null) return new JSONResult(500, RESULT_NG, null);

        String frameName = (String) object.get("name");
        String type = (String) object.get("type");

        if(type.toLowerCase().equals("command")) {
            frameName = COMMAND_TYPE + frameName;
        } else {
            frameName = RESPONSE_TYPE + frameName;
        }

        if(eq.getMessageFrames().remove(frameName) != null) {
            return JSONUtil.returnResult(xmlModel.marshalling(eqName, eq));
        } else {
            return new JSONResult(404, FILE_NOT_FOUND, null);
        }
    }
}
