package com.drimsys.simulator.dto;

import com.drimsys.simulator.dto.xml.EqXml;
import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * 장비 정보 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 13:52
 */

@Getter
@Setter
public class Eq {
    private EqSetting eqSetting;
    private Map<String, Component> components;
    private Map<String, MessageFrame> messageFrames;
    private Map<String, Scenario> scenarios;

    public Eq(){}

    public Eq(EqXml eqXml) {
        this.eqSetting = eqXml.getEqSetting();
        this.components = eqXml.toMapComponent();
        this.messageFrames = eqXml.toMapMessageFrames();
        this.scenarios = eqXml.toMapScenarios();
    }

    /**
     * 컴포넌트를 LIST로 반환
     *
     * @return List component
     */
    public List<Component> toListComponents() {
        List<Component> list = new LinkedList<>();

        if(this.components == null) return null;
        if(this.components.isEmpty()) return null;

        for(Map.Entry<String, Component> entry : this.components.entrySet()) {
            list.add(entry.getValue());
        }

        return list;
    }

    /**
     * 메시지 프레임을 list로 반환
     *
     * @return list message frame
     */
    public List<MessageFrame> toListMessageFrames() {
        List<MessageFrame> list = new LinkedList<>();

        if(this.messageFrames == null) return null;
        if(this.messageFrames.isEmpty()) return null;

        for(Map.Entry<String, MessageFrame> entry : this.messageFrames.entrySet()) {
            list.add(entry.getValue());
        }

        return list;
    }

    /**
     * 시나리오를 list로 반환
     *
     * @return list scenario
     */
    public List<Scenario> toListScenarios() {
        List<Scenario> list = new LinkedList<>();

        if(this.scenarios == null) return null;
        if(this.scenarios.isEmpty()) return null;

        for(Map.Entry<String, Scenario> entry : this.scenarios.entrySet()) {
            list.add(entry.getValue());
        }

        return list;
    }

    /**
     * DTO를 JSON String으로 반환
     *
     * @return {"eqSetting": "~", "components":"~", "messageFrames":"~", "scenarios":"~"}
     */
    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
