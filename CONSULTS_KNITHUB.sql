-- Una consulta que retorne un listado de los montos y personas, categorízados por año y mes de
-- aquellos dineros que no se han podido cobrar, en el query debe poder verse las categorías, nombres
-- y montos debidamente agrupados.

SELECT 
(SELECT CONCAT(Users.Name, ' ', Users.LastName) FROM Users) AS UserName,
SUM(PaymentAttempts.Amount) AS NotPayedAmounts,
MONTH(PaymentAttempts.PostTime) AS 'Month',
MONTHNAME(PaymentAttempts.PostTime) AS 'MonthName',
YEAR(PaymentAttempts.PostTime) AS 'Year'
FROM PaymentAttempts
INNER JOIN Users ON PaymentAttempts.UserId=Users.UserId
WHERE PaymentAttempts.PaymentStatusId!=(SELECT PaymentStatus.PaymentStatusId FROM PaymentStatus WHERE PaymentStatus.Name="Aceptado")
AND PaymentAttempts.ReferenceNumber 
NOT IN(SELECT Transactions.ReferenceNumber FROM Transactions)
GROUP BY PostTime, Username 
ORDER BY 'Month' ASC, 'Year' DESC; 

-- Una consulta que retorne el volumen de operaciones de uso del sistema por mes en un rango de
-- fechas, clasificado entre bajo volumen, volumen medio y volumen alto

-- SET @MAXDATE= #Fechas definidas
-- SET @MINDATE= #Fechas definidas

SELECT 
'Projects' AS 'VolumeType', 
MONTH(Projects.creationDate) AS 'Month',
MONTHNAME(Projects.creationDate) AS 'MonthName',
COUNT(Projects.ProjectId) AS 'IndividualMonthVolume', 
COUNT(Patterns.PatternId + Projects.ProjectId)  AS 'SumMonthVolume',
CASE
    WHEN 'SumMonthVolume' < 350  THEN 'Volumen bajo'
    WHEN 500 < 'SumMonthVolume' < 1000  THEN 'Volumen medio'
    WHEN 'SumMonthVolume' > 500  THEN 'Volumen alto'
END AS 'VolumeClassification'
FROM Projects, Patterns
WHERE @MINDATE < Projects.creationDate > @MAXDATE
AND MONTH(Projects.creationDate)=MONTH(Patterns.creationDate) 
GROUP BY 'VolumeType','Month','VolumeClassification','IndividualVolume', Projects.creationDate
UNION
SELECT
'Patterns' AS 'VolumeType',
MONTH(Patterns.creationDate) AS 'Month',
MONTHNAME(Patterns.creationDate) AS 'MonthName',
COUNT(Patterns.PatternId) AS 'IndividualMonthVolume',
COUNT(Patterns.PatternId + Projects.ProjectId) AS 'SumMonthVolume',
CASE
    WHEN 'SumMonthVolume' < 350  THEN 'Volumen bajo'
    WHEN 500 < 'SumMonthVolume' < 1000  THEN 'Volumen medio'
    WHEN 'SumMonthVolume' > 500  THEN 'Volumen alto'
END AS 'SumVolumeClassification'
FROM Patterns, Projects
WHERE @MINDATE < Patterns.creationDate > @MAXDATE
AND MONTH(Projects.creationDate)=MONTH(Patterns.creationDate) 
GROUP BY 'VolumeType','Month','IndividualVolume', Patterns.creationDate;


