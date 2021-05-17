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




