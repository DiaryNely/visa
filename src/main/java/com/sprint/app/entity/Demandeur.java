package com.sprint.app.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "demandeur")
public class Demandeur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 50)
    private String nom;

    @Column(nullable = false, length = 50)
    private String prenom;

    @Column(name = "nom_jeune_fille", length = 50)
    private String nomJeuneFille;

    @Column(name = "nom_pere", length = 50)
    private String nomPere;

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;

    @Column(name = "lieu_naissance", nullable = false, length = 100)
    private String lieuNaissance;

    @Column(length = 100)
    private String profession;

    @Column(nullable = false, length = 20)
    private String telephone;

    @Column(nullable = false, length = 100)
    private String email;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String adresse;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_situation_familiale", nullable = false)
    private SituationFamiliale situationFamiliale;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_nationalite", nullable = false)
    private Nationalite nationalite;

    @OneToMany(mappedBy = "demandeur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Passeport> passeports = new ArrayList<>();

    @OneToMany(mappedBy = "demandeur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<VisaTransformable> visasTransformables = new ArrayList<>();

    @OneToMany(mappedBy = "demandeur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Demande> demandes = new ArrayList<>();

    @OneToMany(mappedBy = "demandeur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Famille> famille = new ArrayList<>();

    public Demandeur() {}

    // Getters & Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getNomJeuneFille() { return nomJeuneFille; }
    public void setNomJeuneFille(String nomJeuneFille) { this.nomJeuneFille = nomJeuneFille; }

    public String getNomPere() { return nomPere; }
    public void setNomPere(String nomPere) { this.nomPere = nomPere; }

    public LocalDate getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }

    public String getLieuNaissance() { return lieuNaissance; }
    public void setLieuNaissance(String lieuNaissance) { this.lieuNaissance = lieuNaissance; }

    public String getProfession() { return profession; }
    public void setProfession(String profession) { this.profession = profession; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public SituationFamiliale getSituationFamiliale() { return situationFamiliale; }
    public void setSituationFamiliale(SituationFamiliale situationFamiliale) { this.situationFamiliale = situationFamiliale; }

    public Nationalite getNationalite() { return nationalite; }
    public void setNationalite(Nationalite nationalite) { this.nationalite = nationalite; }

    public List<Passeport> getPasseports() { return passeports; }
    public void setPasseports(List<Passeport> passeports) { this.passeports = passeports; }

    public List<VisaTransformable> getVisasTransformables() { return visasTransformables; }
    public void setVisasTransformables(List<VisaTransformable> visasTransformables) { this.visasTransformables = visasTransformables; }

    public List<Demande> getDemandes() { return demandes; }
    public void setDemandes(List<Demande> demandes) { this.demandes = demandes; }

    public List<Famille> getFamille() { return famille; }
    public void setFamille(List<Famille> famille) { this.famille = famille; }

    public String getNomComplet() { return prenom + " " + nom; }
}
