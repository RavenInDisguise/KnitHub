-- 1. Muestra de resultados por compra de patrones

DROP PROCEDURE IF EXISTS CompraPatrones;
DELIMITER //
CREATE PROCEDURE CompraPatrones
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternTitle VARCHAR(45)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PATTERN INT DEFAULT(53001);
	
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
    WHERE Users.MacAddress=pMacAddress  
    AND Users.Name=pName
    AND Users.Lastname=pLastName;
    
    IF(@UserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
    END IF;
    
    SET @PatternId = 0;
    SELECT PatternId INTO @PatternId FROM patterns
    WHERE Patterns.PatternId=pPatternTitle
    AND Patterns.UserId=@UserId;
    
    IF(@PatternId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PATTERN;
	END IF;
    
    SELECT payment_transactions.`PersonName`, payment_transactions.`TransAmount`, payment_transactions.`TransPosttime`, 
    payment_transactions.`TransType`, projects_patterns.`PatternName`, projects_patterns.`PatternCategoryName`,
    payment_transactions.`MerchantName`, payment_transactions.`PaymentStatus`
    FROM payment_transactions
    INNER JOIN projects_patterns ON payment_transactions.`UserId`=projects_patterns.`UserId`
    INNER JOIN PurchasedPatternsPerUser ON payment_transactions.TransId=PurchasedPatternsPerUser.TransactionId
    AND payment_transactions.UserId=PurchasedPatternsPerUser.UserId
    AND projects_patterns.PatternId=PurchasedPatternsPerUser.PatternId
    WHERE payment_transactions.`UserId`=@UserId 
    AND projects_patterns.`PatternId`=@PatternId;
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
    IN pPlanName VARCHAR(50)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PLAN INT DEFAULT(53002);
    DECLARE PLAN_NOT_FOUND_FOR_USER INT DEFAULT(53005);
    
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
    WHERE Users.MacAddress=pMacAddress  
    AND Users.Name=pName
    AND Users.Lastname=pLastName;
    
    IF(@UserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
    END IF;
    
    SET @PlanId = 0;
    SELECT PlanId INTO @PlanId FROM Plans
    WHERE Plans.Name=pPlanName;
    
    IF(@PlanId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PLAN;	
	END IF;
    
    SET @PlanCount=0;
    SELECT COUNT(*) INTO @PlanCount FROM PlansPerUser
    WHERE PlansPerUser.UserId=@UserId AND PlansPerUser.PlanId=@PlanId;
    
    IF(@PlanCount=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = PLAN_NOT_FOUND_FOR_USER;	
	END IF;
    
    SELECT payment_transactions.`PersonName`, payment_transactions.`TransAmount`, payment_transactions.`TransPosttime`,
    payment_transactions.`TransType`, Plans.`Name`, PlansPerUser.`PostTime`, PlansPerUser.`NextTime`,
    payment_transactions.`MerchantName`, payment_transactions.`PaymentStatus`
    FROM payment_transactions
    INNER JOIN PlansPerUser ON payment_transactions.TransId=PlansPerUser.TransactionId
    AND payment_transactions.UserId=PlansPerUser.UserId
    INNER JOIN Plans ON PlansPerUser.PlanId=Plans.PlanId 
    WHERE payment_transactions.`UserId`=@UserId
    AND Plans.PlanId=@PlanId;
    -- Así muestra todas las veces que el usuario compró el plan
    -- Hace falta filtrarlo de alguna forma?
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
	DECLARE INVALID_PROJECT INT DEFAULT(53003);

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
    WHERE Users.MacAddress=pMacAddress  
    AND Users.Name=pName
    AND Users.Lastname=pLastName;
    
    IF(@UserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
    END IF;
    
    SET @ProjectId = 0;
    SELECT ProjectId INTO @ProjectId FROM Projects
    WHERE Projects.Name=pProjectName
    AND Project.UserId=@UserId;
    
    IF(@ProjectId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PROJECT;
    END IF;
    
    SELECT projects_patterns.`PersonName`, projects_patterns.`ProjectName`, projects_patterns.`ProjectTime`
    FROM projects_patterns
    WHERE project_patterns.`UserId`=@UserId
    AND project_patterns.`ProjectId`=@ProjectId;
END//
DELIMITER ;

-- 4. Muestra de los patrones en venta
DROP PROCEDURE IF EXISTS PatronesEnVenta;
DELIMITER //
CREATE PROCEDURE PatronesEnVenta
(
)
BEGIN
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
-- Tablas modificadas: Patterns, Users, CategoriesPerPattern
DROP PROCEDURE IF EXISTS GenerarPatron;
DELIMITER //
CREATE PROCEDURE GenerarPatron
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName NVARCHAR(45),
    IN pPatternCategoryName NVARCHAR(45)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PATTERN_CATEGORY INT DEFAULT(53004);
    -- error de que el patron ya existe para el usuario
	
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
    WHERE Users.MacAddress=pMacAddress  
    AND Users.Name=pName
    AND Users.Lastname=pLastName;
    
    IF (@UserId=0) THEN
        SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @PatternCategoryId = 0;
    SELECT PatternCategoryId INTO @PatternCategoryId FROM PatternCategories
    WHERE PatternCategories.`Name`=pPatternCategoryName;
    
    IF (@PatternCategoryId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PATTERN_CATEGORY;
	END IF;
    
    SET @LastPatternId = 0;
    START TRANSACTION;
		INSERT INTO Patterns (`Title`, `UserId`)
		VALUES (pPatternName, @UserId);
        SELECT LAST_INSERT_ID() INTO @LastPatternId;
		
        UPDATE Users SET PatternCount = PatternCount + 1
        WHERE Users.UserId=@UserId;
        
        INSERT INTO CategoriesPerPattern(`PatternCategoryId`, `PatternId`)
        VALUES (@PatternCategoryId, @LastPatternId);
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
    IN pProjectName NVARCHAR(45)
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PATTERN INT DEFAULT(53001);
    DECLARE done INT DEFAULT FALSE;
    DECLARE Cursor_AmountSpent DECIMAL(5,2);
    DECLARE Cursor_MaterialId INT;
    DECLARE Cursor_PatternId BIGINT;
    DECLARE Cursor_MeasureUnitId INT;
    DECLARE Materials_Cursor CURSOR FOR SELECT AmountSpent, MaterialId, PatternId, MeasureUnitId FROM MaterialsPerPattern;  -- WHERE PatternId = @PatternId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- error de que ya existe el proyecto para el usuario
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
		SELECT PatternId INTO @PatternId FROM PurchasedPatternsPerUser
        INNER JOIN Patterns ON Patterns.PatternId = PurchasedPatternsPerUser.PatternId
        WHERE Patterns.`Title`=pPatternName
		AND PurchasedPatternsPerUser.`UserId`=@UserId;
        
        IF (@PatternId=0) THEN
			SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PATTERN;
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El patrón no ha sido encontrado';
		END IF;
    END IF;
    
    SET @LastProjectId = 0;
    START TRANSACTION;
		INSERT INTO Projects (`Name`, `Time`, `PatternId`, `UserId`)
		VALUES (pProjectName, 0, @PatternId, @UserId);
        SELECT LAST_INSERT_ID() INTO @LastProjectId;
        
        UPDATE Users SET ProjectCount = ProjectCount + 1
        WHERE Users.UserId=@UserId;
        
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

-- 7. Clasificación de proyectos por tiempo en columna dinamica
DROP PROCEDURE IF EXISTS ClasificacionProyectos;
DELIMITER //
CREATE PROCEDURE ClasificacionProyectos
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50)
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
    
	SELECT Projects.`Name`, Patterns.`Title` As `Pattern Name`, Projects.`Time`, Projects.`PricePerHour`, Projects.`TotalPrice`,
	CASE
    WHEN Projects.Time < DATE('00:60:00') THEN 'Minutos'
    WHEN Projects.Time < DATE('24:00:00') THEN 'Horas'
	WHEN Projects.Time < DATE('168:00:00') THEN 'Días'
	WHEN Projects.Time < DATE('672:00:00') THEN 'Semanas'
	WHEN Projects.Time >= DATE('672:00:00') THEN 'Meses'
	END AS `Time Clasification`
	FROM Projects
	INNER JOIN Patterns ON Projects.UserId = @UserId AND Projects.PatternId = Patterns.PatternId;
    END//
DELIMITER ;

-- 8. Iniciar proyecto a partir de un patrón a comprar
-- A) Proceso de compra
-- Tablas modificadas: PaymentAttempts, Transactions
DROP PROCEDURE IF EXISTS CompraPatron_NuevoProyecto;
DELIMITER //
CREATE PROCEDURE CompraPatron_NuevoProyecto
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pProjectName NVARCHAR(45),
    IN pPatternName NVARCHAR(45),
    IN pOwnerMacAddress VARCHAR(20),
    IN pOwnerName NVARCHAR(50),
    IN pOwnerLastName NVARCHAR(50),
    IN pMerchantName NVARCHAR(50),
    IN pTransType VARCHAR(30)
)
BEGIN
	DECLARE Transaction_Count BIT;
    DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PATTERN INT DEFAULT(53001);
    DECLARE PATTERN_NOT_ON_SALE INT DEFAULT(53006);
    DECLARE INVALID_MERCHANT INT DEFAULT(53007);
    DECLARE INVALID_TRANSTYPE INT DEFAULT(53008);
    
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
    
    SET @OwnerUserId = 0;
    SELECT UserId INTO @OwnerUserId FROM Users
    WHERE Users.MacAddress=pOwnerMacAddress
    AND Users.`Name`=pOwnerName
    AND Users.LastName=pOwnerLastName;
    
    IF (@OwnerUserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    
    SET @PatternId = 0;
    SET @PatternName = '';
    SELECT PatternId, Title INTO @PatternId, @PatternName FROM Patterns
    WHERE Patterns.UserId=@OwnerUserId
    AND Patterns.Title=pPatternName;
    
    IF (@PatternId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PATTERN;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @PriceValueId=0;
    SELECT PriceValueId INTO @PriceValueId FROM PatternsOnSale
    WHERE PatternsOnSale.PatternId=@PatternId
    AND PatternsOnSale.OnSale=1
    ORDER BY `Date` DESC;
    
    IF (@PriceValueId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = PATTERN_NOT_ON_SALE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @Amount = 0;
    SET @CurrencySymbol = '';
    SELECT Price, CurrencySymbol INTO @Amount, @CurrencySymbol FROM PriceValues
    WHERE PriceValues.PriceValueId=@PriceValueId;

    SET @UserId = 0;
    SET @Nickname = '';
    SET @SecondName = '';
    SELECT UserId, Nickname, SecondName INTO @UserId, @Nickname, @SecondName FROM Users
    WHERE Users.MacAddress = pMacAddress  
    AND Users.Name = pName
    AND Users.Lastname = pLastName;
    
    IF(@UserId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
    END IF;
    
    IF (@Nickname = '') THEN
		SET @Nickname = NULL;
    END IF;
    
    IF (@SecondName = '') THEN
		SET @SecondName = NULL;
    END IF;
    
    SET @MerchantId = 0;
    SELECT MerchantId INTO @MerchantId FROM Merchants
    WHERE Merchant.Name=pMerchantName;
    
    IF(@MerchantId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_MERCHANT;
    END IF;
    
    SET @TransTypeId = 0;
    SELECT TransTypeId INTO @TransTypeId FROM TransTypes
    WHERE TransTypes.Name=pTransType;
    
    IF(@TransTypeId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_TRANSTYPE;
    END IF;
    
    SET @PaymentId = 0;
    SET @TransactionId = 0;
    SET Transaction_Count = 0;
    SET @CurrentTime = NOW();
    
    IF Transaction_Count=0 THEN
		SET Transaction_Count = 1;
        START TRANSACTION;
	END IF;
    
    INSERT INTO PaymentAttempts (PostTime, Amount, CurrencySymbol, ReferenceNumber, MerchantTransNumber, PaymentTimeStamp, ComputerName,
    Username, IPAddress, Checksum, Description, UserId, MerchantId, PaymentStatusId)
    VALUES (@CurrentTime, @Amount, @CurrencySymbol, @OwnerUserId, FLOOR(RAND()*(10-1+1))+1, current_timestamp(), pMacAddress,
    IFNULL(@Nickname, CONCAT(pName, ' ', IFNULL(CONCAT(SUBSTRING(@SecondName, 1, 1), '. '), ''), SUBSTRING(pLastName, 1, 1), '.')),
    '123:ABC:00', SHA2(CONCAT(@UserId, @Amount, '123:ABC:00', @MerchantId), 256), CONCAT('Compra del patrón ', @PatternName),
    @UserId, @MerchantId, 1);
    SELECT LAST_INSERT_ID() INTO @PaymentId;
    
    INSERT INTO Transactions (Checksum, PostTime, ReferenceNumber, Amount, Description, PaymentAttemptsId, TransTypeId, SubTypeId,
    EntityTypeId)
    VALUES (SHA2(CONCAT(@TransType, @SubType, 1, @Amount, NOW()), 256), NOW(), @OwnerUserId, @Amount,
    CONCAT('Compra del patrón ', @PatternName), @PaymentId, @TransTypeId, 1, 1);
    SELECT LAST_INSERT_ID() INTO @TransactionId;
    
    CALL CrearProyectoConNuevoPatron(pMacAddress, pName, pLastName, pPatternName, pOwnerMacAddress, pOwnerName, pOwnerLastName,
    @CurrentTime, pProjectName, Transaction_Count);
    
    IF Transaction_Count=1 THEN
		COMMIT;
	END IF;
END// 
DELIMITER ;

-- B) Creación de nuevo proyecto y entrega de servicio
-- Tablas modificadas: PurchasedPatternsPerUser, Projects
DROP PROCEDURE IF EXISTS CrearProyectoConNuevoPatron;
DELIMITER //
CREATE PROCEDURE CrearProyectoConNuevoPatron
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName NVARCHAR(45),
    IN pOwnerMacAddress VARCHAR(20),
    IN pOwnerName NVARCHAR(50),
    IN pOwnerLastName NVARCHAR(50),
    IN pTransactionTime DATE,
    IN pProjectName NVARCHAR(45),
    IN pTransactionCount BIT
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PATTERN INT DEFAULT(53001);
    DECLARE INVALID_PAYMENT_ATTEMPT INT DEFAULT(53009);
    DECLARE INVALID_TRANSACTION INT DEFAULT(53010);

    DECLARE Transaction_Count BIT;

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
    
    SET @OwnerUserId = 0;
    SELECT UserId INTO @OwnerUserId FROM Users
    WHERE Users.MacAddress=pOwnerMacAddress
    AND Users.`Name`=pOwnerName
    AND Users.LastName=pOwnerLastName;
    
    IF (@OwnerUserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @PatternId = 0;
    SET @PatternName = '';
    SELECT PatternId, Title INTO @PatternId, @PatternName FROM Patterns
    WHERE Patterns.UserId=@OwnerUserId
    AND Patterns.Title=pPatternName;
    
    IF (@PatternId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PATTERN;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @UserId = 0;
    SELECT UserId INTO @UserId FROM Users
    WHERE Users.MacAddress = pMacAddress  
    AND Users.Name = pName
    AND Users.Lastname = pLastName;
    
    IF(@UserId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
    END IF;
    
    SET @PaymentId = 0;
    SELECT PaymentAttemptId INTO @PaymentId FROM PaymentAttempts
    WHERE PaymentAttempts.PostTime = pTransactionTime
    AND PaymentAttempts.UserId = @UserId
    AND PaymentAttempts.ReferenceNumber = @OwnerUserId;
    
    IF(@PaymentId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PAYMENT_ATTEMPT;
    END IF;
    
    SET @TransId = 0;
    SELECT TransactionId INTO @TransId FROM Transactions
    WHERE Transactions.PaymentAttemptId = @PaymentId;
    
	IF(@TransId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_TRANSACTION;
    END IF;
    
    SET @ProjectId = 0;
    
    IF pTransactionCount=0 THEN
		SET Transaction_Count = 1;
        SET pTransactionCount = 1;
        START TRANSACTION;
	END IF;
    
    INSERT INTO PurchasedPatternsPerUser (UserId, PatternId, TransactionId)
    VALUES (@UserId, @PatternId, @TransId);
    
    INSERT INTO Projects (`Name`, `Time`, PatternId, UserId)
    VALUES (pProjectName, '00:00:00', @PatternId, @UserId);
    SELECT LAST_INSERT_ID() INTO @ProjectId;

    CALL MaterialesNuevoProyecto(pMacAddress, pName, pLastName, pOwnerMacAddress, pOwnerName, pOwnerLastName, pProjectName,
    pTransactionCount);
    
    IF Transaction_Count=1 THEN
		COMMIT;
	END IF;
END// 

DELIMITER ;

-- C) Aumento del contador de proyectos y materiales por proyecto
-- Tablas modificadas: Users, MaterialsPerProject
DROP PROCEDURE IF EXISTS MaterialesNuevoProyecto;
DELIMITER //
CREATE PROCEDURE MaterialesNuevoProyecto
(
	IN pMacAddress VARCHAR(20),
    IN pName NVARCHAR(50),
    IN pLastName NVARCHAR(50),
    IN pPatternName NVARCHAR(45),
    IN pOwnerMacAddress VARCHAR(20),
    IN pOwnerName NVARCHAR(50),
    IN pOwnerLastName NVARCHAR(50),
    IN pProjectName NVARCHAR(45),
    IN pTransactionCount BIT
)
BEGIN
	DECLARE INVALID_USER INT DEFAULT(53000);
    DECLARE INVALID_PATTERN INT DEFAULT(53001);
	DECLARE INVALID_PROJECT INT DEFAULT(53003);
    
	DECLARE Transaction_Count BIT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE Cursor_AmountSpent DECIMAL(5,2);
    DECLARE Cursor_MaterialId INT;
    DECLARE Cursor_PatternId BIGINT;
    DECLARE Cursor_MeasureUnitId INT;
    DECLARE Materials_Cursor CURSOR FOR SELECT AmountSpent, MaterialId, PatternId, MeasureUnitId FROM MaterialsPerPattern;
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
    
    SET @OwnerUserId = 0;
    SELECT UserId INTO @OwnerUserId FROM Users
    WHERE Users.MacAddress=pOwnerMacAddress
    AND Users.`Name`=pOwnerName
    AND Users.LastName=pOwnerLastName;
    
    IF (@OwnerUserId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @PatternId = 0;
    SET @PatternName = '';
    SELECT PatternId, Title INTO @PatternId, @PatternName FROM Patterns
    WHERE Patterns.UserId=@OwnerUserId
    AND Patterns.Title=pPatternName;
    
    IF (@PatternId=0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PATTERN;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no ha sido encontrado';
    END IF;
    
    SET @UserId = 0;
    SELECT UserId INTO @UserId FROM Users
    WHERE Users.MacAddress = pMacAddress  
    AND Users.Name = pName
    AND Users.Lastname = pLastName;
    
    IF(@UserId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_USER;
    END IF;
    
    SET @ProjectId = 0;
    SELECT ProjectId INTO @ProjectId FROM Projects
    WHERE Projects.UserId = @UserId
    AND Projects.Name = pProjectName;
    
    IF(@ProjectId = 0) THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_PROJECT;
    END IF;

    IF pTransactionCount=0 THEN
		SET Transaction_Count = 1;
        SET pTransactionCount = 1;
        START TRANSACTION;
	END IF;
    
    UPDATE Users
    SET ProjectCount = ProjectCount + 1
    WHERE Users.UserId=@UserId;
    
    OPEN Materials_Cursor;
		readMaterials : LOOP
			FETCH Materials_Cursor INTO Cursor_AmountSpent, Cursor_MaterialId, Cursor_PatternId, Cursor_MeasureUnitId;
			IF done THEN
				LEAVE readMaterials;
			END IF;
            IF Cursor_PatternId = @PatternId THEN
				INSERT INTO MaterialsPerProject (AmountSpent, MaterialId, ProjectId, MeasureUnitId)
				VALUES (Cursor_AmountSpent, Cursor_MaterialId, @ProjectId, Cursor_MeasureUnitId);
            END IF;
		END LOOP;
    CLOSE Materials_Cursor;
    
    IF Transaction_Count=1 THEN
		COMMIT;
	END IF;
END// 

-- 9. Insertar N pasos a un patrón
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
