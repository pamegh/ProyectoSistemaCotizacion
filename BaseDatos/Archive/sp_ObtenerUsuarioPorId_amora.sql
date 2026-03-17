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