package com.metting.scheduling.schedule.utils;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ValidationException extends RuntimeException {

    private String mensagemErro;

    public ValidationException(String message) {
        super(message);
        this.mensagemErro = message;
    }
}
