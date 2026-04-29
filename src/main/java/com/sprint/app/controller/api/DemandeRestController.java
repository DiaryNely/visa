package com.sprint.app.controller.api;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sprint.app.entity.Demande;
import com.sprint.app.entity.Demandeur;
import com.sprint.app.entity.TypeDemande;
import com.sprint.app.entity.TypeVisa;
import com.sprint.app.service.DemandeService;

@RestController
@RequestMapping("/api/demandes")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DemandeRestController {

    @Autowired
    private DemandeService demandeService;

    /**
     * Récupérer une demande par son ID avec les infos du demandeur.
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getDemandeById(@PathVariable Integer id) {
        Optional<Demande> demande = demandeService.findById(id);
        if (demande.isPresent()) {
            return ResponseEntity.ok(toDemandePayload(demande.get()));
        }
        return ResponseEntity.notFound().build();
    }

    /**
     * Récupérer toutes les demandes d'un demandeur par son ID.
     */
    @GetMapping("/par-demandeur/{demandeurId}")
    public ResponseEntity<List<Map<String, Object>>> getDemandesByDemandeurId(@PathVariable Integer demandeurId) {
        List<Demande> demandes = demandeService.findByDemandeurId(demandeurId);
        List<Map<String, Object>> payload = demandes.stream().map(this::toDemandePayload).collect(Collectors.toList());
        return ResponseEntity.ok(payload);
    }

    /**
     * Lister toutes les demandes avec filtre optionnel par statut.
     */
    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> listDemandes(
            @RequestParam(required = false) String statut) {
        List<Demande> demandes;
        if (statut != null && !statut.isEmpty()) {
            demandes = demandeService.findByStatut(statut);
        } else {
            demandes = demandeService.findAll();
        }
        List<Map<String, Object>> payload = demandes.stream().map(this::toDemandePayload).collect(Collectors.toList());
        return ResponseEntity.ok(payload);
    }

    private Map<String, Object> toDemandePayload(Demande demande) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("id", demande.getId());
        payload.put("statut", demande.getStatut());
        payload.put("dateDemande", demande.getDateDemande());
        payload.put("dateTraitement", demande.getDateTraitement());
        payload.put("observations", demande.getObservations());
        payload.put("sansDonnees", demande.getSansDonnees());
        payload.put("qrCodeUrl", demande.getQrCodeUrl());
        payload.put("qrCodeImageBase64", demande.getQrCodeImageBase64());

        Demandeur demandeurEntity = demande.getDemandeur();
        Map<String, Object> demandeur = new HashMap<>();
        if (demandeurEntity != null) {
            demandeur.put("id", demandeurEntity.getId());
            demandeur.put("nom", demandeurEntity.getNom());
            demandeur.put("prenom", demandeurEntity.getPrenom());
            demandeur.put("email", demandeurEntity.getEmail());
            demandeur.put("telephone", demandeurEntity.getTelephone());
            if (demandeurEntity.getNationalite() != null) {
                Map<String, Object> nationalite = new HashMap<>();
                nationalite.put("id", demandeurEntity.getNationalite().getId());
                nationalite.put("libelle", demandeurEntity.getNationalite().getLibelle());
                demandeur.put("nationalite", nationalite);
            }
        }
        payload.put("demandeur", demandeur);

        TypeDemande typeDemandeEntity = demande.getTypeDemande();
        Map<String, Object> typeDemande = new HashMap<>();
        if (typeDemandeEntity != null) {
            typeDemande.put("id", typeDemandeEntity.getId());
            typeDemande.put("libelle", typeDemandeEntity.getLibelle());
        }
        payload.put("typeDemande", typeDemande);

        TypeVisa typeVisaEntity = demande.getTypeVisa();
        Map<String, Object> typeVisa = new HashMap<>();
        if (typeVisaEntity != null) {
            typeVisa.put("id", typeVisaEntity.getId());
            typeVisa.put("libelle", typeVisaEntity.getLibelle());
        }
        payload.put("typeVisa", typeVisa);

        return payload;
    }
}
