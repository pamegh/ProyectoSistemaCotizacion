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

                <div style="margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                    
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <asp:Label ID="lblFiltroMoneda" runat="server" Text="Filtrar por Moneda:" style="font-weight: bold;" />
                        <asp:DropDownList 
                            ID="ddlMoneda" 
                            runat="server" 
                            CssClass="form-control" 
                            style="width: 200px; display: inline-block;"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="ddlMoneda_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:Button 
                            ID="btnLimpiarFiltro"
                            runat="server"
                            Text="Limpiar Filtro"
                            CssClass="btn-filtro"
                            OnClick="btnLimpiarFiltro_Click" />
                    </div>

                    <div style="text-align: center;">
                        <asp:Button 
                            ID="btnExportarExcel"
                            runat="server"
                            Text="Exportar a Excel"
                            CssClass="btn-export btn-export-excel"
                            OnClick="btnExportarExcel_Click" />
                        
                        <asp:Button 
                            ID="btnExportarPDF"
                            runat="server"
                            Text="Exportar a PDF"
                            CssClass="btn-export btn-export-pdf"
                            OnClick="btnExportarPDF_Click" />
                    </div>
                </div>

                <asp:GridView 
                    ID="gvCotizaciones" 
                    runat="server"
                    AutoGenerateColumns="false"
                    CssClass="tabla"
                    AllowPaging="true"
                    PageSize="10"
                    OnPageIndexChanging="gvCotizaciones_PageIndexChanging"
                    OnRowCommand="gvCotizaciones_RowCommand">

                    <PagerStyle CssClass="pager-style" HorizontalAlign="Center" />
                    <PagerSettings Mode="NumericFirstLast" 
                                   FirstPageText="Primera" 
                                   LastPageText="Última" 
                                   PageButtonCount="5" 
                                   Position="Bottom" />

                    <Columns>

                        <asp:BoundField DataField="numero_cotizacion" HeaderText="Número" />
                        <asp:BoundField DataField="cliente" HeaderText="Cliente" />
                        <asp:BoundField DataField="producto" HeaderText="Producto" />

                        <asp:TemplateField HeaderText="Monto">
                            <ItemTemplate>
                                <%# Eval("simbolo_moneda") %> <%# String.Format("{0:N2}", Eval("monto")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

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

                <asp:Label ID="lblSinCotizaciones" 
    runat="server" 
    Visible="false" 
    Text="No tiene cotizaciones registradas." 
    CssClass="text-center text-muted d-block mt-3" />

            </div>

        </div>

    </div>

</div>

</form>
</body>
</html>