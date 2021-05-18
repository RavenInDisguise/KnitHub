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

    SET @PatternCategoryId = 0;

	WHILE @Cantidad <= 500 DO
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
        
		SET @Cantidad = @Cantidad + 1;
	END WHILE;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS FillPlans;
DELIMITER //
CREATE PROCEDURE FillPlans()
BEGIN
    DECLARE StartTime DATETIME;
    
    SET @Cantidad = 1;
    SET @PlanId = 1;
    SET @Name = '';
    SET @Amount = 0.0;
    SET @Description = '';
    SET @Enabled = 1;
    SET @IconUrl = '';
    SET @RecurrenceTypeId = 0;

	WHILE @Cantidad <= 500 DO
        SET @PlanId = @Cantidad;
        SELECT CONCAT('Plan', @PlanId) INTO @Name; 
        SELECT RAND()*(30000-10000)+10000 INTO @Amount;
        SELECT CONCAT('Descripción perteneciente al ', @Name) INTO @Description;
        SELECT CONCAT('https://KnitHub/Icons/', @Name,'.jpg') INTO @IconUrl;
        SELECT RecurrenceTypeId INTO @RecurrenceTypeId FROM RecurrencesTypes ORDER BY RAND() LIMIT 1;
        
        -- Se puede variar el starttime, sumando o restando a SYSDATE()
		INSERT INTO Plans (PlanId, Name, Amount, Description, StartTime, Enabled, IconUrl, RecurrenceTypeId)
		VALUES (@PlanId, @Name, @Amount, @Description, SYSDATE(), @Enabled, @IconUrl, @RecurrenceTypeId);
        
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

-- Me queda pendiente el FillTransactions() porque tengo algunas preguntas :D