package com.metting.scheduling.schedule.repository;

import com.metting.scheduling.schedule.models.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    @Query("select u from Usuario u where u.email = :email")
    public List<Usuario> findByEmail(@Param("email") String email);
}
