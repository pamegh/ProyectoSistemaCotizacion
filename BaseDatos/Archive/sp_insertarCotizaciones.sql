

CREATE PROCEDURE sp_InsertarCotizaciones
(
    @numero_cotizacion VARCHAR(20),
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
        creado_por
    )
    VALUES
    (
        @numero_cotizacion,
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
        @creado_por
    )

    SELECT @numero_cotizacion AS numero_cotizacion
END
