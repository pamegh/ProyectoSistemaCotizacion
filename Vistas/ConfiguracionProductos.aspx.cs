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

        ctrParametros impuesto;
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
                InicializarPantalla();
            }
        }

        private void MostrarMensaje(string texto, string tipo)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = texto;

            string clase = "alert ";

            switch (tipo)
            {
                case "success":
                    clase += "alert-success";
                    break;
                case "error":
                    clase += "alert-danger";
                    break;
                case "warning":
                    clase += "alert-warning";
                    break;
                default:
                    clase += "alert-info";
                    break;
            }

            lblMensaje.CssClass = clase + " d-block text-center fw-bold";
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
            pnlFormulario.Visible = true;

            LimpiarInputs();

            if (ModoOperacion == "Eliminar")
            {
                MostrarModoEliminar();
                return;
            }

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
                ddlProductoBuscar.SelectedIndex = -1;
                CargarPlazos();

                ddlProductoBuscar.Visible = !ModoNuevo;
            }
            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                pnlPlazo.Visible = true;

                chkProductosPlazo.DataSource = ctrProducto.ListarProductos();
                chkProductosPlazo.DataTextField = "nombre";
                chkProductosPlazo.DataValueField = "producto_id";
                chkProductosPlazo.DataBind();

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

                ddlPlazoBuscar.SelectedIndex = -1;
                ddlPlazoBuscar.Visible = !ModoNuevo;
            }
            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                pnlTasaFiltros.Visible = true;
                ddlProductoTasa.Items.Clear();

                ddlProductoTasa.DataSource = ctrProducto.ListarProductos();
                ddlProductoTasa.DataTextField = "nombre";
                ddlProductoTasa.DataValueField = "producto_id";
                ddlProductoTasa.DataBind();

                ddlProductoTasa.Items.Insert(0,
                    new ListItem("-- Seleccione Producto --", ""));
                ddlProductoTasa.SelectedIndex = -1;

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

                ddlPlazoTasa.SelectedIndex = -1;
            }
        }

        protected void ddlProductoBuscar_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ModoOperacion == "Eliminar" || ModoNuevo)
                return;

            if (string.IsNullOrEmpty(ddlProductoBuscar.SelectedValue))
                return;

            pnlFormulario.Visible = true;
            pnlProducto.Visible = true;

            ModoOperacion = "Editar";

            MostrarMensaje("Modo edición activado", "warning");

            int id = Convert.ToInt32(ddlProductoBuscar.SelectedValue);
            mdlProducto prod = ctrProducto.ObtenerProductoPorId(id);

            txtNombreProducto.Text = prod.Nombre;

            if (ddlMonedaProducto.Items.FindByValue(prod.MonedaId.ToString()) != null)
            {
                ddlMonedaProducto.SelectedValue = prod.MonedaId.ToString();
            }
        }

        private void LimpiarInputs()
        {
            txtNombreProducto.Text = "";
            txtMesesPlazo.Text = "";
            txtTasaEditar.Text = "";

            if (ddlMonedaProducto.Items.Count > 0)
                ddlMonedaProducto.SelectedIndex = 0;
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

        protected void ddlImpuestos_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlImpuestos.SelectedValue))
                return;

            ctrParametros ctr = new ctrParametros();

            int impuestoId = Convert.ToInt32(ddlImpuestos.SelectedValue);

            hfParametroId.Value = ddlImpuestos.SelectedValue;

            mdlParametros impuesto = ctr.ObtenerParametroPorId(impuestoId);
            txtClaveImpuesto.Text = impuesto.Clave;
            txtNombreImpuesto.Text = impuesto.Descripcion;
            txtPorcentajeImpuesto.Text = impuesto.Valor;

            lblMensajeImpuesto.Text = "Editando: " + impuesto.Descripcion;
        }

        private void CargarImpuestoActivo()
        {
            ctrParametros ctr = new ctrParametros();

            mdlParametros impuesto = ctr.ObtenerImpuestoActivo();

            if (impuesto.ParametroId > 0)
            {
                lblImpuestoActivo.Text =
                impuesto.Descripcion + " (" + impuesto.Valor + "%)";
            }
        }

        protected void btnGuardarImpuesto_Click(object sender, EventArgs e)
        {
            ctrParametros ctr = new ctrParametros();
            mdlParametros parametro = new mdlParametros();

            parametro.Clave = txtClaveImpuesto.Text.Trim().ToUpper();
            parametro.Valor = txtPorcentajeImpuesto.Text.Trim();
            parametro.Descripcion = txtNombreImpuesto.Text.Trim();

            if (string.IsNullOrEmpty(parametro.Clave))
            {
                lblMensajeImpuesto.Text = "Debe ingresar la clave";
                return;
            }

            if (string.IsNullOrEmpty(parametro.Valor))
            {
                lblMensajeImpuesto.Text = "Debe ingresar el porcentaje";
                return;
            }

            bool resultado;
            int idActivo = 0;

            if (!string.IsNullOrEmpty(hfParametroId.Value))
            {
                parametro.ParametroId = Convert.ToInt32(hfParametroId.Value);

                var actual = ctr.ObtenerParametroPorId(parametro.ParametroId);
                parametro.Estado = actual.Estado;

                resultado = ctr.ActualizarParametro(parametro);
                idActivo = parametro.ParametroId;

                lblMensajeImpuesto.Text = parametro.Mensaje;
            }
            else
            {
                parametro.Estado = "ACTIVO";

                resultado = ctr.InsertarParametro(parametro);

                CargarImpuestos();

                idActivo = Convert.ToInt32(ddlImpuestos.Items[ddlImpuestos.Items.Count - 1].Value);

                lblMensajeImpuesto.Text = parametro.Mensaje;
            }

            string mensaje;
            ctr.ActivarImpuesto(idActivo, out mensaje);

            CargarImpuestos();
            ddlImpuestos.SelectedValue = idActivo.ToString();

            CargarImpuestoActivo();
            LimpiarFormularioImpuesto();
        }

        private void CargarImpuestos()
        {
            ctrParametros ctr = new ctrParametros();

            ddlImpuestos.DataSource = ctr.ListarParametros();
            ddlImpuestos.DataTextField = "descripcion";
            ddlImpuestos.DataValueField = "parametro_id";
            ddlImpuestos.DataBind();

            ddlImpuestos.Items.Insert(0, new ListItem("-- Seleccione impuesto --", ""));
        }

        protected void btnEliminarImpuesto_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlImpuestos.SelectedValue))
            {
                lblMensajeImpuesto.Text = "Seleccione un impuesto para eliminar";
                return;
            }

            ctrParametros ctr = new ctrParametros();

            int parametroId = Convert.ToInt32(ddlImpuestos.SelectedValue);

            string mensaje;

            if (ctr.EliminarParametro(parametroId, out mensaje))
            {
                lblMensajeImpuesto.Text = mensaje;

                CargarImpuestos();
                CargarImpuestoActivo();
            }
            else
            {
                lblMensajeImpuesto.Text = mensaje;
            }
            LimpiarFormularioImpuesto();
        }

        protected void btnNuevoImpuesto_Click(object sender, EventArgs e)
        {
            LimpiarFormularioImpuesto();

            hfParametroId.Value = "";

            ddlImpuestos.ClearSelection();
            ddlImpuestos.Visible = false;

            lblMensajeImpuesto.Text = "Ingrese un nuevo impuesto";

            btnGuardarImpuesto.Text = "Guardar";

            txtNombreImpuesto.Focus();
        }

        private void LimpiarFormularioImpuesto()
        {
            txtClaveImpuesto.Text = "";
            txtNombreImpuesto.Text = "";
            txtPorcentajeImpuesto.Text = "";

            ddlImpuestos.ClearSelection();

            ddlImpuestos.Visible = true;

            hfParametroId.Value = "";

            lblMensajeImpuesto.Text = "";
        }
        protected void ddlPlazoTasa_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtTasaEditar.Text = "";
            ViewState["TasaId"] = null;

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
                    MostrarMensaje("Debe ingresar el nombre del producto.", "error");
                    return;
                }

                if (string.IsNullOrEmpty(ddlMonedaProducto.SelectedValue))
                {
                    MostrarMensaje("Debe seleccionar una moneda.", "error");
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
                        MostrarMensaje(prod.Mensaje, "error");
                        return;
                    }

                    foreach (GridViewRow row in gvTasasProducto.Rows)
                    {
                        int plazoId = Convert.ToInt32(
                            ((HiddenField)row.FindControl("hfPlazoId")).Value);

                        decimal tasa;
                        bool esNumero = decimal.TryParse(
                            ((TextBox)row.FindControl("txtTasa")).Text.Replace(",", "."),
                            System.Globalization.NumberStyles.Any,
                            System.Globalization.CultureInfo.InvariantCulture,
                            out tasa);

                        if (!esNumero)
                        {
                            MostrarMensaje("Ingrese una tasa válida.", "error");
                            return;
                        }

                        if (tasa <= 0 || tasa > 99.9999m)
                        {
                            MostrarMensaje("La tasa debe ser mayor a 0 y menor o igual a 99.9999.", "error");
                            return;
                        }

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
                            if (tasaObj.TasaAnual > 99.9999m)
                            {
                                MostrarMensaje("ERROR REAL: tasa enviada es " + tasaObj.TasaAnual, "error");
                                return;
                            }
                            ctrTasa.InsertarTasa(tasaObj);
                        }
                    }

                    MostrarMensaje("Producto creado correctamente con sus tasas.", "success");
                }
                else
                {
                    if (string.IsNullOrEmpty(ddlProductoBuscar.SelectedValue))
                    {
                        MostrarMensaje("Seleccione un producto.", "error");
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

                        decimal tasa;
                        bool esNumero = decimal.TryParse(
                            ((TextBox)row.FindControl("txtTasa")).Text,
                            out tasa);

                        if (!esNumero)
                        {
                            MostrarMensaje("Ingrese una tasa válida.", "error");
                            return;
                        }

                        if (tasa <= 0 || tasa > 99.9999m)
                        {
                            MostrarMensaje("La tasa debe ser mayor a 0 y menor o igual a 99.9999.", "error");
                            return;
                        }

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
                        MostrarMensaje("Producto y tasas actualizados correctamente.", "success");
                    }
                    else
                    {
                        MostrarMensaje("Error al actualizar el producto.", "error");
                    }
                }

                ModoNuevo = false;
                ModoOperacion = "";
            }
            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                if (string.IsNullOrEmpty(txtMesesPlazo.Text) && string.IsNullOrEmpty(ddlDiasPlazo.SelectedValue))
                {
                    MostrarMensaje("Debe ingresar meses o días para el plazo.", "error");
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
                    MostrarMensaje("Los valores no pueden ser negativos.", "error");
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
                        MostrarMensaje("Debe ingresar meses o días.", "error");
                        return;
                    }

                    int plazoId = ctrPlazo.InsertarPlazo(plazo);

                    if (plazoId == 0)
                    {
                        MostrarMensaje(plazo.Mensaje, "error");
                        return;
                    }

                    foreach (GridViewRow row in gvTasasPlazo.Rows)
                    {
                        int productoId = Convert.ToInt32(
                            ((HiddenField)row.FindControl("hfProductoId")).Value);

                        decimal tasa;
                        bool esNumero = decimal.TryParse(
                            ((TextBox)row.FindControl("txtTasa")).Text,
                            out tasa);

                        if (!esNumero)
                        {
                            MostrarMensaje("Ingrese una tasa válida.", "error");
                            return;
                        }

                        if (tasa <= 0 || tasa > 99.9999m)
                        {
                            MostrarMensaje("La tasa debe ser mayor a 0 y menor o igual a 99.9999.", "error");
                            return;
                        }

                        mdlTasa tasaObj = new mdlTasa
                        {
                            ProductoId = productoId,
                            PlazoId = plazoId,
                            TasaAnual = tasa
                        };

                        ctrTasa.InsertarTasa(tasaObj);
                    }

                    MostrarMensaje("Plazo creado correctamente.", "success"); ;
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

                        decimal tasa;
                        bool esNumero = decimal.TryParse(
                            ((TextBox)row.FindControl("txtTasa")).Text,
                            out tasa);

                        if (!esNumero)
                        {
                            MostrarMensaje("Ingrese una tasa válida.", "error");
                            return;
                        }

                        if (tasa <= 0 || tasa > 99.9999m)
                        {
                            MostrarMensaje("La tasa debe ser mayor a 0 y menor o igual a 99.9999.", "error");
                            return;
                        }

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

                    MostrarMensaje(
                resultado ? "Plazo y tasas actualizados correctamente." : "Error al actualizar el plazo.",
                resultado ? "success" : "error"
            );
                }
            }
            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                if (string.IsNullOrEmpty(ddlProductoTasa.SelectedValue) ||
                    string.IsNullOrEmpty(ddlPlazoTasa.SelectedValue))
                {
                    MostrarMensaje("Debe seleccionar producto y plazo.", "error");
                    return;
                }

                int productoId = Convert.ToInt32(ddlProductoTasa.SelectedValue);
                int plazoId = Convert.ToInt32(ddlPlazoTasa.SelectedValue);

                decimal tasaValor;

                if (!decimal.TryParse(txtTasaEditar.Text, out tasaValor))
                {
                    MostrarMensaje("Debe ingresar una tasa válida.", "error");
                    return;
                }

                if (tasaValor <= 0 || tasaValor > 99.9999m)
                {
                    MostrarMensaje("La tasa debe ser mayor a 0 y menor o igual a 99.9999.", "error");
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
                    MostrarMensaje(
    resultado ? "Tasa actualizada correctamente." : "Error al actualizar la tasa.",
    resultado ? "success" : "error"
);
                }
                else
                {
                    resultado = ctrTasa.InsertarTasa(tasa);

                    MostrarMensaje(
           resultado ? "Tasa guardada correctamente." : "Error al guardar la tasa.",
           resultado ? "success" : "error"
       );
                }

                lblMensaje.CssClass = resultado ? "text-success" : "text-danger";

                if (ViewState["TasaId"] != null)
                {
                    ModoOperacion = "Editar";
                    MostrarMensaje("Tasa actualizada correctamente.", "success");
                }
                else
                {
                    ModoOperacion = "Nuevo";
                    MostrarMensaje("Tasa creada correctamente.", "success");
                }
            }

            CargarTablaFinanciera();
            RecargarCombos();

            string mensaje = lblMensaje.Text;
            string css = lblMensaje.CssClass;
            
                LimpiarFormulario();
            ddlProductoBuscar.ClearSelection();

            if (ddlProductoBuscar.Items.Count > 0)
                ddlProductoBuscar.SelectedIndex = 0;

            if (ddlPlazoBuscar.Items.Count > 0)
                ddlPlazoBuscar.SelectedIndex = 0;



        }

        private void RecargarCombos()
        {
            var productos = ctrProducto.ListarProductos();

            ddlProductoBuscar.DataSource = productos;
            ddlProductoBuscar.DataBind();
            ddlProductoBuscar.Items.Insert(0, new ListItem("-- Seleccione --", ""));

            ddlProductoTasa.DataSource = productos;
            ddlProductoTasa.DataBind();
            ddlProductoTasa.Items.Insert(0, new ListItem("-- Seleccione --", ""));

            chkProductosPlazo.DataSource = productos;
            chkProductosPlazo.DataBind();

            
            CargarMonedas();
        }

        private void LimpiarCampos()
        {
            txtNombreProducto.Text = "";

            if (ddlMonedaProducto.Items.Count > 0)
                ddlMonedaProducto.SelectedIndex = 0;

            if (ddlProductoBuscar.Items.Count > 0)
            {
                ddlProductoBuscar.ClearSelection();
                ddlProductoBuscar.SelectedIndex = 0;
            }

            foreach (ListItem item in chkPlazos.Items)
                item.Selected = false;

            gvTasasProducto.DataSource = null;
            gvTasasProducto.DataBind();

            // PLAZO
            if (ddlPlazoBuscar.Items.Count > 0)
            {
                ddlPlazoBuscar.ClearSelection();
                ddlPlazoBuscar.SelectedIndex = 0;
            }

            txtMesesPlazo.Text = "";

            if (ddlDiasPlazo.Items.Count > 0)
                ddlDiasPlazo.SelectedIndex = 0;

            foreach (ListItem item in chkProductosPlazo.Items)
                item.Selected = false;

            gvTasasPlazo.DataSource = null;
            gvTasasPlazo.DataBind();

            // TASA
            if (ddlProductoTasa.Items.Count > 0)
            {
                ddlProductoTasa.ClearSelection();
                ddlProductoTasa.SelectedIndex = 0;
            }

            if (ddlPlazoTasa.Items.Count > 0)
            {
                ddlPlazoTasa.ClearSelection();
                ddlPlazoTasa.SelectedIndex = 0;
            }

            txtTasaEditar.Text = "";
            ViewState["TasaId"] = null;
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            pnlFormulario.Visible = true;
            ModoOperacion = "Eliminar";
            MostrarModoEliminar();
            MostrarMensaje(
       "Modo eliminación activado. Seleccione el registro y presione Guardar.",
       "warning"
   );

        }
        private void EjecutarEliminacion()
        {
            if (ddlEntidad.SelectedValue == "Producto")
            {
                if (string.IsNullOrEmpty(ddlProductoBuscar.SelectedValue))
                {
                    MostrarMensaje("Seleccione un producto para eliminar.", "error");
                    return;
                }

                int id = Convert.ToInt32(ddlProductoBuscar.SelectedValue);
                string mensaje;

                bool resultado = ctrProducto.EliminarProducto(id, out mensaje);

                MostrarMensaje(mensaje, resultado ? "success" : "error");
            }

            else if (ddlEntidad.SelectedValue == "Plazo")
            {
                if (string.IsNullOrEmpty(ddlPlazoBuscar.SelectedValue))
                {
                    MostrarMensaje("Seleccione un plazo para eliminar.", "error");
                    lblMensaje.CssClass = "text-danger";
                    return;
                }

                int id = Convert.ToInt32(ddlPlazoBuscar.SelectedValue);
                string mensaje;

                bool resultado = ctrPlazo.EliminarPlazo(id, out mensaje);

                MostrarMensaje(mensaje, resultado ? "success" : "error");
            }

            else if (ddlEntidad.SelectedValue == "Tasa")
            {
                if (ddlProductoTasa.SelectedValue == "" || ddlPlazoTasa.SelectedValue == "")
                {
                    MostrarMensaje("Seleccione producto y plazo.", "error");
                    return;
                }

                int productoId = Convert.ToInt32(ddlProductoTasa.SelectedValue);
                int plazoId = Convert.ToInt32(ddlPlazoTasa.SelectedValue);

                mdlTasa tasa = ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                if (tasa == null)
                {
                    MostrarMensaje("No existe tasa para eliminar.", "error");
                    return;
                }

                bool resultado = ctrTasa.EliminarTasa(tasa.TasaId);

                MostrarMensaje(
          resultado ? "Tasa eliminada correctamente." : "Error al eliminar la tasa.",
          resultado ? "success" : "error"
      );
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

                ddlProductoBuscar.Items.Clear();
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
                ddlProductoTasa.Items.Clear();

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
            dt.Columns.Add("Plazo");
            dt.Columns.Add("PlazoId");
            dt.Columns.Add("Tasa");

            foreach (ListItem item in chkPlazos.Items)
            {
                if (item.Selected)
                {
                    DataRow row = dt.NewRow();
                    row["Plazo"] = item.Text;
                    row["PlazoId"] = item.Value;

                    if (ModoNuevo)
                    {
                        row["Tasa"] = "";
                    }
                    else
                    {
                        int productoId = Convert.ToInt32(ddlProductoBuscar.SelectedValue);
                        int plazoId = Convert.ToInt32(item.Value);

                        mdlTasa tasa = ctrTasa.ObtenerTasaPorProductoYPlazo(productoId, plazoId);

                        row["Tasa"] = tasa != null ? tasa.TasaAnual.ToString("0.####") : "";
                    }

                    dt.Rows.Add(row);
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

            if (ModoNuevo)
            {
                gvTasasProducto.DataSource = null;
                gvTasasProducto.DataBind();

                gvTasasPlazo.DataSource = null;
                gvTasasPlazo.DataBind();

                return;
            }

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
            pnlFormulario.Visible = true;
            ModoNuevo = true;
            ModoOperacion = "Nuevo";

            txtNombreProducto.Text = "";

            if (ddlMonedaProducto.Items.Count > 0)
                ddlMonedaProducto.SelectedIndex = 0;

            foreach (ListItem item in chkPlazos.Items)
                item.Selected = false;

            gvTasasProducto.DataSource = null;
            gvTasasProducto.DataBind();

            txtMesesPlazo.Text = "";
            ddlDiasPlazo.SelectedIndex = 0;

            foreach (ListItem item in chkProductosPlazo.Items)
                item.Selected = false;

            gvTasasPlazo.DataSource = null;
            gvTasasPlazo.DataBind();

            txtTasaEditar.Text = "";
            ViewState["TasaId"] = null;

            ddlProductoBuscar.Visible = false;
            ddlPlazoBuscar.Visible = false;

            MostrarMensaje("Modo creación activado", "success");

            ViewState["ListaTasas"] = null;
            gvTasasProducto.DataSource = null;
            gvTasasProducto.DataBind();
        }

        private void CargarMonedas()
        {
            DataTable dt = ctrMoneda.ListarMonedas();

            ddlMonedaProducto.Items.Clear();

            foreach (DataRow row in dt.Rows)
            {
                ddlMonedaProducto.Items.Add(new ListItem(
                    $"{row["Nombre"]} ({row["Simbolo"]})",
                    row["moneda_id"].ToString()
                ));
            }

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

        void LimpiarFormulario()
        {
            txtNombreProducto.Text = "";
            txtMesesPlazo.Text = "";
            txtTasaEditar.Text = "";

            foreach (ListItem item in chkPlazos.Items)
                item.Selected = false;

            foreach (ListItem item in chkProductosPlazo.Items)
                item.Selected = false;

            gvTasasProducto.DataSource = null;
            gvTasasProducto.DataBind();

            gvTasasPlazo.DataSource = null;
            gvTasasPlazo.DataBind();

            ViewState["TasaId"] = null;

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
            InicializarPantalla();
        }

        private void InicializarPantalla()
        {
            CargarTablaFinanciera();
            CargarMonedas();
            CargarDias();
            CargarImpuestos();
            CargarImpuestoActivo();

            pnlFormulario.Visible = false;
            pnlProducto.Visible = false;
            pnlPlazo.Visible = false;
            pnlTasaFiltros.Visible = false;

            ResetDropDown(ddlEntidad);
            ResetDropDown(ddlProductoBuscar);
            ResetDropDown(ddlPlazoBuscar);
            ResetDropDown(ddlProductoTasa);
            ResetDropDown(ddlPlazoTasa);

            pnlMensaje.Visible = false;
            lblMensaje.Text = "";

            ModoOperacion = "";
            ModoNuevo = false;
        }

        private void ResetDropDown(DropDownList ddl)
        {
            ddl.ClearSelection();

            if (ddl.Items.Count > 0)
            {
                ddl.SelectedIndex = -1; // 🔥 clave real
            }
        }

        protected void btnAtras_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Vistas/DashboardAdministrador.aspx");
        }

    }
}