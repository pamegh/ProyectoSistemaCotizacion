using System; 
using System.Configuration;  

namespace ProyectoSistemaCotizacion.BaseDatos
{
     class Conn
    {
        Conn()
        {

        }
        public static string GetConnectionStrings()
        {
            return ConfigurationManager
                   .ConnectionStrings["ConexionBD"]
                   .ConnectionString;
        }
    }
}
