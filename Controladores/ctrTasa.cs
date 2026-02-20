using ProyectoSistemaCotizacion.BaseDatos;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Controladores
{
    public class ctrTasa
    {
        private ConnSQL conn = new ConnSQL();
        private string _SQLConnection = Conn.GetConnectionStrings();

        // LISTAR
        public DataTable ListarTasas()
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ListarTasas", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        // INSERTAR
        public bool InsertarTasa(mdlTasa datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_InsertarTasa", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@producto_id", datos.ProductoId);
                cmd.Parameters.AddWithValue("@plazo_id", datos.PlazoId);
                cmd.Parameters.AddWithValue("@tasa_anual", datos.TasaAnual);
                cmd.Parameters.AddWithValue("@creado_por", "Sistema");

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        datos.Mensaje = dr["mensaje"].ToString();
                        return Convert.ToInt32(dr["resultado"]) == 1;
                    }
                }
            }

            return false;
        }

        // ACTUALIZAR
        public bool ActualizarTasa(mdlTasa datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ActualizarTasa", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@tasa_id", datos.TasaId);
                cmd.Parameters.AddWithValue("@tasa_anual", datos.TasaAnual);
                cmd.Parameters.AddWithValue("@modificado_por", "Sistema");

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        datos.Mensaje = dr["mensaje"].ToString();
                        return Convert.ToInt32(dr["resultado"]) == 1;
                    }
                }
            }

            return false;
        }

        // ELIMINAR
        public bool EliminarTasa(int tasaId)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_EliminarTasa", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@tasa_id", tasaId);
                cmd.Parameters.AddWithValue("@modificado_por", "Sistema");

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            return true;
        }

        public DataTable ObtenerTablaFinanciera()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerTablaFinanciera", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
        }

        public mdlTasa ObtenerTasaPorProductoYPlazo(int productoId, int plazoId)
        {
            mdlTasa tasa = new mdlTasa();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerTasaPorProductoYPlazo", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@producto_id", productoId);
                cmd.Parameters.AddWithValue("@plazo_id", plazoId);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        tasa.TasaId = Convert.ToInt32(dr["tasa_id"]);
                        tasa.ProductoId = productoId;
                        tasa.PlazoId = plazoId;
                        tasa.TasaAnual = Convert.ToDecimal(dr["tasa_anual"]);
                    }
                }
            }

            return tasa;
        }
    }
}