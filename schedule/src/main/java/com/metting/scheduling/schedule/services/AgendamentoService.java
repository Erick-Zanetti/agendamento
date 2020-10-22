package com.metting.scheduling.schedule.services;

import com.metting.scheduling.schedule.dto.ConclusaoAgendamentoDto;
import com.metting.scheduling.schedule.dto.ReagendamentoDto;
import com.metting.scheduling.schedule.enums.SituacaoAgendamento;
import com.metting.scheduling.schedule.models.*;
import com.metting.scheduling.schedule.repository.AgendamentoParticipanteRepository;
import com.metting.scheduling.schedule.repository.AgendamentoRepository;
import com.metting.scheduling.schedule.repository.AgendamentoSpecs;
import com.metting.scheduling.schedule.repository.HistoricoAgendamentoRepository;
import com.metting.scheduling.schedule.utils.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class AgendamentoService {

    @Autowired
    private AgendamentoRepository repository;

    @Autowired
    private HistoricoAgendamentoRepository historicoAgendamentoRepository;

    @Autowired
    private AgendamentoParticipanteRepository agendamentoParticipanteRepository;

    @Autowired
    private UsuarioService usuarioService;

    @Autowired
    private ParticipanteService participanteService;

    @Autowired
    private AgendamentoParticipanteService agendamentoParticipanteService;

    public Agendamento agendar(Agendamento agendamento) {
        if(agendamento.getDataHora().before(new Date())) {
            throw new AlertErrorException(
                    "Data do agendamento inválida!",
                    "A data e horário do agendamento deve ser superior a data e horário atual."
            );
        }

        if(agendamento.getId() != null) {
            throw new ValidationException("Não é permitido a alteração do registro de código " + agendamento.getId());
        }

        agendamento.setSituacao(SituacaoAgendamento.AGENDADO);
        return repository.save(agendamento);
    }

    public Response<?> finalizar(ConclusaoAgendamentoDto dto, Long agendamentoId) {
        Agendamento obj = buscarPorId(agendamentoId);

        if(!obj.getSituacao().equals(SituacaoAgendamento.INICIADO)) {
            throw new ValidationException("O agendamento não pode ser finalizado porque está " + obj.getSituacao().getDescricao());
        }

        obj.setSituacao(SituacaoAgendamento.CONCLUIDO);
        obj.setFeedback(dto.getComentario());
        obj.setNota(dto.getNota());
        obj.setDataHoraFim(new Date());
        obj.setRealizado(true);

        repository.save(obj);

        Response<Alert> response = new Response<>();
        response.setData(new Alert("Agendadamento finalizado!", "O agendamento foi concluído com sucesso", AlertIcon.SUCCESS));
        return response;
    }

    public Response<?> iniciar(Long agendamentoId) {
        Agendamento obj = buscarPorId(agendamentoId);

        if(!obj.getSituacao().equals(SituacaoAgendamento.AGENDADO)) {
            throw new ValidationException("O agendamento não pode ser iniciado porque está " + obj.getSituacao().getDescricao());
        }

        obj.setSituacao(SituacaoAgendamento.INICIADO);
        obj.setDataHoraInicio(new Date());

        repository.save(obj);

        Response<?> response = new Response<>(obj.getDataHoraInicio());
        response.setMessage("Agendamento iniciado com sucesso");
        response.setTipo(ResponseType.MESSAGE_SUCCESS);
        return response;
    }

    @Transactional(Transactional.TxType.REQUIRES_NEW)
    public Response<?> remover(Long agendamentoId) {
        Agendamento agendamento = buscarPorId(agendamentoId);

        if(!agendamento.getSituacao().equals(SituacaoAgendamento.AGENDADO)) {
            throw new ValidationException("O agendamento não pode ser excluído porque está " + agendamento.getSituacao().getDescricao());
        }

        List<HistoricoAgendamento> agendamentos = historicoAgendamentoRepository.buscarReagendamentos(agendamentoId);

        historicoAgendamentoRepository.deleteAll(agendamentos);

        repository.deleteById(agendamentoId);
        Response<?> response = new Response<>();
        response.setTipo(ResponseType.MESSAGE_SUCCESS);
        response.setMessage("Agendamento excluído com sucesso!");
        return response;
    }

    public Agendamento buscarPorId(Long agendamentoId) {
        Optional<Agendamento> agendamento = repository.findById(agendamentoId);

        if(!agendamento.isPresent()) {
            throw new ValidationException("Agendamento com o código " + agendamentoId + " não encontrado");
        }

        return agendamento.get();
    }

    public Response<?> adicionarParticipantes(List<Long> participantesId, Long agendamentoId) {
        Agendamento agendamento = buscarPorId(agendamentoId);

        if(!agendamento.getSituacao().equals(SituacaoAgendamento.AGENDADO)
                && !agendamento.getSituacao().equals(SituacaoAgendamento.INICIADO)) {
            throw new ValidationException("Não é permitido adicionar participantes quando o agendamento está " + agendamento.getSituacao().getDescricao());
        }

        List<AgendamentoParticipante> participantes = new ArrayList<>();

        for (Long participanteId : participantesId) {
            Participante participante = participanteService.buscarPorId(participanteId);

            if(!participante.getAtivo()) {
                throw new ValidationException("O participante " + participante.getNome() + " foi inativado, favor remover e salvar novamente!");
            }

            if(participante.getUsuario() != null) {
                if(!participante.getUsuario().getAtivo()) {
                    throw new ValidationException("O usuario " + participante.getUsuario().getNome() + " foi inativado, favor remover e salvar novamente!");
                }
            }

            if(participanteIsPresent(agendamentoId, participanteId)) {
                throw new ValidationException("O participante " + participante.getNome() + " já está participando, remova o participante e tente novamente.");
            }

            participantes.add(new AgendamentoParticipante().builder()
                        .agendamento(agendamento)
                        .participante(participante)
                    .build());
        }

        agendamentoParticipanteRepository.saveAll(participantes);

        Response<?> response = new Response<>();
        response.setMessage("Participantes incluidos com sucesso!");
        response.setTipo(ResponseType.MESSAGE_SUCCESS);
        return response;
    }

    private Boolean participanteIsPresent(Long agendamentoId, Long participanteId) {
        return agendamentoParticipanteRepository.buscarPorParticipanteAgendamento(agendamentoId, participanteId).size() > 0;
    }

    @Transactional(Transactional.TxType.REQUIRES_NEW)
    public Response<?> reagendamento(ReagendamentoDto reagendamentoDto, Long agendamentoId) {
        Agendamento atual = buscarPorId(agendamentoId);

        if(!atual.getSituacao().equals(SituacaoAgendamento.CONCLUIDO)) {
            throw new ValidationException("O agendamento só pode ser reagendado quando estiver concluído.");
        }

        Usuario usuario = usuarioService.buscarPorId(reagendamentoDto.getUsuarioId());

        Agendamento novo = new Agendamento().builder()
                .titulo(reagendamentoDto.getTitulo())
                .observacao(reagendamentoDto.getObservacao())
                .dataHora(reagendamentoDto.getDataHora())
                .usuario(usuario)
                .build();

        novo = agendar(novo);

        HistoricoAgendamento historicoAgendamento = new HistoricoAgendamento().builder()
                .antigo(atual)
                .novo(novo)
                .build();

        historicoAgendamentoRepository.save(historicoAgendamento);

        atual.setSituacao(SituacaoAgendamento.REAGENDADO);
        repository.save(atual);

        Response<Agendamento> response = new Response<>(novo);
        response.setMessage("Reagendamento efetuado com sucesso!");
        response.setTipo(ResponseType.MESSAGE_SUCCESS);
        return response;
    }

    public List<Participante> buscarParticipantes(Long agendamentoId) {
        return agendamentoParticipanteRepository.buscarParticipantes(agendamentoId);
    }

    public List<Agendamento> porUsuario(Long usuarioId) {
        return repository.findAll(AgendamentoSpecs.getByUser(usuarioId));
    }

    public Boolean adicionarparticipante(Long agendamentoId, Long participanteId) {
        Agendamento agendamento = buscarPorId(agendamentoId);
        return agendamentoParticipanteService.adicionarParticipante(agendamento, participanteId);
    }

    public Boolean removerParticipante(Long agendamentoId, Long participanteId) {
        Agendamento agendamento = buscarPorId(agendamentoId);
        return  agendamentoParticipanteService.removerParticipante(agendamento, participanteId);
    }

    public Agendamento alterar(Agendamento agendamento) {
        // busca o agendamento do banco
        Agendamento banco = buscarPorId(agendamento.getId());

        // Valida a data
        if(agendamento.getDataHora().before(new Date())) {
            throw new ValidationException("Agendamento não pode ser alterado porque sua data é menor que a data atual.");
        }

        // Seta as informações no objeto do banco
        banco.setTitulo(agendamento.getTitulo());
        banco.setObservacao(agendamento.getObservacao());
        banco.setDataHora(agendamento.getDataHora());

        return repository.save(banco);
    }
}
