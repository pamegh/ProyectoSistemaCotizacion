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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
                Response.Redirect("Login.aspx");

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
            decimal tasaMensual = tasa / 12 / 100;
            decimal impuesto = 0.13m;

            List<string> detalle = new List<string>();

            for (int i = 1; i <= plazo; i++)
            {
                decimal interesBruto = monto * tasaMensual;
                decimal impuestoMes = interesBruto * impuesto;
                decimal interesNeto = interesBruto - impuestoMes;

                detalle.Add($"Mes {i}: Bruto {interesBruto:C} | Impuesto {impuestoMes:C} | Neto {interesNeto:C}");
            }

            gvDetalle.DataSource = detalle;
            gvDetalle.DataBind();
            lblMensaje.Text = "Cotización generada correctamente.";
            lblMensaje.Visible = true;
        }

        private decimal ObtenerTasaProducto()
        {
            string productoSeleccionado = ddlProducto.SelectedValue;

            // EJEMPLO temporal (simulación)
            if (productoSeleccionado == "1")
                return 6.5m;

            if (productoSeleccionado == "2")
                return 7.2m;

            if (productoSeleccionado == "3")
                return 8.1m;

            return 0;
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
            ddlProducto.DataTextField = "nombre";   // Carga Combobox con los campos "nombre y codigo" desde bd
            ddlProducto.DataValueField = "codigo";      
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

    }
}