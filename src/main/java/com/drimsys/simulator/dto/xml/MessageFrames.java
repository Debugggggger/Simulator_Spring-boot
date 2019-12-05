package com.drimsys.simulator.dto.xml;

import com.drimsys.simulator.dto.MessageFrame;
import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * XML 형식으로 저장하기 위한 DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 13:45
 */

@Getter
@Setter
@XmlRootElement(name = "MessageFrames")
@XmlAccessorType(XmlAccessType.FIELD)
public class MessageFrames {
    @XmlElement(name = "MessageFrame")
    private List<MessageFrame> messageFrames;

    public MessageFrames() {}

    public MessageFrames(List<MessageFrame> messageFrames) {
        this.messageFrames = messageFrames;
    }

    public Map<String, MessageFrame> toMap() {
        Map<String, MessageFrame> map = new HashMap<>();
        for(MessageFrame messageFrame : this.messageFrames) {
            if(messageFrame==null) continue;
            map.put(messageFrame.getName(), messageFrame);
        }
        return map;
    }

    /**
     * DTO를 JSON String으로 반환
     *
     * @return [{"name":"~",...},...]
     */
    @Override
    public String toString() {
        return new Gson().toJson(this.messageFrames, messageFrames.getClass());
    }
}
