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
                <div class="page-header">

    <asp:Button 
        ID="btnAtras"
        runat="server"
        Text="←"
        CssClass="btn-back-icon"
        OnClick="btnVolver_Click" />

    <h2 class="page-title">Historial de Cotizaciones</h2>

</div>

                <h2 class="page-title">Historial de Cotizaciones</h2>

            </div>

            <div class="card-header card-header-primary">
                Cotizaciones Registradas
            </div>

            <div class="card-body">


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
                                    Text="Ver"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("cotizacion_id") %>'
                                    CssClass="btn btn-primary" />
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