package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class ExeParam {
    private String eqName;
    private String path;
    private String port;
    private String scenarioName;
    private String reservationStart;
    private String reservationEnd;
    private int loop;

    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
