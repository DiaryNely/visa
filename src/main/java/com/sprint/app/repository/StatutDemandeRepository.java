package com.sprint.app.repository;

import com.sprint.app.entity.StatutDemande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StatutDemandeRepository extends JpaRepository<StatutDemande, Integer> {

    List<StatutDemande> findByDemandeIdOrderByDateChangementStatutDesc(Integer demandeId);
}
