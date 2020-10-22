package com.metting.scheduling.schedule.dto;

import com.metting.scheduling.schedule.models.Agendamento;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class PesquisaAgendamentoResult {

    private List<Agendamento> agendados;
    private List<Agendamento> outros;
}
