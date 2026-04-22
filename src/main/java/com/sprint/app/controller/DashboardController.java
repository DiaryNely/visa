package com.sprint.app.controller;

import com.sprint.app.service.DemandeService;
import com.sprint.app.service.DemandeurService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Map;

@Controller
public class DashboardController {

    @Autowired
    private DemandeService demandeService;

    @Autowired
    private DemandeurService demandeurService;

    @GetMapping("/")
    public String dashboard(Model model) {
        Map<String, Long> stats = demandeService.getStatistiques();
        model.addAttribute("stats", stats);
        model.addAttribute("totalDemandeurs", demandeurService.count());
        model.addAttribute("dernieresDemandes", demandeService.findAll().stream().limit(10).toList());
        model.addAttribute("activePage", "dashboard");
        return "dashboard";
    }
}
