package com.drimsys.simulator.dto.result;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StartEndMessage {
    private String port;
    private String resultDate;


    public StartEndMessage(){}

    public StartEndMessage(String port, String resultDate){
        this.resultDate = resultDate;
        this.port = port;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
