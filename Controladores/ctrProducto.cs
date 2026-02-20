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
    public class ctrProducto
    {

        private ConnSQL conn = new ConnSQL();
        private string _SQLConnection = Conn.GetConnectionStrings();
        public DataTable ListarProductos()
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ListarProductos", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }

        public bool InsertarProducto(mdlProducto datos)
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_InsertarProducto", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@codigo", datos.Codigo);
                cmd.Parameters.AddWithValue("@nombre", datos.Nombre);
                cmd.Parameters.AddWithValue("@moneda", datos.Moneda);
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

        public bool ActualizarProducto(mdlProducto datos)
        {
            if (datos == null || datos.ProductoId <= 0)
                return false;

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ActualizarProducto", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@producto_id", datos.ProductoId);
                cmd.Parameters.AddWithValue("@nombre", datos.Nombre);
                cmd.Parameters.AddWithValue("@moneda", datos.Moneda);
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


        public bool EliminarProducto(int productoId, out string mensaje)
        {
            mensaje = "";

            if (productoId <= 0)
                return false;

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_EliminarProducto", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@producto_id", productoId);
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

        public mdlProducto ObtenerProductoPorId(int productoId)
        {
            mdlProducto producto = new mdlProducto();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerProductoPorId", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@producto_id", productoId);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        producto.ProductoId = Convert.ToInt32(dr["producto_id"]);
                        producto.Codigo = dr["codigo"].ToString();
                        producto.Nombre = dr["nombre"].ToString();
                        producto.Moneda = dr["moneda"].ToString();
                        producto.Estado = dr["estado"].ToString();
                    }
                }
            }

            return producto;
        }

        public DataTable ObtenerTablaFinanciera()
        {
            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_TablaTasasPivot", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }

        public int ObtenerProductoIdPorCodigo(string codigo)
        {
            int productoId = 0;

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerProductoPorCodigo", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@codigo", codigo);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        productoId = Convert.ToInt32(dr["producto_id"]);
                    }
                }
            }

            return productoId;
        }

        public int ObtenerProductoIdPorNombre(string nombre)
        {
            int productoId = 0;

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ObtenerProductoPorNombre", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@nombre", nombre);

                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        productoId = Convert.ToInt32(dr["producto_id"]);
                    }
                }
            }

            return productoId;
        }

    }
}