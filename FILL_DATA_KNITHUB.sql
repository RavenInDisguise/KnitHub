DROP PROCEDURE IF EXISTS FillUsers;
DELIMITER //
CREATE PROCEDURE FillUsers()
BEGIN    
    SET @Cantidad = 1;
    SET @UserId = 0;
    SET @MacAddress = '';
    SET @Nickname = '';
    SET @Name = '';
    SET @LastName = '';
    SET @Password = '';
    SET @CityId = 0;

	WHILE @Cantidad <= 250 DO
        SET @UserId = @Cantidad;
        SELECT CONCAT('QW:ER:TY:DS:', @UserId) INTO @MacAddress; 
        SELECT CONCAT('RNuñez', @UserId) INTO @Nickname;
        SET @Name = 'Rodrigo';
        SELECT CONCAT('Nuñez', @UserId) INTO @LastName;
		SELECT CONCAT( SUBSTRING(@Name, 1, 2), SUBSTRING(@LastName, 1, 2), @UserId ) INTO @Password; 
		SELECT CityId INTO @CityId FROM Cities ORDER BY RAND() LIMIT 1;
        
		INSERT INTO Users (UserId, MacAddress, Nickname, Name, LastName, Password, PatternCount, ProjectCount, CityId) 
		VALUES (@UserId, @MacAddress, @Nickname, @Name, @LastName, @Password, 0, 0, @CityId);
        
		SET @Cantidad = @Cantidad + 1;
	END WHILE;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS FillPriceValues;
DELIMITER //
CREATE PROCEDURE FillPriceValues()
BEGIN
    DECLARE CreationDate DATETIME;
    
    SET @Cantidad = 2;
    SET @PriceValueId = 0;
    SET @Price = 0;

	WHILE @Cantidad <= 100 DO
        SET @PriceValueId = @Cantidad;
        SET @Price = RAND()*(50000-500+1)+500;
        
		INSERT INTO PriceValues (PriceValueId, StartDate, Active, Price, CurrencySymbol)
		VALUES (@PriceValueId, SYSDATE(), 1, @Price, '₡');

		SET @Cantidad = @Cantidad + 1;
	END WHILE;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS FillPatterns;
DELIMITER //
CREATE PROCEDURE FillPatterns()
BEGIN
    DECLARE CreationDate DATETIME;
    
    SET @Cantidad = 1;
    SET @PatternId = 0;
    SET @Title = '';
    SET @Description = '';
    SET @UserId = 0;
    SET @Steps = 0;
    SET @CurrentStep = 0;
    SET @StepId = 0;
    SET @MediaTypeId = 0;
    SET @MediaName = '';
    
    SET @PatternCategoryId = 0;
    SET @PriceValueId = 0;
    
	WHILE @Cantidad <= 250 DO
        SET @PatternId = @Cantidad;
        SELECT CONCAT('Patron', @PatternId) INTO @Title; 
        SELECT CONCAT('Descripción perteneciente al ', @Title) INTO @Description;
        SELECT UserId INTO @UserId FROM Users ORDER BY RAND() LIMIT 1;
        
        
		INSERT INTO Patterns (PatternId, Title, Description, UserId, creationDate)
		VALUES (@PatternId, @Title, @Description, @UserId, SYSDATE());
        
        
        UPDATE Users SET PatternCount = PatternCount + 1
        WHERE Users.UserId=@UserId;
        
        -- En caso de que se desee asociar una categoría ya existente al patrón, se hace lo siguiente
        SELECT PatternCategoryId INTO @PatternCategoryId FROM PatternCategories ORDER BY RAND() LIMIT 1;
        
        INSERT INTO CategoriesPerPattern (PatternCategoryId, PatternId) 
        VALUES (@PatternCategoryId, @PatternId);
        
        -- -------------------------------------------------------------------------------------------
        SET @OnSale = FLOOR( RAND()*(1-0+1)+0 );
        
        IF(@OnSale=1) THEN 
			SELECT PriceValueId INTO @PriceValueId FROM PriceValues ORDER BY RAND() LIMIT 1;
			
			INSERT INTO PatternsOnSale (Date, OnSale, PatternId, PriceValueId)
            VALUES (SYSDATE(), @OnSale, @PatternId, @PriceValueId);
		END IF;
        
        
        SET @Steps = FLOOR(RAND()*(7-3+1)+3);
        SET @CurrentStep = 1;
        WHILE @CurrentStep <= @Steps DO
			INSERT INTO Steps (StepNumber, Instruction, PatternId)
            VALUES (@CurrentStep, CONCAT('Paso no. ', @CurrentStep), @PatternId);
            SELECT LAST_INSERT_ID() INTO @StepId;
            
            SELECT MediaTypeId INTO @MediaTypeId FROM MediaTypes ORDER BY RAND() LIMIT 1;
            INSERT INTO Medias (URL, MediaTypeId, StepId)
            VALUES (CONCAT('https://KnitHub.com/', UUID()), @MediaTypeId, @StepId);
            
            SET @CurrentStep = @CurrentStep + 1;
        END WHILE;
        
        
        
        SET @MaterialId = 0;
        SELECT MaterialId INTO @MaterialId FROM Materials ORDER BY RAND() LIMIT 1;
        
        SET @MeasureUnitId = 0;
		SELECT MeasureUnitId INTO @MeasureUnitId FROM MeasureUnits ORDER BY RAND() LIMIT 1;
	
	
		INSERT INTO MaterialsPerPattern(AmountSpent, MaterialId, PatternId, MeasureUnitId)
		VALUES ( ( RAND()*(30-1+1)+1 ), @MaterialId , @PatternId, @MeasureUnitId); 
	
        
		SET @Cantidad = @Cantidad + 1;
	END WHILE;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS FillProjects;
