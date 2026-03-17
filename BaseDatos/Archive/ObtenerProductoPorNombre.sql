CREATE PROCEDURE sp_ObtenerProductoPorNombre
    @nombre VARCHAR(100)
AS
BEGIN
    SELECT producto_id
    FROM Productos
    WHERE nombre = @nombre
    AND estado = 'Activo'
END