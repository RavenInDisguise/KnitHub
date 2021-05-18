-- Trigger:
-- Se actualiza el contador de patrones o proyectos del usuario cuando agrega uno nuevo. 
DROP TRIGGER IF EXISTS TR_after_insert_patrones; 
DELIMITER //
CREATE TRIGGER TR_after_insert_patrones AFTER INSERT
ON Patterns FOR EACH ROW 
	UPDATE Users SET PatternCount=PatternCount+1
	WHERE UserId=Users.UserId;
//
DELIMITER ;

DROP TRIGGER IF EXISTS TR_after_insert_proyectos; 
DELIMITER //
CREATE TRIGGER TR_after_insert_proyectos AFTER INSERT
ON Patterns FOR EACH ROW 
	UPDATE Users SET ProjectCount=ProjectCount+1
	WHERE UserId=Users.UserId;
//
DELIMITER ;

-- Cursor:
DROP PROCEDURE IF EXISTS GenerarProyecto;
DELIMITER //
CREATE PROCEDURE GenerarProyecto
(
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE Cursor_AmountSpent DECIMAL(5,2);
    DECLARE Cursor_MaterialId INT;
    DECLARE Cursor_PatternId BIGINT;
    DECLARE Cursor_MeasureUnitId INT;
    DECLARE Materials_Cursor CURSOR FOR SELECT AmountSpent, MaterialId, PatternId, MeasureUnitId FROM MaterialsPerPattern;  -- WHERE PatternId = @PatternId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
        IF (ISNULL(@message)) THEN
			SET @message = 'Se ha producido un error';            
        ELSE
            SET @message = CONCAT('Internal error: ', @message);
        END IF;
        ROLLBACK;
        RESIGNAL SET MESSAGE_TEXT = @message;
	END;

        -- Insertar los materiales del patrón al proyecto mediante un cursor
        OPEN Materials_Cursor;
		readMaterials : LOOP
			FETCH Materials_Cursor INTO Cursor_AmountSpent, Cursor_MaterialId, Cursor_PatternId, Cursor_MeasureUnitId;
			IF done THEN
				LEAVE readMaterials;
			END IF;
            IF Cursor_PatternId = @PatternId THEN
				INSERT INTO MaterialsPerProject (AmountSpent, MaterialId, ProjectId, MeasureUnitId)
				VALUES (Cursor_AmountSpent, Cursor_MaterialId, @LastProjectId, Cursor_MeasureUnitId);
            END IF;
		END LOOP;
        CLOSE Materials_Cursor;
	COMMIT;
    SELECT * FROM MaterialsPerProject; -- Es solo para revisar que se estén transfiriendo bien, cuando esté terminado y bien probado se puede quitar
END//
DELIMITER ;

-- Substring: 
-- Se hace uso del substring para generar los checksums:
SET SQL_SAFE_UPDATES=0;


UPDATE PaymentAttempts
SET Checksum = SHA2(CONCAT(PaymentAttemptId,PostTime, Amount,CurrencySymbol,ReferenceNumber,IFNULL(ErrorNumber,''),MerchantTransNumber,
PaymentTimeStamp,ComputerName,Username,IPAddress,UserId,MerchantId,PaymentStatusId,(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Transactions
SET Checksum = SHA2(CONCAT(TransactionId,PostTime,ReferenceNumber,Amount,PaymentAttemptId,TransTypeId, SubTypeId,EntityTypeId,
(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Logs
SET Checksum = SHA2(CONCAT(LogId,PostTime,ComputerName,Username,IPAddress,IFNULL(RefId1,''),IFNULL(RefId2,''),IFNULL(OldValue,''),IFNULL(NewValue,''),SeverityId,EntityTypeId,AppSourceId,
LogTypeId,UserId,(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Benefits
SET Checksum =  SHA2(CONCAT(BenefitId,Name,(SELECT SUBSTRING(Description, 0, 3))), 256);
