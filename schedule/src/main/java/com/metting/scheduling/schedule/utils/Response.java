package com.metting.scheduling.schedule.utils;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Response<T> {

    private T data;
    private String message;
    private ResponseType tipo;
    private Boolean hasError = false;
    private Alert alert;

    public Response() {

    }
    public Response(T obj) {
        this.data = obj;
        this.tipo = ResponseType.SUCCESS;
    }

    public Response(String message, ResponseType type) {
        this.message = message;
        this.tipo = type;
        this.hasError = true;
    }
}
