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
import com.sprint.app.entity.Passeport;
import com.sprint.app.entity.TypeDemande;
import com.sprint.app.entity.TypeVisa;
import com.sprint.app.entity.VisaTransformable;
import com.sprint.app.service.DemandeService;
import com.sprint.app.service.DemandeurService;

@RestController
@RequestMapping("/api/demandeurs")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DemandeurRestController {

    @Autowired
    private DemandeurService demandeurService;

    @Autowired
    private DemandeService demandeService;

    /**
     * Récupérer un demandeur par son ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getDemandeurById(@PathVariable Integer id) {
        Optional<Demandeur> demandeur = demandeurService.findById(id);
        if (demandeur.isPresent()) {
            return ResponseEntity.ok(toDemandeurPayload(demandeur.get()));
        }
        return ResponseEntity.notFound().build();
    }

    /**
     * Rechercher un demandeur par numéro de passeport et retourner toutes ses
     * demandes, visas transformables, et la dernière demande.
     */
    @GetMapping("/par-passeport/{numeroPasse}")
    public ResponseEntity<?> getDemandesByPasseportNumber(@PathVariable String numeroPasse) {
        Optional<Demandeur> demandeur = demandeurService.findByNumeroPasse(numeroPasse);
        if (!demandeur.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        List<Demande> demandes = demandeService.findByDemandeurId(demandeur.get().getId());

        Map<String, Object> response = new HashMap<>();
        response.put("demandeur", toDemandeurPayload(demandeur.get()));
        response.put("demandes", demandes.stream().map(this::toDemandePayload).collect(Collectors.toList()));

        // Ajouter les visas transformables
        List<VisaTransformable> visasTransformables = demandeurService.getVisasTransformables(demandeur.get().getId());
        response.put("visasTransformables",
                visasTransformables.stream().map(this::toVisaTransformablePayload).collect(Collectors.toList()));

        // Ajouter la dernière demande avec ses infos
        Optional<Demande> derniereDemande = demandeService.findDerniereDemandeParDemandeur(demandeur.get().getId());
        if (derniereDemande.isPresent()) {
            response.put("derniereDemande", toDemandeDetailPayload(derniereDemande.get()));
        } else {
            response.put("derniereDemande", null);
        }

        return ResponseEntity.ok(response);
    }

    /**
     * Rechercher par nom ou prénom.
     */
    @GetMapping("/search")
    public ResponseEntity<List<Demandeur>> search(
            @RequestParam(required = false) String query) {
        List<Demandeur> demandeurs = demandeurService.search(query);
        return ResponseEntity.ok(demandeurs);
    }

    private Map<String, Object> toDemandeurPayload(Demandeur demandeur) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("id", demandeur.getId());
        payload.put("nom", demandeur.getNom());
        payload.put("prenom", demandeur.getPrenom());
        payload.put("nomJeuneFille", demandeur.getNomJeuneFille());
        payload.put("nomPere", demandeur.getNomPere());
        payload.put("profession", demandeur.getProfession());
        payload.put("email", demandeur.getEmail());
        payload.put("telephone", demandeur.getTelephone());
        payload.put("dateNaissance", demandeur.getDateNaissance());
        payload.put("lieuNaissance", demandeur.getLieuNaissance());
        payload.put("adresse", demandeur.getAdresse());

        Map<String, Object> nationalite = new HashMap<>();
        if (demandeur.getNationalite() != null) {
            nationalite.put("id", demandeur.getNationalite().getId());
            nationalite.put("libelle", demandeur.getNationalite().getLibelle());
        }
        payload.put("nationalite", nationalite);
        payload.put("nationaliteId", demandeur.getNationalite() != null ? demandeur.getNationalite().getId() : null);

        Map<String, Object> situationFamiliale = new HashMap<>();
        if (demandeur.getSituationFamiliale() != null) {
            situationFamiliale.put("id", demandeur.getSituationFamiliale().getId());
            situationFamiliale.put("libelle", demandeur.getSituationFamiliale().getLibelle());
        }
        payload.put("situationFamiliale", situationFamiliale);
        payload.put("situationFamilialeId",
                demandeur.getSituationFamiliale() != null ? demandeur.getSituationFamiliale().getId() : null);

        Optional<Passeport> passeportActif = demandeurService.getPasseportActif(demandeur.getId());
        if (passeportActif.isPresent()) {
            payload.put("passeportActif", toPasseportPayload(passeportActif.get()));
        } else {
            payload.put("passeportActif", null);
        }

        return payload;
    }

    private Map<String, Object> toPasseportPayload(Passeport passeport) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("id", passeport.getId());
        payload.put("numeroPasse", passeport.getNumeroPasse());
        payload.put("dateDelivrance", passeport.getDateDelivrance());
        payload.put("dateExpiration", passeport.getDateExpiration());
        payload.put("paysDelivrance", passeport.getPaysDelivrance());
        payload.put("estActif", passeport.getEstActif());
        payload.put("valide", passeport.isValide());
        return payload;
    }

    private Map<String, Object> toVisaTransformablePayload(VisaTransformable visa) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("id", visa.getId());
        payload.put("numeroReference", visa.getNumeroReference());
        payload.put("dateEntree", visa.getDateEntree());
        payload.put("lieuEntree", visa.getLieuEntree());
        payload.put("dateExpiration", visa.getDateExpiration());
        payload.put("valide", visa.isValide());

        Map<String, Object> passeport = new HashMap<>();
        if (visa.getPasseport() != null) {
            passeport.put("id", visa.getPasseport().getId());
            passeport.put("numeroPasse", visa.getPasseport().getNumeroPasse());
        }
        payload.put("passeport", passeport);
        return payload;
    }

    private Map<String, Object> toDemandeDetailPayload(Demande demande) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("id", demande.getId());
        payload.put("statut", demande.getStatut());
        payload.put("observations", demande.getObservations());

        if (demande.getTypeDemande() != null) {
            Map<String, Object> typeDemande = new HashMap<>();
            typeDemande.put("id", demande.getTypeDemande().getId());
            typeDemande.put("libelle", demande.getTypeDemande().getLibelle());
            payload.put("typeDemande", typeDemande);
        }

        if (demande.getTypeVisa() != null) {
            Map<String, Object> typeVisa = new HashMap<>();
            typeVisa.put("id", demande.getTypeVisa().getId());
            typeVisa.put("libelle", demande.getTypeVisa().getLibelle());
            payload.put("typeVisa", typeVisa);
        }

        if (demande.getTypeProfil() != null) {
            Map<String, Object> typeProfil = new HashMap<>();
            typeProfil.put("id", demande.getTypeProfil().getId());
            typeProfil.put("libelle", demande.getTypeProfil().getLibelle());
            payload.put("typeProfil", typeProfil);
        } else {
            payload.put("typeProfil", null);
        }

        if (demande.getVisaTransformable() != null) {
            payload.put("visaTransformableId", demande.getVisaTransformable().getId());
        }

        return payload;
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
