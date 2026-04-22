package com.sprint.app.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "type_visa")
public class TypeVisa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 50)
    private String libelle;

    @Column(name = "duree_validite", nullable = false)
    private Integer dureeValidite;

    public TypeVisa() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Integer getDureeValidite() { return dureeValidite; }
    public void setDureeValidite(Integer dureeValidite) { this.dureeValidite = dureeValidite; }

    @Override
    public String toString() { return libelle; }
}
