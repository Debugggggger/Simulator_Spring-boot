package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.model.XmlModel;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


import static com.drimsys.simulator.util.Message.*;

@RestController
@RequestMapping("/api/eq")
public class EqAPI{
    private final XmlModel xmlModel = new XmlModel();

    @RequestMapping(method = RequestMethod.GET)
    public JSONResult eqNameGET() {
        List<String> fileName = xmlModel.getFileNames();

        if(fileName.isEmpty()) {
            return new JSONResult(404, NOT_FOUND, null);
        }

        return new JSONResult(200, RESULT_OK, fileName);
    }
}
