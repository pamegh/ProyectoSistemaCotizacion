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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
                Response.Redirect("Login.aspx");

            mdlUsuario usuario = (mdlUsuario)Session["Usuario"];

            if (usuario.Rol != "NORMAL")
                Response.Redirect("Dashboardprincipal.aspx");

            lblUsuario.Text = "Bienvenid@, " + usuario.NombreCompleto;
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}