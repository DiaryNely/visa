package com.sprint.app.service;

import java.text.Normalizer;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sprint.app.entity.Demande;
import com.sprint.app.entity.DemandePiece;
import com.sprint.app.entity.Demandeur;
import com.sprint.app.entity.PieceJustificative;
import com.sprint.app.entity.StatutDemande;
import com.sprint.app.entity.TypeDemande;
import com.sprint.app.entity.TypeProfil;
import com.sprint.app.entity.TypeVisa;
import com.sprint.app.entity.VisaTransformable;
import com.sprint.app.repository.DemandePieceRepository;
import com.sprint.app.repository.DemandeRepository;
import com.sprint.app.repository.DemandeurRepository;
import com.sprint.app.repository.PieceJustificativeRepository;
import com.sprint.app.repository.StatutDemandeRepository;
import com.sprint.app.repository.TypeDemandeRepository;
import com.sprint.app.repository.TypeProfilRepository;
import com.sprint.app.repository.TypeVisaRepository;
import com.sprint.app.repository.VisaTransformableRepository;

@Service
public class DemandeService {

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private StatutDemandeRepository statutDemandeRepository;

    @Autowired
    private VisaTransformableRepository visaTransformableRepository;

    @Autowired
    private TypeDemandeRepository typeDemandeRepository;

    @Autowired
    private TypeVisaRepository typeVisaRepository;

    @Autowired
    private TypeProfilRepository typeProfilRepository;

    @Autowired
    private DemandeurRepository demandeurRepository;

    @Autowired
    private PieceJustificativeRepository pieceJustificativeRepository;

    @Autowired
    private DemandePieceRepository demandePieceRepository;

    // ==================== CRUD ====================

    public List<Demande> findAll() {
        return demandeRepository.findAllOrderByDateDemandeDesc();
    }

    public Optional<Demande> findById(Integer id) {
        return demandeRepository.findById(id);
    }

    public List<Demande> findByStatut(String statut) {
        return demandeRepository.findByStatut(statut);
    }

    public List<Demande> findByDemandeurId(Integer demandeurId) {
        return demandeRepository.findByDemandeurId(demandeurId);
    }

    public Optional<Demande> findDerniereDemandeParDemandeur(Integer demandeurId) {
        return demandeRepository.findTopByDemandeurIdOrderByDateDemandeDesc(demandeurId);
    }

    // ==================== CRÉATION ====================

