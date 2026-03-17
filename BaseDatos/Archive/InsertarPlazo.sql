CREATE PROCEDURE sp_InsertarPlazo
(
    @meses INT,
    @dias INT,
    @creado_por VARCHAR(50)
)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Plazos WHERE meses = @meses AND dias = @dias)
    BEGIN
        SELECT 0 AS resultado, 'El plazo ya existe.' AS mensaje;
        RETURN;
    END

    INSERT INTO Plazos
    (meses, dias, estado, fecha_creacion, creado_por)
    VALUES
    (@meses, @dias, 'Activo', GETDATE(), @creado_por);

    SELECT 1 AS resultado, 'Plazo creado correctamente.' AS mensaje;
END
