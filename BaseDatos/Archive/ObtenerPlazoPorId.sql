CREATE PROCEDURE sp_ObtenerPlazoPorId
(
    @plazo_id INT
)
AS
BEGIN
    SELECT *
    FROM Plazos
    WHERE plazo_id = @plazo_id;
END
