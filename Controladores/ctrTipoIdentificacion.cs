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
    public class ctrTipoIdentificacion
    {
        private ConnSQL conn = new ConnSQL();
        private string _SQLConnection = Conn.GetConnectionStrings();

        public List<mdlTipoIdentificacion> ObtenerTodos()
        {
            List<mdlTipoIdentificacion> lista = new List<mdlTipoIdentificacion>();

            try
            {
                using (SqlConnection conexion = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_TipoIdentificacion_Obtener", conexion))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;

                    conexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            mdlTipoIdentificacion modelo = new mdlTipoIdentificacion
                            {
                                TipoIdentificacionId = Convert.ToInt32(dr["tipo_identificacion_id"]),
                                Codigo = dr["codigo"]?.ToString(),
                                Nombre = dr["nombre"]?.ToString(),
                                Descripcion = dr["descripcion"]?.ToString(),
                                LongitudMin = Convert.ToInt32(dr["longitud_min"]),
                                LongitudMax = Convert.ToInt32(dr["longitud_max"]),
                                PatronRegex = dr["patron_regex"]?.ToString(),
                                SoloNumerico = Convert.ToBoolean(dr["solo_numerico"]),
                                Estado = Convert.ToBoolean(dr["estado"]),
                                FechaCreacion = Convert.ToDateTime(dr["fecha_creacion"])
                            };

                            lista.Add(modelo);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener tipos de identificación: " + ex.Message);
            }

            return lista;
        }
    }
}