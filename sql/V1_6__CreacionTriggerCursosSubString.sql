-- Script de generación de views

-- PAYMENTS AND TRANSACTIONS VIEW:
DROP VIEW IF EXISTS payment_transactions;
CREATE VIEW payment_transactions
AS
SELECT `Users`.`UserId`,
    `Users`.`MacAddress`,
    `Users`.`Nickname`,
    CONCAT(`Users`.`Name`,' ',IFNULL(CONCAT(SecondName, ' '), ''),`Users`.`LastName`) AS 'PersonName',
    `Users`.`Password`,
    `Users`.`PatternCount`,
    `Users`.`ProjectCount`,
    `Countries`.`Name` AS 'CountryName',
    `Cities`.`Name` AS 'CityName',
     PayAtt.`PaymentAttemptId`,
     PayAtt.`PostTime`,
     PayAtt.`Amount`,
     PayAtt.`CurrencySymbol`,
     PayAtt.`ReferenceNumber`,
     PayAtt.`ErrorNumber`,
     PayAtt.`MerchantTransNumber`,
     PayAtt.`PaymentTimeStamp`,
     PayAtt.`ComputerName`,
     PayAtt.`Username`,
     PayAtt.`IPAddress`,
     PayAtt.`Checksum`,
     PayAtt.`Description`,
     PayStat.`Name` AS 'PaymentStatus',
    `Merchants`.`Name` AS 'MerchantName',
    `Merchants`.`Url` AS 'MerchantURL',
    `Merchants`.`Enabled` AS 'MerchantEnabled',
    `Merchants`.`IconUrl` AS 'MerchantIconURL',
	 Trans.`Description` AS 'TransDescription',
     Trans.`PostTime` 'TransPosttime',
     Trans.`ReferenceNumber` AS 'TransReferenceNumber',
     Trans.`Amount` AS 'TransAmount',
     Trans.`Checksum` AS 'TransChecksum',
     Trans.`TransactionId` AS 'TransId',
     TTypes.`Name` AS 'TransType',
     STypes.`Name` AS 'SubTypes',
     EntTypes.`Name` AS 'EntityType'
FROM `KnitHub`.`Users`
INNER JOIN Cities ON Users.CityId=Cities.CityId
INNER JOIN Countries ON Cities.CountryId=Countries.CountryId
INNER JOIN PaymentAttempts PayAtt ON Users.UserId=PayAtt.UserId
INNER JOIN Merchants ON PayAtt.MerchantId=Merchants.MerchantId
INNER JOIN PaymentStatus PayStat ON PayAtt.PaymentStatusId=PayStat.PaymentStatusId
INNER JOIN Transactions Trans ON Trans.PaymentAttemptId=PayAtt.PaymentAttemptId
INNER JOIN TransTypes TTypes ON Trans.TransTypeId=TTypes.TransTypeId
INNER JOIN SubTypes STypes ON Trans.SubTypeId=STypes.SubTypeId
INNER JOIN EntityTypes EntTypes ON EntTypes.EntityTypeId=Trans.EntityTypeId; 



-- PROJECTS AND PATTERNS VIEW:
DROP VIEW IF EXISTS projects_patterns;

CREATE VIEW projects_patterns
AS
SELECT `Users`.`UserId`,
	IFNULL(`Users`.`Nickname`, 'NONE') AS 'Nickname',
	CONCAT(`Users`.`Name`,' ',IFNULL(CONCAT(SecondName, ' '), ''),`Users`.`LastName`) AS 'PersonName',
	`Users`.`MacAddress`,
    IFNULL(`Users`.`Password`, 'NONE') AS 'Password',
    `Users`.`PatternCount`,
    `Users`.`ProjectCount`,
    `Cities`.`Name` AS 'CityName',
    `Countries`.`Name` AS 'CountryName',
    `Projects`.ProjectId,
    `Projects`.`Name` AS 'ProjectName',
    IFNULL(`Projects`.`Time`, '00:00:00') AS 'ProjectTime',
    IFNULL(`Projects`.`PricePerHour`, '0') AS 'ProjectPricePerHour',
    IFNULL(`Projects`.`TotalPrice`, '0') AS 'ProjectTotalPrice',
    `Materials`.`Name` AS 'MaterialName',
    IFNULL(`Materials`.`Description`, 'NONE') AS 'MaterialDescription',
    CONCAT(IFNULL(`MaterialsPerProject`.`AmountSpent`, '0'), ' ', `MeasureUnits`.`Abbreviation`) AS 'MaterialSpent',
    IFNULL(`MaterialsPerProject`.`PurchasePrice`, '0') AS 'MaterialCost',
    `Patterns`.`PatternId`,
    `Patterns`.`Title` AS 'PatternName',
    IFNULL(`Patterns`.`Description`, 'NONE') AS 'PatternDescription',
    `PatternCategories`.`Name` AS 'PatternCategoryName',
    `Steps`.`Instruction` AS 'PatternStepInstruction',
    `MediaTypes`.`Name` AS 'MediaType',
	`Medias`.`URL` AS 'MediaURL'
FROM `KnitHub`.`Users`
INNER JOIN Cities ON Users.CityId=Cities.CityId
INNER JOIN Countries ON Cities.CountryId=Countries.CountryId
INNER JOIN Projects ON Projects.UserId=Users.UserId
INNER JOIN MaterialsPerProject ON Projects.ProjectId=MaterialsPerProject.ProjectId
INNER JOIN Materials ON Materials.MaterialId=MaterialsPerProject.MaterialId
INNER JOIN MeasureUnits ON MaterialsPerProject.MeasureUnitId=MeasureUnits.MeasureUnitId
INNER JOIN Patterns ON Projects.PatternId=Patterns.PatternId
INNER JOIN Steps ON Steps.PatternId=Patterns.PatternId
INNER JOIN Medias ON Medias.StepId=Steps.StepId
INNER JOIN MediaTypes ON Medias.MediaTypeId=MediaTypes.MediaTypeId
INNER JOIN CategoriesPerPattern ON Patterns.PatternId=CategoriesPerPattern.PatternId
INNER JOIN PatternCategories ON PatternCategories.PatternCategoryId=CategoriesPerPattern.PatternCategoryId
