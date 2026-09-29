DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

-- Strong Entities

CREATE TABLE Patient (
    patient_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    PRIMARY KEY (patient_id)
) ENGINE=InnoDB;

CREATE TABLE Room (
    room_no INT,
    capacity INT NOT NULL,
    nightly_fee DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (room_no)
) ENGINE=InnoDB;

CREATE TABLE Physician (
    physician_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    cert_no VARCHAR(50) UNIQUE NOT NULL,
    specialty VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(20),
    PRIMARY KEY (physician_id)
) ENGINE=InnoDB;

CREATE TABLE Nurse (
    nurse_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    cert_no VARCHAR(50) UNIQUE NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    PRIMARY KEY (nurse_id)
) ENGINE=InnoDB;

CREATE TABLE `Order` (
    order_code VARCHAR(20),
    description TEXT NOT NULL,
    fee DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_code)
) ENGINE=InnoDB;

CREATE TABLE MedicationType (
    med_code VARCHAR(20),
    name VARCHAR(100) NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (med_code)
) ENGINE=InnoDB;

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT,
    pay_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    patient_id INT NOT NULL,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Weak Entities

CREATE TABLE HealthRecord (
    record_id INT AUTO_INCREMENT,
    patient_id INT NOT NULL,
    disease VARCHAR(200) NOT NULL,
    diagnosis_date DATE NOT NULL,
    status ENUM('ongoing', 'resolved', 'chronic') NOT NULL,
    details TEXT,
    PRIMARY KEY (record_id, patient_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Relationship Tables

CREATE TABLE PatientRoomStay (
    stay_id INT AUTO_INCREMENT,
    patient_id INT NOT NULL,
    room_no INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE,
    PRIMARY KEY (stay_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (room_no) REFERENCES Room(room_no) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PhysicianMonitors (
    monitor_id INT AUTO_INCREMENT,
    physician_id INT NOT NULL,
    patient_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    PRIMARY KEY (monitor_id),
    FOREIGN KEY (physician_id) REFERENCES Physician(physician_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE OrderExecution (
    exec_id INT AUTO_INCREMENT,
    nurse_id INT NOT NULL,
    order_code VARCHAR(20) NOT NULL,
    patient_id INT NOT NULL,
    exec_status ENUM('pending', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    exec_time DATETIME NOT NULL,
    PRIMARY KEY (exec_id),
    FOREIGN KEY (nurse_id) REFERENCES Nurse(nurse_id) ON DELETE CASCADE,
    FOREIGN KEY (order_code) REFERENCES `Order`(order_code) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE MedicationAdministration (
    admin_id INT AUTO_INCREMENT,
    nurse_id INT NOT NULL,
    patient_id INT NOT NULL,
    med_code VARCHAR(20) NOT NULL,
    admin_date DATE NOT NULL,
    amount_given DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (admin_id),
    FOREIGN KEY (nurse_id) REFERENCES Nurse(nurse_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (med_code) REFERENCES MedicationType(med_code) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Creates (
    physician_id INT NOT NULL,
    order_code VARCHAR(20) NOT NULL,
    creation_date DATE NOT NULL,
    PRIMARY KEY (physician_id, order_code),
    FOREIGN KEY (physician_id) REFERENCES Physician(physician_id) ON DELETE CASCADE,
    FOREIGN KEY (order_code) REFERENCES `Order`(order_code) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Invoice and Payable System

CREATE TABLE Invoice (
    account_no VARCHAR(20) NOT NULL,
    issue_date DATE NOT NULL,
    patient_id INT NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    PRIMARY KEY (account_no, issue_date),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Payable (
    payable_id INT AUTO_INCREMENT,
    patient_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    pay_date DATE NOT NULL,
    description VARCHAR(255),
    payable_type ENUM('room', 'medication', 'order') NOT NULL,
    PRIMARY KEY (payable_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE RoomCharge (
    payable_id INT,
    stay_id INT NOT NULL,
    PRIMARY KEY (payable_id),
    FOREIGN KEY (payable_id) REFERENCES Payable(payable_id) ON DELETE CASCADE,
    FOREIGN KEY (stay_id) REFERENCES PatientRoomStay(stay_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE MedicationCharge (
    payable_id INT,
    admin_id INT NOT NULL,
    PRIMARY KEY (payable_id),
    FOREIGN KEY (payable_id) REFERENCES Payable(payable_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES MedicationAdministration(admin_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE OrderCharge (
    payable_id INT,
    exec_id INT NOT NULL,
    PRIMARY KEY (payable_id),
    FOREIGN KEY (payable_id) REFERENCES Payable(payable_id) ON DELETE CASCADE,
    FOREIGN KEY (exec_id) REFERENCES OrderExecution(exec_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE InvoicePayable (
    account_no VARCHAR(20) NOT NULL,
    issue_date DATE NOT NULL,
    payable_id INT NOT NULL,
    PRIMARY KEY (account_no, issue_date, payable_id),
    FOREIGN KEY (account_no, issue_date) REFERENCES Invoice(account_no, issue_date) ON DELETE CASCADE,
    FOREIGN KEY (payable_id) REFERENCES Payable(payable_id) ON DELETE CASCADE
) ENGINE=InnoDB;