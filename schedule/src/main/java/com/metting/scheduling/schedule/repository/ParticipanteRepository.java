package com.metting.scheduling.schedule.repository;

import com.metting.scheduling.schedule.models.Participante;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ParticipanteRepository extends JpaRepository<Participante, Long> {

    @Query("select p from Participante p where p.email = :email")
    public List<Participante> findByEmail(@Param("email") String email);

    @Query(value = "select p.* from Participante p " +
            " where p.nome ilike :nome and p.ativo = true and p.usuarioid = :usuarioid order by nome ", nativeQuery = true)
    public List<Participante> buscarPorNome(@Param("nome") String nome, @Param("usuarioid") Integer idUsuario);

}
