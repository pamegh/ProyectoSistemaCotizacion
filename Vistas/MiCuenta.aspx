<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MiCuenta.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.MiCuenta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../Estilos/MiCuenta.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
      <div class="mi-cuenta-wrapper">
    <div class="mi-cuenta-container">
        <div class="mi-cuenta-card">

            <div class="mi-cuenta-header">
                <h2 class="mi-cuenta-title">Mi Cuenta</h2>
                <p class="mi-cuenta-subtitle">
                    Actualiza tu información personal
                </p>
            </div>

            <div class="form-group">
                <label class="form-label">Identificación</label>
                <asp:TextBox ID="txtIdentificacion" runat="server"
                    CssClass="form-input"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Nombre Completo</label>
                <asp:TextBox ID="txtNombre" runat="server"
                    CssClass="form-input"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Teléfono</label>
                <asp:TextBox ID="txtTelefono" runat="server"
                    CssClass="form-input"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Correo</label>
                <asp:TextBox ID="txtCorreo" runat="server"
                    CssClass="form-input"></asp:TextBox>
            </div>

            <div class="mi-divider"></div>

            <asp:Button ID="btnMostrarCambio" runat="server"
                Text="Cambiar contraseña"
                CssClass="btn btn-secondary-outline"
                OnClick="btnMostrarCambio_Click" />

            <asp:Panel ID="pnlCambioContrasena" runat="server"
                CssClass="panel-contrasena"
                Visible="false">

                <div class="form-group">
                    <label class="form-label">Contraseña actual</label>
                    <asp:TextBox ID="txtActual" runat="server"
                        TextMode="Password"
                        CssClass="form-input" />
                </div>

                <div class="form-group">
                    <label class="form-label">Nueva contraseña</label>
                    <asp:TextBox ID="txtNueva" runat="server"
                        TextMode="Password"
                        CssClass="form-input" />
                </div>

            </asp:Panel>

            <br />

            <asp:Button ID="btnGuardar" runat="server"
                Text="Guardar Cambios"
                CssClass="btn btn-guardar btn-block"
                OnClick="btnGuardar_Click" />

            <asp:Label ID="lblMensaje" runat="server"
                CssClass="mensaje"></asp:Label>

        </div>
    </div>
</div>
    </form>
</body>
</html>
