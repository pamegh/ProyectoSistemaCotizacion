using ProyectoSistemaCotizacion.Controladores;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class MantenimientoUsuarios : System.Web.UI.Page
    {
        ctrUsuario ctr = new ctrUsuario();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                CargarUsuarios();

            }
        }
        protected void CargarUsuarios()
        {
            gvUsuarios.DataSource = ctr.ListarUsuarios();
            gvUsuarios.DataBind();
        }
    }
}