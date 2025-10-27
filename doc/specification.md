2.1 Description générale du projet
Le projet consiste à développer une plateforme web de gestion et de pilotage contractuel
orientée immobilier et gestion technique. La solution permet de centraliser les contrats de

maintenance, d'entretien, de contrôle technique et biologique, sous traitance, fourniture,
assurance et immobilier (actes de propriété, baux, règlements de copropriété) dans une
structure de données organisée par portefeuille immobilier (sites, bâtiments, équipements).
L'objectif est de simplifier drastiquement l'entrée de données via l'extraction automatique
d'informations depuis les documents contractuels (OCR + IA), puis de permettre le pilotage
des échéances contractuelles avec système d'alertes et la visualisation des économies
potentielles par comparaison avec un référentiel prix.
Le projet sera développé en deux briques successives permettant une mise en production
progressive et des tests utilisateurs entre chaque étape.
2.2 BRIQUE 1 - Gestion contractuelle de base (5000€)
Fonctionnalités par type d'utilisateur
👤 Admin (5000.dev)
● Je peux créer et configurer les comptes "Gestionnaire de portefeuille"
● Je peux accéder aux données clients (avec autorisation contractuelle formalisée)
👑 Gestionnaire de Portefeuille
● Je peux créer et gérer les profils "Responsable de site" de mon organisation
● Je peux assigner des sites aux responsables de site
● Je peux créer et gérer ma structure patrimoniale (sites, bâtiments, équipements)
● Je peux uploader des contrats PDF et valider l'extraction automatique des données
● Je peux créer/modifier manuellement des contrats si absence de document ou si
extraction incomplète
● Je peux saisir et associé manuellement la correspondance entre les équipements et
les codes de classification OmniClass fourni :
● Je peux saisir et associé manuellement la correspondance entre les prestations et
les Famille contrats / Sous Famille contrats
● Je peux saisir et associé manuellement la correspondance entre l’organisation
signataire et les organisations (tiers) présente dans la base de données
● Je peux consulter mes contrats sous forme de liste avec filtres (site, famille,
prestataire, statut)
● Je peux visualiser mes sites, bâtiments et équipements dans une arborescence
structurée
● Je peux visualiser et gérer les organisations et leurs contacts.
● Je peux générer et exporter des fiches synthétiques avec infos essentiels par contrat
au format PDF
🏢 Responsable de Site
● Je peux consulter les contrats liés à mon/mes site(s) assigné(s)
● Je peux uploader des contrats pour mon périmètre

● Je peux consulter la liste des équipements de mon site
● Je peux générer et exporter des fiches synthétiques des contrats de mon site au
format PDF
Fonctionnalités système Brique 1
Structuration patrimoniale :
● Structure hiérarchique : Portefeuille > Sites > Bâtiments > Équipements
● Import de la classification OmniClass Table 23 (équipements) via fichier Excel fourni
par le Client
● Import de la structure des espaces via fichier Excel fourni par le Client
● Import des familles et sous familles de contrats via fichier Excel fourni par le Client
● Système de recherche et d'autocomplete dans la base equipement pour faciliter la
saisie manuelle
● Système de recherche et d'autocomplete dans la base famille contrats et sous famille
achat pour faciliter la saisie manuelle
● Système de recherche et d'autocomplete dans les bases Organisations et contacts
pour faciliter la saisie manuelle
● Liaison entre équipements, Organisation ( tiers) , contrats, famille et sous famille
contrats.
Extraction et gestion des contrats :
● Upload de documents PDF (multi-pages)
● Extraction du texte via Mistral OCR
● Structuration automatique des données via LLM (OpenRouter) : numéro de contrat,
dates, nature de contrat, prestataire, durées, type de reconduction, liste des
équipements,site concerné, informations essentiels, montants (selon fichier fourni
par le client)
● Interface de validation manuelle des données extraites
● Création manuelle de contrats si document absent ou non-extractible
● Liaison manuelle des équipements aux codes OmniClass via système de recherche
● Liaison manuelle des base famille contrats et sous famille achat via système de
recherche
● Liaison manuelle des bases Organisations et contacts base via système de
recherche
● Calcul automatique des date de dernier renouvellement du contrat, date d’échéance
du contrat, date limite de résiliation, date de la derniere mise à jour du montant du
contrat, et montants TTC (selon fichier fourni par le client)
Visualisation :
● Liste des contrats avec filtres multiples
● Navigation arborescente du portefeuille
● Génération de fiches synthétiques PDF par contrat (numéro d'urgence, références,
équipements, selon fichier fournis par le client)
● Dashboard avec vue d'ensemble du portefeuille et indicateurs clés

