ALTER PROCEDURE [dbo].[sp_EliminarPlazo]
(
    @plazo_id INT,
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

    BEGIN TRAN;

    -- 1️⃣ Inactivar plazo
    UPDATE Plazos
    SET estado = 'Inactivo',
        fecha_modificacion = GETDATE(),
        modificado_por = @modificado_por
    WHERE plazo_id = @plazo_id;

    -- 2️⃣ Inactivar todas las tasas asociadas
    UPDATE Tasas
    SET estado = 'Inactivo',
        fecha_modificacion = GETDATE(),
        modificado_por = @modificado_por
    WHERE plazo_id = @plazo_id;

    COMMIT TRAN;

    SELECT 1 AS resultado, 'Plazo y sus tasas fueron desactivados correctamente.' AS mensaje;
END