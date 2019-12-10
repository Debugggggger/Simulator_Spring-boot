package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.dto.Scenario;
import com.drimsys.simulator.model.XmlModel;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.File;
import com.drimsys.simulator.util.JSONUtil;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;


import static com.drimsys.simulator.util.Message.*;

@RestController
@RequestMapping("/api/scenario/{eqName}")
public class ScenarioAPI{
    private final XmlModel xmlModel = new XmlModel();

    @RequestMapping(method = RequestMethod.GET)
    public JSONResult messageFrameGET(@PathVariable String eqName) {
        Eq eq = xmlModel.unmarshalling(eqName);

        if(eq != null) {
            if(eq.getScenarios() == null) return new JSONResult(404, NOT_FOUND, null);
            if(eq.getScenarios().size() != 0) {
                return new JSONResult(200, RESULT_OK, eq.toListScenarios());
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

        Scenario scenario = (Scenario) Convert.parse(request, Scenario.class);

        if(scenario == null) {
            return new JSONResult(500, RESULT_NG, null);
        }

        if(eq.getScenarios() == null) eq.setScenarios(new HashMap<>());

        Map<String, Scenario> scenarioMap = eq.getScenarios();
        scenarioMap.put(scenario.getName(), scenario);
        eq.setScenarios(scenarioMap);

        return JSONUtil.returnResult(xmlModel.marshalling(eqName, eq));
    }

    @RequestMapping(method = RequestMethod.DELETE)
    public JSONResult messageFrameDELETE(@PathVariable String eqName,
                                         @RequestBody String request) {
        request = Convert.decodeURL(request);
        Eq eq = xmlModel.unmarshalling(eqName);

        if(eq == null) new JSONResult(404, FILE_NOT_FOUND, null);

        if(eq.getScenarios() == null) {
            new JSONResult(404, NOT_FOUND, null);
        }

        if(eq.getScenarios().remove(request) != null) {
            return JSONUtil.returnResult(xmlModel.marshalling(eqName, eq));
        } else {
            return new JSONResult(404, FILE_NOT_FOUND, null);
        }
    }
}
