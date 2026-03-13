using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class MiCuenta : System.Web.UI.Page
    {
        private ctrUsuario ctrUsuario = new ctrUsuario();
        private ctrTipoIdentificacion ctrTipoIdentificacion = new ctrTipoIdentificacion();

        // Propiedad pública leída desde el ASPX con <%= %>
        public string TiposIdentificacionJson { get; private set; }

        public MiCuenta()
        {
            TiposIdentificacionJson = "{}";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;

            if (Session["Usuario"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarTiposIdentificacion();
                mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];
                CargarDatos(usuarioSesion.UsuarioId);
            }
            else
            {
                GenerarTiposJson(null);
            }
        }

        private void CargarTiposIdentificacion()
        {
            try
            {
                List<mdlTipoIdentificacion> tipos = ctrTipoIdentificacion.ObtenerTodos();

                ddlTipoIdentificacion.Items.Clear();
                ddlTipoIdentificacion.Items.Add(new ListItem("-- Seleccione --", "0"));

                foreach (mdlTipoIdentificacion tipo in tipos)
                {
                    ddlTipoIdentificacion.Items.Add(
                        new ListItem(tipo.Nombre, tipo.TipoIdentificacionId.ToString()));
                }

                GenerarTiposJson(tipos);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar tipos de identificación: " + ex.Message, false);
            }
        }

        private void GenerarTiposJson(List<mdlTipoIdentificacion> tipos)
        {
            if (tipos == null)
            {
                try { tipos = ctrTipoIdentificacion.ObtenerTodos(); }
                catch { return; }
            }

            StringBuilder sb = new StringBuilder("{");
            bool primero = true;

            foreach (mdlTipoIdentificacion t in tipos)
            {
                string placeholder = GenerarPlaceholder(t);
                string hint = GenerarHint(t);

                if (!primero) sb.Append(",");

                sb.Append("\"" + t.TipoIdentificacionId + "\":{");
                sb.Append("\"placeholder\":\"" + placeholder + "\",");
                sb.Append("\"hint\":\"" + hint + "\",");
                sb.Append("\"maxLength\":" + t.LongitudMax + ",");
                sb.Append("\"soloNumerico\":" + (t.SoloNumerico ? "true" : "false"));
                sb.Append("}");

                primero = false;
            }

            sb.Append("}");
            TiposIdentificacionJson = sb.ToString();
        }

        private string GenerarPlaceholder(mdlTipoIdentificacion t)
        {
            switch (t.TipoIdentificacionId)
            {
                case 1: return "Ej: 1-1234-1234";
                case 2: return "Ej: 3-123-123456";
                case 3: return "Ej: 11234567890";
                case 4: return "Ej: A1234567";
                default:
                    return t.LongitudMin == t.LongitudMax
                        ? t.LongitudMin + " caracteres"
                        : t.LongitudMin + "-" + t.LongitudMax + " caracteres";
            }
        }

        private string GenerarHint(mdlTipoIdentificacion t)
        {
            switch (t.TipoIdentificacionId)
            {
                case 1: return "Cedula Fisica: formato X-XXXX-XXXX";
                case 2: return "Cedula Juridica: formato 3-XXX-XXXXXX";
                case 3: return "DIMEX: 11 o 12 digitos";
                case 4: return "Pasaporte: 6 a 20 caracteres alfanumericos";
                default:
                    return t.SoloNumerico
                        ? (t.Nombre + ": " + t.LongitudMin + "-" + t.LongitudMax + " digitos")
                        : (t.Nombre + ": " + t.LongitudMin + "-" + t.LongitudMax + " caracteres");
            }
        }

        private void CargarDatos(int usuarioId)
        {
            try
            {
                mdlUsuario usuario = ctrUsuario.ObtenerUsuarioPorId(usuarioId);

                if (usuario != null && usuario.UsuarioId > 0)
                {
                    txtIdentificacion.Text = usuario.Identificacion ?? "";
                    txtNombre.Text = usuario.NombreCompleto ?? "";
                    txtTelefono.Text = usuario.Telefono ?? "";
                    txtCorreo.Text = usuario.Correo ?? "";

                    if (usuario.TipoIdentificacionId > 0)
                    {
                        string valorTipoId = usuario.TipoIdentificacionId.ToString();
                        ListItem item = ddlTipoIdentificacion.Items.FindByValue(valorTipoId);
                        if (item != null)
                            ddlTipoIdentificacion.SelectedValue = valorTipoId;
                        else
                            ddlTipoIdentificacion.SelectedIndex = 0;
                    }
                    else
                    {
                        ddlTipoIdentificacion.SelectedIndex = 0;
                    }
                }
                else
                {
                    MostrarMensaje("No se pudieron cargar los datos del usuario.", false);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar datos: " + ex.Message, false);
            }
        }

        protected void btnMostrarCambio_Click(object sender, EventArgs e)
        {
            pnlCambioContrasena.Visible = !pnlCambioContrasena.Visible;

            rfvActual.Enabled = pnlCambioContrasena.Visible;
            rfvNueva.Enabled = pnlCambioContrasena.Visible;
            revNueva.Enabled = pnlCambioContrasena.Visible;
            cvConfirmar.Enabled = pnlCambioContrasena.Visible;

            if (pnlCambioContrasena.Visible)
            {
                txtActual.Text = "";
                txtNueva.Text = "";
                txtConfirmarNueva.Text = "";
            }

            lblMensaje.Text = "";
        }

        protected void btnAtras_Click(object sender, EventArgs e)
        {
            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

            if (usuarioSesion != null && usuarioSesion.Rol != null &&
                usuarioSesion.Rol.ToUpper() == "ADMIN")
                Response.Redirect("~/Vistas/DashboardAdministrador.aspx");
            else
                Response.Redirect("~/Vistas/DashboardUsuario.aspx");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                MostrarMensaje("Por favor, corrija los errores en el formulario.", false);
                return;
            }

            try
            {
                mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

                mdlUsuario usuario = new mdlUsuario();
                usuario.UsuarioId = usuarioSesion.UsuarioId;
                usuario.TipoIdentificacionId = Convert.ToInt32(ddlTipoIdentificacion.SelectedValue);
                usuario.Identificacion = txtIdentificacion.Text.Trim();
                usuario.NombreCompleto = txtNombre.Text.Trim();
                usuario.Telefono = txtTelefono.Text.Trim();
                usuario.Correo = txtCorreo.Text.Trim();

                string actual = null;
                string nueva = null;

                if (pnlCambioContrasena.Visible)
                {
                    if (!string.IsNullOrWhiteSpace(txtActual.Text) &&
                        !string.IsNullOrWhiteSpace(txtNueva.Text))
                    {
                        if (txtNueva.Text != txtConfirmarNueva.Text)
                        {
                            MostrarMensaje("Las contraseñas no coinciden.", false);
                            return;
                        }
                        actual = SeguridadContrasena.CalcularSHA256(txtActual.Text);
                        nueva = SeguridadContrasena.CalcularSHA256(txtNueva.Text);
                    }
                    else if (!string.IsNullOrWhiteSpace(txtActual.Text) ||
                             !string.IsNullOrWhiteSpace(txtNueva.Text))
                    {
                        MostrarMensaje("Debe completar ambos campos de contraseña para cambiarla.", false);
                        return;
                    }
                }

                bool resultado = ctrUsuario.ActualizarUsuario(usuario, actual, nueva);

                if (resultado)
                {
                    usuarioSesion.TipoIdentificacionId = usuario.TipoIdentificacionId;
                    usuarioSesion.Identificacion = usuario.Identificacion;
                    usuarioSesion.NombreCompleto = usuario.NombreCompleto;
                    usuarioSesion.Telefono = usuario.Telefono;
                    usuarioSesion.Correo = usuario.Correo;
                    Session["Usuario"] = usuarioSesion;

                    if (pnlCambioContrasena.Visible && actual != null)
                    {
                        txtActual.Text = "";
                        txtNueva.Text = "";
                        txtConfirmarNueva.Text = "";
                        pnlCambioContrasena.Visible = false;

                        rfvActual.Enabled = false;
                        rfvNueva.Enabled = false;
                        revNueva.Enabled = false;
                        cvConfirmar.Enabled = false;
                    }

                    MostrarMensaje(usuario.Mensaje, true);
                }
                else
                {
                    MostrarMensaje(usuario.Mensaje, false);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al guardar cambios: " + ex.Message, false);
            }
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = esExito ? "mensaje mensaje-exito" : "mensaje mensaje-error";
        }
    }
}