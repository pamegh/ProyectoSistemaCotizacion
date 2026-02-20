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
    public class ctrPlazo
    {
        private ConnSQL conn = new ConnSQL();
        private string _SQLConnection = Conn.GetConnectionStrings();

        public DataTable ListarPlazos()
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ListarPlazos", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        public mdlPlazo ObtenerPlazoPorId(int plazoId)
        {
            mdlPlazo plazo = new mdlPlazo();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerPlazoPorId", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@plazo_id", plazoId);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        plazo.PlazoId = Convert.ToInt32(dr["plazo_id"]);
                        plazo.Meses = Convert.ToInt32(dr["meses"]);
                        plazo.Dias = Convert.ToInt32(dr["dias"]);
                    }
                }
            }

            return plazo;
        }

        public bool InsertarPlazo(mdlPlazo datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_InsertarPlazo", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@meses", datos.Meses);
                cmd.Parameters.AddWithValue("@dias", datos.Dias);
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

        public bool ActualizarPlazo(mdlPlazo datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ActualizarPlazo", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@plazo_id", datos.PlazoId);
                cmd.Parameters.AddWithValue("@meses", datos.Meses);
                cmd.Parameters.AddWithValue("@dias", datos.Dias);
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

        public bool EliminarPlazo(int plazoId, out string mensaje)
        {
            mensaje = "";

            if (plazoId <= 0)
                return false;

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_EliminarPlazo", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@plazo_id", plazoId);
                cmd.Parameters.AddWithValue("@modificado_por", "Sistema");

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        mensaje = dr["mensaje"].ToString();
                        return Convert.ToInt32(dr["resultado"]) == 1;
                    }
                }
            }

            return false;
        }
    }
}
