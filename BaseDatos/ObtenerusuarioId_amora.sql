create PROCEDURE sp_ObtenerUsuarioPorId
    @usuario_id INT
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
    WHERE usuario_id = @usuario_id;
END