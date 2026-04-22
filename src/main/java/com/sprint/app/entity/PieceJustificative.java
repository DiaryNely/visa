package com.sprint.app.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "piece_justificative")
public class PieceJustificative {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_type_demande", nullable = false)
    private TypeDemande typeDemande;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_type_profil")
    private TypeProfil typeProfil;

    @Column(nullable = false, length = 100)
    private String libelle;

    @Column(nullable = false)
    private Boolean obligatoire = true;

    public PieceJustificative() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public TypeDemande getTypeDemande() { return typeDemande; }
    public void setTypeDemande(TypeDemande typeDemande) { this.typeDemande = typeDemande; }

    public TypeProfil getTypeProfil() { return typeProfil; }
    public void setTypeProfil(TypeProfil typeProfil) { this.typeProfil = typeProfil; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Boolean getObligatoire() { return obligatoire; }
    public void setObligatoire(Boolean obligatoire) { this.obligatoire = obligatoire; }
}
