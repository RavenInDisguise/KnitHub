-- Trigger:
DELIMITER //
CREATE TRIGGER TR_ BEFORE INSERT
ON  FOR EACH ROW 
	UPDATE 
	WHERE 
//
DELIMITER ;

CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
 INSERT INTO employees_audit
 SET action = 'update',
     employeeNumber = OLD.employeeNumber,
     lastname = OLD.lastname,
     changedat = NOW();

DELIMITER //
CREATE TRIGGER TR_acc_transactions_after_insert AFTER INSERT 
ON acc_transactions FOR EACH ROW 
	UPDATE acc_balances SET amount = amount + NEW.Amount
	WHERE userid=NEW.UserId AND fundid= NEW.fundid;
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
