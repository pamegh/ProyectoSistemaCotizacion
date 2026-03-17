using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Modelos
{
    public class mdlDetalleCotizacion
    {
        public int Mes { get; set; }

        public decimal InteresBruto { get; set; }

        public decimal Impuesto { get; set; }

        public decimal InteresNeto { get; set; }
    }

}