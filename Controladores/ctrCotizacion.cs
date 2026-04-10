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

        public int InsertarCotizacion(
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
            int cotizacionId = 0;

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

                object result = cmd.ExecuteScalar();

                if (result != null && int.TryParse(result.ToString(), out int id))
                {
                    cotizacionId = id;
                }
                else
                {
                    throw new Exception("No se pudo obtener el ID de la cotización");
                }
            }

            return cotizacionId;
        }

        public DataTable ListarCotizaciones(int? usuarioId)
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ListarCotizaciones", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                if (usuarioId.HasValue)
                    cmd.Parameters.AddWithValue("@usuario_id", usuarioId.Value);
                else
                    cmd.Parameters.AddWithValue("@usuario_id", DBNull.Value);

                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
        }
        public List<mdlDetalleCotizacion> ObtenerDetalleCotizacion(int cotizacionId)
        {
            List<mdlDetalleCotizacion> lista = new List<mdlDetalleCotizacion>();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerDetalleCotizacion", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@cotizacion_id", cotizacionId);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        lista.Add(new mdlDetalleCotizacion
                        {
                            Mes = Convert.ToInt32(dr["mes"]),
                            InteresBruto = Convert.ToDecimal(dr["interes_bruto"]),
                            Impuesto = Convert.ToDecimal(dr["impuesto"]),
                            InteresNeto = Convert.ToDecimal(dr["interes_neto"])
                        });
                    }
                }
            }

            return lista;
        }

        public mdlCotizacion ObtenerCotizacionPorId(int cotizacionId)
        {
            mdlCotizacion cot = null;

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerCotizacionPorId", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@cotizacion_id", cotizacionId);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        cot = new mdlCotizacion
                        {
                            CotizacionId = cotizacionId,
                            NumeroCotizacion = dr["numero_cotizacion"].ToString(),
                            NombreCliente = dr["cliente"].ToString(),
                            Telefono = dr["telefono"].ToString(),
                            Correo = dr["correo"].ToString(),
                            NombreProducto = dr["producto"].ToString(),
                            ProductoId = Convert.ToInt32(dr["producto_id"]),
                            Monto = Convert.ToDecimal(dr["monto"]),
                            TasaAnual = Convert.ToDecimal(dr["tasa_anual"]),
                            Impuesto = Convert.ToDecimal(dr["impuesto"]),
                            TotalInteresNeto = Convert.ToDecimal(dr["total_interes_neto"]),
                            PlazoDescripcion = dr["plazo"].ToString()
                        };
                    }
                }
            }

            return cot;
        }

        public bool InsertarDetalleCotizacion(int cotizacionId, int mes, decimal interesBruto,
    decimal impuesto, decimal interesNeto, string usuarioActual = "Sistema")
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_InsertarDetalleCotizacion", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@cotizacion_id", cotizacionId);
                cmd.Parameters.AddWithValue("@mes", mes);
                cmd.Parameters.AddWithValue("@interes_bruto", interesBruto);
                cmd.Parameters.AddWithValue("@impuesto", impuesto);
                cmd.Parameters.AddWithValue("@interes_neto", interesNeto);
                cmd.Parameters.AddWithValue("@creado_por", usuarioActual); // ✅
                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }
    }
}