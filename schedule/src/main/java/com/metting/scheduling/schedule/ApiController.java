package com.metting.scheduling.schedule;

import com.metting.scheduling.schedule.utils.ResponseType;
import com.metting.scheduling.schedule.utils.Response;
import com.metting.scheduling.schedule.utils.ValidationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import javax.validation.ConstraintViolationException;

public abstract class ApiController {

    public ResponseEntity<Response<?>> sendError(Exception e) {
        e.printStackTrace();
        if(e instanceof ValidationException) {
            ValidationException validation = (ValidationException)e;
            return sendErrorValid(new Response(validation.getMessage(), ResponseType.VALIDATION));
        } else if (e instanceof ConstraintViolationException) {
            ConstraintViolationException validation = (ConstraintViolationException) e;
            return sendErrorValid(new Response<>(validation.getMessage(), ResponseType.CAMPOS_INVALIDOS));
        }
        return sendErrorValid(new Response<>("Ops! estamos enfrentando problemas técnicos, tente novamente mais tarde.", ResponseType.EXCEPTION));
    }

    private ResponseEntity<Response<?>> sendErrorValid(Response<?> res) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(res);
    }

    public ResponseEntity<Response<?>> sendOk(Response<?> res) {
        return ResponseEntity.ok(res);
    }
}
