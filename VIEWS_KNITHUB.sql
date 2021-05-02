-- Script de generación de views

-- PAYMENTS AND TRANSACTIONS VIEW:
CREATE VIEW paymenttransactions
AS
SELECT `Users`.`UserId`,
    `Users`.`MacAddress`,
    `Users`.`Nickname`,
    CONCAT(`Users`.`Name`,' ',IFNULL(SecondName, ''),' ',`Users`.`LastName`) AS 'PersonName',
    `Users`.`Password`,
    `Users`.`PatternCount`,
    `Users`.`ProjectCount`,
    `Countries`.`Name` AS 'CountryName',
    `Cities`.`Name` AS 'CityName',
     PayAtt.`PaymentAttemptsId`,
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
INNER JOIN Countries ON Cities.CityId=Countries.CountryId
INNER JOIN PaymentsAttempts PayAtt ON Users.UserId=PayAtt.UserId
INNER JOIN Merchants ON PayAtt.MerchantId=Merchants.MerchantId
INNER JOIN PaymentStatus PayStat ON PayAtt.PaymentStatusId=PayStat.PaymentStatusId
INNER JOIN Transactions Trans ON Trans.PaymentAttemptsId=PayAtt.PaymentAttemptsId
INNER JOIN TransTypes TTypes ON Trans.TransactionId=TTypes.TransTypeId
INNER JOIN SubTypes STypes ON Trans.SubTypeId=STypes.SubTypeId
INNER JOIN EntityTypes EntTypes ON EntTypes.EntityTypeId=Trans.EntityTypeId; 



