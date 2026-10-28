-- Schéma relationnel GymFlow - Gestion des réservations et jauges

CREATE TABLE IF NOT EXISTS spaces (
    id VARCHAR(32) PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    max_capacity INTEGER NOT NULL DEFAULT 20
);

CREATE TABLE IF NOT EXISTS members (
    member_id VARCHAR(32) PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    email VARCHAR(128) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS reservations (
    id SERIAL PRIMARY KEY,
    booking_ref VARCHAR(32) NOT NULL,
    member_id VARCHAR(32) REFERENCES members(member_id),
    space_id VARCHAR(32) REFERENCES spaces(id),
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes IN (60, 90, 120)),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Données d'exemple
INSERT INTO spaces (id, name, max_capacity) VALUES
('cardio', 'Espace cardio', 20),
('hyrox', 'Espace hyrox', 20),
('lower', 'Séance jambe', 20),
('upper', 'Séance haut du corps', 20)
ON CONFLICT (id) DO NOTHING;

INSERT INTO members (member_id, first_name, last_name, email, phone) VALUES
('GF-2026-01', 'Alex', 'Dupont', 'alex.dupont@email.fr', '0612345678')
ON CONFLICT (member_id) DO NOTHING;

-- Requête métier : Calcul des places restantes (règle des 20 places)
SELECT 
    s.id AS space_id,
    s.name AS space_name,
    s.max_capacity,
    COUNT(r.id) AS booked_count,
    GREATEST(0, s.max_capacity - COUNT(r.id)) AS remaining_seats
FROM spaces s
LEFT JOIN reservations r 
    ON s.id = r.space_id 
    AND r.booking_date = '2026-10-28' 
    AND r.start_time = '09:00:00'
WHERE s.id = 'hyrox'
GROUP BY s.id, s.name, s.max_capacity;

-- Requête historique : Séances à venir et passées
SELECT 
    r.booking_ref,
    s.name AS space_name,
    r.booking_date,
    r.start_time,
    r.end_time,
    CASE 
        WHEN (r.booking_date + r.end_time) >= CURRENT_TIMESTAMP THEN 'A venir'
        ELSE 'Passe'
    END AS status
FROM reservations r
JOIN spaces s ON r.space_id = s.id
WHERE r.member_id = 'GF-2026-01'
ORDER BY r.booking_date DESC, r.start_time DESC;