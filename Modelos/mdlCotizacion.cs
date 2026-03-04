using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace ProyectoSistemaCotizacion.Modelos
{
    public class mdlCotizacion
    {
        public int CotizacionId { get; set; }

        public string NumeroCotizacion { get; set; }

        public int UsuarioId { get; set; }

        public int ProductoId { get; set; }

        public int PlazoId { get; set; }

        public decimal Monto { get; set; }

        public decimal TasaAnual { get; set; }

        public decimal Impuesto { get; set; }

        public decimal TotalInteresBruto { get; set; }

        public decimal TotalImpuesto { get; set; }

        public decimal TotalInteresNeto { get; set; }

        public string Estado { get; set; }

        public DateTime FechaCreacion { get; set; }

        public string CreadoPor { get; set; }

        public DateTime? FechaModificacion { get; set; }

        public string ModificadoPor { get; set; }
    }
}