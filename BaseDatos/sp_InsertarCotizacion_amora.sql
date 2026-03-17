CREATE PROCEDURE sp_InsertarCotizacion
(
    @usuario_id INT,
    @producto_id INT,
    @plazo_id INT,
    @monto DECIMAL(18,2),
    @tasa_anual DECIMAL(6,4),
    @impuesto DECIMAL(5,2),
    @total_interes_bruto DECIMAL(18,2),
    @total_impuesto DECIMAL(18,2),
    @total_interes_neto DECIMAL(18,2),
    @creado_por VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @nuevo_id INT;
    DECLARE @numero_cotizacion VARCHAR(20);

    -- 1️⃣ Insertar sin numero_cotizacion
    INSERT INTO Cotizaciones
    (
        numero_cotizacion,
        usuario_id,
        producto_id,
        plazo_id,
        monto,
        tasa_anual,
        impuesto,
        total_interes_bruto,
        total_impuesto,
        total_interes_neto,
        estado,
        fecha_creacion,
        creado_por
    )
    VALUES
    (
        '', -- temporalmente vacío
        @usuario_id,
        @producto_id,
        @plazo_id,
        @monto,
        @tasa_anual,
        @impuesto,
        @total_interes_bruto,
        @total_impuesto,
        @total_interes_neto,
        'Activo',
        GETDATE(),
        @creado_por
    );

    -- 2️⃣ Obtener el ID recién insertado
    SET @nuevo_id = SCOPE_IDENTITY();

    -- 3️⃣ Generar numero tipo COT-00001
    SET @numero_cotizacion = 
        'COT-' + RIGHT('00000' + CAST(@nuevo_id AS VARCHAR), 5);

    -- 4️⃣ Actualizar el registro con el número generado
    UPDATE Cotizaciones
    SET numero_cotizacion = @numero_cotizacion
    WHERE cotizacion_id = @nuevo_id;

    -- 5️⃣ Devolver el número generado
    SELECT @numero_cotizacion AS numero_cotizacion;
END