package com.drimsys.simulator.dto.xml;

import com.drimsys.simulator.dto.Component;
import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

/**
 * XML 형식으로 저장하기 위한 DTO
 *
 * @author Seo gyeongseok
 * @version 1.0
 * @since 2019-11-01 13:36
 **/

@Getter
@Setter
@XmlRootElement(name = "Components")
@XmlAccessorType(XmlAccessType.FIELD)
public class Components {
    @XmlElement(name = "Component")
    private List<Component> components;

    public Components() {}

    public Components(List<Component> components) {
        this.components = components;
    }

    /**
     * DTO를 JSON String으로 반환
     *
     * @return [{"name":"~",...},...]
     */
    @Override
    public String toString() {
        return new Gson().toJson(this.components, components.getClass());
    }
}
