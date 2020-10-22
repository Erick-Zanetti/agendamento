package com.metting.scheduling.schedule.validators;

import com.metting.scheduling.schedule.models.Participante;
import com.metting.scheduling.schedule.utils.ValidationException;
import org.springframework.stereotype.Service;

@Service
public class ParticipanteValidator {

    public void validar(Participante participante) {
        if(participante.getNome() == null || participante.getNome().isEmpty()) {
            throw new ValidationException("Campo nome é obrigatório.");
        }

        if(participante.getEmail() == null || participante.getEmail().isEmpty()) {
            throw new ValidationException("Campo e-mail é obrigatório.");
        }
    }
}
