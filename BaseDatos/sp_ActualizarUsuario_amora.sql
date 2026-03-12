
--ACTUALUZAR USUARIO 


CREATE PROCEDURE sp_ActualizarUsuario
(
    @usuario_id INT,
    @identificacion VARCHAR(30),
    @nombre_completo VARCHAR(150),
    @telefono VARCHAR(20) = NULL,
    @correo VARCHAR(100),
    @contrasena_actual VARCHAR(255) = NULL,
    @contrasena_nueva VARCHAR(255) = NULL,
    @modificado_por VARCHAR(50)
)
AS
BEGIN

    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE usuario_id = @usuario_id)
    BEGIN
        SELECT 0 AS resultado, 'Usuario no encontrado.' AS mensaje
        RETURN
    END

    -- Actualizar datos generales
    UPDATE Usuarios
    SET
        identificacion = @identificacion,
        nombre_completo = @nombre_completo,
        telefono = @telefono,
        correo = @correo
    WHERE usuario_id = @usuario_id


    -- Si viene contraseña nueva → actualizar
    IF @contrasena_nueva IS NOT NULL
    BEGIN
        UPDATE Usuarios
        SET contrasena = @contrasena_nueva
        WHERE usuario_id = @usuario_id
    END


    SELECT 1 AS resultado, 'Usuario actualizado correctamente.' AS mensaje

END

---OBTENER USUARIO POR ID


CREATE PROCEDURE sp_ObtenerUsuarioPorId
(
    @usuario_id INT
)
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        usuario_id,
        identificacion,
        nombre_completo,
        telefono,
        correo
    FROM Usuarios
    WHERE usuario_id = @usuario_id

END


---Obtener Usuario por ID

CREATE PROCEDURE sp_ObtenerUsuarioPorId
(
    @usuario_id INT
)
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        usuario_id,
        tipo_identificacion_id,
        identificacion,
        nombre_completo,
        telefono,
        correo
    FROM Usuarios
    WHERE usuario_id = @usuario_id

END

EXEC sp_ObtenerUsuarioPorId 9

select * from Usuarios;
