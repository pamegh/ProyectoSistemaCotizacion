using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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

        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["cotizacionId"] == null)
                return;

            int cotizacionId = Convert.ToInt32(Request.QueryString["cotizacionId"]);
            var cot = ctrCot.ObtenerCotizacionPorId(cotizacionId);
            var detalle = ctrCot.ObtenerDetalleCotizacion(cotizacionId);
            string simbolo = ctrMoneda.ObtenerSimboloMoneda(cot.ProductoId);

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Cotizacion_" + cot.NumeroCotizacion + "_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:x='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'>");
            sb.Append("<head>");
            sb.Append("<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />");
            sb.Append("<style>");
            sb.Append("body { font-family: Arial, sans-serif; }");
            sb.Append("h2 { color: #1693A5; font-weight: bold; font-size: 18px; margin-bottom: 5px; }");
            sb.Append(".fecha-gen { font-size: 11px; margin-bottom: 20px; }");
            sb.Append("table { border-collapse: collapse; width: 100%; margin-top: 10px; margin-bottom: 20px; }");
            sb.Append("th { background-color: white; color: black; font-weight: bold; padding: 8px; border: 1px solid black; text-align: left; font-size: 11px; }");
            sb.Append("td { padding: 8px; border: 1px solid black; font-size: 11px; }");
            sb.Append(".info-label { font-weight: bold; background-color: #1693A5; color: white; width: 20%; }");
            sb.Append(".info-value { background-color: white; text-align: right; }");
            sb.Append(".tabla-detalle th { background-color: white; color: black; text-align: center; border: 1px solid black; }");
            sb.Append(".tabla-detalle td { text-align: right; background-color: white; border: 1px solid black; }");
            sb.Append(".tabla-detalle .col-mes { text-align: center; }");
            sb.Append("</style>");
            sb.Append("</head>");
            sb.Append("<body>");
            sb.Append("<h2>DETALLE DE COTIZACIÓN</h2>");
            sb.Append("<div class='fecha-gen'>Fecha de generación: " + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") + "</div>");
            
            sb.Append("<table>");
            sb.Append("<tr>");
            sb.Append("<th class='info-label'>Número</th>");
            sb.Append("<td class='info-value'>" + cot.NumeroCotizacion + "</td>");
            sb.Append("<th class='info-label'>Cliente</th>");
            sb.Append("<td class='info-value'>" + cot.NombreCliente + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<th class='info-label'>Teléfono</th>");
            sb.Append("<td class='info-value'>" + cot.Telefono + "</td>");
            sb.Append("<th class='info-label'>Correo</th>");
            sb.Append("<td class='info-value'>" + cot.Correo + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<th class='info-label'>Producto</th>");
            sb.Append("<td class='info-value'>" + cot.NombreProducto + "</td>");
            sb.Append("<th class='info-label'>Monto</th>");
            sb.Append("<td class='info-value'>" + simbolo + " " + cot.Monto.ToString("N2") + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<th class='info-label'>Plazo</th>");
            sb.Append("<td class='info-value'>" + cot.PlazoDescripcion + "</td>");
            sb.Append("<th class='info-label'>Tasa</th>");
            sb.Append("<td class='info-value'>" + cot.TasaAnual.ToString("N2") + "%</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<th class='info-label'>Impuesto</th>");
            sb.Append("<td class='info-value'>" + cot.Impuesto.ToString("N2") + "%</td>");
            sb.Append("<th class='info-label'>Interés Neto</th>");
            sb.Append("<td class='info-value'>" + simbolo + " " + cot.TotalInteresNeto.ToString("N2") + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<th class='info-label'>Fecha</th>");
            sb.Append("<td class='info-value' colspan='3'>" + DateTime.Now.ToString("dd/MM/yyyy") + "</td>");
            sb.Append("</tr>");
            sb.Append("</table>");

            sb.Append("<table class='tabla-detalle'>");
            sb.Append("<tr>");
            sb.Append("<th>MES</th>");
            sb.Append("<th>INTERÉS BRUTO</th>");
            sb.Append("<th>IMPUESTO</th>");
            sb.Append("<th>INTERÉS NETO</th>");
            sb.Append("</tr>");

            foreach (var item in detalle)
            {
                sb.Append("<tr>");
                sb.Append("<td class='col-mes'>" + item.Mes + "</td>");
                sb.Append("<td>" + simbolo + " " + item.InteresBruto.ToString("N2") + "</td>");
                sb.Append("<td>" + simbolo + " " + item.Impuesto.ToString("N2") + "</td>");
                sb.Append("<td>" + simbolo + " " + item.InteresNeto.ToString("N2") + "</td>");
                sb.Append("</tr>");
            }

            sb.Append("</table>");
            sb.Append("</body>");
            sb.Append("</html>");

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        protected void btnExportarPDF_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["cotizacionId"] == null)
                return;

            int cotizacionId = Convert.ToInt32(Request.QueryString["cotizacionId"]);
            var cot = ctrCot.ObtenerCotizacionPorId(cotizacionId);
            var detalle = ctrCot.ObtenerDetalleCotizacion(cotizacionId);
            string simbolo = ctrMoneda.ObtenerSimboloMoneda(cot.ProductoId);

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "text/html";
            Response.AddHeader("content-disposition", "inline;filename=Cotizacion_" + cot.NumeroCotizacion + "_" + DateTime.Now.ToString("yyyyMMdd") + ".html");

            StringBuilder sb = new StringBuilder();
            sb.Append("<!DOCTYPE html>");
            sb.Append("<html>");
            sb.Append("<head>");
            sb.Append("<meta charset='utf-8' />");
            sb.Append("<title>Cotización " + cot.NumeroCotizacion + "</title>");
            sb.Append("<style>");
            sb.Append("@media print { body { margin: 0; } }");
            sb.Append("body { font-family: 'Times New Roman', Times, serif; color: #000; background-color: #fff; padding: 20px; }");
            sb.Append("h2 { color: #1693A5; font-size: 22px; background-color: #D8D8C0; padding: 15px; margin-bottom: 20px; }");
            sb.Append("h3 { color: white; background-color: #222222; font-size: 14px; padding: 10px; margin-top: 20px; margin-bottom: 10px; }");
            sb.Append("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; background-color: white; page-break-inside: avoid; }");
            sb.Append("th { background-color: #1693A5; color: white; font-weight: bold; padding: 12px; border: 1px solid #ddd; text-align: center; font-size: 11px; }");
            sb.Append("td { padding: 10px; border: 1px solid #EFEFEF; font-size: 11px; }");
            sb.Append("tr:nth-child(even) { background-color: #FAFAF5; }");
            sb.Append(".info-label { font-weight: bold; background-color: #F7F7F2; color: #1693A5; width: 30%; border-right: 2px solid #D8D8C0; }");
            sb.Append(".no-print { display: block; text-align: center; margin: 20px 0; }");
            sb.Append("@media print { .no-print { display: none; } }");
            sb.Append("</style>");
            sb.Append("<script>");
            sb.Append("window.onload = function() { setTimeout(function() { window.print(); }, 500); };");
            sb.Append("</script>");
            sb.Append("</head>");
            sb.Append("<body>");
            
            sb.Append("<div class='no-print'>");
            sb.Append("<button onclick='window.print()' style='background-color: #1693A5; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px;'>Imprimir / Guardar como PDF</button>");
            sb.Append("</div>");
            
            sb.Append("<h2>DETALLE DE COTIZACIÓN</h2>");
            
            sb.Append("<h3>Información General</h3>");
            sb.Append("<table>");
            sb.Append("<tr><td class='info-label'>Número</td><td style='text-align: center;'>" + cot.NumeroCotizacion + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Cliente</td><td style='text-align: center;'>" + cot.NombreCliente + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Teléfono</td><td style='text-align: center;'>" + cot.Telefono + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Correo</td><td style='text-align: center;'>" + cot.Correo + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Producto</td><td style='text-align: center;'>" + cot.NombreProducto + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Monto</td><td style='text-align: center;'>" + simbolo + " " + cot.Monto.ToString("N2") + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Plazo</td><td style='text-align: center;'>" + cot.PlazoDescripcion + "</td></tr>");
            sb.Append("<tr><td class='info-label'></td><td style='text-align: center;'></td></tr>");
            sb.Append("<tr><td class='info-label'>Tasa</td><td style='text-align: center;'>" + cot.TasaAnual.ToString("N2") + " %</td></tr>");
            sb.Append("<tr><td class='info-label'>Impuesto</td><td style='text-align: center;'>" + cot.Impuesto.ToString("N2") + " %</td></tr>");
            sb.Append("<tr><td class='info-label'>Interés Neto</td><td style='text-align: center;'>" + simbolo + " " + cot.TotalInteresNeto.ToString("N2") + "</td></tr>");
            sb.Append("</table>");

            sb.Append("<h3>Detalle Mensual</h3>");
            sb.Append("<table>");
            sb.Append("<thead>");
            sb.Append("<tr>");
            sb.Append("<th>MES</th>");
            sb.Append("<th>INTERÉS BRUTO</th>");
            sb.Append("<th>IMPUESTO</th>");
            sb.Append("<th>INTERÉS NETO</th>");
            sb.Append("</tr>");
            sb.Append("</thead>");
            sb.Append("<tbody>");

            foreach (var item in detalle)
            {
                sb.Append("<tr>");
                sb.Append("<td style='text-align: center;'>" + item.Mes + "</td>");
                sb.Append("<td style='text-align: right;'>" + simbolo + " " + item.InteresBruto.ToString("N2") + "</td>");
                sb.Append("<td style='text-align: right;'>" + simbolo + " " + item.Impuesto.ToString("N2") + "</td>");
                sb.Append("<td style='text-align: right;'>" + simbolo + " " + item.InteresNeto.ToString("N2") + "</td>");
                sb.Append("</tr>");
            }

            sb.Append("</tbody>");
            sb.Append("</table>");
            sb.Append("</body>");
            sb.Append("</html>");

            Response.Write(sb.ToString());
            Response.End();
        }
    }
}