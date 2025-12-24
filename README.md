# HubSight

Plateforme web de gestion et pilotage contractuel orientée immobilier et gestion technique.

## État du projet

**État: IMPLEMENTATION - Brick #1**

| Phase | Statut |
|-------|--------|
| Analysis | ✅ Terminé |
| Mockups | ✅ Validés par le client |
| Implementation Brick 1 | 🔄 En cours |
| Implementation Brick 2 | ⏳ À venir |

---

## 📚 Documentation Critique

### ⚠️ FICHIERS À SUIVRE IMPÉRATIVEMENT

Ces fichiers définissent la structure de données et doivent être respectés scrupuleusement, notamment pour les imports Excel :

| Fichier | Description | Importance |
|---------|-------------|------------|
| **`doc/data_models_referential.md`** | Structure complète des modèles de données (21KB) | 🔴 CRITIQUE - Définit tous les champs, relations et types |
| **`doc/en_specification.md`** | Spécifications fonctionnelles en anglais | 🔴 CRITIQUE - Périmètre Brick 1 & 2 |
| **`doc/specification.md`** | Spécifications fonctionnelles en français | 🟡 Référence |
| **`doc/routes.md`** | Toutes les routes par profil utilisateur (~120 routes) | 🟡 Référence |
| **`doc/style_guide.html`** | Charte graphique (Coral #FF6B6B) | 🟡 Design |

### 📊 Structure de Données (data_models_referential.md)

Le fichier `doc/data_models_referential.md` contient :

1. **Hiérarchie patrimoniale** :
   ```
   SITE → BUILDING → LEVEL → SPACE → EQUIPMENT
   ```

2. **Modèles principaux** (12 entités) :
   - `Site` (8 champs)
   - `Building` (17 champs)
   - `Level` (3 champs)
   - `Space` (23 champs)
   - `Equipment` (34 champs de base + 31 optionnels)
   - `Contract` (72 champs!)
   - `Organization` (12 champs)
   - `Contact` (11 champs)
   - `Agency` (11 champs)
   - `User` + `UserProfile`
   - Tables de référence (EquipmentType, ContractFamily, etc.)

3. **Imports Excel attendus** :
   - OmniClass Table 23 : 256 types d'équipements
   - OmniClass Table 13 : 966 classifications d'espaces
   - Familles de contrats : 7 familles, 20+ sous-familles
   - 339 types de contrats pré-configurés

---

## 🗂️ Structure du Projet

```
hubsight/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── home_controller.rb
│   │   ├── api/                    # Endpoints AJAX
│   │   └── mockups/                # Controllers mockup (référence)
│   │
│   ├── models/                     # À implémenter
│   │   └── user.rb                 # Seul modèle existant (Devise)
│   │
│   └── views/
│       ├── devise/                 # Auth
│       ├── home/                   # Page d'accueil
│       ├── layouts/                # Layouts partagés
│       └── mockups/                # Vues mockup (référence)
│
├── doc/
│   ├── data_models_referential.md  # 🔴 STRUCTURE DE DONNÉES
│   ├── en_specification.md         # 🔴 SPECS FONCTIONNELLES
│   ├── specification.md            # Specs FR
│   ├── routes.md                   # Routes par profil
│   ├── style_guide.html            # Charte graphique
│   └── admin_sidebar_menu.md       # Menu admin
│
└── doc/memory/                     # À créer - Suivi des tâches
```

---

## 🎯 Brick 1 - Gestion Contractuelle de Base (5000€)

### Profils Utilisateurs

| Profil | Responsabilités |
|--------|-----------------|
| **Admin** | Créer/gérer les Portfolio Managers, accéder aux données clients |
| **Portfolio Manager** | Gestion complète : sites, bâtiments, équipements, contrats, organisations |
| **Site Manager** | Consultation des contrats/équipements de ses sites assignés |

### Fonctionnalités Clés

- [ ] Structure patrimoniale : Portfolio > Sites > Buildings > Levels > Spaces > Equipment
- [ ] Import OmniClass Table 23 (équipements)
- [ ] Import structure espaces
- [ ] Import familles de contrats
- [ ] Upload PDF + OCR (Mistral) + LLM (OpenRouter)
- [ ] Validation manuelle des extractions
- [ ] Génération fiches PDF par contrat
- [ ] Dashboard avec indicateurs clés

---

## 🚀 Démarrage

```bash
# Installation
bundle install

# Base de données
bin/rails db:create db:migrate

# Lancer le serveur
bin/dev

# Accéder aux mockups (référence)
open http://localhost:3000/mockups
```

---

## 🔧 Stack Technique

- **Ruby on Rails 8** avec SQLite (Solid libraries)
- **Hotwire** (Turbo + Stimulus) pour l'interactivité
- **Tailwind CSS** pour le styling
- **Devise** pour l'authentification
- **Mistral OCR** pour l'extraction de texte (API externe)
- **OpenRouter** pour le traitement LLM

---

## 📝 Conventions

- Ruby/HTML first - Maximiser le code côté serveur
- JS uniquement via Turbo/Stimulus
- Tests pour chaque fonctionnalité
- Commits atomiques après chaque tâche

---

## 🔗 Liens Utiles

- Mockups : `/mockups`
- Documentation : `/doc/`
- Style Guide : `/doc/style_guide.html`
