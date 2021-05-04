-- 1. Muestra de resultados por compra de patrones
-- Dar más detalle de cuestiones del payment attempt, en este y en el 2

DROP PROCEDURE IF EXISTS CompraPatrones;
DELIMITER //
CREATE PROCEDURE CompraPatrones
(
	IN pMacAddress INT,
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50)
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
    
    SELECT payment_transactions.`PersonName`, payment_transactions.`TransAmount`, payment_transactions.`TransPosttime`, 
    payment_transactions.`TransType`, projects_patterns.`PatternName`, projects_patterns.`PatternCategoryName`
    FROM payment_transactions
    INNER JOIN projects_patterns
    INNER JOIN PurchasedPatternsPerUser ON payment_transactions.TransId=PurchasedPatternsPerUser.TransactionId
    AND projects_patterns.PatternId=PurchasedPatternsPerUser.PatternId;
END//

DELIMITER ;


-- 2. Muestra de resultados por compra de planes
DROP PROCEDURE IF EXISTS CompraPlanes;
DELIMITER //
CREATE PROCEDURE CompraPlanes
(
	IN pMacAddress BINARY,
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50)
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
    
    SELECT payment_transactions.`PersonName`, payment_transactions.`TransAmount`, payment_transactions.`TransPosttime`,
    payment_transactions.`TransType`, Plans.`Name`, PlansPerUser.`PostTime`, PlansPerUser.`NextTime`
    FROM payment_transactions
    INNER JOIN Plans
    INNER JOIN PlansPerUser ON payment_transactions.TransId=PlansPerUser.TransactionId
    AND Plans.PlanId=PlansPerUser.PlanId;
END//

DELIMITER ;

-- 3. Cronometraje por proyecto
DROP PROCEDURE IF EXISTS CronometrajeProyectos;
DELIMITER //
CREATE PROCEDURE CronometrajeProyectos
(
	IN pProjectName NVARCHAR(45)
)
BEGIN
	DECLARE INVALID_PROJECT INT DEFAULT(53001);

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
    
    SET @ProjectId = 0;
    SELECT ProjectId INTO @ProjectId FROM Projects
    WHERE Projects.Name = pProjectName;
    
    IF(@ProjectId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PROJECT;
    END IF;
    
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
	DECLARE INVALID_PATTERN INT DEFAULT(53002);

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
    
    SELECT projects_patterns.`PersonName`, projects_patterns.`PatternName`, projects_patterns.`PatternCategoryName`, 
    PriceValues.`Price`
    FROM projects_patterns
    INNER JOIN PatternsOnSale ON projects_patterns.PatternId=PatternsOnSale.PatternId
    INNER JOIN PriceValues ON PatternsOnSale.PriceValueId=PriceValues.PriceValueId;
END//

DELIMITER ;

-- 5. Generación de patrones
-- Modifiqué este porque el enunciado dice que hay que escribir en al menos 3 tablas
-- se me ocurrió pedir el nombre de la categoria del patrón, ahí escribiría en una tabla
-- para registrar esa categoría, y luego habría que asociar esa categoría al patrón, 
-- ahí escribiría en otra tabla
DROP PROCEDURE IF EXISTS GenerarPatron;
DELIMITER //
CREATE PROCEDURE GenerarPatron
(
	IN pMacAddress BINARY,
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName NVARCHAR(45),
    IN pPatternCategoryName NVARCHAR(45),
    OUT pLastPatternId BIGINT,
    OUT pLastPatternCategoryId INT
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
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
    
    START TRANSACTION;
		INSERT INTO Patterns (`Title`, `UserId`)
		VALUES (pPatternName, @UserId);
        SELECT LAST_INSERT_ID() INTO pLastPatternId;
        INSERT INTO PatternCategories (`Name`)
        VALUES (pPatternCategoryName);
        SELECT LAST_INSERT_ID() INTO pLastPatternCategoryId;
        INSERT INTO CategoriesPerPattern(`PatternCategoryId`, `PatternId`)
        VALUES (pLastPatternCategoryId, pLastPatternId);
	COMMIT;
END//

DELIMITER ;

-- Aquí no se me ocurrió en cuál tabla asociada a proyectos escribir,
-- una opción sería tal vez como que al registrar un proyecto, 
-- se pida un material como requisito para empezar, y ahí ya se 
-- escribiría en otras tablas aparte de solo registrar el proyecto
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
    DECLARE INVALID_PATTERN INT DEFAULT(53002);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
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
        ROLLBACK;
        RESIGNAL SET MESSAGE_TEXT = @message;
	END;
    
    SET @UserId = 0;
    SELECT UserId INTO @UserId FROM Users 
    WHERE Users.`MacAddress`=pMacAddress
    AND Users.`Name`=pName 
    AND Users.`LastName`=pLastName;
    
    IF (@UserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @PatternId = 0;
    SELECT PatternId INTO @PatternId FROM Patterns 
    WHERE Patterns.`Title`=pPatternName 
    AND Patterns.`UserId`=@UserId;
    
    IF (@PatternId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PATTERN;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El patrón no ha sido encontrado';
    END IF;
    
    START TRANSACTION;
		INSERT INTO Projects (`Name`, `Time`, `PatternId`, `UserId`)
		VALUES (pProjectName, 0, @PatternId, @UserId);
	COMMIT;
END//

DELIMITER ;