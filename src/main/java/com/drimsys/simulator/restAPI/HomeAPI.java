package com.drimsys.simulator.restAPI;

import com.drimsys.simulator.util.Convert;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

/**
 * Controller와 연결하기 위한 REST 컨트롤러
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:06
 */

@RestController
@RequestMapping("/")
public class HomeAPI {
    @RequestMapping(value = {"", "/setting/physical-interface"}, method = RequestMethod.GET)
    public ModelAndView homeGET() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("eqSetting");
        return modelAndView;
    }

    @RequestMapping(value = "/setting/message-frame", method = RequestMethod.GET)
    public ModelAndView messageModelingGET() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("message");
        return modelAndView;
    }

    @RequestMapping(value = "/setting/scenario", method = RequestMethod.GET)
    public ModelAndView scenarioGET() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("scenario");
        return modelAndView;
    }

    @RequestMapping(value = "/execution", method =  RequestMethod.GET)
    public ModelAndView executionGET() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("/execution");
        return modelAndView;
    }
    
    @RequestMapping(value = "/manual", method = RequestMethod.GET)
    public ModelAndView manualGET() {
    	ModelAndView modelAndView = new ModelAndView();
    	modelAndView.setViewName("/manual");
        return modelAndView;
    }
    
    @RequestMapping(value = "/ascii", method = RequestMethod.GET)
    public ModelAndView asciiGET() {
    	ModelAndView modelAndView = new ModelAndView();
    	modelAndView.setViewName("/ascii");
        return modelAndView;
    }
    
    @RequestMapping(value = "/test/heeyoung", method = RequestMethod.GET)
    public ModelAndView heeyoungGET() {
    	ModelAndView modelAndView = new ModelAndView();
    	modelAndView.setViewName("/test/heeyoung");
        return modelAndView;
    }
}
