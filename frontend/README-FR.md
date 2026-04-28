# Application Vue.js - Recherche de Demandes Visa

Application web moderne permettant aux utilisateurs de rechercher leurs demandes de visa par numéro de passeport ou numéro de demande.

## 📋 Fonctionnalités

- 🔍 **Recherche par Passeport** : Entrez votre numéro de passeport pour voir toutes vos demandes
- 📋 **Recherche par Numéro de Demande** : Consultez une demande spécifique par son ID
- ✨ **Interface Moderne** : Design épuré avec Tailwind-like styling
- 📱 **Responsive** : Compatible sur tous les appareils
- 🎨 **Vue 3** : Framework JavaScript moderne et performant
- ⚡ **Vite** : Build tool ultra-rapide

## 🚀 Démarrage Rapide

### Prérequis
- Node.js 16+ et npm

### Installation

```bash
cd frontend
npm install
```

### Développement

```bash
npm run dev
```

L'application s'ouvrira automatiquement sur `http://localhost:3000`

### Build pour Production

```bash
npm run build
npm run preview
```

## 📁 Structure du Projet

```
frontend/
├── src/
│   ├── components/
│   │   ├── SearchForm.vue        # Formulaire de recherche
│   │   └── ResultsSection.vue    # Affichage des résultats
│   ├── App.vue                   # Composant principal
│   ├── main.js                   # Point d'entrée
│   └── style.css                 # Styles globaux
├── index.html
├── vite.config.js
└── package.json
```

## 🔌 Configuration de l'API

Par défaut, l'application se connecte à :
```
http://localhost:8081/api
```

### Endpoints utilisés

- `GET /api/demandeurs/par-passeport/:numeroPasse` - Récupère un demandeur et toutes ses demandes par numéro de passeport
- `GET /api/demandes/:id` - Récupère une demande spécifique par son ID

## 🎯 Utilisation

### Rechercher par Passeport
1. Cliquez sur l'onglet **"🛂 Par Passeport"**
2. Entrez votre numéro de passeport
3. Cliquez sur **"🔍 Rechercher"**
4. Consultez vos informations et toutes vos demandes

### Rechercher par Numéro de Demande
1. Cliquez sur l'onglet **"📋 Par Numéro Demande"**
2. Entrez l'ID de votre demande
3. Cliquez sur **"🔍 Rechercher"**
4. Consultez les détails de votre demande

## 🎨 Design

L'application utilise un design moderne avec :
- Gradient violet/bleu en arrière-plan
- Cards blanches avec ombres douces
- Badges de statut colorés
- Tableau responsive pour les résultats
- Animations fluides

### Statuts des Demandes
- 📝 **Brouillon** (jaune) - Demande non soumise
- 📤 **Soumise** (bleu) - Demande envoyée
- ⏳ **En cours** (cyan) - Traitement en cours
- ✅ **Validée** (vert) - Demande approuvée
- ❌ **Rejetée** (rouge) - Demande refusée

## 📝 Variables d'Environnement

Pour modifier l'URL de l'API, éditez le fichier `src/App.vue` et modifiez :

```javascript
const API_BASE_URL = 'http://localhost:8081/api'
```

## 🔧 Technos Utilisées

- **Vue 3** - Framework JavaScript
- **Vite** - Build tool ultramoderne
- **CSS3** - Styles modernes et responsive

## 📄 License

MIT
