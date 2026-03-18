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

    <!-- IZQUIERDA (RESULTADOS) -->
    <div class="col-resultados">

        <!-- Resumen -->
        <div class="card">
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

        <!-- Detalle mensual -->
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
                        <asp:BoundField DataField="InteresBruto" HeaderText="Interés Bruto"  DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Impuesto"     HeaderText="Impuesto"        DataFormatString="{0:C}" />
                        <asp:BoundField DataField="InteresNeto"  HeaderText="Interés Neto"    DataFormatString="{0:C}" />
                    </Columns>
                </asp:GridView>

            </div>
        </div>

    </div>

    <!-- DERECHA (FORMULARIO) -->
    <div class="col-formulario">

        <div class="card">
            <div class="card-header card-header-primary">
                Generar Cotización
            </div>
            <div class="card-body">

                <!-- MENSAJE -->
                <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="mensaje mensaje-error"></asp:Label>

                <!-- Buscar usuario -->
                <div class="form-group">
                    <label class="form-label">Buscar usuario</label>

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

                <!-- Producto -->
                <div class="form-group">
                    <label class="form-label">Producto</label>
                    <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>

                <!-- Plazo -->
                <div class="form-group">
                    <label class="form-label">Plazo</label>
                    <asp:DropDownList ID="ddlPlazo" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>

                <!-- Monto -->
                <div class="form-group">
                    <label class="form-label">Monto a invertir</label>
                    <asp:TextBox ID="txtMonto" runat="server" CssClass="form-input"></asp:TextBox>
                </div>

                <!-- Botón calcular -->
                <asp:Button ID="btnCalcular" runat="server"
                    Text="Calcular Cotización"
                    CssClass="btn btn-primary"
                    OnClick="btnCalcular_Click" />

                <!-- Resultado -->
                <asp:Panel ID="pnlResultado" runat="server" CssClass="panel-resultado">
                    <asp:Label ID="lblTasa"         runat="server"></asp:Label><br />
                    <asp:Label ID="lblInteresBruto" runat="server"></asp:Label><br />
                    <asp:Label ID="lblImpuesto"     runat="server"></asp:Label><br />
                    <asp:Label ID="lblInteresNeto"  runat="server"></asp:Label>
                </asp:Panel>

                <!-- Guardar -->
                <asp:Button 
                    ID="btnGuardar" 
                    runat="server" 
                    Text="Guardar Cotización"
                    CssClass="btn btn-primary"
                    OnClick="btnGuardarCotizacion_Click" />

                <!-- Volver -->
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

<!-- Labels ocultos (NO se tocan) -->
<asp:Label ID="lblNumero"   runat="server" Visible="false" />
<asp:Label ID="lblCliente"  runat="server" Visible="false" />
<asp:Label ID="lblTelefono" runat="server" Visible="false" />
<asp:Label ID="lblCorreo"   runat="server" Visible="false" />

</form>
</body>
</html>
