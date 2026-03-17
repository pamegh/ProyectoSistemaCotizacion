CREATE PROCEDURE sp_InsertarProducto
(
    @codigo VARCHAR(10),
    @nombre VARCHAR(100),
    @moneda CHAR(1),
    @creado_por VARCHAR(50)
)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Productos WHERE codigo = @codigo)
    BEGIN
        SELECT 0 AS resultado, 'El código ya existe.' AS mensaje;
        RETURN;
    END

    INSERT INTO Productos
    (codigo, nombre, moneda, estado, fecha_creacion, creado_por)
    VALUES
    (@codigo, @nombre, @moneda, 'Activo', GETDATE(), @creado_por);

    SELECT 1 AS resultado, 'Producto creado correctamente.' AS mensaje;
END
