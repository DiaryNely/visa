-- ============================================
-- Reference data - Sprint 1 (PostgreSQL)
-- Safe version: ASCII only + no hard-coded FK ids
-- ============================================

BEGIN;

-- Nationalites
INSERT INTO Nationalite (libelle)
SELECT 'Francaise' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Francaise');
INSERT INTO Nationalite (libelle)
SELECT 'Malgache' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Malgache');
INSERT INTO Nationalite (libelle)
SELECT 'Camerounaise' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Camerounaise');
INSERT INTO Nationalite (libelle)
SELECT 'Senegalaise' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Senegalaise');
INSERT INTO Nationalite (libelle)
SELECT 'Ivoirienne' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Ivoirienne');
INSERT INTO Nationalite (libelle)
SELECT 'Congolaise' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Congolaise');
INSERT INTO Nationalite (libelle)
SELECT 'Tunisienne' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Tunisienne');
INSERT INTO Nationalite (libelle)
SELECT 'Marocaine' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Marocaine');
INSERT INTO Nationalite (libelle)
SELECT 'Chinoise' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Chinoise');
INSERT INTO Nationalite (libelle)
SELECT 'Indienne' WHERE NOT EXISTS (SELECT 1 FROM Nationalite WHERE libelle = 'Indienne');

-- Situations familiales
INSERT INTO Situation_familiale (libelle)
SELECT 'Celibataire' WHERE NOT EXISTS (SELECT 1 FROM Situation_familiale WHERE libelle = 'Celibataire');
INSERT INTO Situation_familiale (libelle)
SELECT 'Marie(e)' WHERE NOT EXISTS (SELECT 1 FROM Situation_familiale WHERE libelle = 'Marie(e)');
INSERT INTO Situation_familiale (libelle)
SELECT 'Divorce(e)' WHERE NOT EXISTS (SELECT 1 FROM Situation_familiale WHERE libelle = 'Divorce(e)');
INSERT INTO Situation_familiale (libelle)
SELECT 'Veuf(ve)' WHERE NOT EXISTS (SELECT 1 FROM Situation_familiale WHERE libelle = 'Veuf(ve)');

-- Types de visa (Sprint 1)
INSERT INTO Type_visa (libelle, duree_validite)
SELECT 'VISA Etudiant', 12
WHERE NOT EXISTS (SELECT 1 FROM Type_visa WHERE libelle = 'VISA Etudiant');

INSERT INTO Type_visa (libelle, duree_validite)
SELECT 'VISA Travailleur', 24
WHERE NOT EXISTS (SELECT 1 FROM Type_visa WHERE libelle = 'VISA Travailleur');

-- Types de demande
INSERT INTO Type_demande (libelle, necessite_sans_donnees)
SELECT 'Nouvelle demande de titre', TRUE
WHERE NOT EXISTS (SELECT 1 FROM Type_demande WHERE libelle = 'Nouvelle demande de titre');

INSERT INTO Type_demande (libelle, necessite_sans_donnees)
SELECT 'Transfert de VISA', TRUE
WHERE NOT EXISTS (SELECT 1 FROM Type_demande WHERE libelle = 'Transfert de VISA');

INSERT INTO Type_demande (libelle, necessite_sans_donnees)
SELECT 'Duplicata de carte de resident', FALSE
WHERE NOT EXISTS (SELECT 1 FROM Type_demande WHERE libelle = 'Duplicata de carte de resident');

-- Types de profil
INSERT INTO Type_profil (libelle)
SELECT 'Etudiant' WHERE NOT EXISTS (SELECT 1 FROM Type_profil WHERE libelle = 'Etudiant');
INSERT INTO Type_profil (libelle)
SELECT 'Travailleur salarie' WHERE NOT EXISTS (SELECT 1 FROM Type_profil WHERE libelle = 'Travailleur salarie');
INSERT INTO Type_profil (libelle)
SELECT 'Travailleur independant' WHERE NOT EXISTS (SELECT 1 FROM Type_profil WHERE libelle = 'Travailleur independant');
INSERT INTO Type_profil (libelle)
SELECT 'Investisseur' WHERE NOT EXISTS (SELECT 1 FROM Type_profil WHERE libelle = 'Investisseur');
INSERT INTO Type_profil (libelle)
SELECT 'Retraite' WHERE NOT EXISTS (SELECT 1 FROM Type_profil WHERE libelle = 'Retraite');
INSERT INTO Type_profil (libelle)
SELECT 'Conjoint de national' WHERE NOT EXISTS (SELECT 1 FROM Type_profil WHERE libelle = 'Conjoint de national');

