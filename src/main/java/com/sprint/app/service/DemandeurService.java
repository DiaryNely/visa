package com.sprint.app.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sprint.app.entity.Demandeur;
import com.sprint.app.entity.Nationalite;
import com.sprint.app.entity.Passeport;
import com.sprint.app.entity.SituationFamiliale;
import com.sprint.app.entity.VisaTransformable;
import com.sprint.app.repository.DemandeurRepository;
import com.sprint.app.repository.NationaliteRepository;
import com.sprint.app.repository.PasseportRepository;
import com.sprint.app.repository.SituationFamilialeRepository;
import com.sprint.app.repository.VisaTransformableRepository;

@Service
public class DemandeurService {

    @Autowired
    private DemandeurRepository demandeurRepository;

    @Autowired
    private NationaliteRepository nationaliteRepository;

    @Autowired
    private SituationFamilialeRepository situationFamilialeRepository;

    @Autowired
    private PasseportRepository passeportRepository;

    @Autowired
    private VisaTransformableRepository visaTransformableRepository;

    // ==================== CRUD ====================

    public List<Demandeur> findAll() {
        return demandeurRepository.findAll();
    }

    public Optional<Demandeur> findById(Integer id) {
        return demandeurRepository.findById(id);
    }

    public List<Demandeur> search(String query) {
        if (query == null || query.trim().isEmpty()) {
            return findAll();
        }
        return demandeurRepository.searchByNomOrPrenom(query.trim());
    }

    @Transactional
    public Demandeur save(Demandeur demandeur) {
        return demandeurRepository.save(demandeur);
    }

    @Transactional
    public void delete(Integer id) {
        demandeurRepository.deleteById(id);
    }

    // ==================== PASSEPORT ====================

    public List<Passeport> getPasseports(Integer demandeurId) {
        return passeportRepository.findByDemandeurId(demandeurId);
    }

    public Optional<Passeport> getPasseportActif(Integer demandeurId) {
        return passeportRepository.findByDemandeurIdAndEstActifTrue(demandeurId);
    }

    public Optional<Demandeur> findByNumeroPasse(String numeroPasse) {
        Optional<Passeport> passeport = passeportRepository.findByNumeroPasse(numeroPasse);
        if (passeport.isPresent()) {
            return demandeurRepository.findById(passeport.get().getDemandeur().getId());
        }
        return Optional.empty();
    }

    @Transactional
    public Passeport savePasseport(Passeport passeport) {
        return passeportRepository.save(passeport);
    }

    // ==================== VISA TRANSFORMABLE ====================

    public List<VisaTransformable> getVisasTransformables(Integer demandeurId) {
        return visaTransformableRepository.findByDemandeurId(demandeurId);
    }

    @Transactional
    public VisaTransformable saveVisaTransformable(VisaTransformable visaTransformable) {
        return visaTransformableRepository.save(visaTransformable);
    }

    // ==================== DONNÉES DE RÉFÉRENCE ====================

    public List<Nationalite> getAllNationalites() {
        return nationaliteRepository.findAll();
    }

    public List<SituationFamiliale> getAllSituationsFamiliales() {
        return situationFamilialeRepository.findAll();
    }

    public Optional<Nationalite> findNationaliteById(Integer id) {
        return nationaliteRepository.findById(id);
    }

    public Optional<SituationFamiliale> findSituationFamilialeById(Integer id) {
        return situationFamilialeRepository.findById(id);
    }

    // ==================== STATISTIQUES ====================

    public long count() {
        return demandeurRepository.count();
    }
}
