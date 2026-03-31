CREATE DATABASE TrabajoDb;
GO

USE TrabajoDb;
GO


CREATE TABLE Cliente (
    id_cliente  INT           PRIMARY KEY IDENTITY(1,1),
    nombre      VARCHAR(50)   NOT NULL,
    pais        VARCHAR(50)   NOT NULL,
    ciudad      VARCHAR(50)   NOT NULL
);
GO


CREATE TABLE Producto (
    id_producto INT              PRIMARY KEY IDENTITY(1,1),
    nombre      VARCHAR(50)      NOT NULL,
    precio      DECIMAL(18, 2)   NOT NULL
);
GO


CREATE TABLE Venta (
    id_venta    INT     PRIMARY KEY IDENTITY(1,1),
    fecha       DATE    NULL,
    id_cliente  INT     NULL,
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
);
GO


CREATE TABLE Detalle_vta (
    id_vta          INT             NOT NULL,
    id_producto     INT             NULL,
    precio_venta    DECIMAL(18, 2)  NULL,
    cantidad        INT             NOT NULL DEFAULT 1,
    CONSTRAINT FK_Detalle_Venta    FOREIGN KEY (id_vta)        REFERENCES Venta(id_venta),
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (id_producto)   REFERENCES Producto(id_producto)
);
GO



INSERT INTO Cliente (nombre, pais, ciudad) VALUES
    ('Carlos Mendoza',   'México',    'Tula de Allende'),
    ('Laura Jiménez',    'México',    'Pachuca'),
    ('Roberto Torres',   'México',    'Ciudad de México'),
    ('Ana García',       'México',    'Querétaro'),
    ('Luis Hernández',   'México',    'Monterrey');
GO


INSERT INTO Producto (nombre, precio) VALUES
    ('Laptop HP 15"',        12500.00),
    ('Mouse Inalámbrico',      350.00),
    ('Teclado Mecánico',       890.00),
    ('Monitor 24" Full HD',   4200.00),
    ('Bocinas Bluetooth',      750.00),
    ('Memoria USB 64GB',       180.00);
GO






-- SP: sp_RegistrarVenta
-- Parámetros: @id_cliente, @id_producto, @cantidad
-- Inserta en Venta y Detalle_vta dentro de una transacción.
-- Si algo falla -> ROLLBACK. Si todo ok -> COMMIT.

CREATE PROCEDURE sp_RegistrarVenta
    @id_cliente  INT,
    @id_producto INT,
    @cantidad    INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables
    DECLARE @precio_producto DECIMAL(18, 2); -- precio del catálogo
    DECLARE @id_venta_nueva  INT;            -- ID generado por IDENTITY
    DECLARE @fecha_hoy       DATE = GETDATE();

    BEGIN TRANSACTION; -- inicia la transacción

    BEGIN TRY

        -- Validar cliente
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('Cliente no encontrado.', 16, 1);
            RETURN;
        END

        -- Obtener precio del producto
        SELECT @precio_producto = precio
        FROM Producto
        WHERE id_producto = @id_producto;

        -- Validar que el producto exista
        IF @precio_producto IS NULL
        BEGIN
            RAISERROR('Producto no encontrado.', 16, 1);
            RETURN;
        END

        -- Insertar encabezado de la venta
        INSERT INTO Venta (fecha, id_cliente)
        VALUES (@fecha_hoy, @id_cliente);

        -- Capturar el ID recién generado con SCOPE_IDENTITY()
        SET @id_venta_nueva = SCOPE_IDENTITY();

        -- Insertar detalle con precio tomado del catálogo
        INSERT INTO Detalle_vta (id_vta, id_producto, precio_venta, cantidad)
        VALUES (@id_venta_nueva, @id_producto, @precio_producto, @cantidad);

        COMMIT TRANSACTION; -- confirmar cambios
        PRINT 'Venta registrada. ID: ' + CAST(@id_venta_nueva AS VARCHAR);

    END TRY
    BEGIN CATCH

        -- Revertir todo si ocurrió algún error
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();

    END CATCH
END;
GO

-- Ejemplo de uso del SP
EXEC sp_RegistrarVenta @id_cliente = 1, @id_producto = 2, @cantidad = 3;
GO

SELECT v.id_venta, v.fecha, c.nombre AS cliente, p.nombre AS producto, dv.cantidad, dv.precio_venta
FROM Venta v    
JOIN Cliente c ON v.id_cliente = c.id_cliente
JOIN Detalle_vta dv ON v.id_venta = dv.id_vta
JOIN Producto p ON dv.id_producto = p.id_producto;
GO