DELIMITER //
CREATE PROCEDURE FillProjects()
BEGIN
    DECLARE Time TIME;
    DECLARE CreationDate DATETIME;
    
    SET @Cantidad = 1;
    SET @ProjectId = 0;
    SET @Name = '';
    SET @PricePerHour = 0.0;
    SET @PatternId = 0;
    SET @UserId = 0;

	WHILE @Cantidad <= 250 DO
        SET @ProjectId = @Cantidad;
        SELECT CONCAT('Proyecto', @ProjectId) INTO @Name; 
        -- El random da el mismo en cada iteración, solucionar --
        SELECT RAND()*(5000-500)+500 INTO @PricePerHour;
        SELECT PatternId INTO @PatternId FROM Patterns ORDER BY RAND() LIMIT 1;
        SELECT UserId INTO @UserId FROM Users ORDER BY RAND() LIMIT 1;
        
        -- Se puede variar el starttime, sumando o restando a SYSDATE()
		INSERT INTO Projects (ProjectId, Name, Time, PricePerHour, PatternId, UserId, creationDate)
		VALUES (@ProjectId, @Name, 0, @PricePerHour, @PatternId, @UserId, SYSDATE());
        
        UPDATE Users SET ProjectCount = ProjectCount + 1
        WHERE Users.UserId=@UserId;
        
        SET @MaterialId = 0;
        SELECT MaterialId INTO @MaterialId FROM Materials ORDER BY RAND() LIMIT 1;
        
        SET @MeasureUnitId = 0;
		SELECT MeasureUnitId INTO @MeasureUnitId FROM MeasureUnits ORDER BY RAND() LIMIT 1;
	
		INSERT INTO MaterialsPerProject(AmountSpent, PurchasePrice, MaterialId, ProjectId, MeasureUnitId)
		VALUES ( ( RAND()*(30-1+1)+1 ), ( RAND()*(2000-100+1)+100 ), @MaterialId, @ProjectId, @MeasureUnitId); 
        
		SET @Cantidad = @Cantidad + 1;
	END WHILE;
END //
DELIMITER ;

SELECT DATE_ADD(SYSDATE(), INTERVAL -12 MONTH);

SELECT DATE_ADD(SYSDATE(), INTERVAL (RAND()*(365-15)+15) DAY);

