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


        
        protected void Page_Load(object sender, EventArgs e)
        {
           // if (Session["Usuario"] == null)
             //   Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                CargarProductos();
                CargarPlazos();
            }

        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }



       

    protected void btnCalcular_Click(object sender, EventArgs e)
        {

            int usuarioId = Convert.ToInt32(hfUsuarioId.Value);
            var usuario = ctrUsuario.ObtenerUsuarioPorId(usuarioId);
            if (usuario == null)
            {
                lblMensaje.Text = "Debe seleccionar el cliente.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return;
            }
            


            //  Valida campos

            if (ddlProducto.SelectedIndex == 0 ||
                ddlPlazo.SelectedIndex == 0 ||
                string.IsNullOrWhiteSpace(txtMonto.Text))
            {
                lblMensaje.Text = "Debe completar todos los campos.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return;
            }

            // lee los datos
            decimal monto = Convert.ToDecimal(txtMonto.Text);
            decimal tasa = ObtenerTasaProducto();

            

            if (tasa == 0)
            {
                lblMensaje.Text = "No existe una tasa configurada para el producto y plazo seleccionado.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                return;
            }

            int plazo = Convert.ToInt32(ddlPlazo.SelectedValue);



            CalcularCotizacion(monto, tasa, plazo);


        }

        private void CalcularCotizacion(decimal monto, decimal tasa, int plazo)
        {
            List<mdlDetalleCotizacion> detalleMensual = new List<mdlDetalleCotizacion>();

            decimal tasaMensual = tasa / 12 / 100;
            decimal impuestoPorcentaje = 0.13m;

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
                    InteresNeto = interesNeto
                });
            }

            // 🔹 GridView detalle mensual
            gvDetalleCotizacion.DataSource = detalleMensual;
            gvDetalleCotizacion.DataBind();


            // 🔹 GridView resumen vertical
            List<mdlDetalleFila> resumen = new List<mdlDetalleFila>();

            resumen.Add(new mdlDetalleFila { Campo = "Número", Valor = lblNumero.Text });
            resumen.Add(new mdlDetalleFila { Campo = "Cliente", Valor = lblCliente.Text });
            resumen.Add(new mdlDetalleFila { Campo = "Teléfono", Valor = lblTelefono.Text });
            resumen.Add(new mdlDetalleFila { Campo = "Producto", Valor = ddlProducto.SelectedItem.Text });
            resumen.Add(new mdlDetalleFila { Campo = "Monto", Valor = monto.ToString("C") });
            resumen.Add(new mdlDetalleFila { Campo = "Plazo", Valor = plazo.ToString() });

            resumen.Add(new mdlDetalleFila { Campo = "", Valor = "" });

            resumen.Add(new mdlDetalleFila { Campo = "Tasa", Valor = tasa.ToString("N2") + " %" });
            resumen.Add(new mdlDetalleFila { Campo = "Impuesto", Valor = (impuestoPorcentaje * 100) + " %" });
            resumen.Add(new mdlDetalleFila { Campo = "Interés Neto", Valor = totalNeto.ToString("C") });

            

            gvResumenCotizacion.DataSource = resumen;
            gvResumenCotizacion.DataBind();
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

        private decimal ObtenerTasa()
        {
            int prodctoId = Convert.ToInt32(ddlProducto.SelectedValue);
            int plazoId = Convert.ToInt32(ddlPlazo.SelectedValue);

            ctrTasa controlador = new ctrTasa();
            mdlTasa tasa = controlador.ObtenerTasaPorProductoYPlazo(prodctoId, plazoId);

            return tasa.TasaAnual;
        }

        private void CargarProductos()
        {
            ctrProducto ctrProd = new ctrProducto();
            DataTable dt = ctrProd.ListarProductos();

            ddlProducto.DataSource = dt;
            ddlProducto.DataTextField = "nombre";   // Carga Combobox con los campos "nombre y producto_id" desde bd
            ddlProducto.DataValueField = "producto_id";   //producto_id   
            ddlProducto.DataBind();
            ddlProducto.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        }

        private void CargarPlazos()
        {
            ctrPlazo controlador = new ctrPlazo();
            var dt = controlador.ListarPlazos();

            ddlPlazo.DataSource = dt;
            ddlPlazo.DataTextField = "meses";
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



    }
}