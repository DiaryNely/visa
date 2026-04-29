package com.sprint.app.controller;

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
import com.sprint.app.entity.VisaTransformable;
import com.sprint.app.service.DemandeService;
import com.sprint.app.service.DemandeurService;

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
    public String list(@RequestParam(required = false) String statut,
            @RequestParam(required = false) Integer createdId,
            Model model) {
        List<Demande> demandes;
        if (statut != null && !statut.isEmpty()) {
            demandes = demandeService.findByStatut(statut);
        } else {
            demandes = demandeService.findAll();
        }
        model.addAttribute("demandes", demandes);
        model.addAttribute("filtreStatut", statut);
        model.addAttribute("createdId", createdId);
        model.addAttribute("activePage", "demandes");
        return "demandes/list";
    }

    /**
     * Formulaire de nouvelle demande.
     */
    @GetMapping("/nouveau")
    public String formulaireNouveau(Model model) {
        model.addAttribute("demandeurs", demandeurService.findAll());
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
     * Recuperer les informations de type depuis la derniere demande du demandeur.
     */
    @GetMapping("/type-infos")
    @ResponseBody
    public Map<String, Object> getTypeInfos(@RequestParam Integer demandeurId) {
        Map<String, Object> payload = new HashMap<>();
        demandeService.findDerniereDemandeParDemandeur(demandeurId).ifPresentOrElse(demande -> {
            payload.put("found", true);
            payload.put("typeDemandeId", demande.getTypeDemande().getId());
            payload.put("typeDemandeLibelle", demande.getTypeDemande().getLibelle());
            payload.put("typeVisaId", demande.getTypeVisa().getId());
            payload.put("typeVisaLibelle", demande.getTypeVisa().getLibelle());

            if (demande.getTypeProfil() != null) {
                payload.put("typeProfilId", demande.getTypeProfil().getId());
                payload.put("typeProfilLibelle", demande.getTypeProfil().getLibelle());
            } else {
                payload.put("typeProfilId", null);
                payload.put("typeProfilLibelle", "Aucun");
            }
        }, () -> {
            payload.put("found", false);
            payload.put("message", "Aucune demande precedente trouvee pour ce demandeur");
        });

        return payload;
    }

    /**
     * Enregistrer une nouvelle demande.
     */
    @PostMapping("/nouveau")
    public String creerDemande(@RequestParam Integer demandeurId,
            @RequestParam(required = false) Integer typeDemandeId,
            @RequestParam(required = false) Integer typeVisaId,
            @RequestParam(required = false) Integer typeProfilId,
            @RequestParam(required = false) Integer visaTransformableId,
            @RequestParam(required = false) String observations,
            RedirectAttributes redirectAttributes) {
        try {
            if (typeDemandeId == null || typeVisaId == null) {
                redirectAttributes.addFlashAttribute(
                        "error",
                        "Le type de demande et le type de VISA doivent etre renseignes depuis la creation du demandeur.");
                return "redirect:/demandeurs/nouveau";
            }

            Demande demande = demandeService.creerDemande(
                    demandeurId, typeDemandeId, typeVisaId, typeProfilId, visaTransformableId, observations);
            redirectAttributes.addFlashAttribute("success",
                    "Demande #" + demande.getId() + " créée avec succès. QR code généré.");
            return "redirect:/demandes?createdId=" + demande.getId();
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
