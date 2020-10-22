package com.metting.scheduling.schedule.services;

import com.metting.scheduling.schedule.dto.LoginDto;
import com.metting.scheduling.schedule.models.Participante;
import com.metting.scheduling.schedule.models.Usuario;
import com.metting.scheduling.schedule.repository.ParticipanteRepository;
import com.metting.scheduling.schedule.repository.UsuarioRepository;
import com.metting.scheduling.schedule.utils.AlertErrorException;
import com.metting.scheduling.schedule.utils.ValidationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import javax.validation.Valid;
import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository repository;

    @Autowired
    private ParticipanteRepository participanteRepository;

    /**
     * @author Erick
     * @param usuario para ser cadastrado
     * @return retorna o registro inserifdo no banco
     */
    @Transactional(Transactional.TxType.REQUIRES_NEW)
    public Usuario cadastrar(@Valid Usuario usuario) {
        List<Usuario> users = repository.findByEmail(usuario.getEmail());

        if (!users.isEmpty()) {
            throw new ValidationException("O email " + usuario.getEmail() + " já está cadastrado.");
        }
        usuario.setAtivo(true);
        Participante participante = new Participante();
        participante.setUsuario(usuario);
        participante.setNome(usuario.getNome());
        participante.setEmail(usuario.getEmail());
        participante.setNotifica(true);
        participanteRepository.save(participante);
        return repository.save(usuario);
    }

    public Usuario login(LoginDto login) {
        List<Usuario> users = repository.findByEmail(login.getLogin());

        if (users.isEmpty()) {
            throw new ValidationException("O email " + login.getLogin() + " não está cadastrado.");
        }

        Usuario usuario = users.get(0);

        if(!usuario.getAtivo()) {
            throw new ValidationException("Este usuário esta inativo");
        }

        if(usuario.getSenha().equals(login.getSenha())) {
            return usuario;
        }

        throw new AlertErrorException("Senha inválida!", "A senha está incorreta.");
    }

    public Usuario buscarPorId(Long id) {
        Optional<Usuario> usuario = repository.findById(id);

        if(!usuario.isPresent()) {
            throw new ValidationException("Usuário com código " + id + " não encontrado!");
        }

        return usuario.get();
    }
}
