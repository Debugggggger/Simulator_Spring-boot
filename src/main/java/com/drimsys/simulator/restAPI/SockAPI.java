package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.model.XmlModel;
import com.drimsys.simulator.util.Convert;
import com.drimsys.simulator.util.File;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;



@RestController
@RequestMapping("/api/sock")
public class SockAPI{
    private final XmlModel xmlModel = new XmlModel();

    @RequestMapping(method = RequestMethod.GET)
    public ModelAndView dsadasd() {
        
        ModelAndView mov = new ModelAndView();
        mov.setViewName("/test/sock.do");
        return mov;
    }

    @RequestMapping(value = "/path", method = RequestMethod.GET)
    public String pathGET() {
        return Convert.encodeURL(xmlModel.getXML_PATH());
    }
}
