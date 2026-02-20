<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.Registro" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Registro de Usuario - APF Cotizaciones</title>
    <link href="../Estilos/RegistroStyle.css" rel="stylesheet" />
</head>
<body>

<form id="form1" runat="server">

    <header class="header">
        <div class="header-container">
            <div class="logo">
                APF Cotizaciones
            </div>
            <nav class="nav">
                <a href="<%= ResolveUrl("~/Vistas/DashboardPrincipal.aspx") %>">Inicio</a>
                <a href="<%= ResolveUrl("~/Vistas/Login.aspx") %>">Iniciar Sesión</a>
            </nav>
        </div>
    </header>

    <div class="main-container">

        <div class="card">

            <h1 class="title">Registro de Usuario</h1>
            <p class="subtitle">Complete la información para crear un nuevo usuario</p>

            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje" Visible="false"></asp:Label>

            <div class="form-grid">

                <div class="form-group">
    <label>Tipo Identificación</label>
    <asp:DropDownList 
        ID="ddlTipoIdentificacion" 
        runat="server" 
        CssClass="input">
    </asp:DropDownList>
</div>


                <div class="form-group">
                    <label>Número de Identificación</label>
                    <asp:TextBox ID="txtIdentificacion" runat="server" CssClass="input" />
                </div>

                <div class="form-group">
                    <label>Nombre Completo</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="input" />
                </div>

                <div class="form-group">
                    <label>Teléfono</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="input" />
                </div>

                <div class="form-group">
                    <label>Correo</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="input" TextMode="Email" />
                </div>

                <div class="form-group">
                    <label>Contraseña</label>
                    <asp:TextBox ID="txtContrasena" runat="server" CssClass="input" TextMode="Password" />
                </div>

            </div>

            <div class="actions">
                <asp:Button ID="btnGuardar" 
                    runat="server"
                    Text="Guardar Usuario"
                    CssClass="btn-primary"
                    OnClick="btnGuardar_Click" />
            </div>

        </div>

    </div>

</form>
</body>
</html>