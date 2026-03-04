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
        ctrTasa crtTasa = new ctrTasa();
        
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

            if (tasa == null)
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
            }

            //  Llenar tabla resumen

            lblNumero.Text = "001"; // aquí luego ponemos consecutivo real
            //lblCliente.Text = txtCliente.Text;
            //lblTelefono.Text = txtTelefono.Text;
            //lblCorreo.Text = txtCorreo.Text;
            lblProducto.Text = ddlProducto.SelectedItem.Text;
            lblMonto.Text = monto.ToString("C");
            lblPlazo.Text = ddlPlazo.SelectedItem.Text;
            Label1.Text = tasa.ToString("N2") + " %";
            lblImpuestoPorc.Text = "13 %";

            Label2.Text = totalInteresBruto.ToString("C");
            lblImpuestoTotal.Text = totalImpuesto.ToString("C");
            lblNetoTotal.Text = totalNeto.ToString("C");

            lblMensaje.Text = "Cotización generada correctamente.";
            lblMensaje.CssClass = "mensaje mensaje-exito";
            lblMensaje.Visible = true;
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

            mdlTasa tasaObj = crtTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

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