package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

/**
 * 컴포넌트 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 13:46
 */

@Getter
@Setter
@XmlRootElement(name = "Component")
@XmlAccessorType(XmlAccessType.FIELD)
public class Component {
	private String name;
	private String type;
	private List<String> value;
	private int length;
	private String description;
	private String svid;
	private boolean multiValue;

	public Component(){}

	public Component(String name, String type, List<String> value, int length, String description, String svid, boolean multiValue){
		this.name = name;
		this.type = type;
		this.value = value;
		this.length = length;
		this.description = description;
		this.svid = svid;
		this.multiValue = multiValue;
	}

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