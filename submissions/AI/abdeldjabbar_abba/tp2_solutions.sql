-- TP2: Hospital Management System


-- 1. Create and use the database
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- 2. Create tables with constraints

-- Table: specialties
CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL
);

-- Table: doctors
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialty_id INT NOT NULL,
    license_number VARCHAR(20) UNIQUE NOT NULL,
    hire_date DATE,
    office VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table: patients
CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    file_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M','F') NOT NULL,
    blood_type VARCHAR(5),
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    province VARCHAR(50),
    registration_date DATE DEFAULT (CURRENT_DATE),
    insurance VARCHAR(100),
    insurance_number VARCHAR(50),
    allergies TEXT,
    medical_history TEXT
);

-- Table: consultations
CREATE TABLE consultations (
    consultation_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_date DATETIME NOT NULL,
    reason TEXT NOT NULL,
    diagnosis TEXT,
    observations TEXT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4,2),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    status ENUM('Scheduled','In Progress','Completed','Cancelled') DEFAULT 'Scheduled',
    amount DECIMAL(10,2),
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: medications
CREATE TABLE medications (
    medication_id INT PRIMARY KEY AUTO_INCREMENT,
    medication_code VARCHAR(20) UNIQUE NOT NULL,
    commercial_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    form VARCHAR(50),
    dosage VARCHAR(50),
    manufacturer VARCHAR(100),
    unit_price DECIMAL(10,2) NOT NULL,
    available_stock INT DEFAULT 0,
    minimum_stock INT DEFAULT 10,
    expiration_date DATE,
    prescription_required BOOLEAN DEFAULT TRUE,
    reimbursable BOOLEAN DEFAULT FALSE
);

-- Table: prescriptions
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: prescription_details
CREATE TABLE prescription_details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================
-- 3. Create indexes
-- ============================================
CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consultation_patient ON consultations(patient_id);
CREATE INDEX idx_consultation_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consult ON prescriptions(consultation_id);

-- ============================================
-- 4. Insert test data
-- ============================================

-- Specialties (6)
INSERT INTO specialties (specialty_id, specialty_name, description, consultation_fee) VALUES
(1, 'General Medicine', 'General medical consultations', 1500.00),
(2, 'Cardiology', 'Heart and cardiovascular system', 2500.00),
(3, 'Pediatrics', 'Children''s health', 2000.00),
(4, 'Dermatology', 'Skin conditions', 1800.00),
(5, 'Orthopedics', 'Musculoskeletal system', 2200.00),
(6, 'Gynecology', 'Women''s reproductive health', 2300.00);

