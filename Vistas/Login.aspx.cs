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

            mdlUsuario datos = new mdlUsuario();

            datos.Correo = txtUsuario.Text.Trim();
            datos.Contrasena = txtContrasena.Text.Trim();

            ctrUsuario controlador = new ctrUsuario();

            if (controlador.ValidarIngreso(datos))
            {
                Session["Usuario"] = datos;

                MostrarMensaje("¡Bienvenido " + datos.NombreCompleto + "!", "exito");

                
                Response.AddHeader("REFRESH", "1.5;URL=Dashboard.aspx");
            }
            else
            {
                MostrarMensaje(datos.Mensaje, "error");
            }
        }

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