package com.metting.scheduling.schedule.repository;

import com.metting.scheduling.schedule.models.Agendamento;
import com.metting.scheduling.schedule.models.Agendamento_;
import org.springframework.data.jpa.domain.Specification;

public class AgendamentoSpecs {
    public static Specification<Agendamento> getByUser(Long usuarioId) {
        return (root, query, criteriaBuilder) -> {
            return criteriaBuilder.equal(root.get(Agendamento_.usuarioId), usuarioId);
        };
    }
}