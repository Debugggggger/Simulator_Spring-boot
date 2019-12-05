package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * 시나리오 DTO에서 메시지 프레임리스트에 들어갈 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:03
 */

@Getter
@Setter
@XmlRootElement(name = "ScenarioFrame")
@XmlAccessorType(XmlAccessType.FIELD)
public class ScenarioFrame {
    private String name;
    private String type;

    /**
     * DTO를 JSON String으로 반환
     *
     * @return {"name":"~",...}
     */
    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
