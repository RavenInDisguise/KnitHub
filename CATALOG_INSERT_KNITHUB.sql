-- Script de rellenado de catalogos.

-- ---------------------------------------------------------------------------------------------
-- TRANSACTIONS TABLES

-- TRANSTYPES:
INSERT INTO `KnitHub`.`TransTypes`
(`TransTypeId`,
`Name`)
VALUES
(1,'Credito');

INSERT INTO `KnitHub`.`TransTypes`
(`TransTypeId`,
`Name`)
VALUES
(2,'Debito');

INSERT INTO `KnitHub`.`TransTypes`
(`TransTypeId`,
`Name`)
VALUES
(3,'Cancelado');


-- SUBTYPES:
INSERT INTO `KnitHub`.`SubTypes`
(`SubTypeId`,
`Name`)
VALUES
(1,'Patron');

INSERT INTO `KnitHub`.`SubTypes`
(`SubTypeId`,
`Name`)
VALUES
(2,'Plan');

-- PAYMENTSTATUS:
INSERT INTO `KnitHub`.`PaymentStatus`
(`PaymentStatusId`,
`Name`)
VALUES
(1,'Aceptado');

INSERT INTO `KnitHub`.`PaymentStatus`
(`PaymentStatusId`,
`Name`)
VALUES
(2,'Rechazado');

INSERT INTO `KnitHub`.`PaymentStatus`
(`PaymentStatusId`,
`Name`)
VALUES
(3,'Invalido');

INSERT INTO `KnitHub`.`PaymentStatus`
(`PaymentStatusId`,
`Name`)
VALUES
(4,'Error de comunicacion');

-- MERCHANTS:
INSERT INTO `KnitHub`.`Merchants`
(`MerchantId`,
`Name`,
`Url`,
`Enabled`,
`IconUrl`)
VALUES
(1,'Paypal','https://www.paypal.com/cr/home',1,'https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_37x23.jpg');

INSERT INTO `KnitHub`.`Merchants`
(`MerchantId`,
`Name`,
`Url`,
`Enabled`,
`IconUrl`)
VALUES
(2,'BAC','https://www.baccredomatic.com/',1,'https://www.baccredomatic.com/themes/custom/bac_theme/images/logo.png');

INSERT INTO `KnitHub`.`Merchants`
(`MerchantId`,
`Name`,
`Url`,
`Enabled`,
`IconUrl`)
VALUES
(3,'BCR','https://www.bancobcr.com/wps/portal/bcr',1,"https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/122010/logo_bcr_0.png?itok=PoA3d9gr");

-- SOCIAL NETWORKS:
INSERT INTO `KnitHub`.`SocialNetworks` (`SocialNetworksId`, `Name`, `URL`, `IconURL`)
VALUES 	
(1, 'Facebook', 'https://www.facebook.com/', 'https://facebookbrand.com/wp-content/uploads/2019/04/f_logo_RGB-Hex-Blue_512.png?w=512&h=512'), 
(2, 'Gmail', 'https://mail.google.com/', 'https://ssl.gstatic.com/ui/v1/icons/mail/rfr/logo_gmail_lockup_default_1x_r2.png');

-- COUNTRIES:
INSERT INTO `KnitHub`.`Countries` (`CountryId`, `Name`)
VALUES 
(1, 'Costa Rica'),
(2, 'Guatemala'),
(3, 'Honduras'),
(4, 'El Salvador'),
(5, 'Nicaragua'),
(6, 'Panamá');

-- CITIES:
INSERT INTO `KnitHub`.`Cities` (`Name`, `CountryId`)
VALUES 
('San José', 1),
('Alajuela', 1),
('Cartago', 1),
('Ciudad de Guatemala', 2),
('Quetzaltenango', 2),
('San Juan Sacatepéquez', 2),
('Tegucigalpa', 3),
('San Pedro Sula', 3),
('La Ceiba', 3),
('San Salvador', 4),
('Cojutepeque', 4),
('Ahuachapán', 4),
('Managua', 5),
('Granada', 5),
('León', 5),
('Ciudad de Panamá', 6),
('Colón', 6),
('David', 6);

-- MEDIA TYPES:
INSERT INTO `KnitHub`.`MediaTypes` (`MediaTypeId`, `Name`)
VALUES
(1, 'Imagen'),
(2, 'Video'),
(3, 'PDF');


-- PATTERN CATEGORIES:
INSERT INTO `KnitHub`.`PatternCategories`
(`PatternCategoryId`,
`Name`)
VALUES
(1,"Sueter"),
(2,"Amigurumi"),
(3,"Pillowcase");


-- ENTITY TYPES:


-- RECURRENCES TYPES:
INSERT INTO `KnitHub`.`RecurrencesTypes`
(`RecurrenceTypeId`,
`Name`,
`ValueToAdd`,
`DatePart`)
VALUES
(1,"Semanal",7,"DD"),
(2,"Mensual",30,"MM"),
(3,"Anual",365,"AA");

-- PLANS:
INSERT INTO `KnitHub`.`Plans`
(`PlanId`,
`Name`,
`Amount`,
`Description`,
`StartTime`,
`EndTime`,
`Enabled`,
`IconUrl`,
`RecurrenceTypeId`)
VALUES
(1,"Plan economico",45,"Plan que permite tener 45 patrones y proyectos",sysdate(),NULL,1,"https://z1gestion.es/wp-content/uploads/2017/02/calendar-2004848_640.jpg",1),
(2,"Plan estandar",90,"Plan que permite tener 90 patrones y proyectos",sysdate(),NULL,1,"https://z1gestion.es/wp-content/uploads/2017/02/calendar-2004848_640.jpg",2),
(3,"Plan premium",200,"Plan que permite tener 200 patrones y proyectos",sysdate(),NULL,1,"https://z1gestion.es/wp-content/uploads/2017/02/calendar-2004848_640.jpg",3),
(4,"Plan business",500,"Plan que permite tener 500 patrones y proyectos",sysdate(),NULL,1,"https://z1gestion.es/wp-content/uploads/2017/02/calendar-2004848_640.jpg",3);

-- MATERIALS:
INSERT INTO `KnitHub`.`Materials`
(`MaterialId`,
`Name`,
`Description`)
VALUES
(1,"Lana","Gruesa unicolor"),
(2,"Lana","Gruesa multicolor"),
(3,"Hilo","Delgado de 2mm, unicolor");

INSERT INTO `KnitHub`.`MeasureUnits`
(`MeasureUnitId`,
`Name`,
`Abbreviation`)
VALUES
(1,"Centimetros","cm"),
(2,"Metros","m"),
(3,"Gramos","g");



