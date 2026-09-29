INSERT INTO Patient (name, address, phone) VALUES
('John Smith', '123 Main St, Chicago, IL', '312-555-0101'),
('Sarah Johnson', '456 Oak Ave, Chicago, IL', '312-555-0102'),
('Michael Brown', '789 Pine St, Chicago, IL', '312-555-0103'),
('Emily Davis', '321 Elm St, Chicago, IL', '312-555-0104'),
('David Wilson', '654 Maple Ave, Chicago, IL', '312-555-0105'),
('Lisa Anderson', '987 Cedar St, Chicago, IL', '312-555-0106'),
('Robert Taylor', '147 Birch Ave, Chicago, IL', '312-555-0107');

INSERT INTO Room (room_no, capacity, nightly_fee) VALUES
(101, 1, 250.00),
(102, 1, 250.00),
(103, 2, 180.00),
(104, 2, 180.00),
(105, 1, 300.00),
(201, 1, 275.00),
(202, 2, 200.00);

INSERT INTO Physician (name, cert_no, specialty, address, phone) VALUES
('Dr. James Wilson', 'MD12345', 'Cardiology', '100 Medical Center Dr, Chicago, IL', '312-555-1001'),
('Dr. Lisa House', 'MD12346', 'Neurology', '101 Medical Center Dr, Chicago, IL', '312-555-1002'),
('Dr. Robert Chase', 'MD12347', 'Internal Medicine', '102 Medical Center Dr, Chicago, IL', '312-555-1003'),
('Dr. Allison Cameron', 'MD12348', 'Emergency Medicine', '103 Medical Center Dr, Chicago, IL', '312-555-1004'),
('Dr. Eric Foreman', 'MD12349', 'Radiology', '104 Medical Center Dr, Chicago, IL', '312-555-1005'),
('Dr. Martha Stewart', 'MD12350', 'Pediatrics', '105 Medical Center Dr, Chicago, IL', '312-555-1006');

INSERT INTO Nurse (name, cert_no, address, phone) VALUES
('Nurse Jennifer Adams', 'RN54321', '200 Nurse Ave, Chicago, IL', '312-555-2001'),
('Nurse Michael Clark', 'RN54322', '201 Nurse Ave, Chicago, IL', '312-555-2002'),
('Nurse Susan Miller', 'RN54323', '202 Nurse Ave, Chicago, IL', '312-555-2003'),
('Nurse Daniel Garcia', 'RN54324', '203 Nurse Ave, Chicago, IL', '312-555-2004'),
('Nurse Patricia Martinez', 'RN54325', '204 Nurse Ave, Chicago, IL', '312-555-2005'),
('Nurse Kevin Rodriguez', 'RN54326', '205 Nurse Ave, Chicago, IL', '312-555-2006');

INSERT INTO `Order` (order_code, description, fee) VALUES
('ORD001', 'Blood pressure monitoring', 45.00),
('ORD002', 'IV fluid administration', 85.00),
('ORD003', 'Wound dressing change', 65.00),
('ORD004', 'Physical therapy session', 120.00),
('ORD005', 'X-ray chest', 150.00),
('ORD006', 'ECG monitoring', 75.00),
('ORD007', 'Medication administration', 35.00);

INSERT INTO MedicationType (med_code, name, unit_cost) VALUES
('MED001', 'Amoxicillin 500mg', 12.50),
('MED002', 'Ibuprofen 200mg', 8.75),
('MED003', 'Lisinopril 10mg', 15.25),
('MED004', 'Metformin 500mg', 9.80),
('MED005', 'Atorvastatin 20mg', 22.50),
('MED006', 'Omeprazole 20mg', 18.75),
('MED007', 'Aspirin 81mg', 5.25);

INSERT INTO HealthRecord (patient_id, disease, diagnosis_date, status, details) VALUES
(1, 'Hypertension', '2024-01-15', 'ongoing', 'High blood pressure, requires daily medication'),
(1, 'Type 2 Diabetes', '2024-02-20', 'ongoing', 'Controlled with medication and diet'),
(2, 'Pneumonia', '2024-07-01', 'resolved', 'Bacterial pneumonia, treated with antibiotics'),
(3, 'Broken Arm', '2024-06-15', 'resolved', 'Fracture of left radius, healed completely'),
(4, 'Migraine', '2024-03-10', 'chronic', 'Recurring migraine headaches'),
(5, 'Appendicitis', '2024-07-20', 'resolved', 'Acute appendicitis, surgically removed'),
(6, 'Asthma', '2024-01-05', 'ongoing', 'Chronic asthma, managed with inhalers');

INSERT INTO PatientRoomStay (patient_id, room_no, check_in, check_out) VALUES
(1, 101, '2024-07-01', '2024-07-05'),
(2, 102, '2024-07-02', '2024-07-07'),
(3, 103, '2024-06-15', '2024-06-20'),
(4, 104, '2024-07-10', '2024-07-12'),
(5, 105, '2024-07-20', '2024-07-25'),
(6, 201, '2024-07-15', NULL), -- Still admitted
(7, 202, '2024-07-22', NULL); -- Still admitted

