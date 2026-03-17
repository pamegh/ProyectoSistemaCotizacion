-- =============================================
-- Procedimiento: sp_ActualizarUsuario
-- Descripción: Actualiza los datos de un usuario con validaciones
-- =============================================
CREATE OR ALTER PROCEDURE sp_ActualizarUsuario
(
    @usuario_id         INT,
    @tipo_identificacion_id INT,
    @identificacion     VARCHAR(30),
    @nombre_completo    VARCHAR(150),
    @telefono           VARCHAR(20) = NULL,
    @correo             VARCHAR(100),
    @contrasena_actual  VARCHAR(255) = NULL,
    @contrasena_nueva   VARCHAR(255) = NULL,
    @modificado_por     VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
 
    -- Verificar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE usuario_id = @usuario_id)
    BEGIN
        SELECT 0 AS resultado, 'Usuario no encontrado.' AS mensaje
        RETURN
    END
 
    -- Validar duplicado de identificación (excluyendo al mismo usuario)
    IF EXISTS (
        SELECT 1 FROM Usuarios 
        WHERE identificacion = @identificacion 
          AND usuario_id <> @usuario_id
    )
    BEGIN
        SELECT 0 AS resultado, 'La identificación ya está registrada por otro usuario.' AS mensaje
        RETURN
    END
 
    -- Validar duplicado de correo (excluyendo al mismo usuario)
    IF EXISTS (
        SELECT 1 FROM Usuarios 
        WHERE correo = @correo 
          AND usuario_id <> @usuario_id
    )
    BEGIN
        SELECT 0 AS resultado, 'El correo ya está registrado por otro usuario.' AS mensaje
        RETURN
    END
 
    -- Validar duplicado de teléfono (solo si se proporciona, excluyendo al mismo usuario)
    IF @telefono IS NOT NULL AND @telefono <> ''
    BEGIN
        IF EXISTS (
            SELECT 1 FROM Usuarios 
            WHERE telefono = @telefono 
              AND usuario_id <> @usuario_id
        )
        BEGIN
            SELECT 0 AS resultado, 'El teléfono ya está registrado por otro usuario.' AS mensaje
            RETURN
        END
    END
 
    -- Validar contraseña actual si se quiere cambiar
    IF @contrasena_nueva IS NOT NULL
    BEGIN
        IF @contrasena_actual IS NULL
        BEGIN
            SELECT 0 AS resultado, 'Debe proporcionar la contraseña actual para cambiarla.' AS mensaje
            RETURN
        END
 
        IF NOT EXISTS (
            SELECT 1 FROM Usuarios 
            WHERE usuario_id = @usuario_id 
              AND contrasena = @contrasena_actual
        )
        BEGIN
            SELECT 0 AS resultado, 'La contraseña actual es incorrecta.' AS mensaje
            RETURN
        END
    END
 
    -- Actualizar datos generales
    UPDATE Usuarios
    SET
        tipo_identificacion_id = @tipo_identificacion_id,
        identificacion         = @identificacion,
        nombre_completo        = @nombre_completo,
        telefono               = @telefono,
        correo                 = @correo,
        fecha_modificacion     = GETDATE(),
        modificado_por         = @modificado_por
    WHERE usuario_id = @usuario_id
 
    -- Actualizar contraseña si se proporcionó nueva
    IF @contrasena_nueva IS NOT NULL
    BEGIN
        UPDATE Usuarios
        SET contrasena = @contrasena_nueva
        WHERE usuario_id = @usuario_id
    END
 
    SELECT 1 AS resultado, 'Usuario actualizado correctamente.' AS mensaje
END