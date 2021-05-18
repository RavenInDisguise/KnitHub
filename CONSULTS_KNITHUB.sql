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

SELECT y, m, Count(Projects.ProjectId) Conteo
FROM (
  SELECT y, m
  FROM 
    (SELECT YEAR(CURDATE()) y UNION ALL SELECT YEAR(CURDATE())-1) years ,
    (SELECT 1 m UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
      UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12) AS months) ym
	LEFT JOIN Projects
	  ON ym.y = YEAR(Projects.creationDate)
     AND ym.m = MONTH(Projects.creationDate)
     
WHERE
  (y=YEAR(CURDATE()) AND m<=MONTH(CURDATE()))
  OR
  (y<YEAR(CURDATE()) AND m>MONTH(CURDATE()))
GROUP BY y, m;

select month(m) 'Mes', count(*) 'Proyectos y Patrones Por Mes'
from (select Patterns.creationDate as m from Patterns union all
      select Projects.creationDate as m from Projects) v
group by month(m)