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
 * 시나리오 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:02
 */

@Getter
@Setter
@XmlRootElement(name = "Scenario")
@XmlAccessorType(XmlAccessType.FIELD)
public class Scenario {
	private String name;
	private String side; //host인지, EQ인지 선택
	private String comPort;
	@XmlElement(name = "ScenarioFrame")
	private List<ScenarioFrame> messageFrames;
	private long[] timer; // [0]번째는 transaction timer
							// 이후의 타이머는 message[n-1],message[n]사이의 타이머
	private int transaction;

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