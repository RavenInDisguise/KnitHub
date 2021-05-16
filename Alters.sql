ALTER TABLE Patterns
ADD creationDate DATETIME;

ALTER TABLE Projects
ADD creationDate DATETIME;

ALTER TABLE PriceValues
ADD CurrencySymbol VARCHAR(6) NOT NULL;

ALTER TABLE PaymentsAttempts
MODIFY Username NVARCHAR(65) NOT NULL;

ALTER TABLE PaymentsAttempts
RENAME TO PaymentAttempts;

ALTER TABLE PaymentAttempts 
RENAME COLUMN PaymentAttemptsId TO PaymentAttemptId;

ALTER TABLE Transactions 
RENAME COLUMN PaymentAttemptsId TO PaymentAttemptId;

ALTER TABLE PaymentAttempts
DROP COLUMN PaymentConceptId;

ALTER TABLE Plans
MODIFY EndTime datetime NULL;

ALTER TABLE Steps
ADD StepNumber INT NOT NULL;

ALTER TABLE PlansPerUser ADD TransactionId BIGINT NOT NULL;
ALTER TABLE PlansPerUser ADD CONSTRAINT fk_PlansPerUser_Transactions1 FOREIGN KEY (TransactionId) REFERENCES Knithub.Transactions (TransactionId);

ALTER TABLE PlansPerUser 
DROP PRIMARY KEY;