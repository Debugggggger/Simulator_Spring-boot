package com.drimsys.simulator.dto.result;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TextResult {

    private long runtime;
    private String port;
    private String resultMessage;
    private String resultDate;


    public TextResult(){}

    public TextResult(long runtime, String resultMessage, String resultDate){
        this.runtime = runtime;
        this.resultMessage = resultMessage;
        this.resultDate = resultDate;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
