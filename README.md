# GymFlow — Réservation de créneaux en salle de sport

Interface web interactive de gestion des flux et de réservation de créneaux d'entraînement, développée dans le cadre de l'unité d'enseignement du Mastère spécialisé ingénierie du sport **IHME** (Polytech Marseille).

---

## 🎯 Concept & Objectifs

**GymFlow** répond à une problématique centrale d'ergonomie et d'organisation des espaces sportifs : **lisser l'affluence et réguler l'accès aux équipements** pour garantir des conditions d'entraînement optimales et sécurisées.

L'application permet aux adhérents de :
- Consulter en temps réel la disponibilité des zones d'entraînement.
- Réserver des créneaux de durée flexible avec mise à jour immédiate des jauges de fréquentation.
- Générer un pass d'accès numérique individuel muni d'un QR code vectoriel autonome.
- Donner au superviseur de la salle une vue globale sur l'affluence et la possibilité de réinitialiser les compteurs.

---

## ⚙️ Fonctionnalités clés

### 1. Gestion par espaces spécialisés
La salle est structurée en 4 zones distinctes, chacune limitée à une capacité stricte de **20 places maximum** par créneau :
- **Espace cardio** : tapis de course, rameurs, vélos de biking.
- **Espace HYROX** : zones fonctionnelles, SkiErgs, traîneaux et stations d'endurance.
- *$Espace jambe** : racks à squat, presses, postes de charge guidée et libre.
- **Espace haut du corps** : bancs développés, poulies réglables, haltères et postes de tirage.

### 2. Planification horaire et durée modulable
- **Amplitude horaire** : de 6h00 à 23h00, découpée par tranches de 30 minutes.
- **Format flexible** : sélection de sessions de 1h, 1h30 ou 2h selon le volume de la séance.
- **Jauges visuelles** : code couleur dynamique (vert, ambre, rouge) indiquant le niveau de saturation du créneau.

### 3. Panier multi-créneaux
- Sélection fluide de plusieurs sessions sur différents jours de la semaine sans rechargement de page.
- Validation groupée des réservations avec persistance locale des données (`localStorage`).

### 4. Pass d'accès avec QR code autonome
- Génération instantanée d'un récapitulatif nominatif prêt pour le contrôle d'accès.
- Intégration d'un module de QR code vectoriel natif (SVG), fonctionnant sans aucune dépendance externe ni appel à une API tierce.

### 5. Console superviseur (Admin)
- Tableau de bord synthétique affichant le taux d'occupation des espaces en temps réel.
- Commande d'effacement rapide pour réinitialiser le registre des réservations lors des phases de test ou à l'ouverture quotidienne.

---

## 🎨 Design & Ergonomie

L'interface a été conçue pour offrir une lisibilité optimale sur smartphone et poste fixe :
- **Thème sombre immersif** : fond noir profond (`#050505` / `#0f0f13`) limitant la fatigue visuelle.
- **Accents violet électrique** : mise en valeur des actions prioritaires, des états actifs et des boutons de validation.
- **Feedback visuel immédiat** : micro-animations au survol et retour d'état instantané lors de l'ajout au panier.

---

## 🛠️ Stack technique

- **Structure & Interface** : HTML5 sémantique, Tailwind CSS (via CDN) pour le stylage utilitaire.
- **Logique applicative** : JavaScript moderne (ES6+), manipulation du DOM, gestion synchrone du `localStorage`.
- **Rendu graphique** : icônes Lucide Icons, générateur vectoriel de QR Code embarqué.
- **Environnement de conteneurisation** : Node.js slim (port 3000), exposition d'un point d'accès de contrôle `/api/health`.
- **CI/CD & Déploiement** : GitHub Actions (`publish.yml`), registre de conteneurs GitHub Packages (GHCR) et hébergement sur l'infrastructure du cours IHME.

---

## 🚀 Déploiement & Maintenance

### Mettre à jour l'application en production
1. Modifier le code localement (ou sur GitHub Codespaces) et valider les changements :
   ```bash
   git add .
   git commit -m "feat: description de la mise a jour"
   git push