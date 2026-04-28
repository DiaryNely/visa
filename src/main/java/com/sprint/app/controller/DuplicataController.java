package com.sprint.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sprint.app.entity.Demande;
import com.sprint.app.entity.Demandeur;
import com.sprint.app.entity.MotifDuplicate;
import com.sprint.app.entity.TypeDuplicate;
import com.sprint.app.service.DemandeService;
import com.sprint.app.service.DemandeurService;
import com.sprint.app.service.DuplicataService;

@Controller
@RequestMapping("/demandes/duplicata")
public class DuplicataController {

    @Autowired
    private DuplicataService duplicataService;

    @Autowired
    private DemandeurService demandeurService;

    @Autowired
    private DemandeService demandeService;

    /**
     * Formulaire de demande de duplicata (transfert visa ou duplicata carte resident).
     */
    @GetMapping
    public String formulaireDuplicate(Model model) {
        List<MotifDuplicate> motifs = duplicataService.getAllMotifs();
        List<TypeDuplicate> types = duplicataService.getAllTypes();
        List<Demandeur> demandeurs = demandeService.getDemandeursWithDuplicataOrTransfer();

        model.addAttribute("motifs", motifs);
        model.addAttribute("types", types);
        model.addAttribute("demandeurs", demandeurs);
        model.addAttribute("situationsFamiliales", demandeurService.getAllSituationsFamiliales());
        model.addAttribute("nationalites", demandeurService.getAllNationalites());
        model.addAttribute("activePage", "demandes");

        return "demandes/duplicata-form";
    }

    /**
     * Récupérer les motifs et types de duplicata (AJAX pour le frontend).
     */
    @GetMapping("/data")
    @ResponseBody
    public Map<String, Object> getDuplicataData() {
        Map<String, Object> data = new HashMap<>();
        data.put("motifs", duplicataService.getAllMotifs());
        data.put("types", duplicataService.getAllTypes());
        return data;
    }
    @ResponseBody
    public Map<String, Object> searchDemandeur(@RequestParam String email) {
        return duplicataService.findDemandeurByEmail(email);
    }

    /**
     * Créer une demande de duplicata.
     */
    @PostMapping
    public String creerDuplicate(
            @RequestParam(required = false) Integer demandeurId,
            @RequestParam(required = false) String nom,
            @RequestParam(required = false) String prenom,
            @RequestParam(required = false) String email,
            @RequestParam Integer motifDuplicateId,
            @RequestParam Integer typeDuplicateId,
            @RequestParam(required = false) String nouveauNumeroPasseport,
            @RequestParam(required = false) String observations,
            RedirectAttributes redirectAttributes) {

        try {
            // Si c'est un nouvel utilisateur, le créer d'abord
            Integer finalDemandeurId = demandeurId;
            if (demandeurId == null || demandeurId == 0) {
                if (nom == null || prenom == null || email == null) {
                    redirectAttributes.addFlashAttribute("error", "Merci de fournir les données requises pour créer un nouveau demandeur.");
                    return "redirect:/demandes/duplicata";
                }

                // Créer le nouveau demandeur via demandeurService
                // TODO: Implémenter la méthode createBasicDemandeur dans DemandeurService
                // Pour l'instant, c'est une TODO
                redirectAttributes.addFlashAttribute("error", "La création de nouveau demandeur n'est pas encore implémentée dans ce formulaire. Veuillez utiliser le formulaire principal.");
                return "redirect:/demandes/duplicata";
            }

            // Créer la demande de duplicata
            Demande demande = duplicataService.creerDemandeDuplicate(
                    finalDemandeurId,
                    motifDuplicateId,
                    typeDuplicateId,
                    nouveauNumeroPasseport,
                    observations);

            redirectAttributes.addFlashAttribute("success",
                    "Demande de duplicata #" + demande.getId() + " créée et approuvée avec succès");
            return "redirect:/demandes/" + demande.getId();

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la création: " + e.getMessage());
            return "redirect:/demandes/duplicata";
        }
    }
}
