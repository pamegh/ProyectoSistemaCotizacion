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

        // Evento Click para btnIniciarSesion - Solo muestra mensaje por ahora
        protected void btnIniciarSesion_Click(object sender, EventArgs e)
        {
            // Validar que la página sea válida
            if (!Page.IsValid)
            {
                return;
            }

            // Obtener credenciales ingresadas
            string usuario = txtUsuario.Text.Trim();
            string contrasena = txtContrasena.Text.Trim();

            // Validación simple - Solo visual por ahora
            if (usuario == "admin" && contrasena == "admin123")
            {
                MostrarMensaje("¡Bienvenido Administrador! (Funcionalidad en desarrollo)", "exito");
                // TODO: Redirigir a DashboardAdmin.aspx cuando esté listo
            }
            else if (usuario == "allison" && contrasena == "123456")
            {
                MostrarMensaje("¡Bienvenida Allison! (Funcionalidad en desarrollo)", "exito");
                // TODO: Redirigir a DashboardCliente.aspx cuando esté listo
            }
            else
            {
                MostrarMensaje("Usuario o contraseña incorrectos. Intenta con los usuarios de prueba.", "error");
            }
        }

        // Método auxiliar para mostrar mensajes
        private void MostrarMensaje(string mensaje, string tipo)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.Visible = true;

            if (tipo == "error")
            {
                lblMensaje.CssClass = "mensaje mensaje-error";
            }
            else if (tipo == "exito")
            {
                lblMensaje.CssClass = "mensaje mensaje-exito";
            }
            else
            {
                lblMensaje.CssClass = "mensaje";
            }
        }
    }
}