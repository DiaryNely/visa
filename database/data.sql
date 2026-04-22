-- Active: 1773918989869@@127.0.0.1@5432@sprint_db
-- ============================================
-- Données de référence — Sprint 1
-- ============================================

-- Nationalités
INSERT INTO Nationalite (libelle) VALUES ('Française') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Malgache') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Camerounaise') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Sénégalaise') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Ivoirienne') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Congolaise') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Tunisienne') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Marocaine') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Chinoise') ON CONFLICT DO NOTHING;
INSERT INTO Nationalite (libelle) VALUES ('Indienne') ON CONFLICT DO NOTHING;

-- Situations familiales
INSERT INTO Situation_familiale (libelle) VALUES ('Célibataire') ON CONFLICT DO NOTHING;
INSERT INTO Situation_familiale (libelle) VALUES ('Marié(e)') ON CONFLICT DO NOTHING;
INSERT INTO Situation_familiale (libelle) VALUES ('Divorcé(e)') ON CONFLICT DO NOTHING;
INSERT INTO Situation_familiale (libelle) VALUES ('Veuf(ve)') ON CONFLICT DO NOTHING;

-- Types de VISA
INSERT INTO Type_visa (libelle, duree_validite) VALUES ('VISA Étudiant', 12) ON CONFLICT DO NOTHING;
INSERT INTO Type_visa (libelle, duree_validite) VALUES ('VISA Travailleur', 24) ON CONFLICT DO NOTHING;

-- Types de demande
INSERT INTO Type_demande (libelle, necessite_sans_donnees) VALUES ('Nouvelle demande de titre', TRUE) ON CONFLICT DO NOTHING;
INSERT INTO Type_demande (libelle, necessite_sans_donnees) VALUES ('Transfert de VISA', TRUE) ON CONFLICT DO NOTHING;
INSERT INTO Type_demande (libelle, necessite_sans_donnees) VALUES ('Duplicata de carte de résident', FALSE) ON CONFLICT DO NOTHING;

-- Types de profil
INSERT INTO Type_profil (libelle) VALUES ('Étudiant') ON CONFLICT DO NOTHING;
INSERT INTO Type_profil (libelle) VALUES ('Travailleur salarié') ON CONFLICT DO NOTHING;
INSERT INTO Type_profil (libelle) VALUES ('Travailleur indépendant') ON CONFLICT DO NOTHING;
INSERT INTO Type_profil (libelle) VALUES ('Investisseur') ON CONFLICT DO NOTHING;
INSERT INTO Type_profil (libelle) VALUES ('Retraité') ON CONFLICT DO NOTHING;
INSERT INTO Type_profil (libelle) VALUES ('Conjoint de national') ON CONFLICT DO NOTHING;

-- ============================================
-- Données de test
-- ============================================

-- Demandeur 1
INSERT INTO Demandeur (nom, prenom, date_naissance, lieu_naissance, profession, telephone, email, adresse, id_situation_familiale, id_nationalite)
VALUES ('RAKOTO', 'Jean', '1990-05-15', 'Antananarivo, Madagascar', 'Ingénieur informatique', '+261 34 12 345 67', 'jean.rakoto@email.com', '123 Rue Rainandriamampandry, Antananarivo', 1, 2)
ON CONFLICT DO NOTHING;

-- Demandeur 2
INSERT INTO Demandeur (nom, prenom, date_naissance, lieu_naissance, profession, telephone, email, adresse, id_situation_familiale, id_nationalite)
VALUES ('MARTIN', 'Sophie', '1988-11-22', 'Lyon, France', 'Enseignante', '+33 6 12 34 56 78', 'sophie.martin@email.com', '45 Avenue de la République, Lyon', 2, 1)
ON CONFLICT DO NOTHING;

-- Demandeur 3
INSERT INTO Demandeur (nom, prenom, date_naissance, lieu_naissance, profession, telephone, email, adresse, id_situation_familiale, id_nationalite)
VALUES ('DIALLO', 'Moussa', '1995-03-08', 'Dakar, Sénégal', 'Étudiant', '+221 77 123 45 67', 'moussa.diallo@email.com', '12 Rue de Médina, Dakar', 1, 4)
ON CONFLICT DO NOTHING;

