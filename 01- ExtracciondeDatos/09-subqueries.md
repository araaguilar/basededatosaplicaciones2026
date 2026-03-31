#Subqueries (Subconsultas)

Una subconsulta es una consulta anidada dentro de otra consulta que
permite resolver problemas en varios niveles de informacion.

Dependiendo de donde se coloque y que retorne, cambia su comportamiento.

**Clasificacion**

1. Subconsultas escalares
2. Subconsultas con IN, ANY, ALL
3. Subconsultas correlacionadas
4. Subconsultas en SELECT
5. Subconsultas en FROM (Tablas derivadas)

##Escalares

Devuelven un unico valor, es por ello que se pueden utilizar con 
operadores =,<,>

Ejemplo:

```sql
SELECT *
FROM pedidos
WHERE total =(
		SELECT MAX (total) FROM pedidos
);
```
Orden de ejecucion:

1. Se ejecuta la subconsulta
2. Devuelve 1500
3. La consulta ocupa ese valor

##Subconsultas con (IN, ANY, ALL)

***Instruccion IN

```
--Seleccionar los pedidos de los clientes que viven en cdmx

--Subconsulta
SELECT id_cliente
FROM clientes
WHERE ciudad = 'CDMX'

--Consulta principal

SELECT 
	p.id_cliente,
	c.id_cliente,
	p.feha,
	c.nombre,
	p.total
FROM pedidos AS p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE id_cliente IN (
	SELECT id_cliente
	FROM clientes
	WHERE ciudad = 'CDMX'
	);

--Seleccionar todos aquellos clientes que no han hecho pedidos

SELECT id_cliente
FROM pedidos

SELECT *
FROM clientes
WHERE id_cliente NOT IN (
	SELECT id_cliente
	FROM pedidos
	);

SELECT DISTINCT c.id_cliente, c.nombre,c.ciudad
FROM clientes AS c
LEFT JOIN pedidos AS p
ON c.id_cliente=p.id_cliente;
WHERE p.id_cliente IS NULL;
```

**Instruccion ANY**
>Compara un valor de **Lista**. La condicion se cumple
>si al menos uno se cumple.

```sql

valor > ANY (subconsulta)

```
Es como decir:
"Mayor que al menos uno de los valores"


