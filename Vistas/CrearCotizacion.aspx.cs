using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class CrearCotizacion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
                Response.Redirect("Login.aspx");

        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void btnCalcular_Click(object sender, EventArgs e)
        {
            string producto = ddlProducto.SelectedValue;
            string plazo = ddlPlazo.SelectedValue;
            string montoTexto = txtMonto.Text.Trim();

            if (string.IsNullOrEmpty(producto) ||
                string.IsNullOrEmpty(plazo) ||
                string.IsNullOrEmpty(montoTexto))
            {
                lblMensaje.Text = "Debe completar todos los campos.";
                lblMensaje.CssClass = "mensaje mensaje-error";
                lblMensaje.Visible = true;
                // lblMensaje.Style["color"] = "red";
                //lblMensaje.Style["font-style"] = "italic";
                //lblMensaje.Style["font-weight"] = "bold";
                //lblMensaje.Style["display"] = "block";
                return;
            }

            lblMensaje.Text = "Datos listos para calcular cotización.";
            lblMensaje.CssClass = "mensaje mensaje-exito";
            lblMensaje.Visible = true;
        }
    }
}