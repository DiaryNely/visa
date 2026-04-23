package com.sprint.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.DemandePiece;

@Repository
public interface DemandePieceRepository extends JpaRepository<DemandePiece, Integer> {
}