-- Doctors (6, one per specialty)
INSERT INTO doctors (doctor_id, last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
(1, 'Smith', 'John', 'john.smith@hospital.com', '0550-123456', 1, 'LIC001', '2015-06-01', 'Room 101', TRUE),
(2, 'Johnson', 'Emily', 'emily.johnson@hospital.com', '0550-123457', 2, 'LIC002', '2016-09-15', 'Room 202', TRUE),
(3, 'Williams', 'Michael', 'michael.williams@hospital.com', '0550-123458', 3, 'LIC003', '2017-03-10', 'Room 103', TRUE),
(4, 'Brown', 'Sarah', 'sarah.brown@hospital.com', '0550-123459', 4, 'LIC004', '2018-11-20', 'Room 204', TRUE),
(5, 'Jones', 'David', 'david.jones@hospital.com', '0550-123460', 5, 'LIC005', '2014-01-12', 'Room 105', TRUE),
(6, 'Garcia', 'Maria', 'maria.garcia@hospital.com', '0550-123461', 6, 'LIC006', '2019-07-08', 'Room 206', TRUE);

-- Patients (8)
INSERT INTO patients (patient_id, file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, insurance, insurance_number, allergies, medical_history) VALUES
(1, 'PAT001', 'Doe', 'John', '1985-03-15', 'M', 'O+', 'john.doe@email.com', '0555-111111', '123 Main St', 'Algiers', 'Algiers', 'CNAS', 'INS001', 'None', 'Hypertension'),
(2, 'PAT002', 'Smith', 'Jane', '1990-07-22', 'F', 'A+', 'jane.smith@email.com', '0555-222222', '456 Oak Ave', 'Oran', 'Oran', 'CASNOS', 'INS002', 'Penicillin', 'None'),
(3, 'PAT003', 'Miller', 'Robert', '1978-11-05', 'M', 'B-', 'robert.miller@email.com', '0555-333333', '789 Pine Rd', 'Constantine', 'Constantine', NULL, NULL, 'Sulfa', 'Diabetes'),
(4, 'PAT004', 'Davis', 'Linda', '2005-09-12', 'F', 'AB+', 'linda.davis@email.com', '0555-444444', '321 Elm St', 'Annaba', 'Annaba', 'CNAS', 'INS004', 'None', 'Asthma'),
(5, 'PAT005', 'Garcia', 'Carlos', '1950-12-01', 'M', 'O-', 'carlos.garcia@email.com', '0555-555555', '654 Maple Dr', 'Blida', 'Blida', 'CASNOS', 'INS005', 'None', 'Arthritis'),
(6, 'PAT006', 'Wilson', 'Emma', '2012-04-18', 'F', 'A-', 'emma.wilson@email.com', '0555-666666', '987 Cedar Ln', 'Setif', 'Setif', NULL, NULL, 'Peanuts', 'None'),
(7, 'PAT007', 'Martinez', 'Jose', '1982-08-30', 'M', 'B+', 'jose.martinez@email.com', '0555-777777', '147 Birch Blvd', 'Tizi Ouzou', 'Tizi Ouzou', 'CNAS', 'INS007', 'None', 'None'),
(8, 'PAT008', 'Anderson', 'Sophia', '1970-02-25', 'F', 'AB-', 'sophia.anderson@email.com', '0555-888888', '258 Spruce Way', 'Bejaia', 'Bejaia', 'CASNOS', 'INS008', 'Ibuprofen', 'Migraine');

-- Consultations (8)
INSERT INTO consultations (consultation_id, patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 1, 1, '2025-01-10 09:30:00', 'Chest pain', 'Angina', 'Patient stable', '120/80', 36.6, 85.5, 175, 'Completed', 1500.00, TRUE),
(2, 2, 2, '2025-01-15 10:00:00', 'Palpitations', 'Arrhythmia', 'ECG normal', '130/85', 36.8, 62.0, 162, 'Completed', 2500.00, TRUE),
(3, 3, 3, '2025-01-20 11:15:00', 'Fever', 'Viral infection', 'Prescribed antipyretics', '115/75', 38.5, 80.0, 170, 'Completed', 2000.00, FALSE),
(4, 4, 4, '2025-02-05 14:30:00', 'Skin rash', 'Eczema', 'Topical cream prescribed', '110/70', 36.7, 45.0, 150, 'Completed', 1800.00, TRUE),
(5, 5, 5, '2025-02-10 09:00:00', 'Knee pain', 'Osteoarthritis', 'Referred to physiotherapy', '140/90', 36.5, 88.0, 168, 'Completed', 2200.00, FALSE),
(6, 6, 3, '2025-02-15 15:45:00', 'Cough', 'Bronchitis', 'Antibiotics prescribed', '105/65', 37.2, 30.0, 125, 'Completed', 2000.00, TRUE),
(7, 7, 1, '2025-03-01 08:30:00', 'Headache', 'Migraine', 'Rest and painkillers', '125/85', 36.9, 72.0, 172, 'Scheduled', 1500.00, FALSE),
(8, 8, 6, '2025-03-05 16:00:00', 'Routine check', 'Normal', 'All good', '118/78', 36.6, 65.0, 160, 'Scheduled', 2300.00, FALSE);

-- Medications (10)
INSERT INTO medications (medication_id, medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
(1, 'MED001', 'Paracetamol', 'Acetaminophen', 'Tablet', '500mg', 'PharmaCo', 150.00, 500, 100, '2026-12-31', FALSE, TRUE),
(2, 'MED002', 'Amoxicillin', 'Amoxicillin', 'Capsule', '250mg', 'HealthPharm', 350.00, 200, 50, '2025-06-30', TRUE, TRUE),
(3, 'MED003', 'Ibuprofen', 'Ibuprofen', 'Tablet', '400mg', 'MediLab', 200.00, 300, 80, '2026-03-15', FALSE, TRUE),
(4, 'MED004', 'Lisinopril', 'Lisinopril', 'Tablet', '10mg', 'CardioHealth', 400.00, 150, 40, '2025-09-30', TRUE, TRUE),
(5, 'MED005', 'Metformin', 'Metformin', 'Tablet', '500mg', 'DiabeCare', 250.00, 100, 30, '2025-07-31', TRUE, TRUE),
(6, 'MED006', 'Omeprazole', 'Omeprazole', 'Capsule', '20mg', 'GastroMed', 300.00, 80, 25, '2025-10-31', FALSE, FALSE),
(7, 'MED007', 'Salbutamol', 'Albuterol', 'Inhaler', '100mcg/dose', 'Respira', 800.00, 40, 15, '2025-05-31', TRUE, TRUE),
(8, 'MED008', 'Ciprofloxacin', 'Ciprofloxacin', 'Tablet', '500mg', 'AntiBac', 500.00, 60, 20, '2025-08-31', TRUE, TRUE),
(9, 'MED009', 'Cetirizine', 'Cetirizine', 'Tablet', '10mg', 'AllergyFree', 120.00, 400, 100, '2026-01-31', FALSE, FALSE),
(10, 'MED010', 'Diazepam', 'Diazepam', 'Tablet', '5mg', 'NervMed', 450.00, 30, 10, '2025-04-30', TRUE, FALSE);

-- Prescriptions (7)
INSERT INTO prescriptions (prescription_id, consultation_id, prescription_date, treatment_duration, general_instructions) VALUES
(1, 1, '2025-01-10 10:30:00', 30, 'Take one tablet daily'),
(2, 2, '2025-01-15 10:45:00', 15, 'Take as needed'),
(3, 3, '2025-01-20 12:00:00', 7, 'Complete the course'),
(4, 4, '2025-02-05 15:00:00', 14, 'Apply twice daily'),
(5, 5, '2025-02-10 09:30:00', 30, 'Take with food'),
(6, 6, '2025-02-15 16:15:00', 10, 'Take after meals'),
(7, 7, '2025-03-01 09:00:00', 5, 'Rest and hydrate');

-- Prescription Details (12)
INSERT INTO prescription_details (detail_id, prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 1, 30, '1 tablet daily', 30, 150.00 * 30),
(2, 1, 4, 30, '1 tablet daily', 30, 400.00 * 30),
(3, 2, 3, 15, '1 tablet every 8h if pain', 15, 200.00 * 15),
(4, 3, 2, 21, '1 capsule 3 times daily', 7, 350.00 * 21),
(5, 3, 1, 14, '1 tablet for fever', 7, 150.00 * 14),
(6, 4, 9, 1, 'Apply twice daily', 14, 120.00 * 1),
(7, 5, 5, 90, '1 tablet twice daily', 30, 250.00 * 90),
(8, 5, 8, 60, '1 tablet daily', 30, 500.00 * 60),
(9, 6, 2, 20, '1 capsule 3 times daily', 7, 350.00 * 20),
(10, 6, 7, 1, 'Use as needed', 10, 800.00 * 1),
(11, 7, 1, 10, '1 tablet every 6h if headache', 5, 150.00 * 10),
(12, 7, 10, 10, '1 tablet at bedtime', 5, 450.00 * 10);

-- ============================================
-- 5. Solutions to the 30 queries
-- ============================================

-- ========== PART 1: BASIC QUERIES ==========

-- Q1. List all patients with their main information
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city FROM patients;

-- Q2. Display all doctors with their specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active
FROM doctors d JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3. Find all medications with price less than 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;

-- Q4. List consultations from January 2025
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.status
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.consultation_date BETWEEN '2025-01-01' AND '2025-01-31';

-- Q5. Display medications where stock is below minimum stock
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;

-- ========== PART 2: QUERIES WITH JOINS ==========

-- Q6. Display all consultations with patient and doctor names
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.diagnosis, c.amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7. List all prescriptions with medication details
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       m.commercial_name AS medication_name, pd.quantity, pd.dosage_instructions
FROM prescriptions pr
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.medication_id
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients p ON c.patient_id = p.patient_id;

-- Q8. Display patients with their last consultation date
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       MAX(c.consultation_date) AS last_consultation_date,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
GROUP BY p.patient_id;

-- Q9. List doctors and the number of consultations performed
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id;

-- Q10. Display revenue by medical specialty
SELECT s.specialty_name, SUM(c.amount) AS total_revenue, COUNT(c.consultation_id) AS consultation_count
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id;

-- ========== PART 3: AGGREGATE FUNCTIONS ==========

-- Q11. Calculate total prescription amount per patient
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       SUM(pd.total_price) AS total_prescription_cost
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY p.patient_id;

-- Q12. Count the number of consultations per doctor (same as Q9)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id;

-- Q13. Calculate total stock value of pharmacy
SELECT COUNT(*) AS total_medications, SUM(unit_price * available_stock) AS total_stock_value FROM medications;

-- Q14. Find average consultation price per specialty
SELECT s.specialty_name, AVG(c.amount) AS average_price
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id;

-- Q15. Count number of patients by blood type
SELECT blood_type, COUNT(*) AS patient_count FROM patients WHERE blood_type IS NOT NULL GROUP BY blood_type;

-- ========== PART 4: ADVANCED QUERIES ==========

-- Q16. Find the top 5 most prescribed medications
SELECT m.commercial_name AS medication_name, COUNT(pd.detail_id) AS times_prescribed, SUM(pd.quantity) AS total_quantity
FROM medications m
JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC
LIMIT 5;

-- Q17. List patients who have never had a consultation
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date
FROM patients p
WHERE NOT EXISTS (SELECT 1 FROM consultations c WHERE c.patient_id = p.patient_id);

-- Q18. Display doctors who performed more than 2 consultations
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
HAVING COUNT(c.consultation_id) > 2;

-- Q19. Find unpaid consultations with total amount
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.consultation_date, c.amount,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE;

-- Q20. List medications expiring in less than 6 months from today
SELECT commercial_name AS medication_name, expiration_date,
       DATEDIFF(expiration_date, CURDATE()) AS days_until_expiration
FROM medications
WHERE expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- ========== PART 5: SUBQUERIES ==========

-- Q21. Find patients who consulted more than the average
WITH patient_counts AS (
    SELECT p.patient_id, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, COUNT(c.consultation_id) AS consultation_count
    FROM patients p
    LEFT JOIN consultations c ON p.patient_id = c.patient_id
    GROUP BY p.patient_id
),
avg_count AS (
    SELECT AVG(consultation_count) AS avg_consultations FROM patient_counts
)
SELECT patient_name, consultation_count, (SELECT avg_consultations FROM avg_count) AS average_count
FROM patient_counts
WHERE consultation_count > (SELECT avg_consultations FROM avg_count);

-- Q22. List medications more expensive than average price
SELECT commercial_name AS medication_name, unit_price,
       (SELECT AVG(unit_price) FROM medications) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Display doctors from the most requested specialty
WITH specialty_counts AS (
    SELECT s.specialty_id, s.specialty_name, COUNT(c.consultation_id) AS consultation_count
    FROM specialties s
    JOIN doctors d ON s.specialty_id = d.specialty_id
    LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
    GROUP BY s.specialty_id
),
max_specialty AS (
    SELECT specialty_id FROM specialty_counts ORDER BY consultation_count DESC LIMIT 1
)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name,
       (SELECT consultation_count FROM specialty_counts WHERE specialty_id = s.specialty_id) AS specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
WHERE d.specialty_id = (SELECT specialty_id FROM max_specialty);

-- Q24. Find consultations with amount higher than average
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.amount,
       (SELECT AVG(amount) FROM consultations) AS average_amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount > (SELECT AVG(amount) FROM consultations);

-- Q25. List allergic patients who received a prescription
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, p.allergies, COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL AND p.allergies != 'None'
GROUP BY p.patient_id;

-- ========== PART 6: BUSINESS ANALYSIS ==========

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       COUNT(c.consultation_id) AS total_consultations,
       SUM(c.amount) AS total_revenue
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
GROUP BY d.doctor_id;

-- Q27. Display top 3 most profitable specialties
SELECT RANK() OVER (ORDER BY SUM(c.amount) DESC) AS rank,
       s.specialty_name,
       SUM(c.amount) AS total_revenue
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id
ORDER BY total_revenue DESC
LIMIT 3;

-- Q28. List medications to restock (stock < minimum)
SELECT commercial_name AS medication_name, available_stock AS current_stock,
       minimum_stock, (minimum_stock - available_stock) AS quantity_needed
FROM medications
WHERE available_stock < minimum_stock;

-- Q29. Calculate average number of medications per prescription
SELECT AVG(med_count) AS average_medications_per_prescription
FROM (
    SELECT prescription_id, COUNT(*) AS med_count
    FROM prescription_details
    GROUP BY prescription_id
) AS counts;

-- Q30. Generate patient demographics report by age group
WITH age_groups AS (
    SELECT
        CASE
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 18 THEN '0-18'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
            ELSE '60+'
        END AS age_group
    FROM patients
)
SELECT age_group, COUNT(*) AS patient_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 2) AS percentage
FROM age_groups
GROUP BY age_group
ORDER BY age_group;