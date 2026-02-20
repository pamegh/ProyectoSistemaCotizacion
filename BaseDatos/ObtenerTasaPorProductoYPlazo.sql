CREATE PROCEDURE sp_ObtenerTasaPorProductoYPlazo
(
    @producto_id INT,
    @plazo_id INT
)
AS
BEGIN
    SELECT tasa_id, tasa_anual
    FROM Tasas
    WHERE producto_id = @producto_id
      AND plazo_id = @plazo_id
      AND estado = 'Activo'
END