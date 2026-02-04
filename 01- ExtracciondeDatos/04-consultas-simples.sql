use NORTHWND;

SELECT *
FROM customers;

GO

SELECT*
FROM orders;
GO

SELECT*
FROM Shippers;
GO

SELECT *
FROM Suppliers;
GO

SELECT * 
FROM [Order Details];
GO

SELECT *
FROM Employees;
GO

SELECT* 
FROM Products;
GO

--Proyeccion de la tabla

SELECT 
  ProductName, UnitsInStock, UnitPrice
FROM Products;

--Alias de columna

SELECT 
  ProductName AS [Nombre del Producto], 
  UnitsInStock AS [Unidades Medida], 
  UnitPrice AS [Precio Unitario]
FROM Products;

--Campo calculado y alias de la tabla

SELECT [Order Details].OrderID AS [Numero de Orden],
	   Products.ProductID AS [Numero de Producto],
	   ProductName AS[Nombre de Producto],
	   Quantity AS [Cantidad],
	   Products.UnitPrice AS [Precio], 
	   (Quantity * [Order Details].UnitPrice) AS Subtotal
FROM [Order Details]
INNER JOIN
Products
ON Products.ProductID=[Order Details].ProductID;


--
SELECT OrderID AS [Numero de Orden],
	   pr.ProductID AS [Numero de Producto],
	   ProductName AS[Nombre de Producto],
	   Quantity AS [Cantidad],
	   od.UnitPrice AS [Precio], 
	   (Quantity * od.UnitPrice) AS Subtotal
FROM [Order Details] AS od
INNER JOIN
Products pr
ON pr.ProductID= od.ProductID;

--Operadores relacionales (<,>,<=,>=,=,!= o <>)
--Mostrar todos los productos mayores a 20

SELECT 
   ProductName AS [Nombre Producto],
   QuantityPerUnit AS [Descripcion],
   UnitPrice AS [Precio]
FROM Products
WHERE UnitPrice>20;

--Seleccionar todos los clientes que no sean de Mexico

SELECT*
FROM Customers
WHERE country <> 'Mexico';

--Seleccionar todas aquellas ordenes realizadas en 1997
SELECT 
OrderID AS [Numero de Orden],
OrderDate AS [Fecha de Orden],
YEAR(OrderDate) AS [Año con Year],
DATEPART (YEAR, OrderDate) AS [Año con Datepart]
FROM Orders
WHERE YEAR (OrderDate) = 1997;

SELECT 
OrderID AS [Numero de Orden],
OrderDate AS [Fecha de Orden],
YEAR(OrderDate) AS [Año con Year],
DATEPART (YEAR, OrderDate) AS [Año con Datepart],
DATEPART (QUARTER ,OrderDate) AS Trimestre,
DATEPART (WEEKDAY, OrderDate) AS [Dia Semana],
DATENAME (WEEKDAY, OrderDate) AS [Nombre Dia Semana]
FROM Orders
WHERE YEAR (OrderDate) = 1997;

--Operadores Logicos (AND, OR, NOT)

--Seleccionar los productos que tengan precio mayor a 20 y stock mayor a 30

SELECT 
	ProductID AS [Numero de Producto],
	ProductName AS [Nombre de Producto],
	UnitsInStock AS [Existencia],
	UnitPrice AS [Precio],
	(UnitPrice*UnitsInStock) AS [Costo Inventario]
FROM Products
WHERE UnitPrice > 20
AND UnitsInStock > 30;

--Seleccionar a los clientes de Estados Unidos o Canada

SELECT *
FROM Customers 
WHERE Country='usa'
      Or country ='canada';


--Seleccionar los clientes de Brasil, Rio de Janeiro y que tengan region

SELECT *
FROM Customers 
WHERE Country='Brazil'
      AND City ='Rio de Janeiro'
	  AND Region IS NOT NULL;

--Operador IN
--Seleccionar todos los clientes de USA, Alemania y Francia

SELECT*
FROM Customers
WHERE Country ='USA'
OR Country='Germany'
OR Country='France'
ORDER BY Country;

SELECT*
FROM Customers
WHERE Country IN ('USA','Germany','France')
ORDER BY Country;

--Seleccionar los nombres de tres categorias especificas

SELECT
CategoryName
FROM Categories
Where CategoryID IN(4,5,7);

--Seleccionar los pedidos de tres empleados

SELECT*
FROM Orders AS [O]
WHERE EmployeeID IN(9,2,3);

--Seleccionar todos los clientes que no sean de Alemania,Mexico y Argentina

SELECT*
FROM Customers
WHERE Country NOT IN ( 'Mexico','Argentina','Germany');

--Seleccionar todos los productos que su precio este entre 10 y 30

SELECT
	ProductName,UnitPrice
FROM Products
WHERE UnitPrice>10
	AND UnitPrice<=30
ORDER BY 2 DESC;

SELECT
	ProductName,UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 10 AND 30
ORDER BY 2 DESC;

--Seleccionar todas las ordenes de 1995 a 1997

SELECT*
FROM Orders
WHERE DATEPART (YEAR,OrderDate) BETWEEN 1995 AND 1997;

--Seleccionar todos los productos que no tengan precio de entre 10 y 20

SELECT*
FROM Products
WHERE UnitPrice NOT BETWEEN 10 AND 20;

--Operador LIKE
--WILDCARDS(%, _, [], [^])

--Seleccionar todos los clientes en donde su nombre comience con A

SELECT *
FROM Customers
WHERE ContactName LIKE 'A%';

SELECT *
FROM Customers
WHERE ContactName LIKE 'An%';

--Seleccionar todos los clientes de una ciudad que comiece con L,
-- seguido de cualquier caracter despues nd y que termine con dos caracteres cualesquiera

SELECT *
FROM Customers
WHERE City LIKE 'L_nd__';

--Seleccionar todos los clientes que su nombre termine con A

SELECT*
FROM Customers
WHERE CompanyName LIKE '%A';

--Funciones de Aregado

--Devolver todos los clientes que en la ciudad contenga
--la letra "l"

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE City LIKE '%L%';

--Devolver todos los clientes que comiencen con a o comienzan con b

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE 'a%' 
	OR CompanyName LIKE 'b%';

--Devolver todos los clientes que comiencen con me y terminen con s

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE 'b%' 
	AND CompanyName LIKE '%s';


SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE 'b%s'; 

--Devolver todos los clientes que comiencen con a y que tengan tres caracteres de longitud

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE 'a__%' ;
	
--Devolver todos los clientes que tienen r en la segunda pocision


SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE '_R%'; 
	
--Devolver todos los clientes que contengan a o b o c al inicio

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE '[abc]%'; 

--Devolver todos los clientes que contengan a o b o c al inicio

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE '[^abc]%'; 

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE '[a-f]%'; -- De la a a las f

--Seleccionar todos los clientes de USA mostrando solo los tres primeros 

SELECT TOP 3 *
FROM Customers
WHERE Country = 'USA' ;

--Seleccionar todos los clientes ordenados de forma ascendente por su numero de cliente (OFFSET)

SELECT *
FROM Customers
ORDER BY CustomerID ASC
OFFSET 5 ROWS; 

--Seleccionar todos los clientes ordenados de forma ascendente por su numero de cliente (OFFSET y FETCH)

SELECT *
FROM Customers
ORDER BY CustomerID ASC
OFFSET 5 ROWS
FETCH NEXT 10 ROWS ONLY; 
	
	




