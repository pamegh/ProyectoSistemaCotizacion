
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CrearCotizacion.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.CrearCotizacion" %>

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

        <!-- CONTENIDO 
        <main class="content">

            <h1 class="dashboard-title">Generar Cotización</h1>

            <!-- Tarjeta -->
            <div class="card" style="max-width:600px;">


                <!-- Mensaje -->
                <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="mensaje mensaje mensaje-error"></asp:Label>

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
        

         <!-- Estructura de crear cotización -->

        <div class="card cotizacion-panel">

    <table class="tabla-cotizacion-resumen">

        <tr>
            <td class="titulo">Número de cotización</td>
            <td><asp:Label ID="lblNumero" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Cliente</td>
            <td><asp:Label ID="lblCliente" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Teléfono</td>
            <td><asp:Label ID="lblTelefono" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Correo</td>
            <td><asp:Label ID="lblCorreo" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Producto</td>
            <td><asp:Label ID="lblProducto" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Monto</td>
            <td><asp:Label ID="lblMonto" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Plazo</td>
            <td><asp:Label ID="lblPlazo" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Tasa</td>
            <td><asp:Label ID="Label1" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Impuesto</td>
            <td><asp:Label ID="lblImpuestoPorc" runat="server" /></td>
        </tr>

    </table>

    <hr />

    <table class="tabla-cotizacion-resumen totales">

        <tr>
            <td class="titulo">Monto Total Interés Bruto</td>
            <td><asp:Label ID="Label2" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Monto Total Impuesto</td>
            <td><asp:Label ID="lblImpuestoTotal" runat="server" /></td>
        </tr>

        <tr>
            <td class="titulo">Monto Total Neto</td>
            <td><asp:Label ID="lblNetoTotal" runat="server" /></td>
        </tr>

    </table>

</div>

        <!-- Botom -->


            <!-- RESULTADO -->
            <asp:Panel ID="pnlResultado" runat="server" Visible="false" CssClass="card" style="margin-top:20px;">

                <h2>Resultado</h2>

                <asp:Label ID="lblTasa" runat="server"></asp:Label><br />
                <asp:Label ID="lblInteresBruto" runat="server"></asp:Label><br />
                <asp:Label ID="lblImpuesto" runat="server"></asp:Label><br />
                <asp:Label ID="lblInteresNeto" runat="server"></asp:Label>

            </asp:Panel>

        </main>

    </div>

</div>

</form>
</body>
</html>
