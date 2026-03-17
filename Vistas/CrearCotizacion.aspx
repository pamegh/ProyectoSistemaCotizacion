<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CrearCotizacion.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.CrearCotizacion" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Crear Cotización</title>

    <!-- Bootstrap igual que la otra pantalla -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

</head>

<body>
<form id="form2" runat="server">

<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

<div class="container-fluid mt-4">
<div class="row">

    <!-- IZQUIERDA (RESULTADOS) -->
    <div class="col-md-8">

        <!-- Resumen -->
        <div class="card mb-3">
            <div class="card-header bg-primary text-white">
                Detalle Cotización
            </div>

            <div class="card-body">

                <asp:GridView 
                    ID="gvResumenCotizacion" 
                    runat="server"
                    AutoGenerateColumns="false"
                    ShowHeader="false"
                    CssClass="table table-bordered text-center">

                    <Columns>
                        <asp:BoundField DataField="Campo" />
                        <asp:BoundField DataField="Valor" />
                    </Columns>

                </asp:GridView>

            </div>
        </div>

        <!-- Detalle mensual -->
        <div class="card">
            <div class="card-header bg-dark text-white">
                Detalle Mensual
            </div>

            <div class="card-body">

                <asp:GridView 
                    ID="gvDetalleCotizacion" 
                    runat="server" 
                    AutoGenerateColumns="false" 
                    CssClass="table table-bordered table-striped text-center">

                    <Columns>
                        <asp:BoundField DataField="Mes" HeaderText="Mes" />
                        <asp:BoundField DataField="InteresBruto" HeaderText="Interés Bruto" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Impuesto" HeaderText="Impuesto" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="InteresNeto" HeaderText="Interés Neto" DataFormatString="{0:C}" />
                    </Columns>

                </asp:GridView>

            </div>
        </div>

    </div>

    <!-- DERECHA (FORMULARIO) -->
    <div class="col-md-4">

        <div class="card">

            <div class="card-header bg-primary text-white">
                Generar Cotización
            </div>

            <div class="card-body">

                <!-- MENSAJE -->
                <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="fw-bold text-danger"></asp:Label>

                <!-- Buscar usuario -->
                <div class="mb-3">
                    <label>Buscar usuario</label>

                    <asp:TextBox 
                        ID="txtBuscarUsuario" 
                        runat="server" 
                        CssClass="form-control">
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
                <div class="mb-3">
                    <label>Producto</label>
                    <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>

                <!-- Plazo -->
                <div class="mb-3">
                    <label>Plazo</label>
                    <asp:DropDownList ID="ddlPlazo" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>

                <!-- Monto -->
                <div class="mb-3">
                    <label>Monto a invertir</label>
                    <asp:TextBox ID="txtMonto" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <!-- Botón calcular -->
                <div class="d-grid mb-2">
                    <asp:Button ID="btnCalcular" runat="server"
                        Text="Calcular Cotización"
                        CssClass="btn btn-primary"
                        OnClick="btnCalcular_Click" />
                </div>

                <!-- Resultado -->
                <asp:Panel ID="pnlResultado" runat="server" CssClass="mt-3">

                    

                    <asp:Label ID="lblTasa" runat="server"></asp:Label><br />
                    <asp:Label ID="lblInteresBruto" runat="server"></asp:Label><br />
                    <asp:Label ID="lblImpuesto" runat="server"></asp:Label><br />
                    <asp:Label ID="lblInteresNeto" runat="server"></asp:Label>

                </asp:Panel>

                <!-- Guardar -->
                <div class="d-grid mt-3">
                    <asp:Button 
                        ID="btnGuardar" 
                        runat="server" 
                        Text="Guardar Cotización"
                        CssClass="btn btn-success"
                        OnClick="btnGuardarCotizacion_Click" />
                </div>

            </div>
        </div>

    </div>

</div>
</div>

<!-- Labels ocultos (NO se tocan) -->
<asp:Label ID="lblNumero" runat="server" Visible="false" />
<asp:Label ID="lblCliente" runat="server" Visible="false" />
<asp:Label ID="lblTelefono" runat="server" Visible="false" />
<asp:Label ID="lblCorreo" runat="server" Visible="false" />

</form>
</body>
</html>