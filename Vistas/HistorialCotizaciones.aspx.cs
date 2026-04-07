using ProyectoSistemaCotizacion.Controladores;
using ProyectoSistemaCotizacion.Modelos;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoSistemaCotizacion.Vistas
{
    public partial class HistorialCotizaciones : System.Web.UI.Page
    {
        ctrCotizacion ctrCot = new ctrCotizacion();
        ctrMoneda ctrMoneda = new ctrMoneda();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCotizaciones();
            }
        }

        protected void gvCotizaciones_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int cotizacionId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "VerDetalle")
            {
                Response.Redirect("DetalleCotizacion.aspx?cotizacionId=" + cotizacionId);
            }
            else if (e.CommandName == "ExportarExcel")
            {
                ExportarCotizacionIndividualExcel(cotizacionId);
            }
            else if (e.CommandName == "ExportarPDF")
            {
                ExportarCotizacionIndividualPDF(cotizacionId);
            }
        }

        private void CargarCotizaciones()
        {
            int? usuarioId = null;

            if (Session["Rol"] != null)
            {
                string rol = Session["Rol"].ToString().ToUpper();
                if (rol != "ADMIN")
                    usuarioId = Convert.ToInt32(Session["UsuarioId"]);
            }

            DataTable dt = ctrCot.ListarCotizaciones(usuarioId);
            gvCotizaciones.DataSource = dt;
            gvCotizaciones.DataBind();

            bool tieneCotizaciones = dt != null && dt.Rows.Count > 0;
            btnExportarExcel.Enabled = tieneCotizaciones;
            btnExportarPDF.Enabled = tieneCotizaciones;
        }

        protected void gvCotizaciones_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCotizaciones.PageIndex = e.NewPageIndex;
            CargarCotizaciones();
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            if (Session["Rol"] != null)
            {
                string rol = Session["Rol"].ToString().ToUpper();
                if (rol == "ADMIN")
                    Response.Redirect("~/Vistas/DashboardAdministrador.aspx");
                else
                    Response.Redirect("~/Vistas/DashboardUsuario.aspx");
            }
            else
            {
                Response.Redirect("~/Login.aspx");
            }
        }

        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            int? usuarioId = null;

            if (Session["Rol"] != null)
            {
                string rol = Session["Rol"].ToString().ToUpper();
                if (rol != "ADMIN")
                    usuarioId = Convert.ToInt32(Session["UsuarioId"]);
            }

            DataTable dt = ctrCot.ListarCotizaciones(usuarioId);

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=HistorialCotizaciones_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xls");
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
            sb.Append("table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }");
            sb.Append("th { background-color: white; color: black; font-weight: bold; padding: 8px; border: 1px solid black; text-align: left; font-size: 11px; }");
            sb.Append("td { padding: 8px; border: 1px solid black; font-size: 11px; }");
            sb.Append(".info-label { font-weight: bold; background-color: #1693A5; color: white; width: 20%; }");
            sb.Append(".info-value { background-color: white; text-align: right; }");
            sb.Append(".tabla-detalle th { background-color: white; color: black; text-align: center; border: 1px solid black; }");
            sb.Append(".tabla-detalle td { text-align: right; background-color: white; border: 1px solid black; }");
            sb.Append(".tabla-detalle .col-mes { text-align: center; }");
            sb.Append(".separador { height: 50px; }");
            sb.Append("</style>");
            sb.Append("</head>");
            sb.Append("<body>");
            sb.Append("<h2>Historial de Cotizaciones</h2>");
            sb.Append("<div class='fecha-gen'>Fecha de generación: " + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") + "</div>");

            foreach (DataRow row in dt.Rows)
            {
                int cotizacionId = Convert.ToInt32(row["cotizacion_id"]);
                var cot = ctrCot.ObtenerCotizacionPorId(cotizacionId);
                var detalle = ctrCot.ObtenerDetalleCotizacion(cotizacionId);
                string simbolo = ctrMoneda.ObtenerSimboloMoneda(cot.ProductoId);

                sb.Append("<table>");
                sb.Append("<tr><th class='info-label'>Número</th><td class='info-value'>" + cot.NumeroCotizacion + "</td><th class='info-label'>Cliente</th><td class='info-value'>" + cot.NombreCliente + "</td></tr>");
                sb.Append("<tr><th class='info-label'>Teléfono</th><td class='info-value'>" + cot.Telefono + "</td><th class='info-label'>Correo</th><td class='info-value'>" + cot.Correo + "</td></tr>");
                sb.Append("<tr><th class='info-label'>Producto</th><td class='info-value'>" + cot.NombreProducto + "</td><th class='info-label'>Monto</th><td class='info-value'>" + simbolo + " " + cot.Monto.ToString("N2") + "</td></tr>");
                sb.Append("<tr><th class='info-label'>Plazo</th><td class='info-value'>" + cot.PlazoDescripcion + "</td><th class='info-label'>Tasa</th><td class='info-value'>" + cot.TasaAnual.ToString("N2") + "%</td></tr>");
                sb.Append("<tr><th class='info-label'>Impuesto</th><td class='info-value'>" + cot.Impuesto.ToString("N2") + "%</td><th class='info-label'>Interés Neto</th><td class='info-value'>" + simbolo + " " + cot.TotalInteresNeto.ToString("N2") + "</td></tr>");
                sb.Append("<tr><th class='info-label'>Fecha</th><td class='info-value' colspan='3'>" + Convert.ToDateTime(row["fecha_creacion"]).ToString("dd/MM/yyyy") + "</td></tr>");
                sb.Append("</table>");

                sb.Append("<table class='tabla-detalle'>");
                sb.Append("<tr><th>MES</th><th>INTERÉS BRUTO</th><th>IMPUESTO</th><th>INTERÉS NETO</th></tr>");

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
                sb.Append("<div class='separador'></div>");
            }

            sb.Append("</body></html>");

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        protected void btnExportarPDF_Click(object sender, EventArgs e)
        {
            int? usuarioId = null;

            if (Session["Rol"] != null)
            {
                string rol = Session["Rol"].ToString().ToUpper();
                if (rol != "ADMIN")
                    usuarioId = Convert.ToInt32(Session["UsuarioId"]);
            }

            DataTable dt = ctrCot.ListarCotizaciones(usuarioId);

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "text/html";
            Response.AddHeader("content-disposition", "inline;filename=HistorialCotizaciones_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".html");

            StringBuilder sb = new StringBuilder();
            sb.Append("<!DOCTYPE html>");
            sb.Append("<html>");
            sb.Append("<head>");
            sb.Append("<meta charset='utf-8' />");
            sb.Append("<title>Historial de Cotizaciones</title>");
            sb.Append("<style>");
            // Elimina encabezado y pie (URL, fecha, título) que agrega el navegador al imprimir
            sb.Append("@page { size: A4; margin: 15mm; @top-center { content: none; } @bottom-center { content: none; } }");
            sb.Append("@media print { body { margin: 0; -webkit-print-color-adjust: exact; print-color-adjust: exact; } .page-break { page-break-after: always; } }");
            sb.Append("body { font-family: 'Times New Roman', Times, serif; color: #000; background-color: #fff; padding: 20px; }");
            sb.Append("h2 { color: #1693A5; font-size: 22px; background-color: #D8D8C0; padding: 15px; margin-bottom: 20px; }");
            sb.Append("h3 { color: white; background-color: #222222; font-size: 14px; padding: 10px; margin-top: 20px; margin-bottom: 10px; }");
            sb.Append("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; background-color: white; page-break-inside: avoid; }");
            sb.Append("th { background-color: #1693A5; color: white; font-weight: bold; padding: 12px; border: 1px solid #ddd; text-align: center; font-size: 11px; }");
            sb.Append("td { padding: 10px; border: 1px solid #EFEFEF; font-size: 11px; }");
            sb.Append("tr:nth-child(even) { background-color: #FAFAF5; }");
            sb.Append(".info-label { font-weight: bold; background-color: #F7F7F2; color: #1693A5; width: 30%; border-right: 2px solid #D8D8C0; }");
            sb.Append(".separador { height: 30px; }");
            sb.Append("</style>");
            // Abre el diálogo de impresión automáticamente al cargar la página
            sb.Append("<script>window.onload = function() { setTimeout(function() { window.print(); }, 500); };</script>");
            sb.Append("</head>");
            sb.Append("<body>");

            // Sin botón ni elementos .no-print — todo lo que esté en el body se imprime directamente
            sb.Append("<h2>Historial de Cotizaciones</h2>");

            foreach (DataRow row in dt.Rows)
            {
                int cotizacionId = Convert.ToInt32(row["cotizacion_id"]);
                var cot = ctrCot.ObtenerCotizacionPorId(cotizacionId);
                var detalle = ctrCot.ObtenerDetalleCotizacion(cotizacionId);
                string simbolo = ctrMoneda.ObtenerSimboloMoneda(cot.ProductoId);

                sb.Append("<h3>Cotización: " + cot.NumeroCotizacion + "</h3>");
                sb.Append("<table>");
                sb.Append("<tr><td class='info-label'>Número</td><td>" + cot.NumeroCotizacion + "</td></tr>");
                sb.Append("<tr><td class='info-label'>Cliente</td><td>" + cot.NombreCliente + "</td></tr>");
                sb.Append("<tr><td class='info-label'>Teléfono</td><td>" + cot.Telefono + "</td></tr>");
                sb.Append("<tr><td class='info-label'>Correo</td><td>" + cot.Correo + "</td></tr>");
                sb.Append("<tr><td class='info-label'>Producto</td><td>" + cot.NombreProducto + "</td></tr>");
                sb.Append("<tr><td class='info-label'>Monto</td><td>" + simbolo + " " + cot.Monto.ToString("N2") + "</td></tr>");
                sb.Append("<tr><td class='info-label'>Plazo</td><td>" + cot.PlazoDescripcion + "</td></tr>");
                sb.Append("<tr><td class='info-label'>Tasa</td><td>" + cot.TasaAnual.ToString("N2") + " %</td></tr>");
                sb.Append("<tr><td class='info-label'>Impuesto</td><td>" + cot.Impuesto.ToString("N2") + " %</td></tr>");
                sb.Append("<tr><td class='info-label'>Interés Neto</td><td>" + simbolo + " " + cot.TotalInteresNeto.ToString("N2") + "</td></tr>");
                sb.Append("<tr><td class='info-label'>Fecha</td><td>" + Convert.ToDateTime(row["fecha_creacion"]).ToString("dd/MM/yyyy") + "</td></tr>");
                sb.Append("</table>");

                sb.Append("<table>");
                sb.Append("<thead><tr><th>MES</th><th>INTERÉS BRUTO</th><th>IMPUESTO</th><th>INTERÉS NETO</th></tr></thead>");
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

                sb.Append("</tbody></table>");
                sb.Append("<div class='separador'></div>");
            }

            sb.Append("</body></html>");

            Response.Write(sb.ToString());
            Response.End();
        }

        private void ExportarCotizacionIndividualExcel(int cotizacionId)
        {
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
            sb.Append("<tr><th class='info-label'>Número</th><td class='info-value'>" + cot.NumeroCotizacion + "</td><th class='info-label'>Cliente</th><td class='info-value'>" + cot.NombreCliente + "</td></tr>");
            sb.Append("<tr><th class='info-label'>Teléfono</th><td class='info-value'>" + cot.Telefono + "</td><th class='info-label'>Correo</th><td class='info-value'>" + cot.Correo + "</td></tr>");
            sb.Append("<tr><th class='info-label'>Producto</th><td class='info-value'>" + cot.NombreProducto + "</td><th class='info-label'>Monto</th><td class='info-value'>" + simbolo + " " + cot.Monto.ToString("N2") + "</td></tr>");
            sb.Append("<tr><th class='info-label'>Plazo</th><td class='info-value'>" + cot.PlazoDescripcion + "</td><th class='info-label'>Tasa</th><td class='info-value'>" + cot.TasaAnual.ToString("N2") + "%</td></tr>");
            sb.Append("<tr><th class='info-label'>Impuesto</th><td class='info-value'>" + cot.Impuesto.ToString("N2") + "%</td><th class='info-label'>Interés Neto</th><td class='info-value'>" + simbolo + " " + cot.TotalInteresNeto.ToString("N2") + "</td></tr>");
            sb.Append("<tr><th class='info-label'>Fecha</th><td class='info-value' colspan='3'>" + DateTime.Now.ToString("dd/MM/yyyy") + "</td></tr>");
            sb.Append("</table>");

            sb.Append("<table class='tabla-detalle'>");
            sb.Append("<tr><th>MES</th><th>INTERÉS BRUTO</th><th>IMPUESTO</th><th>INTERÉS NETO</th></tr>");

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
            sb.Append("</body></html>");

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        private void ExportarCotizacionIndividualPDF(int cotizacionId)
        {
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
            // Elimina encabezado y pie (URL, fecha, título) que agrega el navegador al imprimir
            sb.Append("@page { size: A4; margin: 15mm; @top-center { content: none; } @bottom-center { content: none; } }");
            sb.Append("@media print { body { margin: 0; -webkit-print-color-adjust: exact; print-color-adjust: exact; } }");
            sb.Append("body { font-family: 'Times New Roman', Times, serif; color: #000; background-color: #fff; padding: 20px; }");
            sb.Append("h2 { color: #1693A5; font-size: 22px; background-color: #D8D8C0; padding: 15px; margin-bottom: 20px; }");
            sb.Append("h3 { color: white; background-color: #222222; font-size: 14px; padding: 10px; margin-top: 20px; margin-bottom: 10px; }");
            sb.Append("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; background-color: white; page-break-inside: avoid; }");
            sb.Append("th { background-color: #1693A5; color: white; font-weight: bold; padding: 12px; border: 1px solid #ddd; text-align: center; font-size: 11px; }");
            sb.Append("td { padding: 10px; border: 1px solid #EFEFEF; font-size: 11px; }");
            sb.Append("tr:nth-child(even) { background-color: #FAFAF5; }");
            sb.Append(".info-label { font-weight: bold; background-color: #F7F7F2; color: #1693A5; width: 30%; border-right: 2px solid #D8D8C0; }");
            sb.Append("</style>");
            // Abre el diálogo de impresión automáticamente al cargar la página
            sb.Append("<script>window.onload = function() { setTimeout(function() { window.print(); }, 500); };</script>");
            sb.Append("</head>");
            sb.Append("<body>");

            // Sin botón ni elementos extra — solo el contenido que irá al PDF
            sb.Append("<h2>DETALLE DE COTIZACIÓN</h2>");
            sb.Append("<h3>Información General</h3>");
            sb.Append("<table>");
            sb.Append("<tr><td class='info-label'>Número</td><td>" + cot.NumeroCotizacion + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Cliente</td><td>" + cot.NombreCliente + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Teléfono</td><td>" + cot.Telefono + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Correo</td><td>" + cot.Correo + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Producto</td><td>" + cot.NombreProducto + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Monto</td><td>" + simbolo + " " + cot.Monto.ToString("N2") + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Plazo</td><td>" + cot.PlazoDescripcion + "</td></tr>");
            sb.Append("<tr><td class='info-label'>Tasa</td><td>" + cot.TasaAnual.ToString("N2") + " %</td></tr>");
            sb.Append("<tr><td class='info-label'>Impuesto</td><td>" + cot.Impuesto.ToString("N2") + " %</td></tr>");
            sb.Append("<tr><td class='info-label'>Interés Neto</td><td>" + simbolo + " " + cot.TotalInteresNeto.ToString("N2") + "</td></tr>");
            sb.Append("</table>");

            sb.Append("<h3>Detalle Mensual</h3>");
            sb.Append("<table>");
            sb.Append("<thead><tr><th>MES</th><th>INTERÉS BRUTO</th><th>IMPUESTO</th><th>INTERÉS NETO</th></tr></thead>");
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

            sb.Append("</tbody></table>");
            sb.Append("</body></html>");

            Response.Write(sb.ToString());
            Response.End();
        }
    }
}