using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Web.UI;

namespace SistemaCotizacionAPF.Vistas
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Página de login cargada
        }

        protected void btnIniciarSesion_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string correo = txtUsuario.Text.Trim();
            string claveSesionIntentos = "IntentosLogin_" + correo;

            mdlUsuario datos = new mdlUsuario();
            datos.Correo = correo;
            datos.Contrasena = txtContrasena.Text.Trim();

            ctrUsuario controlador = new ctrUsuario();
    
            if (controlador.ValidarIngreso(datos))
            {
                // Login exitoso - Limpiar intentos fallidos
                Session.Remove(claveSesionIntentos);

                Session["Usuario"] = datos;
                Session["UsuarioId"] = datos.UsuarioId;
                Session["Nombre"] = datos.NombreCompleto;
                Session["Identificacion"] = datos.Identificacion;
                Session["Rol"] = datos.Rol;

                MostrarMensaje("¡Bienvenido " + datos.NombreCompleto + "!", "exito");

                if (datos.Rol != null && datos.Rol.ToUpper() == "ADMIN")
                {
                    Response.Redirect("~/Vistas/DashboardAdministrador.aspx");
                }
                else
                {
                    Response.Redirect("~/Vistas/DashboardUsuario.aspx");
                }
            }
            else
            {
                // Verificar si la cuenta está desactivada
                if (datos.Mensaje != null && datos.Mensaje.ToLower().Contains("desactivada"))
                {
                    MostrarMensaje(datos.Mensaje, "error");
                    txtUsuario.Focus();
                    return;
                }

                // Verificar si el usuario no existe
                if (datos.Mensaje != null && datos.Mensaje.ToLower().Contains("no existe"))
                {
                    MostrarMensaje(datos.Mensaje, "error");
                    txtUsuario.Focus();
                    return;
                }

                // Contar intentos fallidos si el error es de contraseña incorrecta
                if (datos.Mensaje != null && 
                    (datos.Mensaje.ToLower().Contains("contrasena") || 
                     datos.Mensaje.ToLower().Contains("contraseña") ||
                     datos.Mensaje.ToLower().Contains("incorrecta")))
                {
                    int intentos = Session[claveSesionIntentos] != null 
                        ? (int)Session[claveSesionIntentos] 
                        : 0;
                    
                    intentos++;
                    Session[claveSesionIntentos] = intentos;

                    if (intentos >= 3)
                    {
                        // Desactivar usuario en la base de datos
                        mdlUsuario usuarioBloqueado = controlador.ObtenerUsuarioPorCorreo(correo);
                        
                        if (usuarioBloqueado != null && usuarioBloqueado.UsuarioId > 0)
                        {
                            controlador.CambiarEstadoUsuario(usuarioBloqueado.UsuarioId, "Inactivo", "Sistema");
                        }
                        
                        Session.Remove(claveSesionIntentos);
                        
                        MostrarMensaje("Su cuenta ha sido desactivada por múltiples intentos fallidos. " +
                                       "Contacte al administrador para reactivarla.", "error");
                    }
                    else
                    {
                        int intentosRestantes = 3 - intentos;
                        MostrarMensaje("Usuario o contraseña incorrectos. Le quedan " + intentosRestantes + " intento(s) " +
                                       "antes de que su cuenta sea desactivada.", "error");
                    }
                    
                    txtContrasena.Text = "";
                    txtContrasena.Focus();
                }
                else
                {
                    // Para cualquier otro error
                    MostrarMensaje(datos.Mensaje, "error");
                    txtContrasena.Text = "";
                    txtContrasena.Focus();
                }
            }
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.Visible = true;

            if (tipo == "error")
                lblMensaje.CssClass = "mensaje mensaje-error";
            else if (tipo == "exito")
                lblMensaje.CssClass = "mensaje mensaje-exito";
            else
                lblMensaje.CssClass = "mensaje";
        }
    }
}