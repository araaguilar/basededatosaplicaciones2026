CREATE DATABASE db_triggers;
GO
USE db_triggers;
GO

CREATE TABLE Productos
(
    Id INT PRIMARY KEY ,
    Nombre VARCHAR(50) ,
    Precio DECIMAL(10,2) 
);
GO

--Ejercicio 1 Evento Insert (Trigger)

CREATE  OR ALTER TRIGGER trg_Insert_Productos
ON Productos
AFTER INSERT
AS
BEGIN
    SELECT* FROM inserted;
END
GO

--Evaluar el trigger

INSERT INTO Productos 
VALUES (1, 'Producto A', 10.00);
GO

INSERT INTO Productos
VALUES (2, 'Producto B', 20.00);
GO
 
INSERT INTO Productos
VALUES (3, 'Producto C', 30.00);
GO

INSERT INTO Productos
VALUES (4, 'Producto D', 40.00);
GO



--Evento DELETE (Trigger)
CREATE OR ALTER TRIGGER trg_Delete_Productos
ON Productos
AFTER DELETE
AS
BEGIN
    SELECT* FROM deleted;
    SELECT* FROM Productos;
    SELECT* FROM deleted;
END ;
GO

--EVENTO UPDATE (Trigger)

CREATE OR ALTER TRIGGER trg_Update_Productos
ON Productos
AFTER UPDATE
AS
BEGIN
    SELECT* FROM inserted;
    SELECT* FROM deleted;
END ;
GO

--Realizar un trigger que permita cancelar la operacion si se insertan 
-- mas de un registro a la vez

CREATE OR ALTER TRIGGER trg_Insert_Productos_Cancelar
ON Productos
AFTER INSERT
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        RAISERROR('No se permiten insertar mas de un registro a la vez', 16, 1);
        ROLLBACK TRANSACTION;
    END
END ;
GO

--REALIZAR UN TRIGGER QUE DETECTE UN CAMBIO EN EL PRECIO Y MANDE MENSAJE DE QUE
--EL PRECIO HA SIDO MODIFICADO

CREATE OR ALTER TRIGGER trg_Update_Precio_Productos
ON Productos
AFTER UPDATE
AS
BEGIN
   IF EXISTS (
            SELECT 1
            FROM inserted AS i
            INNER JOIN deleted d 
            ON i.Id = d.Id
            WHERE i.Precio <> d.Precio
   )
   BEGIN
       SELECT 'El precio ha sido modificado' AS Mensaje;
   END

END ;
GO

--Trigger que evite que cambie el precio

CREATE OR ALTER TRIGGER trg_Update_Precio_Productos_Cancelar
ON Productos
AFTER UPDATE
AS
BEGIN
   IF EXISTS (
            SELECT 1
            FROM inserted AS i
            INNER JOIN deleted d 
            ON i.Id = d.Id
            WHERE i.Precio <> d.Precio
   )
   BEGIN
       RAISERROR('No se permite cambiar el precio', 16, 1);
       ROLLBACK TRANSACTION;
   END

END ;
GO