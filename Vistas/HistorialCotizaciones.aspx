<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HistorialCotizaciones.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.HistorialCotizaciones" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Historial Cotizaciones</title>
    <link href="~/Estilos/DashboardCrearCotizacion.css" rel="stylesheet" />
</head>

<body>
<form id="form1" runat="server">

<div class="pagina-cotizacion">

    <div class="col-resultados">

        <div class="card">

            <div class="page-header">

    <asp:Button 
        ID="btnAtras"
        runat="server"
        Text="←"
        CssClass="btn-back-icon"
        OnClick="btnVolver_Click" />

    <h2 class="page-title">Historial de Cotizaciones</h2>

            </div>

            <div class="card-header card-header-primary">
                Cotizaciones Registradas
            </div>

            <div class="card-body">

                <div style="margin-bottom: 15px; text-align: center;">
                    <asp:Button 
                        ID="btnExportarExcel"
                        runat="server"
                        Text="Exportar Todo a Excel"
                        CssClass="btn-export btn-export-excel"
                        OnClick="btnExportarExcel_Click" />
                    
                    <asp:Button 
                        ID="btnExportarPDF"
                        runat="server"
                        Text="Exportar Todo a PDF"
                        CssClass="btn-export btn-export-pdf"
                        OnClick="btnExportarPDF_Click" />
                </div>

                <asp:GridView 
                    ID="gvCotizaciones" 
                    runat="server"
                    AutoGenerateColumns="false"
                    CssClass="tabla"
                    OnRowCommand="gvCotizaciones_RowCommand">


                    <Columns>

                        <asp:BoundField DataField="numero_cotizacion" HeaderText="Número" />
                        <asp:BoundField DataField="cliente" HeaderText="Cliente" />
                        <asp:BoundField DataField="producto" HeaderText="Producto" />

                        <asp:BoundField 
                            DataField="monto" 
                            HeaderText="Monto" 
                            DataFormatString="{0:C}" />

                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button 
                                    ID="btnVer"
                                    runat="server"
                                    Text="Ver Detalle"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("cotizacion_id") %>'
                                    CssClass="btn-accion btn-accion-ver" />
                                
                                <asp:Button 
                                    ID="btnExportarExcelIndividual"
                                    runat="server"
                                    Text="Exportar a Excel"
                                    CommandName="ExportarExcel"
                                    CommandArgument='<%# Eval("cotizacion_id") %>'
                                    CssClass="btn-accion btn-accion-excel" />
                                
                                <asp:Button 
                                    ID="btnExportarPDFIndividual"
                                    runat="server"
                                    Text="Exportar a PDF"
                                    CommandName="ExportarPDF"
                                    CommandArgument='<%# Eval("cotizacion_id") %>'
                                    CssClass="btn-accion btn-accion-pdf" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

        </div>

    </div>

</div>

</form>
</body>
</html>