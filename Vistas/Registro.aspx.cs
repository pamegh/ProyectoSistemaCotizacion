using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class Registro : System.Web.UI.Page
    {
        private ctrTipoIdentificacion controlador = new ctrTipoIdentificacion();

        // Propiedad leída desde el .aspx para inyectar JSON en el JS
        protected string TiposIdentificacionJson { get; private set; } = "{}";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Siempre inyectar el JSON (necesario incluso en postback para el JS)
            InyectarTiposJson();

            if (!IsPostBack)
            {
                CargarTiposIdentificacion();

                if (Request.QueryString["id"] != null)
                {
                    int usuarioId = Convert.ToInt32(Request.QueryString["id"]);
                    CargarUsuario(usuarioId);

                    lblTitulo.Text = "Editar Usuario";
                    lblSubtitulo.Text = "Actualice la información del usuario.";
                    txtContrasena.Enabled = false;
                }
            }
        }

        // ── Construye el JSON de tipos para el JavaScript del cliente ──
        private void InyectarTiposJson()
        {
            var lista = controlador.ObtenerTodos();
            var sb = new StringBuilder("{");

            foreach (var t in lista)
            {
                string regex = (t.PatronRegex ?? "")
                    .Replace("\\", "\\\\")
                    .Replace("\"", "\\\"");

                sb.AppendFormat(
                    "\"{0}\":{{\"codigo\":\"{1}\",\"nombre\":\"{2}\"," +
                    "\"longitudMin\":{3},\"longitudMax\":{4}," +
                    "\"patronRegex\":\"{5}\",\"soloNumerico\":{6}}},",
                    t.TipoIdentificacionId,
                    t.Codigo ?? "",
                    (t.Nombre ?? "").Replace("\"", "\\\""),
                    t.LongitudMin,
                    t.LongitudMax,
                    regex,
                    t.SoloNumerico ? "true" : "false"
                );
            }

            if (sb.Length > 1) sb.Length--; // quitar última coma
            sb.Append("}");

            TiposIdentificacionJson = sb.ToString();
        }

        private void CargarUsuario(int usuarioId)
        {
            ctrUsuario ctrUsuario = new ctrUsuario();
            mdlUsuario usuario = ctrUsuario.ObtenerUsuarioPorId(usuarioId);

            if (usuario != null)
            {
                txtIdentificacion.Text = usuario.Identificacion;
                txtNombre.Text = usuario.NombreCompleto;
                txtTelefono.Text = usuario.Telefono;
                txtCorreo.Text = usuario.Correo;
                ddlTipoIdentificacion.SelectedValue = usuario.TipoIdentificacionId.ToString();
            }
        }

        private void CargarTiposIdentificacion()
        {
            var lista = controlador.ObtenerTodos();

            ddlTipoIdentificacion.DataSource = lista;
            ddlTipoIdentificacion.DataTextField = "Nombre";
            ddlTipoIdentificacion.DataValueField = "TipoIdentificacionId";
            ddlTipoIdentificacion.DataBind();

            ddlTipoIdentificacion.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            bool esEdicion = Request.QueryString["id"] != null;
            int tipoId = Convert.ToInt32(ddlTipoIdentificacion.SelectedValue);

            // ── Validaciones básicas ──────────────────────────────────────
            if (tipoId == 0)
            {
                MostrarMensaje("Debe seleccionar un tipo de identificación.", false);
                return;
            }

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

            if (!esEdicion && string.IsNullOrWhiteSpace(txtContrasena.Text))
            {
                MostrarMensaje("La contraseña es obligatoria.", false);
                return;
            }

            // ── Validación de teléfono CR (servidor = doble capa) ─────────
            // Obligatorio, 8 dígitos, primer dígito 2, 4, 5, 6, 7 u 8
            if (string.IsNullOrWhiteSpace(txtTelefono.Text))
            {
                MostrarMensaje("El teléfono es obligatorio.", false);
                return;
            }

            string telLimpio = txtTelefono.Text.Trim().Replace("-", "");
            if (!Regex.IsMatch(telLimpio, @"^[245678]\d{7}$"))
            {
                MostrarMensaje(
                    "El teléfono no es válido. Debe tener 8 dígitos e iniciar con 2, 4, 5, 6, 7 u 8.",
                    false);
                return;
            }

            // ── Validación de formato de identificación (servidor) ────────
            var tipos = controlador.ObtenerTodos();
            var tipo = tipos.Find(t => t.TipoIdentificacionId == tipoId);

            if (tipo != null)
            {
                // Validar directamente con la regex de BD (que ya incluye guiones para CF y CJ)
                if (!string.IsNullOrEmpty(tipo.PatronRegex) &&
                    !Regex.IsMatch(txtIdentificacion.Text.Trim(), tipo.PatronRegex))
                {
                    string mensajeFormato;
                    switch (tipo.Codigo?.ToUpper())
                    {
                        case "CF": mensajeFormato = "Cédula Física inválida. Use el formato 0-0000-0000."; break;
                        case "CJ": mensajeFormato = "Cédula Jurídica inválida. Use el formato 3-000-000000 (inicia con 3)."; break;
                        case "DX": mensajeFormato = $"DIMEX debe tener entre {tipo.LongitudMin} y {tipo.LongitudMax} dígitos numéricos."; break;
                        case "PA": mensajeFormato = "Pasaporte: solo letras y números, entre 6 y 20 caracteres."; break;
                        default: mensajeFormato = "El formato de la identificación no es válido."; break;
                    }
                    MostrarMensaje(mensajeFormato, false);
                    return;
                }
            }

            // ── Armar modelo ──────────────────────────────────────────────
            mdlUsuario datos = new mdlUsuario
            {
                Identificacion = txtIdentificacion.Text.Trim(),
                NombreCompleto = txtNombre.Text.Trim(),
                Telefono = txtTelefono.Text.Trim(),
                Correo = txtCorreo.Text.Trim(),
                Contrasena = txtContrasena.Text.Trim(),
                TipoIdentificacionId = tipoId
            };

            ctrUsuario ctr = new ctrUsuario();

            // ── Edición ───────────────────────────────────────────────────
            if (esEdicion)
            {
                datos.UsuarioId = Convert.ToInt32(Request.QueryString["id"]);

                string nuevaContrasena = string.IsNullOrWhiteSpace(txtContrasena.Text)
                    ? null
                    : txtContrasena.Text.Trim();

                if (ctr.ActualizarUsuario(datos, null, nuevaContrasena))
                    Response.Redirect("MantenimientoUsuarios.aspx");
                else
                    MostrarMensaje(datos.Mensaje ?? "Error al actualizar usuario.", false);
            }
            // ── Registro nuevo ────────────────────────────────────────────
            else
            {
                if (ctr.RegistrarUsuario(datos))
                {
                    MostrarMensaje(datos.Mensaje ?? "Usuario registrado correctamente.", true);
                    LimpiarFormulario();
                }
                else
                {
                    MostrarMensaje(datos.Mensaje ?? "Error al registrar usuario.", false);
                }
            }
        }

        private void LimpiarFormulario()
        {
            ddlTipoIdentificacion.SelectedIndex = 0;
            txtIdentificacion.Text = "";
            txtNombre.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";
            txtContrasena.Text = "";
        }

        private void MostrarMensaje(string mensaje, bool exito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.Visible = true;
            lblMensaje.CssClass = exito ? "mensaje mensaje-exito" : "mensaje mensaje-error";
        }
    }
}