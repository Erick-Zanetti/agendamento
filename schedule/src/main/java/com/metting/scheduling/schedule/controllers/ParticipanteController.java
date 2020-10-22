package com.metting.scheduling.schedule.controllers;

import com.metting.scheduling.schedule.ApiController;
import com.metting.scheduling.schedule.models.Participante;
import com.metting.scheduling.schedule.services.ParticipanteService;
import com.metting.scheduling.schedule.utils.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("api/participante")
public class ParticipanteController extends ApiController {

    @Autowired
    private ParticipanteService service;

    @PostMapping
    public ResponseEntity<?> cadastrar(@RequestBody @Valid Participante participante) {
        return sendOk(new Response<>(service.cadastrar(participante)));
    }

    @GetMapping
    public ResponseEntity<?> buscarPorNome(
            @RequestParam("nome") String nome,
            @RequestParam("idUsuario") Integer idUsuario
    ) {
        return sendOk(new Response<>(service.buscarPorNome(nome, idUsuario)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> buscarPorId(@PathVariable("id") Long id) {
        return sendOk(new Response<>(service.buscarPorId(id)));
    }

    @PutMapping
    public ResponseEntity<?> alterar(@RequestBody Participante participante) {
        return sendOk(new Response<>(service.alterar(participante)));
    }
}
