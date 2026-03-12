Please see the commented revisions to your SQL script below:

```sql
-- =============================================
-- Procedimiento: sp_ObtenerUsuarioPorId
-- Descripción: Obtiene los datos de un usuario por su ID (SIN contraseña)
-- =============================================
CREATE OR ALTER PROCEDURE sp_ObtenerUsuarioPorId
    @usuario_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        usuario_id,
        tipo_identificacion_id,
        identificacion,
        nombre_completo,
        telefono,
        correo,
        rol,
        estado
    FROM Usuarios
    WHERE usuario_id = @usuario_id;
END
GO