Sécurité :
● Authentification sécurisée avec gestion de trois profils utilisateurs
● Isolation totale des données entre clients
● Hébergement en France, connexion HTTPS
Services externes et hébergement :
● Mistral OCR pour extraction de texte (API externe, coût à l'usage approximatif
0.10€/contrat, à la charge du Client)
● OpenRouter pour traitement LLM (coût à l'usage inclus)
● Interface web responsive (Web App)
● Design épuré avec charte graphique du Client (logo et couleurs fournis)
● Hébergement sécurisé France : 50€/mois (contrat séparé, facturation directe au
Client)
2.3 BRIQUE 2 - Matching automatique & Comparaison prix (5000€)
Fonctionnalités par type d'utilisateur
👤 Admin (5000.dev)
● Je peux gérer le référentiel de prix via interface d'administration
● Je peux créer/modifier des références de prix par type d'équipement et prestation
● Je peux importer des fichiers Excel de références de prix
👑 Gestionnaire de Portefeuille
● Je peux voir les économies potentielles calculées automatiquement par contrat
● Je peux consulter le comparatif entre prix actuel et prix référentiel
● Je peux filtrer mes contrats par potentiel d'économie
● Je peux consulter le tableau de bord des alertes contractuelles
● Je peux valider manuellement les alertes (marquer comme "pris en compte")
● Je peux exporter un rapport d'analyse économique au format PDF
● Je peux paramétrer mes notifications par email
🏢 Responsable de Site
● Je peux consulter les économies potentielles de mon site
● Je peux recevoir les alertes concernant mon site
Fonctionnalités système Brique 2
Matching automatique BDD Famille et sous famille contrats / Equipements / Organisations :
● Système de matching automatique entre équipements extraits et BDD Equipements
via LLM
● Système de recherche et d'autocomplete dans la BDD Famille et sous famille
contrats pour faciliter la saisie manuelle

● Système de recherche et d'autocomplete dans les BDD Organisations et contacts
pour faciliter la saisie manuelle
● Suggestions avec score de confiance
● Interface de validation/correction des suggestions
● Apprentissage progressif des corrections utilisateur
Système d'alertes complet : ( Selon fichier joint par le client)
● Alertes "à venir" : X jours avant date limite de résiliation (délai paramétrable)
● Alertes "en risque" : date limite dépassée sans action
● Alertes "contrats manquants" : contrats obligatoires non référencés pour un type de
site
● Validation manuelle des alertes par l'utilisateur avec historique
● Notifications email automatiques pour les alertes critiques (paramétrables)
○

Référentiel de prix et comparaison économique :
● Interface d'administration du référentiel avec création de références par famille et
sous famille contrat et par équipement
● Structuration par type famille et sous famille contrat et par équipement
caractéristiques techniques, type de prestation, localisation ( selon fichier joint par le
client)
● Import/export Excel du référentiel
● Comparaison automatique entre prix contractuel et prix référentiel
● Calcul des économies potentielles en valeur absolue et en pourcentage
● Mise à jour automatique lors de modification du référentiel
● Affichage des économies sur chaque contrat avec vue consolidée par site et famille
et sous famille contrat
● Export rapport d'analyse économique au format PDF
Dashboard enrichi :
● Total des économies potentielles par site / par portefeuille
● Nombre d'alertes actives par type
● Contrats à échéance dans les 30/60/90 jours
● Contrats en risque nécessitant une action immédiate
2.4 Éléments explicitement exclus du périmètre des 2 briques
Les éléments suivants sont explicitement exclus du périmètre contractuel et pourront faire
l'objet de briques de développement ultérieures :
● Profil "Prestataire externe" avec accès à la plateforme
● Gestion des demandes d'intervention
● Gestion des sinistres et déclarations d'assurance
● Plans d'action avec suivi de tâches
● Plans d'investissement et durée de vie prévisionnelle des équipements

● Workflow de validation contractuelle et signature électronique
● Application mobile native (iOS/Android)
● Connexions API avec logiciels tiers (comptabilité, gestion patrimoniale)
● Alertes sur la santé financière des prestataires
● Système de limitation par nombre de sites avec paliers tarifaires
Cette liste de fonctionnalités constitue le périmètre contractuel des développements à
réaliser.