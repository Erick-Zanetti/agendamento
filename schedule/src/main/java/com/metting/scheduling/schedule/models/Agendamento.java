package com.metting.scheduling.schedule.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.metting.scheduling.schedule.enums.SituacaoAgendamento;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "agendamento")
public class Agendamento {

    @Id
    @Column(name = "agendamentoid")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_agendamento")
    @SequenceGenerator(name = "seq_agendamento", sequenceName = "seq_agendamento", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "usuarioid", referencedColumnName = "usuarioid",  insertable = false, updatable = false)
    private Usuario usuario;

    @NotNull(message = "É necessário informar o usuário que realizou o agendamneto.")
    @Column(name = "usuarioid")
    private Long usuarioId;

    @Column(name = "titulo")
    @NotNull(message = "Campo título obrigatório")
    private String titulo;

    @Column(name = "observacao")
    private String observacao;

    @Column(name = "datahora")
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat
            (shape = JsonFormat.Shape.STRING, pattern = "dd-MM-yyyy HH:mm:ss")
    @NotNull(message = "Data e horário do agendamento é obrigatório.")
    private Date dataHora;

    @Column(name = "datahorainicio")
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat
            (shape = JsonFormat.Shape.STRING, pattern = "dd-MM-yyyy HH:mm:ss")
    private Date dataHoraInicio;

    @Column(name = "datahorafim")
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat
            (shape = JsonFormat.Shape.STRING, pattern = "dd-MM-yyyy HH:mm:ss")
    private Date dataHoraFim;

    @Column(name = "realizado")
    private Boolean realizado;

    @Column(name = "situacao")
    @Enumerated(EnumType.STRING)
    private SituacaoAgendamento situacao;

    @Column(name = "nota")
    private Integer nota;

    @Column(name = "feedback")
    private String feedback;

    @OneToMany(mappedBy = "agendamento", cascade = CascadeType.ALL)
    @JsonManagedReference(value = "agendamento_reference")
    private List<AgendamentoParticipante> participantes;
}
