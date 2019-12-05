package com.drimsys.simulator.dto.result;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Statistics {
    private long totalScenarioCount;
    private long successScenarioCount;
    private long failedScenarioCount;

    private long totalMessageCount;
    private long successMessageCount;
    private long failedMessageCount;

    private String port;
    private long runtime;
    private String scenarioName;
    private String resultDate;

    public void increase(String caseString){
        caseString = caseString.toLowerCase();
        switch (caseString){
            case "ts":
                totalScenarioCount++;
                break;
            case "ss":
                successScenarioCount++;
                break;
            case "fs":
                failedScenarioCount++;
                break;
            case "tm":
                totalMessageCount++;
                break;
            case "sm":
                successMessageCount++;
                break;
            case "fm":
                failedMessageCount++;
                break;
            default:
        }
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
