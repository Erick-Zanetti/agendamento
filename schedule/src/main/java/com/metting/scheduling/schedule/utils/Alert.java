package com.metting.scheduling.schedule.utils;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Alert {

    private String title;
    private String message;
    private AlertIcon icon;
}
