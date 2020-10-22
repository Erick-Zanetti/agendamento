package com.metting.scheduling.schedule.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;

@Getter
@Setter
public class ConclusaoAgendamentoDto {

    private String comentario;

    @NotNull(message = "Campo nota é obrigatório")
    private Integer nota;
}
