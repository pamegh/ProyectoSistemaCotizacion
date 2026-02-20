using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class MiCuenta : System.Web.UI.Page
    {
        ctrUsuario ctrUsuario = new ctrUsuario();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["Usuario"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];
                CargarDatos(usuarioSesion.UsuarioId);
            }
        }

        private void CargarDatos(int usuarioId)
        {
            mdlUsuario usuario = ctrUsuario.ObtenerUsuarioPorId(usuarioId);

            txtIdentificacion.Text = usuario.Identificacion;
            txtNombre.Text = usuario.NombreCompleto;
            txtTelefono.Text = usuario.Telefono;
            txtCorreo.Text = usuario.Correo;
        }
        protected void btnMostrarCambio_Click(object sender, EventArgs e)
        {
            pnlCambioContrasena.Visible = !pnlCambioContrasena.Visible;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

            mdlUsuario usuario = new mdlUsuario
            {
                UsuarioId = usuarioSesion.UsuarioId,
                Identificacion = txtIdentificacion.Text,
                NombreCompleto = txtNombre.Text,
                Telefono = txtTelefono.Text,
                Correo = txtCorreo.Text
            };

            string actual = null;
            string nueva = null;

            if (pnlCambioContrasena.Visible && !string.IsNullOrEmpty(txtNueva.Text))
            {
                actual = SeguridadContrasena.CalcularSHA256(txtActual.Text);
                nueva = SeguridadContrasena.CalcularSHA256(txtNueva.Text);
            }

            bool resultado = ctrUsuario.ActualizarUsuario(usuario, actual, nueva);

            lblMensaje.Text = usuario.Mensaje;
            lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
        }
    }
}