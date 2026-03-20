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
    public partial class DetalleCotizacion : System.Web.UI.Page
    {
        ctrCotizacion ctrCot = new ctrCotizacion();
        ctrMoneda ctrMoneda = new ctrMoneda();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["cotizacionId"] != null)
                {
                    int cotizacionId = Convert.ToInt32(Request.QueryString["cotizacionId"]);
                    CargarDetalleCotizacion(cotizacionId);
                }
            }
        }

        private void CargarDetalleCotizacion(int cotizacionId)
        {
            var cot = ctrCot.ObtenerCotizacionPorId(cotizacionId);

            if (cot == null)
            {
                return;
            }

            string simbolo = ctrMoneda.ObtenerSimboloMoneda(cot.ProductoId);

            List<mdlDetalleFila> resumen = new List<mdlDetalleFila>();

            resumen.Add(new mdlDetalleFila { Campo = "Número", Valor = cot.NumeroCotizacion });
            resumen.Add(new mdlDetalleFila { Campo = "Cliente", Valor = cot.NombreCliente });
            resumen.Add(new mdlDetalleFila { Campo = "Teléfono", Valor = cot.Telefono });
            resumen.Add(new mdlDetalleFila { Campo = "Correo", Valor = cot.Correo });
            resumen.Add(new mdlDetalleFila { Campo = "Producto", Valor = cot.NombreProducto });
            resumen.Add(new mdlDetalleFila { Campo = "Monto", Valor = $"{simbolo} {cot.Monto:N2}" });
            resumen.Add(new mdlDetalleFila { Campo = "Plazo", Valor = cot.PlazoDescripcion }); // 👈 importante
            resumen.Add(new mdlDetalleFila { Campo = "", Valor = "" });
            resumen.Add(new mdlDetalleFila { Campo = "Tasa", Valor = cot.TasaAnual.ToString("N2") + " %" });
            resumen.Add(new mdlDetalleFila { Campo = "Impuesto", Valor = cot.Impuesto.ToString("N2") + " %" });
            resumen.Add(new mdlDetalleFila { Campo = "Interés Neto", Valor = $"{simbolo} {cot.TotalInteresNeto:N2}" });

            gvResumenCotizacion.DataSource = resumen;
            gvResumenCotizacion.DataBind();

            var detalle = ctrCot.ObtenerDetalleCotizacion(cotizacionId);

            
            foreach (var item in detalle)
            {
                item.Simbolo = simbolo;

                if (string.IsNullOrEmpty(item.Simbolo))
                {
                    throw new Exception("El símbolo está vacío");
                }
            }

            gvDetalleCotizacion.DataSource = detalle;
            gvDetalleCotizacion.DataBind();
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            string rol = Session["Rol"]?.ToString();

            if (rol == "ADMIN")
                Response.Redirect("HistorialCotizaciones.aspx");
            else
                Response.Redirect("HistorialCotizaciones.aspx");
        }
    }
}