package com.sprint.app.repository;

import com.sprint.app.entity.TypeProfil;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypeProfilRepository extends JpaRepository<TypeProfil, Integer> {
}
