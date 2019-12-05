package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * 체크섬 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:29
 */

@Getter
@Setter
@XmlRootElement(name = "Checksum")
@XmlAccessorType(XmlAccessType.FIELD)
public class Checksum{
    private String from;
    private String to;
    private String method;
    private String result;

    /**
     * DTO를 JSON String으로 반환
     *
     * @return {"name":"~", ...}
     */
    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
