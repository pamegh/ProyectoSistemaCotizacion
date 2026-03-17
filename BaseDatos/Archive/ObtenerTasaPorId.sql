CREATE PROCEDURE sp_ObtenerTasaPorId
(
    @tasa_id INT
)
AS
BEGIN
    SELECT *
    FROM Tasas
    WHERE tasa_id = @tasa_id;
END
