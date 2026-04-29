package com.sprint.app.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sprint.app.entity.Demande;
import com.sprint.app.entity.Demandeur;
import com.sprint.app.entity.MotifDuplicate;
import com.sprint.app.entity.Passeport;
import com.sprint.app.entity.TypeDemande;
import com.sprint.app.entity.TypeDuplicate;
import com.sprint.app.entity.TypeVisa;
import com.sprint.app.repository.DemandeRepository;
import com.sprint.app.repository.DemandeurRepository;
import com.sprint.app.repository.MotifDuplicateRepository;
import com.sprint.app.repository.PasseportRepository;
import com.sprint.app.repository.TypeDemandeRepository;
import com.sprint.app.repository.TypeDuplicateRepository;
import com.sprint.app.repository.TypeVisaRepository;

@Service
public class DuplicataService {

    @Autowired
    private DemandeurRepository demandeurRepository;

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private TypeDemandeRepository typeDemandeRepository;

    @Autowired
    private TypeVisaRepository typeVisaRepository;

    @Autowired
    private MotifDuplicateRepository motifDuplicateRepository;

    @Autowired
    private TypeDuplicateRepository typeDuplicateRepository;

    @Autowired
    private PasseportRepository passeportRepository;

    /**
     * Rechercher un demandeur par email.
     * Retourne un Map avec les infos du demandeur et de son dernier passeport (s'il existe).
     */
    public Map<String, Object> findDemandeurByEmail(String email) {
        Map<String, Object> result = new HashMap<>();
        result.put("found", false);

        Optional<Demandeur> demandeur = demandeurRepository.findByEmail(email);
        if (demandeur.isPresent()) {
            Demandeur d = demandeur.get();
            result.put("found", true);
            result.put("id", d.getId());
            result.put("nom", d.getNom());
            result.put("prenom", d.getPrenom());
            result.put("dateNaissance", d.getDateNaissance());
            result.put("lieuNaissance", d.getLieuNaissance());
            result.put("profession", d.getProfession());
            result.put("telephone", d.getTelephone());
            result.put("email", d.getEmail());
            result.put("adresse", d.getAdresse());
            result.put("situationFamiliale", d.getSituationFamiliale().getId());
            result.put("nationalite", d.getNationalite().getId());

            // Récupérer le dernier passeport actif
            List<Passeport> passeports = d.getPasseports();
            if (!passeports.isEmpty()) {
                Passeport lastPassport = passeports.stream()
                        .filter(Passeport::getEstActif)
                        .findFirst()
                        .orElse(passeports.get(0));

                result.put("dernierePasseport", lastPassport.getId());
                result.put("dernierNumeroPasseport", lastPassport.getNumeroPasse());
                result.put("dernierDateExpiration", lastPassport.getDateExpiration());
            }
        }

        return result;
    }

    /**
     * Créer une demande de duplicata.
     * Si l'utilisateur existe, ses données sont pré-remplies.
     * Le statut est directement "approuvée".
     */
    @Transactional
    public Demande creerDemandeDuplicate(
            Integer demandeurId,
            Integer motifDuplicateId,
            Integer typeDuplicateId,
            String nouveauNumeroPasseport,
            String observations) {

        // Récupérer le demandeur
        Demandeur demandeur = demandeurRepository.findById(demandeurId)
                .orElseThrow(() -> new IllegalArgumentException("Demandeur non trouvé"));

        // Récupérer le motif et le type de duplicata
        MotifDuplicate motifDuplicate = motifDuplicateRepository.findById(motifDuplicateId)
                .orElseThrow(() -> new IllegalArgumentException("Motif de duplicata non trouvé"));

        TypeDuplicate typeDuplicate = typeDuplicateRepository.findById(typeDuplicateId)
                .orElseThrow(() -> new IllegalArgumentException("Type de duplicata non trouvé"));

        // Pour les demandes de duplicata, on utilise le type de demande "Duplicata de carte de resident"
        // ou "Transfert de VISA" selon le type
        TypeDemande typeDemande = null;
        TypeVisa typeVisa = null;

        if (typeDuplicate.getLibelle().contains("Transfert")) {
            typeDemande = typeDemandeRepository.findByLibelle("Transfert de VISA");
            typeVisa = typeVisaRepository.findByLibelle("VISA Etudiant"); // Default, à adapter selon le besoin
        } else {
            typeDemande = typeDemandeRepository.findByLibelle("Duplicata de carte de resident");
            typeVisa = typeVisaRepository.findByLibelle("VISA Etudiant"); // Default
        }

        if (typeDemande == null || typeVisa == null) {
            throw new IllegalStateException("Type de demande ou type de visa non trouvé");
        }

        // Créer la demande
        Demande demande = new Demande();
        demande.setDemandeur(demandeur);
        demande.setTypeDemande(typeDemande);
        demande.setTypeVisa(typeVisa);
        demande.setMotifDuplicate(motifDuplicate);
        demande.setTypeDuplicate(typeDuplicate);
        demande.setNouveauNumeroPasseport(nouveauNumeroPasseport);
        demande.setObservations(observations);
        demande.setDateDemande(LocalDateTime.now());
        demande.setStatut("approuvee"); // Statut directement approuvé pour duplicata
        demande.setSansDonnees(false);

        return demandeRepository.save(demande);
    }

    /**
     * Récupérer tous les motifs de duplicata.
     */
    public List<MotifDuplicate> getAllMotifs() {
        return motifDuplicateRepository.findAll();
    }

    /**
     * Récupérer tous les types de duplicata.
     */
    public List<TypeDuplicate> getAllTypes() {
        return typeDuplicateRepository.findAll();
    }

    /**
     * Récupérer un motif de duplicata par ID.
     */
    public MotifDuplicate getMotifById(Integer id) {
        return motifDuplicateRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Motif de duplicata non trouvé"));
    }
}
