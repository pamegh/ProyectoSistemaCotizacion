CREATE PROCEDURE sp_ObtenerProductoPorId
(
    @producto_id INT
)
AS
BEGIN
    SELECT *
    FROM Productos
    WHERE producto_id = @producto_id;
END