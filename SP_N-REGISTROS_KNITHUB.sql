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

-- Llenado de los datos de la tabla temporal
SET @UUID = '';
SELECT UUID() into @UUID;

SET @PatternId = #Id del patrón donde se insertará N pasos;

 CREATE TEMPORARY TABLE TemporarySteps (
	UniversallyUniqueIdentifier VARCHAR(36),
    StepNumber TINYINT,
    Instruction NVARCHAR(1000),
    PatternId BIGINT
);

INSERT INTO TemporarySteps (UniversallyUniqueIdentifier, StepNumber, Instruction, PatternId)
VALUES
(@UUID, 1, 'Paso 1', @PatternId),
(@UUID, 2, 'Paso 2', @PatternId),
(@UUID, 3, 'Paso 3', @PatternId),
(@UUID, 4, 'Paso 4', @PatternId),
(@UUID, 5, 'Paso 5', @PatternId);

CALL LoadStepsIntoPattern (@UUID);