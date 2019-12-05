package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.util.SerialUtil;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import static com.drimsys.simulator.util.Message.NOT_FOUND;
import static com.drimsys.simulator.util.Message.RESULT_OK;

@RestController
@RequestMapping("/api/port")
public class PortAPI {
    public static Map<String, String> bindPortString = new HashMap<>();

    private List<String> bindPort(List<String> ports) {
        bindPortString = new HashMap<>();
        List<String> result = new LinkedList<>();

        int i = 1;
        String name = "Port";
        for(String idx : ports) {
            if(idx.contains("COM")) {
                bindPortString.put(idx, idx);
                result.add(idx);
            } else {
                bindPortString.put(name+i, idx);
                bindPortString.put(idx,name+i);
                result.add(name+i);
                i++;
            }
        }

        return result;
    }

    @RequestMapping(method = RequestMethod.POST)
    public JSONResult portListGET() {
        List<String> ports = SerialUtil.listPorts();

        if(ports.isEmpty()) {
            return new JSONResult(404, NOT_FOUND, null);
        }

        return new JSONResult(200, RESULT_OK, bindPort(ports));
    }

    @RequestMapping(value = "/all", method = RequestMethod.POST)
    public JSONResult allPortListGET() {
        List<String> ports = SerialUtil.getAllPorts();
        if(ports.isEmpty()) {
            return new JSONResult(404, NOT_FOUND, null);
        }

        return new JSONResult(200, RESULT_OK, bindPort(ports));
    }
}

