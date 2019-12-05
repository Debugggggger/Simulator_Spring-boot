package com.drimsys.simulator.dto.result;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ScenarioResult {
    private String resultMessage;
    private String port;
    private String scenarioName;
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
