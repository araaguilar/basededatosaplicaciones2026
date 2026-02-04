--Restricciones Sql
CREATE DATABASE restricciones;
GO

USE restricciones;
GO

CREATE TABLE clientes(
cliente_id int not null primary key,       -- primary key
nombre nvarchar (100) not null,
apellido_paterno nvarchar(50) not null,
apellido_materno nvarchar(50)
)
GO

INSERT INTO clientes 
Values (1,'Aranza','Bernabe','Aguilar');
GO


INSERT INTO clientes 
Values (2,'Zaid Emmanuel','Sanchez','Martinez');
GO

INSERT INTO clientes 
(apellido_paterno,nombre,cliente_id,apellido_materno)
Values ('Ramirez','Angel',3,'Martinez');
GO

SELECT
*
FROM clientes;
GO

CREATE TABLE clientes_2(
cliente_id int not null identity(1,1),
nombre nvarchar(100) not null,
edad int not null

CONSTRAINT pk_clientes_2
PRIMARY KEY(cliente_id)
);
GO

CREATE TABLE pedidos(
pedidos_id int not null identity(1,1),
fecha_pedido date not null,
cliente_id int,
CONSTRAINT pk_pedidos
PRIMARY KEY (pedidos_id),
CONSTRAINT fk_pedidos_clientes
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION

);
GO

UPDATE clientes_2
SET cliente_id=3
WHERE cliente_id=2;


CREATE TABLE proveedor(
proveedor_id int not null,
nombre nvarchar(60) not null,
tipo nchar(1) not null,
limite_credito money not null,
CONSTRAINT pk_proveedor
PRIMARY KEY (proveedor_id),
CONSTRAINT unique_nombre
UNIQUE(nombre),
CONSTRAINT chk_tipo
CHECK (tipo in('g','s','b')),
CONSTRAINT chk_limite_credito
CHECK(limite_credito between 0 and 30000)
);

GO

CREATE TABLE productos(
producto_id int not null identity(1,1),
nombre nvarchar(50) not null,
precio money not null,
stock_maximo int not null,
stock_minimo int not null,
cantidad int not null,
proveedor_id int,
CONSTRAINT pk_productos
PRIMARY KEY(producto_id),
CONSTRAINT unique_nombre_pr
UNIQUE (nombre),
CONSTRAINT chk_stock_maximo
CHECK (stock_maximo >=5 and stock_maximo <=400),
CONSTRAINT chk_stock_minimo
CHECK (stock_minimo >=1 and stock_minimo < stock_maximo),
CONSTRAINT chk_cantidad_pr
CHECK (cantidad>0),
CONSTRAINT fk_productos_proveedor
FOREIGN KEY (proveedor_id)
REFERENCES proveedor(proveedor_id)
ON DELETE SET NULL
ON UPDATE SET NULL
);
GO