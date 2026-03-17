CREATE PROCEDURE sp_ListarTasas
AS
BEGIN
    SELECT t.tasa_id,
           p.nombre AS producto,
           pl.meses,
           pl.dias,
           t.tasa_anual,
           t.estado
    FROM Tasas t
    INNER JOIN Productos p ON t.producto_id = p.producto_id
    INNER JOIN plazo pl ON t.plazo_id = pl.plazo_id
    WHERE t.estado = 'Activo'
    ORDER BY p.nombre, pl.meses, pl.dias;
END
