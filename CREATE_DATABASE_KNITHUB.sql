-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Countries` (
  `CountryId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CountryId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Cities` (
  `CityId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `CountryId` INT NOT NULL,
  PRIMARY KEY (`CityId`),
  INDEX `fk_Cities_Countries1_idx` (`CountryId` ASC) VISIBLE,
  CONSTRAINT `fk_Cities_Countries1`
    FOREIGN KEY (`CountryId`)
    REFERENCES `mydb`.`Countries` (`CountryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Users` (
  `UserId` BIGINT NOT NULL AUTO_INCREMENT,
  `MacAdress` BINARY NOT NULL,
  `Nickname` NVARCHAR(30) NULL,
  `Name` NVARCHAR(50) NOT NULL,
  `LastName` NVARCHAR(50) NOT NULL,
  `SecondName` NVARCHAR(50) NULL,
  `Password` VARBINARY(300) NULL,
  `PatternCount` INT NOT NULL,
  `ProjectCount` INT NOT NULL,
  `CityId` INT NOT NULL,
  PRIMARY KEY (`UserId`),
  INDEX `fk_Users_Cities1_idx` (`CityId` ASC) VISIBLE,
  CONSTRAINT `fk_Users_Cities1`
    FOREIGN KEY (`CityId`)
    REFERENCES `mydb`.`Cities` (`CityId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SocialNetworks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SocialNetworks` (
  `SocialNetworksId` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `URL` VARCHAR(128) NOT NULL,
  `IconURL` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`SocialNetworksId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SocialNetworkAuthentications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SocialNetworkAuthentications` (
  `SocialNetworkAuthenticationId` INT NOT NULL AUTO_INCREMENT,
  `Token` VARCHAR(45) NOT NULL,
  `TokenValid` BIT NOT NULL,
  `ReceivedTokenTime` DATETIME NOT NULL,
  `UserId` BIGINT NOT NULL,
  `SocialNetworksId` INT NOT NULL,
  PRIMARY KEY (`SocialNetworkAuthenticationId`),
  INDEX `fk_SocialNetworksAuthentication_Users1_idx` (`UserId` ASC) VISIBLE,
  INDEX `fk_SocialNetworkAuthentication_SocialNetworks1_idx` (`SocialNetworksId` ASC) VISIBLE,
  CONSTRAINT `fk_SocialNetworksAuthentication_Users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `mydb`.`Users` (`UserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SocialNetworkAuthentication_SocialNetworks1`
    FOREIGN KEY (`SocialNetworksId`)
    REFERENCES `mydb`.`SocialNetworks` (`SocialNetworksId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Patterns`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Patterns` (
  `PatternId` BIGINT NOT NULL AUTO_INCREMENT,
  `Title` NVARCHAR(45) NOT NULL,
  `Description` NVARCHAR(100) NULL,
  `UserId` BIGINT NOT NULL,
  PRIMARY KEY (`PatternId`),
  INDEX `fk_Patterns_Users_idx` (`UserId` ASC) VISIBLE,
  CONSTRAINT `fk_Patterns_Users`
    FOREIGN KEY (`UserId`)
    REFERENCES `mydb`.`Users` (`UserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Materials`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Materials` (
  `MaterialId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Description` VARCHAR(45) NULL,
  PRIMARY KEY (`MaterialId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PatternCategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PatternCategories` (
  `PatternCategoryId` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(45) NOT NULL,
  PRIMARY KEY (`PatternCategoryId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CategoriesPerPattern`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CategoriesPerPattern` (
  `PatternCategoryId` INT NOT NULL,
  `PatternId` BIGINT NOT NULL,
  INDEX `CategoriesXPattern1_idx` (`PatternCategoryId` ASC) VISIBLE,
  INDEX `CategoriesXPattern2_idx` (`PatternId` ASC) VISIBLE,
  CONSTRAINT `CategoriesXPattern1`
    FOREIGN KEY (`PatternCategoryId`)
    REFERENCES `mydb`.`PatternCategories` (`PatternCategoryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CategoriesXPattern2`
    FOREIGN KEY (`PatternId`)
    REFERENCES `mydb`.`Patterns` (`PatternId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Projects` (
  `ProjectId` BIGINT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(45) NOT NULL,
  `Time` TIME NULL,
  `PricePerHour` DECIMAL(7,2) NULL,
  `TotalPrice` DECIMAL(10,2) NULL,
  `PatternId` BIGINT NOT NULL,
  `UserId` BIGINT NOT NULL,
  PRIMARY KEY (`ProjectId`),
  INDEX `fk_Projects_Patterns1_idx` (`PatternId` ASC) VISIBLE,
  INDEX `fk_Projects_Users1_idx` (`UserId` ASC) VISIBLE,
  CONSTRAINT `fk_Projects_Patterns1`
    FOREIGN KEY (`PatternId`)
    REFERENCES `mydb`.`Patterns` (`PatternId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Projects_Users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `mydb`.`Users` (`UserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Merchants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Merchants` (
  `MerchantId` BIGINT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(50) NOT NULL,
  `Url` VARCHAR(128) NOT NULL,
  `Enabled` BIT NOT NULL,
  `IconUrl` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`MerchantId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PaymentStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PaymentStatus` (
  `PaymentStatusId` BIGINT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(50) NOT NULL,
  PRIMARY KEY (`PaymentStatusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PaymentsAttempts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PaymentsAttempts` (
  `PaymentAttemptsId` BIGINT NOT NULL,
  `PostTime` DATETIME NOT NULL,
  `Amount` DECIMAL(12,2) NOT NULL,
  `CurrencySymbol` VARCHAR(6) NOT NULL,
  `ReferenceNumber` BIGINT NOT NULL,
  `ErrorNumber` INT NULL,
  `MerchantTransNumber` BIGINT NOT NULL,
  `PaymentTimeStamp` TIMESTAMP NOT NULL,
  `ComputerName` VARCHAR(20) NOT NULL,
  `Username` NVARCHAR(50) NOT NULL,
  `IPAddress` VARCHAR(45) NOT NULL,
  `Checksum` VARBINARY(300) NOT NULL,
  `PaymentConceptId` INT NOT NULL,
  `Description` NVARCHAR(300) NOT NULL,
  `UserId` BIGINT NOT NULL,
  `MerchantId` BIGINT NOT NULL,
  `PaymentStatusId` BIGINT NOT NULL,
  PRIMARY KEY (`PaymentAttemptsId`),
  INDEX `fk_PaymentsAttempts_Users1_idx` (`UserId` ASC) VISIBLE,
  INDEX `fk_PaymentsAttempts_Merchants1_idx` (`MerchantId` ASC) VISIBLE,
  INDEX `fk_PaymentsAttempts_PaymentStatus1_idx` (`PaymentStatusId` ASC) VISIBLE,
  CONSTRAINT `fk_PaymentsAttempts_Users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `mydb`.`Users` (`UserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PaymentsAttempts_Merchants1`
    FOREIGN KEY (`MerchantId`)
    REFERENCES `mydb`.`Merchants` (`MerchantId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PaymentsAttempts_PaymentStatus1`
    FOREIGN KEY (`PaymentStatusId`)
    REFERENCES `mydb`.`PaymentStatus` (`PaymentStatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TransTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TransTypes` (
  `TransTypeId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`TransTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SubTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SubTypes` (
  `SubTypeId` INT NOT NULL,
  `Name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`SubTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EntityTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`EntityTypes` (
  `EntityTypeId` BIGINT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`EntityTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Transactions` (
  `TransactionId` BIGINT NOT NULL,
  `Checksum` VARBINARY(300) NOT NULL,
  `PostTime` DATETIME NOT NULL,
  `ReferenceNumber` BIGINT NOT NULL,
  `Amount` DECIMAL(12,2) NOT NULL,
  `Description` NVARCHAR(300) NOT NULL,
  `PaymentAttemptsId` BIGINT NOT NULL,
  `TransTypeId` INT NOT NULL,
  `SubTypeId` INT NOT NULL,
  `EntityTypeId` BIGINT NOT NULL,
  PRIMARY KEY (`TransactionId`),
  INDEX `fk_Transactions_PaymentsAttempts1_idx` (`PaymentAttemptsId` ASC) VISIBLE,
  INDEX `fk_Transactions_TransTypes1_idx` (`TransTypeId` ASC) VISIBLE,
  INDEX `fk_Transactions_SubTypes1_idx` (`SubTypeId` ASC) VISIBLE,
  INDEX `fk_Transactions_EntityTypes1_idx` (`EntityTypeId` ASC) VISIBLE,
  CONSTRAINT `fk_Transactions_PaymentsAttempts1`
    FOREIGN KEY (`PaymentAttemptsId`)
    REFERENCES `mydb`.`PaymentsAttempts` (`PaymentAttemptsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transactions_TransTypes1`
    FOREIGN KEY (`TransTypeId`)
    REFERENCES `mydb`.`TransTypes` (`TransTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transactions_SubTypes1`
    FOREIGN KEY (`SubTypeId`)
    REFERENCES `mydb`.`SubTypes` (`SubTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transactions_EntityTypes1`
    FOREIGN KEY (`EntityTypeId`)
    REFERENCES `mydb`.`EntityTypes` (`EntityTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PurchasedPatternsPerUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PurchasedPatternsPerUser` (
  `UserId` BIGINT NOT NULL,
  `PatternId` BIGINT NOT NULL,
  `TransactionId` BIGINT NOT NULL,
  INDEX `fk_PatternsXUser_Users1_idx` (`UserId` ASC) VISIBLE,
  INDEX `fk_PatternsXUser_Patterns1_idx` (`PatternId` ASC) VISIBLE,
  INDEX `fk_PurchasedPatternsPerUser_Transactions1_idx` (`TransactionId` ASC) VISIBLE,
  CONSTRAINT `fk_PatternsXUser_Users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `mydb`.`Users` (`UserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PatternsXUser_Patterns1`
    FOREIGN KEY (`PatternId`)
    REFERENCES `mydb`.`Patterns` (`PatternId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PurchasedPatternsPerUser_Transactions1`
    FOREIGN KEY (`TransactionId`)
    REFERENCES `mydb`.`Transactions` (`TransactionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`RecurrencesTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`RecurrencesTypes` (
  `RecurrenceTypeId` BIGINT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  `ValueToAdd` INT NOT NULL,
  `DatePart` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`RecurrenceTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Plans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Plans` (
  `PlanId` BIGINT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(50) NOT NULL,
  `Amount` DECIMAL NOT NULL,
  `Description` NVARCHAR(300) NOT NULL,
  `StartTime` DATETIME NOT NULL,
  `EndTime` DATETIME NOT NULL,
  `Enabled` BIT NOT NULL,
  `IconUrl` VARCHAR(128) NOT NULL,
  `RecurrenceTypeId` BIGINT NOT NULL,
  PRIMARY KEY (`PlanId`),
  INDEX `fk_Plans_RecurrencesTypes1_idx` (`RecurrenceTypeId` ASC) VISIBLE,
  CONSTRAINT `fk_Plans_RecurrencesTypes1`
    FOREIGN KEY (`RecurrenceTypeId`)
    REFERENCES `mydb`.`RecurrencesTypes` (`RecurrenceTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Benefits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Benefits` (
  `BenefitId` BIGINT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(50) NOT NULL,
  `Description` NVARCHAR(100) NOT NULL,
  `Checksum` VARBINARY(300) NOT NULL,
  PRIMARY KEY (`BenefitId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`BenefitsPerPlan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`BenefitsPerPlan` (
  `Deleted` BIT NOT NULL,
  `PlanId` BIGINT NOT NULL,
  `BenefitId` BIGINT NOT NULL,
  INDEX `fk_BenefitsPerPlan_Plans1_idx` (`PlanId` ASC) VISIBLE,
  INDEX `fk_BenefitsPerPlan_Benefits1_idx` (`BenefitId` ASC) VISIBLE,
  CONSTRAINT `fk_BenefitsPerPlan_Plans1`
    FOREIGN KEY (`PlanId`)
    REFERENCES `mydb`.`Plans` (`PlanId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BenefitsPerPlan_Benefits1`
    FOREIGN KEY (`BenefitId`)
    REFERENCES `mydb`.`Benefits` (`BenefitId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PlansPerUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PlansPerUser` (
  `PostTime` DATE NOT NULL,
  `NextTime` DATE NOT NULL,
  `UserId` BIGINT NOT NULL,
  `PlanId` BIGINT NOT NULL,
  PRIMARY KEY (`PostTime`),
  INDEX `fk_PlansPerUser_Users1_idx` (`UserId` ASC) VISIBLE,
  INDEX `fk_PlansPerUser_Plans1_idx` (`PlanId` ASC) VISIBLE,
  CONSTRAINT `fk_PlansPerUser_Users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `mydb`.`Users` (`UserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PlansPerUser_Plans1`
    FOREIGN KEY (`PlanId`)
    REFERENCES `mydb`.`Plans` (`PlanId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Severities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Severities` (
  `SeverityId` BIGINT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`SeverityId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AppSources`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AppSources` (
  `AppSourceId` BIGINT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AppSourceId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`LogTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LogTypes` (
  `LogTypeId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`LogTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Logs` (
  `LogId` BIGINT NOT NULL AUTO_INCREMENT,
  `PostTime` DATETIME NOT NULL,
  `Description` NVARCHAR(300) NOT NULL,
  `ComputerName` VARCHAR(20) NOT NULL,
  `Username` NVARCHAR(50) NOT NULL,
  `IPAddress` VARCHAR(45) NOT NULL,
  `RefId1` BIGINT NULL,
  `RefId2` BIGINT NULL,
  `OldValue` NVARCHAR(200) NULL,
  `NewValue` NVARCHAR(200) NULL,
  `Checksum` VARBINARY(300) NOT NULL,
  `SeverityId` BIGINT NOT NULL,
  `EntityTypeId` BIGINT NOT NULL,
  `AppSourceId` BIGINT NOT NULL,
  `LogTypeId` INT NOT NULL,
  `UserId` BIGINT NOT NULL,
  PRIMARY KEY (`LogId`),
  INDEX `fk_Logs_Severities1_idx` (`SeverityId` ASC) VISIBLE,
  INDEX `fk_Logs_EntitiesTypes1_idx` (`EntityTypeId` ASC) VISIBLE,
  INDEX `fk_Logs_AppSources1_idx` (`AppSourceId` ASC) VISIBLE,
  INDEX `fk_Logs_LogTypes1_idx` (`LogTypeId` ASC) VISIBLE,
  INDEX `fk_Logs_Users1_idx` (`UserId` ASC) VISIBLE,
  CONSTRAINT `fk_Logs_Severities1`
    FOREIGN KEY (`SeverityId`)
    REFERENCES `mydb`.`Severities` (`SeverityId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Logs_EntitiesTypes1`
    FOREIGN KEY (`EntityTypeId`)
    REFERENCES `mydb`.`EntityTypes` (`EntityTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Logs_AppSources1`
    FOREIGN KEY (`AppSourceId`)
    REFERENCES `mydb`.`AppSources` (`AppSourceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Logs_LogTypes1`
    FOREIGN KEY (`LogTypeId`)
    REFERENCES `mydb`.`LogTypes` (`LogTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Logs_Users1`
    FOREIGN KEY (`UserId`)
    REFERENCES `mydb`.`Users` (`UserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Limits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Limits` (
  `LimitId` INT NOT NULL,
  `Name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`LimitId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`LimitsPerBenefit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LimitsPerBenefit` (
  `Quantity` INT NOT NULL,
  `LimitId` INT NOT NULL,
  `BenefitId` BIGINT NOT NULL,
  INDEX `fk_LimitsPerBenefit_Limits1_idx` (`LimitId` ASC) VISIBLE,
  INDEX `fk_LimitsPerBenefit_Benefits1_idx` (`BenefitId` ASC) VISIBLE,
  CONSTRAINT `fk_LimitsPerBenefit_Limits1`
    FOREIGN KEY (`LimitId`)
    REFERENCES `mydb`.`Limits` (`LimitId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LimitsPerBenefit_Benefits1`
    FOREIGN KEY (`BenefitId`)
    REFERENCES `mydb`.`Benefits` (`BenefitId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MaterialsPerPattern`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MaterialsPerPattern` (
  `MaterialId` INT NOT NULL,
  `PatternId` BIGINT NOT NULL,
  INDEX `fk_MaterialsPerPattern_Materials1_idx` (`MaterialId` ASC) VISIBLE,
  INDEX `fk_MaterialsPerPattern_Patterns1_idx` (`PatternId` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialsPerPattern_Materials1`
    FOREIGN KEY (`MaterialId`)
    REFERENCES `mydb`.`Materials` (`MaterialId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MaterialsPerPattern_Patterns1`
    FOREIGN KEY (`PatternId`)
    REFERENCES `mydb`.`Patterns` (`PatternId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MediaTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MediaTypes` (
  `MediaTypeId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MediaTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Steps`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Steps` (
  `StepId` INT NOT NULL AUTO_INCREMENT,
  `Instruction` NVARCHAR(1000) NOT NULL,
  `PatternId` BIGINT NOT NULL,
  PRIMARY KEY (`StepId`),
  INDEX `fk_Steps_Patterns1_idx` (`PatternId` ASC) VISIBLE,
  CONSTRAINT `fk_Steps_Patterns1`
    FOREIGN KEY (`PatternId`)
    REFERENCES `mydb`.`Patterns` (`PatternId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Medias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Medias` (
  `MediaId` INT NOT NULL AUTO_INCREMENT,
  `URL` VARCHAR(128) NOT NULL,
  `MediaTypeId` INT NOT NULL,
  `StepId` INT NOT NULL,
  PRIMARY KEY (`MediaId`),
  INDEX `fk_Medias_MediaTypes1_idx` (`MediaTypeId` ASC) VISIBLE,
  INDEX `fk_Medias_Steps1_idx` (`StepId` ASC) VISIBLE,
  CONSTRAINT `fk_Medias_MediaTypes1`
    FOREIGN KEY (`MediaTypeId`)
    REFERENCES `mydb`.`MediaTypes` (`MediaTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Medias_Steps1`
    FOREIGN KEY (`StepId`)
    REFERENCES `mydb`.`Steps` (`StepId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Categories` (
  `CategoryId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CategoryId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DataTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DataTypes` (
  `DataTypesId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`DataTypesId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Features`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Features` (
  `FeaturesId` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `DataTypesId` INT NOT NULL,
  PRIMARY KEY (`FeaturesId`),
  INDEX `fk_Features_DataTypes1_idx` (`DataTypesId` ASC) VISIBLE,
  CONSTRAINT `fk_Features_DataTypes1`
    FOREIGN KEY (`DataTypesId`)
    REFERENCES `mydb`.`DataTypes` (`DataTypesId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FeaturesPerCategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FeaturesPerCategories` (
  `Value` VARCHAR(50) NOT NULL,
  `Deleted` BIT NOT NULL,
  `FeaturesId` INT NOT NULL,
  `CategoryId` INT NOT NULL,
  INDEX `fk_FeaturesPerCategories_Features1_idx` (`FeaturesId` ASC) VISIBLE,
  INDEX `fk_FeaturesPerCategories_Categories1_idx` (`CategoryId` ASC) VISIBLE,
  CONSTRAINT `fk_FeaturesPerCategories_Features1`
    FOREIGN KEY (`FeaturesId`)
    REFERENCES `mydb`.`Features` (`FeaturesId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FeaturesPerCategories_Categories1`
    FOREIGN KEY (`CategoryId`)
    REFERENCES `mydb`.`Categories` (`CategoryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CategoriesPerMaterials`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CategoriesPerMaterials` (
  `CategoryId` INT NOT NULL,
  `MaterialId` INT NOT NULL,
  INDEX `fk_CategoriesPerMaterials_Categories1_idx` (`CategoryId` ASC) VISIBLE,
  INDEX `fk_CategoriesPerMaterials_Materials1_idx` (`MaterialId` ASC) VISIBLE,
  CONSTRAINT `fk_CategoriesPerMaterials_Categories1`
    FOREIGN KEY (`CategoryId`)
    REFERENCES `mydb`.`Categories` (`CategoryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CategoriesPerMaterials_Materials1`
    FOREIGN KEY (`MaterialId`)
    REFERENCES `mydb`.`Materials` (`MaterialId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FeaturesPerMaterial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FeaturesPerMaterial` (
  `Value` VARCHAR(45) NOT NULL,
  `Deleted` BIT NOT NULL,
  `FeaturesId` INT NOT NULL,
  `MaterialId` INT NOT NULL,
  INDEX `fk_FeaturesPerMaterial_Materials1_idx` (`MaterialId` ASC) VISIBLE,
  INDEX `fk_FeaturesPerMaterial_Features1_idx` (`FeaturesId` ASC) VISIBLE,
  CONSTRAINT `fk_FeaturesPerMaterial_Materials1`
    FOREIGN KEY (`MaterialId`)
    REFERENCES `mydb`.`Materials` (`MaterialId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FeaturesPerMaterial_Features1`
    FOREIGN KEY (`FeaturesId`)
    REFERENCES `mydb`.`Features` (`FeaturesId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MeasureUnits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MeasureUnits` (
  `MeasureUnitId` INT NOT NULL,
  `Name` VARCHAR(15) NOT NULL,
  `Abbreviation` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`MeasureUnitId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MaterialsPerProject`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MaterialsPerProject` (
  `AmountSpent` DECIMAL(5,2) NULL,
  `PurchasePrice` DECIMAL(7,2) NULL,
  `MaterialId` INT NOT NULL,
  `ProjectId` BIGINT NOT NULL,
  `MeasureUnitId` INT NOT NULL,
  INDEX `fk_table1_Projects1_idx` (`ProjectId` ASC) VISIBLE,
  INDEX `fk_table1_Materials1_idx` (`MaterialId` ASC) VISIBLE,
  INDEX `fk_MaterialsPerProject_MeasureUnits1_idx` (`MeasureUnitId` ASC) VISIBLE,
  CONSTRAINT `fk_table1_Projects1`
    FOREIGN KEY (`ProjectId`)
    REFERENCES `mydb`.`Projects` (`ProjectId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_table1_Materials1`
    FOREIGN KEY (`MaterialId`)
    REFERENCES `mydb`.`Materials` (`MaterialId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MaterialsPerProject_MeasureUnits1`
    FOREIGN KEY (`MeasureUnitId`)
    REFERENCES `mydb`.`MeasureUnits` (`MeasureUnitId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Fees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Fees` (
  `FeeId` INT NOT NULL,
  `FeeName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FeeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FeesPerPlan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FeesPerPlan` (
  `PlanId` BIGINT NOT NULL,
  `FeeId` INT NOT NULL,
  INDEX `fk_FeesPerPlan_Plans1_idx` (`PlanId` ASC) VISIBLE,
  INDEX `fk_FeesPerPlan_Fees1_idx` (`FeeId` ASC) VISIBLE,
  CONSTRAINT `fk_FeesPerPlan_Plans1`
    FOREIGN KEY (`PlanId`)
    REFERENCES `mydb`.`Plans` (`PlanId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FeesPerPlan_Fees1`
    FOREIGN KEY (`FeeId`)
    REFERENCES `mydb`.`Fees` (`FeeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FeesValues`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FeesValues` (
  `FeeValueId` INT NOT NULL,
  `StartDate` DATETIME NOT NULL,
  `EndDate` DATETIME NULL,
  `Active` BIT NOT NULL,
  `Percentage` DECIMAL(5,2) NOT NULL,
  `FeeId` INT NOT NULL,
  PRIMARY KEY (`FeeValueId`),
  INDEX `fk_FeesValues_Fees1_idx` (`FeeId` ASC) VISIBLE,
  CONSTRAINT `fk_FeesValues_Fees1`
    FOREIGN KEY (`FeeId`)
    REFERENCES `mydb`.`Fees` (`FeeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FeesPerPattern`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FeesPerPattern` (
  `FeeId` INT NOT NULL,
  `PatternId` BIGINT NOT NULL,
  INDEX `fk_FeesPerPattern_Fees1_idx` (`FeeId` ASC) VISIBLE,
  INDEX `fk_FeesPerPattern_Patterns1_idx` (`PatternId` ASC) VISIBLE,
  CONSTRAINT `fk_FeesPerPattern_Fees1`
    FOREIGN KEY (`FeeId`)
    REFERENCES `mydb`.`Fees` (`FeeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FeesPerPattern_Patterns1`
    FOREIGN KEY (`PatternId`)
    REFERENCES `mydb`.`Patterns` (`PatternId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PriceValues`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PriceValues` (
  `PriceValueId` INT NOT NULL,
  `StartDate` DATETIME NOT NULL,
  `EndDate` DATETIME NULL,
  `Active` BIT NOT NULL,
  `Price` DECIMAL(7,2) NOT NULL,
  PRIMARY KEY (`PriceValueId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PatternsOnSale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PatternsOnSale` (
  `Date` DATETIME NOT NULL,
  `OnSale` BIT NOT NULL,
  `PatternId` BIGINT NOT NULL,
  `PriceValueId` INT NOT NULL,
  INDEX `fk_PatternsOnSale_Patterns1_idx` (`PatternId` ASC) VISIBLE,
  INDEX `fk_PatternsOnSale_PriceValues1_idx` (`PriceValueId` ASC) VISIBLE,
  CONSTRAINT `fk_PatternsOnSale_Patterns1`
    FOREIGN KEY (`PatternId`)
    REFERENCES `mydb`.`Patterns` (`PatternId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PatternsOnSale_PriceValues1`
    FOREIGN KEY (`PriceValueId`)
    REFERENCES `mydb`.`PriceValues` (`PriceValueId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;