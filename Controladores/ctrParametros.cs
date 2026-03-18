using ProyectoSistemaCotizacion.BaseDatos;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Controladores
{
    public class ctrParametros
    {
        private ConnSQL conn = new ConnSQL();
        private string _SQLConnection = Conn.GetConnectionStrings();

        public DataTable ListarParametros()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ListarParametros", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
        }

        public bool InsertarParametro(mdlParametros datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_InsertarParametro", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@clave", datos.Clave);
                cmd.Parameters.AddWithValue("@valor", datos.Valor);
                cmd.Parameters.AddWithValue("@descripcion", datos.Descripcion);
                cmd.Parameters.AddWithValue("@estado", datos.Estado);
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

        public mdlParametros ObtenerParametroPorId(int parametroId)
        {
            mdlParametros parametro = new mdlParametros();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerParametroPorId", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@parametro_id", parametroId);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        parametro.ParametroId = Convert.ToInt32(dr["parametro_id"]);
                        parametro.Clave = dr["clave"].ToString();
                        parametro.Valor = dr["valor"].ToString();
                        parametro.Descripcion = dr["descripcion"].ToString();
                        parametro.Estado = dr["estado"].ToString();
                    }
                }
            }

            return parametro;
        }

        public bool ActualizarParametro(mdlParametros datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ActualizarParametro", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@parametro_id", datos.ParametroId);
                cmd.Parameters.AddWithValue("@clave", datos.Clave);
                cmd.Parameters.AddWithValue("@valor", datos.Valor);
                cmd.Parameters.AddWithValue("@descripcion", datos.Descripcion);
                cmd.Parameters.AddWithValue("@estado", datos.Estado);
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

        public bool EliminarParametro(int parametroId, out string mensaje)
        {
            mensaje = "";

            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_EliminarParametro", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@parametro_id", parametroId);
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
            }
            catch (Exception ex)
            {
                mensaje = "Error: " + ex.Message;
            }

            return false;
        }
        public bool ActivarImpuesto(int impuestoId, out string mensaje)
        {
            mensaje = "";

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ActivarImpuesto", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@impuesto_id", impuestoId);

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

        public mdlParametros ObtenerImpuestoActivo()
        {
            mdlParametros parametro = new mdlParametros();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ImpuestoActivo", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        parametro.ParametroId = Convert.ToInt32(dr["parametro_id"]);
                        parametro.Clave = dr["clave"].ToString();
                        parametro.Valor = dr["valor"].ToString();
                        parametro.Descripcion = dr["descripcion"].ToString();
                        parametro.Estado = dr["estado"].ToString();
                    }
                }
            }

            return parametro;
        }
    }
}