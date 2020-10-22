package com.metting.scheduling.schedule.utils;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
@RestController
public class TratamentoExecao extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException ex, HttpHeaders headers, HttpStatus status, WebRequest request) {
        Response res = new Response<>(ex.getBindingResult().getFieldError().getDefaultMessage(), ResponseType.CAMPOS_INVALIDOS);
        return new ResponseEntity<>(res, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(ValidationException.class)
    public ResponseEntity<Object> handleValidationException(ValidationException ex, WebRequest request) {
        Response res = new Response<>(ex.getMensagemErro(), ResponseType.CAMPOS_INVALIDOS);
        return new ResponseEntity<>(res, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(AlertErrorException.class)
    public ResponseEntity<Object> handleAlertError(AlertErrorException ex, WebRequest request) {
        Response res = new Response<>();
        res.setAlert(ex.getData());
        res.setTipo(ResponseType.ALERT_ERROR);
        res.setHasError(true);
        return new ResponseEntity<>(res, HttpStatus.BAD_REQUEST);
    }
}
