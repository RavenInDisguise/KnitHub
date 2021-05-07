-- 1. Muestra de resultados por compra de patrones

DROP PROCEDURE IF EXISTS CompraPatrones;
DELIMITER //
CREATE PROCEDURE CompraPatrones
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
    
    SELECT payment_transactions.`PersonName`, payment_transactions.`TransAmount`, payment_transactions.`TransPosttime`, 
    payment_transactions.`TransType`, projects_patterns.`PatternName`, projects_patterns.`PatternCategoryName`,
    payment_transactions.`MerchantName`, payment_transactions.`PaymentStatus`
    FROM payment_transactions
    INNER JOIN projects_patterns ON payment_transactions.`UserId`=project_patterns.`UserId` -- Esta linea no tenía ON, debatir si es necesario (creo que sí)
    INNER JOIN PurchasedPatternsPerUser ON payment_transactions.TransId=PurchasedPatternsPerUser.TransactionId
    AND projects_patterns.PatternId=PurchasedPatternsPerUser.PatternId
    WHERE payment_transactions.`UserId` = @UserId; -- Ver si filtrar también por un patrón en específico, o si muestra todos los del usuario dado
END//

DELIMITER ;


-- 2. Muestra de resultados por compra de planes
DROP PROCEDURE IF EXISTS CompraPlanes;
DELIMITER //
CREATE PROCEDURE CompraPlanes
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN Name VARCHAR(50)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
        IF (ISNULL(@message)) THEN
			SET @message = 'aqui saco el mensaje de un catalogo de mensajes que fue creado por equipo de desarrollo';            
        ELSE
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
    payment_transactions.`TransType`, Plans.`Name`, PlansPerUser.`PostTime`, PlansPerUser.`NextTime`,
    payment_transactions.`MerchantName`, payment_transactions.`PaymentStatus`
    FROM payment_transactions
    -- INNER JOIN Plans -> La quité
    INNER JOIN PlansPerUser ON payment_transactions.TransId=PlansPerUser.TransactionId
    AND payment_transactions.UserId=PlansPerUser.UserId -- -> Nueva
    INNER JOIN Plans ON PlansPerUser.PlanId=Plans.PlanId 
    -- AND Plans.PlanId=PlansPerUser.PlanId -> La quité, creo que iba mejor como join
    WHERE payment_transactions.`UserId` = @UserId; -- Ver si filtrar también por un plan en específico, o si muestra todos los del usuario dado
END//

DELIMITER ;

