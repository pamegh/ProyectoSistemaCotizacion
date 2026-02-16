using ProyectoSistemaCotizacion.BaseDatos;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Windows;


namespace ProyectoSistemaCotizacion.Controladores
{
    public class ctrUsuario
    {
        private ConnSQL conn = new ConnSQL();
        private string _SQLConnection = Conn.GetConnectionStrings();

        public bool ValidarIngreso(mdlUsuario datos)
        {
            if (datos == null)
                return false;

            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_Login", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;
                    cmd.Parameters.Add("@correo", SqlDbType.VarChar, 100).Value =
                        string.IsNullOrWhiteSpace(datos.Correo)
                            ? (object)DBNull.Value
                            : datos.Correo.Trim();

                    string hash = SeguridadContrasena.CalcularSHA256(datos.Contrasena.Trim());

                    cmd.Parameters.Add("@contrasena", SqlDbType.VarChar, 255).Value = hash;


                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (!dr.Read())
                        {
                            datos.Mensaje = "Usuario o contraseña incorrectos.";
                            return false;
                        }

                        int usuarioId = dr["usuario_id"] != DBNull.Value
                            ? Convert.ToInt32(dr["usuario_id"])
                            : 0;

                        if (usuarioId == 0)
                        {
                            datos.Mensaje = dr["mensaje"]?.ToString() ?? "Error al iniciar sesión.";
                            return false;
                        }

                        datos.UsuarioId = usuarioId;
                        datos.Identificacion = dr["identificacion"]?.ToString();
                        datos.NombreCompleto = dr["nombre_completo"]?.ToString();
                        datos.Telefono = dr["telefono"]?.ToString();
                        datos.Correo = dr["correo"]?.ToString();
                        datos.Rol = dr["rol"]?.ToString();
                        datos.Estado = dr["estado"]?.ToString();
                        datos.FechaCreacion = dr["fecha_creacion"] != DBNull.Value
                            ? Convert.ToDateTime(dr["fecha_creacion"])
                            : DateTime.MinValue;

                        return true;
                    }
                }
            }
            catch (SqlException ex)
            {
                datos.Mensaje = "Error SQL: " + ex.Message;
                return false;
            }
            catch (Exception ex)
            {
                datos.Mensaje = "Error general: " + ex.Message;
                return false;
            }
        }

        public bool RegistrarUsuario(mdlUsuario datos)
        {
            if (datos == null)
                return false;

            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_RegistrarUsuario", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@identificacion", SqlDbType.VarChar, 30)
                        .Value = datos.Identificacion?.Trim();

                    cmd.Parameters.Add("@nombre_completo", SqlDbType.VarChar, 150)
                        .Value = datos.NombreCompleto?.Trim();

                    cmd.Parameters.Add("@telefono", SqlDbType.VarChar, 20)
                        .Value = string.IsNullOrWhiteSpace(datos.Telefono)
                            ? (object)DBNull.Value
                            : datos.Telefono.Trim();

                    cmd.Parameters.Add("@correo", SqlDbType.VarChar, 100)
                        .Value = datos.Correo?.Trim();

                    string hash = SeguridadContrasena.CalcularSHA256(datos.Contrasena.Trim());

                    cmd.Parameters.Add("@contrasena", SqlDbType.VarChar, 255)
                        .Value = hash;

                    cmd.Parameters.Add("@tipo_identificacion_id", SqlDbType.Int)
                        .Value = datos.TipoIdentificacionId;

                    cmd.Parameters.Add("@creado_por", SqlDbType.VarChar, 50)
                        .Value = "Sistema";

                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (!dr.Read())
                        {
                            datos.Mensaje = "No se pudo registrar el usuario.";
                            return false;
                        }

                        int usuarioId = dr["usuario_id"] != DBNull.Value
                            ? Convert.ToInt32(dr["usuario_id"])
                            : 0;

                        string mensaje = dr["mensaje"]?.ToString();

                        if (usuarioId == 0)
                        {
                            datos.Mensaje = mensaje;
                            return false;
                        }

                        datos.UsuarioId = usuarioId;
                        datos.Mensaje = mensaje;

                        return true;
                    }
                }
            }
            catch (SqlException ex)
            {
                datos.Mensaje = "Error SQL: " + ex.Message;
                return false;
            }
            catch (Exception ex)
            {
                datos.Mensaje = "Error general: " + ex.Message;
                return false;
            }
        }


    }
}