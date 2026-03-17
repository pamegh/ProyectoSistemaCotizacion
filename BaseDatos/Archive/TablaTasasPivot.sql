CREATE PROCEDURE sp_TablaTasasPivot
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CASE 
            WHEN pl.dias > 0 THEN CAST(pl.dias AS VARCHAR) + ' días'
            ELSE CAST(pl.meses AS VARCHAR) + ' meses'
        END AS Plazo,
        ISNULL(MAX(CASE WHEN p.codigo = 'CC' THEN t.tasa_anual END), 0) AS CC,
        ISNULL(MAX(CASE WHEN p.codigo = 'CF' THEN t.tasa_anual END), 0) AS CF,
        ISNULL(MAX(CASE WHEN p.codigo = 'DS' THEN t.tasa_anual END), 0) AS DS,
        ISNULL(MAX(CASE WHEN p.codigo = 'DV' THEN t.tasa_anual END), 0) AS DV
    FROM Tasas t
    INNER JOIN Productos p ON t.producto_id = p.producto_id
    INNER JOIN Plazos pl ON t.plazo_id = pl.plazo_id
    WHERE t.estado = 'Activo'
    GROUP BY pl.meses, pl.dias
    ORDER BY pl.meses, pl.dias;
END
