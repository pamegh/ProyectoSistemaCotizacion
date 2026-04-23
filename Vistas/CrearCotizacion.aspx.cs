using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class CrearCotizacion : System.Web.UI.Page
    {
        ctrProducto ctrProd = new ctrProducto();
        ctrPlazo ctrPlz = new ctrPlazo();
        ctrTasa ctrTasa = new ctrTasa();
        ctrUsuario ctrUsuario = new ctrUsuario();
        ctrCotizacion ctrCot = new ctrCotizacion();
        ctrMoneda ctrMoneda = new ctrMoneda();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                CargarProductos();
                CargarPlazos();

                if (Session["UsuarioId"] != null)
                {
                    int usuarioId = Convert.ToInt32(Session["UsuarioId"]);
                    string rol = Session["Rol"].ToString();

                    string nombre = Session["Nombre"].ToString();
                    string id = Session["Identificacion"].ToString();

                    txtBuscarUsuario.Text = $"({id}) {nombre}";
                    hfUsuarioId.Value = usuarioId.ToString();

                    txtBuscarUsuario.ReadOnly = true;
                    AutoCompleteExtender1.Enabled = false;

                    lblTituloUsuario.InnerText = "Usuario";
                }
            }
        }

        protected void ddlProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlProducto.SelectedIndex == 0)
            {
                lblMonedaMonto.Text = "";
                return;
            }

            int productoId = Convert.ToInt32(ddlProducto.SelectedValue);
            string simbolo = ctrMoneda.ObtenerSimboloMoneda(productoId);
            string nombreMoneda = ctrMoneda.ObtenerNombreMoneda(productoId);

            lblMonedaMonto.Text = $"({nombreMoneda})";
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

    protected void btnCalcular_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";
            lblMensaje.Visible = false;
            lblNumero.Text = ctrCot.ObtenerSiguienteNumeroCotizacion();

            int usuarioId;
        

            if (!int.TryParse(hfUsuarioId.Value, out usuarioId))
            {
                lblMensaje.Text = "Debe seleccionar el cliente.";
                lblMensaje.Visible = true;
                return;
            }
            var usuario = ctrUsuario.ObtenerUsuarioPorId(usuarioId);

            lblCliente.Text = usuario.NombreCompleto;
            lblTelefono.Text = usuario.Telefono;
            lblCorreo.Text = usuario.Correo;

            if (usuario == null)
            {
                lblMensaje.Text = "Cliente no encontrado.";
                lblMensaje.Visible = true;
                return;
            }




            if (ddlProducto.SelectedIndex == 0 ||
                ddlPlazo.SelectedIndex == 0 ||
                string.IsNullOrWhiteSpace(txtMonto.Text))
            {
                lblMensaje.Text = "Debe completar todos los campos.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return;
            }

            decimal monto;
            if (!decimal.TryParse(txtMonto.Text, out monto))
            {
                lblMensaje.Text = "El monto ingresado no es válido. Debe ingresar solo números.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return;
            }

            if (monto <= 0)
            {
                lblMensaje.Text = "El monto debe ser mayor a cero.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return;
            }

            decimal tasa = ObtenerTasaProducto();

            

            if (tasa == 0)
            {
                lblMensaje.Text = "No existe una tasa configurada para el producto y plazo seleccionado.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return;
            }

            int plazo = int.Parse(ddlPlazo.SelectedItem.Text.Split(' ')[0]);



            CalcularCotizacion(monto, tasa, plazo);
            GuardarCotizacion();

        }

        private void CalcularCotizacion(decimal monto, decimal tasa, int plazo)
        {
            List<mdlDetalleCotizacion> detalleMensual = new List<mdlDetalleCotizacion>();
            ctrParametros ctrParam = new ctrParametros();
            mdlParametros impuestoActivo = ctrParam.ObtenerImpuestoActivo();
            int productoId = Convert.ToInt32(ddlProducto.SelectedValue);
            string simbolo = ctrMoneda.ObtenerSimboloMoneda(productoId);

            decimal tasaMensual = tasa / 12 / 100;
            if (impuestoActivo == null || string.IsNullOrEmpty(impuestoActivo.Valor))
            {
                lblMensaje.Text = "No hay impuesto activo configurado.";
                lblMensaje.Visible = true;
                return;
            }

            decimal impuestoPorcentaje = Convert.ToDecimal(impuestoActivo.Valor) / 100;

            decimal totalInteresBruto = 0;
            decimal totalImpuesto = 0;
            decimal totalNeto = 0;

            for (int i = 1; i <= plazo; i++)
            {
                decimal interesBruto = monto * tasaMensual;
                decimal impuestoMes = interesBruto * impuestoPorcentaje;
                decimal interesNeto = interesBruto - impuestoMes;

                totalInteresBruto += interesBruto;
                totalImpuesto += impuestoMes;
                totalNeto += interesNeto;

                detalleMensual.Add(new mdlDetalleCotizacion
                {
                    Mes = i,
                    InteresBruto = interesBruto,
                    Impuesto = impuestoMes,
                    InteresNeto = interesNeto,
                    Simbolo = simbolo
                });
            }
            //agregando Fila de totales
            detalleMensual.Add(new mdlDetalleCotizacion
            {
                Mes = 0, 
                InteresBruto = totalInteresBruto,
                Impuesto = totalImpuesto,
                InteresNeto = totalNeto,
                Simbolo = simbolo
            });
            
            gvDetalleCotizacion.DataSource = detalleMensual;
            gvDetalleCotizacion.DataBind();

            ViewState["DetalleMensual"] = detalleMensual;

            List<mdlDetalleFila> resumen = new List<mdlDetalleFila>();
            int usuarioId = Convert.ToInt32(hfUsuarioId.Value);
            var usuario = ctrUsuario.ObtenerUsuarioPorId(usuarioId);
            string clienteFormato = $"({usuario.Identificacion}) {usuario.NombreCompleto}";

            resumen.Add(new mdlDetalleFila { Campo = "Número", Valor = lblNumero.Text });
            resumen.Add(new mdlDetalleFila
            {
                Campo = "Cliente",
                Valor = clienteFormato
            });

            resumen.Add(new mdlDetalleFila { Campo = "Teléfono", Valor = lblTelefono.Text });
            resumen.Add(new mdlDetalleFila { Campo = "Correo", Valor = lblCorreo.Text });
            resumen.Add(new mdlDetalleFila { Campo = "Producto", Valor = ddlProducto.SelectedItem.Text });
            resumen.Add(new mdlDetalleFila { Campo = "Monto", Valor = $"{simbolo} {monto:N2}" });
            resumen.Add(new mdlDetalleFila { Campo = "Plazo", Valor = ddlPlazo.SelectedItem.Text });
            resumen.Add(new mdlDetalleFila { Campo = "Tasa", Valor = tasa.ToString("N2") + " %" });
            resumen.Add(new mdlDetalleFila { Campo = "Impuesto", Valor = (impuestoPorcentaje * 100) + " %" });
                      
            gvResumenCotizacion.DataSource = resumen;
            gvResumenCotizacion.DataBind();

            ViewState["TotalBruto"] = totalInteresBruto;
            ViewState["TotalImpuesto"] = totalImpuesto;
            ViewState["TotalNeto"] = totalNeto;
            ViewState["Impuesto"] = impuestoPorcentaje * 100;


        }

        private decimal ObtenerTasaProducto()
        {
            int productoId;
            int plazoId;

            if (!int.TryParse(ddlProducto.SelectedValue, out productoId) ||
                !int.TryParse(ddlPlazo.SelectedValue, out plazoId))
            {
                lblMensaje.Text = "Debe seleccionar un producto y un plazo válidos.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return 0;
            }

            mdlTasa tasaObj = ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

            if (tasaObj == null)
            {
                lblMensaje.Text = "No existe una tasa configurada para el producto y plazo seleccionado.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return 0;
            }

            return tasaObj.TasaAnual;
        }

        private void CargarProductos()
        {
            ctrProducto ctrProd = new ctrProducto();
            DataTable dt = ctrProd.ListarProductos();

            ddlProducto.DataSource = dt;
            ddlProducto.DataTextField = "nombre";
            ddlProducto.DataValueField = "producto_id";
            ddlProducto.DataBind();
            ddlProducto.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        }

        private void CargarPlazos()
        {
            ctrPlazo controlador = new ctrPlazo();
            var dt = controlador.ListarPlazos();

            ddlPlazo.DataSource = dt;
            ddlPlazo.DataTextField = "descripcion";
            ddlPlazo.DataValueField = "plazo_id";
            ddlPlazo.DataBind();

            ddlPlazo.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        }

        protected void txtBuscarUsuario_TextChanged(object sender, EventArgs e)
        {
            string nombre = txtBuscarUsuario.Text;

            lblMensaje.Text = "Buscando usuario: " + nombre;
            lblMensaje.Visible = true;
        }
        [System.Web.Services.WebMethod]
        [System.Web.Script.Services.ScriptMethod]
        public static List<string> BuscarUsuariosAjax(string prefixText, int count)
        {
            ctrUsuario ctr = new ctrUsuario();

            var lista = ctr.ListarUsuarios();

            var resultado = lista
                .Where(u => u.NombreCompleto.ToLower().Contains(prefixText.ToLower()) || u.Identificacion.Contains(prefixText))
                .Select(u => AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(
                    "(" + u.Identificacion + ") " + u.NombreCompleto,
                    u.UsuarioId.ToString()))

                .Take(count)
                .ToList();



            return resultado;
        }

        private void GuardarCotizacion()
        {
            string numero = lblNumero.Text;
            int usuarioId = Convert.ToInt32(hfUsuarioId.Value);
            int productoId = Convert.ToInt32(ddlProducto.SelectedValue);
            int plazoId = Convert.ToInt32(ddlPlazo.SelectedValue);
            decimal monto = Convert.ToDecimal(txtMonto.Text);
            decimal tasa = ObtenerTasaProducto();
            decimal impuesto = Convert.ToDecimal(ViewState["Impuesto"]);
            decimal totalBruto = Convert.ToDecimal(ViewState["TotalBruto"]);
            decimal totalImpuesto = Convert.ToDecimal(ViewState["TotalImpuesto"]);
            decimal totalNeto = Convert.ToDecimal(ViewState["TotalNeto"]);

            int cotizacionId = ctrCot.InsertarCotizacion(
                numero, usuarioId, productoId, plazoId,
                monto, tasa, impuesto, totalBruto, totalImpuesto, totalNeto,
                ObtenerUsuarioActual()
            );

            GuardarDetalleCotizacion(cotizacionId);

            lblMensaje.Text = "Cotización guardada correctamente con número: " + numero;
            lblMensaje.CssClass = "mensaje mensaje-exito";
            lblMensaje.Visible = true;
        }

        private void GuardarDetalleCotizacion(int cotizacionId)
        {
            var detalleMensual = (List<mdlDetalleCotizacion>)ViewState["DetalleMensual"];

            if (detalleMensual == null || detalleMensual.Count == 0) return;

            foreach (var item in detalleMensual)
            {
                ctrCot.InsertarDetalleCotizacion(
                    cotizacionId,
                    item.Mes,
                    item.InteresBruto,
                    item.Impuesto,
                    item.InteresNeto,
                    ObtenerUsuarioActual()
                );
            }
        }

        private string ObtenerUsuarioActual()
        {
            return Session["Nombre"] != null ? Session["Nombre"].ToString() : "Sistema";
        }

        private void LimpiarFormulario()
        {
            txtBuscarUsuario.Text = "";
            txtMonto.Text = "";

            hfUsuarioId.Value = "";

            lblCliente.Text = "";
            lblTelefono.Text = "";
            lblCorreo.Text = "";
            lblNumero.Text = "";

            ddlProducto.SelectedIndex = 0;
            ddlPlazo.SelectedIndex = 0;

            gvResumenCotizacion.DataSource = null;
            gvResumenCotizacion.DataBind();

            gvDetalleCotizacion.DataSource = null;
            gvDetalleCotizacion.DataBind();

            ViewState["DetalleMensual"] = null;
            ViewState["TotalBruto"] = null;
            ViewState["TotalImpuesto"] = null;
            ViewState["TotalNeto"] = null;
            ViewState["Impuesto"] = null;
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            if (Session["Rol"] != null)
            {
                string rol = Session["Rol"].ToString().ToUpper();

                if (rol == "ADMIN")
                {
                    Response.Redirect("~/Vistas/DashboardAdministrador.aspx");
                }
                else
                {
                    Response.Redirect("~/Vistas/DashboardUsuario.aspx");
                }
            }
            else
            {
                Response.Redirect("~/Login.aspx");
            }
        }
    }
}