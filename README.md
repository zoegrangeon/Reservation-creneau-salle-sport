# GymFlow — Réservation de créneaux en salle de sport

Interface web interactive de gestion des flux d'entraînement et de régulation des accès en salle de sport, conçue dans le cadre du cours **IHME** (Polytech Marseille).

- **URL de l'application en ligne** : `https://node219697-ihme26.jcloud.ik-server.com/reservation-de-creneaux-de-salle-de-sport/`
- **Conteneur & Registre** : `ghcr.io/zoegrangeon/reservation-creneau-salle-sport`

---

## 1. Cadrage du besoin

### Utilisateur cible
Étudiant(e) ou enseignant(e) de la filière STAPS / sportif régulier en salle universitaire s'entraînant sur des créneaux précis (cardio, force, préparation type Hyrox) nécessitant une disponibilité garantie des postes d'entraînement.

### Problème rencontré
Saturation imprévisible des plateaux sportifs aux heures de pointe, files d'attente sur les machines à charge guidée/libre, et absence de visibilité sur les créneaux disponibles.

### Entrées & Résultat attendu
- **Entrée** : Sélection d'une zone sportive, d'une date, d'un horaire (tranches de 30 min entre 6h et 23h), d'une durée (1h, 1h30, 2h) et des coordonnées athlète (Nom, Prénom, N° Adhérent, Email, Téléphone).
- **Résultat attendu** : Contrôle immédiat de la capacité (jauge visuelle), confirmation groupée, génération d'un pass avec QR code vectoriel SVG autonome et intégration dans l'historique du compte athlète.

---

## 2. Modèle de données & Schéma SQL

Le modèle relationnel s'appuie sur trois entités principales (détaillées dans le fichier `schema.sql`) :
- `spaces` : Espaces d'entraînement (`id`, `name`, `max_capacity` fixé à 20).
- `members` : Adhérents (`member_id` [PK], `first_name`, `last_name`, `email`, `phone`).
- `reservations` : Réservations confirmées (`id` [PK], `booking_ref`, `member_id` [FK], `space_id` [FK], `booking_date`, `start_time`, `end_time`, `duration_minutes`).

Exemple de requête SQL de calcul de disponibilité :
```sql
SELECT 
    s.name, 
    GREATEST(0, s.max_capacity - COUNT(r.id)) AS places_restantes
FROM spaces s
LEFT JOIN reservations r ON s.id = r.space_id 
    AND r.booking_date = CURRENT_DATE 
    AND r.start_time = '10:00:00'
WHERE s.id = 'hyrox'
GROUP BY s.name, s.max_capacity;