package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ScenarioSock{
    private String port;
    private String scenarioName;
    private int loop;
    String eqName;
    String path;

    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
