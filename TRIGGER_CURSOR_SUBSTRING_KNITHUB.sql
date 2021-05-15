-- Trigger:
-- Se actualiza el contador de patrones o proyectos del usuario cuando agrega uno nuevo. 
DROP TRIGGER IF EXISTS TR_after_insert_patrones; 
DELIMITER //
CREATE TRIGGER TR_after_insert_patrones AFTER INSERT
ON Patterns FOR EACH ROW 
	UPDATE Users SET PatternCount=PatternCount+1
	WHERE UserId=Users.UserId;
//
DELIMITER ;

DROP TRIGGER IF EXISTS TR_after_insert_proyectos; 
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

UPDATE PaymentAttempts
SET Checksum = SHA2(CONCAT(PaymentAttemptId,PostTime, Amount,CurrencySymbol,ReferenceNumber,ErrorNumber,MerchantTransNumber,
PaymentTimeStamp,ComputerName,Username,IPAddress,UserId,MerchantId,PaymentStatusId,(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Transactions
SET Checksum = SHA2(CONCAT(TransactionId,PostTime,ReferenceNumber,Amount,PaymentAttemptId,TransTypeId, SubTypeId,EntityTypeId,
(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Logs
SET Checksum = SHA2(CONCAT(LogId,PostTime,ComputerName,Username,IPAddress,RefId1,RefId2,OldValue,NewValue,SeverityId,EntityTypeId,AppSourceId,
LogTypeId,UserId,(SELECT SUBSTRING(Description, 0, 3))), 256);

UPDATE Benefits
SET Checksum =  SHA2(CONCAT(BenefitId,Name,(SELECT SUBSTRING(Description, 0, 3))), 256);
