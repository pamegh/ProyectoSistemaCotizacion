ALTER PROCEDURE sp_ObtenerTablaFinanciera
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Columnas NVARCHAR(MAX);
    DECLARE @SQL NVARCHAR(MAX);

    SELECT @Columnas = STRING_AGG(QUOTENAME(nombre), ',')
    FROM Productos
    WHERE estado = 'Activo';

    SET @SQL = '
    SELECT 
        plazo_id,
        Plazo, ' + @Columnas + '
    FROM
    (
        SELECT 
            p.plazo_id,

            CASE 
                WHEN p.meses > 0 AND p.dias > 0 THEN 
                    CAST(p.meses AS VARCHAR) + 
                    CASE WHEN p.meses = 1 THEN '' mes y '' ELSE '' meses y '' END +
                    CAST(p.dias AS VARCHAR) +
                    CASE WHEN p.dias = 1 THEN '' día'' ELSE '' días'' END

                WHEN p.meses > 0 THEN 
                    CAST(p.meses AS VARCHAR) +
                    CASE WHEN p.meses = 1 THEN '' mes'' ELSE '' meses'' END

                WHEN p.dias > 0 THEN 
                    CAST(p.dias AS VARCHAR) +
                    CASE WHEN p.dias = 1 THEN '' día'' ELSE '' días'' END

                ELSE ''0 días''
            END AS Plazo,

            pr.nombre,
            t.tasa_anual

        FROM Plazos p
        LEFT JOIN Tasas t 
            ON p.plazo_id = t.plazo_id
            AND t.estado = ''Activo''

        LEFT JOIN Productos pr 
            ON pr.producto_id = t.producto_id
            AND pr.estado = ''Activo''

        WHERE p.estado = ''Activo''
    ) AS Fuente
    PIVOT
    (
        MAX(tasa_anual)
        FOR nombre IN (' + @Columnas + ')
    ) AS PivotTable
    ORDER BY plazo_id';

    EXEC sp_executesql @SQL;
END