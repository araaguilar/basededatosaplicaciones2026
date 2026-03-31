CREATE DATABASE bdstored;
GO
USE bdstored
GO

CREATE OR ALTER PROC spu_persona_saludar
    @nombre VARCHAR(50) -- Parametro de entrada

AS
BEGIN
    PRINT 'Hola ' + @nombre;
    END;
GO

EXEC spu_persona_saludar @nombre = 'Juan';
EXEC spu_persona_saludar @nombre = 'Maria';
EXEC spu_persona_saludar @nombre = 'Pedro';
EXEC spu_persona_saludar @nombre = 'Ana';
GO

SELECT CustomerID, CompanyName, City, Country
INTO customers
FROM NORTHWND.dbo.Customers
GO;

--Realizar un sp que reciba un parametro de un cliente en particular
-- y lo muestree

CREATE OR ALTER PROC spu_cliente_consultarporid
@Id CHAR(10)
AS
BEGIN
    SELECT CustomerID AS [NUMERO],
    CompanyName AS [CLIENTE],
    City AS [CIUDAD],
    Country AS [PAIS]
    FROM customers
    WHERE CustomerID = @Id;
    END;

EXEC spu_cliente_consultarporid @Id = 'ALFKI';
GO

SELECT * FROM customers
WHERE EXISTS (SELECT 1
FROM customers
WHERE CustomerID = 'ANTON')
GO

--
DECLARE @valor INT

SET @valor=(SELECT 1
FROM customers
WHERE CustomerID = 'ANTON');

IF @valor = 1
BEGIN
    PRINT 'El cliente existe';
END
ELSE
BEGIN
    PRINT 'El cliente no existe';
END
GO;

-- CREATE OR ALTER PROC spu_cliente_consultarporid2
--  @Id CHAR(10)
--  @valor INT

-- AS
-- SET @valor=(SELECT 1
-- FROM customers
-- WHERE CustomerID = 'ANTON');

-- IF @valor = 1
-- BEGIN
--     SELECT CustomerID AS [NUMERO],
--     CompanyName AS [CLIENTE],
--     City AS [CIUDAD],
--     Country AS [PAIS]
--     FROM customers
--     WHERE CustomerID = @Id;
--     END;
-- ELSE
-- BEGIN
--     PRINT 'El cliente no existe';
-- END
-- GO;

CREATE OR ALTER PROC spu_cliente_consultarporid2
    @Id CHAR(10)
AS
BEGIN
    IF LEN(@id)>5
    BEGIN
        RAISERROR ('El id del cliente no puede ser mayor a 5 caracteres',16,1);
        RETURN
    END;
    IF EXISTS (SELECT 1 FROM customers WHERE CustomerID = @Id)
    BEGIN
        SELECT CustomerID AS [NUMERO],
        CompanyName AS [CLIENTE],
        City AS [CIUDAD],
        Country AS [PAIS]
        FROM customers
        WHERE CustomerID = @Id;
    END
    ELSE
        PRINT 'El cliente no existe';
END;
GO

EXEC spu_cliente_consultarporid2 @Id = 'ALFKI';
GO

DECLARE @id2 AS CHAR(10) = (SELECT customerId FROM customers WHERE CustomerID = 'ANTON');
EXEC spu_cliente_consultarporid2 @Id = @id2;
GO

DECLARE @id3 CHAR(10)
SELECT @id3 = (SELECT customerId FROM customers WHERE CustomerID = 'ANTON');
EXEC spu_cliente_consultarporid2 @Id = @id3;    
GO ;



--Crear un sp con parametros de entrada y saloda
--para calcular el area de un  triangulo

CREATE OR ALTER PROC spu_calcular_area_triangulo
@base INT,
@altura INT,
@area FLOAT OUTPUT
AS
BEGIN
    SET @area = (@base * @altura) / 2.0;
END;
GO

DECLARE @area_triangulo FLOAT
EXEC spu_calcular_area_triangulo @base = 10, @altura = 5 ;
SELECT @area_triangulo AS Area;
GO   

--Crear un sp que evalue la edad de una persona

CREATE OR ALTER PROC spu_evaluar_edad
    @edad INT
AS
BEGIN
    
 IF @edad >= 18 AND @edad <= 45
    BEGIN
        PRINT ('Eres un adulto sin pension');
    END
    ELSE
    BEGIN
        PRINT ('Eres menor de edad');
    END
END;
GO

EXEC spu_evaluar_edad @edad = 20;
GO

