package com.sprint.app.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "demande")
public class Demande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_visa_transformable")
    private VisaTransformable visaTransformable;

    @Column(name = "date_demande", nullable = false)
    private LocalDateTime dateDemande;

    @Column(nullable = false, length = 30)
    private String statut;

    @Column(name = "sans_donnees", nullable = false)
    private Boolean sansDonnees = false;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_demandeur", nullable = false)
    private Demandeur demandeur;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_type_visa", nullable = false)
    private TypeVisa typeVisa;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_type_demande", nullable = false)
    private TypeDemande typeDemande;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_type_profil")
    private TypeProfil typeProfil;

    @Column(name = "date_traitement")
    private LocalDate dateTraitement;

    @Column(columnDefinition = "TEXT")
    private String observations;

    @Column(name = "motif_rejet", columnDefinition = "TEXT")
    private String motifRejet;

    @Column(name = "qr_code_url", columnDefinition = "TEXT")
    private String qrCodeUrl;

    @Column(name = "qr_code_image_base64", columnDefinition = "TEXT")
    private String qrCodeImageBase64;

    public Demande() {
    }

    // Getters & Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public VisaTransformable getVisaTransformable() {
        return visaTransformable;
    }

    public void setVisaTransformable(VisaTransformable visaTransformable) {
        this.visaTransformable = visaTransformable;
    }

    public LocalDateTime getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(LocalDateTime dateDemande) {
        this.dateDemande = dateDemande;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Boolean getSansDonnees() {
        return sansDonnees;
    }

    public void setSansDonnees(Boolean sansDonnees) {
        this.sansDonnees = sansDonnees;
    }

    public Demandeur getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(Demandeur demandeur) {
        this.demandeur = demandeur;
    }

    public TypeVisa getTypeVisa() {
        return typeVisa;
    }

    public void setTypeVisa(TypeVisa typeVisa) {
        this.typeVisa = typeVisa;
    }

    public TypeDemande getTypeDemande() {
        return typeDemande;
    }

    public void setTypeDemande(TypeDemande typeDemande) {
        this.typeDemande = typeDemande;
    }

    public TypeProfil getTypeProfil() {
        return typeProfil;
    }

    public void setTypeProfil(TypeProfil typeProfil) {
        this.typeProfil = typeProfil;
    }

    public LocalDate getDateTraitement() {
        return dateTraitement;
    }

    public void setDateTraitement(LocalDate dateTraitement) {
        this.dateTraitement = dateTraitement;
    }

    public String getObservations() {
        return observations;
    }

    public void setObservations(String observations) {
        this.observations = observations;
    }

    public String getMotifRejet() {
        return motifRejet;
    }

    public void setMotifRejet(String motifRejet) {
        this.motifRejet = motifRejet;
    }

    public String getQrCodeUrl() {
        return qrCodeUrl;
    }

    public void setQrCodeUrl(String qrCodeUrl) {
        this.qrCodeUrl = qrCodeUrl;
    }

    public String getQrCodeImageBase64() {
        return qrCodeImageBase64;
    }

    public void setQrCodeImageBase64(String qrCodeImageBase64) {
        this.qrCodeImageBase64 = qrCodeImageBase64;
    }

    public String getStatutLabel() {
        if (statut == null)
            return "";
        return switch (statut) {
            case "brouillon" -> "Brouillon";
            case "soumise" -> "Soumise";
            case "en_cours" -> "En cours";
            case "validee" -> "Validée";
            case "rejetee" -> "Rejetée";
            default -> statut;
        };
    }

    public String getStatutBadgeClass() {
        if (statut == null)
            return "badge-secondary";
        return switch (statut) {
            case "brouillon" -> "badge-secondary";
            case "soumise" -> "badge-info";
            case "en_cours" -> "badge-warning";
            case "validee" -> "badge-success";
            case "rejetee" -> "badge-danger";
            default -> "badge-secondary";
        };
    }
}
