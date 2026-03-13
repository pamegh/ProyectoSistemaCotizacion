-- =============================================
-- Stored Procedure: sp_ListarUsuarios
-- Descripción:      Lista todos los usuarios del sistema
--                   con sus datos principales
-- =============================================

CREATE OR ALTER PROCEDURE sp_ListarUsuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        usuario_id,
        identificacion,
        nombre_completo,
        telefono,
        correo,
        rol,
        estado
    FROM Usuarios
    ORDER BY nombre_completo ASC;
END
