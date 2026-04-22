package com.sprint.app.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "nationalite")
public class Nationalite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 50)
    private String libelle;

    public Nationalite() {}

    public Nationalite(String libelle) {
        this.libelle = libelle;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    @Override
    public String toString() { return libelle; }
}
