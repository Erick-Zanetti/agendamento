package com.metting.scheduling.schedule.utils;

import lombok.Getter;
import lombok.Setter;

public class AlertErrorException extends RuntimeException {

    @Getter
    @Setter
    public Alert data;

    public AlertErrorException(String title, String message) {
        super(message);
        this.data = new Alert(title, message, AlertIcon.ERROR);
    }
}
