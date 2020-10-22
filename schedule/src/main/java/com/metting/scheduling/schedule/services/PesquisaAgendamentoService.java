package com.metting.scheduling.schedule.services;

import com.metting.scheduling.schedule.dto.FiltroAgendamentoDto;
import com.metting.scheduling.schedule.enums.SituacaoAgendamento;
import com.metting.scheduling.schedule.models.Agendamento;
import com.metting.scheduling.schedule.utils.Response;
import com.ordnaelmedeiros.jpafluidselect.querybuilder.QueryBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Service
public class PesquisaAgendamentoService {

    @Autowired
    private EntityManager em;

    public Response<List<Agendamento>> pesquisar(FiltroAgendamentoDto filtro) {
        Boolean isValue = false, isInicio = false, isFim = false;
        return null;
    }

    private List<Agendamento> consultar(FiltroAgendamentoDto filtro, SituacaoAgendamento situacao) {
        Date inicio = filtro.getInicio() != null ? filtro.getInicio() : new Date();
        new QueryBuilder(em).select(Agendamento.class)
                .where()
                    .andGroup()
                        .field("usuarioId").eq(filtro.getUsuarioId())
                        .field("situacao").eq(situacao)
                        .field("titulo").ilike(filtro.getValue() != null ? filtro.getValue() : "")
                    .end()
                .getResultList();
        return null;
    }

}
