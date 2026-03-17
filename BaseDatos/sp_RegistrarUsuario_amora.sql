CREATE PROCEDURE sp_RegistrarUsuario
    @tipo_identificacion_id INT,
    @identificacion VARCHAR(30),
    @nombre_completo VARCHAR(150),
    @telefono VARCHAR(20),
    @correo VARCHAR(100),
    @contrasena VARCHAR(255),
    @creado_por VARCHAR(50)
AS
BEGIN

    INSERT INTO usuarios
    (
        tipo_identificacion_id,
        identificacion,
        nombre_completo,
        telefono,
        correo,
        contrasena,
        fecha_creacion,
        creado_por
    )
    VALUES
    (
        @tipo_identificacion_id,
        @identificacion,
        @nombre_completo,
        @telefono,
        @correo,
        @contrasena,
        GETDATE(),
        @creado_por
    )

    SELECT 
        1 AS resultado,
        'Usuario registrado correctamente' AS mensaje

END