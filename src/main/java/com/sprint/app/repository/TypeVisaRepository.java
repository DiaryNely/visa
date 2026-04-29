package com.sprint.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.TypeVisa;

@Repository
public interface TypeVisaRepository extends JpaRepository<TypeVisa, Integer> {
    TypeVisa findByLibelle(String libelle);
}
