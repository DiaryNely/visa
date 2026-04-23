package com.sprint.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.PieceJustificative;

@Repository
public interface PieceJustificativeRepository extends JpaRepository<PieceJustificative, Integer> {

    List<PieceJustificative> findByTypeDemandeIdOrderByObligatoireDescLibelleAsc(Integer typeDemandeId);
}
