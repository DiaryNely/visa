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

-- Motifs de duplicata (Sprint 2)
INSERT INTO Motif_duplicata (libelle)
SELECT 'Perte' WHERE NOT EXISTS (SELECT 1 FROM Motif_duplicata WHERE libelle = 'Perte');
INSERT INTO Motif_duplicata (libelle)
SELECT 'Vol' WHERE NOT EXISTS (SELECT 1 FROM Motif_duplicata WHERE libelle = 'Vol');
INSERT INTO Motif_duplicata (libelle)
SELECT 'Deterioration' WHERE NOT EXISTS (SELECT 1 FROM Motif_duplicata WHERE libelle = 'Deterioration');
INSERT INTO Motif_duplicata (libelle)
SELECT 'Erreur administrative' WHERE NOT EXISTS (SELECT 1 FROM Motif_duplicata WHERE libelle = 'Erreur administrative');
INSERT INTO Motif_duplicata (libelle)
SELECT 'Changement de support' WHERE NOT EXISTS (SELECT 1 FROM Motif_duplicata WHERE libelle = 'Changement de support');
INSERT INTO Motif_duplicata (libelle)
SELECT 'Cas particulier' WHERE NOT EXISTS (SELECT 1 FROM Motif_duplicata WHERE libelle = 'Cas particulier');

-- Types de duplicata (Sprint 2)
INSERT INTO Type_duplicata (libelle)
SELECT 'Transfert de visa' WHERE NOT EXISTS (SELECT 1 FROM Type_duplicata WHERE libelle = 'Transfert de visa');
INSERT INTO Type_duplicata (libelle)
SELECT 'Duplicata de carte resident' WHERE NOT EXISTS (SELECT 1 FROM Type_duplicata WHERE libelle = 'Duplicata de carte resident');

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

COMMIT;