CREATE OR ALTER PROC spu_Valores_Imprimir
@n AS INT
AS
BEGIN
IF @n <= 0
BEGIN
PRINT ('El numero debe ser mayor a 0');
RETURN  
END;
    DECLARE @i INT = 1;
    WHILE (@i <= @n)
    BEGIN
        PRINT CONCAT ('Este es el numero: ', @i);
        SET @i = @i + 1;
    END
END;
GO

EXEC spu_Valores_Imprimir @n = 5;
GO

CREATE OR ALTER PROC spu_Valores_Tabla
@n AS INT
AS
BEGIN
IF @n <= 0
BEGIN
PRINT ('El numero debe ser mayor a 0');
RETURN  
END
    DECLARE @i INT = 1;
    DECLARE @j INT = 1;
    WHILE (@i <= @n)
        BEGIN
 WHILE (@j <= 10)
    BEGIN
        PRINT CONCAT (@i,' * ',@j,' = ',@i*@j);
        SET @j = @j + 1;
    END
    PRINT (CHAR(13)+ CHAR(10)); -- Salto de linea
    SET @i = @i + 1;
    SET @j = 1;
END
END;
GO

EXEC spu_Valores_Tabla @n = 10;
GO

--Sirve para evaluar condiciones como un switch o if multiple

CREATE OR ALTER PROC spu_calificacion_evaluar
@calificacion INT
AS
BEGIN
SELECT CASE 
    WHEN @calificacion >= 90 THEN 'Excelente'
    WHEN @calificacion >= 70 THEN 'Aprobado'
    WHEN @calificacion >= 60 THEN 'regular'
    ELSE 'No acreditado'
 END AS Resultado;
END;
GO

EXEC spu_calificacion_evaluar @calificacion = 95;
GO

USE NORTHWND
GO

SELECT 
MAX (unitPrice) AS PrecioMaximo,
MIN (unitPrice) AS PrecioMinimo
FROM Products
GO

SELECT 
ProductName,
UnitPrice,
CASE 
    WHEN UnitPrice >=200 THEN 'Caro'
    WHEN UnitPrice >=100 THEN 'Medio'
    ELSE 'Barato'
END AS Categoria
FROM Products

SELECT *
FROM [Order Details]

USE NORTHWND

/*================================CRUD======================================*/

--EJEMPLO INSERT

USE bdstored

CREATE TABLE Products
(
    id INT IDENTITY,
    nombre VARCHAR(50),
    precio DECIMAL (10,2)
);
GO

/* SP PARA INSERT */
CREATE OR ALTER PROCEDURE usp_insertarCliente
@nombre VARCHAR(50),
@precio DECIMAL (10,2)
AS
BEGIN
    INSERT INTO Products (nombre,precio)
    VALUES (@nombre,@precio);
END;
GO

--SP para UPDATE

CREATE OR ALTER PROC usp_Actualizar_precio
@id INT,
@precio DECIMAL(10,2)
AS 
BEGIN
IF EXISTS(SELECT 1 FROM Products WHERE id =@id)
BEGIN
    UPDATE Products
    SET precio=@precio
    WHERE id =@id;
    END
    PRINT 'El id del producto no exite, no se realizo la modificacion';
END;
GO

--SP para DELETE

CREATE OR ALTER PROC usp_Eliminar_Producto
@id AS INT
AS
BEGIN
    DELETE Products
    WHERE id = @id;
END;
GO

/*================================MAEJO DE ERRORES======================================*/

--Sin manejo de errores
SELECT 10/0;

BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'Ocurrio un error';
END CATCH
GO

BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'Mensaje'+ ERROR_MESSAGE();
    PRINT 'Numero'+CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'LINEA'+CAST(ERROR_LINE() AS VARCHAR);
END CATCH;
GO

--Ejemplo de uso de una transaccion

BEGIN TRANSACTION;

SELECT*FROM Products;

INSERT INTO Products
VALUES ('Shampoo',75);

ROLLBACK; -- Cancela la transaccion, permite que la bd no sea inconsistente
COMMIT; -- Confirma la transaccion, porque todo fue atomico o se compilo

/*===============================USO DE TRANSACCIONES====================================*/

--Ejercicio para verificar en donde el try catch se vuelve poderoso

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Products
    VALUES ('Papas',22);

    INSERT INTO Products
    VALUES ('Chicles',35);

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Se hizo un ROLLBACK con error'
    PRINT 'ERROR: ' + ERROR_MESSAGE()
END CATCH;

--Validar si una transaccion esta activa

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Products
    VALUES ('Papas',22);

    INSERT INTO Products
    VALUES ('Chicles',35);

    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK
    PRINT 'Se hizo un ROLLBACK con error'
    PRINT 'ERROR: ' + ERROR_MESSAGE();
END CATCH;
