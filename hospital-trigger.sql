DELIMITER //
CREATE TRIGGER trg_After_OrderExecution_CreateCharge
AFTER INSERT ON OrderExecution
FOR EACH ROW
BEGIN
    DECLARE order_fee DECIMAL(10,2);
    DECLARE new_payable_id INT;
    
    SELECT fee INTO order_fee 
    FROM `Order` 
    WHERE order_code = NEW.order_code;
    
    INSERT INTO Payable(patient_id, amount, pay_date, description, payable_type)
    VALUES(NEW.patient_id, 
           order_fee,
           NEW.exec_time,
           CONCAT('Order execution: ', NEW.order_code, ' - ', 
                  (SELECT description FROM `Order` WHERE order_code = NEW.order_code)),
           'order');
    
    SET new_payable_id = LAST_INSERT_ID();
    
    INSERT INTO OrderCharge(payable_id, exec_id)
    VALUES(new_payable_id, NEW.exec_id);
    
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_After_Checkout_CreateRoomCharge
AFTER UPDATE ON PatientRoomStay
FOR EACH ROW
BEGIN
    DECLARE nights_stayed INT;
    DECLARE room_fee DECIMAL(10,2);
    DECLARE total_room_cost DECIMAL(10,2);
    DECLARE new_payable_id INT;
    
    IF OLD.check_out IS NULL AND NEW.check_out IS NOT NULL THEN
        
        SET nights_stayed = DATEDIFF(NEW.check_out, NEW.check_in);
        
        SELECT nightly_fee INTO room_fee 
        FROM Room 
        WHERE room_no = NEW.room_no;
        
        SET total_room_cost = nights_stayed * room_fee;
        
        INSERT INTO Payable(patient_id, amount, pay_date, description, payable_type)
        VALUES(NEW.patient_id,
               total_room_cost,
               NEW.check_out,
               CONCAT('Room ', NEW.room_no, ' charges for ', nights_stayed, ' nights'),
               'room');
        
        SET new_payable_id = LAST_INSERT_ID();
        
        INSERT INTO RoomCharge(payable_id, stay_id)
        VALUES(new_payable_id, NEW.stay_id);
        
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_After_MedicationAdmin_CreateCharge
AFTER INSERT ON MedicationAdministration
FOR EACH ROW
BEGIN
    DECLARE med_unit_cost DECIMAL(10,2);
    DECLARE total_med_cost DECIMAL(10,2);
    DECLARE med_name VARCHAR(100);
    DECLARE new_payable_id INT;
    
    SELECT unit_cost, name 
    INTO med_unit_cost, med_name
    FROM MedicationType 
    WHERE med_code = NEW.med_code;
    
    SET total_med_cost = med_unit_cost * NEW.amount_given;
    
    INSERT INTO Payable(patient_id, amount, pay_date, description, payable_type)
    VALUES(NEW.patient_id,
           total_med_cost,
           NEW.admin_date,
           CONCAT('Medication: ', med_name, ' (', NEW.amount_given, ' units)'),
           'medication');
    
    SET new_payable_id = LAST_INSERT_ID();
    
    INSERT INTO MedicationCharge(payable_id, admin_id)
    VALUES(new_payable_id, NEW.admin_id);
    
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_After_Discharge_UpdateHealthRecords
AFTER UPDATE ON PatientRoomStay
FOR EACH ROW
BEGIN
    IF NEW.check_out IS NOT NULL AND OLD.check_out IS NULL THEN
        
        UPDATE HealthRecord 
        SET status = 'resolved',
            details = CONCAT(COALESCE(details, ''), 
                           ' - Patient discharged on ', NEW.check_out)
        WHERE patient_id = NEW.patient_id 
        AND status = 'ongoing'
        AND diagnosis_date <= NEW.check_out;
        
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Before_OrderExecution_Validate
BEFORE INSERT ON OrderExecution
FOR EACH ROW
BEGIN
    DECLARE order_exists INT DEFAULT 0;
    DECLARE patient_admitted INT DEFAULT 0;
    
    -- Verify the order exists
    SELECT COUNT(*) INTO order_exists
    FROM `Order`
    WHERE order_code = NEW.order_code;
    
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot execute non-existent order';
    END IF;
    
    -- Verify patient is currently admitted
    SELECT COUNT(*) INTO patient_admitted
    FROM PatientRoomStay
    WHERE patient_id = NEW.patient_id 
    AND check_out IS NULL;
    
    IF patient_admitted = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot execute order for non-admitted patient';
    END IF;
    
    -- Set default execution time if not provided
    IF NEW.exec_time IS NULL THEN
        SET NEW.exec_time = NOW();
    END IF;
    
END;
//
DELIMITER ;