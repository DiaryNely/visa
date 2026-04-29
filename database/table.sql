CREATE TABLE Nationalite (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE Situation_familiale (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE Type_visa (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL,
    duree_validite INTEGER NOT NULL CHECK (duree_validite > 0)
);

CREATE TABLE Type_demande (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL,
    necessite_sans_donnees BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE Type_profil (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE Demandeur (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    nom_jeune_fille VARCHAR(50),
    nom_pere VARCHAR(50),
    date_naissance DATE NOT NULL,
    lieu_naissance VARCHAR(100) NOT NULL,
    profession VARCHAR(100),
    telephone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    adresse TEXT NOT NULL,
    id_situation_familiale INTEGER NOT NULL,
    id_nationalite INTEGER NOT NULL,
    FOREIGN KEY (id_situation_familiale) REFERENCES Situation_familiale(id),
    FOREIGN KEY (id_nationalite) REFERENCES Nationalite(id)
);

CREATE TABLE Passeport (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_demandeur INTEGER NOT NULL,
    id_passeport_precedent INTEGER,
    numero_passeport VARCHAR(50) NOT NULL UNIQUE,
    date_delivrance DATE NOT NULL,
    date_expiration DATE NOT NULL,
    pays_delivrance VARCHAR(100),
    est_actif BOOLEAN NOT NULL,
    FOREIGN KEY (id_demandeur) REFERENCES Demandeur(id),
    FOREIGN KEY (id_passeport_precedent) REFERENCES Passeport(id),
    CHECK (date_expiration > date_delivrance)
);

CREATE TABLE Statut_passeport (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_passeport INTEGER NOT NULL,
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('actif', 'expire', 'perdu', 'volee')),
    date_changement_statut DATE,
    FOREIGN KEY (id_passeport) REFERENCES Passeport(id)
);

CREATE TABLE Visa_transformable (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_demandeur INTEGER NOT NULL,
    id_passeport INTEGER NOT NULL,
    numero_reference VARCHAR(50) NOT NULL UNIQUE,
    date_entree DATE NOT NULL,
    lieu_entree VARCHAR(100) NOT NULL,
    date_expiration DATE NOT NULL,
    FOREIGN KEY (id_demandeur) REFERENCES Demandeur(id),
    FOREIGN KEY (id_passeport) REFERENCES Passeport(id),
    CHECK (date_expiration >= date_entree)
);

CREATE TABLE Motif_duplicata (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE Type_duplicata (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE Demande (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_visa_transformable INTEGER,
    date_demande TIMESTAMP NOT NULL,
    statut VARCHAR(30) NOT NULL CHECK (statut IN ('brouillon', 'soumise', 'en_cours', 'validee', 'rejetee', 'approuvee')),
    sans_donnees BOOLEAN NOT NULL DEFAULT FALSE,
    id_demandeur INTEGER NOT NULL,
    id_type_visa INTEGER NOT NULL,
    id_type_demande INTEGER NOT NULL,
    id_type_profil INTEGER,
    date_traitement DATE,
    observations TEXT,
    motif_rejet TEXT,
    id_motif_duplicata INTEGER,
    id_type_duplicata INTEGER,
    nouveau_numero_passeport VARCHAR(50),
    qr_code_url TEXT,
    qr_code_image_base64 TEXT,
    FOREIGN KEY (id_type_demande) REFERENCES Type_demande(id),
    FOREIGN KEY (id_type_profil) REFERENCES Type_profil(id),
    FOREIGN KEY (id_demandeur) REFERENCES Demandeur(id),
    FOREIGN KEY (id_type_visa) REFERENCES Type_visa(id),
    FOREIGN KEY (id_visa_transformable) REFERENCES Visa_transformable(id),
    FOREIGN KEY (id_motif_duplicata) REFERENCES Motif_duplicata(id),
    FOREIGN KEY (id_type_duplicata) REFERENCES Type_duplicata(id),
    CHECK (date_traitement IS NULL OR date_traitement >= date_demande::date)
);

CREATE TABLE Statut_demande (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_demande INTEGER NOT NULL,
    statut VARCHAR(30) NOT NULL CHECK (statut IN ('brouillon', 'soumise', 'en_cours', 'validee', 'rejetee', 'approuvee')),
    date_changement_statut DATE,
    FOREIGN KEY (id_demande) REFERENCES Demande(id)
);

CREATE TABLE Visa (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_demande INTEGER NOT NULL,
    reference VARCHAR(50),
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    lieu_entree VARCHAR(100) NOT NULL,
    statut VARCHAR(30),
    transformable BOOLEAN NOT NULL DEFAULT FALSE,
    id_type_visa INTEGER NOT NULL,
    id_passeport INTEGER NOT NULL,
    FOREIGN KEY (id_passeport) REFERENCES Passeport(id),
    FOREIGN KEY (id_demande) REFERENCES Demande(id),
    FOREIGN KEY (id_type_visa) REFERENCES Type_visa(id),
    CHECK (date_fin >= date_debut)
);

CREATE TABLE Visa_historique (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_visa INTEGER NOT NULL,
    date_changement DATE,
    ancien_statut VARCHAR(30),
    nouveau_statut VARCHAR(30),
    motif TEXT,
    FOREIGN KEY (id_visa) REFERENCES Visa(id)
);

CREATE TABLE Carte_resident (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_demande INTEGER NOT NULL,
    reference VARCHAR(50),
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    id_passeport INTEGER NOT NULL,
    FOREIGN KEY (id_demande) REFERENCES Demande(id),
    FOREIGN KEY (id_passeport) REFERENCES Passeport(id),
    CHECK (date_fin >= date_debut)
);

CREATE TABLE Piece_justificative (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_type_demande INTEGER NOT NULL,
    id_type_profil INTEGER,
    libelle VARCHAR(100) NOT NULL,
    obligatoire BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_type_demande) REFERENCES Type_demande(id),
    FOREIGN KEY (id_type_profil) REFERENCES Type_profil(id)
);

CREATE TABLE Demande_piece (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_demande INTEGER NOT NULL,
    id_piece INTEGER NOT NULL,
    fournie BOOLEAN NOT NULL DEFAULT FALSE,
    date_fourniture DATE,
    FOREIGN KEY (id_demande) REFERENCES Demande(id),
    FOREIGN KEY (id_piece) REFERENCES Piece_justificative(id)
);

CREATE TABLE Titre_sejour (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_demandeur INTEGER NOT NULL,
    id_demande INTEGER NOT NULL,
    numero VARCHAR(50),
    type_titre VARCHAR(50),
    date_delivrance DATE,
    date_expiration DATE,
    FOREIGN KEY (id_demandeur) REFERENCES Demandeur(id),
    FOREIGN KEY (id_demande) REFERENCES Demande(id),
    CHECK (
        date_delivrance IS NULL
        OR date_expiration IS NULL
        OR date_expiration >= date_delivrance
    )
);

CREATE TABLE Famille (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_demandeur INTEGER NOT NULL,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    lien VARCHAR(50) NOT NULL,
    date_naissance DATE,
    FOREIGN KEY (id_demandeur) REFERENCES Demandeur(id)
);

CREATE UNIQUE INDEX uq_passeport_actif_demandeur
    ON Passeport (id_demandeur)
    WHERE est_actif;

COMMENT ON COLUMN Passeport.est_actif IS 'Un seul passeport actif par demandeur';

-- D'abord, supprimez l'ancienne contrainte


ALTER TABLE demande DROP CONSTRAINT demande_statut_check;
ALTER TABLE demande 
ADD CONSTRAINT demande_statut_check 
CHECK (statut IN ('brouillon', 'soumise', 'en_cours', 'validee', 'rejetee', 'approuvee'));

-- Corriger la table statut_demande
ALTER TABLE statut_demande DROP CONSTRAINT statut_demande_statut_check;
ALTER TABLE statut_demande 
ADD CONSTRAINT statut_demande_statut_check 
CHECK (statut IN ('brouillon', 'soumise', 'en_cours', 'validee', 'rejetee', 'approuvee'));