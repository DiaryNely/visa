package com.sprint.app.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "type_demande")
public class TypeDemande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 50)
    private String libelle;

    @Column(name = "necessite_sans_donnees", nullable = false)
    private Boolean necessiteSansDonnees = false;

    public TypeDemande() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Boolean getNecessiteSansDonnees() { return necessiteSansDonnees; }
    public void setNecessiteSansDonnees(Boolean necessiteSansDonnees) { this.necessiteSansDonnees = necessiteSansDonnees; }

    @Override
    public String toString() { return libelle; }
}
