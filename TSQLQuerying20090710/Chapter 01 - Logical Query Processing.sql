---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Querying (MSPress, 2009)
-- Chapter 01 - Logical Query Processing
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Sample Query based on Customers/Orders Scenario
---------------------------------------------------------------------

-- Data Definition Language (DDL) and sample data for Customers and Orders
SET NOCOUNT ON;
USE tempdb;

IF OBJECT_ID('dbo.Orders') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Customers') IS NOT NULL DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers
(
  customerid  CHAR(5)     NOT NULL PRIMARY KEY,
  city        VARCHAR(10) NOT NULL
);

CREATE TABLE dbo.Orders
(
  orderid    INT     NOT NULL PRIMARY KEY,
  customerid CHAR(5)     NULL REFERENCES Customers(customerid)
);
GO

INSERT INTO dbo.Customers(customerid, city) VALUES('FISSA', 'Madrid');
INSERT INTO dbo.Customers(customerid, city) VALUES('FRNDO', 'Madrid');
INSERT INTO dbo.Customers(customerid, city) VALUES('KRLOS', 'Madrid');
INSERT INTO dbo.Customers(customerid, city) VALUES('MRPHS', 'Zion');

INSERT INTO dbo.Orders(orderid, customerid) VALUES(1, 'FRNDO');
INSERT INTO dbo.Orders(orderid, customerid) VALUES(2, 'FRNDO');
INSERT INTO dbo.Orders(orderid, customerid) VALUES(3, 'KRLOS');
INSERT INTO dbo.Orders(orderid, customerid) VALUES(4, 'KRLOS');
INSERT INTO dbo.Orders(orderid, customerid) VALUES(5, 'KRLOS');
INSERT INTO dbo.Orders(orderid, customerid) VALUES(6, 'MRPHS');
INSERT INTO dbo.Orders(orderid, customerid) VALUES(7, NULL);

SELECT * FROM dbo.Customers;
SELECT * FROM dbo.Orders;

-- Listing 1-2: Query: Madrid customers with Fewer than three orders

-- The query returns customers from Madrid who placed fewer than
-- three orders (including zero), and their order count.
-- The result is sorted by the order count.
SELECT C.customerid, COUNT(O.orderid) AS numorders
FROM dbo.Customers AS C
  LEFT OUTER JOIN dbo.Orders AS O
    ON C.customerid = O.customerid
WHERE C.city = 'Madrid'
GROUP BY C.customerid
HAVING COUNT(O.orderid) < 3
ORDER BY numorders;

---------------------------------------------------------------------
-- Logical Query Processing Phase Details
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Step 6 – The Presentation ORDER BY Phase
---------------------------------------------------------------------

-- Sorting by Ordinal Positions
SELECT orderid, customerid FROM dbo.Orders ORDER BY 2, 1;
GO

-- ORDER BY in Derived Table is not Allowed
SELECT *
FROM (SELECT orderid, customerid
      FROM dbo.Orders
      ORDER BY orderid DESC) AS D;
GO

-- ORDER BY in View is not Allowed
IF OBJECT_ID('dbo.VSortedOrders', 'V') IS NOT NULL
  DROP VIEW dbo.VSortedOrders;
GO
CREATE VIEW dbo.VSortedOrders
AS

SELECT orderid, customerid
FROM dbo.Orders
ORDER BY orderid DESC;
GO

-- Outer query with TOP and ORDER BY
SELECT TOP (3) orderid, customerid
FROM dbo.Orders
ORDER BY orderid DESC;

-- Table expression with TOP and ORDER BY
SELECT *
FROM (SELECT TOP (3) orderid, customerid
      FROM dbo.Orders
      ORDER BY orderid DESC) AS D;

-- Attempt to create a sorted view
IF OBJECT_ID('dbo.VSortedOrders', 'V') IS NOT NULL
  DROP VIEW dbo.VSortedOrders;
GO

-- Note: This does not create a “sorted view”!
CREATE VIEW dbo.VSortedOrders
AS

SELECT TOP (100) PERCENT orderid, customerid
FROM dbo.Orders
ORDER BY orderid DESC;
GO

