--  13. Insertar N pasos a un patrón:
DROP PROCEDURE IF EXISTS LoadStepsIntoPattern;
DELIMITER //
CREATE PROCEDURE LoadStepsIntoPattern
(
	IN pUniversallyUniqueIdentifier VARCHAR(36)
)
BEGIN
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

    START TRANSACTION;
		INSERT INTO Steps (StepNumber, Instruction, PatternId)
		SELECT StepNumber, Instruction, PatternId FROM TemporarySteps
        WHERE UniversallyUniqueIdentifier = pUniversallyUniqueIdentifier;
    COMMIT;
END// 