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
    public partial class ConfiguracionMonedas : System.Web.UI.Page
    {
        private ctrMoneda ctrMoneda = new ctrMoneda();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarMonedas();
                ddlMoneda.Visible = true;
            }
        }
        private void CargarMonedas()
        {
            ddlMoneda.DataSource = ctrMoneda.ListarMonedas();
            ddlMoneda.DataTextField = "nombre";
            ddlMoneda.DataValueField = "moneda_id";
            ddlMoneda.DataBind();

            ddlMoneda.Items.Insert(0,
                new ListItem("-- Seleccione moneda --", ""));
        }

        protected void ddlMoneda_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlMoneda.SelectedValue))
            {
                int id = Convert.ToInt32(ddlMoneda.SelectedValue);

                mdlMoneda moneda = ctrMoneda.ObtenerMonedaPorId(id);

                txtCodigo.Text = moneda.Codigo;
                txtNombre.Text = moneda.Nombre;
                txtSimbolo.Text = moneda.Simbolo;
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtCodigo.Text) ||
                string.IsNullOrEmpty(txtNombre.Text))
            {
                lblMensaje.Text = "Debe completar los campos.";
                lblMensaje.CssClass = "text-danger";
                return;
            }

            mdlMoneda moneda = new mdlMoneda();

            moneda.Codigo = txtCodigo.Text;
            moneda.Nombre = txtNombre.Text;
            moneda.Simbolo = txtSimbolo.Text;

            bool resultado;

            if (string.IsNullOrEmpty(ddlMoneda.SelectedValue))
            {
                resultado = ctrMoneda.InsertarMoneda(moneda);
            }
            else
            {
                moneda.MonedaId = Convert.ToInt32(ddlMoneda.SelectedValue);
                resultado = ctrMoneda.ActualizarMoneda(moneda);
            }

            lblMensaje.Text = moneda.Mensaje;
            lblMensaje.CssClass = resultado ? "text-success" : "text-danger";

            CargarMonedas();
            LimpiarFormulario();
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlMoneda.SelectedValue))
            {
                lblMensaje.Text = "Seleccione una moneda.";
                lblMensaje.CssClass = "text-danger";
                return;
            }

            int id = Convert.ToInt32(ddlMoneda.SelectedValue);

            string mensaje;

            bool resultado = ctrMoneda.EliminarMoneda(id, out mensaje);

            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = resultado ? "text-success" : "text-danger";

            CargarMonedas();
            LimpiarFormulario();
        }

        protected void btnNuevo_Click(object sender, EventArgs e)
        {
            ddlMoneda.SelectedIndex = 0;

            txtCodigo.Text = "";
            txtNombre.Text = "";
            txtSimbolo.Text = "";

            ddlMoneda.Visible = false;

            lblMensaje.Text = "Modo creación activado";
            lblMensaje.CssClass = "text-info";
        }

        private void LimpiarFormulario()
        {
            txtCodigo.Text = "";
            txtNombre.Text = "";
            txtSimbolo.Text = "";

            ddlMoneda.SelectedIndex = 0;
            ddlMoneda.Visible = true;
        }

    }
}