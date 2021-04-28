-- Script de rellenado de catalogos.

-- ---------------------------------------------------------------------------------------------
-- TRANSACTIONS TABLES

-- TRANSTYPES:
INSERT INTO `KnitHub`.`TransTypes`
(`TransTypeId`,
`Name`)
VALUES
(1,
'Credito');

INSERT INTO `KnitHub`.`TransTypes`
(`TransTypeId`,
`Name`)
VALUES
(2,
'Debito');

INSERT INTO `KnitHub`.`TransTypes`
(`TransTypeId`,
`Name`)
VALUES
(3,
'Cancelado');


-- SUBTYPES:
INSERT INTO `KnitHub`.`SubTypes`
(`SubTypeId`,
`Name`)
VALUES
(1,
'Patron');

INSERT INTO `KnitHub`.`SubTypes`
(`SubTypeId`,
`Name`)
VALUES
(2,
'Plan');

-- PAYMENTSTATUS:
INSERT INTO `KnitHub`.`PaymentStatus`
(`PaymentStatusId`,
`Name`)
VALUES
(3,
'Aceptado');

INSERT INTO `KnitHub`.`PaymentStatus`
(`PaymentStatusId`,
`Name`)
VALUES
(2,
'Rechazado');

INSERT INTO `KnitHub`.`PaymentStatus`
(`PaymentStatusId`,
`Name`)
VALUES
(3,
'Invalido');

INSERT INTO `KnitHub`.`PaymentStatus`
(`PaymentStatusId`,
`Name`)
VALUES
(4,
'Error de comunicacion');

-- MERCHANTS:
INSERT INTO `KnitHub`.`Merchants`
(`MerchantId`,
`Name`,
`Url`,
`Enabled`,
`IconUrl`)
VALUES
(1,
'Paypal',
'https://www.paypal.com/cr/home',
1,
'https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_37x23.jpg');

INSERT INTO `KnitHub`.`Merchants`
(`MerchantId`,
`Name`,
`Url`,
`Enabled`,
`IconUrl`)
VALUES
(2,
'BAC',
'https://www.baccredomatic.com/',
1,
'https://www.baccredomatic.com/themes/custom/bac_theme/images/logo.png');

INSERT INTO `KnitHub`.`Merchants`
(`MerchantId`,
`Name`,
`Url`,
`Enabled`,
`IconUrl`)
VALUES
(3,
'BCR',
'https://www.bancobcr.com/wps/portal/bcr',
1,
'https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/122010/logo_bcr_0.png?itok=PoA3d9gr');






