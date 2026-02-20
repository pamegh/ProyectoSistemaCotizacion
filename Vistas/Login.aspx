<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SistemaCotizacionAPF.Vistas.Login" UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Iniciar Sesión - APF Cotizaciones</title>
     <link href='../Estilos/LoginStyle.css' rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="header">
            <div class="container">
                <div class="header-content">
                    <div class="logo">
                        <svg class="logo-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M3 9L12 2L21 9V20C21 20.5304 20.7893 21.0391 20.4142 21.4142C20.0391 21.7893 19.5304 22 19 22H5C4.46957 22 3.96086 21.7893 3.58579 21.4142C3.21071 21.0391 3 20.5304 3 20V9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            <path d="M9 22V12H15V22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                        <a href="DashboardPrincipal.aspx" class="logo-text">APF Cotizaciones</a>
                    </div>
                    <nav class="nav">
                        <a href="DashboardPrincipal.aspx" class="nav-link">
                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M3 9L12 2L21 9V20C21 20.5304 20.7893 21.0391 20.4142 21.4142C20.0391 21.7893 19.5304 22 19 22H5C4.46957 22 3.96086 21.7893 3.58579 21.4142C3.21071 21.0391 3 20.5304 3 20V9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M9 22V12H15V22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            Inicio
                        </a>
                        <a href="Registro.aspx" class="nav-link">
                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M16 21V19C16 17.9391 15.5786 16.9217 14.8284 16.1716C14.0783 15.4214 13.0609 15 12 15H5C3.93913 15 2.92172 15.4214 2.17157 16.1716C1.42143 16.9217 1 17.9391 1 19V21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M8.5 11C10.7091 11 12.5 9.20914 12.5 7C12.5 4.79086 10.7091 3 8.5 3C6.29086 3 4.5 4.79086 4.5 7C4.5 9.20914 6.29086 11 8.5 11Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M20 8V14M23 11H17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            Registrarse
                        </a>
                    </nav>
                </div>
            </div>
        </header>

        <!-- Login Container -->
        <div class="login-wrapper">
            <div class="login-container">
                <div class="login-card">
                    <!-- Icono de usuario -->
                    <div class="login-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M15 3H19C19.5304 3 20.0391 3.21071 20.4142 3.58579C20.7893 3.96086 21 4.46957 21 5V19C21 19.5304 20.7893 20.0391 20.4142 20.4142C20.0391 20.7893 19.5304 21 19 21H15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            <path d="M10 17L15 12L10 7M15 12H3" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>

                    <h1 class="login-title">Iniciar Sesión</h1>
                    <p class="login-subtitle">Ingresa tus credenciales para acceder al sistema</p>

                    <!-- Mensaje de error/éxito -->
                    <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje" Visible="false"></asp:Label>

                    <!-- Campo de Usuario -->
                    <div class="form-group">
                        <label for="txtUsuario" class="form-label">
                            <svg class="label-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M20 21V19C20 17.9391 19.5786 16.9217 18.8284 16.1716C18.0783 15.4214 17.0609 15 16 15H8C6.93913 15 5.92172 15.4214 5.17157 16.1716C4.42143 16.9217 4 17.9391 4 19V21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                <circle cx="12" cy="7" r="4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            Usuario
                        </label>
                        <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-input" placeholder="Ingrese su usuario" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvUsuario" runat="server" 
                            ControlToValidate="txtUsuario" 
                            ErrorMessage="El usuario es requerido" 
                            CssClass="validation-error"
                            Display="Dynamic">
                        </asp:RequiredFieldValidator>
                    </div>

                    <!-- Campo de Contraseña -->
                    <div class="form-group">
                        <label for="txtContrasena" class="form-label">
                            <svg class="label-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M7 11V7C7 5.67392 7.52678 4.40215 8.46447 3.46447C9.40215 2.52678 10.6739 2 12 2C13.3261 2 14.5979 2.52678 15.5355 3.46447C16.4732 4.40215 17 5.67392 17 7V11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            Contraseña
                        </label>
                        <asp:TextBox ID="txtContrasena" runat="server" TextMode="Password" CssClass="form-input" placeholder="Ingrese su contraseña" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvContrasena" runat="server" 
                            ControlToValidate="txtContrasena" 
                            ErrorMessage="La contraseña es requerida" 
                            CssClass="validation-error"
                            Display="Dynamic">
                        </asp:RequiredFieldValidator>
                    </div>

                    <!-- Recordar sesión -->
                    <div class="form-group-checkbox">
                        <asp:CheckBox ID="chkRecordar" runat="server" CssClass="form-checkbox" />
                        <label for="chkRecordar" class="checkbox-label">Recordar mi sesión</label>
                    </div>

                    <!-- Botón de login -->
                    <asp:Button ID="btnIniciarSesion" runat="server" Text="Iniciar Sesión" CssClass="btn btn-primary btn-block" OnClick="btnIniciarSesion_Click" />

                   <asp:HyperLink 
    ID="hlRegistro" 
    runat="server" 
    NavigateUrl="~/Vistas/Registro.aspx"
    CssClass="footer-link">
    Regístrate aquí
</asp:HyperLink>


                    <!-- Usuarios de prueba -->
                    <div class="test-users">
                        <p class="test-title">👤 Usuarios de prueba:</p>
                        <div class="test-user-grid">
                            <div class="test-user-item">
                                <strong>Admin:</strong> admin@sistema.com / Admin123!
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
