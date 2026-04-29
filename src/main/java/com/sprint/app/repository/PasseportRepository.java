package com.sprint.app.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sprint.app.entity.Passeport;

@Repository
public interface PasseportRepository extends JpaRepository<Passeport, Integer> {

    List<Passeport> findByDemandeurId(Integer demandeurId);

    Optional<Passeport> findByDemandeurIdAndEstActifTrue(Integer demandeurId);

    boolean existsByNumeroPasse(String numeroPasse);

    Optional<Passeport> findByNumeroPasse(String numeroPasse);
}
