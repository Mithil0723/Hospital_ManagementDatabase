SELECT DISTINCT p.name AS patient_name, 
       r.room_no, 
       ph.name AS physician_name, 
       n.name AS nurse_name
FROM Patient p
JOIN PatientRoomStay prs ON p.patient_id = prs.patient_id
JOIN Room r ON prs.room_no = r.room_no
JOIN PhysicianMonitors pm ON p.patient_id = pm.patient_id
JOIN Physician ph ON pm.physician_id = ph.physician_id
JOIN OrderExecution oe ON p.patient_id = oe.patient_id
JOIN Nurse n ON oe.nurse_id = n.nurse_id
WHERE prs.check_out IS NULL;

SELECT p.name AS patient_name,
       i.account_no,
       i.issue_date AS invoice_date,
       py.description AS payable_description,
       py.amount AS payable_amount,
       py.pay_date AS payable_date,
       py.payable_type
FROM Patient p
JOIN Invoice i ON p.patient_id = i.patient_id
JOIN InvoicePayable ip ON i.account_no = ip.account_no AND i.issue_date = ip.issue_date
JOIN Payable py ON ip.payable_id = py.payable_id
ORDER BY p.name, i.issue_date, py.pay_date;

SELECT ph.name AS physician_name,
       ph.specialty,
       p.name AS patient_name,
       pm.start_date,
       pm.end_date,
       CASE 
           WHEN pm.end_date IS NULL THEN 'Currently Monitoring'
           ELSE 'Monitoring Completed'
       END AS monitoring_status
FROM Physician ph
JOIN PhysicianMonitors pm ON ph.physician_id = pm.physician_id
JOIN Patient p ON pm.patient_id = p.patient_id
ORDER BY ph.name, pm.start_date;


-- CATEGORY B: AGGREGATION QUERIES 

SELECT YEAR(pay_date) AS year, 
       MONTH(pay_date) AS month, 
       SUM(amount) AS total_revenue,
       COUNT(*) AS number_of_charges
FROM Payable
GROUP BY YEAR(pay_date), MONTH(pay_date)
ORDER BY year DESC, month DESC;

SELECT ph.name AS physician_name,
       ph.specialty,
       COUNT(DISTINCT pm.patient_id) AS patients_monitored,
       COUNT(DISTINCT c.order_code) AS orders_created
FROM Physician ph
LEFT JOIN PhysicianMonitors pm ON ph.physician_id = pm.physician_id
LEFT JOIN Creates c ON ph.physician_id = c.physician_id
GROUP BY ph.physician_id, ph.name, ph.specialty
ORDER BY patients_monitored DESC, orders_created DESC;

SELECT p.name AS patient_name,
       COUNT(ma.admin_id) AS medication_administrations,
       AVG(ma.amount_given) AS average_medication_amount,
       MAX(ma.amount_given) AS maximum_medication_amount,
       SUM(ma.amount_given) AS total_medication_given
FROM Patient p
JOIN MedicationAdministration ma ON p.patient_id = ma.patient_id
GROUP BY p.patient_id, p.name
ORDER BY total_medication_given DESC;


-- CATEGORY C: NESTED/CORRELATED QUERIES 

SELECT p.patient_id, p.name,
       (SELECT COALESCE(SUM(amount), 0) FROM Payable WHERE patient_id = p.patient_id) AS total_charges,
       (SELECT COALESCE(SUM(amount), 0) FROM Payment WHERE patient_id = p.patient_id) AS total_payments,
       (SELECT COALESCE(SUM(amount), 0) FROM Payable WHERE patient_id = p.patient_id) - 
       (SELECT COALESCE(SUM(amount), 0) FROM Payment WHERE patient_id = p.patient_id) AS outstanding_balance
FROM Patient p
WHERE (SELECT COALESCE(SUM(amount), 0) FROM Payable WHERE patient_id = p.patient_id) >
      (SELECT COALESCE(SUM(amount), 0) FROM Payment WHERE patient_id = p.patient_id);

SELECT ph.name AS physician_name,
       COUNT(c.order_code) AS orders_created,
       AVG(o.fee) AS avg_order_fee
FROM Physician ph
JOIN Creates c ON ph.physician_id = c.physician_id
JOIN `Order` o ON c.order_code = o.order_code
GROUP BY ph.physician_id, ph.name
HAVING AVG(o.fee) > (SELECT AVG(fee) FROM `Order`);

