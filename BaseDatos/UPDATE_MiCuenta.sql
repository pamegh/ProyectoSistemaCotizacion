-- =============================================
-- SCRIPT DE ACTUALIZACIÓN - Mi Cuenta
-- Fecha: $(date)
-- Descripción: Actualiza los procedimientos almacenados para la funcionalidad Mi Cuenta
-- =============================================

USE [Apf_cotizaciones]
GO

PRINT 'Iniciando actualización de procedimientos almacenados...'
GO

-- =============================================
-- 1. Procedimiento: sp_ObtenerUsuarioPorId
-- Descripción: Obtiene los datos de un usuario por su ID (SIN contraseña)
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ObtenerUsuarioPorId]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_ObtenerUsuarioPorId]
GO

CREATE PROCEDURE [dbo].[sp_ObtenerUsuarioPorId]
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
    FROM usuarios
    WHERE usuario_id = @usuario_id;
END
GO

PRINT 'Procedimiento sp_ObtenerUsuarioPorId actualizado correctamente.'
GO

-- =============================================
-- 2. Procedimiento: sp_ActualizarUsuario
-- Descripción: Actualiza los datos de un usuario con validaciones
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ActualizarUsuario]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_ActualizarUsuario]
GO

CREATE PROCEDURE [dbo].[sp_ActualizarUsuario]
    @usuario_id INT,
    @tipo_identificacion_id INT,
    @identificacion VARCHAR(30),
    @nombre_completo VARCHAR(150),
    @telefono VARCHAR(20),
    @correo VARCHAR(100),
    @contrasena_actual VARCHAR(255) = NULL,
    @contrasena_nueva VARCHAR(255) = NULL,
    @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que el usuario existe
    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE usuario_id = @usuario_id)
    BEGIN
        SELECT 0 AS resultado, 'El usuario no existe.' AS mensaje;
        RETURN;
    END
    
    -- Validar campos requeridos
    IF @identificacion IS NULL OR LTRIM(RTRIM(@identificacion)) = ''
    BEGIN
        SELECT 0 AS resultado, 'La identificación es requerida.' AS mensaje;
        RETURN;
    END
    
    IF @nombre_completo IS NULL OR LTRIM(RTRIM(@nombre_completo)) = ''
    BEGIN
        SELECT 0 AS resultado, 'El nombre completo es requerido.' AS mensaje;
        RETURN;
    END
    
    IF @correo IS NULL OR LTRIM(RTRIM(@correo)) = ''
    BEGIN
        SELECT 0 AS resultado, 'El correo es requerido.' AS mensaje;
        RETURN;
    END
    
    -- Validar formato de correo
    IF @correo NOT LIKE '%_@__%.__%'
    BEGIN
        SELECT 0 AS resultado, 'El formato del correo es inválido.' AS mensaje;
        RETURN;
    END
    
    -- Validar que el correo no esté en uso por otro usuario
    IF EXISTS (SELECT 1 FROM usuarios WHERE correo = @correo AND usuario_id <> @usuario_id)
    BEGIN
        SELECT 0 AS resultado, 'El correo ya está registrado por otro usuario.' AS mensaje;
        RETURN;
    END
    
    -- Validar que la identificación no esté en uso por otro usuario
    IF EXISTS (SELECT 1 FROM usuarios WHERE identificacion = @identificacion AND usuario_id <> @usuario_id)
    BEGIN
        SELECT 0 AS resultado, 'La identificación ya está registrada por otro usuario.' AS mensaje;
        RETURN;
    END
    
    -- Si se desea cambiar contraseña, validar
    IF @contrasena_actual IS NOT NULL AND @contrasena_nueva IS NOT NULL
    BEGIN
        -- Verificar que la contraseña actual sea correcta
        IF NOT EXISTS (SELECT 1 FROM usuarios WHERE usuario_id = @usuario_id AND contrasena = @contrasena_actual)
        BEGIN
            SELECT 0 AS resultado, 'La contraseña actual es incorrecta.' AS mensaje;
            RETURN;
        END
        
        -- Actualizar con nueva contraseña
        UPDATE usuarios
        SET 
            tipo_identificacion_id = @tipo_identificacion_id,
            identificacion = @identificacion,
            nombre_completo = @nombre_completo,
            telefono = @telefono,
            correo = @correo,
            contrasena = @contrasena_nueva,
            fecha_modificacion = GETDATE(),
            modificado_por = @modificado_por
        WHERE usuario_id = @usuario_id;
        
        SELECT 1 AS resultado, 'Datos y contraseña actualizados correctamente.' AS mensaje;
    END
    ELSE
    BEGIN
        -- Actualizar solo datos personales
        UPDATE usuarios
        SET 
            tipo_identificacion_id = @tipo_identificacion_id,
            identificacion = @identificacion,
            nombre_completo = @nombre_completo,
            telefono = @telefono,
            correo = @correo,
            fecha_modificacion = GETDATE(),
            modificado_por = @modificado_por
        WHERE usuario_id = @usuario_id;
        
        SELECT 1 AS resultado, 'Datos actualizados correctamente.' AS mensaje;
    END
END
GO

PRINT 'Procedimiento sp_ActualizarUsuario actualizado correctamente.'
GO

-- =============================================
-- 3. Verificación de Procedimientos
-- =============================================
PRINT ''
PRINT 'Verificando procedimientos almacenados...'
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ObtenerUsuarioPorId]') AND type in (N'P', N'PC'))
    PRINT '? sp_ObtenerUsuarioPorId - OK'
ELSE
    PRINT '? sp_ObtenerUsuarioPorId - ERROR'
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ActualizarUsuario]') AND type in (N'P', N'PC'))
    PRINT '? sp_ActualizarUsuario - OK'
ELSE
    PRINT '? sp_ActualizarUsuario - ERROR'
GO

PRINT ''
PRINT '============================================='
PRINT 'Actualización completada exitosamente.'
PRINT '============================================='
GO