-- Pieces justificatives (type demande + profil)
INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, NULL, 'Formulaire de demande signe', TRUE
FROM Type_demande td
WHERE td.libelle = 'Nouvelle demande de titre'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil IS NULL AND p.libelle = 'Formulaire de demande signe'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, NULL, 'Copie du passeport en cours de validite', TRUE
FROM Type_demande td
WHERE td.libelle = 'Nouvelle demande de titre'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil IS NULL AND p.libelle = 'Copie du passeport en cours de validite'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, tp.id, 'Certificat de scolarite', TRUE
FROM Type_demande td
JOIN Type_profil tp ON tp.libelle = 'Etudiant'
WHERE td.libelle = 'Nouvelle demande de titre'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil = tp.id AND p.libelle = 'Certificat de scolarite'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, tp.id, 'Contrat de travail ou attestation employeur', TRUE
FROM Type_demande td
JOIN Type_profil tp ON tp.libelle = 'Travailleur salarie'
WHERE td.libelle = 'Nouvelle demande de titre'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil = tp.id AND p.libelle = 'Contrat de travail ou attestation employeur'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, tp.id, 'Justificatif d activite professionnelle', TRUE
FROM Type_demande td
JOIN Type_profil tp ON tp.libelle = 'Travailleur independant'
WHERE td.libelle = 'Nouvelle demande de titre'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil = tp.id AND p.libelle = 'Justificatif d activite professionnelle'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, NULL, 'Ancien titre de sejour ou preuve de detention', FALSE
FROM Type_demande td
WHERE td.libelle = 'Duplicata de carte de resident'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil IS NULL AND p.libelle = 'Ancien titre de sejour ou preuve de detention'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, NULL, 'Declaration de perte ou de vol', TRUE
FROM Type_demande td
WHERE td.libelle = 'Duplicata de carte de resident'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil IS NULL AND p.libelle = 'Declaration de perte ou de vol'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, NULL, 'Nouveau passeport', TRUE
FROM Type_demande td
WHERE td.libelle = 'Transfert de VISA'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil IS NULL AND p.libelle = 'Nouveau passeport'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, NULL, 'Copie de l ancien passeport', TRUE
FROM Type_demande td
WHERE td.libelle = 'Transfert de VISA'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil IS NULL AND p.libelle = 'Copie de l ancien passeport'
	);

INSERT INTO Piece_justificative (id_type_demande, id_type_profil, libelle, obligatoire)
SELECT td.id, NULL, 'Justificatif de domicile recent', FALSE
FROM Type_demande td
WHERE td.libelle = 'Transfert de VISA'
	AND NOT EXISTS (
			SELECT 1 FROM Piece_justificative p
			WHERE p.id_type_demande = td.id AND p.id_type_profil IS NULL AND p.libelle = 'Justificatif de domicile recent'
	);

-- ============================================
-- Donnees de test
-- ============================================

-- Demandeur 1
INSERT INTO Demandeur (
		nom, prenom, date_naissance, lieu_naissance, profession,
		telephone, email, adresse, id_situation_familiale, id_nationalite
)
SELECT
		'RAKOTO', 'Jean', DATE '1990-05-15', 'Antananarivo, Madagascar', 'Ingenieur informatique',
		'+261 34 12 345 67', 'jean.rakoto@email.com', '123 Rue Rainandriamampandry, Antananarivo',
		sf.id, n.id
FROM Situation_familiale sf
JOIN Nationalite n ON n.libelle = 'Malgache'
WHERE sf.libelle = 'Celibataire'
	AND NOT EXISTS (SELECT 1 FROM Demandeur d WHERE d.email = 'jean.rakoto@email.com');

