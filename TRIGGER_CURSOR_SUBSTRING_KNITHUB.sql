-- Trigger:
-- Se actualiza el contador de patrones o proyectos del usuario cuando agrega uno nuevo. 
DELIMITER //
CREATE TRIGGER TR_after_insert_patrones AFTER INSERT
ON Patterns FOR EACH ROW 
	UPDATE Users SET PatternCount=PatternCount+1
	WHERE UserId=Users.UserId;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER TR_after_insert_proyectos AFTER INSERT
ON Patterns FOR EACH ROW 
	UPDATE Users SET ProjectCount=ProjectCount+1
	WHERE UserId=Users.UserId;
//
DELIMITER ;

-- Cursor:

-- Substring: 
-- Se hace uso del substring para generar los checksums:
SET SQL_SAFE_UPDATES=0;

UPDATE PaymentsAttempts
SET Checksum = SHA2(CONCAT(PaymentAttemptsId,PostTime, Amount,CurrencySymbol,ReferenceNumber,ErrorNumber,MerchantTransNumber,
PaymentTimeStamp,ComputerName,Username,IPAddress,UserId,MerchantId,PaymentStatusId,(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Transactions
SET Checksum = SHA2(CONCAT(TransactionId,PostTime,ReferenceNumber,Amount,PaymentAttemptsId,TransTypeId, SubTypeId,EntityTypeId,
(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Logs
SET Checksum = SHA2(CONCAT(LogId,PostTime,ComputerName,Username,IPAddress,RefId1,RefId2,OldValue,NewValue,SeverityId,EntityTypeId,AppSourceId,
LogTypeId,UserId,(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Benefits
SET Checksum =  SHA2(CONCAT(BenefitId,Name,(SELECT SUBSTRING(Description, 0, 3))), 256);
