using System;
using System.Web.UI;

namespace SistemaCotizacionAPF.Vista
{
    public partial class Dashboardprincipal : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Código de inicialización si es necesario
            if (!IsPostBack)
            {
                // Configuraciones iniciales
            }
        }

        // Evento Click para btnAcceder - Siguiendo estándar: OnClick="btnAcceder_Click"
        protected void btnAcceder_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        // Evento Click para btnRegistrar - Siguiendo estándar: OnClick="btnRegistrar_Click"
        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Registro.aspx");
        }
    }
}