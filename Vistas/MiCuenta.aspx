<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MiCuenta.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.MiCuenta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Mi Cuenta - SICAPF</title>
    <link href="../Estilos/MiCuenta.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
      <div class="mi-cuenta-wrapper">
    <div class="mi-cuenta-container">
        <div class="mi-cuenta-card">
            <div class="page-header">
                <asp:Button ID="btnAtras" runat="server"
                    Text="←"
                    CssClass="btn-back-icon"
                    OnClick="btnAtras_Click"
                    CausesValidation="false" />
            </div>

            <div class="mi-cuenta-header">
                <h2 class="mi-cuenta-title">Mi Cuenta</h2>
                <p class="mi-cuenta-subtitle">
                    Actualiza tu información personal
                </p>
            </div>

            <div class="form-group">
                <label class="form-label">Tipo de Identificación <span class="campo-requerido">*</span></label>
                <asp:DropDownList ID="ddlTipoIdentificacion" runat="server" 
                    CssClass="form-input">
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvTipoIdentificacion" runat="server"
                    ControlToValidate="ddlTipoIdentificacion"
                    InitialValue="0"
                    ErrorMessage="Debe seleccionar un tipo de identificación."
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="form-group">
                <label class="form-label">Identificación <span class="campo-requerido">*</span></label>
                <asp:TextBox ID="txtIdentificacion" runat="server"
                    CssClass="form-input"
                    MaxLength="30"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvIdentificacion" runat="server"
                    ControlToValidate="txtIdentificacion"
                    ErrorMessage="La identificación es requerida."
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
                <asp:RegularExpressionValidator ID="revIdentificacion" runat="server"
                    ControlToValidate="txtIdentificacion"
                    ErrorMessage="La identificación debe tener al menos 9 caracteres."
                    ValidationExpression="^.{9,}$"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="form-group">
                <label class="form-label">Nombre Completo <span class="campo-requerido">*</span></label>
                <asp:TextBox ID="txtNombre" runat="server"
                    CssClass="form-input"
                    MaxLength="150"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                    ControlToValidate="txtNombre"
                    ErrorMessage="El nombre completo es requerido."
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
                <asp:RegularExpressionValidator ID="revNombre" runat="server"
                    ControlToValidate="txtNombre"
                    ErrorMessage="El nombre debe tener al menos 3 caracteres."
                    ValidationExpression="^.{3,}$"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="form-group">
                <label class="form-label">Teléfono</label>
                <asp:TextBox ID="txtTelefono" runat="server"
                    CssClass="form-input"
                    MaxLength="20"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revTelefono" runat="server"
                    ControlToValidate="txtTelefono"
                    ErrorMessage="El teléfono debe tener al menos 8 dígitos."
                    ValidationExpression="^[\d\s\-]{8,}$"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="form-group">
                <label class="form-label">Correo <span class="campo-requerido">*</span></label>
                <asp:TextBox ID="txtCorreo" runat="server"
                    CssClass="form-input"
                    MaxLength="100"
                    TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCorreo" runat="server"
                    ControlToValidate="txtCorreo"
                    ErrorMessage="El correo es requerido."
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
                <asp:RegularExpressionValidator ID="revCorreo" runat="server"
                    ControlToValidate="txtCorreo"
                    ErrorMessage="El formato del correo es inválido."
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="mi-divider"></div>

            <asp:Button ID="btnMostrarCambio" runat="server"
                Text="Cambiar contraseña"
                CssClass="btn btn-secondary-outline"
                OnClick="btnMostrarCambio_Click"
                CausesValidation="false" />

            <asp:Panel ID="pnlCambioContrasena" runat="server"
                CssClass="panel-contrasena"
                Visible="false">

                <div class="form-group">
                    <label class="form-label">Contraseña actual <span class="campo-requerido">*</span></label>
                    <asp:TextBox ID="txtActual" runat="server"
                        TextMode="Password"
                        CssClass="form-input"
                        MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvActual" runat="server"
                        ControlToValidate="txtActual"
                        ErrorMessage="La contraseña actual es requerida."
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="GuardarDatos"
                        Enabled="false" />
                </div>

                <div class="form-group">
                    <label class="form-label">Nueva contraseña <span class="campo-requerido">*</span></label>
                    <asp:TextBox ID="txtNueva" runat="server"
                        TextMode="Password"
                        CssClass="form-input"
                        MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvNueva" runat="server"
                        ControlToValidate="txtNueva"
                        ErrorMessage="La nueva contraseña es requerida."
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="GuardarDatos"
                        Enabled="false" />
                    <asp:RegularExpressionValidator ID="revNueva" runat="server"
                        ControlToValidate="txtNueva"
                        ErrorMessage="La contraseña debe tener al menos 6 caracteres."
                        ValidationExpression="^.{6,}$"
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="GuardarDatos"
                        Enabled="false" />
                </div>

                <div class="form-group">
                    <label class="form-label">Confirmar nueva contraseña <span class="campo-requerido">*</span></label>
                    <asp:TextBox ID="txtConfirmarNueva" runat="server"
                        TextMode="Password"
                        CssClass="form-input"
                        MaxLength="50" />
                    <asp:CompareValidator ID="cvConfirmar" runat="server"
                        ControlToValidate="txtConfirmarNueva"
                        ControlToCompare="txtNueva"
                        ErrorMessage="Las contraseñas no coinciden."
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="GuardarDatos"
                        Enabled="false" />
                </div>

            </asp:Panel>

            <br />

            <asp:Button ID="btnGuardar" runat="server"
                Text="Guardar Cambios"
                CssClass="btn btn-guardar btn-block"
                OnClick="btnGuardar_Click"
                ValidationGroup="GuardarDatos" />

            <asp:Label ID="lblMensaje" runat="server"
                CssClass="mensaje"></asp:Label>

        </div>
    </div>
</div>
    </form>
</body>
</html>
