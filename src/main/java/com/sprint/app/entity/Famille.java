package com.sprint.app.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "famille")
public class Famille {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_demandeur", nullable = false)
    private Demandeur demandeur;

    @Column(nullable = false, length = 50)
    private String nom;

    @Column(nullable = false, length = 50)
    private String prenom;

    @Column(nullable = false, length = 50)
    private String lien;

    @Column(name = "date_naissance")
    private LocalDate dateNaissance;

    public Famille() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Demandeur getDemandeur() { return demandeur; }
    public void setDemandeur(Demandeur demandeur) { this.demandeur = demandeur; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getLien() { return lien; }
    public void setLien(String lien) { this.lien = lien; }

    public LocalDate getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }
}
