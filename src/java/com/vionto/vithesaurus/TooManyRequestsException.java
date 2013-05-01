package com.vionto.vithesaurus;

public class TooManyRequestsException extends RuntimeException {

    private String ipAddress;

    public TooManyRequestsException(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getIpAddress() {
        return ipAddress;
    }
}
