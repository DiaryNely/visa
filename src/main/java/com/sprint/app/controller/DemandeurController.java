package com.sprint.app.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sprint.app.entity.Demande;
import com.sprint.app.entity.Demandeur;
import com.sprint.app.entity.MotifDuplicate;
import com.sprint.app.entity.Nationalite;
import com.sprint.app.entity.Passeport;
import com.sprint.app.entity.PieceJustificative;
import com.sprint.app.entity.SituationFamiliale;
import com.sprint.app.entity.TypeDemande;
import com.sprint.app.entity.VisaTransformable;
import com.sprint.app.service.DemandeService;
import com.sprint.app.service.DemandeurService;
import com.sprint.app.service.DuplicataService;

@Controller
@RequestMapping("/demandeurs")
public class DemandeurController {

    @Autowired
    private DemandeurService demandeurService;

    @Autowired
    private DemandeService demandeService;

    @Autowired
    private DuplicataService duplicataService;

    /**
     * Liste des demandeurs avec recherche.
     */
    @GetMapping
    public String list(@RequestParam(required = false) String search, Model model) {
        List<Demandeur> demandeurs;
        if (search != null && !search.trim().isEmpty()) {
            demandeurs = demandeurService.search(search);
        } else {
            demandeurs = demandeurService.findAll();
        }
        model.addAttribute("demandeurs", demandeurs);
        model.addAttribute("search", search);
        model.addAttribute("activePage", "demandeurs");
        return "demandeurs/list";
    }

    /**
     * Formulaire d'ajout de demandeur.
     */
    @GetMapping("/nouveau")
    public String formulaireNouveau(Model model) {
        model.addAttribute("nationalites", demandeurService.getAllNationalites());
        model.addAttribute("situationsFamiliales", demandeurService.getAllSituationsFamiliales());
        model.addAttribute("typesDemande", demandeService.getAllTypesDemande());
        model.addAttribute("typesVisa", demandeService.getAllTypesVisa());
        model.addAttribute("typesProfil", demandeService.getAllTypesProfil());
        model.addAttribute("activePage", "demandeurs");
        return "demandeurs/form";
    }

