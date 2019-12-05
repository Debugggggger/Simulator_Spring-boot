package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.util.Checksum;
import com.drimsys.simulator.util.File;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static com.drimsys.simulator.util.Message.*;

@RestController
@RequestMapping("/api/eq")
public class EqAPI{
    @RequestMapping(method = RequestMethod.GET)
    public JSONResult eqNameGET(HttpServletRequest servletRequest) {
        List<String> fileName = File.getFiles(File.getXMLPath(servletRequest));

        if(fileName.isEmpty()) {
            return new JSONResult(404, NOT_FOUND, null);
        }

        return new JSONResult(200, RESULT_OK, fileName);
    }

    @RequestMapping(value = "test", method =  RequestMethod.GET)
    public String dsa(HttpServletRequest servletRequest) {
        Eq eq = File.load("testPump1123", File.getXMLPath(servletRequest));
        return Checksum.sum(eq.getMessageFrames().get(COMMAND_TYPE + "asdasdasd"), "stx", "etx");
    }


}