-- Demandeur 2
INSERT INTO Demandeur (
		nom, prenom, date_naissance, lieu_naissance, profession,
		telephone, email, adresse, id_situation_familiale, id_nationalite
)
SELECT
		'MARTIN', 'Sophie', DATE '1988-11-22', 'Lyon, France', 'Enseignante',
		'+33 6 12 34 56 78', 'sophie.martin@email.com', '45 Avenue de la Republique, Lyon',
		sf.id, n.id
FROM Situation_familiale sf
JOIN Nationalite n ON n.libelle = 'Francaise'
WHERE sf.libelle = 'Marie(e)'
	AND NOT EXISTS (SELECT 1 FROM Demandeur d WHERE d.email = 'sophie.martin@email.com');

-- Demandeur 3
INSERT INTO Demandeur (
		nom, prenom, date_naissance, lieu_naissance, profession,
		telephone, email, adresse, id_situation_familiale, id_nationalite
)
SELECT
		'DIALLO', 'Moussa', DATE '1995-03-08', 'Dakar, Senegal', 'Etudiant',
		'+221 77 123 45 67', 'moussa.diallo@email.com', '12 Rue de Medina, Dakar',
		sf.id, n.id
FROM Situation_familiale sf
JOIN Nationalite n ON n.libelle = 'Senegalaise'
WHERE sf.libelle = 'Celibataire'
	AND NOT EXISTS (SELECT 1 FROM Demandeur d WHERE d.email = 'moussa.diallo@email.com');

-- Passeports
INSERT INTO Passeport (id_demandeur, numero_passeport, date_delivrance, date_expiration, pays_delivrance, est_actif)
SELECT d.id, 'MG-2022-001234', DATE '2022-01-15', DATE '2032-01-14', 'Madagascar', TRUE
FROM Demandeur d
WHERE d.email = 'jean.rakoto@email.com'
	AND NOT EXISTS (SELECT 1 FROM Passeport p WHERE p.numero_passeport = 'MG-2022-001234');

INSERT INTO Passeport (id_demandeur, numero_passeport, date_delivrance, date_expiration, pays_delivrance, est_actif)
SELECT d.id, 'FR-2021-567890', DATE '2021-06-20', DATE '2031-06-19', 'France', TRUE
FROM Demandeur d
WHERE d.email = 'sophie.martin@email.com'
	AND NOT EXISTS (SELECT 1 FROM Passeport p WHERE p.numero_passeport = 'FR-2021-567890');

INSERT INTO Passeport (id_demandeur, numero_passeport, date_delivrance, date_expiration, pays_delivrance, est_actif)
SELECT d.id, 'SN-2023-112233', DATE '2023-03-10', DATE '2033-03-09', 'Senegal', TRUE
FROM Demandeur d
WHERE d.email = 'moussa.diallo@email.com'
	AND NOT EXISTS (SELECT 1 FROM Passeport p WHERE p.numero_passeport = 'SN-2023-112233');

-- VISA transformables
INSERT INTO Visa_transformable (id_demandeur, id_passeport, numero_reference)
SELECT d.id, p.id, 'VT-2024-MG-0001'
FROM Demandeur d
JOIN Passeport p ON p.id_demandeur = d.id AND p.numero_passeport = 'MG-2022-001234'
WHERE d.email = 'jean.rakoto@email.com'
	AND NOT EXISTS (SELECT 1 FROM Visa_transformable vt WHERE vt.numero_reference = 'VT-2024-MG-0001');

INSERT INTO Visa_transformable (id_demandeur, id_passeport, numero_reference)
SELECT d.id, p.id, 'VT-2024-FR-0002'
FROM Demandeur d
JOIN Passeport p ON p.id_demandeur = d.id AND p.numero_passeport = 'FR-2021-567890'
WHERE d.email = 'sophie.martin@email.com'
	AND NOT EXISTS (SELECT 1 FROM Visa_transformable vt WHERE vt.numero_reference = 'VT-2024-FR-0002');

