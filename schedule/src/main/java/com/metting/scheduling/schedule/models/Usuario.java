package com.metting.scheduling.schedule.models;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Getter @Setter
@Entity
@Table(name = "usuario")
public class Usuario {

    @Id
    @Column(name = "usuarioid")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_usuario")
    @SequenceGenerator(name = "seq_usuario", sequenceName = "seq_usuario", allocationSize = 1)
    private Long id;

    @Column(name = "nome", length = 50)
    @NotNull(message = "Campo nome não foi preenchido")
    @Size(min = 3, max = 50, message = "Campo deve conter entre 3 e 50 caracteres")
    private String nome;

    @Column(name = "email")
    @NotNull(message = "Campo e-mail não foi preenchido.")
    @Email(message = "Email inválido.")
    private String email;

    @NotNull(message = "Campo senha não foi preenchido.")
    @Column(name = "senha")
    @Size(max = 50, message = "A senha não deve ultrapassar os 50 caracteres")
    private String senha;

    @Column(name = "ativo")
    private Boolean ativo;
}
