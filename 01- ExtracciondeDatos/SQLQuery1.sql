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
CONSTRAINT fk_pedidos_clientes2
FOREIGN KEY (cliente_id)
REFERENCES clientes_2 (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION

);
GO

INSERT INTO clientes_2
values('coca-cola',100),
      ('pepsi',10),
      ('chicharrones',20)
      ;

GO

INSERT INTO pedidos
VALUES(GETDATE(),1),
('2026-01-10',1),
('2026-04-06',3),
('2026-12-12',NULL);

GO

SELECT*
FROM pedidos;

--Eliminacion DELETE NO ACTION

--Eliminar a los hijos

