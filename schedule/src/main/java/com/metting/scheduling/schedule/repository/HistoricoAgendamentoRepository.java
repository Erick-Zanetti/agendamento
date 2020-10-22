package com.metting.scheduling.schedule.repository;

import com.metting.scheduling.schedule.models.HistoricoAgendamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface HistoricoAgendamentoRepository extends JpaRepository<HistoricoAgendamento, Long> {

    @Query("select a from HistoricoAgendamento a " +
            " join a.novo n on n.id = :id ")
    public List<HistoricoAgendamento> buscarReagendamentos(@Param("id") Long id);
}
