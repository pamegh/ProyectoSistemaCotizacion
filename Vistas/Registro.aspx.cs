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
    public partial class Registro : System.Web.UI.Page
    {
        private ctrTipoIdentificacion controlador = new ctrTipoIdentificacion();

        // ─────────────────────────────────────────────────────────────────────
        // Genera el mismo diccionario que MiCuenta para que el JS funcione igual:
        //   configTipos["1"] => { placeholder, hint, maxLength, ... }
        // El ASPX lo usa con: var configTipos = <%= TiposIdentificacionJson %>;
        // ─────────────────────────────────────────────────────────────────────
        public string TiposIdentificacionJson
        {
            get
            {
                try
                {
                    List<mdlTipoIdentificacion> tipos = controlador.ObtenerTodos();

                    var hints = new Dictionary<string, string[]>
                    {
                        { "FISICA",    new[]{ "Ej: 123456789",   "9 dígitos numéricos" } },
                        { "JURIDICA",  new[]{ "Ej: 3101234567",  "10 dígitos, debe iniciar con 3" } },
                        { "DIMEX",     new[]{ "Ej: 11712345678", "11 o 12 dígitos numéricos" } },
                        { "NITE",      new[]{ "Ej: 3012345678",  "10 dígitos numéricos" } },
                        { "PASAPORTE", new[]{ "Ej: A1234567",    "6 a 20 caracteres alfanuméricos" } },
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

        private void CargarUsuario(int usuarioId)
        {
            ctrUsuario ctrUsr = new ctrUsuario();
            mdlUsuario usuario = ctrUsr.ObtenerUsuarioPorId(usuarioId);
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
            List<mdlTipoIdentificacion> lista = controlador.ObtenerTodos();
            ddlTipoIdentificacion.DataSource = lista;
            ddlTipoIdentificacion.DataTextField = "Nombre";
            ddlTipoIdentificacion.DataValueField = "TipoIdentificacionId";
            ddlTipoIdentificacion.DataBind();
            ddlTipoIdentificacion.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            bool esEdicion = Request.QueryString["id"] != null;

            // 1. Tipo de identificacion
            if (ddlTipoIdentificacion.SelectedValue == "0" ||
                string.IsNullOrWhiteSpace(ddlTipoIdentificacion.SelectedValue))
            {
                MostrarMensaje("Debe seleccionar un tipo de identificación.", false);
                return;
            }

            int tipoId = Convert.ToInt32(ddlTipoIdentificacion.SelectedValue);

            // 2. Identificacion no vacia
            if (string.IsNullOrWhiteSpace(txtIdentificacion.Text))
            {
                MostrarMensaje("La identificación es obligatoria.", false);
                return;
            }

            // 3. Validacion dinamica por tipo
            mdlTipoIdentificacion tipo = controlador.ObtenerPorId(tipoId);
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

            // 4. Nombre
            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                MostrarMensaje("El nombre completo es obligatorio.", false);
                return;
            }
            if (txtNombre.Text.Trim().Length < 3)
            {
                MostrarMensaje("El nombre completo debe tener al menos 3 caracteres.", false);
                return;
            }

            // 5. Telefono requerido y formato CR
            if (string.IsNullOrWhiteSpace(txtTelefono.Text))
            {
                MostrarMensaje("El teléfono es obligatorio.", false);
                return;
            }
            if (!Regex.IsMatch(txtTelefono.Text.Trim(), @"^[24678]\d{7}$"))
            {
                MostrarMensaje("Debe ser un teléfono costarricense válido (8 dígitos, inicia con 2, 4, 6, 7 u 8).", false);
                return;
            }

            // 6. Correo
            if (string.IsNullOrWhiteSpace(txtCorreo.Text))
            {
                MostrarMensaje("El correo es obligatorio.", false);
                return;
            }
            if (!Regex.IsMatch(txtCorreo.Text.Trim(), @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                MostrarMensaje("El formato del correo no es válido.", false);
                return;
            }

            // 7. Contrasena en registro nuevo
            if (!esEdicion && string.IsNullOrWhiteSpace(txtContrasena.Text))
            {
                MostrarMensaje("La contraseña es obligatoria.", false);
                return;
            }

            // 8. Construir modelo
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

            if (esEdicion)
            {
                datos.UsuarioId = Convert.ToInt32(Request.QueryString["id"]);
                if (!string.IsNullOrWhiteSpace(txtContrasena.Text))
                    datos.Contrasena = txtContrasena.Text.Trim();

                if (ctr.ActualizarUsuario(datos, null, txtContrasena.Text))
                    Response.Redirect("MantenimientoUsuarios.aspx");
                else
                    MostrarMensaje(datos.Mensaje ?? "Error al actualizar usuario.", false);
            }
            else
            {
                if (ctr.RegistrarUsuario(datos))
                    Response.Redirect("MantenimientoUsuarios.aspx");
                else
                    MostrarMensaje(datos.Mensaje ?? "Error al registrar usuario.", false);
            }
        }

        private void MostrarMensaje(string mensaje, bool exito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.Visible = true;
            lblMensaje.CssClass = exito ? "mensaje mensaje-exito" : "mensaje mensaje-error";
        }
    }
}