create PROCEDURE sp_ActualizarUsuario
    @usuario_id INT,
    @identificacion VARCHAR(50),
    @nombre_completo VARCHAR(150),
    @telefono VARCHAR(20),
    @correo VARCHAR(150),
    @modificado_por VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Usuarios
    SET 
        identificacion = @identificacion,
        nombre_completo = @nombre_completo,
        telefono = @telefono,
        correo = @correo,
        fecha_modificacion = GETDATE(),
        modificado_por = @modificado_por
    WHERE usuario_id = @usuario_id;

    SELECT 1 AS resultado, 'Datos actualizados correctamente.' AS mensaje;
END