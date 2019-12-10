package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.EqSetting;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.model.XmlModel;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.JSONUtil;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedList;
import java.util.List;


import static com.drimsys.simulator.util.Message.*;

/**
 * 장비 설정 데이터를 처리하기 위한 REST 컨트롤러
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:06
 */

@RestController
@RequestMapping("/api/eqSetting")
public class EqSettingAPI {
    private final XmlModel xmlModel = new XmlModel();

    /**
     * 장비 추가
     *
     * @return 처리결과
     */
    @RequestMapping(method = RequestMethod.GET)
    public JSONResult eqSettingGET() {
        List<EqSetting> eqSettings = new LinkedList<>();
        List<String> files = xmlModel.getFileNames();

        for(String name : files) {
            eqSettings.add(xmlModel.unmarshalling(name).getEqSetting());
        }

        if(eqSettings.isEmpty()) {
            return new JSONResult(404, NOT_FOUND, null);
        }

        return new JSONResult(200, RESULT_OK, eqSettings);
    }

    /**
     *
     * @param eqName
     * @param request
     * @return
     */
    @RequestMapping(value = "/{eqName}",  method = RequestMethod.POST)
    public JSONResult eqSettingPOST(@PathVariable String eqName,
                                    @RequestBody String request) {
        request = Convert.decodeURL(request);

        Eq eq = new Eq();

        EqSetting eqSetting = (EqSetting) Convert.parse(request, EqSetting.class);

        if(eqSetting == null) {
            return new JSONResult(500, RESULT_NG, null);
        }

        if(!eqSetting.getTargetEq().equals("")) {
            eq = xmlModel.unmarshalling(eqSetting.getTargetEq());
        }

        eq.setEqSetting(eqSetting);

        return JSONUtil.returnResult(xmlModel.marshalling(eqSetting.getName(), eq));
    }

    @RequestMapping(value = "/{eqName}", method = RequestMethod.PUT)
    public JSONResult eqSettingPUT(@PathVariable String eqName,
                                   @RequestBody String request) {
        request = Convert.decodeURL(request);
        Eq eq = xmlModel.unmarshalling(eqName);

        if(eq == null) return new JSONResult(404, FILE_NOT_FOUND, null);

        EqSetting eqSetting = (EqSetting) Convert.parse(request, EqSetting.class);

        if(eqSetting == null) {
            return new JSONResult(500, RESULT_NG, null);
        }

        eq.setEqSetting(eqSetting);

        return JSONUtil.returnResult(xmlModel.marshalling(eqSetting.getName(), eq));
    }

    // TODO : 장비 세팅 삭제하면 파일 삭제 해야함
    @RequestMapping(value = "/{eqName}", method = RequestMethod.DELETE)
    public JSONResult eqSettingDELETE(@PathVariable String eqName,
                                      @RequestBody String request) {
        return JSONUtil.returnResult(xmlModel.remove(eqName));
    }
}
