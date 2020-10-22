package com.metting.scheduling.schedule.models;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;

@Getter @Setter
@Entity
@Table(name = "participante")
public class Participante {

    @Id
    @Column(name = "participanteid")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_participante")
    @SequenceGenerator(name = "seq_participante", sequenceName = "seq_participante", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "usuarioid")
    private Usuario usuario;

    @Column(name = "nome")
    @Size(max = 255, message = "Campo nome não deve exceder os 255 caracteres.")
    @Size(min = 3, message = "Campo nome deve conter no minimo 3 caracteres.")
    private String nome;

    @Column(name = "email")
    @Email(message = "Campo E-mail está inválido.")
    @Size(max = 50, message = "O campo e-mail não deve esceder nos 50 caracteres.")
    private String email;

    @Column(name = "telefone")
    @Size(max = 20, message = "O campo telefone não deve exceder os 20 caracteres.")
    private String telefone;

    @Column(name = "ativo")
    private Boolean ativo;

    @Column(name = "notifica")
    @NotNull(message = "Campo notificar é obrigatório.")
    private Boolean notifica;

    @OneToMany(mappedBy = "participante", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<AgendamentoParticipante> agendamento;
}
