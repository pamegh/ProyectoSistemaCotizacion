# Instrucciones de Instalación - Panel de Control del Dashboard Administrador

## Archivos Modificados/Creados

1. **BaseDatos\sp_ObtenerEstadisticasDashboard.sql** - Nuevo procedimiento almacenado
2. **Modelos\mdlEstadisticasDashboard.cs** - Nuevo modelo de datos
3. **Controladores\ctrUsuario.cs** - Agregado método `ObtenerEstadisticasDashboard()`
4. **Vistas\DashboardAdministrador.aspx** - Actualizado con controles Label
5. **Vistas\DashboardAdministrador.aspx.cs** - Agregado método `CargarEstadisticas()`
6. **Vistas\DashboardAdministrador.aspx.designer.cs** - Declaraciones de los nuevos controles

## Pasos de Instalación

### 1. Ejecutar el Procedimiento Almacenado

Abra SQL Server Management Studio (SSMS) y ejecute el archivo:
```
BaseDatos\sp_ObtenerEstadisticasDashboard.sql
```

Este procedimiento almacenado obtiene las siguientes estadísticas:
- **Total de Usuarios**: Cuenta todos los usuarios activos
- **Cotizaciones Activas**: Cuenta las cotizaciones del año actual
- **Reportes Generados**: Cuenta todas las cotizaciones generadas
- **Productos Disponibles**: Cuenta todos los productos activos

### 2. Verificar la Compilación

El proyecto ya ha sido compilado exitosamente. Los cambios están listos para usarse.

### 3. Funcionalidad Implementada

- El panel de control ahora muestra datos en tiempo real
- Si no hay datos disponibles, muestra **0** en cada campo
- Si ocurre un error al obtener las estadísticas, también muestra **0** en todos los campos
- Las estadísticas se cargan automáticamente al abrir la página (solo en el primer carga, no en postbacks)

### 4. Notas Técnicas

- Los valores se cargan en el evento `Page_Load` cuando `!IsPostBack`
- El manejo de errores asegura que siempre se muestre un valor (0 si no hay datos o hay error)
- Los controles Label se actualizan desde el servidor con los valores reales de la base de datos

## Pruebas

1. Asegúrese de tener el procedimiento almacenado instalado en la base de datos
2. Inicie sesión con un usuario con rol de **ADMIN**
3. Navegue al Dashboard del Administrador
4. Verifique que los números se muestren correctamente en las cuatro tarjetas

## Personalización

Si desea cambiar qué se cuenta en cada estadística, modifique las consultas SQL en el archivo:
```
BaseDatos\sp_ObtenerEstadisticasDashboard.sql
```

Por ejemplo, para cambiar "Cotizaciones Activas" a solo las del mes actual, cambie:
```sql
SELECT @CotizacionesActivas = COUNT(*) 
FROM cotizaciones 
WHERE YEAR(fecha_creacion) = YEAR(GETDATE()) 
  AND MONTH(fecha_creacion) = MONTH(GETDATE());
```
