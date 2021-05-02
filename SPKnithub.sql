-- 1. Muestra de resultados por compra de patrones -- por usuario
DROP PROCEDURE IF EXISTS CompraPatrones;
DELIMITER //
CREATE PROCEDURE CompraPatrones
(
	
)
BEGIN
	DECLARE INVALID_FUND INT DEFAULT(53000);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
		-- SET pLastTransactionId = 0;
        -- SET pLastBalance = 0.0;
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
    
    SELECT paymenttransactions.`PersonName`, `TransAmount`, `TransPosttime`, `TransType`, `PatternName`, `PatternCategoryName`
    FROM paymenttransactions
    INNER JOIN projects_patterns
    INNER JOIN PurchasedPatternsPerUser ON paymenttransactions.TransId=PurchasedPatternsPerUser.TransactionId
    AND projects_patterns.PatternId=PurchasedPatternsPerUser.PatternId;
    
END//

DELIMITER ;





-- 2. Muestra de resultados por compra de planes -- por usuario
DROP PROCEDURE IF EXISTS CompraPlanes;
DELIMITER //
CREATE PROCEDURE CompraPlanes
(
	
)
BEGIN
	DECLARE INVALID_FUND INT DEFAULT(53000);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
		-- SET pLastTransactionId = 0;
        -- SET pLastBalance = 0.0;
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
    
    SELECT paymenttransactions.`PersonName`, `TransAmount`, `TransPosttime`, `TransType`, Plans.`Name`,
    PlansPerUser.`PostTime`, PlansPerUser.`NextTime`
    FROM paymenttransactions
    INNER JOIN Plans
    INNER JOIN PlansPerUser ON paymenttransactions.TransId=PlansPerUser.TransactionId
    AND Plans.PlanId=PlansPerUser.PlanId;
    
END//

DELIMITER ;





-- 3. Cronometraje por proyecto -- por proyecto
DROP PROCEDURE IF EXISTS CronometrajeProjectos;
DELIMITER //
CREATE PROCEDURE CronometrajeProjectos
(
	
)
BEGIN
	DECLARE INVALID_FUND INT DEFAULT(53000);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
		-- SET pLastTransactionId = 0;
        -- SET pLastBalance = 0.0;
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
    
    
    SELECT projects_patterns.`PersonName`, projects_patterns.`ProjectName`, projects_patterns.`ProjectTime`
    FROM projects_patterns;
    
END//

DELIMITER ;





-- 4. Muestra de los patrones en venta
DROP PROCEDURE IF EXISTS PatronesEnVenta;
DELIMITER //
CREATE PROCEDURE PatronesEnVenta
(
	
)
BEGIN
	DECLARE INVALID_FUND INT DEFAULT(53000);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
		-- SET pLastTransactionId = 0;
        -- SET pLastBalance = 0.0;
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
    
    SELECT projects_patterns.`PersonName`, projects_patterns.`PatternName`, projects_patterns.`PatternCategory`, `Price`
    FROM projects_patterns
    INNER JOIN PatternsOnSale ON projects_patterns.PatternId=PatternsOnSale.PatternId
    INNER JOIN PriceValues ON PatternsOnSale.PriceValueId=PriceValues.PriceValueId;
END//

DELIMITER ;





-- 5. Generación de patrones
DROP PROCEDURE IF EXISTS GenerarPatron;
DELIMITER //
CREATE PROCEDURE GenerarPatron
(
	IN pMacAddress BINARY,
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName NVARCHAR(45)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
		-- SET pLastTransactionId = 0;
        -- SET pLastBalance = 0.0;
        -- si es un exception de sql, ambos campos vienen en el diagnostics
        -- pero si es una excepction forzada por el programador solo viene el ERRNO, el texto no
        
        IF (ISNULL(@message)) THEN -- quiere decir q es una excepcion forzada del programador
			SET @message = 'Se ha producido un error';            
        ELSE
			-- es un exception de SQL que no queremos que salga hacia la capa de aplicacion
            -- tengo que guardar el error en una bitácora de errores... patron de bitacora
            -- sustituyo el texto del mensaje
            SET @message = CONCAT('Internal error: ', @message);
        END IF;
        
        
        RESIGNAL SET MESSAGE_TEXT = @message;
	END;
    
    SET @UserId = 0;
    SELECT IFNULL(UserId, @UserId) INTO @UserId FROM Users WHERE Users.`MacAddress`=pMacAddress
    AND Users.`Name`=pName AND Users.`LastName`=pLastName;
    
    IF (@UserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    INSERT INTO Patterns (`Title`, `UserId`)
    VALUES
    (pPatternName, @UserId);
END//

DELIMITER ;





-- 6. Generación de proyectos
DROP PROCEDURE IF EXISTS GenerarProyecto;
DELIMITER //
CREATE PROCEDURE GenerarProyecto
(
	IN pMacAddress BINARY,
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName NVARCHAR(45),
    IN pProjectName NVARCHAR(45)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PATTERN INT DEFAULT(53001);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
		-- SET pLastTransactionId = 0;
        -- SET pLastBalance = 0.0;
        -- si es un exception de sql, ambos campos vienen en el diagnostics
        -- pero si es una excepction forzada por el programador solo viene el ERRNO, el texto no
        
        IF (ISNULL(@message)) THEN -- quiere decir q es una excepcion forzada del programador
			SET @message = 'Se ha producido un error';            
        ELSE
			-- es un exception de SQL que no queremos que salga hacia la capa de aplicacion
            -- tengo que guardar el error en una bitácora de errores... patron de bitacora
            -- sustituyo el texto del mensaje
            SET @message = CONCAT('Internal error: ', @message);
        END IF;
        
        
        RESIGNAL SET MESSAGE_TEXT = @message;
	END;
    
    SET @UserId = 0;
    SELECT IFNULL(UserId, @UserId) INTO @UserId FROM Users WHERE Users.`MacAddress`=pMacAddress
    AND Users.`Name`=pName AND Users.`LastName`=pLastName;
    
    IF (@UserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @PatternId = 0;
    SELECT IFNULL(PatternId, @PatternId) INTO @PatternId FROM Patterns WHERE Patterns.`Title`=pPatternName AND Patterns.`UserId`=@UserId;
    
    IF (@PatternId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PATTERN;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El patrón no ha sido encontrado';
    END IF;
    
    INSERT INTO Projects (`Name`, `PatternId`, `UserId`)
    VALUES
    (pProjectName, @PatternId, @UserId);
END//

DELIMITER ;