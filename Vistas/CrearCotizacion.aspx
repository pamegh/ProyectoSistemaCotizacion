
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CrearCotizacion.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.CrearCotizacion" %>
<!-- AutoCompleteExtender: AjaxControlToolkit -->
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Crear Cotización</title>
    <link href="../Estilos/DashboardAdmin.css" rel="stylesheet" />
    <link runat="server" href="~/Estilos/DashboardAdmin.css" rel="stylesheet" />
    <style type="text/css">
        .form-input {}
    </style>
</head>

<body>
<form id="form2" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

<div class="page-wrapper">

    <!-- HEADER -->
    <header class="header">
        <div class="header-container">

            <div class="logo-admin">
                <img src="../Recursos/logoWeb.png" class="logo-img-admin"/>
            </div>

            <div class="user-info">
                <asp:Label ID="lblUsuario" runat="server"></asp:Label>
                <asp:Button ID="btnSalir" runat="server" Text="Cerrar Sesión" CssClass="btn-logout" OnClick="btnSalir_Click"/>
            </div>

        </div>
    </header>

    <!-- LAYOUT -->
    <div class="layout">

        <!-- SIDEBAR -->
        <aside class="sidebar">
            <ul class="menu">
                <li><a href="DashboardAdministrador.aspx">Inicio</a></li>
                <li><a href="CrearCotizacion.aspx">Realizar Cotización</a></li>
                <li><a href="#">Historial</a></li>
                <li><a href="#">Reportes</a></li>
            </ul>
        </aside>

        <!-- CONTENIDO -->
        <main class="content">

            <h1 class="dashboard-title">Generar Cotización</h1>


            <!-- Tarjeta -->

        
            <div class="card" style="max-width:600px;">


                <!-- Mensaje -->
                <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="mensaje mensaje mensaje-error"></asp:Label>
        
                <!-- Buscar usuario -->

                                    <div class="form-group">

                        <label>Buscar usuario</label>

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
                    <label>Producto</label>
                    <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-input" Height="16px" Width="91px"></asp:DropDownList>
                </div>

                <!-- Plazo -->
                <div class="form-group">
                    <label>Plazo</label>
                    <asp:DropDownList ID="ddlPlazo" runat="server" CssClass="form-input" Height="18px" Width="111px"></asp:DropDownList>
                </div>

                <!-- Monto -->
                <div class="form-group">
                    <label>Monto a invertir</label>
                    <asp:TextBox ID="txtMonto" runat="server" CssClass="form-input" Width="138px"></asp:TextBox>
                </div>

                <!-- Botón -->
                <asp:Button ID="btnCalcular" runat="server"
                    Text="Calcular Cotización"
                    CssClass="btn btn-primary"
                    OnClick="btnCalcular_Click" />

            </div>

        <!--BOTONES INVISIBLES, usados para almacenar información del usuario -->
            <asp:Label ID="lblNumero" runat="server" Visible="false" />
            <asp:Label ID="lblCliente" runat="server" Visible="false" />
                <asp:Label ID="lblTelefono" runat="server" Visible="false" />
                <asp:Label ID="lblCorreo" runat="server" Visible="false" />
        <!-- Estructura de crear cotización GRIDVIEW-->

                           <h3>Detalle Cotización</h3>

                <asp:GridView 
                    ID="gvResumenCotizacion" 
                    runat="server"
                    AutoGenerateColumns="false"
                    ShowHeader="false"
                    CssClass="tabla-cotizacion">

                    <Columns>
                        <asp:BoundField DataField="Campo" />
                        <asp:BoundField DataField="Valor" />
                    </Columns>

                </asp:GridView>

        <!-- Detalle Mensual Cotización -->
        <h3>Detalle Mensual Cotización</h3>
           

        <asp:GridView ID="gvDetalleCotizacion" runat="server" AutoGenerateColumns="false" CssClass="tabla-cotizacion">

    <Columns>

        <asp:BoundField DataField="Mes" HeaderText="Mes" />

        <asp:BoundField DataField="InteresBruto" HeaderText="Interés Bruto" DataFormatString="{0:C}" />

        <asp:BoundField DataField="Impuesto" HeaderText="Impuesto" DataFormatString="{0:C}" />

        <asp:BoundField DataField="InteresNeto" HeaderText="Interés Neto" DataFormatString="{0:C}" />

    </Columns>

</asp:GridView>

                           

            <!-- RESULTADO -->
            <asp:Panel ID="pnlResultado" runat="server" Visible="true" CssClass="card" style="margin-top:20px;">

                <h2>Resultado</h2>

                <asp:Label ID="lblTasa" runat="server"></asp:Label><br />
                <asp:Label ID="lblInteresBruto" runat="server"></asp:Label><br />
                <asp:Label ID="lblImpuesto" runat="server"></asp:Label><br />
                <asp:Label ID="lblInteresNeto" runat="server"></asp:Label>

            </asp:Panel>

                <asp:Button 
                    ID="btnGuardar" 
                    runat="server" 
                    Text="Guardar Cotización"
                    CssClass="btn btn-success"
                    OnClick="btnGuardarCotizacion_Click" />

        </main>

    </div>

</div>

</form>
</body>
</html>
