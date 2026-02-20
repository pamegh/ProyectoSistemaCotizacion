<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DashboardUsuario.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.DashboardUsuario" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Panel Cliente - APF</title>
    <link href="../Estilos/DashboardAdmin.css" rel="stylesheet" />
</head>
<body>
<form id="form1" runat="server">
<div class="page-wrapper">

    <header class="header">
        <div class="header-container">
            <div class="logo-admin">
                <img src="../Recursos/logoWeb.png" 
                     alt="SICAPF Logo" 
                     class="logo-img-admin" />
            </div>

            <div class="user-info">
    <asp:Label ID="lblUsuario" runat="server" CssClass="user-name"></asp:Label>

    <asp:Button ID="btnSalir" 
        runat="server" 
        Text="Cerrar Sesión" 
        CssClass="btn-logout"
        OnClick="btnSalir_Click" />
</div>
        </div>
    </header>

    <div class="layout">

        <aside class="sidebar">
            <ul class="menu">
                <li>
                    <a href="RealizarCotizacion.aspx">
                        Realizar Cotización
                    </a>
                </li>

                <li>
                    <a href="HistorialCotizaciones.aspx">
                        Historial de Mis Cotizaciones
                    </a>
                </li>

                <li>
                    <a href="MiCuenta.aspx">
                        Mi Cuenta
                    </a>
                </li>
            </ul>
        </aside>

        <main class="content">

            <h1 class="dashboard-title">
                Bienvenido al Panel de Cliente
            </h1>

            <div class="cards-grid">

                <div class="card">
                    <h2>Realizar Nueva Cotización</h2>
                    <p class="card-number">APF</p>
                </div>

                <div class="card">
                    <h2>Consultar Historial</h2>
                    <p class="card-number">Mis Cotizaciones</p>
                </div>

                <div class="card">
                    <h2>Administrar Perfil</h2>
                    <p class="card-number">Mi Cuenta</p>
                </div>

            </div>

        </main>

    </div>

</div>
</form>
</body>
</html>