DROP PROCEDURE IF EXISTS FillTransactions;
DELIMITER //
CREATE PROCEDURE FillTransactions()
BEGIN
    DECLARE Time TIME;
    DECLARE CreationDate DATETIME;
    
    SET @Cantidad = 1;
    SET @TransactionId = 0;
    SET @Amount = 1; 
    SET @ReferenceNumber = 0;
    SET @MerchantTransNumber = 1;
    SET @UserId = 0;
    SET @ComputerName = '';
    SET @Name = '';
    SET @SecondName = '';
    SET @LastName = '';
    SET @Nickname = '';
    SET @IP = '';
    SET @Checksum = '';
    SET @Checksum2= '';
    SET @Description = '';
    SET @MerchantId = 1;
    SET @PaymentStatusId = 1;
    SET @TransTypeId = 1;
    SET @SubTypeId = 1;
    SET @EntityTypeId = 1;

	WHILE @Cantidad <= 500 DO
        SET @Id = @Cantidad;
        SET @Amount = RAND()*(100000+1);
        SET @Reference = FLOOR(RAND()*(30-1+1)+1);
        SET @Merchant = FLOOR(RAND()*(15-1+1)+1);
        SELECT MerchantId INTO @MerchantId FROM Merchants ORDER BY RAND() LIMIT 1;
        SELECT UserId, MacAddress, Name, SecondName, LastName, Nickname INTO @UserId, @ComputerName, @Name, @SecondName, @LastName,
        @Nickname FROM Users ORDER BY RAND() LIMIT 1;
        SET @Nickname = IFNULL(@Nickname, CONCAT(@Name, ' ', IFNULL(CONCAT(SUBSTRING(@SecondName, 1, 1), '. '), ''), SUBSTRING(@LastName, 1, 1), '.'));
        SET @IP = CONCAT('192.0.0.', @UserId);
        SET @Checksum = SHA2(CONCAT(@UserId, @Amount, @IP, @MerchantId), 256);
        SET @Description = CONCAT('Transaccion no. ', @Id);
        SELECT PaymentStatusId INTO @PaymentStatusId FROM PaymentStatus ORDER BY RAND() LIMIT 1;
        
        SELECT TransTypeId INTO @TransTypeId FROM TransTypes ORDER BY RAND() LIMIT 1;
        SELECT SubTypeId INTO @SubTypeId FROM SubTypes ORDER BY RAND() LIMIT 1;
        SELECT EntityTypeId INTO @EntityTypeId FROM EntityTypes ORDER BY RAND() LIMIT 1;
        SET @Checksum2 = SHA2(CONCAT(@TransTypeId, @SubTypeId, @EntityTypeId, @Amount, NOW()), 256);
        
		INSERT INTO PaymentAttempts (PaymentAttemptId, PostTime, Amount, CurrencySymbol, ReferenceNumber, MerchantTransNumber,
        PaymentTimeStamp, ComputerName, Username, IPAddress, Checksum, Description, UserId, MerchantId, PaymentStatusId)
		VALUES (@Id, SYSDATE(), @Amount, '₡', @Reference, @Merchant, CURRENT_TIMESTAMP(), @ComputerName, @Nickname, @IP,
        @Checksum, @Description, @UserId, @MerchantId, @PaymentStatusId);
        
        INSERT INTO Transactions (TransactionId, Checksum, PostTime, ReferenceNumber, Amount, Description, PaymentAttemptId,
        TransTypeId, SubTypeId, EntityTypeId)
        VALUES (@Id, @Checksum2, SYSDATE(), @Reference, @Amount, @Description, @Id, @TransTypeId, @SubTypeId, @EntityTypeId);
        
		SET @Cantidad = @Cantidad + 1;
	END WHILE;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS FillPlansPerUser;
DELIMITER //
CREATE PROCEDURE FillPlansPerUser()
BEGIN
    DECLARE PostTime DATETIME;
    DECLARE NextTime DATETIME;
    
    SET @Cantidad = 1;
    SET @UserId = 0;
    SET @PlanId = 0;
    SET @TransactionId = 0;

	WHILE @Cantidad <= 250 DO
    
		SET PostTime = SYSDATE();
		SET NextTime = DATE_ADD(SYSDATE(), INTERVAL (RAND()*(365-15)+15) DAY);
        SELECT UserId INTO @UserId FROM Users ORDER BY RAND() LIMIT 1;
        SELECT PlanId INTO @PlanId FROM Plans ORDER BY RAND() LIMIT 1;
        SELECT TransactionId INTO @TransactionId FROM Transactions ORDER BY RAND() LIMIT 1;
        
		INSERT INTO PlansPerUser (PostTime, NextTime, UserId, PlanId, TransactionId)
		VALUES (PostTime, NextTime, @UserId, @PlanId, @TransactionId);
        
		SET @Cantidad = @Cantidad + 1; 
	END WHILE; 
