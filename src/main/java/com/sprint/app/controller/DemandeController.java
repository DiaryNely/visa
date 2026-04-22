package com.sprint.app.controller;

import com.sprint.app.entity.*;
import com.sprint.app.service.DemandeService;
import com.sprint.app.service.DemandeurService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/demandes")
public class DemandeController {

    @Autowired
    private DemandeService demandeService;

    @Autowired
    private DemandeurService demandeurService;

    /**
     * Liste des demandes avec filtre optionnel par statut.
     */
    @GetMapping
    public String list(@RequestParam(required = false) String statut, Model model) {
        List<Demande> demandes;
        if (statut != null && !statut.isEmpty()) {
            demandes = demandeService.findByStatut(statut);
        } else {
            demandes = demandeService.findAll();
        }
        model.addAttribute("demandes", demandes);
        model.addAttribute("filtreStatut", statut);
        model.addAttribute("activePage", "demandes");
        return "demandes/list";
    }

    /**
     * Formulaire de nouvelle demande.
     */
    @GetMapping("/nouveau")
    public String formulaireNouveau(Model model) {
        model.addAttribute("demandeurs", demandeurService.findAll());
        model.addAttribute("typesDemande", demandeService.getAllTypesDemande());
        model.addAttribute("typesVisa", demandeService.getAllTypesVisa());
        model.addAttribute("typesProfil", demandeService.getAllTypesProfil());
        model.addAttribute("activePage", "demandes");
        return "demandes/form";
    }

    /**
     * Récupérer les VISA transformables d'un demandeur (AJAX).
     */
    @GetMapping("/visas-transformables")
    @ResponseBody
    public List<VisaTransformable> getVisasTransformables(@RequestParam Integer demandeurId) {
        return demandeurService.getVisasTransformables(demandeurId);
    }

    /**
     * Enregistrer une nouvelle demande.
     */
    @PostMapping("/nouveau")
    public String creerDemande(@RequestParam Integer demandeurId,
                                @RequestParam Integer typeDemandeId,
                                @RequestParam Integer typeVisaId,
                                @RequestParam(required = false) Integer typeProfilId,
                                @RequestParam(required = false) Integer visaTransformableId,
                                @RequestParam(required = false) String observations,
                                RedirectAttributes redirectAttributes) {
        try {
            Demande demande = demandeService.creerDemande(
                    demandeurId, typeDemandeId, typeVisaId, typeProfilId, visaTransformableId, observations);
            redirectAttributes.addFlashAttribute("success",
                    "Demande #" + demande.getId() + " créée avec succès");
            return "redirect:/demandes/" + demande.getId();
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/demandes/nouveau";
        }
    }

    /**
     * Détail d'une demande.
     */
    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        Demande demande = demandeService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Demande introuvable : " + id));

        model.addAttribute("demande", demande);
        model.addAttribute("historique", demandeService.getHistoriqueStatuts(id));
        model.addAttribute("activePage", "demandes");
        return "demandes/detail";
    }

    /**
     * Changer le statut d'une demande.
     */
    @PostMapping("/{id}/statut")
    public String changerStatut(@PathVariable Integer id,
                                 @RequestParam String nouveauStatut,
                                 @RequestParam(required = false) String motifRejet,
                                 RedirectAttributes redirectAttributes) {
        try {
            demandeService.changerStatut(id, nouveauStatut, motifRejet);
            redirectAttributes.addFlashAttribute("success", "Statut mis à jour avec succès");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/demandes/" + id;
    }
}
