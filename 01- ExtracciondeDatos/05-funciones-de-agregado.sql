/*
Funciones de Agregado

COUNT(*)
COUNT(CAMPO)
MAX()
MIN()
AVG()
SUM()

Estas funciones por si solas generan un resultado escalar
(un solo registro)

GROUP BY
HAVING
*/

SELECT*
FROM Orders;

SELECT 
	COUNT(*) AS [Numero de Ordenes]
FROM Orders;

SELECT 
	COUNT (shipregion) AS [Numero de Regiones]
FROM Orders;

SELECT MAX(OrderDate) AS [Ultima fecha de Compra]
FROM Orders;

SELECT MAX(UnitPrice) AS [Precio mas alto]
FROM Products;

SELECT MIN(UnitsInStock) AS [Stock Minimo]
FROM Products;

--Total de ventas realizadas

SELECT *, (UnitPrice*Quantity-(1-Discount)) AS [Importe]
FROM [Order Details]


SELECT 
	ROUND (SUM(UnitPrice*Quantity-(1-Discount)),2) AS [Importe]
FROM [Order Details]

--Seleccionar el promedio de ventas

SELECT 
	ROUND (AVG(UnitPrice*Quantity-(1-Discount)),2) AS [Promedio de Ventas]
FROM [Order Details]

--Seleccionar el numero de ordenes realizadas a Alemania

SELECT*
FROM Orders;

SELECT COUNT (*) AS [Total de Ordenes]
FROM Orders
WHERE ShipCountry = 'Germany'
AND CustomerId ='LEHMS';


SELECT*
FROM Customers;

--Seleccionar la suma de la cantidad vendida
--por cada OrderId(Agrupada)

SELECT
	OrderId,SUM(Quantity) AS [Total de Cantidades]
FROM [Order Details]
GROUP BY OrderID

--Seleccionar el numero de productos por categoria

SELECT
c.CategoryID AS [Categoria],
COUNT(*) AS [Numero de productos]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID=c.CategoryID
WHERE c.CategoryName IN ('Beverages','Meat/Poultry')
GROUP BY c.CategoryName

--Obtener el total de pedidos realizados por cada cliente

SELECT
	CustomerID,COUNT(OrderId) AS[Pedidos Totales]
FROM Orders
GROUP BY CustomerID

--Obtener el numero total de pedidos que ha atendido cada empleado

SELECT
	EmployeeID AS [Numero de empleado],
	COUNT(OrderId) AS[Pedidos Totales]
FROM Orders
GROUP BY EmployeeID


SELECT
	e.FirstName,
	e.LastName,
	COUNT(OrderId) AS[Pedidos Totales]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID=e.EmployeeID
GROUP BY e.FirstName,
		 e.LastName

SELECT
	CONCAT (e.FirstName,'',e.LastName) AS [FullName],
	COUNT(OrderId) AS[Pedidos Totales]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID=e.EmployeeID
GROUP BY e.FirstName,
		 e.LastName


		 --Ventas totales por producto

SELECT
	p.ProductName,
	ROUND(SUM(od.Quantity * od.UnitPrice * (1-Discount)),2) AS [Totales por producto]
FROM [Order Details] AS od
INNER JOIN Products AS p
ON p.ProductID=od.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;

--Calcular cuantos pedidos se realizaron por año

SELECT
	 DATEPART (YY,OrderDate) AS [Año],
	 COUNT(*) AS [Numero de pedidos]
FROM Orders AS o
GROUP BY DATEPART (YY,OrderDate) 

--Cuantos productos ofrece cada proveedor

SELECT 
       s.CompanyName AS [Proveedor],
	   COUNT(*) AS [Numero de Productos]
FROM Products AS p
INNER JOIN Suppliers AS s
ON p.SupplierID=s.SupplierID
GROUP BY s.CompanyName

--Seleccionar el numero de pedidos por cliente que hayan realizado mas de 10

SELECT 
	c.CompanyName AS [Cliente],
	COUNT(*) AS [Numero de pedidos]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID=c.CustomerID
GROUP BY c.CompanyName
HAVING COUNT (*) > 10

--Seleccionar los empleados que hayan gestionado pedidos por un total superior a 10000 en ventas
--(mostrar id empleado, nombre y total de compras)

SELECT
	o.EmployeeId AS [Nombre Empleado],
	CONCAT(e.FirstName,'',e.LastName) AS [FullName],
	ROUND (SUM (od.UnitPrice * od.Quantity * (1-od.Discount)), 2) 
	AS [Total de Pedidos]
FROM [Order Details] AS od
	INNER JOIN Orders AS o
	ON od.OrderId=o.OrderID
	INNER JOIN Employees AS e
	ON e.EmployeeID = o.EmployeeID
	GROUP BY o.EmployeeID,FirstName, e.LastName