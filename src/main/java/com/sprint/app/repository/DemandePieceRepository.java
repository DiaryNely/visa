package com.sprint.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.DemandePiece;

import java.util.List;

@Repository
public interface DemandePieceRepository extends JpaRepository<DemandePiece, Integer> {
    
    List<DemandePiece> findByDemandeId(Integer demandeId);
}
