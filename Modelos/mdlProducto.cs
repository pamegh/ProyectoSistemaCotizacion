using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Modelos
{
    public class mdlProducto
    {
        public int ProductoId { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string Moneda { get; set; }
        public string Estado { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public string ModificadoPor { get; set; }

        public string Mensaje { get; set; }
    }
}