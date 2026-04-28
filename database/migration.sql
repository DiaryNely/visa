-- ============================================
-- Migration Sprint 3: Ajout des colonnes de scan
-- ============================================

BEGIN;

-- Ajouter les colonnes manquantes à la table Demande
ALTER TABLE Demande
ADD COLUMN IF NOT EXISTS statut_scan VARCHAR(30) NOT NULL DEFAULT 'EN_COURS_DE_SCAN',
ADD COLUMN IF NOT EXISTS est_verrouille BOOLEAN NOT NULL DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS date_scan_termine DATE;

-- Ajouter les colonnes manquantes à la table Demande_piece
ALTER TABLE Demande_piece
ADD COLUMN IF NOT EXISTS statut_scan VARCHAR(20) NOT NULL DEFAULT 'EN_ATTENTE',
ADD COLUMN IF NOT EXISTS date_scan DATE,
ADD COLUMN IF NOT EXISTS chemin_fichier VARCHAR(255);

COMMIT;
