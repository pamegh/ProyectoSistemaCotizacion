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

        protected void gvUsuarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Editar")
            {
                int usuarioId = Convert.ToInt32(e.CommandArgument);

                Response.Redirect("Registro.aspx?id=" + usuarioId);
            }

            if (e.CommandName == "Estado")
            {
                string[] datos = e.CommandArgument.ToString().Split('|');

                int usuarioId = Convert.ToInt32(datos[0]);
                string estadoActual = datos[1];

                string nuevoEstado = estadoActual == "Activo" ? "Inactivo" : "Activo";

                ctrUsuario ctr = new ctrUsuario();

                ctr.CambiarEstadoUsuario(usuarioId, nuevoEstado);

                CargarUsuarios();
            }
        }

        protected void gvUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lblEstado = (Label)e.Row.FindControl("lblEstado");

                if (lblEstado.Text == "Activo")
                {
                    lblEstado.CssClass += " estado-activo";
                }
                else
                {
                    lblEstado.CssClass += " estado-inactivo";
                }
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            string nombre = txtBuscar.Text.Trim().ToLower();
            if (string.IsNullOrEmpty(nombre))
            {
                CargarUsuarios();
                return;
            }
            

            var lista = ctr.ListarUsuarios();

            var resultado = lista.Where(u =>
                u.NombreCompleto.ToLower().Contains(nombre)
            ).ToList();

            gvUsuarios.DataSource = resultado;
            gvUsuarios.DataBind();
        }
    }
}

    
