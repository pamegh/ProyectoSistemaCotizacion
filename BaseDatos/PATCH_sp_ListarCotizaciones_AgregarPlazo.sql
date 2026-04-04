-- ============================================================
-- PATCH: Agregar columna "plazo" al SP sp_ListarCotizaciones
-- Fecha: 2024
-- Descripción: Soluciona el error al cargar el dashboard de usuario
--              cuando el campo "plazo" no existe en el resultado
-- ============================================================

USE [Apf_cotizaciones]
GO

-- Eliminar el procedimiento existente
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_ListarCotizaciones')
    DROP PROCEDURE [dbo].[sp_ListarCotizaciones]
GO

-- Recrear el procedimiento con el campo "plazo"
CREATE PROCEDURE [dbo].[sp_ListarCotizaciones]
    @usuario_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.cotizacion_id, c.numero_cotizacion,
           u.nombre_completo AS cliente,
           p.nombre AS producto,
           c.monto, c.total_interes_neto, c.fecha_creacion,
           CASE
               WHEN pl.meses > 0 AND pl.dias > 0 THEN
                   CAST(pl.meses AS VARCHAR) + ' meses y ' + CAST(pl.dias AS VARCHAR) + ' dias'
               WHEN pl.meses > 0 THEN
                   CAST(pl.meses AS VARCHAR) + ' meses'
               ELSE
                   CAST(pl.dias AS VARCHAR) + ' dias'
           END AS plazo
    FROM Cotizaciones c
    INNER JOIN Usuarios  u  ON c.usuario_id  = u.usuario_id
    INNER JOIN Productos p  ON c.producto_id = p.producto_id
    INNER JOIN Plazos    pl ON c.plazo_id    = pl.plazo_id
    WHERE c.estado <> 'Eliminado'
      AND (@usuario_id IS NULL OR c.usuario_id = @usuario_id)
    ORDER BY c.fecha_creacion DESC;
END
GO

PRINT 'Stored Procedure sp_ListarCotizaciones actualizado correctamente.'
GO
