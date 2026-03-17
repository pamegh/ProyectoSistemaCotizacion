CREATE PROCEDURE sp_ListarPlazos
AS
BEGIN
    SELECT *
    FROM Plazos
    WHERE estado = 'Activo'
    ORDER BY meses, dias;
END
