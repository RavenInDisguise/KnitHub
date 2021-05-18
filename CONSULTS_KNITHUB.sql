-- Una consulta que retorne un listado de los montos y personas, categorízados por año y mes de
-- aquellos dineros que no se han podido cobrar, en el query debe poder verse las categorías, nombres
-- y montos debidamente agrupados.
SELECT 
MONTH(PaymentAttempts.PostTime) AS 'Mes',
YEAR(PaymentAttempts.PostTime) AS 'Anno',
GROUP_CONCAT((SELECT CONCAT(Users.Name,' ',Users.LastName) FROM Users WHERE Users.UserId=PaymentAttempts.UserId LIMIT 1)) AS 'Lista de usuarios',
SUM(PaymentAttempts.Amount) AS NotPayedAmounts
FROM PaymentAttempts
INNER JOIN Users ON PaymentAttempts.UserId=Users.UserId
WHERE PaymentAttempts.PaymentStatusId!=(SELECT (PaymentStatus.PaymentStatusId) FROM PaymentStatus WHERE PaymentStatus.Name="Aceptado")
AND PaymentAttempts.ReferenceNumber!=(SELECT(Transactions.ReferenceNumber) FROM Transactions LIMIT 1)
AND PaymentAttempts.UserId=Users.UserId
GROUP BY MONTH(PostTime), YEAR(PostTime)
ORDER BY 'Mes' ASC, 'Anno' DESC; 

-- Una consulta que retorne el volumen de operaciones de uso del sistema por mes en un rango de
-- fechas, clasificado entre bajo volumen, volumen medio y volumen alto

-- Valores seteados por el usuario:
-- SET @MINDATE=
-- SET @MAXDATE=

SELECT MONTH(mes) 'Mes', count(*) 'Volumen proyectos y patrones'
FROM (SELECT Patterns.creationDate AS mes FROM Patterns WHERE (@MINDATE < Patterns.creationDate < @MAXDATE)
UNION ALL
SELECT Projects.creationDate AS mes FROM Projects WHERE (@MINDATE < Projects.creationDate < @MAXDATE)) dates
GROUP BY MONTH(mes);