package com.drimsys.simulator.dto.result;

import com.drimsys.simulator.dto.Checksum;
import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Setter
@Getter

public class MessageFrameResult {
    private List<String> hexStrings = new ArrayList<>();
    private List<String> ascStrings = new ArrayList<>();
    private List<Integer> componentsLength = new ArrayList<>();

    private String frameName;
    private String communicationType;

    private long runtime = 0;
    private String port;

    private String resultMessage;
    private Checksum checksum;
    private String resultDate;

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