    /**
     * Créer une nouvelle demande avec toutes les règles métier.
     * 
     * Règles :
     * 1. Le VISA transformable doit être valide (passeport non expiré)
     * 2. Pour "Nouvelle demande" et "Transfert" : si aucune donnée antérieure,
     * la demande est marquée comme sans_donnees = true
     * 3. La demande est créée avec le statut "brouillon"
     */
    @Transactional
    public Demande creerDemande(Integer demandeurId, Integer typeDemandeId, Integer typeVisaId,
            Integer typeProfilId, Integer visaTransformableId, String observations)
            throws IllegalStateException {

        // Charger les entités
        Demandeur demandeur = demandeurRepository.findById(demandeurId)
                .orElseThrow(() -> new IllegalStateException("Demandeur introuvable"));

        TypeDemande typeDemande = typeDemandeRepository.findById(typeDemandeId)
                .orElseThrow(() -> new IllegalStateException("Type de demande introuvable"));

        TypeVisa typeVisa = typeVisaRepository.findById(typeVisaId)
                .orElseThrow(() -> new IllegalStateException("Type de VISA introuvable"));

        // Sprint 1: seuls les VISA etudiant et travailleur sont autorises.
        String libelleVisa = typeVisa.getLibelle() == null ? "" : typeVisa.getLibelle().toLowerCase();
        boolean visaAutorise = libelleVisa.contains("etudiant") || libelleVisa.contains("étudiant")
                || libelleVisa.contains("travailleur");
        if (!visaAutorise) {
            throw new IllegalStateException("Sprint 1 autorise uniquement les VISA etudiant et travailleur");
        }

        // Regle metier: toute demande exige un VISA transformable valide.
        if (visaTransformableId == null) {
            throw new IllegalStateException("Un VISA transformable valide est obligatoire pour creer une demande");
        }
        VisaTransformable visaTransformable = visaTransformableRepository.findById(visaTransformableId)
                .orElseThrow(() -> new IllegalStateException("VISA transformable introuvable"));

        if (!visaTransformable.isValide()) {
            throw new IllegalStateException(
                    "Le VISA transformable n'est plus valide. Le passeport associe est expire ou inactif.");
        }

        // Charger le type de profil si fourni
        TypeProfil typeProfil = null;
        if (typeProfilId != null) {
            typeProfil = typeProfilRepository.findById(typeProfilId).orElse(null);
        }

        // RÈGLE MÉTIER : Déterminer si c'est sans données antérieures
        boolean sansDonnees = false;
        if (typeDemande.getNecessiteSansDonnees()) {
            // Pour "Nouvelle demande" et "Transfert" : vérifier s'il existe des demandes
            // antérieures
            List<Demande> demandesAnterieures = demandeRepository
                    .findByDemandeurIdAndTypeDemandeId(demandeurId, typeDemandeId);
            // Filtrer les demandes validées
            boolean hasDonneesAnterieures = demandesAnterieures.stream()
                    .anyMatch(d -> "validee".equals(d.getStatut()));
            sansDonnees = !hasDonneesAnterieures;
        }

        // Créer la demande
        Demande demande = new Demande();
        demande.setDemandeur(demandeur);
        demande.setTypeDemande(typeDemande);
        demande.setTypeVisa(typeVisa);
        demande.setTypeProfil(typeProfil);
        demande.setVisaTransformable(visaTransformable);
        demande.setDateDemande(LocalDateTime.now());
        demande.setStatut("brouillon");
        demande.setSansDonnees(sansDonnees);
        demande.setObservations(observations);

        demande = demandeRepository.save(demande);

        // Créer l'entrée d'historique initiale
        creerHistoriqueStatut(demande, "brouillon");

        return demande;
    }

    // ==================== GESTION DES STATUTS ====================

    /**
     * Soumettre une demande (brouillon → soumise)
     */
    @Transactional
    public Demande soumettreDemande(Integer demandeId) throws IllegalStateException {
        Demande demande = demandeRepository.findById(demandeId)
                .orElseThrow(() -> new IllegalStateException("Demande introuvable"));

        if (!"brouillon".equals(demande.getStatut())) {
            throw new IllegalStateException("Seule une demande en brouillon peut être soumise");
        }

        // Vérifier que le VISA transformable est toujours valide
        if (demande.getVisaTransformable() != null && !demande.getVisaTransformable().isValide()) {
            throw new IllegalStateException("Le VISA transformable n'est plus valide");
        }

        demande.setStatut("soumise");
        demande = demandeRepository.save(demande);
        creerHistoriqueStatut(demande, "soumise");
        return demande;
    }

    /**
     * Changer le statut d'une demande avec validation des transitions.
     */
    @Transactional
    public Demande changerStatut(Integer demandeId, String nouveauStatut, String motifRejet)
            throws IllegalStateException {

        Demande demande = demandeRepository.findById(demandeId)
                .orElseThrow(() -> new IllegalStateException("Demande introuvable"));

        String statutActuel = demande.getStatut();

        // Valider la transition
        if (!isTransitionValide(statutActuel, nouveauStatut)) {
            throw new IllegalStateException(
                    String.format("Transition invalide : %s → %s", statutActuel, nouveauStatut));
        }

        // Si rejetée, un motif est requis
        if ("rejetee".equals(nouveauStatut)) {
            if (motifRejet == null || motifRejet.trim().isEmpty()) {
                throw new IllegalStateException("Un motif de rejet est requis");
            }
            demande.setMotifRejet(motifRejet);
        }

        // Si validée ou rejetée, enregistrer la date de traitement
        if ("validee".equals(nouveauStatut) || "rejetee".equals(nouveauStatut)) {
            demande.setDateTraitement(LocalDate.now());
        }

        demande.setStatut(nouveauStatut);
        demande = demandeRepository.save(demande);
        creerHistoriqueStatut(demande, nouveauStatut);

        return demande;
    }

