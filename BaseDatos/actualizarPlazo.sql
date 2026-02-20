CREATE OR ALTER PROCEDURE sp_ActualizarPlazo
(
    @plazo_id INT,
    @meses INT,
    @dias INT,
    @modificado_por VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Plazos WHERE plazo_id = @plazo_id)
    BEGIN
        SELECT 0 AS resultado, 'El plazo no existe.' AS mensaje;
        RETURN;
    END

    UPDATE Plazos
    SET meses = @meses,
        dias = @dias,
        fecha_modificacion = GETDATE(),
        modificado_por = @modificado_por
    WHERE plazo_id = @plazo_id;

    SELECT 1 AS resultado, 'Plazo actualizado correctamente.' AS mensaje;
END
