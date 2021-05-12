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