INSERT INTO Visa_transformable (id_demandeur, id_passeport, numero_reference)
SELECT d.id, p.id, 'VT-2025-SN-0003'
FROM Demandeur d
JOIN Passeport p ON p.id_demandeur = d.id AND p.numero_passeport = 'SN-2023-112233'
WHERE d.email = 'moussa.diallo@email.com'
	AND NOT EXISTS (SELECT 1 FROM Visa_transformable vt WHERE vt.numero_reference = 'VT-2025-SN-0003');

-- Demandes de test
INSERT INTO Demande (
		id_visa_transformable, date_demande, statut, sans_donnees,
		id_demandeur, id_type_visa, id_type_demande, id_type_profil, observations
)
SELECT
		vt.id,
		TIMESTAMP '2025-04-10 09:30:00',
		'en_cours',
		TRUE,
		d.id,
		tv.id,
		td.id,
		tp.id,
		'Demandeur dispose d un contrat de travail valide'
FROM Demandeur d
JOIN Visa_transformable vt ON vt.id_demandeur = d.id AND vt.numero_reference = 'VT-2024-MG-0001'
JOIN Type_visa tv ON tv.libelle = 'VISA Travailleur'
JOIN Type_demande td ON td.libelle = 'Nouvelle demande de titre'
JOIN Type_profil tp ON tp.libelle = 'Travailleur salarie'
WHERE d.email = 'jean.rakoto@email.com'
	AND NOT EXISTS (
		SELECT 1
		FROM Demande x
		WHERE x.id_demandeur = d.id
			AND x.date_demande = TIMESTAMP '2025-04-10 09:30:00'
	);

INSERT INTO Demande (
		id_visa_transformable, date_demande, statut, sans_donnees,
		id_demandeur, id_type_visa, id_type_demande, id_type_profil, observations
)
SELECT
		vt.id,
		TIMESTAMP '2025-04-12 14:00:00',
		'soumise',
		TRUE,
		d.id,
		tv.id,
		td.id,
		tp.id,
		'Demande pour inscription universitaire'
FROM Demandeur d
JOIN Visa_transformable vt ON vt.id_demandeur = d.id AND vt.numero_reference = 'VT-2024-FR-0002'
JOIN Type_visa tv ON tv.libelle = 'VISA Etudiant'
JOIN Type_demande td ON td.libelle = 'Nouvelle demande de titre'
JOIN Type_profil tp ON tp.libelle = 'Etudiant'
WHERE d.email = 'sophie.martin@email.com'
	AND NOT EXISTS (
		SELECT 1
		FROM Demande x
		WHERE x.id_demandeur = d.id
			AND x.date_demande = TIMESTAMP '2025-04-12 14:00:00'
	);

INSERT INTO Demande (
		id_visa_transformable, date_demande, statut, sans_donnees,
		id_demandeur, id_type_visa, id_type_demande, date_traitement, observations
)
SELECT
		vt.id,
		TIMESTAMP '2025-03-20 10:15:00',
		'validee',
		FALSE,
		d.id,
		tv.id,
		td.id,
		DATE '2025-04-01',
		'Transfert suite au changement de passeport'
FROM Demandeur d
JOIN Visa_transformable vt ON vt.id_demandeur = d.id AND vt.numero_reference = 'VT-2025-SN-0003'
JOIN Type_visa tv ON tv.libelle = 'VISA Etudiant'
JOIN Type_demande td ON td.libelle = 'Transfert de VISA'
WHERE d.email = 'moussa.diallo@email.com'
	AND NOT EXISTS (
		SELECT 1
		FROM Demande x
		WHERE x.id_demandeur = d.id
			AND x.date_demande = TIMESTAMP '2025-03-20 10:15:00'
	);

INSERT INTO Demande (
		id_visa_transformable, date_demande, statut, sans_donnees,
		id_demandeur, id_type_visa, id_type_demande, date_traitement, motif_rejet
)
SELECT
		vt.id,
		TIMESTAMP '2025-02-05 11:00:00',
		'rejetee',
		TRUE,
		d.id,
		tv.id,
		td.id,
		DATE '2025-02-20',
		'Dossier incomplet - pieces justificatives manquantes'
