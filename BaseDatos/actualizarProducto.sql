CREATE PROCEDURE sp_ActualizarProducto
(
    @producto_id INT,
    @nombre VARCHAR(100),
    @moneda CHAR(1),
    @modificado_por VARCHAR(50)
)
AS
BEGIN
    UPDATE Productos
    SET nombre = @nombre,
        moneda = @moneda,
        fecha_modificacion = GETDATE(),
        modificado_por = @modificado_por
    WHERE producto_id = @producto_id;

    SELECT 1 AS resultado, 'Producto actualizado correctamente.' AS mensaje;
END
