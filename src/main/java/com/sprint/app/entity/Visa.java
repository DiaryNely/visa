package com.sprint.app.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "visa")
public class Visa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_demande", nullable = false)
    private Demande demande;

    @Column(length = 50)
    private String reference;

    @Column(name = "date_debut", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "date_fin", nullable = false)
    private LocalDate dateFin;

    @Column(name = "lieu_entree", nullable = false, length = 100)
    private String lieuEntree;

    @Column(length = 30)
    private String statut;

    @Column(nullable = false)
    private Boolean transformable = false;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_type_visa", nullable = false)
    private TypeVisa typeVisa;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_passeport", nullable = false)
    private Passeport passeport;

    public Visa() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Demande getDemande() { return demande; }
    public void setDemande(Demande demande) { this.demande = demande; }

    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }

    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }

    public LocalDate getDateFin() { return dateFin; }
    public void setDateFin(LocalDate dateFin) { this.dateFin = dateFin; }

    public String getLieuEntree() { return lieuEntree; }
    public void setLieuEntree(String lieuEntree) { this.lieuEntree = lieuEntree; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Boolean getTransformable() { return transformable; }
    public void setTransformable(Boolean transformable) { this.transformable = transformable; }

    public TypeVisa getTypeVisa() { return typeVisa; }
    public void setTypeVisa(TypeVisa typeVisa) { this.typeVisa = typeVisa; }

    public Passeport getPasseport() { return passeport; }
    public void setPasseport(Passeport passeport) { this.passeport = passeport; }
}
