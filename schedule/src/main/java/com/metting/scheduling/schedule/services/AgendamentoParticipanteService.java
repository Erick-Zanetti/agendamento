package com.metting.scheduling.schedule.services;

import com.metting.scheduling.schedule.enums.SituacaoAgendamento;
import com.metting.scheduling.schedule.models.Agendamento;
import com.metting.scheduling.schedule.models.AgendamentoParticipante;
import com.metting.scheduling.schedule.models.Participante;
import com.metting.scheduling.schedule.repository.AgendamentoParticipanteRepository;
import com.metting.scheduling.schedule.utils.ValidationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AgendamentoParticipanteService {

    @Autowired
    private ParticipanteService participanteService;

    @Autowired
    private AgendamentoParticipanteRepository repository;

    public Boolean adicionarParticipante(Agendamento agendamento, Long participanteId) {
        if(agendamento.getSituacao().equals(SituacaoAgendamento.CONCLUIDO)
                || agendamento.getSituacao().equals(SituacaoAgendamento.CONCLUIDO)) {
            throw new ValidationException("Não foi possivel adicionar o participante, porque o agendamento está " + agendamento.getSituacao().getDescricao() + ".");
        }

        Participante participante = participanteService.buscarPorId(participanteId);

        if(jaIncluso(agendamento.getId(), participanteId) != null) {
            throw new ValidationException("O participante " + participante.getNome() + " já está incluso!");
        }

        AgendamentoParticipante obj = new AgendamentoParticipante();

        obj.setAgendamento(agendamento);
        obj.setParticipante(participante);

        repository.save(obj);
        return true;
    }

    public Boolean removerParticipante(Agendamento agendamento, Long participanteId) {
        if(agendamento.getSituacao().equals(SituacaoAgendamento.CONCLUIDO)
                || agendamento.getSituacao().equals(SituacaoAgendamento.CONCLUIDO)) {
            throw new ValidationException("Não foi possivel remover o participante, porque o agendamento está " + agendamento.getSituacao().getDescricao() + ".");
        }

        Participante participante = participanteService.buscarPorId(participanteId);

        AgendamentoParticipante agendamentoParticipante = jaIncluso(participanteId, agendamento.getId());
        if(agendamentoParticipante == null) {
            throw new ValidationException("O participante " + participante.getNome() + " já foi removido!");
        }

        repository.delete(agendamentoParticipante);
        return true;
    }

    private AgendamentoParticipante jaIncluso(Long participanteId, Long agendamentoId) {
        List<AgendamentoParticipante> participantes = repository.buscarPorParticipanteAgendamento(agendamentoId, participanteId);
        if(participantes.isEmpty()) {
            return null;
        }
        return participantes.get(0);
    }
}
