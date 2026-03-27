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
    public partial class DashboardUsuario : System.Web.UI.Page
    {

        ctrCotizacion ctrCot = new ctrCotizacion();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
                Response.Redirect("Login.aspx");

            mdlUsuario usuario = (mdlUsuario)Session["Usuario"];

            if (usuario.Rol != "NORMAL")
                Response.Redirect("Dashboardprincipal.aspx");

            lblUsuario.Text = "Bienvenid@, " + usuario.NombreCompleto;

            if (!IsPostBack)
            {
                CargarDatosDashboard(usuario);
            }
        }

        private void CargarDatosDashboard(mdlUsuario usuario)
        {
            var dt = ctrCot.ListarCotizaciones(usuario.UsuarioId);

            lblTotalCotizaciones.Text = dt.Rows.Count.ToString();

            lblUltimaCotizacion.Text = "0";
            lblProducto.Text = "";
            lblPlazo.Text = "";

            if (dt.Rows.Count > 0)
            {
                lblUltimaCotizacion.Text =
                    Convert.ToDecimal(dt.Rows[0]["monto"]).ToString("N2");

                lblProducto.Text = dt.Rows[0]["producto"].ToString();
                lblPlazo.Text = dt.Rows[0]["plazo"].ToString();
            }

            lblNombreCorto.Text = usuario.NombreCompleto.Split(' ')[0];
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}