package com.sprint.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.TypeDuplicate;

@Repository
public interface TypeDuplicateRepository extends JpaRepository<TypeDuplicate, Integer> {
    TypeDuplicate findByLibelle(String libelle);
}
