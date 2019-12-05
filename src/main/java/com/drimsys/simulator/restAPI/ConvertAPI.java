package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.dto.Checksum;
import com.drimsys.simulator.dto.Component;
import com.drimsys.simulator.dto.JSONResult;
import com.drimsys.simulator.dto.MessageFrame;
import com.drimsys.simulator.util.Communication;
import com.drimsys.simulator.util.Convert;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

import static com.drimsys.simulator.util.Message.RESULT_NG;
import static com.drimsys.simulator.util.Message.RESULT_OK;

/**
 * 컴포넌트 데이터를 처리하기 위한 REST 컨트롤러
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:06
 */

@RestController
@RequestMapping("/api/convert")
public class ConvertAPI {
    /**
     * 바이트 리스트로 변경 추가 및 수정
     *
     * @param request:JSON 형식의 String
     * @return 처리결과
     */
    @RequestMapping(value = "/{loopIndex}", method = {RequestMethod.POST, RequestMethod.PUT})
    public JSONResult convertPOST(@PathVariable String loopIndex, @RequestBody String request,
                                  HttpServletRequest servletRequest) {
        try {
            request = Convert.decodeURL(request);
            int idx = Integer.parseInt(loopIndex);

            //eqName 필요 없음.
            MessageFrame requestMessageFrame = (MessageFrame) Convert.parse(request, MessageFrame.class);
            if (requestMessageFrame == null) return new JSONResult(404, RESULT_NG, null);

            Checksum checksum = requestMessageFrame.getChecksum();
            if (checksum == null) return new JSONResult(500, RESULT_NG, null);

            MessageFrame messageFrame = new MessageFrame();
            List<Component> components = new ArrayList<>();

            Integer.parseInt(checksum.getFrom());
            Integer.parseInt(checksum.getTo());
            for (int i = Integer.parseInt(checksum.getFrom()); i <= Integer.parseInt(checksum.getTo()); i++) {
                components.add(requestMessageFrame.getComponents().get(i));
            }
            messageFrame.setComponents(components);

            if (components == null) {
                return new JSONResult(500, RESULT_NG, null);
            }

            Communication communication = new Communication();
            return new JSONResult(200, RESULT_OK, Convert.toStringList(Convert.frameToBytes(messageFrame, idx)));

        }catch (Exception e){
            return new JSONResult(0,"Occured unknown error",null);
        }
    }
}
