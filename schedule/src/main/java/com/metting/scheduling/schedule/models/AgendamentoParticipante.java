package com.metting.scheduling.schedule.models;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.*;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "agendpart")
public class AgendamentoParticipante {

    @Id
    @Column(name = "agendpartid")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_agendpart")
    @SequenceGenerator(name = "seq_agendpart", sequenceName = "seq_agendpart", allocationSize = 1)
    private Long id;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "agendamentoid")
    @JsonBackReference(value = "agendamento_reference")
    private Agendamento agendamento;

    @ManyToOne
    @JoinColumn(name = "participanteid")
    private Participante participante;
}
