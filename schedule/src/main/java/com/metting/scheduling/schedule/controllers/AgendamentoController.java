package com.metting.scheduling.schedule.controllers;

import com.metting.scheduling.schedule.ApiController;
import com.metting.scheduling.schedule.dto.ConclusaoAgendamentoDto;
import com.metting.scheduling.schedule.dto.FiltroAgendamentoDto;
import com.metting.scheduling.schedule.dto.ReagendamentoDto;
import com.metting.scheduling.schedule.models.Agendamento;
import com.metting.scheduling.schedule.services.AgendamentoService;
import com.metting.scheduling.schedule.services.PesquisaAgendamentoService;
import com.metting.scheduling.schedule.utils.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

@RestController
@RequestMapping("api/agendamento")
public class AgendamentoController extends ApiController {

    @Autowired
    private AgendamentoService service;

    @Autowired
    private PesquisaAgendamentoService pesquisaService;

    @PostMapping
    public ResponseEntity<?> agendar(
            @RequestBody @Valid Agendamento agendamento
    ) {

        return sendOk(new Response<>(service.agendar(agendamento)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> buscarPorId(@PathVariable("id") Long agendamentoId) {
        return sendOk(new Response<>(service.buscarPorId(agendamentoId)));
    }

    @PutMapping("/finalizar/{agendamentoId}")
    public ResponseEntity<?> finalizar(
            @RequestBody @Valid ConclusaoAgendamentoDto dto,
            @PathVariable("agendamentoId") Long agendamentoId) {
        return sendOk(service.finalizar(dto, agendamentoId));
    }

    @PutMapping("/iniciar/{agendamentoId}")
    public ResponseEntity<?> iniciar(
            @PathVariable("agendamentoId") Long agendamentoId) {
        return sendOk(service.iniciar(agendamentoId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> remover(@PathVariable("id") Long agendamentoId) {
        return sendOk(service.remover(agendamentoId));
    }

    @PostMapping("pesquisar")
    public ResponseEntity<?> pesquisar(@RequestBody @Valid FiltroAgendamentoDto filtro) {
        return sendOk(new Response<>(pesquisaService.pesquisar(filtro)));
    }

    @PutMapping("/adicionar-participantes/{id}")
    public ResponseEntity<?> adidonarParticipantes(
            @RequestBody @NotNull(message = "Nenhum participante foi informado")
            @NotEmpty(message = "Nenhum participante foi informado")List<Long> participantes,
            @PathVariable("id") Long agendamentoId
    ) {
        return sendOk(service.adicionarParticipantes(participantes, agendamentoId));
    }

    @PostMapping("/reagendar/{agendamentoid}")
    public ResponseEntity<?> reagendar(
            @RequestBody @Valid ReagendamentoDto reagendamentoDto,
            @PathVariable("agendamentoid") Long agendamentoId
    ) {
        return sendOk(service.reagendamento(reagendamentoDto, agendamentoId));
    }

    @GetMapping("/buscar-participantes/{id}")
    public ResponseEntity<?> buscarParticipantes(@PathVariable("id") Long agendamentoId) {
        return sendOk(new Response<>(service.buscarParticipantes(agendamentoId)));
    }

    @GetMapping("/por-usuario/{usuarioId}")
    public ResponseEntity<?> porUsuario(@PathVariable("usuarioId") Long usuarioId) {
        return sendOk(new Response<>(service.porUsuario(usuarioId)));
    }

    @PutMapping("/adicionar-participante")
    public ResponseEntity<?> adicionarParticipante(
            @RequestParam("agendamentoId") @NotNull(message = "Código do agendamento não informado") Long agendamentoId,
            @RequestParam("participanteId") @NotNull(message = "Código do participante não informado") Long participanteId
    ) {
        return sendOk(new Response<>(service.adicionarparticipante(agendamentoId, participanteId)));
    }

    @PutMapping("/remover-participante")
    public ResponseEntity<Response<?>> removerParticipante(
            @RequestParam("agendamentoId") @NotNull(message = "Código do agendamento não informado") Long agendamentoId,
            @RequestParam("participanteId") @NotNull(message = "Código do participante não informado") Long participanteId
    ) {
        return sendOk(new Response<>(service.removerParticipante(agendamentoId, participanteId)));
    }

    @PutMapping
    public ResponseEntity<?> alterar(@Valid @RequestBody Agendamento agendamento) {
        return sendOk(new Response<>(service.alterar(agendamento)));
    }
}
