CREATE OR ALTER PROCEDURE sp_EliminarTasa
(
    @tasa_id INT,
    @modificado_por VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Tasas WHERE tasa_id = @tasa_id)
    BEGIN
        SELECT 0 AS resultado, 'La tasa no existe.' AS mensaje;
        RETURN;
    END

    UPDATE Tasas
    SET estado = 'Inactivo',
        fecha_modificacion = GETDATE(),
        modificado_por = @modificado_por
    WHERE tasa_id = @tasa_id;

    SELECT 1 AS resultado, 'Tasa desactivada correctamente.' AS mensaje;
END
