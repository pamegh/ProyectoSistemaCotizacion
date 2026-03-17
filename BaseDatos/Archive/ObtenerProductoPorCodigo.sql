alter PROCEDURE sp_ObtenerProductoPorCodigo
(
    @codigo VARCHAR(10)
)
AS
BEGIN
    SELECT producto_id
    FROM Productos
    WHERE codigo = @codigo
      AND estado = 'Activo'
END