package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * 장비 설정 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 13:58
 */

@Getter
@Setter
@XmlRootElement(name = "EqSetting")
@XmlAccessorType(XmlAccessType.FIELD)
public class EqSetting {
	private String name;
	private String electricalInterface;
	private int buadRate;
	private int dataBits;
	private int stopBits;
	private int parity;
	private String flowControl;
	private String targetEq;

	/**
	 * DTO를 JSON String으로 반환
	 *
	 * @return {"name":"~", ... }
	 */
	@Override
	public String toString() {
		return new Gson().toJson(this, this.getClass());
	}
}
