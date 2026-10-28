# GymFlow — Réservation de créneaux en salle de sport

Interface web interactive de gestion des flux d'entraînement et de régulation des accès en salle de sport, conçue dans le cadre du cours IHME (Polytech Marseille).

- URL de l'application en ligne : https://node219697-ihme26.jcloud.ik-server.com/reservation-de-creneaux-de-salle-de-sport/
- Conteneur & Registre : ghcr.io/zoegrangeon/reservation-creneau-salle-sport

---

## 1. Cadrage du besoin

### Utilisateur cible
Étudiant(e) ou enseignant(e) de la filière STAPS / sportif régulier en salle universitaire s'entraînant sur des créneaux précis (cardio, force, préparation type Hyrox) nécessitant une disponibilité garantie des postes d'entraînement.

### Problème rencontré
Saturation imprévisible des plateaux sportifs aux heures de pointe, files d'attente sur les machines à charge guidée/libre, et absence de visibilité sur les créneaux disponibles.

### Entrées & Résultat attendu
- Entrée : Sélection d'une zone sportive, d'une date, d'un horaire (tranches de 30 min entre 6h et 23h), d'une durée (1h, 1h30, 2h) et des coordonnées athlète (Nom, Prénom, N° Adhérent, Email, Téléphone).
- Résultat attendu : Contrôle immédiat de la capacité (jauge visuelle), confirmation groupée, génération d'un pass avec QR code vectoriel SVG autonome et intégration dans l'historique du compte athlète.

---

## 2. Modèle de données & Schéma SQL

Le modèle relationnel s'appuie sur trois entités principales (détaillées dans le fichier schema.sql) :
- spaces : Espaces d'entraînement (id, name, max_capacity fixé à 20).
- members : Adhérents (member_id [PK], first_name, last_name, email, phone).
- reservations : Réservations confirmées (id [PK], booking_ref, member_id [FK], space_id [FK], booking_date, start_time, end_time, duration_minutes).

Exemple de requête SQL de calcul de disponibilité :
SELECT 
    s.name, 
    GREATEST(0, s.max_capacity - COUNT(r.id)) AS places_restantes
FROM spaces s
LEFT JOIN reservations r ON s.id = r.space_id 
    AND r.booking_date = CURRENT_DATE 
    AND r.start_time = '10:00:00'
WHERE s.id = 'hyrox'
GROUP BY s.name, s.max_capacity;

---

## 3. Règle métier & Calcul isolé

La règle fondamentale est la régulation stricte à 20 places maximum par espace et par créneau horaire.

Formule de calcul :
Places restantes = max(0, 20 - réservations validées - sélections en panier)

Vérification des 3 cas (implémentés dans metier.js) :
1. Cas normal : Sur l'espace Cardio à 14h00, 6 places sont réservées et 1 est dans le panier.
   Calcul : 20 - 6 - 1 = 13 places restantes. Créneau réservable, jauge violette à 35% de remplissage.
2. Cas vide : Aucune réservation n'a encore été enregistrée sur le créneau.
   Calcul : 20 - 0 - 0 = 20 places restantes. Créneau totalement libre (20 places).
3. Cas limite : 20 personnes ont déjà validé leur place sur l'espace Séance jambe à 18h00.
   Calcul : 20 - 20 - 0 = 0 place. Le créneau passe automatiquement au statut Complet, se colore en rouge et le clic est bloqué (cursor-not-allowed).

---

## 4. Interface & Retours utilisateur

- Feedback interactif : Chaque créneau affiche le décompte exact (18 places rest.) et une jauge horizontale qui adapte sa couleur au remplissage (violet < 70%, orange >= 70%, rouge complet).
- Gestion des erreurs : Bouton de validation désactivé tant qu'aucun créneau n'est sélectionné, message d'erreur si le formulaire est incomplet et contrôle d'accès avec avertissement Code d'accès incorrect sur la console superviseur (mot de passe : 0129#).
- Espace Adhérent : Recherche par identifiant (memberId ou email) répartissant dynamiquement les séances en À venir et Passées.

---

## 5. Intégration et Cahier de tests manuels

| N° | Scénario de test | Entrée | Résultat attendu | Résultat obtenu | Statut |
|---|---|---|---|---|---|
| T1 (Normal) | Réservation standard | Zone Cardio, 10h00 (1h), Alex Dupont (GF-01) | Créneau ajouté au panier, 19 places restantes affichées, Pass QR SVG généré | Conforme : pass généré avec référence unique | Validé |
| T2 (Vide) | Panier vide / soumission sans sélection | Clic sur Valider sans créneau | Bouton désactivé, message d'indication invitant à choisir | Conforme : bouton inactif | Validé |
| T3 (Limite) | Saturation de la capacité | 20 réservations consécutives sur le même créneau | La 20e passe à 0 place, carte grisée et clic verrouillé | Conforme : statut Complet | Validé |
| T4 (Sécurité) | Authentification superviseur | Tentative avec code erroné puis 0129# | Blocage avec message rouge, puis ouverture du panneau sur code valide | Conforme : vue déverrouillée | Validé |

---

## 6. Déploiement, Architecture & Limites

### Procédure de reproduction
Le projet est exécuté dans un conteneur Node.js slim (Dockerfile) répondant aux exigences IHME :
- Port d'écoute : 3000
- Route de santé : /api/health renvoyant {"status":"ok"}
- Utilisateur d'exécution sécurisé : USER 1000
- Déploiement automatisé : GitHub Actions via webhook sécurisé (deploy.curl)

### Limites actuelles et pistes d'amélioration
- Persistance client : Le stockage repose actuellement sur localStorage dans le navigateur. L'amélioration consistera à brancher directement la base PostgreSQL fournie via DATABASE_URL en utilisant le schéma relationnel de schema.sql.
- Règles avancées : Limiter le nombre de réservations actives simultanées par numéro d'adhérent (ex. 3 par semaine).