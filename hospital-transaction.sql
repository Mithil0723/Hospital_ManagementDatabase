DELIMITER //
CREATE PROCEDURE usp_AdmitPatient(
    IN p_name VARCHAR(100),
    IN p_address VARCHAR(200),
    IN p_phone VARCHAR(15),
    IN p_room_no INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Patient(name, address, phone_number)
    VALUES(p_name, p_address, p_phone);

    SET @new_patient_id = LAST_INSERT_ID();

    INSERT INTO PatientRoomStay(patient_id, room_no, check_in)
    VALUES(@new_patient_id, p_room_no, CURDATE());

    INSERT INTO HealthRecord(patient_id, description, diagnosis_date, status)
    VALUES(@new_patient_id, 'Initial admission', CURDATE(), 'Active');

    COMMIT;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE usp_TransferPatient(
    IN p_patient_id INT,
    IN p_new_room_no INT
)
BEGIN
    DECLARE room_charge DECIMAL(10,2);
    DECLARE nights INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT DATEDIFF(CURDATE(), check_in), r.nightly_fee
    INTO nights, room_charge
    FROM PatientRoomStay prs
    JOIN Room r ON prs.room_no = r.room_no
    WHERE prs.patient_id = p_patient_id AND check_out IS NULL;

    UPDATE PatientRoomStay 
    SET check_out = CURDATE()
    WHERE patient_id = p_patient_id AND check_out IS NULL;

    SAVEPOINT after_checkout;

    INSERT INTO Payable(patient_id, amount, description, pay_date)
    VALUES(p_patient_id, room_charge * nights, 'Room charges', CURDATE());

    INSERT INTO PatientRoomStay(patient_id, room_no, check_in)
    VALUES(p_patient_id, p_new_room_no, CURDATE());

    COMMIT;
END //
DELIMITER ;

