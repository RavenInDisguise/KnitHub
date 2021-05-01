CREATE VIEW projects_patterns
AS
SELECT `Users`.`UserId`,
	IFNULL(`Users`.`Nickname`, 'NONE') AS 'Nickname',
	CONCAT(`Users`.`Name`, ' ', IFNULL(SecondName, ''), ' ', `Users`.`LastName`) AS 'PersonName',
	`Users`.`MacAdress`,
    IFNULL(`Users`.`Password`, 'NONE') AS 'Password',
    `Users`.`PatternCount`,
    `Users`.`ProjectCount`,
    `Cities`.`Name` AS 'CityName',
    `Countries`.`Name` AS 'CountryName',
    `Projects`.`Name` AS 'ProjectName',
    IFNULL(`Projects`.`Time`, '00:00:00') AS 'ProjectTime',
    IFNULL(`Projects`.`PricePerHour`, '0') AS 'ProjectPricePerHour',
    IFNULL(`Projects`.`TotalPrice`, '0') AS 'ProjectTotalPrice',
    `Materials`.`Name` AS 'MaterialName',
    IFNULL(`Materials`.`Description`, 'NONE') AS 'MaterialDescription',
    CONCAT(IFNULL(`MaterialsPerProject`.`AmountSpent`, '0'), ' ', `MeasureUnits`.`Abbreviation`) AS 'MaterialSpent',
    IFNULL(`MaterialsPerProject`.`PurchasePrice`, '0') AS 'MaterialCost',
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