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
        ctrTipoIdentificacion ctrTipoIdentificacion = new ctrTipoIdentificacion();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Configurar ValidationSettings para evitar error de jQuery
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
        }

        private void CargarTiposIdentificacion()
        {
            try
            {
                List<mdlTipoIdentificacion> tipos = ctrTipoIdentificacion.ObtenerTodos();
                
                ddlTipoIdentificacion.Items.Clear();
                ddlTipoIdentificacion.Items.Add(new ListItem("-- Seleccione --", "0"));
                
                foreach (var tipo in tipos)
                {
                    ddlTipoIdentificacion.Items.Add(new ListItem(tipo.Nombre, tipo.TipoIdentificacionId.ToString()));
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar tipos de identificación: " + ex.Message, false);
            }
        }

        private void CargarDatos(int usuarioId)
        {
            try
            {
                mdlUsuario usuario = ctrUsuario.ObtenerUsuarioPorId(usuarioId);

                if (usuario != null && usuario.UsuarioId > 0)
                {
                    // Debug: Verificar datos
                    System.Diagnostics.Debug.WriteLine($"Usuario ID: {usuario.UsuarioId}");
                    System.Diagnostics.Debug.WriteLine($"Tipo ID: {usuario.TipoIdentificacionId}");
                    System.Diagnostics.Debug.WriteLine($"Identificacion: {usuario.Identificacion}");
                    System.Diagnostics.Debug.WriteLine($"Nombre: {usuario.NombreCompleto}");
                    
                    // Cargar datos en los campos de texto
                    txtIdentificacion.Text = usuario.Identificacion ?? "";
                    txtNombre.Text = usuario.NombreCompleto ?? "";
                    txtTelefono.Text = usuario.Telefono ?? "";
                    txtCorreo.Text = usuario.Correo ?? "";
                    
                    // Seleccionar el tipo de identificación si existe en el dropdown
                    if (usuario.TipoIdentificacionId > 0)
                    {
                        string valorTipoId = usuario.TipoIdentificacionId.ToString();
                        ListItem item = ddlTipoIdentificacion.Items.FindByValue(valorTipoId);
                        
                        if (item != null)
                        {
                            ddlTipoIdentificacion.SelectedValue = valorTipoId;
                            System.Diagnostics.Debug.WriteLine($"Dropdown seleccionado: {valorTipoId}");
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"No se encontró el valor {valorTipoId} en el dropdown");
                            ddlTipoIdentificacion.SelectedIndex = 0;
                        }
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine("TipoIdentificacionId es 0 o negativo");
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
                System.Diagnostics.Debug.WriteLine($"Error en CargarDatos: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"StackTrace: {ex.StackTrace}");
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
            // Redirigir al Dashboard del Administrador
            Response.Redirect("~/Vistas/DashboardAdministrador.aspx");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Validar que la página sea válida
            if (!Page.IsValid)
            {
                MostrarMensaje("Por favor, corrija los errores en el formulario.", false);
                return;
            }

            try
            {
                mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

                // Crear objeto con los datos del formulario
                mdlUsuario usuario = new mdlUsuario
                {
                    UsuarioId = usuarioSesion.UsuarioId,
                    TipoIdentificacionId = Convert.ToInt32(ddlTipoIdentificacion.SelectedValue),
                    Identificacion = txtIdentificacion.Text.Trim(),
                    NombreCompleto = txtNombre.Text.Trim(),
                    Telefono = txtTelefono.Text.Trim(),
                    Correo = txtCorreo.Text.Trim()
                };

                string actual = null;
                string nueva = null;

                // Si el panel de contraseña está visible y hay valores
                if (pnlCambioContrasena.Visible)
                {
                    if (!string.IsNullOrWhiteSpace(txtActual.Text) && !string.IsNullOrWhiteSpace(txtNueva.Text))
                    {
                        // Validar que las contraseñas coincidan
                        if (txtNueva.Text != txtConfirmarNueva.Text)
                        {
                            MostrarMensaje("Las contraseñas no coinciden.", false);
                            return;
                        }

                        // Encriptar contraseñas
                        actual = SeguridadContrasena.CalcularSHA256(txtActual.Text);
                        nueva = SeguridadContrasena.CalcularSHA256(txtNueva.Text);
                    }
                    else if (!string.IsNullOrWhiteSpace(txtActual.Text) || !string.IsNullOrWhiteSpace(txtNueva.Text))
                    {
                        MostrarMensaje("Debe completar ambos campos de contraseña para cambiarla.", false);
                        return;
                    }
                }

                // Intentar actualizar
                bool resultado = ctrUsuario.ActualizarUsuario(usuario, actual, nueva);

                if (resultado)
                {
                    // Actualizar datos de sesión
                    usuarioSesion.TipoIdentificacionId = usuario.TipoIdentificacionId;
                    usuarioSesion.Identificacion = usuario.Identificacion;
                    usuarioSesion.NombreCompleto = usuario.NombreCompleto;
                    usuarioSesion.Telefono = usuario.Telefono;
                    usuarioSesion.Correo = usuario.Correo;
                    Session["Usuario"] = usuarioSesion;

                    // Limpiar campos de contraseña si se actualizó
                    if (pnlCambioContrasena.Visible && actual != null)
                    {
                        txtActual.Text = "";
                        txtNueva.Text = "";
                        txtConfirmarNueva.Text = "";
                        pnlCambioContrasena.Visible = false;
                        
                        // Deshabilitar validadores
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