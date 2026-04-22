package com.sprint.app.entity;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "passeport")
@JsonIgnoreProperties({ "demandeur", "passeportPrecedent" })
public class Passeport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_demandeur", nullable = false)
    private Demandeur demandeur;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_passeport_precedent")
    private Passeport passeportPrecedent;

    @Column(name = "numero_passeport", nullable = false, unique = true, length = 50)
    private String numeroPasse;

    @Column(name = "date_delivrance", nullable = false)
    private LocalDate dateDelivrance;

    @Column(name = "date_expiration", nullable = false)
    private LocalDate dateExpiration;

    @Column(name = "pays_delivrance", length = 100)
    private String paysDelivrance;

    @Column(name = "est_actif", nullable = false)
    private Boolean estActif;

    public Passeport() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Demandeur getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(Demandeur demandeur) {
        this.demandeur = demandeur;
    }

    public Passeport getPasseportPrecedent() {
        return passeportPrecedent;
    }

    public void setPasseportPrecedent(Passeport passeportPrecedent) {
        this.passeportPrecedent = passeportPrecedent;
    }

    public String getNumeroPasse() {
        return numeroPasse;
    }

    public void setNumeroPasse(String numeroPasse) {
        this.numeroPasse = numeroPasse;
    }

    public LocalDate getDateDelivrance() {
        return dateDelivrance;
    }

    public void setDateDelivrance(LocalDate dateDelivrance) {
        this.dateDelivrance = dateDelivrance;
    }

    public LocalDate getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(LocalDate dateExpiration) {
        this.dateExpiration = dateExpiration;
    }

    public String getPaysDelivrance() {
        return paysDelivrance;
    }

    public void setPaysDelivrance(String paysDelivrance) {
        this.paysDelivrance = paysDelivrance;
    }

    public Boolean getEstActif() {
        return estActif;
    }

    public void setEstActif(Boolean estActif) {
        this.estActif = estActif;
    }

    public boolean isValide() {
        return estActif != null && estActif && dateExpiration != null && dateExpiration.isAfter(LocalDate.now());
    }
}
