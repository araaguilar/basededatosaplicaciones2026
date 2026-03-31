# Triggers (Disparadores)

## ¿Que es un Tigger?

Es un bloque de codigo SQL que se ejecuta automaticamente
cuando ocurre un evento en una tabla:

Eventos 

- INSERT
- UPDATE
- DELETE

No se ejecutan manualmente se activan solos

## Para que sirven?
- Validaciones
- Auditoria (Guardar un historial)
- Reglas del negocio
- Automatizacion

## Tipos de Triggers

- AFTER TRIGGER
Se ejecuta despues del evento

- INSTEAD OF
Reemplaza la operacion original

## Sintaxis Basica

``` SQL

CREATE TRIGGER nombre_trigger
ON nombre_tabla
AFTER INSERT
AS
BEGIN
    -- Codigo
END;

```

## Tablas Especiales

| Tabla | Contenido |
| :--- | :--- |
| INSERTED | Nuevos datos |
| DELETED | Datos anteriores |
