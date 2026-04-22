package com.sprint.app.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "statut_demande")
public class StatutDemande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_demande", nullable = false)
    private Demande demande;

    @Column(nullable = false, length = 30)
    private String statut;

    @Column(name = "date_changement_statut")
    private LocalDate dateChangementStatut;

    public StatutDemande() {}

    public StatutDemande(Demande demande, String statut, LocalDate dateChangementStatut) {
        this.demande = demande;
        this.statut = statut;
        this.dateChangementStatut = dateChangementStatut;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Demande getDemande() { return demande; }
    public void setDemande(Demande demande) { this.demande = demande; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public LocalDate getDateChangementStatut() { return dateChangementStatut; }
    public void setDateChangementStatut(LocalDate dateChangementStatut) { this.dateChangementStatut = dateChangementStatut; }

    public String getStatutLabel() {
        if (statut == null) return "";
        return switch (statut) {
            case "brouillon" -> "Brouillon";
            case "soumise" -> "Soumise";
            case "en_cours" -> "En cours";
            case "validee" -> "Validée";
            case "rejetee" -> "Rejetée";
            default -> statut;
        };
    }
}
