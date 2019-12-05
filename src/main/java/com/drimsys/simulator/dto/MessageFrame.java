package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

/**
 * 메시지 프레임 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:01
 */

@Getter
@Setter
@XmlRootElement(name = "MessageFrame")
@XmlAccessorType(XmlAccessType.FIELD)
public class MessageFrame{
	private String name;
	@XmlElement(name = "Component")
	private List<Component> components;
	private String type; //command인지, response인지 선택
	@XmlElement(name = "Checksum")
	private Checksum checksum;

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