SELECT r.room_no,
       r.capacity,
       COUNT(prs.patient_id) AS current_occupancy,
       (r.capacity - COUNT(prs.patient_id)) AS available_spots
FROM Room r
LEFT JOIN PatientRoomStay prs ON r.room_no = prs.room_no AND prs.check_out IS NULL
GROUP BY r.room_no, r.capacity
HAVING COUNT(prs.patient_id) < (
    SELECT AVG(occupancy_count) 
    FROM (
        SELECT COUNT(patient_id) AS occupancy_count
        FROM PatientRoomStay
        WHERE check_out IS NULL
        GROUP BY room_no
    ) AS avg_occupancy
)
ORDER BY available_spots DESC;


-- CATEGORY D: ADVANCED QUERIES

SELECT p.name AS patient_name,
       prs.check_in,
       prs.check_out,
       DATEDIFF(COALESCE(prs.check_out, CURDATE()), prs.check_in) AS stay_duration_days,
       r.nightly_fee,
       (DATEDIFF(COALESCE(prs.check_out, CURDATE()), prs.check_in) * r.nightly_fee) AS total_room_cost,
       CASE 
           WHEN prs.check_out IS NULL THEN 'Currently Admitted'
           ELSE 'Discharged'
       END AS status
FROM Patient p
JOIN PatientRoomStay prs ON p.patient_id = prs.patient_id
JOIN Room r ON prs.room_no = r.room_no
ORDER BY stay_duration_days DESC;

SELECT p.patient_id,
       p.name AS patient_name,
       COUNT(hr.record_id) AS number_of_conditions,
       GROUP_CONCAT(hr.disease SEPARATOR ', ') AS conditions_list
FROM Patient p
JOIN HealthRecord hr ON p.patient_id = hr.patient_id
GROUP BY p.patient_id, p.name
HAVING COUNT(hr.record_id) > 1
ORDER BY number_of_conditions DESC;

SELECT ph.physician_id,
       ph.name AS physician_name,
       ph.specialty,
       ph.cert_no
FROM Physician ph
LEFT JOIN PhysicianMonitors pm ON ph.physician_id = pm.physician_id
WHERE pm.physician_id IS NULL
ORDER BY ph.specialty;

SELECT YEAR(pay_date) AS payment_year,
       MONTH(pay_date) AS payment_month,
       COUNT(*) AS number_of_payments,
       SUM(amount) AS total_payments_received,
       AVG(amount) AS average_payment_amount
FROM Payment
GROUP BY YEAR(pay_date), MONTH(pay_date)
ORDER BY payment_year DESC, payment_month DESC;

SELECT p.patient_id,
       p.name AS patient_name,
       p.phone,
       COUNT(prs.stay_id) AS number_of_stays
FROM Patient p
JOIN PatientRoomStay prs ON p.patient_id = prs.patient_id
WHERE NOT EXISTS (
    SELECT 1
    FROM Invoice i
    WHERE i.patient_id = p.patient_id
    AND i.issue_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
GROUP BY p.patient_id, p.name, p.phone
ORDER BY number_of_stays DESC;

SELECT o.order_code,
       o.description,
       o.fee,
       COUNT(oe.exec_id) AS times_executed,
       SUM(o.fee) AS total_revenue_generated
FROM `Order` o
LEFT JOIN OrderExecution oe ON o.order_code = oe.order_code
GROUP BY o.order_code, o.description, o.fee
ORDER BY o.fee DESC
LIMIT 5;

SELECT n.name AS nurse_name,
       COUNT(DISTINCT oe.exec_id) AS orders_executed,
       COUNT(DISTINCT ma.admin_id) AS medications_given,
       COUNT(DISTINCT oe.patient_id) AS patients_served,
       ROUND((COUNT(DISTINCT oe.exec_id) * 100.0 / 
              (SELECT COUNT(*) FROM OrderExecution)), 2) AS percentage_of_total_orders
FROM Nurse n
LEFT JOIN OrderExecution oe ON n.nurse_id = oe.nurse_id
LEFT JOIN MedicationAdministration ma ON n.nurse_id = ma.nurse_id
GROUP BY n.nurse_id, n.name
ORDER BY orders_executed DESC, medications_given DESC;