-- 3. Cronometraje por proyecto
DROP PROCEDURE IF EXISTS CronometrajeProyectos;
DELIMITER //
CREATE PROCEDURE CronometrajeProyectos
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
	IN pProjectName NVARCHAR(45)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
	DECLARE INVALID_PROJECT INT DEFAULT(53001);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
        IF (ISNULL(@message)) THEN
			SET @message = 'aqui saco el mensaje de un catalogo de mensajes que fue creado por equipo de desarrollo';            
        ELSE
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
    
    SET @UserId = 0;
    SELECT UserId INTO @UserId FROM Users
    WHERE Users.MacAddress = pMacAddress  
    AND Users.Name = pName
    AND Users.Lastname = pLastName;
    
    IF(@UserId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
    END IF;
    
    SELECT projects_patterns.`PersonName`, projects_patterns.`ProjectName`, projects_patterns.`ProjectTime`
    FROM projects_patterns
    WHERE project_patterns.`UserId`=@UserId
    AND project_patterns.``=@ProjectId;
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
        IF (ISNULL(@message)) THEN
			SET @message = 'aqui saco el mensaje de un catalogo de mensajes que fue creado por equipo de desarrollo';            
        ELSE
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
-- Tablas modificadas: Patterns, CategoriesPerPattern, (PatternCategories), MaterialsPerPattern, (Materials)
DROP PROCEDURE IF EXISTS GenerarPatron;
DELIMITER //
CREATE PROCEDURE GenerarPatron
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName NVARCHAR(45),
    IN pPatternCategoryName NVARCHAR(45),
    IN pMaterialName VARCHAR(45),
    OUT pLastPatternId BIGINT,
    OUT pLastPatternCategoryId INT,
    OUT pLastMaterialId INT
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
    
    SET @PatternCategoryId = 0;
    SELECT PatternCategoryId INTO @PatternCategoryId FROM PatternCategories
    WHERE PatternCategories.`Name` = pPatternCategoryName;
    
    SET @MaterialId = 0;
    SELECT MaterialId INTO @MaterialId FROM Materials
    WHERE Materials.`Name` = pMaterialName;
    
    START TRANSACTION;
		INSERT INTO Patterns (`Title`, `UserId`)
		VALUES (pPatternName, @UserId);
        SELECT LAST_INSERT_ID() INTO pLastPatternId;
        
        IF (@PatternCategoryId=0) THEN
			INSERT INTO PatternCategories (`Name`)
			VALUES (pPatternCategoryName);
            SELECT LAST_INSERT_ID() INTO pLastPatternCategoryId;
		ELSE
			SELECT @PatternCategoryId INTO pLastPatternCategoryId;
		END IF;
        INSERT INTO CategoriesPerPattern(`PatternCategoryId`, `PatternId`)
        VALUES (pLastPatternCategoryId, pLastPatternId);
        
        IF (@MaterialId=0) THEN
			INSERT INTO Materials (`Name`)
			VALUES (pMaterialName);
            SELECT LAST_INSERT_ID() INTO pLastMaterialId;
		ELSE
			SELECT @MaterialId INTO pLastMaterialId;
		END IF;
        INSERT INTO MaterialsPerPattern(`MaterialId`, `PatternId`)
        VALUES (pLastMaterialId, pLastPatternId);
	COMMIT;
END//

DELIMITER ;

-- 6. Generación de proyectos
-- Tablas Modificadas: Projects, MatterialsPerProject, (Materials), (MeasureUnits)
DROP PROCEDURE IF EXISTS GenerarProyecto;
DELIMITER //
CREATE PROCEDURE GenerarProyecto
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName NVARCHAR(45),
    IN pProjectName NVARCHAR(45),
    IN pMaterialName VARCHAR(45),
    IN pMeasureUnitName VARCHAR(45),
    IN pMeasureUnitAbbreviation VARCHAR(5),
    OUT pLastProjectId BIGINT,
    OUT pLastMaterialId INT,
    OUT pLastMeasureUnitId INT
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PATTERN INT DEFAULT(53002);

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
    
    SET @MaterialId = 0;
    SELECT MaterialId INTO @MaterialId FROM Materials 
    WHERE Materials.`Name`=pMaterialName;
    
    SET @MeasureUnitId = 0;
    SELECT MeasureUnitId INTO @MeasureUnitId FROM MeasureUnits 
    WHERE MeasureUnits.`Name`=pMeasureUnitName AND MeasureUnits.`Abbreviation`=pMeasureUnitAbbreviation;
    
    
    START TRANSACTION;
		INSERT INTO Projects (`Name`, `Time`, `PatternId`, `UserId`)
		VALUES (pProjectName, 0, @PatternId, @UserId);
        SELECT LAST_INSERT_ID() INTO pLastProjectId;
        
        IF (@MeasureUnitId=0) THEN
			INSERT INTO MeasureUnits (`Name`, Abbreviation)
			VALUES (pMeasureUnitName, pMeasureUnitAbbreviation);
            SELECT LAST_INSERT_ID() INTO pLastMeasureUnitId;
		ELSE
			SELECT @MeasureUnitId INTO pLastMeasureUnitId;
		END IF;
        
        IF (@MaterialId=0) THEN
			INSERT INTO Materials (`Name`)
			VALUES (pMaterialName);
            SELECT LAST_INSERT_ID() INTO pLastMaterialId;
		ELSE
			SELECT @MaterialId INTO pLastMaterialId;
		END IF;
        INSERT INTO MaterialsPerProject(`MaterialId`, `ProjectId`, `MeasureUnitId`)
        VALUES (pLastMaterialId, pLastProjectId, pLastMeasureUnitId);
	COMMIT;
END//

DELIMITER ;