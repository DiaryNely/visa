package com.sprint.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.TypeDemande;

@Repository
public interface TypeDemandeRepository extends JpaRepository<TypeDemande, Integer> {
    TypeDemande findByLibelle(String libelle);
}
