-- =============================================
-- Stored Procedure: sp_CambiarEstadoUsuario
-- =============================================
CREATE OR ALTER PROCEDURE sp_CambiarEstadoUsuario
(
    @usuario_id    INT,
    @estado        VARCHAR(20),
    @modificado_por VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE usuario_id = @usuario_id)
    BEGIN
        SELECT 0 AS resultado, 'Usuario no encontrado.' AS mensaje;
        RETURN;
    END

    UPDATE Usuarios
    SET estado             = @estado,
        fecha_modificacion = GETDATE(),
        modificado_por     = @modificado_por
    WHERE usuario_id = @usuario_id;

    SELECT 1 AS resultado, 'Estado actualizado correctamente.' AS mensaje;
END
