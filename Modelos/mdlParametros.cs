using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Modelos
{
    public class mdlParametros
    {
        public int ParametroId { get; set; }

        public string Clave { get; set; }

        public string Valor { get; set; }

        public string Descripcion { get; set; }

        public string Estado { get; set; }

        public DateTime FechaCreacion { get; set; }

        public string CreadoPor { get; set; }

        public DateTime? FechaModificacion { get; set; }

        public string ModificadoPor { get; set; }

        public string Mensaje { get; set; }
    }
}