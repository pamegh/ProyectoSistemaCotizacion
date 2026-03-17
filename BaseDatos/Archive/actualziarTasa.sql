CREATE OR ALTER PROCEDURE sp_ActualizarTasa
(
    @tasa_id INT,
    @tasa_anual DECIMAL(6,4),
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

    IF @tasa_anual <= 0
    BEGIN
        SELECT 0 AS resultado, 'La tasa debe ser mayor a cero.' AS mensaje;
        RETURN;
    END

    UPDATE Tasas
    SET tasa_anual = @tasa_anual,
        fecha_modificacion = GETDATE(),
        modificado_por = @modificado_por
    WHERE tasa_id = @tasa_id;

    SELECT 1 AS resultado, 'Tasa actualizada correctamente.' AS mensaje;
END
