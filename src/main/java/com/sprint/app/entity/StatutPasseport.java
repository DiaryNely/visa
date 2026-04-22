package com.sprint.app.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "statut_passeport")
public class StatutPasseport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_passeport", nullable = false)
    private Passeport passeport;

    @Column(nullable = false, length = 20)
    private String statut;

    @Column(name = "date_changement_statut")
    private LocalDate dateChangementStatut;

    public StatutPasseport() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Passeport getPasseport() { return passeport; }
    public void setPasseport(Passeport passeport) { this.passeport = passeport; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public LocalDate getDateChangementStatut() { return dateChangementStatut; }
    public void setDateChangementStatut(LocalDate dateChangementStatut) { this.dateChangementStatut = dateChangementStatut; }
}
