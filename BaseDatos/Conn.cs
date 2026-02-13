using System; 
using System.Configuration;  

namespace VeterinariaWpfApp1.Bases_de_Datos
{
     class Conn
    {
        Conn()
        {

        }
        public static string GetConnectionStrings()
        {
            string resultado = "";
            ConnectionStringSettingsCollection settings =
                ConfigurationManager.ConnectionStrings;

            if (settings != null)
            {
                resultado = settings[0].ConnectionString; 
            }
            return resultado;
        }
    }
}
