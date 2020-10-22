create sequence seq_usuario;

create table usuario(
	usuarioid bigint not null,
	email varchar(100),
	senha varchar(400),
	nome varchar(50),
	ativo boolean,
	constraint pk_usuario primary key(usuarioid)
);

create sequence seq_participante;

create table participante(
	participanteid bigint not null,
	usuarioid bigint,
	nome varchar(255),
	email varchar(50),
	telefone varchar(20),
	ativo boolean,
	notifica boolean,
	constraint pk_participante primary key(participanteid),
	constraint fk_participante_usuario foreign key(usuarioid) references usuario(usuarioid)
);

create sequence seq_agendamento;

create table agendamento(
	agendamentoid bigint not null,
	usuarioid bigint,
	titulo varchar(255),
	observacao varchar(2000),
	datahora timestamp,
	datahorainicio timestamp,
	datahorafim timestamp,
	realizado boolean,
	situacao varchar(20),
	nota integer,
	feedback varchar(2500),
	constraint pk_agendamento primary key(agendamentoid),
	constraint fk_agendamento_usuario foreign key (usuarioid) references usuario(usuarioid)
);

create sequence seq_agendpart;

create table agendpart(
	agendpartid bigint not null,
	agendamentoid bigint not null,
	participanteid bigint not null,
	constraint pk_agendpart primary key(agendpartid),
	constraint fk_agendpart_agendamento foreign key (agendamentoid) references agendamento(agendamentoid),
	constraint fk_agendpart_participante foreign key(participanteid) references participante(participanteid)
);

create sequence seq_histagend;

create table histagend(
	histagendid bigint not null,
	novoid bigint,
	antigoid bigint,
	constraint pk_histagend primary key (histagendid),
	constraint fk_histagend_novo foreign key (novoid) references agendamento(agendamentoid),
	constraint fk_histagend_antigo foreign key (antigoid) references agendamento(agendamentoid)
);
