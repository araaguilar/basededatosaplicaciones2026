# Store Procedure

## Fundamentos

¿Que es un Stored Procedure?

Es un bloque de codigo SQL guardado dentro de 
la base de datos(**Un objeto de la DB**) que
puede ejecutarse cuando se necesite

Es similar a una funcion o metodo en programacion:

Ventajas.

1. Reutilizacion de Codigo
2. Mejor Rendimiento
3. Mayor Seguridad (Evitar la Inyeccion SQL)
4. Centralizacion de la logica del Negocio
5. Menos trafico entre la aplicacion y el servidor

```
/================== Variables =========================/ 
DECLARE @Edad INT
SET @Edad = 42

SELECT @Edad AS Edad
PRINT CONCAT('La edad es: ', ' ',@Edad)

/* ================= Ejercicios con Variables =======================*/

/*
  1. Declarar una variable precio
  2. Asignarle el valor de 150
  3. Calcular el iva del 16%
  4. Mostrar el total
*/

DECLARE @Precio MONEY = 150 -- Se le asigna un valor inicial 
DECLARE @total MONEY

SET @total = @precio * 1.16

SELECT @total AS [Total]

/* ================= IF/ELSE =======================*/

DECLARE @edad2 INT
SET @edad2 = 18

IF @edad2 >= 18
BEGIN
    PRINT 'Es mayor de Edad'
    PRINT 'Felicidades'
END
ELSE
    PRINT 'Es menor'

/* ================= EJERCICIO IF/ELSE =======================*/

/*
   1. Crear una variable calificación 
   2. Evaluar si es mayor a 70 imprimir "Aprobado", sino "Reprobado"

*/

DECLARE @contador INT ;
DECLARE @contador2 INT = 1;
SET @contador = 1 ;
SET @contador2 =1;

WHILE @contador <= 5
    BEGIN
        WHILE @contador2 <=5
        BEGIN
            PRINT CONCAT (@contador ,'_',@contador2);
            SET @contador2 = @contador2 + 1
            END;
       SET @contador2 = 1;
        SET @contador = @contador +1;
       
END;
GO

--Imprime los numeros del 10 al 1

DECLARE @contador INT;
SET @contador = 10;
    WHILE @contador >=1
    BEGIN
        PRINT @contador;
        SET @contador = @contador -1;
    END;

--Store Procedure

CREATE PROCEDURE usp_mensaje_saludar
AS
BEGIN
    PRINT ('Hola Mundi Transact-SQL');
    END;
    GO

EXECUTE usp_mensaje_saludar;
GO

--Crear un sp que imprima la fecha actual

CREATE PROCEDURE usp_fecha
AS
BEGIN
    PRINT 'Fecha: ' + CAST(GETDATE() AS VARCHAR (30));
    END;
    GO

EXECUTE usp_fecha
GO

CREATE PROCEDURE usp_fecha2
AS
BEGIN
PRINT GETDATE();
END;
GO

EXECUTE usp_fecha2
GO

--Crear un sp que muestre el nombre de la bd actual

CREATE PROCEDURE usp_nombredb_mostrar
AS
BEGIN
    SELECT DB_NAME() AS [NOMBRE DB];
END;

EXECUTE usp_nombredb_mostrar
GO
```

2 Parametros en Stored Procedures

Los Parametros permiten enviar datos a los Sp

-- Stored Procedure

CREATE DATABASE bdstored;
GO
USE bdstored
GO

CREATE OR ALTER PROC spu_persona_saludar
    @nombre VARCHAR(50) -- Parametro de entrada

AS
BEGIN
    PRINT 'Hola' + @nombre;
    END;
GO
EXEC spu_persona

```
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

```
3 PARAMETROS OUTPUT

Los parametros OUTPUT devuelven valores al usuario

```
--Parametros OUTPUT

CREATE OR ALTER PROC spu_operacion_sumar
@a INT,
@b INT,
@resultado INT OUTPUT
AS
BEGIN
    SET @resultado = @a + @b;
END;
GO

--Utilizar la variable de salida

DECLARE @res INT
EXEC spu_operacion_sumar @a = 5, @b = 10, @resultado = @res OUTPUT;
SELECT @res AS Resultado;
GO
```

4 Logica dentro del Sp

Puedes usar:

- IF
- IF/ELSE
- WHILE
- VARIABLES
- CASE


## STORE PROCEDURES CON INSERT, UPDATE Y DELETE

Los SP para manejo de un CRUD

- Create (INSERT)
- Read (SELECT)
- Update (UPDATE)
- Delete (DELETE)

sql```
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
```

6 Manejo de errores

Se utiliza TRY CATCH 

Sintaxis
```
BEGIN TRY
    --CODIGO QUE PUEDE GENERAR ERROR
END TRY
BEGIN CATCH
    --CODIGO QUE SE EJECUTA SI OCURRE UN ERROR
END CATCH
```

Obtener Informacion del error `CATCH`, SQL SERVER tiene funciones especiales:

Dentro del

| Funcion | Descripcion |
| :--- | :--- |
| ERROR_MESSAGE() | Mensaje del error |
| ERROR_NUMBER() | Numero del error |
| ERROR_LINE() | Linea donde ocurrio|
| ERROR_SEVEREITY() | Nivel de gravedad|
| ERROR_STATE() | Estado del error|
| ERROR_LINE() | Linea donde ocurrio|

```SQL
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
```

> NOTA: ERRORES QUE NO CAPTURA EL TRY-CATCH
    -ERRORES DE COMPILACION (EJ.TABLA QUE NO EXISTE)
    -ERRORES DE SINTAXIS

```SQL
    BEGIN TRY
        SELECT * FROM TblQueNoExiste
    END TRY
    BEGIN CATCH
        PRINT 'NO ENTRA AQUI';
    END
```