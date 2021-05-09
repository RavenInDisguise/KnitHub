DROP PROCEDURE IF EXISTS PatronesJSON;
DELIMITER //
CREATE PROCEDURE PatronesJSON
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN Title VARCHAR(45)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
        -- si es un exception de sql, ambos campos vienen en el diagnostics
        -- pero si es una excepction forzada por el programador solo viene el ERRNO, el texto no
        IF (ISNULL(@message)) THEN -- quiere decir q es una excepcion forzada del programador
			SET @message = 'aqui saco el mensaje de un catalogo de mensajes que fue creado por equipo de desarrollo';            
        ELSE
			-- es un exception de SQL que no queremos que salga hacia la capa de aplicacion
            -- tengo que guardar el error en una bitácora de errores... patron de bitacora
            -- sustituyo el texto del mensaje
            SET @message = CONCAT('Internal error: ', @message);
        END IF;
        RESIGNAL SET MESSAGE_TEXT = @message;
	END;
    
    SET @UserId = 0;
    SELECT UserId INTO @UserId FROM Users
    WHERE Users.MacAddress = pMacAddress  
    AND Users.Name = pName
    AND Users.Lastname = pLastName;
    
    IF(@UserId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
    END IF;
    
    SET group_concat_max_len = 2048;
    
	SELECT `Patterns`.`UserId`=@UId,`Patterns`.`PatternId`=@PId,`Patterns`.`Title`=@PTitle,`Patterns`.`Description`=@PDesc,`Patterns`.`creationDate`=@PFechaCreac,
	(SELECT GROUP_CONCAT(`Steps`.`StepId`,`Steps`.`StepNumber`,`Steps`.`Instruction`,`Steps`.`PatternId`, 
    (SELECT `Medias`.`URL` FROM `KnitHub`.`Medias` WHERE (`Steps`.`StepId`=`Medias`.`StepId`) ORDER BY `Steps`.`StepNumber` ASC)=@PSteps) 
    FROM `KnitHub`.`Steps` WHERE `Steps`.`PatternId`=`Patterns`.`PatternId`) AS StepsPattern
	FROM `KnitHub`.`Patterns`
    INNER JOIN Steps ON Steps.PatternId=Patterns.PatternId
    INNER JOIN Medias ON Medias.StepId=Steps.StepId;

	SELECT JSON_ARRAYAGG(JSON_OBJECT('UserId', @UId, 'PatternId', @PId, 'PatternName', @PTitle, 'PatternDescription', @PDesc, 
    'PatternCreationDate',@PFechaCreac, 'Pasos', @PSteps)) AS JSONObject;
    
    
END//

DELIMITER ;



