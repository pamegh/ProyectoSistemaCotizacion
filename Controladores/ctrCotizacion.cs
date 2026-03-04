using ProyectoSistemaCotizacion.BaseDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using ProyectoSistemaCotizacion.Modelos;

namespace ProyectoSistemaCotizacion.Controladores
{
    public class ctrCotizacion
    {
        private string _SQLConnection = Conn.GetConnectionStrings();

        public string InsertarCotizacion(mdlCotizacion datos)
        {
            String numeroGenerado = "";

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_InsertarCotizacion"))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@usuario_id", datos.UsuarioId);
                cmd.Parameters.AddWithValue("@producto_id", datos.ProductoId);
                cmd.Parameters.AddWithValue("@plazo_id", datos.PlazoId);
                cmd.Parameters.AddWithValue("@monto", datos.Monto);
                cmd.Parameters.AddWithValue("@tasa_anual", datos.TasaAnual);
                cmd.Parameters.AddWithValue("@impuesto", datos.Impuesto);
                cmd.Parameters.AddWithValue("@total_interes_bruto", datos.TotalInteresBruto);
                cmd.Parameters.AddWithValue("@total_impuesto", datos.TotalImpuesto);
                cmd.Parameters.AddWithValue("@total_interes_neto", datos.TotalInteresNeto);
                cmd.Parameters.AddWithValue("@creado_por", datos.CreadoPor);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        numeroGenerado = dr["numero_cotizacion"].ToString();

                    }
                }
            }
            return numeroGenerado;
        }
    }
}