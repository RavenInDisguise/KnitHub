
-- Pasar un patrón a JSON:
DROP PROCEDURE IF EXISTS PatronesJSON;
DELIMITER //
CREATE PROCEDURE PatronesJSON
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName VARCHAR(45)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);

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
    
    SET @UserId = 0;
    SELECT UserId INTO @UserId FROM Users
    WHERE Users.MacAddress = pMacAddress  
    AND Users.Name = pName
    AND Users.Lastname = pLastName;
    
    IF (@UserId=0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @PatternId=0;
    SELECT PatternId INTO @PatternId FROM Patterns
    WHERE Patterns.Title=pPatternName
    AND Patterns.UserId=@UserId LIMIT 1;
    
    SET group_concat_max_len = 3000;
    
	SELECT `Patterns`.`UserId`,`Patterns`.`PatternId`,`Patterns`.`Title`,`Patterns`.`Description`,`Patterns`.`creationDate`
    FROM Patterns
    WHERE Patterns.UserId=@UserId
    AND Patterns.PatternId=@PatternId
    LIMIT 1
    INTO @UId,@PId,@PTitle,@PDesc,@PFechaCreac;
	
    SET group_concat_max_len = 2048;
	SELECT GROUP_CONCAT(' ',CONCAT(" Paso #",IFNULL(`Steps`.`StepNumber`,'')),' ',IFNULL(`Steps`.`Instruction`,''),' ',
	(SELECT CONCAT(" MediaURL: ",IFNULL(`Medias`.`URL`,'')) FROM `KnitHub`.`Medias` WHERE (`Steps`.`StepId`=`Medias`.`StepId`))) 
	AS PS FROM Steps 
	INNER JOIN Medias ON Medias.StepId=Steps.StepId 
	WHERE Steps.PatternId=@PatternId 
    ORDER BY Steps.StepNumber ASC
    LIMIT 1
    INTO @PSteps;

	START TRANSACTION;
	SELECT JSON_ARRAYAGG(JSON_OBJECT('UserId', @UId, 'PatternId', @PId, 'PatternName', @PTitle, 'PatternDescription', @PDesc, 
    'PatternCreationDate',@PFechaCreac, 'Pasos', @PSteps)) AS JSONObject LIMIT 1;
	COMMIT;
    
END//

DELIMITER ;

