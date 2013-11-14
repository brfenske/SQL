---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Querying (MSPress, 2009)
-- Chapter 02 - Set Theory and Predicate Logic
-- Copyright Steve Kass, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Set Theory
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Faithfulness
---------------------------------------------------------------------

---------------------------------------------------------------------
-- No REAL Faithfulness
---------------------------------------------------------------------

DECLARE @a REAL = 0.001;
DECLARE @b REAL = 9876543;
DECLARE @c REAL = 1234567;

SELECT
  @a * (@b * @c) as [a(bc)],
  (@a * @b) * @c as [(ab)c]
GO

---------------------------------------------------------------------
-- Order
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Alphabetical Order
---------------------------------------------------------------------

DECLARE @Names TABLE (
  name VARCHAR(20)
);

INSERT INTO @Names VALUES
  ('DeSzmetch'),('DESZMETCH'),('DESZMETCK'),('DesZmetch'),('deszmetch');

SELECT
  name,
  RANK() OVER (ORDER BY name COLLATE Latin1_General_BIN) AS [Lat...BIN],
  RANK() OVER (ORDER BY name COLLATE Traditional_Spanish_CI_AS) AS [Tra...CI_AS],
  RANK() OVER (ORDER BY name COLLATE Latin1_General_CS_AS) AS [Lat...CS_AS],
  RANK() OVER (ORDER BY name COLLATE Latin1_General_CI_AS) AS [Lat...CI_AS],
  RANK() OVER (ORDER BY name COLLATE Hungarian_CI_AS) AS [Hun..._CI_AS]
FROM @Names
ORDER BY name COLLATE Latin1_General_BIN;
GO

---------------------------------------------------------------------
-- Relations
---------------------------------------------------------------------

---------------------------------------------------------------------
-- The Reflexive, Symmetric, and Transitive Properties
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Not All < Operators Were Created Equal
---------------------------------------------------------------------

DECLARE @x VARCHAR(10);
DECLARE @y INT;
DECLARE @z VARCHAR(10);

SET @x =  '1000';
SET @y =  '2000';
SET @z = '+3000';

SELECT
  CASE WHEN @x < @y THEN 'TRUE' ELSE 'FALSE' END AS [x<y?],
  CASE WHEN @y < @z THEN 'TRUE' ELSE 'FALSE' END AS [y<z?], 
  CASE WHEN @x < @z THEN 'TRUE' ELSE 'FALSE' END AS [x<z?]
GO


DECLARE @x VARCHAR(10);
DECLARE @y INT;
DECLARE @z VARCHAR(10);

SET @x =  '1000';
SET @y =  '2000';
SET @z = '+3000';

SELECT
  CASE WHEN @x < @y THEN 'TRUE' ELSE 'FALSE' END AS [CAST(x)<y?],
  CASE WHEN @y < @z THEN 'TRUE' ELSE 'FALSE' END AS [y<CAST(z)?], 
  CASE WHEN @x < @z THEN 'TRUE' ELSE 'FALSE' END AS [x<z?],
  CASE WHEN CAST(@x AS INT) < CAST(@z AS INT)
       THEN 'TRUE' ELSE 'FALSE' END AS [CAST(x)<CAST(z)?]
GO

---------------------------------------------------------------------
-- A Practical Application
---------------------------------------------------------------------

USE InsideTSQL2008;
GO

DECLARE @empid AS INT = 1;

SELECT
  custid,
  CASE WHEN custid IN (
      SELECT custid
      FROM Sales.Orders AS O
      WHERE O.empid = @empid
    ) THEN 1 ELSE 0 END AS charfun
FROM Sales.Customers AS C
GO

WITH TheseEmployees AS (
  SELECT empid
  FROM HR.Employees
  WHERE country = 'USA'
), CustomerCharacteristicFunctions AS (
  SELECT
    custid, 
    CASE WHEN custid IN (
        SELECT custid
        FROM Sales.Orders AS O
        WHERE O.empid = E.empid
      ) THEN 1 ELSE 0 END AS charfun
  FROM Sales.Customers AS C
  CROSS JOIN TheseEmployees AS E
) 
  SELECT
    custid, MIN(charfun) as mincharfun
  FROM CustomerCharacteristicFunctions
  GROUP BY custid
  ORDER BY custid;
GO


-- Listing 2-4 Query to find customers who were served by every USA employee
CREATE INDEX sk_custid_empid ON Sales.Orders(custid,empid);
GO

WITH TheseEmployees AS (
  SELECT empid
  FROM HR.Employees
  WHERE country = 'USA'
), CharacteristicFunctions AS (
  SELECT
    custid, 
    CASE WHEN custid IN (
        SELECT custid
        FROM Sales.Orders AS O
        WHERE O.empid = E.empid
      ) THEN 1 ELSE 0 END AS charfun
  FROM Sales.Customers AS C
  CROSS JOIN TheseEmployees AS E
) 
  SELECT
    custid 
  FROM CharacteristicFunctions
  GROUP BY custid
  HAVING MIN(charfun) = 1
  ORDER BY custid;
GO

DROP INDEX Sales.Orders.sk_custid_empid;
