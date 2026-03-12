using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Modelos
{
    public class mdlEstadisticasDashboard
    {
        public int TotalUsuarios { get; set; }
        public int CotizacionesActivas { get; set; }
        public int ReportesGenerados { get; set; }
        public int ProductosDisponibles { get; set; }
    }
}
