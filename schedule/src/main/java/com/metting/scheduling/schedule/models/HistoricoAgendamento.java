package com.metting.scheduling.schedule.models;

import lombok.*;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "histagend")
public class HistoricoAgendamento {

    @Id
    @Column(name = "histagendid")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_histagend")
    @SequenceGenerator(name = "seq_histagend", sequenceName = "seq_histagend", allocationSize = 1)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "novoid")
    private Agendamento novo;

    @ManyToOne
    @JoinColumn(name = "antigoid")
    private Agendamento antigo;

}
