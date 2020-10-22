package com.metting.scheduling.schedule.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.util.Date;

@Getter
@Setter
public class FiltroAgendamentoDto {

    private Date inicio;
    private Date fim;
    private String value;

    @NotNull(message = "Código do usuário é obrigatório")
    private Long usuarioId;
    private Integer pagina;
    private Integer itens = 20;
}
