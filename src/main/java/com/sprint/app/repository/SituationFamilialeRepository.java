package com.sprint.app.repository;

import com.sprint.app.entity.SituationFamiliale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SituationFamilialeRepository extends JpaRepository<SituationFamiliale, Integer> {
}
