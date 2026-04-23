
CREATE PROCEDURE sp_ObtenerSiguienteNumeroCotizacion
AS
BEGIN
    DECLARE @ultimoNumero INT

    SELECT @ultimoNumero = MAX(
        CAST(SUBSTRING(numero_cotizacion, 5, LEN(numero_cotizacion)) AS INT)
    )
    FROM Cotizaciones

    IF @ultimoNumero IS NULL
        SET @ultimoNumero = 0

    SET @ultimoNumero = @ultimoNumero + 1

    SELECT 'COT-' + RIGHT('0000' + CAST(@ultimoNumero AS VARCHAR), 4) AS numero_cotizacion
END