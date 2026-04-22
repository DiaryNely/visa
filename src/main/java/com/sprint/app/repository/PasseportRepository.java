package com.sprint.app.repository;

import com.sprint.app.entity.Passeport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PasseportRepository extends JpaRepository<Passeport, Integer> {

    List<Passeport> findByDemandeurId(Integer demandeurId);

    Optional<Passeport> findByDemandeurIdAndEstActifTrue(Integer demandeurId);

    boolean existsByNumeroPasse(String numeroPasse);
}
