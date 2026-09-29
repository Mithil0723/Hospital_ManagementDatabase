CREATE VIEW v_Patient_Balance AS
SELECT p.patient_id, 
       p.name AS patient_name,
       p.address,
       p.phone,
       COALESCE(SUM(pay.amount), 0) AS total_charges,
       COALESCE(SUM(pmt.amount), 0) AS total_payments,
       COALESCE(SUM(pay.amount), 0) - COALESCE(SUM(pmt.amount), 0) AS current_balance,
       CASE 
           WHEN COALESCE(SUM(pay.amount), 0) - COALESCE(SUM(pmt.amount), 0) > 0 THEN 'Outstanding'
           WHEN COALESCE(SUM(pay.amount), 0) - COALESCE(SUM(pmt.amount), 0) < 0 THEN 'Overpaid'
           ELSE 'Settled'
       END AS balance_status
FROM Patient p
LEFT JOIN Payable pay ON p.patient_id = pay.patient_id
LEFT JOIN Payment pmt ON p.patient_id = pmt.patient_id
GROUP BY p.patient_id, p.name, p.address, p.phone;

CREATE VIEW v_Staff_Directory AS
SELECT physician_id AS staff_id,
       name AS staff_name,
       'Physician' AS role,
       phone AS contact_phone,
       specialty AS department_specialty
FROM Physician
UNION ALL
SELECT nurse_id AS staff_id,
       name AS staff_name,
       'Nurse' AS role,
       phone AS contact_phone,
       'Nursing' AS department_specialty
FROM Nurse
ORDER BY role, staff_name;

CREATE VIEW v_Current_Admissions AS
SELECT prs.stay_id,
       p.patient_id,
       p.name AS patient_name,
       p.phone AS patient_phone,
       r.room_no,
       r.capacity AS room_capacity,
       prs.check_in AS admission_date,
       DATEDIFF(CURDATE(), prs.check_in) AS days_admitted,
       r.nightly_fee
FROM Patient p
JOIN PatientRoomStay prs ON p.patient_id = prs.patient_id
JOIN Room r ON prs.room_no = r.room_no
WHERE prs.check_out IS NULL;

CREATE VIEW v_Physician_Workload AS
SELECT ph.physician_id,
       ph.name AS physician_name,
       ph.specialty,
       COUNT(DISTINCT pm.patient_id) AS current_patients,
       COUNT(DISTINCT c.order_code) AS orders_created,
       AVG(o.fee) AS avg_order_value,
       ph.phone AS contact_phone
FROM Physician ph
LEFT JOIN PhysicianMonitors pm ON ph.physician_id = pm.physician_id AND pm.end_date IS NULL
LEFT JOIN Creates c ON ph.physician_id = c.physician_id
LEFT JOIN `Order` o ON c.order_code = o.order_code
GROUP BY ph.physician_id, ph.name, ph.specialty, ph.phone;

CREATE VIEW v_Medication_Summary AS
SELECT mt.med_code,
       mt.name AS medication_name,
       mt.unit_cost,
       COUNT(ma.admin_id) AS times_administered,
       SUM(ma.amount_given) AS total_amount_used,
       SUM(ma.amount_given * mt.unit_cost) AS total_medication_cost,
       AVG(ma.amount_given) AS average_dose,
       COUNT(DISTINCT ma.patient_id) AS patients_treated
FROM MedicationType mt
LEFT JOIN MedicationAdministration ma ON mt.med_code = ma.med_code
GROUP BY mt.med_code, mt.name, mt.unit_cost
ORDER BY total_medication_cost DESC;

