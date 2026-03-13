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
    public partial class ConfiguracionProductos : System.Web.UI.Page
    {
        ctrProducto ctrProducto = new ctrProducto();
        ctrPlazo ctrPlazo = new ctrPlazo();
        ctrTasa ctrTasa = new ctrTasa();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarTablaFinanciera();
            }
        }

        private void CargarTablaFinanciera()
        {
            gvTablaFinanciera.DataSource = ctrTasa.ObtenerTablaFinanciera();
            gvTablaFinanciera.DataBind();
        }

        // =================== CAMBIO DE ENTIDAD ===================
        protected void ddlEntidad_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlFormulario.Visible = true;

            // Ocultar todos
            pnlProducto.Visible = false;
            pnlPlazo.Visible = false;
            pnlTasaFiltros.Visible = false;

            lblMensaje.Text = "";

            if (ddlEntidad.SelectedValue == "Producto")
            {
                pnlProducto.Visible = true;

                ddlProductoBuscar.DataSource = ctrProducto.ListarProductos();
                ddlProductoBuscar.DataTextField = "nombre";
                ddlProductoBuscar.DataValueField = "producto_id";
                ddlProductoBuscar.DataBind();

                ddlProductoBuscar.Items.Insert(0, new ListItem("-- Seleccione --", ""));
            }
            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                pnlPlazo.Visible = true;

                var dtPlazos = ctrPlazo.ListarPlazos();

                ddlPlazoBuscar.Items.Clear();
                ddlPlazoBuscar.Items.Insert(0, new ListItem("-- Seleccione --", ""));

                foreach (System.Data.DataRow row in dtPlazos.Rows)
                {
                    int meses = Convert.ToInt32(row["meses"]);
                    int dias = Convert.ToInt32(row["dias"]);

                    string texto = "";

                    if (meses > 0)
                        texto += meses == 1 ? "1 mes" : $"{meses} meses";

                    if (dias > 0)
                    {
                        if (texto != "") texto += " y ";
                        texto += dias == 1 ? "1 día" : $"{dias} días";
                    }

                    ddlPlazoBuscar.Items.Add(
                        new ListItem(texto, row["plazo_id"].ToString())
                    );
                }

                ddlPlazoBuscar.Items.Insert(0, new ListItem("-- Seleccione --", ""));
            }
            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                pnlTasaFiltros.Visible = true;

                ddlProductoTasa.DataSource = ctrProducto.ListarProductos();
                ddlProductoTasa.DataTextField = "nombre";
                ddlProductoTasa.DataValueField = "producto_id";
                ddlProductoTasa.DataBind();

                ddlProductoTasa.Items.Insert(0, new ListItem("-- Seleccione Producto --", ""));

                ddlPlazoTasa.Items.Clear();
                ddlPlazoTasa.Items.Insert(0, new ListItem("-- Seleccione Plazo --", ""));
            }
        }

        // =================== PRODUCTO ===================
        protected void ddlProductoBuscar_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlProductoBuscar.SelectedValue))
            {
                int id = Convert.ToInt32(ddlProductoBuscar.SelectedValue);
                mdlProducto prod = ctrProducto.ObtenerProductoPorId(id);
                txtNombreProducto.Text = prod.Nombre;
            }
        }

        protected void ddlPlazoBuscar_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlPlazoBuscar.SelectedValue))
            {
                int id = Convert.ToInt32(ddlPlazoBuscar.SelectedValue);
                mdlPlazo plazo = ctrPlazo.ObtenerPlazoPorId(id);

                txtMesesPlazo.Text = plazo.Meses.ToString();
                txtDiasPlazo.Text = plazo.Dias.ToString();
            }
        }

        // =================== TASAS ===================
        protected void ddlProductoTasa_SelectedIndexChanged(object sender, EventArgs e)
        {
            var dtPlazos = ctrPlazo.ListarPlazos();

            ddlPlazoTasa.Items.Clear();
            ddlPlazoTasa.Items.Insert(0, new ListItem("-- Seleccione Plazo --", ""));

            foreach (System.Data.DataRow row in dtPlazos.Rows)
            {
                int meses = Convert.ToInt32(row["meses"]);
                int dias = Convert.ToInt32(row["dias"]);

                string texto = "";

                if (meses > 0)
                    texto += meses == 1 ? "1 mes" : $"{meses} meses";

                if (dias > 0)
                {
                    if (texto != "") texto += " y ";
                    texto += dias == 1 ? "1 día" : $"{dias} días";
                }

                // Si ambos fueran 0 (por seguridad)
                if (texto == "")
                    texto = "0 días";

                ddlPlazoTasa.Items.Add(
                    new ListItem(texto, row["plazo_id"].ToString())
                );
            }

            txtTasaEditar.Text = "";
            ViewState["TasaId"] = null;
        }

        protected void ddlPlazoTasa_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlProductoTasa.SelectedValue) &&
                !string.IsNullOrEmpty(ddlPlazoTasa.SelectedValue))
            {
                int productoId = Convert.ToInt32(ddlProductoTasa.SelectedValue);
                int plazoId = Convert.ToInt32(ddlPlazoTasa.SelectedValue);

                mdlTasa tasa = ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                if (tasa != null && tasa.TasaId > 0)
                {
                    txtTasaEditar.Text = tasa.TasaAnual.ToString();
                    ViewState["TasaId"] = tasa.TasaId;
                }
                else
                {
                    txtTasaEditar.Text = "";
                    ViewState["TasaId"] = null;
                }
            }
        }

        // =================== GUARDAR ===================
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";

            if (ddlEntidad.SelectedValue == "Producto")
            {
                int id = Convert.ToInt32(ddlProductoBuscar.SelectedValue);

                mdlProducto prod = ctrProducto.ObtenerProductoPorId(id);
                prod.Nombre = txtNombreProducto.Text;

                bool resultado = ctrProducto.ActualizarProducto(prod);

                lblMensaje.Text = prod.Mensaje;
                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
            }
            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                int id = Convert.ToInt32(ddlPlazoBuscar.SelectedValue);

                mdlPlazo plazo = ctrPlazo.ObtenerPlazoPorId(id);
                plazo.Meses = Convert.ToInt32(txtMesesPlazo.Text);
                plazo.Dias = Convert.ToInt32(txtDiasPlazo.Text);

                bool resultado = ctrPlazo.ActualizarPlazo(plazo);

                lblMensaje.Text = plazo.Mensaje;
                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
            } 
            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                if (string.IsNullOrEmpty(ddlProductoTasa.SelectedValue) ||
                    string.IsNullOrEmpty(ddlPlazoTasa.SelectedValue))
                {
                    lblMensaje.Text = "Debe seleccionar producto y plazo.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                int productoId = Convert.ToInt32(ddlProductoTasa.SelectedValue);
                int plazoId = Convert.ToInt32(ddlPlazoTasa.SelectedValue);
                decimal tasaValor = Convert.ToDecimal(txtTasaEditar.Text);

                mdlTasa tasa = new mdlTasa
                {
                    ProductoId = productoId,
                    PlazoId = plazoId,
                    TasaAnual = tasaValor
                };

                bool resultado;

                if (ViewState["TasaId"] != null)
                {
                    tasa.TasaId = Convert.ToInt32(ViewState["TasaId"]);
                    resultado = ctrTasa.ActualizarTasa(tasa);
                }
                else
                {
                    resultado = ctrTasa.InsertarTasa(tasa);
                }

                lblMensaje.Text = tasa.Mensaje;
                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
            }

            CargarTablaFinanciera();
        }

        // =================== ELIMINAR ===================
        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";

            if (ddlEntidad.SelectedValue == "Producto")
            {
                int id = Convert.ToInt32(ddlProductoBuscar.SelectedValue);
                string mensaje;

                bool resultado = ctrProducto.EliminarProducto(id, out mensaje);

                lblMensaje.Text = mensaje;
                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
            }
            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                int id = Convert.ToInt32(ddlPlazoBuscar.SelectedValue);
                string mensaje;

                bool resultado = ctrPlazo.EliminarPlazo(id, out mensaje);

                lblMensaje.Text = mensaje;
                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
            }
            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                if (ViewState["TasaId"] != null)
                {
                    int tasaId = Convert.ToInt32(ViewState["TasaId"]);

                    bool resultado = ctrTasa.EliminarTasa(tasaId);

                    lblMensaje.Text = resultado ? "Tasa eliminada correctamente"
                                                : "Error al eliminar la tasa";
                    lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
                }
                else
                {
                    lblMensaje.Text = "No existe tasa para eliminar.";
                    lblMensaje.CssClass = "text-danger";
                }
            }

            CargarTablaFinanciera();
        }
    }
}