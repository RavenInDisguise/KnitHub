DROP PROCEDURE IF EXISTS FillUsers;
DELIMITER //
CREATE PROCEDURE FillUsers()
BEGIN    
    SET @Cantidad = 1;
    SET @UserId = 1;
    SET @MacAddress = '';
    SET @Nickname = '';
    SET @Name = '';
    SET @LastName = '';
    SET @Password = '';
    SET @CityId = 0;

	WHILE @Cantidad <= 500 DO
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
    
    SET @Cantidad = 1;
    SET @Id = 1;
    SET @Price = 1;

	WHILE @Cantidad <= 100 DO
        SET @Id = @Cantidad;
        SET @Price = RAND()*(50000-500+1)+500;
        
		INSERT INTO PriceValues (PriceValueId, StartDate, Active, Price, CurrencySymbol)
		VALUES (@Id, SYSDATE(), 1, @Price, '₡');
        
        
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
    SET @PatternId = 1;
    SET @Title = '';
    SET @Description = '';
    SET @UserId = 0;
    SET @Steps = 1;
    SET @CurrentStep = 1;
    SET @StepId = 1;
    SET @MediaTypeId = 1;
    SET @MediaName = '';
    SET @PatternCategoryId = 0;
    SET @PriceValueId = 0;
    SET @Name = '';
    SET @SecondNamd = '';
    SET @LastName = '';
    SET @Nickname = '';

	WHILE @Cantidad <= 500 DO
        SET @PatternId = @Cantidad;
        SELECT CONCAT('Patron', @PatternId) INTO @Title; 
        SELECT CONCAT('Descripción perteneciente al ', @Title) INTO @Description;
        SELECT UserId, Name, SecondName, LastName, Nickname INTO @UserId, @Name, @SecondName, @LastName, @Nickname
        FROM Users ORDER BY RAND() LIMIT 1;
        SET @Nickname = IFNULL(@Nickname, CONCAT(@Name, '_', IFNULL(CONCAT(SUBSTRING(@SecondName, 1, 1), '_'), ''), SUBSTRING(@LastName, 1, 1)));
        
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
            
            SELECT MediaTypeId, Name INTO @MediaTypeId, @MediaName FROM MediaTypes ORDER BY RAND() LIMIT 1;
            INSERT INTO Medias (URL, MediaTypeId, StepId)
            VALUES (CONCAT('https://KnitHub.com/', UUID()), @MediaTypeId, @StepId);
        END WHILE;
        
        
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
    SET @ProjectId = 1;
    SET @Name = '';
    SET @PricePerHour = 0.0;
    SET @PatternId = 0;
    SET @UserId = 0;

	WHILE @Cantidad <= 500 DO
        SET @ProjectId = @Cantidad;
        SELECT CONCAT('Proyecto', @ProjectId) INTO @Name; 
        -- El random da el mismo en cada iteración solucionar --
        SELECT RAND()*(5000-500)+500 INTO @PricePerHour;
        SELECT PatternId INTO @PatternId FROM Patterns ORDER BY RAND() LIMIT 1;
        SELECT UserId INTO @UserId FROM Users ORDER BY RAND() LIMIT 1;
        
        -- Se puede variar el starttime, sumando o restando a SYSDATE()
		INSERT INTO Projects (ProjectId, Name, Time, PricePerHour, PatternId, UserId, creationDate)
		VALUES (@ProjectId, @Name, 0, @Amount, @PatternId, @UserId, SYSDATE());
        
        UPDATE Users SET ProjectCount = ProjectCount + 1
        WHERE Users.UserId=@UserId;
        
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
    SET @UserId = 1;
    SET @PlanId = 1;
    SET @TransactionId = 1;

	WHILE @Cantidad <= 500 DO
    
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

DROP PROCEDURE IF EXISTS FillTransactions;
DELIMITER //
CREATE PROCEDURE FillTransactions()
BEGIN
    DECLARE Time TIME;
    DECLARE CreationDate DATETIME;
    
    SET @Cantidad = 1;
    SET @Id = 1;
    SET @Amount = 1; 
    SET @Reference = 1;
    SET @Merchant = 1;
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