    /**
     * Vérifie si une transition de statut est valide.
     * brouillon → soumise → en_cours → validee | rejetee
     */
    private boolean isTransitionValide(String statutActuel, String nouveauStatut) {
        return switch (statutActuel) {
            case "brouillon" -> "soumise".equals(nouveauStatut);
            case "soumise" -> "en_cours".equals(nouveauStatut) || "rejetee".equals(nouveauStatut);
            case "en_cours" -> "validee".equals(nouveauStatut) || "rejetee".equals(nouveauStatut);
            default -> false;
        };
    }

    private void creerHistoriqueStatut(Demande demande, String statut) {
        StatutDemande statutDemande = new StatutDemande(demande, statut, LocalDate.now());
        statutDemandeRepository.save(statutDemande);
    }

    // ==================== HISTORIQUE ====================

    public List<StatutDemande> getHistoriqueStatuts(Integer demandeId) {
        return statutDemandeRepository.findByDemandeIdOrderByDateChangementStatutDesc(demandeId);
    }

    // ==================== STATISTIQUES ====================

    public Map<String, Long> getStatistiques() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("total", demandeRepository.count());
        stats.put("brouillon", demandeRepository.countByStatut("brouillon"));
        stats.put("soumise", demandeRepository.countByStatut("soumise"));
        stats.put("en_cours", demandeRepository.countByStatut("en_cours"));
        stats.put("validee", demandeRepository.countByStatut("validee"));
        stats.put("rejetee", demandeRepository.countByStatut("rejetee"));
        return stats;
    }

    // ==================== DONNÉES DE RÉFÉRENCE ====================

    public List<TypeDemande> getAllTypesDemande() {
        return typeDemandeRepository.findAll();
    }

    public List<TypeVisa> getAllTypesVisa() {
        return typeVisaRepository.findAll();
    }

    public List<TypeProfil> getAllTypesProfil() {
        return typeProfilRepository.findAll();
    }

    // ==================== PIECES JUSTIFICATIVES ====================

    public List<PieceJustificative> getPiecesJustificatives(Integer typeDemandeId, Integer typeVisaId) {
        TypeVisa typeVisa = typeVisaRepository.findById(typeVisaId)
                .orElseThrow(() -> new IllegalStateException("Type de VISA introuvable"));

        String visaNormalise = normalize(typeVisa.getLibelle());
        String profilAttendu = visaNormalise.contains("travailleur") ? "travailleur" : "etudiant";

        List<PieceJustificative> pieces = pieceJustificativeRepository
                .findByTypeDemandeIdOrderByObligatoireDescLibelleAsc(typeDemandeId);

        return pieces.stream()
                .filter(piece -> {
                    if (piece.getTypeProfil() == null) {
                        return true;
                    }
                    String profilNormalise = normalize(piece.getTypeProfil().getLibelle());
                    return profilNormalise.contains(profilAttendu);
                })
                .toList();
    }

    @Transactional
    public void enregistrerPiecesPourDemande(Demande demande, List<Integer> pieceIdsCochees) {
        List<PieceJustificative> piecesAttendues = getPiecesJustificatives(
                demande.getTypeDemande().getId(),
                demande.getTypeVisa().getId());

        Set<Integer> idsCoches = pieceIdsCochees == null
                ? new HashSet<>()
                : new HashSet<>(pieceIdsCochees);

        List<String> obligatoiresManquantes = piecesAttendues.stream()
                .filter(p -> Boolean.TRUE.equals(p.getObligatoire()) && !idsCoches.contains(p.getId()))
                .map(PieceJustificative::getLibelle)
                .toList();

        if (!obligatoiresManquantes.isEmpty()) {
            throw new IllegalStateException(
                    "Pieces justificatives obligatoires manquantes: " + String.join(", ", obligatoiresManquantes));
        }

        List<DemandePiece> demandePieces = new ArrayList<>();
        for (PieceJustificative piece : piecesAttendues) {
            DemandePiece dp = new DemandePiece();
            dp.setDemande(demande);
            dp.setPiece(piece);

            boolean fournie = idsCoches.contains(piece.getId());
            dp.setFournie(fournie);
            dp.setDateFourniture(fournie ? LocalDate.now() : null);
            demandePieces.add(dp);
        }

        demandePieceRepository.saveAll(demandePieces);
    }

    private String normalize(String value) {
        if (value == null) {
            return "";
        }
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");
        return normalized.toLowerCase();
    }
}
