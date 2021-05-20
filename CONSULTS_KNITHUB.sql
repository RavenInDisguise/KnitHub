-- Una consulta que retorne un listado de los montos y personas, categorízados por año y mes de
-- aquellos dineros que no se han podido cobrar, en el query debe poder verse las categorías, nombres
-- y montos debidamente agrupados.
SELECT 
YEAR(PaymentAttempts.PostTime) AS 'Anno',
MONTH(PaymentAttempts.PostTime) AS 'Mes',
CONCAT(Users.Name,' ',Users.LastName) AS 'Usuario',
SUM(PaymentAttempts.Amount) AS 'Montos no pagados'
FROM PaymentAttempts
INNER JOIN Users ON PaymentAttempts.UserId=Users.UserId
WHERE PaymentAttempts.PaymentStatusId!=(SELECT (PaymentStatus.PaymentStatusId) FROM PaymentStatus WHERE PaymentStatus.Name="Aceptado")
AND PaymentAttempts.ReferenceNumber NOT IN(SELECT Transactions.ReferenceNumber FROM Transactions)
AND PaymentAttempts.UserId=Users.UserId
GROUP BY MONTH(PostTime), YEAR(PostTime), Users.Name, Users.LastName
ORDER BY 'Mes' DESC, 'Anno' DESC; 

-- Una consulta que retorne el volumen de operaciones de uso del sistema por mes en un rango de
-- fechas, clasificado entre bajo volumen, volumen medio y volumen alto

-- Valores seteados por el usuario:
-- SET @MINDATE="2019-06-11";
-- SET @MAXDATE="2022-06-11";

SELECT YEAR(Mes) 'Anno', MONTH(Mes) 'Mes', count(*) 'Volumen proyectos y patrones', 
CASE
    WHEN COUNT(*) <= 30  THEN 'Volumen bajo'
    WHEN 30 < COUNT(*) AND COUNT(*) <= 50  THEN 'Volumen medio'
    WHEN COUNT(*) > 50  THEN 'Volumen alto'
END AS 'Clasificacion de volumen'
FROM (SELECT Patterns.creationDate AS Mes FROM Patterns WHERE (@MINDATE < Patterns.creationDate AND Patterns.creationDate < @MAXDATE)
UNION ALL
SELECT Projects.creationDate AS Mes FROM Projects WHERE (@MINDATE < Projects.creationDate AND Projects.creationDate < @MAXDATE)) Dates
GROUP BY MONTH(Mes), YEAR(Mes)
ORDER BY YEAR(Mes) DESC, MONTH(Mes) ASC;
