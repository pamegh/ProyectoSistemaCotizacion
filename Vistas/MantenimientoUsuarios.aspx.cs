using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class MantenimientoUsuarios : System.Web.UI.Page
    {
        private ctrUsuario ctr = new ctrUsuario();

        protected void Page_Load(object sender, EventArgs e)
        {
            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

            if (usuarioSesion == null || usuarioSesion.Rol == null ||
                usuarioSesion.Rol.ToUpper() != "ADMIN")
            {
                Response.Redirect("~/Vistas/Login.aspx");
                return;
            }

            if (!IsPostBack)
                CargarUsuarios();
        }

        private void CargarUsuarios()
        {
            gvUsuarios.DataSource = ctr.ListarUsuarios();
            gvUsuarios.DataBind();
        }

        protected void gvUsuarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

            // ── EDITAR: abrir panel con datos del usuario ─────────────────
            if (e.CommandName == "Editar")
            {
                int usuarioId = Convert.ToInt32(e.CommandArgument);
                mdlUsuario u = ctr.ObtenerUsuarioPorId(usuarioId);

                if (u == null || u.UsuarioId == 0)
                {
                    MostrarMensaje("No se pudo cargar el usuario.", false);
                    return;
                }

                hfUsuarioId.Value = u.UsuarioId.ToString();
                txtIdentificacionEdit.Text = u.Identificacion;
                txtNombreEdit.Text = u.NombreCompleto;
                txtTelefonoEdit.Text = u.Telefono;
                txtCorreoEdit.Text = u.Correo;

                pnlEditar.Visible = true;

                // Scroll al panel
                ScriptManager.RegisterStartupScript(this, GetType(), "scroll",
                    "window.setTimeout(function(){ document.getElementById('" +
                    pnlEditar.ClientID + "').scrollIntoView({behavior:'smooth'}); }, 100);",
                    true);
            }

            // ── CAMBIAR ROL ───────────────────────────────────────────────
            if (e.CommandName == "CambiarRol")
            {
                string[] partes = e.CommandArgument.ToString().Split('|');
                int usuarioId = Convert.ToInt32(partes[0]);
                string rolActual = partes[1];

                if (usuarioId == usuarioSesion.UsuarioId)
                {
                    MostrarMensaje("No puede cambiar su propio rol.", false);
                    return;
                }

                string nuevoRol = rolActual.ToUpper() == "ADMIN" ? "NORMAL" : "ADMIN";

                bool ok = ctr.CambiarRolUsuario(usuarioId, nuevoRol, usuarioSesion.Correo);

                MostrarMensaje(
                    ok ? "Rol cambiado a '" + nuevoRol + "' correctamente."
                       : "Error al cambiar el rol del usuario.", ok);

                CargarUsuarios();
            }

            // ── CAMBIAR ESTADO ────────────────────────────────────────────
            if (e.CommandName == "Estado")
            {
                string[] datos = e.CommandArgument.ToString().Split('|');
                int usuarioId = Convert.ToInt32(datos[0]);
                string estadoActual = datos[1];

                if (usuarioId == usuarioSesion.UsuarioId)
                {
                    MostrarMensaje("No puede cambiar su propio estado.", false);
                    return;
                }

                string nuevoEstado = estadoActual == "Activo" ? "Inactivo" : "Activo";

                bool ok = ctr.CambiarEstadoUsuario(usuarioId, nuevoEstado);

                MostrarMensaje(
                    ok ? "Usuario " + nuevoEstado.ToLower() + " correctamente."
                       : "Error al cambiar el estado del usuario.", ok);

                CargarUsuarios();
            }
        }

        // ── GUARDAR EDICIÓN ───────────────────────────────────────────────
        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

            if (string.IsNullOrWhiteSpace(txtNombreEdit.Text))
            {
                MostrarMensaje("El nombre es obligatorio.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtCorreoEdit.Text))
            {
                MostrarMensaje("El correo es obligatorio.", false);
                return;
            }

            int usuarioId = Convert.ToInt32(hfUsuarioId.Value);

            // Obtener datos actuales para conservar identificacion, tipo y rol
            mdlUsuario actual = ctr.ObtenerUsuarioPorId(usuarioId);

            mdlUsuario datos = new mdlUsuario
            {
                UsuarioId = usuarioId,
                // Identificacion y tipo NO cambian desde administración
                Identificacion = actual.Identificacion,
                TipoIdentificacionId = actual.TipoIdentificacionId,
                // Rol NO se cambia desde este panel (se cambia con el botón de rol)
                Rol = actual.Rol,
                // Datos editables
                NombreCompleto = txtNombreEdit.Text.Trim(),
                Telefono = txtTelefonoEdit.Text.Trim(),
                Correo = txtCorreoEdit.Text.Trim()
            };

            bool ok = ctr.ActualizarUsuario(datos, null, null);

            if (ok)
            {
                pnlEditar.Visible = false;
                MostrarMensaje("Usuario actualizado correctamente.", true);
                CargarUsuarios();
            }
            else
            {
                MostrarMensaje("Error al actualizar: " + datos.Mensaje, false);
            }
        }

        // ── CANCELAR EDICIÓN ──────────────────────────────────────────────
        protected void btnCancelarEdicion_Click(object sender, EventArgs e)
        {
            pnlEditar.Visible = false;
            lblMensaje.Visible = false;
        }

        // ── ROW DATA BOUND ────────────────────────────────────────────────
        protected void gvUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];
            mdlUsuario usuario = (mdlUsuario)e.Row.DataItem;

            // Colorear label estado
            Label lblEstado = (Label)e.Row.FindControl("lblEstado");
            if (lblEstado != null)
                lblEstado.CssClass = lblEstado.Text == "Activo"
                    ? "estado-activo" : "estado-inactivo";

            LinkButton btnRol = (LinkButton)e.Row.FindControl("btnCambiarRol");
            LinkButton btnEstado = (LinkButton)e.Row.FindControl("btnCambiarEstado");

            if (usuario == null) return;

            // Deshabilitar botones para el propio usuario logueado
            if (usuario.UsuarioId == usuarioSesion.UsuarioId)
            {
                if (btnRol != null)
                {
                    btnRol.Enabled = false;
                    btnRol.CssClass = "btn-action btn-disabled";
                    btnRol.OnClientClick = "return false;";
                    btnRol.ToolTip = "No puede modificar su propia cuenta";
                }
                if (btnEstado != null)
                {
                    btnEstado.Enabled = false;
                    btnEstado.CssClass = "btn-action btn-disabled";
                    btnEstado.OnClientClick = "return false;";
                    btnEstado.ToolTip = "No puede modificar su propia cuenta";
                }
                return;
            }

            // Icono del botón de rol según el rol actual
            if (btnRol != null)
            {
                if (usuario.Rol != null && usuario.Rol.ToUpper() == "ADMIN")
                {
                    btnRol.CssClass = "btn-action btn-admin-activo";
                    btnRol.ToolTip = "Quitar Admin (pasar a Normal)";
                    btnRol.Text = "<i class='fa-solid fa-user-slash'></i>";
                }
                else
                {
                    btnRol.CssClass = "btn-action";
                    btnRol.ToolTip = "Hacer Administrador";
                    btnRol.Text = "<i class='fa-solid fa-user-shield'></i>";
                }
            }
        }

        // ── BUSCAR ────────────────────────────────────────────────────────
        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            string nombre = txtBuscar.Text.Trim().ToLower();

            if (string.IsNullOrEmpty(nombre))
            {
                CargarUsuarios();
                return;
            }

            var lista = ctr.ListarUsuarios()
                .Where(u => u.NombreCompleto.ToLower().Contains(nombre))
                .ToList();

            gvUsuarios.DataSource = lista;
            gvUsuarios.DataBind();
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = esExito ? "mensaje mensaje-exito" : "mensaje mensaje-error";
            lblMensaje.Visible = true;
        }
    }
}