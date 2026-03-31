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

-- TODO: CICLO WHILE