package com.sprint.app.repository;

import com.sprint.app.entity.Demandeur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DemandeurRepository extends JpaRepository<Demandeur, Integer> {

    @Query("SELECT d FROM Demandeur d WHERE LOWER(d.nom) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(d.prenom) LIKE LOWER(CONCAT('%', :search, '%'))")
    List<Demandeur> searchByNomOrPrenom(@Param("search") String search);

    boolean existsByEmail(String email);
}
