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
                            ? Convert.ToInt32(dr["usuario_id"]) : 0;

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
            catch (SqlException ex) { datos.Mensaje = "Error SQL: " + ex.Message; return false; }
            catch (Exception ex) { datos.Mensaje = "Error general: " + ex.Message; return false; }
        }

        public bool RegistrarUsuario(mdlUsuario datos)
        {
            if (datos == null) return false;

            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_RegistrarUsuario", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@identificacion", SqlDbType.VarChar, 30).Value = datos.Identificacion?.Trim();
                    cmd.Parameters.Add("@nombre_completo", SqlDbType.VarChar, 150).Value = datos.NombreCompleto?.Trim();
                    cmd.Parameters.Add("@telefono", SqlDbType.VarChar, 20).Value =
                        string.IsNullOrWhiteSpace(datos.Telefono) ? (object)DBNull.Value : datos.Telefono.Trim();
                    cmd.Parameters.Add("@correo", SqlDbType.VarChar, 100).Value = datos.Correo?.Trim();
                    cmd.Parameters.Add("@contrasena", SqlDbType.VarChar, 255).Value =
                        SeguridadContrasena.CalcularSHA256(datos.Contrasena.Trim());
                    cmd.Parameters.Add("@tipo_identificacion_id", SqlDbType.Int).Value = datos.TipoIdentificacionId;
                    cmd.Parameters.Add("@creado_por", SqlDbType.VarChar, 50).Value = "Sistema";

                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (!dr.Read())
                        {
                            datos.Mensaje = "No se pudo registrar el usuario.";
                            return false;
                        }

                        int usuarioId = dr["usuario_id"] != DBNull.Value
                            ? Convert.ToInt32(dr["usuario_id"]) : 0;

                        string mensaje = dr["mensaje"]?.ToString();

                        if (usuarioId == 0) { datos.Mensaje = mensaje; return false; }

                        datos.UsuarioId = usuarioId;
                        datos.Mensaje = mensaje;
                        return true;
                    }
                }
            }
            catch (SqlException ex) { datos.Mensaje = "Error SQL: " + ex.Message; return false; }
            catch (Exception ex) { datos.Mensaje = "Error general: " + ex.Message; return false; }
        }

        public mdlUsuario ObtenerUsuarioPorId(int usuarioId)
        {
            mdlUsuario usuario = new mdlUsuario();

            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_ObtenerUsuarioPorId", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;
                    cmd.Parameters.AddWithValue("@usuario_id", usuarioId);

                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            usuario.UsuarioId = dr["usuario_id"] != DBNull.Value ? Convert.ToInt32(dr["usuario_id"]) : 0;
                            usuario.TipoIdentificacionId = dr["tipo_identificacion_id"] != DBNull.Value ? Convert.ToInt32(dr["tipo_identificacion_id"]) : 0;
                            usuario.Identificacion = dr["identificacion"] != DBNull.Value ? dr["identificacion"].ToString() : "";
                            usuario.NombreCompleto = dr["nombre_completo"] != DBNull.Value ? dr["nombre_completo"].ToString() : "";
                            usuario.Telefono = dr["telefono"] != DBNull.Value ? dr["telefono"].ToString() : "";
                            usuario.Correo = dr["correo"] != DBNull.Value ? dr["correo"].ToString() : "";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ObtenerUsuarioPorId: " + ex.Message);
            }

            return usuario;
        }

        public bool ActualizarUsuario(mdlUsuario datos, string contrasenaActual = null, string contrasenaNueva = null)
        {
            if (datos == null)
            {
                datos = new mdlUsuario();
                datos.Mensaje = "Datos de usuario inválidos.";
                return false;
            }

            if (datos.TipoIdentificacionId <= 0)
            {
                datos.Mensaje = "Debe seleccionar un tipo de identificación.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(datos.Identificacion))
            {
                datos.Mensaje = "La identificación es requerida.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(datos.NombreCompleto))
            {
                datos.Mensaje = "El nombre completo es requerido.";
                return false;
            }
            if (datos.NombreCompleto.Trim().Length < 3)
            {
                datos.Mensaje = "El nombre completo debe tener al menos 3 caracteres.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(datos.Telefono))
            {
                datos.Mensaje = "El teléfono es requerido.";
                return false;
            }
            string telLimpio = datos.Telefono.Trim().Replace("-", "").Replace(" ", "");
            if (!System.Text.RegularExpressions.Regex.IsMatch(telLimpio, @"^[24678]\d{7}$"))
            {
                datos.Mensaje = "El teléfono debe tener 8 dígitos y ser un número costarricense válido (inicia con 2, 4, 6, 7 u 8).";
                return false;
            }

            if (string.IsNullOrWhiteSpace(datos.Correo))
            {
                datos.Mensaje = "El correo es requerido.";
                return false;
            }
            if (!System.Text.RegularExpressions.Regex.IsMatch(datos.Correo, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                datos.Mensaje = "El formato del correo es inválido.";
                return false;
            }

            if (!string.IsNullOrEmpty(contrasenaActual) && !string.IsNullOrEmpty(contrasenaNueva))
            {
                if (contrasenaNueva.Length < 6)
                {
                    datos.Mensaje = "La nueva contraseña debe tener al menos 6 caracteres.";
                    return false;
                }
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_ActualizarUsuario", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@usuario_id", SqlDbType.Int).Value = datos.UsuarioId;
                    cmd.Parameters.Add("@tipo_identificacion_id", SqlDbType.Int).Value = datos.TipoIdentificacionId;
                    cmd.Parameters.Add("@identificacion", SqlDbType.VarChar, 30).Value = datos.Identificacion.Trim();
                    cmd.Parameters.Add("@nombre_completo", SqlDbType.VarChar, 150).Value = datos.NombreCompleto.Trim();
                    cmd.Parameters.Add("@telefono", SqlDbType.VarChar, 20).Value = datos.Telefono.Trim();
                    cmd.Parameters.Add("@correo", SqlDbType.VarChar, 100).Value = datos.Correo.Trim();

                    cmd.Parameters.Add("@contrasena_actual", SqlDbType.VarChar, 255).Value =
                        string.IsNullOrEmpty(contrasenaActual) ? (object)DBNull.Value : contrasenaActual;
                    cmd.Parameters.Add("@contrasena_nueva", SqlDbType.VarChar, 255).Value =
                        string.IsNullOrEmpty(contrasenaNueva) ? (object)DBNull.Value : contrasenaNueva;

                    cmd.Parameters.Add("@modificado_por", SqlDbType.VarChar, 50).Value = "Sistema";

                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            datos.Mensaje = dr["mensaje"]?.ToString() ?? "Error al actualizar usuario.";
                            return Convert.ToInt32(dr["resultado"]) == 1;
                        }
                    }
                }
            }
            catch (SqlException ex) { datos.Mensaje = "Error SQL: " + ex.Message; return false; }
            catch (Exception ex) { datos.Mensaje = "Error general: " + ex.Message; return false; }

            datos.Mensaje = "No se pudo actualizar el usuario.";
            return false;
        }

        public bool CambiarEstadoUsuario(int usuarioId, string estado)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_CambiarEstadoUsuario", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@usuario_id", SqlDbType.Int).Value = usuarioId;
                    cmd.Parameters.Add("@estado", SqlDbType.VarChar, 20).Value = estado;
                    cmd.Parameters.Add("@modificado_por", SqlDbType.VarChar, 50).Value = "Sistema";

                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                            return Convert.ToInt32(dr["resultado"]) == 1;
                    }
                }
            }
            catch (SqlException ex) { System.Diagnostics.Debug.WriteLine("SQL Error en CambiarEstadoUsuario: " + ex.Message); }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Error en CambiarEstadoUsuario: " + ex.Message); }

            return false;
        }

        public List<mdlUsuario> ListarUsuarios()
        {
            List<mdlUsuario> lista = new List<mdlUsuario>();

            using (SqlConnection conn = new SqlConnection(_SQLConnection))
            using (SqlCommand cmd = new SqlCommand("sp_ListarUsuarios", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        mdlUsuario usuario = new mdlUsuario();
                        usuario.UsuarioId = Convert.ToInt32(dr["usuario_id"]);
                        usuario.Identificacion = dr["identificacion"].ToString();
                        usuario.NombreCompleto = dr["nombre_completo"].ToString();
                        usuario.Telefono = dr["telefono"].ToString();
                        usuario.Correo = dr["correo"].ToString();
                        usuario.Rol = dr["rol"].ToString();
                        usuario.Estado = dr["estado"].ToString();
                        lista.Add(usuario);
                    }
                }
            }
            return lista;
        }

        public mdlEstadisticasDashboard ObtenerEstadisticasDashboard()
        {
            mdlEstadisticasDashboard estadisticas = new mdlEstadisticasDashboard();

            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_ObtenerEstadisticasDashboard", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;
                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            estadisticas.TotalUsuarios = dr["total_usuarios"] != DBNull.Value ? Convert.ToInt32(dr["total_usuarios"]) : 0;
                            estadisticas.CotizacionesActivas = dr["cotizaciones_activas"] != DBNull.Value ? Convert.ToInt32(dr["cotizaciones_activas"]) : 0;
                            estadisticas.ReportesGenerados = dr["reportes_generados"] != DBNull.Value ? Convert.ToInt32(dr["reportes_generados"]) : 0;
                            estadisticas.ProductosDisponibles = dr["productos_disponibles"] != DBNull.Value ? Convert.ToInt32(dr["productos_disponibles"]) : 0;
                        }
                    }
                }
            }
            catch (Exception)
            {
                estadisticas.TotalUsuarios = 0;
                estadisticas.CotizacionesActivas = 0;
                estadisticas.ReportesGenerados = 0;
                estadisticas.ProductosDisponibles = 0;
            }

            return estadisticas;
        }

        public bool CambiarRolUsuario(int usuarioId, string nuevoRol, string modificadoPor)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_SQLConnection))
                using (SqlCommand cmd = new SqlCommand("sp_CambiarRolUsuario", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@usuario_id", SqlDbType.Int).Value = usuarioId;
                    cmd.Parameters.Add("@rol", SqlDbType.VarChar, 50).Value = nuevoRol;
                    cmd.Parameters.Add("@modificado_por", SqlDbType.VarChar, 50).Value = modificadoPor;

                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                            return Convert.ToInt32(dr["resultado"]) == 1;
                    }
                }
            }
            catch (SqlException ex) { System.Diagnostics.Debug.WriteLine("SQL Error en CambiarRolUsuario: " + ex.Message); return false; }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Error en CambiarRolUsuario: " + ex.Message); return false; }

            return false;
        }
    }
}