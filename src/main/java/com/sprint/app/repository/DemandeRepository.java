package com.sprint.app.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.Demande;

@Repository
public interface DemandeRepository extends JpaRepository<Demande, Integer> {

    List<Demande> findByStatut(String statut);

    List<Demande> findByDemandeurId(Integer demandeurId);

    @Query("SELECT d FROM Demande d ORDER BY d.dateDemande DESC")
    List<Demande> findAllOrderByDateDemandeDesc();

    long countByStatut(String statut);

    @Query("SELECT d FROM Demande d WHERE d.demandeur.id = :demandeurId AND d.typeDemande.id = :typeDemandeId")
    List<Demande> findByDemandeurIdAndTypeDemandeId(Integer demandeurId, Integer typeDemandeId);

    Optional<Demande> findTopByDemandeurIdOrderByDateDemandeDesc(Integer demandeurId);
}