-- Passeports
INSERT INTO Passeport (id_demandeur, numero_passeport, date_delivrance, date_expiration, pays_delivrance, est_actif)
VALUES (1, 'MG-2022-001234', '2022-01-15', '2032-01-14', 'Madagascar', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO Passeport (id_demandeur, numero_passeport, date_delivrance, date_expiration, pays_delivrance, est_actif)
VALUES (2, 'FR-2021-567890', '2021-06-20', '2031-06-19', 'France', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO Passeport (id_demandeur, numero_passeport, date_delivrance, date_expiration, pays_delivrance, est_actif)
VALUES (3, 'SN-2023-112233', '2023-03-10', '2033-03-09', 'Sénégal', TRUE)
ON CONFLICT DO NOTHING;

-- VISA Transformables
INSERT INTO Visa_transformable (id_demandeur, id_passeport, numero_reference)
VALUES (1, 1, 'VT-2024-MG-0001')
ON CONFLICT DO NOTHING;

INSERT INTO Visa_transformable (id_demandeur, id_passeport, numero_reference)
VALUES (2, 2, 'VT-2024-FR-0002')
ON CONFLICT DO NOTHING;

INSERT INTO Visa_transformable (id_demandeur, id_passeport, numero_reference)
VALUES (3, 3, 'VT-2025-SN-0003')
ON CONFLICT DO NOTHING;

-- Demandes de test
INSERT INTO Demande (id_visa_transformable, date_demande, statut, sans_donnees, id_demandeur, id_type_visa, id_type_demande, id_type_profil, observations)
VALUES (1, '2025-04-10 09:30:00', 'en_cours', TRUE, 1, 2, 1, 2, 'Demandeur dispose d un contrat de travail valide')
ON CONFLICT DO NOTHING;

INSERT INTO Demande (id_visa_transformable, date_demande, statut, sans_donnees, id_demandeur, id_type_visa, id_type_demande, id_type_profil, observations)
VALUES (2, '2025-04-12 14:00:00', 'soumise', TRUE, 2, 1, 1, 1, 'Demande pour inscription universitaire')
ON CONFLICT DO NOTHING;

INSERT INTO Demande (id_visa_transformable, date_demande, statut, sans_donnees, id_demandeur, id_type_visa, id_type_demande, date_traitement, observations)
VALUES (3, '2025-03-20 10:15:00', 'validee', FALSE, 3, 1, 2, '2025-04-01', 'Transfert suite au changement de passeport')
ON CONFLICT DO NOTHING;

INSERT INTO Demande (id_visa_transformable, date_demande, statut, sans_donnees, id_demandeur, id_type_visa, id_type_demande, date_traitement, motif_rejet)
VALUES (1, '2025-02-05 11:00:00', 'rejetee', TRUE, 1, 1, 1, '2025-02-20', 'Dossier incomplet - pièces justificatives manquantes')
ON CONFLICT DO NOTHING;

-- Historique des statuts
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (1, 'brouillon', '2025-04-10') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (1, 'soumise', '2025-04-10') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (1, 'en_cours', '2025-04-11') ON CONFLICT DO NOTHING;

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (2, 'brouillon', '2025-04-12') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (2, 'soumise', '2025-04-12') ON CONFLICT DO NOTHING;

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (3, 'brouillon', '2025-03-20') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (3, 'soumise', '2025-03-20') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (3, 'en_cours', '2025-03-25') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (3, 'validee', '2025-04-01') ON CONFLICT DO NOTHING;

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (4, 'brouillon', '2025-02-05') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (4, 'soumise', '2025-02-05') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (4, 'en_cours', '2025-02-10') ON CONFLICT DO NOTHING;
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut) VALUES (4, 'rejetee', '2025-02-20') ON CONFLICT DO NOTHING;
