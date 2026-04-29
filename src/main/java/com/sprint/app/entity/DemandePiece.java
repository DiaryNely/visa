package com.sprint.app.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "demande_piece")
public class DemandePiece {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_demande", nullable = false)
    private Demande demande;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_piece", nullable = false)
    private PieceJustificative piece;

    @Column(nullable = false)
    private Boolean fournie = false;

    @Column(name = "date_fourniture")
    private LocalDate dateFourniture;

    @Column(name = "statut_scan", nullable = false, length = 30)
    private String statutScan = "EN_ATTENTE";

    @Column(name = "date_scan")
    private LocalDate dateScan;

    @Column(name = "chemin_fichier", length = 255)
    private String cheminFichier;

    public DemandePiece() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Demande getDemande() { return demande; }
    public void setDemande(Demande demande) { this.demande = demande; }

    public PieceJustificative getPiece() { return piece; }
    public void setPiece(PieceJustificative piece) { this.piece = piece; }

    public Boolean getFournie() { return fournie; }
    public void setFournie(Boolean fournie) { this.fournie = fournie; }

    public LocalDate getDateFourniture() { return dateFourniture; }
    public void setDateFourniture(LocalDate dateFourniture) { this.dateFourniture = dateFourniture; }

    public String getStatutScan() { return statutScan; }
    public void setStatutScan(String statutScan) { this.statutScan = statutScan; }

    public LocalDate getDateScan() { return dateScan; }
    public void setDateScan(LocalDate dateScan) { this.dateScan = dateScan; }

    public String getCheminFichier() { return cheminFichier; }
    public void setCheminFichier(String cheminFichier) { this.cheminFichier = cheminFichier; }
}
