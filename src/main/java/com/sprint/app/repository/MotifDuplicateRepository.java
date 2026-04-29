package com.sprint.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.MotifDuplicate;

@Repository
public interface MotifDuplicateRepository extends JpaRepository<MotifDuplicate, Integer> {
    MotifDuplicate findByLibelle(String libelle);
}
