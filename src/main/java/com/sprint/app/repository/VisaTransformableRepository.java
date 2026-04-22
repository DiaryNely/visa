package com.sprint.app.repository;

import com.sprint.app.entity.VisaTransformable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VisaTransformableRepository extends JpaRepository<VisaTransformable, Integer> {

    List<VisaTransformable> findByDemandeurId(Integer demandeurId);
}
