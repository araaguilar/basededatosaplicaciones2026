
/* Una vista (view) es una tabla virtual basada en una consulta, sirve
para reutilizar logica, simplificar consultas y controlar accesos.

Existen dos tipos: 

-Vistas las almacenadas 
-Vistas materializadas (SQL SERVER Vistas Indexadas)

Sintaxis:

CREATE OR ALTER VIEW vw_Nombre
AS
Definicion de la vista

*/

--Seleccionar todas las ventas por cliente, fecha de venta y estado

USE dbexercises

--Buenas practivas
--Nombre de vistas vw_
--Evitar SELECT * dentro de la vista
--Si se necesita ordenar hazlo al consultar la vista

CREATE VIEW vw_ventas_totales
AS 
SELECT 
	v.ClienteId,
	v.VentaId,
	v.FechaVenta,
	v.Estado,
	SUM (dv.Cantidad * dv.PrecioUnit * ( 1-dv.Descuento/100)) AS [Total]
FROM Ventas AS v
INNER JOIN DetalleVenta AS dv
ON v.VentaId = dv.VentaId
GROUP BY v.ClienteId,
		 v.VentaId,
		 v.FechaVenta,
		 v.Estado;

--Trabajar con la vista

SELECT 
	vt.VentaId,
	vt.ClienteId,
	c.Nombre,
	total,
	DATEPART (MONTH,FechaVenta) AS [Mes]
FROM vw_ventas_totales AS vt
INNER JOIN Clientes AS c
ON vt.ClienteId=c.ClienteId
WHERE DATEPART (MONTH,FechaVenta)=1
AND Total>=3130

--Realizar una vista que se llame vw_detalle_extendido
--que muestre ventaid,cliente,producto,categoria,
--cantidad vendida,precio de la venta,descuento,total de cada linea



--Seleccionar en vista 50 lineas ordenadas por ventais de forma asc

SELECT
v.VentaId AS [Id de la venta],
c.Nombre AS [Nombre del clinte],
p.Precio AS [Precio de la venta],
p.Nombre AS [Nombre del producto],
p.Categoria AS [Cateoria del producto],
dv.Cantidad AS [Cantidad vendida],
dv.Descuento AS [Descuento]

FROM [DetalleVenta] AS dv
INNER JOIN Ventas AS v
ON dv.VentaId=v.VentaId
INNER JOIN Clientes AS c
ON v.ClienteId=c.ClienteId
INNER JOIN Productos AS p
ON dv.ProductoId=p.ProductoId