using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Modelos
{
    public class mdlTasa
    {
        public int TasaId { get; set; }
        public int ProductoId { get; set; }
        public int PlazoId { get; set; }
        public decimal TasaAnual { get; set; }
        public string Estado { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public string ModificadoPor { get; set; }

        public string Mensaje { get; set; }
    }
}