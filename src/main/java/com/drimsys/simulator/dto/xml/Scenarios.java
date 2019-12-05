package com.drimsys.simulator.dto.xml;

import com.drimsys.simulator.dto.Scenario;
import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

/**
 * XML 형식으로 저장하기 위한 메소드
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 13:45
 */

@Getter
@Setter
@XmlRootElement(name = "Scenarios")
@XmlAccessorType(XmlAccessType.FIELD)
public class Scenarios {
    @XmlElement(name = "Scenario")
    private List<Scenario> scenarios;

    public Scenarios(){}

    public Scenarios(List<Scenario> scenarios) {
        this.scenarios = scenarios;
    }

    /**
     * DTO를 JSON String으로 반환
     *
     * @return [{"name":"~",...},...]
     */
    @Override
    public String toString() {
        return new Gson().toJson(this.scenarios, scenarios.getClass());
    }
}
