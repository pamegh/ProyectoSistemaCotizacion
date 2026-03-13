-- =============================================
-- Stored Procedure: sp_CambiarRolUsuario
-- Descripción:      Cambia el rol de un usuario (Usuario <-> Administrador)
-- Autor:            Sistema de Cotizaciones
-- Fecha:            2026
-- =============================================

CREATE OR ALTER PROCEDURE sp_CambiarRolUsuario
(
    @usuario_id     INT,
    @rol            VARCHAR(50),
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
    SET rol                = @rol,
        fecha_modificacion = GETDATE(),
        modificado_por     = @modificado_por
    WHERE usuario_id = @usuario_id;

    SELECT 1 AS resultado, 'Rol actualizado correctamente.' AS mensaje;
END
