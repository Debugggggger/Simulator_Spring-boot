package com.drimsys.simulator.dto;

import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Configuration{
    private int tomcatSock;
    private int appSock;

    public Configuration(){}

    public Configuration(int tomcatSock, int appSock) {
        this.tomcatSock = tomcatSock;
        this.appSock = appSock;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this, this.getClass());
    }
}
