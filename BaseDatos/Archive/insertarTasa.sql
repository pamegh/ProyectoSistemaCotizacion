CREATE PROCEDURE sp_InsertarTasa
(
    @producto_id INT,
    @plazo_id INT,
    @tasa_anual DECIMAL(6,4),
    @creado_por VARCHAR(50)
)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Tasas
        WHERE producto_id = @producto_id
        AND plazo_id = @plazo_id
    )
    BEGIN
        SELECT 0 AS resultado, 'Ya existe una tasa para este producto y plazo.' AS mensaje;
        RETURN;
    END

    INSERT INTO Tasas
    (producto_id, plazo_id, tasa_anual, estado, fecha_creacion, creado_por)
    VALUES
    (@producto_id, @plazo_id, @tasa_anual, 'Activo', GETDATE(), @creado_por);

    SELECT 1 AS resultado, 'Tasa creada correctamente.' AS mensaje;
END
