using ProyectoSistemaCotizacion.Controladores;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class HistorialCotizaciones : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCotizaciones();
            }
        }

        protected void gvCotizaciones_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "VerDetalle")
            {
                int cotizacionId = Convert.ToInt32(e.CommandArgument);

                Response.Redirect("DetalleCotizacion.aspx?cotizacionId=" + cotizacionId);
            }
        }

        private void CargarCotizaciones()
        {
            ctrCotizacion ctr = new ctrCotizacion();

            int? usuarioId = null;

            if (Session["Rol"] != null)
            {
                string rol = Session["Rol"].ToString().ToUpper();

                if (rol != "ADMIN")
                {
                    usuarioId = Convert.ToInt32(Session["UsuarioId"]);
                }
            }

            gvCotizaciones.DataSource = ctr.ListarCotizaciones(usuarioId);
            gvCotizaciones.DataBind();
        }
    }
}