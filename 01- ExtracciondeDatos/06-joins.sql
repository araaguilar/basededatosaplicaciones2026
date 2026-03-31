USE NORTHWND;

SELECT TOP 0 CategoryID,CategoryName
INTO categoriesnew
FROM Categories

ALTER TABLE categoriesnew
ADD CONSTRAINT pk_categories_new
PRIMARY KEY (CategoryId)

SELECT TOP 0 ProductID,ProductName, CategoryId
INTO productsnew
FROM Products


ALTER TABLE productsnew
ADD CONSTRAINT pk_products_new
PRIMARY KEY (ProductID)

ALTER TABLE productsnew
ADD CONSTRAINT fk_products_categories2
FOREIGN KEY (categoryid)
REFERENCES categoriesnew (categoryid)
ON DELETE CASCADE

INSERT INTO categoriesnew
VALUES
('C1'),
('C2'),
('C3'),
('C4')

INSERT INTO productsnew
VALUES
('P1',1),
('P2',1),
('P3',2),
('P4',2),
('P5',4),
('P6',NULL)

SELECT *
FROM categoriesnew AS c
INNER JOIN productsnew AS p
ON p.CategoryID=c.CategoryID

SELECT *
FROM categoriesnew AS c
LEFT JOIN productsnew AS p
ON p.CategoryID=c.CategoryID

SELECT *
FROM categoriesnew AS c
LEFT JOIN productsnew AS p
ON p.CategoryID=c.CategoryID
WHERE ProductID is NULL


SELECT *
FROM categoriesnew AS c
RIGHT JOIN productsnew AS p
ON p.CategoryID=c.CategoryID


SELECT *
FROM productsnew AS p
LEFT JOIN categoriesnew AS c
ON p.CategoryID=c.CategoryID

SELECT CategoryID AS [Numero],
	CategoryName AS [Nombre], 
	[Description] AS[Descripcion]
INTO categories_new
FROM Categories;

ALTER TABLE categories_new
ADD CONSTRAINT pk_categorias_nuevas
PRIMARY KEY ([Numero])

INSERT INTO Categories
VALUES 
('Ropa','Ropa',Null),
('Linea Blanca','Mubles',Null)

INSERT INTO categories_new
SELECT c.CategoryName,c.Description
FROM Categories AS c
LEFT JOIN categories_new AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero IS NULL

SELECT c.CategoryName,c.Description
FROM Categories AS c
LEFT JOIN categories_new AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero IS NULL

DELETE  categories_new

INSERT INTO categories_new
SELECT
UPPER (c.CategoryName) AS [Categories],
UPPER(CAST(c.Description AS Varchar)) AS [Descripcion]
FROM Categories AS c
LEFT JOIN categories_new AS cn
ON c.CategoryID=cn.Numero
WHERE cn.Numero IS NULL

--Reinicia los identity (Cuando las tablas tienes integridad referencial,
--sino utilizar truncate)
DBCC CHECKIDENT ('categories_new',RESEED, 0)

--El truncate elimina los datos de la tabla al igual que el delete 
--pero solo funciona sino tiene integridad referencial,
--y ademas reinicia los identity

TRUNCATE TABLE categories_new

--FULL JOIN

SELECT*
FROM categories_new AS c
FULL JOIN
productsnew AS p
ON c.Numero=p.CategoryID






