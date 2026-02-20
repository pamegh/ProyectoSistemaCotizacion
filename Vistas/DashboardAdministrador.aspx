<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DashboardAdministrador.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.DashboardAdministrador" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Panel Administrativo - APF</title>
    <link href="../Estilos/DashboardAdmin.css" rel="stylesheet" />
</head>
<body>
<form id="form1" runat="server">
    <div class="page-wrapper">
    <header class="header">
        <div class="header-container">
           <div class="logo-admin">
    <img src="../Recursos/logoWeb.png" alt="SICAPF Logo" class="logo-img-admin" />
</div>
            <div class="user-info">
                <asp:Label ID="lblUsuario" runat="server"></asp:Label>
                <asp:Button ID="btnSalir" runat="server" Text="Cerrar Sesión" CssClass="btn-logout" OnClick="btnSalir_Click" />
            </div>
        </div>
    </header>

    <div class="layout">

        <aside class="sidebar">
            <ul class="menu">
                <li><a href="#">Realizar Cotización</a></li>
                <li><a href="#">Gestión de Clientes</a></li>
                <li><a href="#">Historial Mis Cotizaciones</a></li>
                <li><a href="ConfiguracionProductos.aspx">Configuraciones de Productos</a></li>
                <li><a href="#">Administración de Usuarios</a></li>
                <li><a href="MiCuenta.aspx">Mi Cuenta</a></li>
                <li><a href="#">Reportes del Sistema</a></li>
            </ul>
        </aside>

        <main class="content">

            <h1 class="dashboard-title">Panel de Control</h1>

            <div class="cards-grid">

                <div class="card">
                    <h2>Total Usuarios</h2>
                    <p class="card-number">-</p>
                </div>

                <div class="card">
                    <h2>Cotizaciones Activas</h2>
                    <p class="card-number">-</p>
                </div>

                <div class="card">
                    <h2>Reportes Generados</h2>
                    <p class="card-number">-</p>
                </div>

                <div class="card">
                    <h2>Productos Disponibles</h2>
                    <p class="card-number">-</p>
                </div>

            </div>

        </main>

    </div>
        </div>
</form>
</body>
</html>