-- Query view
SELECT orderid, customerid FROM dbo.VSortedOrders;

---------------------------------------------------------------------
-- Further Aspects of Logical Query Processing
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Table Operators
---------------------------------------------------------------------

---------------------------------------------------------------------
-- APPLY
---------------------------------------------------------------------

-- Two most recent orders for each customer
SELECT C.customerid, C.city, A.orderid 
FROM dbo.Customers AS C 
  CROSS APPLY 
    (SELECT TOP (2) O.orderid, O.customerid 
     FROM dbo.Orders AS O 
     WHERE O.customerid = C.customerid 
     ORDER BY orderid DESC) AS A;

-- Two most recent orders for each customer,
-- including customers that made no orders
SELECT C.customerid, C.city, A.orderid
FROM dbo.Customers AS C
  OUTER APPLY
    (SELECT TOP (2) O.orderid, O.customerid
     FROM dbo.Orders AS O
     WHERE O.customerid = C.customerid
     ORDER BY orderid DESC) AS A;

---------------------------------------------------------------------
-- PIVOT
---------------------------------------------------------------------

-- Order Values for each Employee and Year
USE InsideTSQL2008;

SELECT *
FROM (SELECT empid, YEAR(orderdate) AS orderyear, val
      FROM Sales.OrderValues) AS OV
  PIVOT(SUM(val) FOR orderyear IN([2006],[2007],[2008])) AS P;

-- Logical Equivalent to the PIVOT Query
SELECT empid, 
  SUM(CASE WHEN orderyear = 2006 THEN val END) AS [2006],
  SUM(CASE WHEN orderyear = 2007 THEN val END) AS [2007],
  SUM(CASE WHEN orderyear = 2008 THEN val END) AS [2008]
FROM (SELECT empid, YEAR(orderdate) AS orderyear, val
      FROM Sales.OrderValues) AS OV
GROUP BY empid;

---------------------------------------------------------------------
-- UNPIVOT
---------------------------------------------------------------------

IF OBJECT_ID('dbo.EmpYearValues') IS NOT NULL
  DROP TABLE dbo.EmpYearValues;
GO

-- Creating and Populating the EmpYearValues Table
SELECT *
INTO dbo.EmpYearValues
FROM (SELECT empid, YEAR(orderdate) AS orderyear, val
      FROM Sales.OrderValues) AS OV
  PIVOT(SUM(val) FOR orderyear IN([2006],[2007],[2008])) AS P;

UPDATE dbo.EmpYearValues
  SET [2006] = NULL
WHERE empid IN(1, 2);

SELECT * FROM dbo.EmpYearValues;

-- Unpivoted Employee and Year Values
SELECT empid, orderyear, val
FROM dbo.EmpYearValues
  UNPIVOT(val FOR orderyear IN([2006],[2007],[2008])) AS U;

-- Cleanup
IF OBJECT_ID('dbo.EmpYearValues') IS NOT NULL
  DROP TABLE dbo.EmpYearValues;

---------------------------------------------------------------------
-- OVER Clause
---------------------------------------------------------------------

-- OVER Clause applied in SELECT Phase
USE InsideTSQL2008;

SELECT orderid, custid,
  COUNT(*) OVER(PARTITION BY custid) AS numorders
FROM Sales.Orders
WHERE shipcountry = N'Spain';

-- OVER Clause applied in ORDER BY Phase
SELECT orderid, custid,
  COUNT(*) OVER(PARTITION BY custid) AS numorders
FROM Sales.Orders
WHERE shipcountry = N'Spain'
ORDER BY COUNT(*) OVER(PARTITION BY custid) DESC;

---------------------------------------------------------------------
-- Set Operations
---------------------------------------------------------------------

-- UNION ALL Set Operation
USE InsideTSQL2008;

SELECT region, city
FROM Sales.Customers
WHERE country = N'USA'

INTERSECT

SELECT region, city
FROM HR.Employees
WHERE country = N'USA'

ORDER BY region, city;

-- Customers that placed no Orders
SELECT custid FROM Sales.Customers
EXCEPT
SELECT custid FROM Sales.Orders;
