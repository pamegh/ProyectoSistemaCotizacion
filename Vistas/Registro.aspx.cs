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
    public partial class Registro : System.Web.UI.Page
    {
        private ctrTipoIdentificacion controlador = new ctrTipoIdentificacion();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarTiposIdentificacion();
            }
        }

        private void CargarTiposIdentificacion()
        {
            List<mdlTipoIdentificacion> lista = controlador.ObtenerTodos();

            ddlTipoIdentificacion.DataSource = lista;
            ddlTipoIdentificacion.DataTextField = "Nombre";
            ddlTipoIdentificacion.DataValueField = "TipoIdentificacionId";
            ddlTipoIdentificacion.DataBind();

            ddlTipoIdentificacion.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtIdentificacion.Text))
            {
                MostrarMensaje("La identificación es obligatoria.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                MostrarMensaje("El nombre completo es obligatorio.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtCorreo.Text))
            {
                MostrarMensaje("El correo es obligatorio.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtContrasena.Text))
            {
                MostrarMensaje("La contraseña es obligatoria.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(ddlTipoIdentificacion.SelectedValue))
            {
                MostrarMensaje("Debe seleccionar un tipo de identificación.", false);
                return;
            }

            mdlUsuario datos = new mdlUsuario
            {
                Identificacion = txtIdentificacion.Text.Trim(),
                NombreCompleto = txtNombre.Text.Trim(),
                Telefono = txtTelefono.Text.Trim(),
                Correo = txtCorreo.Text.Trim(),
                Contrasena = txtContrasena.Text.Trim(),
                TipoIdentificacionId = Convert.ToInt32(ddlTipoIdentificacion.SelectedValue)
            };

            ctrUsuario controlador = new ctrUsuario();

            if (controlador.RegistrarUsuario(datos))
                MostrarMensaje(datos.Mensaje, true);
            else
                MostrarMensaje(datos.Mensaje, false);
        }

        private void MostrarMensaje(string mensaje, bool exito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.Visible = true;
            lblMensaje.CssClass = exito
                ? "mensaje mensaje-exito"
                : "mensaje mensaje-error";
        }
    }
}