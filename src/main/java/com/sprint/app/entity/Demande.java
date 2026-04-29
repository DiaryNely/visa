package com.sprint.app.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

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

    @Column(name = "statut_scan", nullable = false, length = 30)
    private String statutScan = "EN_COURS_DE_SCAN";

    @Column(name = "est_verrouille", nullable = false)
    private Boolean estVerrouille = false;

    @Column(name = "date_scan_termine")
    private LocalDate dateScanTermine;

    public Demande() {
    }

    // Sprint 2 - Duplicata fields
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_motif_duplicata")
    private MotifDuplicate motifDuplicate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_type_duplicata")
    private TypeDuplicate typeDuplicate;

    @Column(name = "nouveau_numero_passeport", length = 50)
    private String nouveauNumeroPasseport;
    @Column(name = "qr_code_url", columnDefinition = "TEXT")
    private String qrCodeUrl;

    @Column(name = "qr_code_image_base64", columnDefinition = "TEXT")
    private String qrCodeImageBase64;

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

    // Sprint 2 - Duplicata getters & setters
    public MotifDuplicate getMotifDuplicate() {
        return motifDuplicate;
    }

    public void setMotifDuplicate(MotifDuplicate motifDuplicate) {
        this.motifDuplicate = motifDuplicate;
    }

    public TypeDuplicate getTypeDuplicate() {
        return typeDuplicate;
    }

    public void setTypeDuplicate(TypeDuplicate typeDuplicate) {
        this.typeDuplicate = typeDuplicate;
    }

    public String getNouveauNumeroPasseport() {
        return nouveauNumeroPasseport;
    }

    public void setNouveauNumeroPasseport(String nouveauNumeroPasseport) {
        this.nouveauNumeroPasseport = nouveauNumeroPasseport;
    }

    public String getStatutScan() {
        return statutScan;
    }

    public void setStatutScan(String statutScan) {
        this.statutScan = statutScan;
    }

    public Boolean getEstVerrouille() {
        return estVerrouille;
    }

    public void setEstVerrouille(Boolean estVerrouille) {
        this.estVerrouille = estVerrouille;
    }

    public LocalDate getDateScanTermine() {
        return dateScanTermine;
    }

    public void setDateScanTermine(LocalDate dateScanTermine) {
        this.dateScanTermine = dateScanTermine;
    }

    public String getStatutLabel() {
        if (statut == null)
            return "";
        return switch (statut) {
            case "brouillon" -> "Brouillon";
            case "soumise" -> "Soumise";
            case "en_cours" -> "En cours";
            case "validee" -> "Validée";
            case "approuvee" -> "Approuvée";
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
            case "approuvee" -> "badge-success";
            case "rejetee" -> "badge-danger";
            default -> "badge-secondary";
        };
    }

    public String getStatutScanLabel() {
        if (statutScan == null)
            return "";
        return switch (statutScan) {
            case "EN_COURS_DE_SCAN" -> "En cours de scan";
            case "SCAN_TERMINE" -> "Scan terminé";
            case "DOSSIER_VERROUILLE" -> "Dossier verrouillé";
            default -> statutScan;
        };
    }

    public String getStatutScanBadgeClass() {
        if (statutScan == null)
            return "badge-secondary";
        return switch (statutScan) {
            case "EN_COURS_DE_SCAN" -> "badge-info";
            case "SCAN_TERMINE" -> "badge-warning";
            case "DOSSIER_VERROUILLE" -> "badge-success";
            default -> "badge-secondary";
        };
    }
}
