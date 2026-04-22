package com.sprint.app.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "visa_historique")
public class VisaHistorique {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_visa", nullable = false)
    private Visa visa;

    @Column(name = "date_changement")
    private LocalDate dateChangement;

    @Column(name = "ancien_statut", length = 30)
    private String ancienStatut;

    @Column(name = "nouveau_statut", length = 30)
    private String nouveauStatut;

    @Column(columnDefinition = "TEXT")
    private String motif;

    public VisaHistorique() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Visa getVisa() { return visa; }
    public void setVisa(Visa visa) { this.visa = visa; }

    public LocalDate getDateChangement() { return dateChangement; }
    public void setDateChangement(LocalDate dateChangement) { this.dateChangement = dateChangement; }

    public String getAncienStatut() { return ancienStatut; }
    public void setAncienStatut(String ancienStatut) { this.ancienStatut = ancienStatut; }

    public String getNouveauStatut() { return nouveauStatut; }
    public void setNouveauStatut(String nouveauStatut) { this.nouveauStatut = nouveauStatut; }

    public String getMotif() { return motif; }
    public void setMotif(String motif) { this.motif = motif; }
}
