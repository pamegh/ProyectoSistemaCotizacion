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

        public string Simbolo { get; set; }

        public string InteresBrutoFmt => $"{Simbolo} {InteresBruto:N2}";
        public string ImpuestoFmt => $"{Simbolo} {Impuesto:N2}";
        public string InteresNetoFmt => $"{Simbolo} {InteresNeto:N2}";
    }

}