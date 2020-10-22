package com.metting.scheduling.schedule.repository;

import com.metting.scheduling.schedule.models.AgendamentoParticipante;
import com.metting.scheduling.schedule.models.Participante;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface AgendamentoParticipanteRepository extends JpaRepository<AgendamentoParticipante, Long> {

    @Query("select ap from AgendamentoParticipante ap " +
            " join ap.participante p on p.id = :participante " +
            " join ap.agendamento a on a.id = :agendamento ")
    public List<AgendamentoParticipante> buscarPorParticipanteAgendamento(
            @Param("agendamento") Long agendamentoId,
            @Param("participante") Long participanteId
    );

    @Query("select p from AgendamentoParticipante ap " +
            " join ap.agendamento a on a.id = :id " +
            " join ap.participante p ")
    public List<Participante> buscarParticipantes(@Param("id") Long agendamentoId);

    @Query(value = "delete from agendpart a where a.agendamentoid = :agendamentoId and a.participanteid = :participanteId", nativeQuery = true)
    public void removerParticipante(
            @Param("agendamentoId") Long agendamentoId,
            @Param("participanteId") Long participanteId
    );
}
