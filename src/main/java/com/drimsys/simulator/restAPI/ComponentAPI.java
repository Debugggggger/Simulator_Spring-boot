package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Component;
import com.drimsys.simulator.dto.Eq;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.File;
import com.drimsys.simulator.util.JSONUtil;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;

import static com.drimsys.simulator.util.Message.*;

/**
 * 컴포넌트 데이터를 처리하기 위한 REST 컨트롤러
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:06
 */

@RestController
@RequestMapping("/api/component/{eqName}")
public class ComponentAPI {
    /**
     * 컴포넌트들 불러오기
     *
     * @param eqName : 장비 이름
     * @return 처리 결과
     */
    @RequestMapping(method = RequestMethod.GET)
    public JSONResult componentGET(@PathVariable String eqName,
                                   HttpServletRequest servletRequest) {
        Eq eq = File.load(eqName, File.getXMLPath(servletRequest));

        if(eq == null) return new JSONResult(404, FILE_NOT_FOUND, null);

        if(eq.getComponents() != null) {
            if(eq.getComponents().size() != 0) {
                return new JSONResult(200, "OK", eq.toListComponents());
            }
        }

        return new JSONResult(404, "Bad", null);
    }

    /**
     * 컴포넌트 추가 및 수정
     *
     * @param eqName:장비이름
     * @param request:JSON 형식의 String
     * @return 처리결과
     */
    @RequestMapping(method = {RequestMethod.POST, RequestMethod.PUT})
    public JSONResult componentPOST(@PathVariable String eqName,
                                    @RequestBody String request,
                                    HttpServletRequest servletRequest) {
        request = Convert.decodeURL(request);
        Eq eq = File.load(eqName, File.getXMLPath(servletRequest));

        if(eq == null) new JSONResult(404, FILE_NOT_FOUND, null);

        Component component = (Component) Convert.parse(request, Component.class);

        if(component == null) {
            return new JSONResult(500, RESULT_NG, null);
        }

        if(eq.getComponents() == null) eq.setComponents(new HashMap<>());
        eq.getComponents().put(component.getName(), component);

        return JSONUtil.returnResult(File.save(eqName, eq, File.getXMLPath(servletRequest)));
    }

    /**
     * 컴포넌트 삭제
     *
     * @param eqName:장비이름
     * @param request:JSON 형식의 String
     * @return 처리 결과
     */
    @RequestMapping(method = RequestMethod.DELETE)
    public JSONResult componentDELETE(@PathVariable String eqName,
                                      @RequestBody String request,
                                      HttpServletRequest servletRequest) {
        request = Convert.decodeURL(request).replaceAll("\"", "");
        Eq eq = File.load(eqName, File.getXMLPath(servletRequest));

        if(eq == null) new JSONResult(404, FILE_NOT_FOUND, null);

        if(eq.getComponents() == null) {
            return new JSONResult(404, NOT_FOUND, null);
        }

        eq.getComponents().remove(request);

        return JSONUtil.returnResult(File.save(eqName, eq, File.getXMLPath(servletRequest)));
    }
}
