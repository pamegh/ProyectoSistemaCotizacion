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
    public class ctrMoneda
    {
        private ConnSQL conn = new ConnSQL();
        private string _SQLConnection = Conn.GetConnectionStrings(); 

        public DataTable ListarMonedas()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ListarMonedas", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
        }

        public bool InsertarMoneda(mdlMoneda datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_InsertarMoneda", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@codigo", datos.Codigo);
                cmd.Parameters.AddWithValue("@nombre", datos.Nombre);
                cmd.Parameters.AddWithValue("@simbolo", datos.Simbolo);
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

        public mdlMoneda ObtenerMonedaPorId(int monedaId)
        {
            mdlMoneda moneda = new mdlMoneda();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerMonedaPorId", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@moneda_id", monedaId);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        moneda.MonedaId = Convert.ToInt32(dr["moneda_id"]);
                        moneda.Codigo = dr["codigo"].ToString();
                        moneda.Nombre = dr["nombre"].ToString();
                        moneda.Simbolo = dr["simbolo"].ToString();
                        moneda.Estado = dr["estado"].ToString();
                    }
                }
            }

            return moneda;
        }

        public bool ActualizarMoneda(mdlMoneda datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ActualizarMoneda", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@moneda_id", datos.MonedaId);
                cmd.Parameters.AddWithValue("@codigo", datos.Codigo);
                cmd.Parameters.AddWithValue("@nombre", datos.Nombre);
                cmd.Parameters.AddWithValue("@simbolo", datos.Simbolo);
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

        public bool EliminarMoneda(int monedaId, out string mensaje)
        {
            mensaje = "";

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_EliminarMoneda", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@moneda_id", monedaId);
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