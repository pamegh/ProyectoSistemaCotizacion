-- =============================================
-- Procedimiento: sp_ObtenerEstadisticasDashboard
-- Descripción: Obtiene las estadísticas para el panel de control del administrador
-- =============================================
CREATE PROCEDURE sp_ObtenerEstadisticasDashboard
AS
BEGIN
    SET NOCOUNT ON;

    -- Total de usuarios
    DECLARE @TotalUsuarios INT = 0;
    SELECT @TotalUsuarios = COUNT(*) FROM usuarios WHERE estado = 'ACTIVO';

    -- Cotizaciones activas (del último mes o del año actual)
    DECLARE @CotizacionesActivas INT = 0;
    SELECT @CotizacionesActivas = COUNT(*) 
    FROM cotizaciones 
    WHERE YEAR(fecha_creacion) = YEAR(GETDATE());

    -- Reportes generados (asumiendo que son las cotizaciones)
    DECLARE @ReportesGenerados INT = 0;
    SELECT @ReportesGenerados = COUNT(*) 
    FROM cotizaciones;

    -- Productos disponibles
    DECLARE @ProductosDisponibles INT = 0;
    SELECT @ProductosDisponibles = COUNT(*) 
    FROM productos 
    WHERE estado = 'ACTIVO';

    -- Retornar los resultados
    SELECT 
        @TotalUsuarios AS total_usuarios,
        @CotizacionesActivas AS cotizaciones_activas,
        @ReportesGenerados AS reportes_generados,
        @ProductosDisponibles AS productos_disponibles;
END
GO
