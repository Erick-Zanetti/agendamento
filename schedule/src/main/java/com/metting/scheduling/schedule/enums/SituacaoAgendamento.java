package com.metting.scheduling.schedule.enums;

import lombok.Getter;
import lombok.Setter;

public enum SituacaoAgendamento {

    AGENDADO("Agendado"),
    INICIADO("Iniciado"),
    CANCELADO("cancelado"),
    CONCLUIDO("concluido"),
    REAGENDADO("Reagendado");

    @Getter
    @Setter
    private String descricao;

    SituacaoAgendamento(String descricao) {
        this.descricao = descricao;
    }
}
