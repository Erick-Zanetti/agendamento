package com.metting.scheduling.schedule.services;

import com.metting.scheduling.schedule.dto.ParticipanteDto;
import com.metting.scheduling.schedule.models.Participante;
import com.metting.scheduling.schedule.models.Usuario;
import com.metting.scheduling.schedule.repository.ParticipanteRepository;
import com.metting.scheduling.schedule.utils.Response;
import com.metting.scheduling.schedule.utils.ResponseType;
import com.metting.scheduling.schedule.utils.SqlUtil;
import com.metting.scheduling.schedule.utils.ValidationException;
import com.metting.scheduling.schedule.validators.ParticipanteValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ParticipanteService {

    @Autowired
    private ParticipanteRepository repository;

    @Autowired
    private ParticipanteValidator validator;

    public Participante cadastrar(Participante participante) {
        if(emailJaCadastrado(participante.getEmail())) {
            throw new ValidationException("E-mail " + participante.getEmail() + " já cadastrado!");
        }

        validator.validar(participante);

        if(participante.getAtivo() == null) {
            participante.setAtivo(true);
        }

        return repository.save(participante);
    }

    public Participante buscarPorId(Long id) {
        Optional<Participante> participante = repository.findById(id);

        if(!participante.isPresent()) {
            throw new ValidationException("Participante com código " + id + " não encontrado!");
        }

        return participante.get();
    }

    private Boolean emailJaCadastrado(String email) {
        return !repository.findByEmail(email).isEmpty();
    }

    public List<Participante> buscarPorNome(String nome, Integer idUsuario) {
        nome = "%" + nome + "%";
        return repository.buscarPorNome(nome, idUsuario);
    }

    public Participante alterar(Participante participante) {
        validator.validar(participante);

        return repository.save(participante);
    }
}
