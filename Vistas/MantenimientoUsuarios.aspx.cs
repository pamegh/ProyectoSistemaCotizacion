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
            // Verificar sesión y rol (comparación en mayúsculas igual que el login)
            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

            if (usuarioSesion == null || usuarioSesion.Rol == null ||
                usuarioSesion.Rol.ToUpper() != "ADMIN")
            {
                Response.Redirect("~/Vistas/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarUsuarios();
            }
        }

        private void CargarUsuarios()
        {
            gvUsuarios.DataSource = ctr.ListarUsuarios();
            gvUsuarios.DataBind();
        }

        protected void gvUsuarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

            // ── Cambiar ROL (Usuario <-> Administrador) ──────────────────
            if (e.CommandName == "CambiarRol")
            {
                string[] partes = e.CommandArgument.ToString().Split('|');
                int usuarioId = Convert.ToInt32(partes[0]);
                string rolActual = partes[1];

                // No permitir que el admin se cambie el rol a sí mismo
                if (usuarioId == usuarioSesion.UsuarioId)
                {
                    MostrarMensaje("No puede cambiar su propio rol.", false);
                    return;
                }

                string nuevoRol = rolActual.ToUpper() == "ADMIN" ? "NORMAL" : "ADMIN";

                bool ok = ctr.CambiarRolUsuario(usuarioId, nuevoRol, usuarioSesion.Correo);

                MostrarMensaje(
                    ok ? $"Rol cambiado a '{nuevoRol}' correctamente."
                       : "Error al cambiar el rol del usuario.",
                    ok);

                CargarUsuarios();
            }

            // ── Cambiar ESTADO (Activo <-> Inactivo) ─────────────────────
            if (e.CommandName == "Estado")
            {
                string[] datos = e.CommandArgument.ToString().Split('|');
                int usuarioId = Convert.ToInt32(datos[0]);
                string estadoActual = datos[1];

                // No permitir que el admin se desactive a sí mismo
                if (usuarioId == usuarioSesion.UsuarioId)
                {
                    MostrarMensaje("No puede cambiar su propio estado.", false);
                    return;
                }

                string nuevoEstado = estadoActual == "Activo" ? "Inactivo" : "Activo";

                bool ok = ctr.CambiarEstadoUsuario(usuarioId, nuevoEstado);

                MostrarMensaje(
                    ok ? $"Usuario {nuevoEstado.ToLower()} correctamente."
                       : "Error al cambiar el estado del usuario.",
                    ok);

                CargarUsuarios();
            }
        }

        protected void gvUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];
            mdlUsuario usuario = (mdlUsuario)e.Row.DataItem;

            // Colorear label de estado
            Label lblEstado = (Label)e.Row.FindControl("lblEstado");
            if (lblEstado != null)
            {
                lblEstado.CssClass = lblEstado.Text == "Activo"
                    ? "estado-activo"
                    : "estado-inactivo";
            }

            LinkButton btnRol = (LinkButton)e.Row.FindControl("btnCambiarRol");
            LinkButton btnEstado = (LinkButton)e.Row.FindControl("btnCambiarEstado");

            if (usuario == null) return;

            // Si es el usuario logueado: deshabilitar ambos botones visualmente
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

            // ADMIN  → fa-user-slash dorado  = "quitar admin"
            // NORMAL → fa-user-shield celeste = "hacer admin"
            if (btnRol != null)
            {
                if (usuario.Rol != null && usuario.Rol.ToUpper() == "ADMIN")
                {
                    btnRol.CssClass = "btn-action btn-admin-activo";
                    btnRol.ToolTip = "Quitar Admin (pasar a Cliente)";
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

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            string nombre = txtBuscar.Text.Trim().ToLower();

            if (string.IsNullOrEmpty(nombre))
            {
                CargarUsuarios();
                return;
            }

            var lista = ctr.ListarUsuarios();
            var resultado = lista
                .Where(u => u.NombreCompleto.ToLower().Contains(nombre))
                .ToList();

            gvUsuarios.DataSource = resultado;
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