END //
DELIMITER ;


Call FillUsers();
Call FillTransactions();
Call FillPlansPerUser();
Call FillPriceValues();
Call FillPatterns();
Call FillProjects();
Call FillPlansPerUser();

-- Datos para probar SP --

-- 2. Compra Planes --

INSERT INTO Users (UserId, MacAddress, Name, LastName, PatternCount, ProjectCount, CityId)
VALUES 
(5000, 'QW:ER:TY:DS:5000', 'Rodrigo', 'Nuñez5000', 0, 0, 1), 
(5001, 'QW:ER:TY:DS:5001', 'Rodrigo', 'Nuñez5001', 0, 0, 1),
(5002, 'QW:ER:TY:DS:5002', 'Rodrigo', 'Nuñez5002', 0, 0, 1),
(5003, 'QW:ER:TY:DS:5003', 'Rodrigo', 'Nuñez5003', 0, 0, 1),
(5004, 'QW:ER:TY:DS:5004', 'Rodrigo', 'Nuñez5004', 0, 0, 1);

INSERT INTO `KnitHub`.`PaymentAttempts`
(`PaymentAttemptId`, `PostTime`, `Amount`, `CurrencySymbol`, `ReferenceNumber`, `ErrorNumber`, `MerchantTransNumber`,
`PaymentTimeStamp`, `ComputerName`, `Username`, `IPAddress`, `Checksum`, `Description`, `UserId`, `MerchantId`, `PaymentStatusId`)
VALUES
(5000, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5000", 5000, 1, 1),
(5001, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5001", 5001, 2, 1),
(5002, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5002", 5002, 3, 1),
(5003, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5003", 5003, 1, 1),
(5004, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5004", 5004, 2, 1);

SET SQL_SAFE_UPDATES=0;

UPDATE PaymentAttempts
SET Checksum = SHA2(CONCAT(PaymentAttemptId,PostTime, Amount,CurrencySymbol,ReferenceNumber,IFNULL(ErrorNumber,''),MerchantTransNumber,
PaymentTimeStamp,ComputerName,Username,IPAddress,UserId,MerchantId,PaymentStatusId,(SELECT SUBSTRING(Description, 0, 3))), 256);


INSERT INTO `KnitHub`.`EntityTypes` (`EntityTypeId`, `Name`)
VALUES
(1, "Entity Type 1"),
(2, "Entity Type 2"),
(3, "Entity Type 3");

INSERT INTO `KnitHub`.`Transactions`
(`TransactionId`, `Checksum`, `PostTime`, `ReferenceNumber`, `Amount`, `Description`, `PaymentAttemptId`,
`TransTypeId`, `SubTypeId`, `EntityTypeId`)
VALUES
(5000, "Checksum", sysdate(), 1, 10000, "Transaction 5000", 5000, 1, 2, 1),
(5001, "Checksum", sysdate(), 1, 10000, "Transaction 5001", 5001, 2, 2, 2),
(5002, "Checksum", sysdate(), 1, 10000, "Transaction 5002", 5002, 1, 2, 3),
(5003, "Checksum", sysdate(), 1, 10000, "Transaction 5003", 5003, 2, 2, 1),
(5004, "Checksum", sysdate(), 1, 10000, "Transaction 5004", 5004, 1, 2, 2);
SET SQL_SAFE_UPDATES=0;

UPDATE Transactions
SET Checksum = SHA2(CONCAT(TransactionId,PostTime,ReferenceNumber,Amount,PaymentAttemptId,TransTypeId, SubTypeId,EntityTypeId,
(SELECT SUBSTRING(Description, 0, 3))), 256);

INSERT INTO PlansPerUser (PostTime, NextTime, UserId, PlanId, TransactionId)
VALUES 
(SYSDATE(), SYSDATE(), 5000, 1, 5000),
(SYSDATE(), SYSDATE(), 5001, 1, 5001),
(SYSDATE(), SYSDATE(), 5002, 2, 5002),
(SYSDATE(), SYSDATE(), 5003, 3, 5003),
(SYSDATE(), SYSDATE(), 5004, 4, 5004);

CALL CompraPlanes('QW:ER:TY:DS:5000', 'Rodrigo', 'Nuñez5000', 'Plan economico');

-- ------------------------------------------------------------

-- 3 y 4. Cronometraje de proyectos y muestra de los patrones en venta -- 

INSERT INTO Patterns (PatternId, Title, UserId, creationDate)
VALUES
(5000, 'Patrón5000', 5000, SYSDATE()),
(5001, 'Patrón5001', 5001, SYSDATE()),
(5002, 'Patrón5002', 5002, SYSDATE()),
(5003, 'Patrón5003', 5003, SYSDATE()),
(5004, 'Patrón5004', 5004, SYSDATE());

INSERT INTO CategoriesPerPattern (PatternCategoryId, PatternId)
VALUES
(1, 5000),
(2, 5001),
(3, 5002),
(1, 5003),
(2, 5004);

INSERT INTO `KnitHub`.`Projects`
(`ProjectId`, `Name`, `Time`, `PricePerHour`, `TotalPrice`, `PatternId`, `UserId`, `creationDate`)
VALUES
(5000, "Proyecto5000", "6:00", 2500, NULL, 5000, 5000, sysdate()),
(5001, "Proyecto5001", "12:00", 5000, NULL, 5001, 5001, sysdate()),
(5002, "Proyecto5002", "4:00", 2000, NULL, 5002, 5002, sysdate()),
(5003, "Proyecto5003", "18:00", 9500, NULL, 5003, 5003, sysdate()),
(5004, "Proyecto5004", "15:00", 7000, NULL, 5004, 5004, sysdate());

INSERT INTO `KnitHub`.`Steps`
(`StepId`, `Instruction`, `PatternId`, `StepNumber`)
VALUES
(5000, "Paso 5000", 5000, 1),
(5001, "Paso 5001", 5001, 1),
(5002, "Paso 5002", 5002, 1),
(5003, "Paso 5003", 5003, 1),
(5004, "Paso 5004", 5004, 1);

INSERT INTO `KnitHub`.`Medias`
(`MediaId`, `URL`, `MediaTypeId`, `StepId`)
VALUES
(5000, "http://fotodelpatron5000.com", 1, 5000),
(5001, "http://fotodelpatron5001.com", 2, 5001),
(5002, "http://fotodelpatron5002.com", 3, 5002),
(5003, "http://fotodelpatron5003.com", 1, 5003),
(5004, "http://fotodelpatron5004.com", 2, 5004);

INSERT INTO `KnitHub`.`PriceValues`
(`PriceValueId`, `StartDate`, `EndDate`, `Active`, `Price`, `CurrencySymbol`)
VALUES
(5000, sysdate(), NULL, 1, 5000, "$"),
(5001, sysdate(), NULL, 1, 10000, "$"),
(5002, sysdate(), NULL, 1, 20000, "$"),
(5003, sysdate(), NULL, 1, 40000, "$"),
(5004, sysdate(), NULL, 1, 80000, "$");

INSERT INTO `KnitHub`.`MaterialsPerProject`
(`AmountSpent`, `PurchasePrice`, `MaterialId`, `ProjectId`, `MeasureUnitId`)
VALUES
(2, 2000, 1, 5000, 1),
(5, 4000, 2, 5001, 2),
(3, 8000, 3, 5002, 3),
(7, 5500, 1, 5003, 1),
(4, 3100, 2, 5004, 2);

INSERT INTO `KnitHub`.`PatternsOnSale`
(`Date`, `OnSale`, `PatternId`, `PriceValueId`)
VALUES
(sysdate(), 1, 5000, 5000),
(sysdate(), 1, 5001, 5001),
(sysdate(), 1, 5002, 5002),
(sysdate(), 1, 5003, 5003),
(sysdate(), 1, 5004, 5004);

-- ------------------------------------------------------------

-- 1. CompraPatrones --

INSERT INTO `KnitHub`.`PaymentAttempts`
(`PaymentAttemptId`, `PostTime`, `Amount`, `CurrencySymbol`, `ReferenceNumber`, `ErrorNumber`, `MerchantTransNumber`,
`PaymentTimeStamp`, `ComputerName`, `Username`, `IPAddress`, `Checksum`, `Description`, `UserId`, `MerchantId`, `PaymentStatusId`)
VALUES
(5005, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5005", 5000, 1, 1),
(5006, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5006", 5001, 2, 1),
(5007, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5007", 5002, 3, 1),
(5008, sysdate(), 10000, "$", 2, NULL, 123456, timestamp(sysdate()), "12345", "Juan", "101.405.345", "Checksum", "Payment Attempt 5008", 5003, 1, 1);

SET SQL_SAFE_UPDATES=0;

UPDATE PaymentAttempts
SET Checksum = SHA2(CONCAT(PaymentAttemptId,PostTime, Amount,CurrencySymbol,ReferenceNumber,IFNULL(ErrorNumber,''),MerchantTransNumber,
PaymentTimeStamp,ComputerName,Username,IPAddress,UserId,MerchantId,PaymentStatusId,(SELECT SUBSTRING(Description, 0, 3))), 256);

INSERT INTO `KnitHub`.`Transactions`
(`TransactionId`, `Checksum`, `PostTime`, `ReferenceNumber`, `Amount`, `Description`, `PaymentAttemptId`,
`TransTypeId`, `SubTypeId`, `EntityTypeId`)
VALUES
(5005, "Checksum", sysdate(), 1, 10000, "Transaction 5005", 5005, 1, 1, 1),
(5006, "Checksum", sysdate(), 1, 10000, "Transaction 5006", 5006, 2, 1, 2), 
(5007, "Checksum", sysdate(), 1, 10000, "Transaction 5007", 5007, 1, 1, 3),
(5008, "Checksum", sysdate(), 1, 10000, "Transaction 5008", 5008, 2, 1, 1);
SET SQL_SAFE_UPDATES=0;

UPDATE Transactions
SET Checksum = SHA2(CONCAT(TransactionId,PostTime,ReferenceNumber,Amount,PaymentAttemptId,TransTypeId, SubTypeId,EntityTypeId,
(SELECT SUBSTRING(Description, 0, 3))), 256);

INSERT INTO PurchasedPatternsPerUser (UserId, PatternId, TransactionId)
VALUES
(5000, 5001, 5005),
(5001, 5002, 5006),
(5002, 5003, 5007),
(5003, 5004, 5008);

-- ------------------------------------------------------------
-- Usuarios que no completaron su pago:
INSERT INTO `KnitHub`.`PaymentAttempts`
(`PaymentAttemptId`,
`PostTime`,
`Amount`,
`CurrencySymbol`,
`ReferenceNumber`,
`ErrorNumber`,
`MerchantTransNumber`,
`PaymentTimeStamp`,
`ComputerName`,
`Username`,
`IPAddress`,
`Checksum`,
`Description`,
`UserId`,
`MerchantId`,
`PaymentStatusId`)
VALUES
(14262262,"2020-11-03",23000,"$",1234,null,1,"2020-11-03","Macbook1212",1,"102.345.670","Checksum","Pago de patron",1,1,2),
(14262263,"2021-11-03",23000,"$",1234,null,1,"2020-11-03","Macbook1212",1,"102.345.670","Checksum","Pago de patron",2,1,2),
(14262265,"2020-06-03",53000,"$",1234,null,1,"2020-11-03","Macbook1212",1,"102.345.670","Checksum","Pago de patron",3,1,2),
(14262264,"2020-10-03",43000,"$",1234,null,1,"2020-11-03","Macbook1212",1,"102.345.670","Checksum","Pago de patron",3,1,2),
(14262266,"2020-08-03",1000,"$",1234,null,1,"2020-11-03","Macbook1212",1,"102.345.670","Checksum","Pago de patron",4,1,2);