INSERT INTO PhysicianMonitors (physician_id, patient_id, start_date, end_date) VALUES
(1, 1, '2024-07-01', '2024-07-05'),
(2, 2, '2024-07-02', '2024-07-07'),
(3, 3, '2024-06-15', '2024-06-20'),
(4, 4, '2024-07-10', '2024-07-12'),
(5, 5, '2024-07-20', '2024-07-25'),
(6, 6, '2024-07-15', NULL), -- Ongoing
(1, 7, '2024-07-22', NULL); -- Ongoing

INSERT INTO Creates (physician_id, order_code, creation_date) VALUES
(1, 'ORD001', '2024-07-01'),
(1, 'ORD006', '2024-07-01'),
(2, 'ORD005', '2024-07-02'),
(3, 'ORD002', '2024-06-15'),
(4, 'ORD003', '2024-07-10'),
(5, 'ORD005', '2024-07-20'),
(6, 'ORD004', '2024-07-15');

INSERT INTO OrderExecution (nurse_id, order_code, patient_id, exec_status, exec_time) VALUES
(1, 'ORD001', 1, 'completed', '2024-07-01 10:30:00'),
(1, 'ORD006', 1, 'completed', '2024-07-01 14:00:00'),
(2, 'ORD005', 2, 'completed', '2024-07-02 09:15:00'),
(3, 'ORD002', 3, 'completed', '2024-06-15 11:45:00'),
(4, 'ORD003', 4, 'completed', '2024-07-10 16:20:00'),
(5, 'ORD005', 5, 'completed', '2024-07-20 13:30:00'),
(6, 'ORD004', 6, 'pending', '2024-07-15 08:00:00');

INSERT INTO MedicationAdministration (nurse_id, patient_id, med_code, admin_date, amount_given) VALUES
(1, 1, 'MED003', '2024-07-01', 1.00),
(1, 1, 'MED004', '2024-07-02', 1.00),
(2, 2, 'MED001', '2024-07-02', 2.00),
(3, 3, 'MED002', '2024-06-16', 1.00),
(4, 4, 'MED002', '2024-07-11', 1.50),
(5, 5, 'MED001', '2024-07-21', 3.00),
(6, 6, 'MED006', '2024-07-16', 1.00);

INSERT INTO Payable (patient_id, amount, pay_date, description, payable_type) VALUES
(1, 1000.00, '2024-07-05', 'Room charges for 4 nights', 'room'),
(1, 45.00, '2024-07-01', 'Blood pressure monitoring', 'order'),
(1, 75.00, '2024-07-01', 'ECG monitoring', 'order'),
(1, 15.25, '2024-07-01', 'Lisinopril medication', 'medication'),
(2, 1250.00, '2024-07-07', 'Room charges for 5 nights', 'room'),
(2, 150.00, '2024-07-02', 'Chest X-ray', 'order'),
(2, 25.00, '2024-07-02', 'Amoxicillin medication', 'medication'),
(3, 900.00, '2024-06-20', 'Room charges for 5 nights', 'room'),
(4, 360.00, '2024-07-12', 'Room charges for 2 nights', 'room'),
(5, 1500.00, '2024-07-25', 'Room charges for 5 nights', 'room');

INSERT INTO RoomCharge (payable_id, stay_id) VALUES
(1, 1),
(5, 2),
(8, 3),
(9, 4),
(10, 5);

INSERT INTO OrderCharge (payable_id, exec_id) VALUES
(2, 1),
(3, 2),
(6, 3);

INSERT INTO MedicationCharge (payable_id, admin_id) VALUES
(4, 1),
(7, 3);

INSERT INTO Invoice (account_no, issue_date, patient_id, period_start, period_end) VALUES
('ACC001', '2024-07-05', 1, '2024-07-01', '2024-07-05'),
('ACC002', '2024-07-07', 2, '2024-07-02', '2024-07-07'),
('ACC003', '2024-06-20', 3, '2024-06-15', '2024-06-20'),
('ACC004', '2024-07-12', 4, '2024-07-10', '2024-07-12'),
('ACC005', '2024-07-25', 5, '2024-07-20', '2024-07-25'),
('ACC001', '2024-07-15', 1, '2024-07-06', '2024-07-15'); 

INSERT INTO InvoicePayable (account_no, issue_date, payable_id) VALUES
('ACC001', '2024-07-05', 1),
('ACC001', '2024-07-05', 2),
('ACC001', '2024-07-05', 3),
('ACC001', '2024-07-05', 4),
('ACC002', '2024-07-07', 5),
('ACC002', '2024-07-07', 6),
('ACC002', '2024-07-07', 7),
('ACC003', '2024-06-20', 8),
('ACC004', '2024-07-12', 9),
('ACC005', '2024-07-25', 10);

INSERT INTO Payment (pay_date, amount, patient_id) VALUES
('2024-07-06', 500.00, 1),
('2024-07-10', 635.25, 1), -- Full payment for first invoice
('2024-07-08', 1425.00, 2), -- Full payment
('2024-06-22', 900.00, 3), -- Full payment
('2024-07-13', 200.00, 4), -- Partial payment
('2024-07-26', 1000.00, 5), -- Partial payment
('2024-07-27', 500.00, 5); -- Additional payment