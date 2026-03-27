<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CrearCotizacion.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.CrearCotizacion" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Crear Cotización</title>
    <link href="~/Estilos/DashboardCrearCotizacion.css" rel="stylesheet" type="text/css"/>
</head>

<body>
<form id="form2" runat="server">

<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

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

    <h2 class="page-title">Crear Cotización</h2>

</div>
            <div class="card-header card-header-primary">
                Detalle Cotización
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
                        <asp:BoundField DataField="Mes"          HeaderText="Mes" />
                        <asp:BoundField DataField="InteresBrutoFmt" HeaderText="Interés Bruto" />
<asp:BoundField DataField="ImpuestoFmt" HeaderText="Impuesto" />
<asp:BoundField DataField="InteresNetoFmt" HeaderText="Interés Neto" />
                    </Columns>
                </asp:GridView>

            </div>
        </div>

    </div>

    <div class="col-formulario">

        <div class="card">
            <div class="card-header card-header-primary">
                Generar Cotización
            </div>
            <div class="card-body">

                <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="mensaje mensaje-error"></asp:Label>

                <div class="form-group" id="divBuscarUsuario" runat="server">
                    <label id="lblTituloUsuario" runat="server" class="form-label">
    Buscar usuario
</label>

                    <asp:TextBox 
                        ID="txtBuscarUsuario" 
                        runat="server" 
                        CssClass="form-input">
                    </asp:TextBox>

                    <asp:HiddenField ID="hfUsuarioId" runat="server" />

                    <ajax:AutoCompleteExtender
                        ID="AutoCompleteExtender1"
                        runat="server"
                        TargetControlID="txtBuscarUsuario"
                        ServiceMethod="BuscarUsuariosAjax"
                        MinimumPrefixLength="2"
                        CompletionInterval="100"
                        EnableCaching="false"
                        CompletionSetCount="10"
                        OnClientItemSelected="usuarioSeleccionado">
                    </ajax:AutoCompleteExtender>

                    <script>
                        function usuarioSeleccionado(sender, e) {
                            var id = e.get_value();
                            document.getElementById('<%= hfUsuarioId.ClientID %>').value = id;
                        }
                    </script>
                </div>

                <div class="form-group">
                    <label class="form-label">Producto</label>
                    <asp:DropDownList 
    ID="ddlProducto" 
    runat="server" 
    CssClass="form-select"
    onchange="limpiarMensaje()">
</asp:DropDownList>
                </div>

                <div class="form-group">
                    <label class="form-label">Plazo</label>
                    <asp:DropDownList 
    ID="ddlPlazo" 
    runat="server" 
    CssClass="form-select"
    onchange="limpiarMensaje()">
</asp:DropDownList>
                </div>

                <div class="form-group">
                    <label class="form-label">Monto a invertir</label>
                   <asp:TextBox 
    ID="txtMonto" 
    runat="server" 
    CssClass="form-input"
    oninput="limpiarMensaje()">
</asp:TextBox>
                </div>

                <asp:Button ID="btnCalcular" runat="server"
                    Text="Calcular Cotización"
                    CssClass="btn btn-primary"
                    OnClick="btnCalcular_Click" />

                <asp:Button 
                    ID="btnVolver" 
                    runat="server" 
                    Text="Volver"
                    CssClass="btn btn-secondary"
                    OnClick="btnVolver_Click" />

            </div>
        </div>

    </div>

</div>

<asp:Label ID="lblNumero"   runat="server" Visible="false" />
<asp:Label ID="lblCliente"  runat="server" Visible="false" />
<asp:Label ID="lblTelefono" runat="server" Visible="false" />
<asp:Label ID="lblCorreo"   runat="server" Visible="false" />

</form>
    <script>
        function limpiarMensaje() {
            var lbl = document.getElementById('<%= lblMensaje.ClientID %>');
            if (lbl) {
                lbl.style.display = 'none';
            }
        }
    </script>
</body>
</html>
