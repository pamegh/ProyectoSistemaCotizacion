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
        ctrMoneda ctrMoneda = new ctrMoneda();
        bool ModoNuevo
        {
            get { return ViewState["ModoNuevo"] != null && (bool)ViewState["ModoNuevo"]; }
            set { ViewState["ModoNuevo"] = value; }
        }

        string ModoOperacion
        {
            get { return ViewState["ModoOperacion"]?.ToString() ?? ""; }
            set { ViewState["ModoOperacion"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarTablaFinanciera();
                CargarMonedas();
                CargarDias();
                ddlEntidad_SelectedIndexChanged(null, null);
            }

            string evento = Request["__EVENTTARGET"];

            if (evento == "RecargarMonedas")
            {
                CargarMonedas();
            }
        }

        private void CargarTablaFinanciera()
        {
            gvTablaFinanciera.DataSource = ctrTasa.ObtenerTablaFinanciera();
            gvTablaFinanciera.DataBind();

            if (gvTablaFinanciera.Columns.Count > 0)
            {
                gvTablaFinanciera.Columns[0].Visible = false;
            }
        }

        protected void ddlEntidad_SelectedIndexChanged(object sender, EventArgs e)
        {

            if (ModoOperacion == "Eliminar")
            {
                MostrarModoEliminar();
                return;
            }
            pnlFormulario.Visible = true;

            pnlProducto.Visible = false;
            pnlPlazo.Visible = false;
            pnlTasaFiltros.Visible = false;


            if (ddlEntidad.SelectedValue == "Producto")
            {
                pnlProducto.Visible = true;

                ddlProductoBuscar.DataSource = ctrProducto.ListarProductos();
                ddlProductoBuscar.DataTextField = "nombre";
                ddlProductoBuscar.DataValueField = "producto_id";
                ddlProductoBuscar.DataBind();

                ddlProductoBuscar.Items.Insert(0, new ListItem("-- Seleccione --", ""));

                CargarPlazos();

                if (ModoNuevo)
                    ddlProductoBuscar.Visible = false;
                else
                    ddlProductoBuscar.Visible = true;
            }
            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                pnlPlazo.Visible = true;
                ddlPlazoBuscar.Visible = true;
                ddlProductoTasa.Visible = true;
                ddlPlazoTasa.Visible = true;

                chkProductosPlazo.DataSource = ctrProducto.ListarProductos();
                chkProductosPlazo.DataTextField = "nombre";
                chkProductosPlazo.DataValueField = "producto_id";
                chkProductosPlazo.DataBind();

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

                if (ModoNuevo)
                    ddlPlazoBuscar.Visible = false;
                else
                    ddlPlazoBuscar.Visible = true;
            }
            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                pnlTasaFiltros.Visible = true;

                ddlProductoTasa.DataSource = ctrProducto.ListarProductos();
                ddlProductoTasa.DataTextField = "nombre";
                ddlProductoTasa.DataValueField = "producto_id";
                ddlProductoTasa.DataBind();

                ddlProductoTasa.Items.Insert(0,
                    new ListItem("-- Seleccione Producto --", ""));

                var dtPlazos = ctrPlazo.ListarPlazos();


                ddlPlazoTasa.Items.Clear();
                ddlPlazoTasa.Items.Insert(0, new ListItem("-- Seleccione Plazo --", ""));

                foreach (DataRow row in dtPlazos.Rows)
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

                    if (texto == "")
                        texto = "0 días";

                    ddlPlazoTasa.Items.Add(
                        new ListItem(texto, row["plazo_id"].ToString())
                    );
                }

                ddlPlazoTasa.Items.Insert(0,
                    new ListItem("-- Seleccione Plazo --", ""));

                if (ModoNuevo)
                {
                    ddlProductoTasa.Visible = true;
                    ddlPlazoTasa.Visible = true;
                }
            }
        }

        protected void ddlProductoBuscar_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ModoOperacion == "Eliminar" || ModoNuevo)
                return;

            if (!string.IsNullOrEmpty(ddlProductoBuscar.SelectedValue))
            {
                pnlFormulario.Visible = true;
                pnlProducto.Visible = true;

                ModoOperacion = "Editar";

                lblMensaje.Text = "Modo edición activado";
                lblMensaje.CssClass = "text-warning";

                int id = Convert.ToInt32(ddlProductoBuscar.SelectedValue);
                mdlProducto prod = ctrProducto.ObtenerProductoPorId(id);

                txtNombreProducto.Text = prod.Nombre;

                if (ddlMonedaProducto.Items.FindByValue(prod.MonedaId.ToString()) != null)
                {
                    ddlMonedaProducto.SelectedValue = prod.MonedaId.ToString();
                }
            }
        }

        protected void ddlPlazoBuscar_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ModoOperacion == "Eliminar" || ModoNuevo)
                return;

            if (!string.IsNullOrEmpty(ddlPlazoBuscar.SelectedValue))
            {
                ModoOperacion = "Editar";

                lblMensaje.Text = "Modo edición activado";
                lblMensaje.CssClass = "text-warning";

                int id = Convert.ToInt32(ddlPlazoBuscar.SelectedValue);

                mdlPlazo plazo = ctrPlazo.ObtenerPlazoPorId(id);

                txtMesesPlazo.Text = plazo.Meses.ToString();

                if (ddlDiasPlazo.Items.FindByValue(plazo.Dias.ToString()) != null)
                {
                    ddlDiasPlazo.SelectedValue = plazo.Dias.ToString();
                }
            }
        }

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

                if (texto == "")
                    texto = "0 días";

                ddlPlazoTasa.Items.Add(
                    new ListItem(texto, row["plazo_id"].ToString())
                );
            }

            if (ddlPlazoTasa.Items.Count > 1)
            {
                ddlPlazoTasa.SelectedIndex = 0;
            }



            txtTasaEditar.Text = "";
            ViewState["TasaId"] = null;
        }

        protected void ddlPlazoTasa_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlProductoTasa.SelectedValue == "" || ddlPlazoTasa.SelectedValue == "")
                return;

            int productoId = Convert.ToInt32(ddlProductoTasa.SelectedValue);
            int plazoId = Convert.ToInt32(ddlPlazoTasa.SelectedValue);

            mdlTasa tasa = ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

            if (tasa != null)
            {
                ViewState["TasaId"] = tasa.TasaId;
                txtTasaEditar.Text = tasa.TasaAnual.ToString("0.####");
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {


            if (ModoOperacion == "Eliminar")
            {
                EjecutarEliminacion();
                return;
            }

            if (ddlEntidad.SelectedValue == "Producto")
            {
                if (string.IsNullOrEmpty(txtNombreProducto.Text))
                {
                    lblMensaje.Text = "Debe ingresar el nombre del producto.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                if (string.IsNullOrEmpty(ddlMonedaProducto.SelectedValue))
                {
                    lblMensaje.Text = "Debe seleccionar una moneda.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                if (ModoNuevo)
                {
                    mdlProducto prod = new mdlProducto();

                    prod.Codigo = Guid.NewGuid().ToString().Substring(0, 8);
                    prod.Nombre = txtNombreProducto.Text;
                    prod.MonedaId = Convert.ToInt32(ddlMonedaProducto.SelectedValue);

                    int productoId = ctrProducto.InsertarProducto(prod);

                    if (productoId == 0)
                    {
                        lblMensaje.Text = prod.Mensaje;
                        lblMensaje.CssClass = "text-danger";
                        return;
                    }

                    foreach (GridViewRow row in gvTasasProducto.Rows)
                    {
                        int plazoId = Convert.ToInt32(
                            ((HiddenField)row.FindControl("hfPlazoId")).Value);

                        decimal tasa = Convert.ToDecimal(
                            ((TextBox)row.FindControl("txtTasa")).Text);

                        mdlTasa tasaExistente =
                            ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                        mdlTasa tasaObj = new mdlTasa
                        {
                            ProductoId = productoId,
                            PlazoId = plazoId,
                            TasaAnual = tasa
                        };

                        if (tasaExistente != null && tasaExistente.TasaId > 0)
                        {
                            tasaObj.TasaId = tasaExistente.TasaId;
                            ctrTasa.ActualizarTasa(tasaObj);
                        }
                        else
                        {
                            ctrTasa.InsertarTasa(tasaObj);
                        }
                    }

                    lblMensaje.Text = "Producto creado correctamente con sus tasas.";
                    lblMensaje.CssClass = "text-success";
                }
                else
                {
                    if (string.IsNullOrEmpty(ddlProductoBuscar.SelectedValue))
                    {
                        lblMensaje.Text = "Seleccione un producto.";
                        lblMensaje.CssClass = "text-danger";
                        return;
                    }

                    int productoId = Convert.ToInt32(ddlProductoBuscar.SelectedValue);

                    mdlProducto prod = ctrProducto.ObtenerProductoPorId(productoId);
                    prod.Nombre = txtNombreProducto.Text;
                    prod.MonedaId = Convert.ToInt32(ddlMonedaProducto.SelectedValue);

                    bool resultado = ctrProducto.ActualizarProducto(prod);

                    foreach (GridViewRow row in gvTasasProducto.Rows)
                    {
                        int plazoId = Convert.ToInt32(
                            ((HiddenField)row.FindControl("hfPlazoId")).Value);

                        decimal tasa = Convert.ToDecimal(
                            ((TextBox)row.FindControl("txtTasa")).Text);

                        mdlTasa tasaExistente =
                            ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                        mdlTasa tasaObj = new mdlTasa
                        {
                            ProductoId = productoId,
                            PlazoId = plazoId,
                            TasaAnual = tasa
                        };

                        if (tasaExistente != null && tasaExistente.TasaId > 0)
                        {
                            tasaObj.TasaId = tasaExistente.TasaId;
                            ctrTasa.ActualizarTasa(tasaObj);
                        }
                        else
                        {
                            ctrTasa.InsertarTasa(tasaObj);
                        }
                    }

                    if (resultado)
                    {
                        lblMensaje.Text = "Producto y tasas actualizados correctamente.";
                        lblMensaje.CssClass = "text-success";
                    }
                    else
                    {
                        lblMensaje.Text = "Error al actualizar el producto.";
                        lblMensaje.CssClass = "text-danger";
                    }
                }

                ModoNuevo = false;
                ModoOperacion = "";
            }
            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                if (string.IsNullOrEmpty(txtMesesPlazo.Text) && string.IsNullOrEmpty(ddlDiasPlazo.SelectedValue))
                {
                    lblMensaje.Text = "Debe ingresar meses o días para el plazo.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                int meses = string.IsNullOrEmpty(txtMesesPlazo.Text)
                    ? 0
                    : Convert.ToInt32(txtMesesPlazo.Text);

                int dias = string.IsNullOrEmpty(ddlDiasPlazo.SelectedValue)
                    ? 0
                    : Convert.ToInt32(ddlDiasPlazo.SelectedValue);

                if (meses < 0 || dias < 0)
                {
                    lblMensaje.Text = "Los valores no pueden ser negativos.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                if (string.IsNullOrEmpty(ddlPlazoBuscar.SelectedValue))
                {
                    mdlPlazo plazo = new mdlPlazo();

                    meses = 0;
                    dias = 0;

                    if (!string.IsNullOrWhiteSpace(txtMesesPlazo.Text))
                    {
                        meses = Convert.ToInt32(txtMesesPlazo.Text);
                    }

                    if (!string.IsNullOrWhiteSpace(ddlDiasPlazo.SelectedValue))
                    {
                        dias = Convert.ToInt32(ddlDiasPlazo.SelectedValue);
                    }

                    plazo.Meses = meses;
                    plazo.Dias = dias;

                    if (meses == 0 && dias == 0)
                    {
                        lblMensaje.Text = "Debe ingresar meses o días.";
                        lblMensaje.CssClass = "text-danger";
                        return;
                    }

                    int plazoId = ctrPlazo.InsertarPlazo(plazo);

                    if (plazoId == 0)
                    {
                        lblMensaje.Text = plazo.Mensaje;
                        lblMensaje.CssClass = "text-danger";
                        return;
                    }

                    foreach (GridViewRow row in gvTasasPlazo.Rows)
                    {
                        int productoId = Convert.ToInt32(
                            ((HiddenField)row.FindControl("hfProductoId")).Value);

                        decimal tasa = Convert.ToDecimal(
                            ((TextBox)row.FindControl("txtTasa")).Text);

                        mdlTasa tasaObj = new mdlTasa
                        {
                            ProductoId = productoId,
                            PlazoId = plazoId,
                            TasaAnual = tasa
                        };

                        ctrTasa.InsertarTasa(tasaObj);
                    }

                    lblMensaje.Text = "Plazo creado correctamente.";
                    lblMensaje.CssClass = "text-success";
                }
                else
                {
                    int plazoId = Convert.ToInt32(ddlPlazoBuscar.SelectedValue);

                    mdlPlazo plazo = ctrPlazo.ObtenerPlazoPorId(plazoId);

                    plazo.Meses = Convert.ToInt32(txtMesesPlazo.Text);
                    plazo.Dias = string.IsNullOrEmpty(ddlDiasPlazo.SelectedValue)
                        ? 0
                        : Convert.ToInt32(ddlDiasPlazo.SelectedValue);

                    bool resultado = ctrPlazo.ActualizarPlazo(plazo);

                    foreach (GridViewRow row in gvTasasPlazo.Rows)
                    {
                        int productoId = Convert.ToInt32(
                            ((HiddenField)row.FindControl("hfProductoId")).Value);

                        decimal tasa = Convert.ToDecimal(
                            ((TextBox)row.FindControl("txtTasa")).Text);

                        mdlTasa tasaExistente =
                            ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                        mdlTasa tasaObj = new mdlTasa
                        {
                            ProductoId = productoId,
                            PlazoId = plazoId,
                            TasaAnual = tasa
                        };

                        if (tasaExistente != null && tasaExistente.TasaId > 0)
                        {
                            tasaObj.TasaId = tasaExistente.TasaId;
                            ctrTasa.ActualizarTasa(tasaObj);
                        }
                        else
                        {
                            ctrTasa.InsertarTasa(tasaObj);
                        }
                    }

                    lblMensaje.Text = resultado
                        ? "Plazo y tasas actualizados correctamente."
                        : "Error al actualizar el plazo.";

                    lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
                }
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

                decimal tasaValor;

                if (!decimal.TryParse(txtTasaEditar.Text, out tasaValor))
                {
                    lblMensaje.Text = "Debe ingresar una tasa válida.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                if (tasaValor <= 0)
                {
                    lblMensaje.Text = "La tasa debe ser mayor a 0.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                mdlTasa tasa = new mdlTasa
                {
                    ProductoId = productoId,
                    PlazoId = plazoId,
                    TasaAnual = tasaValor
                };

                bool resultado;

                if (ViewState["TasaId"] != null && Convert.ToInt32(ViewState["TasaId"]) > 0)
                {
                    tasa.TasaId = Convert.ToInt32(ViewState["TasaId"]);
                    resultado = ctrTasa.ActualizarTasa(tasa);

                    ModoOperacion = "Editar";
                    lblMensaje.Text = resultado
                        ? "Tasa actualizada correctamente."
                        : "Error al actualizar la tasa.";
                }
                else
                {
                    resultado = ctrTasa.InsertarTasa(tasa);

                    ModoOperacion = "Nuevo";
                    lblMensaje.Text = resultado
                        ? "Tasa creada correctamente."
                        : "Error al crear la tasa.";
                }

                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";

                if (ViewState["TasaId"] != null)
                {
                    ModoOperacion = "Editar";
                    lblMensaje.Text = "Tasa actualizada correctamente.";
                }
                else
                {
                    ModoOperacion = "Nuevo";
                    lblMensaje.Text = "Tasa creada correctamente.";
                }
            }

            CargarTablaFinanciera();

            ModoNuevo = false;
            ModoOperacion = "Editar";

            string mensaje = lblMensaje.Text;
            string css = lblMensaje.CssClass;

            LimpiarFormulario();

            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = css;

        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            ModoOperacion = "Eliminar";

            lblMensaje.Text = "Modo eliminación activado. Seleccione el registro y presione Guardar.";
            lblMensaje.CssClass = "text-danger";

            MostrarModoEliminar();
        }
        private void EjecutarEliminacion()
        {
            if (ddlEntidad.SelectedValue == "Producto")
            {
                if (string.IsNullOrEmpty(ddlProductoBuscar.SelectedValue))
                {
                    lblMensaje.Text = "Seleccione un producto para eliminar.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                int id = Convert.ToInt32(ddlProductoBuscar.SelectedValue);
                string mensaje;

                bool resultado = ctrProducto.EliminarProducto(id, out mensaje);

                lblMensaje.Text = mensaje;
                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
            }

            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                if (string.IsNullOrEmpty(ddlPlazoBuscar.SelectedValue))
                {
                    lblMensaje.Text = "Seleccione un plazo para eliminar.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                int id = Convert.ToInt32(ddlPlazoBuscar.SelectedValue);
                string mensaje;

                bool resultado = ctrPlazo.EliminarPlazo(id, out mensaje);

                lblMensaje.Text = mensaje;
                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
            }

            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                if (ddlProductoTasa.SelectedValue == "" || ddlPlazoTasa.SelectedValue == "")
                {
                    lblMensaje.Text = "Seleccione producto y plazo.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                int productoId = Convert.ToInt32(ddlProductoTasa.SelectedValue);
                int plazoId = Convert.ToInt32(ddlPlazoTasa.SelectedValue);

                mdlTasa tasa = ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                if (tasa == null)
                {
                    lblMensaje.Text = "No existe tasa para eliminar.";
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                bool resultado = ctrTasa.EliminarTasa(tasa.TasaId);

                lblMensaje.Text = resultado
                    ? "Tasa eliminada correctamente."
                    : "Error al eliminar la tasa.";

                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";
            }

            CargarTablaFinanciera();

            LimpiarFormulario();
        }

        private void MostrarModoEliminar()
        {
            pnlProducto.Visible = false;
            pnlPlazo.Visible = false;
            pnlTasaFiltros.Visible = false;

            if (ddlEntidad.SelectedValue == "Producto")
            {
                pnlProducto.Visible = true;

                ddlProductoBuscar.DataSource = ctrProducto.ListarProductos();
                ddlProductoBuscar.DataTextField = "nombre";
                ddlProductoBuscar.DataValueField = "producto_id";
                ddlProductoBuscar.DataBind();
                ddlProductoBuscar.Items.Insert(0, new ListItem("-- Seleccione --", ""));

                pnlNombreProducto.Visible = false;
                pnlMonedaProducto.Visible = false;
                pnlPlazosProducto.Visible = false;
                pnlTasasProducto.Visible = false;
            }

            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                pnlPlazo.Visible = true;

                var dtPlazos = ctrPlazo.ListarPlazos();

                ddlPlazoBuscar.Items.Clear();
                ddlPlazoBuscar.Items.Insert(0, new ListItem("-- Seleccione --", ""));

                foreach (DataRow row in dtPlazos.Rows)
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

                pnlMesesPlazo.Visible = false;
                pnlDiasPlazo.Visible = false;
                pnlProductosPlazo.Visible = false;
                pnlTasasPlazo.Visible = false;
            }

            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                pnlTasaFiltros.Visible = true;

                ddlProductoTasa.DataSource = ctrProducto.ListarProductos();
                ddlProductoTasa.DataTextField = "nombre";
                ddlProductoTasa.DataValueField = "producto_id";
                ddlProductoTasa.DataBind();
                ddlProductoTasa.Items.Insert(0,
                    new ListItem("-- Seleccione Producto --", ""));

                var dtPlazos = ctrPlazo.ListarPlazos();

                ddlPlazoTasa.Items.Clear();
                ddlPlazoTasa.Items.Insert(0,
                    new ListItem("-- Seleccione Plazo --", ""));

                foreach (DataRow row in dtPlazos.Rows)
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

                    if (texto == "")
                        texto = "0 días";

                    ddlPlazoTasa.Items.Add(
                        new ListItem(texto, row["plazo_id"].ToString())
                    );
                }

                pnlTasaEditar.Visible = true;
                txtTasaEditar.Enabled = false;
            }
        }
        protected void chkPlazos_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();

            dt.Columns.Add("PlazoId");
            dt.Columns.Add("Plazo");
            dt.Columns.Add("Tasa");

            int productoId = 0;

            if (!string.IsNullOrEmpty(ddlProductoBuscar.SelectedValue))
                productoId = Convert.ToInt32(ddlProductoBuscar.SelectedValue);

            foreach (ListItem item in chkPlazos.Items)
            {
                if (item.Selected)
                {
                    int plazoId = Convert.ToInt32(item.Value);

                    decimal tasa = 0;

                    if (productoId > 0)
                    {
                        mdlTasa tasaExistente =
                            ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                        if (tasaExistente != null)
                            tasa = tasaExistente.TasaAnual;
                    }

                    dt.Rows.Add(plazoId, item.Text, tasa);
                }
            }

            gvTasasProducto.DataSource = dt;
            gvTasasProducto.DataBind();

        }

        protected void chkProductosPlazo_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();

            dt.Columns.Add("ProductoId");
            dt.Columns.Add("Producto");
            dt.Columns.Add("Tasa");

            int plazoId = Convert.ToInt32(ddlPlazoBuscar.SelectedValue);

            foreach (ListItem item in chkProductosPlazo.Items)
            {
                if (item.Selected)
                {
                    int productoId = Convert.ToInt32(item.Value);

                    decimal tasa = 0;

                    mdlTasa tasaExistente =
                        ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                    if (tasaExistente != null)
                    {
                        tasa = tasaExistente.TasaAnual;
                    }

                    dt.Rows.Add(productoId, item.Text, tasa);
                }
            }

            gvTasasPlazo.DataSource = dt;
            gvTasasPlazo.DataBind();
        }

        protected void btnNuevo_Click(object sender, EventArgs e)
        {
            ModoNuevo = true;
            ModoOperacion = "Nuevo";

            if (ddlEntidad.SelectedValue == "Producto")
            {
                ddlProductoBuscar.Visible = false;
                txtNombreProducto.Text = "";
            }
            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                ddlPlazoBuscar.Visible = false;

                txtMesesPlazo.Text = "";

                ddlDiasPlazo.SelectedIndex = 0;
            }

            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                ddlProductoTasa.Visible = false;
                ddlPlazoTasa.Visible = false;
                txtTasaEditar.Text = "";
                ViewState["TasaId"] = null;
            }

            lblMensaje.Text = "Modo creación activado";
            lblMensaje.CssClass = "text-success";
        }

        private void CargarMonedas()
        {
            ddlMonedaProducto.DataSource = ctrMoneda.ListarMonedas();
            ddlMonedaProducto.DataTextField = "nombre";
            ddlMonedaProducto.DataValueField = "moneda_id";
            ddlMonedaProducto.DataBind();

            ddlMonedaProducto.Items.Insert(0,
                new ListItem("-- Seleccione moneda --", ""));
        }

        private void CargarPlazos()
        {
            chkPlazos.DataSource = ctrPlazo.ListarPlazos();
            chkPlazos.DataTextField = "descripcion";
            chkPlazos.DataValueField = "plazo_id";
            chkPlazos.DataBind();
        }

        private void LimpiarFormulario()
        {
            ddlEntidad.SelectedIndex = 0;

            pnlFormulario.Visible = true;

            pnlProducto.Visible = false;
            pnlPlazo.Visible = false;
            pnlTasaFiltros.Visible = false;

            if (ddlProductoBuscar.Items.Count > 0)
                ddlProductoBuscar.SelectedIndex = 0;

            txtNombreProducto.Text = "";

            if (ddlMonedaProducto.Items.Count > 0)
                ddlMonedaProducto.SelectedIndex = 0;

            if (ddlPlazoBuscar.Items.Count > 0)
                ddlPlazoBuscar.SelectedIndex = 0;

            txtMesesPlazo.Text = "";
            ddlDiasPlazo.SelectedIndex = 0;

            if (ddlProductoTasa.Items.Count > 0)
                ddlProductoTasa.SelectedIndex = 0;

            if (ddlPlazoTasa.Items.Count > 0)
                ddlPlazoTasa.SelectedIndex = 0;

            txtTasaEditar.Text = "";

            foreach (ListItem item in chkPlazos.Items)
                item.Selected = false;

            gvTasasProducto.DataSource = null;
            gvTasasProducto.DataBind();


        }

        private void CargarDias()
        {
            ddlDiasPlazo.Items.Clear();
            ddlDiasPlazo.Items.Add(new ListItem("-- Seleccione --", ""));

            for (int i = 1; i <= 30; i++)
            {
                ddlDiasPlazo.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
        }

        protected void btnRefrescar_Click(object sender, EventArgs e)
        {
            ModoNuevo = false;
            ModoOperacion = "";

            LimpiarFormulario();

            CargarTablaFinanciera();

            ddlEntidad.SelectedIndex = 0;

            lblMensaje.Text = "Pantalla reiniciada.";
            lblMensaje.CssClass = "text-info";
        }

        protected void btnAtras_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Vistas/DashboardAdministrador.aspx");
        }
    }
}