<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DetalleCotizacion.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.DetalleCotizacion" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Detalle Cotización</title>
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

                <h2 class="page-title">Detalle Cotización</h2>

            </div>

            <div class="card-header card-header-primary">
                Información General
            </div>

            <div class="card-body">

                <asp:GridView 
                    ID="gvResumenCotizacion" 
                    runat="server"
                    AutoGenerateColumns="false"
                    ShowHeader="false"
                    CssClass="tabla-resumen">

                    <Columns>
                        <asp:BoundField DataField="Campo" />
                        <asp:BoundField DataField="Valor" />
                    </Columns>

                </asp:GridView>

            </div>
        </div>

        <div class="card">
            <div class="card-header card-header-dark">
                Detalle Mensual
            </div>

            <div class="card-body">

                <asp:GridView 
                    ID="gvDetalleCotizacion" 
                    runat="server" 
                    AutoGenerateColumns="false" 
                    CssClass="tabla">

                    <Columns>
                        <asp:BoundField DataField="Mes" HeaderText="Mes" />

                        <asp:BoundField 
                            DataField="InteresBrutoFmt" 
                            HeaderText="Interés Bruto" />

                        <asp:BoundField 
                            DataField="ImpuestoFmt" 
                            HeaderText="Impuesto" />

                        <asp:BoundField 
                            DataField="InteresNetoFmt" 
                            HeaderText="Interés Neto" />
                    </Columns>

                </asp:GridView>

            </div>
        </div>

    </div>

</div>

</form>
</body>
</html>