    @GetMapping("/pieces-justificatives")
    @ResponseBody
    public List<Map<String, Object>> getPiecesJustificatives(
            @RequestParam Integer typeDemandeId,
            @RequestParam Integer typeVisaId) {
        List<PieceJustificative> pieces = demandeService.getPiecesJustificatives(typeDemandeId, typeVisaId);
        List<Map<String, Object>> payload = new ArrayList<>();
        for (PieceJustificative piece : pieces) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", piece.getId());
            item.put("libelle", piece.getLibelle());
            item.put("obligatoire", piece.getObligatoire());
            payload.add(item);
        }
        return payload;
    }

    @GetMapping("/duplicata-motifs")
    @ResponseBody
    public List<MotifDuplicate> getDuplicataMotifs() {
        return duplicataService.getAllMotifs();
    }

    /**
     * Enregistrer un nouveau demandeur avec passeport et visa transformable.
     */
    @PostMapping("/nouveau")
    public String creerDemandeur(@RequestParam String nom,
            @RequestParam String prenom,
            @RequestParam(required = false) String nomJeuneFille,
            @RequestParam(required = false) String nomPere,
            @RequestParam String dateNaissance,
            @RequestParam String lieuNaissance,
            @RequestParam(required = false) String profession,
            @RequestParam String telephone,
            @RequestParam String email,
            @RequestParam String adresse,
            @RequestParam Integer nationaliteId,
            @RequestParam Integer situationFamilialeId,
            // Demande initiale + pieces justificatives
            @RequestParam(required = false) Integer typeDemandeId,
            @RequestParam(required = false) Integer typeVisaId,
            @RequestParam(required = false) Integer typeProfilId,
            @RequestParam(required = false) Integer motifDuplicateId,
            @RequestParam(required = false) String nouveauNumeroPasseport,
            @RequestParam(required = false) List<Integer> pieceIds,
            // Passeport
            @RequestParam String numeroPasse,
            @RequestParam String dateDelivrancePasse,
            @RequestParam String dateExpirationPasse,
            @RequestParam(required = false) String paysDelivrance,
            // Visa transformable
            @RequestParam(required = false) String numeroReferenceVisa,
            RedirectAttributes redirectAttributes) {
        try {
            // Vérifier si le numéro de passeport existe déjà
            if (demandeurService.passeportExists(numeroPasse)) {
                redirectAttributes.addFlashAttribute("error",
                        "Erreur : Le numéro de passeport '" + numeroPasse + "' existe déjà en base de données. "
                                + "Veuillez vérifier le numéro saisi.");
                return "redirect:/demandeurs/nouveau";
            }

            // Créer le demandeur
            Demandeur demandeur = new Demandeur();
            demandeur.setNom(nom.toUpperCase());
            demandeur.setPrenom(prenom);
            demandeur.setNomJeuneFille(nomJeuneFille);
            demandeur.setNomPere(nomPere);
            demandeur.setDateNaissance(LocalDate.parse(dateNaissance));
            demandeur.setLieuNaissance(lieuNaissance);
            demandeur.setProfession(profession);
            demandeur.setTelephone(telephone);
            demandeur.setEmail(email);
            demandeur.setAdresse(adresse);

            Nationalite nationalite = demandeurService.findNationaliteById(nationaliteId)
                    .orElseThrow(() -> new IllegalStateException("Nationalité introuvable"));
            demandeur.setNationalite(nationalite);

            SituationFamiliale situationFamiliale = demandeurService.findSituationFamilialeById(situationFamilialeId)
                    .orElseThrow(() -> new IllegalStateException("Situation familiale introuvable"));
            demandeur.setSituationFamiliale(situationFamiliale);

            demandeur = demandeurService.save(demandeur);

            // Créer le passeport
            Passeport passeport = new Passeport();
            passeport.setDemandeur(demandeur);
            passeport.setNumeroPasse(numeroPasse);
            passeport.setDateDelivrance(LocalDate.parse(dateDelivrancePasse));
            passeport.setDateExpiration(LocalDate.parse(dateExpirationPasse));
            passeport.setPaysDelivrance(paysDelivrance);
            passeport.setEstActif(true);

            passeport = demandeurService.savePasseport(passeport);

            // Créer le visa transformable si fourni
            VisaTransformable visaTransformableCree = null;
            if (numeroReferenceVisa != null && !numeroReferenceVisa.trim().isEmpty()) {
                VisaTransformable vt = new VisaTransformable();
                vt.setDemandeur(demandeur);
                vt.setPasseport(passeport);
                vt.setNumeroReference(numeroReferenceVisa.trim());
                visaTransformableCree = demandeurService.saveVisaTransformable(vt);
            }

            // Creer une demande initiale avec pieces justificatives si les types sont
            // fournis.
            if (typeDemandeId != null && typeVisaId != null) {
                if (visaTransformableCree == null) {
                    throw new IllegalStateException(
                            "Le numero de reference du VISA transformable est obligatoire pour creer la demande initiale");
                }

                // Récupérer le type de demande pour vérifier si c'est un Duplicata/Transfert
                TypeDemande typeDemande = demandeService.getTypeDemandeById(typeDemandeId)
                        .orElseThrow(() -> new IllegalStateException("Type de demande introuvable"));
                boolean isDuplicataOrTransfer = typeDemande.getLibelle().toLowerCase().contains("duplicata")
                        || typeDemande.getLibelle().toLowerCase().contains("transfert");

                Demande demande;
                if (isDuplicataOrTransfer) {
                    // Créer avec statut "approuvee" pour Duplicata/Transfert
                    demande = demandeService.creerDemandeApprouvee(
                            demandeur.getId(),
                            typeDemandeId,
                            typeVisaId,
                            typeProfilId,
                            visaTransformableCree.getId(),
                            motifDuplicateId,
                            nouveauNumeroPasseport,
                            "Demande de " + typeDemande.getLibelle().toLowerCase()
                                    + " creee lors de l enregistrement du demandeur");
                } else {
                    // Créer une demande normale avec statut "brouillon"
                    demande = demandeService.creerDemande(
                            demandeur.getId(),
                            typeDemandeId,
                            typeVisaId,
                            typeProfilId,
                            visaTransformableCree.getId(),
                            "Demande initiale creee lors de l enregistrement du demandeur");
                }

                demandeService.enregistrerPiecesPourDemande(demande, pieceIds);
            }

            redirectAttributes.addFlashAttribute("success",
                    "Demandeur " + demandeur.getNomComplet() + " créé avec succès");
            return "redirect:/demandeurs/" + demandeur.getId();

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur : " + e.getMessage());
            return "redirect:/demandeurs/nouveau";
        }
    }

    /**
     * Détail d'un demandeur avec ses demandes.
     */
    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        Demandeur demandeur = demandeurService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Demandeur introuvable : " + id));

        model.addAttribute("demandeur", demandeur);
        model.addAttribute("passeports", demandeurService.getPasseports(id));
        model.addAttribute("visasTransformables", demandeurService.getVisasTransformables(id));
        model.addAttribute("demandes", demandeService.findByDemandeurId(id));
        model.addAttribute("activePage", "demandeurs");
        return "demandeurs/detail";
    }
}
