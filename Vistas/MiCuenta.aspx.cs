using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class MiCuenta : System.Web.UI.Page
    {
        ctrUsuario ctrUsuario = new ctrUsuario();
        ctrTipoIdentificacion ctrTipoIdentificacion = new ctrTipoIdentificacion();

        // ─────────────────────────────────────────────────────────────────────
        // Genera un diccionario JSON indexado por el ID del tipo:
        //   { "1": { placeholder, hint, maxLength, soloNumerico, patronRegex, longitudMin },
        //     "2": { ... }, ... }
        // El ASPX lo consume con: var configTipos = <%= TiposIdentificacionJson %>;
        // y luego accede con: configTipos[ddl.value]
        //
        // placeholder/hint son amigables para el usuario.
        // La Cedula Juridica exige que inicie con 3 (validado en el servidor tambien).
        // El NITE tiene su propia entrada separada del Pasaporte.
        // Las cedulas se guardan SIN guiones en la BD; el formato visual es solo UX.
        // ─────────────────────────────────────────────────────────────────────
        public string TiposIdentificacionJson
        {
            get
            {
                try
                {
                    List<mdlTipoIdentificacion> tipos = ctrTipoIdentificacion.ObtenerTodos();

                    // Hints y placeholders amigables por codigo de tipo
                    var hints = new Dictionary<string, string[]>
                    {
                        // codigo => [ placeholder, hint ]
                        { "FISICA",    new[]{ "Ej: 123456789",         "9 dígitos numéricos" } },
                        { "JURIDICA",  new[]{ "Ej: 3101234567",        "10 dígitos, debe iniciar con 3" } },
                        { "DIMEX",     new[]{ "Ej: 11712345678",       "11 o 12 dígitos numéricos" } },
                        { "NITE",      new[]{ "Ej: 3012345678",        "10 dígitos numéricos" } },
                        { "PASAPORTE", new[]{ "Ej: A1234567",          "6 a 20 caracteres alfanuméricos" } },
                    };

                    StringBuilder sb = new StringBuilder();
                    sb.Append("{");
                    bool primero = true;

                    foreach (var t in tipos)
                    {
                        if (!primero) sb.Append(",");
                        primero = false;

                        string codigo = (t.Codigo ?? "").Trim().ToUpper();
                        string placeholder = "Ingrese su identificación";
                        string hint = "";

                        if (hints.ContainsKey(codigo))
                        {
                            placeholder = hints[codigo][0];
                            hint = hints[codigo][1];
                        }

                        // Clave: el ID numerico como string (para que configTipos[ddl.value] funcione)
                        sb.AppendFormat("\"{0}\":{{", t.TipoIdentificacionId);
                        sb.AppendFormat("\"placeholder\":\"{0}\",", EscapeJson(placeholder));
                        sb.AppendFormat("\"hint\":\"{0}\",", EscapeJson(hint));
                        sb.AppendFormat("\"maxLength\":{0},", t.LongitudMax);
                        sb.AppendFormat("\"longitudMin\":{0},", t.LongitudMin);
                        sb.AppendFormat("\"soloNumerico\":{0},", t.SoloNumerico ? "true" : "false");
                        sb.AppendFormat("\"patronRegex\":\"{0}\"", EscapeJson(t.PatronRegex));
                        sb.Append("}");
                    }

                    sb.Append("}");
                    return sb.ToString();
                }
                catch
                {
                    return "{}";
                }
            }
        }

        private string EscapeJson(string valor)
        {
            if (string.IsNullOrEmpty(valor)) return "";
            return valor
                .Replace("\\", "\\\\")
                .Replace("\"", "\\\"")
                .Replace("\n", "\\n")
                .Replace("\r", "\\r");
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
        }

        private void CargarTiposIdentificacion()
        {
            try
            {
                List<mdlTipoIdentificacion> tipos = ctrTipoIdentificacion.ObtenerTodos();

                ddlTipoIdentificacion.Items.Clear();
                ddlTipoIdentificacion.Items.Add(new ListItem("-- Seleccione --", "0"));

                foreach (var tipo in tipos)
                    ddlTipoIdentificacion.Items.Add(
                        new ListItem(tipo.Nombre, tipo.TipoIdentificacionId.ToString()));
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
                    txtIdentificacion.Text = usuario.Identificacion ?? "";
                    txtNombre.Text = usuario.NombreCompleto ?? "";
                    txtTelefono.Text = usuario.Telefono ?? "";
                    txtCorreo.Text = usuario.Correo ?? "";

                    if (usuario.TipoIdentificacionId > 0)
                    {
                        string val = usuario.TipoIdentificacionId.ToString();
                        ListItem item = ddlTipoIdentificacion.Items.FindByValue(val);
                        if (item != null)
                            ddlTipoIdentificacion.SelectedValue = val;
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
            Response.Redirect("~/Vistas/DashboardAdministrador.aspx");
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
                // 1. Tipo de identificacion
                int tipoId = Convert.ToInt32(ddlTipoIdentificacion.SelectedValue);
                if (tipoId <= 0)
                {
                    MostrarMensaje("Debe seleccionar un tipo de identificación.", false);
                    return;
                }

                // 2. Identificacion no vacia
                if (string.IsNullOrWhiteSpace(txtIdentificacion.Text))
                {
                    MostrarMensaje("La identificación es obligatoria.", false);
                    return;
                }

                // 3. Validacion dinamica por tipo (longitud + patron + regla Juridica)
                mdlTipoIdentificacion tipo = ctrTipoIdentificacion.ObtenerPorId(tipoId);
                if (tipo != null)
                {
                    string id = txtIdentificacion.Text.Trim();

                    // Longitud
                    if (id.Length < tipo.LongitudMin || id.Length > tipo.LongitudMax)
                    {
                        string msg = (tipo.LongitudMin == tipo.LongitudMax)
                            ? string.Format("La {0} debe tener exactamente {1} dígitos.", tipo.Nombre, tipo.LongitudMin)
                            : string.Format("La {0} debe tener entre {1} y {2} caracteres.", tipo.Nombre, tipo.LongitudMin, tipo.LongitudMax);
                        MostrarMensaje(msg, false);
                        return;
                    }

                    // Patron regex de la BD
                    if (!string.IsNullOrWhiteSpace(tipo.PatronRegex))
                    {
                        if (!Regex.IsMatch(id, tipo.PatronRegex))
                        {
                            string msg = tipo.SoloNumerico
                                ? string.Format("La {0} solo debe contener números.", tipo.Nombre)
                                : string.Format("El formato de la {0} no es válido.", tipo.Nombre);
                            MostrarMensaje(msg, false);
                            return;
                        }
                    }

                    // Regla especifica: Cedula Juridica debe iniciar con 3
                    if (tipo.Codigo != null &&
                        tipo.Codigo.Trim().ToUpper() == "JURIDICA" &&
                        !id.StartsWith("3"))
                    {
                        MostrarMensaje("La Cédula Jurídica debe iniciar con el dígito 3.", false);
                        return;
                    }
                }

                mdlUsuario usuarioSesion = (mdlUsuario)Session["Usuario"];

                mdlUsuario usuario = new mdlUsuario
                {
                    UsuarioId = usuarioSesion.UsuarioId,
                    TipoIdentificacionId = tipoId,
                    Identificacion = txtIdentificacion.Text.Trim(),
                    NombreCompleto = txtNombre.Text.Trim(),
                    Telefono = txtTelefono.Text.Trim(),
                    Correo = txtCorreo.Text.Trim()
                };

                string actual = null;
                string nueva = null;

                // 4. Cambio de contrasena
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

                // 5. Guardar
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