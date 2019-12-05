package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

/**
 * response DTO
 *
 * @author Gyeongseok Seo
 * @version 1.0
 * @since 2019-11-01 14:01
 */

@Getter
@Setter
public class JSONResult{
    private int code;
    private String message;
    private Object data;

    public JSONResult(){}

    public JSONResult(int code, String message, Object data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
