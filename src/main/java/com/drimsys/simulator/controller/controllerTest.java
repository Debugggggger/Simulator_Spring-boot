package com.drimsys.simulator.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * TODO : 삭제 해야 하는 컨트롤러
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:05
 */

@Controller
public class controllerTest {

    @RequestMapping(value = "/message.do", method = RequestMethod.GET)
    public String test1111() {
        return "message";
    }
    
    @RequestMapping(value = "/checksum.do", method = RequestMethod.GET)
    public String test() {
        return "checksumSource";
    }
    
    @RequestMapping(value = "/message2.do", method = RequestMethod.GET)
    public String tes1t() {
        return "message2";
    }
    
    @RequestMapping(value = "/scenario.do", method = RequestMethod.GET)
    public String tes1t1() {
        return "scenario";
    }
    
    @RequestMapping(value = "/test/heeyoung.do", method = RequestMethod.GET)
    public String testheeyoung() {
        return "test/heeyoung";
    }

    @RequestMapping(value = "/test/message.do", method = RequestMethod.GET)
    public String testmsg() {
        return "test/message";
    }

    @RequestMapping(value = "/test/dohoon.do", method = RequestMethod.GET)
    public String testmdass1g() {
        return "test/dohoon";
    }

    @RequestMapping(value = "/test/utf.do", method = RequestMethod.GET)
    public String dsadas() {
        return "test/uftTest";
    }

    @RequestMapping(value = "/test/sock.do", method = RequestMethod.GET)
    public String dsdwqdqqd() { return "/test/socket"; }

    @RequestMapping(value = "/test/scenarioTest.do", method = RequestMethod.GET)
    public String scenarioTest(){ return "scenarioTest"; }
}
