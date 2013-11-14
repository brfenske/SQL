---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Querying (MSPress, 2009)
-- Chapter 03 - Relational Model
-- Copyright Dejan Sarka, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Relational Division Problems
---------------------------------------------------------------------


-- Return all customers with orders handled by all employees from the USA
USE InsideTSQL2008;

-- Original query - returns 23 rows
SELECT custid FROM Sales.Customers AS C
WHERE NOT EXISTS
  (SELECT * FROM HR.Employees AS E
   WHERE country = N'USA'
     AND NOT EXISTS
       (SELECT * FROM Sales.Orders AS O
        WHERE O.custid = C.custid
          AND O.empid = E.empid));

-- Try with Israel; no employee is from Israel
SELECT custid FROM Sales.Customers AS C
WHERE NOT EXISTS
  (SELECT * FROM HR.Employees AS E
   WHERE country = N'IL'
     AND NOT EXISTS
       (SELECT * FROM Sales.Orders AS O
        WHERE O.custid = C.custid
          AND O.empid = E.empid));
-- All customers are returned - the problem is that there is no customer
-- which would not be served by all employees from Israel, as there is
-- no employee from Israel

-- Mediator relation
SELECT DISTINCT empid, country
  FROM HR.Employees;

-- Corrected division with mediator relation
SELECT custid FROM Sales.Customers AS C
WHERE NOT EXISTS
  (SELECT * FROM HR.Employees AS E
   WHERE country = N'IL' 
     AND NOT EXISTS
       (SELECT * FROM Sales.Orders AS O
        WHERE O.custid = C.custid
          AND O.empid = E.empid))
     AND EXISTS
  (SELECT * FROM HR.Employees AS E
   WHERE country = N'IL');  

-- Check also on USA employees - the result is still 23 customers
SELECT custid FROM Sales.Customers AS C
WHERE NOT EXISTS
  (SELECT * FROM HR.Employees AS E
   WHERE country = N'USA' 
     AND NOT EXISTS
       (SELECT * FROM Sales.Orders AS O
        WHERE O.custid = C.custid
          AND O.empid = E.empid))
     AND EXISTS
  (SELECT * FROM HR.Employees AS E
   WHERE country = N'USA');  


-- Another approach - using count distinct
-- Works correctly for USA
SELECT custid
FROM Sales.Orders
WHERE empid IN
  (SELECT empid FROM HR.Employees
   WHERE country = N'USA')
GROUP BY custid
HAVING COUNT(DISTINCT empid) =
  (SELECT COUNT(*) FROM HR.Employees
   WHERE country = N'USA');

-- Works correctly for Israel
SELECT custid
FROM Sales.Orders
WHERE empid IN
  (SELECT empid FROM HR.Employees
   WHERE country = N'IL')
GROUP BY custid
HAVING COUNT(DISTINCT empid) =
  (SELECT COUNT(*) FROM HR.Employees
   WHERE country = N'IL');
   