FROM Demandeur d
JOIN Visa_transformable vt ON vt.id_demandeur = d.id AND vt.numero_reference = 'VT-2024-MG-0001'
JOIN Type_visa tv ON tv.libelle = 'VISA Etudiant'
JOIN Type_demande td ON td.libelle = 'Nouvelle demande de titre'
WHERE d.email = 'jean.rakoto@email.com'
	AND NOT EXISTS (
		SELECT 1
		FROM Demande x
		WHERE x.id_demandeur = d.id
			AND x.date_demande = TIMESTAMP '2025-02-05 11:00:00'
	);

-- Historique des statuts
INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'brouillon', DATE '2025-04-10'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'jean.rakoto@email.com' AND d.date_demande = TIMESTAMP '2025-04-10 09:30:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'brouillon' AND s.date_changement_statut = DATE '2025-04-10'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'soumise', DATE '2025-04-10'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'jean.rakoto@email.com' AND d.date_demande = TIMESTAMP '2025-04-10 09:30:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'soumise' AND s.date_changement_statut = DATE '2025-04-10'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'en_cours', DATE '2025-04-11'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'jean.rakoto@email.com' AND d.date_demande = TIMESTAMP '2025-04-10 09:30:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'en_cours' AND s.date_changement_statut = DATE '2025-04-11'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'brouillon', DATE '2025-04-12'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'sophie.martin@email.com' AND d.date_demande = TIMESTAMP '2025-04-12 14:00:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'brouillon' AND s.date_changement_statut = DATE '2025-04-12'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'soumise', DATE '2025-04-12'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'sophie.martin@email.com' AND d.date_demande = TIMESTAMP '2025-04-12 14:00:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'soumise' AND s.date_changement_statut = DATE '2025-04-12'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'brouillon', DATE '2025-03-20'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'moussa.diallo@email.com' AND d.date_demande = TIMESTAMP '2025-03-20 10:15:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'brouillon' AND s.date_changement_statut = DATE '2025-03-20'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'soumise', DATE '2025-03-20'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'moussa.diallo@email.com' AND d.date_demande = TIMESTAMP '2025-03-20 10:15:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'soumise' AND s.date_changement_statut = DATE '2025-03-20'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'en_cours', DATE '2025-03-25'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'moussa.diallo@email.com' AND d.date_demande = TIMESTAMP '2025-03-20 10:15:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'en_cours' AND s.date_changement_statut = DATE '2025-03-25'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'validee', DATE '2025-04-01'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'moussa.diallo@email.com' AND d.date_demande = TIMESTAMP '2025-03-20 10:15:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'validee' AND s.date_changement_statut = DATE '2025-04-01'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'brouillon', DATE '2025-02-05'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'jean.rakoto@email.com' AND d.date_demande = TIMESTAMP '2025-02-05 11:00:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'brouillon' AND s.date_changement_statut = DATE '2025-02-05'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'soumise', DATE '2025-02-05'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'jean.rakoto@email.com' AND d.date_demande = TIMESTAMP '2025-02-05 11:00:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'soumise' AND s.date_changement_statut = DATE '2025-02-05'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'en_cours', DATE '2025-02-10'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'jean.rakoto@email.com' AND d.date_demande = TIMESTAMP '2025-02-05 11:00:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'en_cours' AND s.date_changement_statut = DATE '2025-02-10'
	);

INSERT INTO Statut_demande (id_demande, statut, date_changement_statut)
SELECT d.id, 'rejetee', DATE '2025-02-20'
FROM Demande d
JOIN Demandeur dem ON dem.id = d.id_demandeur
WHERE dem.email = 'jean.rakoto@email.com' AND d.date_demande = TIMESTAMP '2025-02-05 11:00:00'
	AND NOT EXISTS (
			SELECT 1 FROM Statut_demande s
			WHERE s.id_demande = d.id AND s.statut = 'rejetee' AND s.date_changement_statut = DATE '2025-02-20'
	);

COMMIT;
