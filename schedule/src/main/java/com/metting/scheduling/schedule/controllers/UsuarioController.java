package com.metting.scheduling.schedule.controllers;

import com.metting.scheduling.schedule.ApiController;
import com.metting.scheduling.schedule.dto.LoginDto;
import com.metting.scheduling.schedule.models.Usuario;
import com.metting.scheduling.schedule.services.UsuarioService;
import com.metting.scheduling.schedule.utils.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@RestController
@RequestMapping("api/usuario")
public class UsuarioController extends ApiController {

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping
    public ResponseEntity<?> cadastrar(@Valid @RequestBody Usuario usuario) {
        return sendOk(new Response<>(usuarioService.cadastrar(usuario)));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginDto loginDto) {
        return sendOk(new Response<>(usuarioService.login(loginDto)));
    }
}
