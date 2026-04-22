package com.sprint.app.controller;

import com.sprint.app.entity.*;
import com.sprint.app.service.DemandeurService;
import com.sprint.app.service.DemandeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/demandeurs")
public class DemandeurController {

    @Autowired
    private DemandeurService demandeurService;

    @Autowired
    private DemandeService demandeService;

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
        model.addAttribute("activePage", "demandeurs");
        return "demandeurs/form";
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
                                  // Passeport
                                  @RequestParam String numeroPasse,
                                  @RequestParam String dateDelivrancePasse,
                                  @RequestParam String dateExpirationPasse,
                                  @RequestParam(required = false) String paysDelivrance,
                                  // Visa transformable
                                  @RequestParam(required = false) String numeroReferenceVisa,
                                  RedirectAttributes redirectAttributes) {
        try {
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
            if (numeroReferenceVisa != null && !numeroReferenceVisa.trim().isEmpty()) {
                VisaTransformable vt = new VisaTransformable();
                vt.setDemandeur(demandeur);
                vt.setPasseport(passeport);
                vt.setNumeroReference(numeroReferenceVisa.trim());
                demandeurService.saveVisaTransformable(vt);
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
