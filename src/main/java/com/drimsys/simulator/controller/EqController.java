package com.drimsys.simulator.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class EqController{
    @RequestMapping(value = {"/index.do", "/setting.do"}, method = RequestMethod.GET)
    public String homeGET() {
        return "eqSetting";
    }

    @RequestMapping(value = "/execution/execution.do", method = RequestMethod.GET)
    public String executionGET() {
        return "execution";
    }

    @RequestMapping(value = "/modeling/message.do", method = RequestMethod.GET)
    public String messageGET() {
        return "message";
    }

    @RequestMapping(value = "/modeling/test.do", method = RequestMethod.GET)
    public String test1() {
        return "/test/message";
    }

    @RequestMapping(value = "/modeling/oldMessage.do", method = RequestMethod.GET)
    public String oldMessageGET() {
        return "message";
    }

    @RequestMapping(value = "/modeling/scenario.do", method = RequestMethod.GET)
    public String scenarioGET() {
        return "scenario";
    }
    
    @RequestMapping(value = "/execution/rowData.do", method = RequestMethod.GET)
    public String rowdataGET() {
        return "rowData";
    }
}
