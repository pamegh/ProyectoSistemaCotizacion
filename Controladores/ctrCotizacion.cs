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

       

        public string ObtenerSiguienteNumeroCotizacion()
        {
            string numeroGenerado = "";

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerSiguienteNumeroCotizacion", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

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

        public string InsertarCotizacion(
                string numero,
                int usuarioId,
                int productoId,
                int plazoId,
                decimal monto,
                decimal tasa,
                decimal impuesto,
                decimal totalBruto,
                decimal totalImpuesto,
                decimal totalNeto,
                string creadoPor)
                    {
            string numeroGenerado = "";

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_InsertarCotizaciones", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@numero_cotizacion", numero);
                cmd.Parameters.AddWithValue("@usuario_id", usuarioId);
                cmd.Parameters.AddWithValue("@producto_id", productoId);
                cmd.Parameters.AddWithValue("@plazo_id", plazoId);
                cmd.Parameters.AddWithValue("@monto", monto);
                cmd.Parameters.AddWithValue("@tasa_anual", tasa);
                cmd.Parameters.AddWithValue("@impuesto", impuesto);
                cmd.Parameters.AddWithValue("@total_interes_bruto", totalBruto);
                cmd.Parameters.AddWithValue("@total_impuesto", totalImpuesto);
                cmd.Parameters.AddWithValue("@total_interes_neto", totalNeto);
                cmd.Parameters.AddWithValue("@creado_por", creadoPor);

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