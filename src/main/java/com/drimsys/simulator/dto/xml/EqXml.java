package com.drimsys.simulator.dto.xml;

import com.drimsys.simulator.dto.*;
import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.HashMap;
import java.util.Map;

/**
 * XML 파일 저장을 위한 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 13:44
 */

@Getter
@Setter
@XmlRootElement(name = "Eq")
@XmlAccessorType(XmlAccessType.FIELD)
public class EqXml {
    @XmlElement(name = "EqSetting")
    private EqSetting eqSetting;
    @XmlElement(name = "Components")
    private Components components;
    @XmlElement(name = "MessageFrames")
    private MessageFrames messageFrames;
    @XmlElement(name = "Scenarios")
    private Scenarios scenarios;

    public EqXml() {}

    public EqXml(Eq eq) {
        this.eqSetting = eq.getEqSetting();
        this.components = new Components(eq.toListComponents());
        this.messageFrames = new MessageFrames(eq.toListMessageFrames());
        this.scenarios = new Scenarios(eq.toListScenarios());
    }

    /**
     * 컴포넌트 리스트를 map으로 반환
     *
     * @return Map<String, Component>
     */
    public Map<String, Component> toMapComponent() {
        if(this.components == null) return null;
        if(this.components.getComponents() == null) return null;

        Map<String, Component> map = new HashMap<>();
        for(Component idx: this.components.getComponents()) {
            if(idx == null) continue;
            map.put(idx.getName(), idx);
        }

        return map;
    }

    /**
     * 메시지 프레임 리스트를 map으로 반환
     *
     * @return Map<String, MessageFrame>
     */
    public Map<String, MessageFrame> toMapMessageFrames() {
        if(this.messageFrames == null) return null;
        if(this.messageFrames.getMessageFrames() == null) return null;

        Map<String, MessageFrame> map = new HashMap<>();
        for(MessageFrame idx: this.messageFrames.getMessageFrames()) {
            if(idx == null) continue;
            map.put(idx.getName(), idx);
        }

        return map;
    }

    /**
     * 시나리오 리스트를 map으로 반환
     *
     * @return Map<String, Scenario>
     */
    public Map<String, Scenario> toMapScenarios() {
        if(this.scenarios == null) return null;
        if(this.scenarios.getScenarios() == null) return null;

        Map<String, Scenario> map = new HashMap<>();
        for(Scenario idx: this.scenarios.getScenarios()) {
            if(idx == null) continue;
            map.put(idx.getName(), idx);
        }

        return map;
    }

    @Override
    public String toString() {
        Map<String, Object> map = new HashMap<>();
        map.put("eqSetting", this.eqSetting);
        map.put("components", this.components);
        map.put("messageFrames", this.messageFrames);
        map.put("scenarios", this.scenarios);
        return new Gson().toJson(map, map.getClass());
    }
}
