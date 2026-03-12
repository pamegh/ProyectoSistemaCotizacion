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
    public partial class DashboardAdministrador : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
                Response.Redirect("Login.aspx");

            mdlUsuario usuario = (mdlUsuario)Session["Usuario"];

            if (usuario.Rol != "ADMIN")
                Response.Redirect("Dashboardprincipal.aspx");

            lblUsuario.Text = "Bienvenido, " + usuario.NombreCompleto;

            if (!IsPostBack)
            {
                CargarEstadisticas();
            }
        }

        private void CargarEstadisticas()
        {
            try
            {
                ctrUsuario controlador = new ctrUsuario();
                mdlEstadisticasDashboard estadisticas = controlador.ObtenerEstadisticasDashboard();

                lblTotalUsuarios.Text = estadisticas.TotalUsuarios.ToString();
                lblCotizacionesActivas.Text = estadisticas.CotizacionesActivas.ToString();
                lblReportesGenerados.Text = estadisticas.ReportesGenerados.ToString();
                lblProductosDisponibles.Text = estadisticas.ProductosDisponibles.ToString();
            }
            catch (Exception)
            {
                // Si hay error, mostrar 0 en todos los campos
                lblTotalUsuarios.Text = "0";
                lblCotizacionesActivas.Text = "0";
                lblReportesGenerados.Text = "0";
                lblProductosDisponibles.Text = "0";
            }
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void btnMantenimientoUsuarios_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Vistas/MantenimientoUsuarios");
        }

        
    }
}