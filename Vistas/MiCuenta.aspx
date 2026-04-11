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
                    Text="←" CssClass="btn-back-icon"
                    OnClick="btnAtras_Click" CausesValidation="false" />
            </div>

            <div class="mi-cuenta-header">
                <h2 class="mi-cuenta-title">Mi Cuenta</h2>
                <p class="mi-cuenta-subtitle">Actualiza tu información personal</p>
            </div>

            <div class="form-group">
                <label class="form-label">Tipo de Identificación <span class="campo-requerido">*</span></label>
                <asp:DropDownList ID="ddlTipoIdentificacion" runat="server"
                    CssClass="form-input"
                    onchange="actualizarPlaceholderIdentificacion(this)">
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvTipoIdentificacion" runat="server"
                    ControlToValidate="ddlTipoIdentificacion"
                    InitialValue="0"
                    ErrorMessage="Debe seleccionar un tipo de identificación."
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="form-group">
                <label class="form-label">
                    Identificación <span class="campo-requerido">*</span>
                    <small id="lblHintIdentificacion" style="font-weight:normal; color:#888; font-size:0.85rem;"></small>
                </label>
                <asp:TextBox ID="txtIdentificacion" runat="server"
                    CssClass="form-input"
                    MaxLength="20"
                    onkeypress="return filtrarTeclaId(event)"
                    oninput="validarIdEnVivo(this)">
                </asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvIdentificacion" runat="server"
                    ControlToValidate="txtIdentificacion"
                    ErrorMessage="La identificación es requerida."
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
                <asp:RegularExpressionValidator ID="revIdentificacion" runat="server"
                    ControlToValidate="txtIdentificacion"
                    ErrorMessage="Formato inválido. Revise el tipo de identificación seleccionado."
                    ValidationExpression=".*"
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" Enabled="false" />
                <span id="spanErrId" style="color:red; font-size:0.85em; display:none;"></span>
            </div>

            <div class="form-group">
                <label class="form-label">Nombre Completo <span class="campo-requerido">*</span></label>
                <asp:TextBox ID="txtNombre" runat="server"
                    CssClass="form-input" MaxLength="150"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                    ControlToValidate="txtNombre"
                    ErrorMessage="El nombre completo es requerido."
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
                <asp:RegularExpressionValidator ID="revNombre" runat="server"
                    ControlToValidate="txtNombre"
                    ErrorMessage="El nombre debe tener al menos 3 letras y solo puede contener letras y espacios."
                    ValidationExpression="^[A-Za-záéíóúÁÉÍÓÚüÜñÑ\s]{3,}$"
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="form-group">
                <label class="form-label">
                    Teléfono <span class="campo-requerido">*</span>
                    <small style="font-weight:normal; color:#888; font-size:0.85rem;">(8 dígitos, número costarricense)</small>
                </label>
                <asp:TextBox ID="txtTelefono" runat="server"
                    CssClass="form-input" MaxLength="8"
                    placeholder="Ej: 88887777"
                    onkeypress="return soloNumero(event)">
                </asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvTelefono" runat="server"
                    ControlToValidate="txtTelefono"
                    ErrorMessage="El teléfono es requerido."
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
                <asp:RegularExpressionValidator ID="revTelefono" runat="server"
                    ControlToValidate="txtTelefono"
                    ErrorMessage="Debe ser un teléfono costarricense válido (8 dígitos, inicia con 2, 4, 6, 7 u 8)."
                    ValidationExpression="^[24678]\d{7}$"
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="form-group">
                <label class="form-label">Correo <span class="campo-requerido">*</span></label>
                <asp:TextBox ID="txtCorreo" runat="server"
                    CssClass="form-input" MaxLength="100" TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCorreo" runat="server"
                    ControlToValidate="txtCorreo"
                    ErrorMessage="El correo es requerido."
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
                <asp:RegularExpressionValidator ID="revCorreo" runat="server"
                    ControlToValidate="txtCorreo"
                    ErrorMessage="El formato del correo es inválido."
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    CssClass="text-danger" Display="Dynamic"
                    ValidationGroup="GuardarDatos" />
            </div>

            <div class="mi-divider"></div>

            <asp:Button ID="btnMostrarCambio" runat="server"
                Text="Cambiar contraseña"
                CssClass="btn btn-secondary-outline"
                OnClick="btnMostrarCambio_Click"
                CausesValidation="false" />

            <asp:Panel ID="pnlCambioContrasena" runat="server"
                CssClass="panel-contrasena" Visible="false">

                <div class="form-group">
                    <label class="form-label">Contraseña actual <span class="campo-requerido">*</span></label>
                    <asp:TextBox ID="txtActual" runat="server"
                        TextMode="Password" CssClass="form-input" MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvActual" runat="server"
                        ControlToValidate="txtActual"
                        ErrorMessage="La contraseña actual es requerida."
                        CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="GuardarDatos" Enabled="false" />
                </div>

                <div class="form-group">
                    <label class="form-label">Nueva contraseña <span class="campo-requerido">*</span></label>
                    <asp:TextBox ID="txtNueva" runat="server"
                        TextMode="Password" CssClass="form-input" MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvNueva" runat="server"
                        ControlToValidate="txtNueva"
                        ErrorMessage="La nueva contraseña es requerida."
                        CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="GuardarDatos" Enabled="false" />
                    <asp:RegularExpressionValidator ID="revNueva" runat="server"
                        ControlToValidate="txtNueva"
                        ErrorMessage="La contraseña debe tener al menos 6 caracteres."
                        ValidationExpression="^.{6,}$"
                        CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="GuardarDatos" Enabled="false" />
                </div>

                <div class="form-group">
                    <label class="form-label">Confirmar nueva contraseña <span class="campo-requerido">*</span></label>
                    <asp:TextBox ID="txtConfirmarNueva" runat="server"
                        TextMode="Password" CssClass="form-input" MaxLength="50" />
                    <asp:CompareValidator ID="cvConfirmar" runat="server"
                        ControlToValidate="txtConfirmarNueva"
                        ControlToCompare="txtNueva"
                        ErrorMessage="Las contraseñas no coinciden."
                        CssClass="text-danger" Display="Dynamic"
                        ValidationGroup="GuardarDatos" Enabled="false" />
                </div>

            </asp:Panel>

            <br />

            <asp:Button ID="btnGuardar" runat="server"
                Text="Guardar Cambios"
                CssClass="btn btn-guardar btn-block"
                OnClick="btnGuardar_Click"
                ValidationGroup="GuardarDatos" />

            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje"></asp:Label>

        </div>
    </div>
  </div>
</form>

<script type="text/javascript">


    var configTipos = <%= TiposIdentificacionJson %>;

    function actualizarPlaceholderIdentificacion(ddl) {
        var val = ddl.value;
        var txtId = document.getElementById('<%= txtIdentificacion.ClientID %>');
        var hint = document.getElementById('lblHintIdentificacion');
        var errId = document.getElementById('spanErrId');

        if (!txtId) return;

        txtId.value = '';
        if (errId) { errId.style.display = 'none'; errId.textContent = ''; }

        var cfg = configTipos[val];
        if (cfg) {
            txtId.placeholder = cfg.placeholder;
            txtId.maxLength = cfg.maxLength;
            if (hint) hint.innerText = '— ' + cfg.hint;
        } else {
            txtId.placeholder = '';
            txtId.maxLength = 20;
            if (hint) hint.innerText = '';
        }

        txtId.focus();
    }

    function filtrarTeclaId(e) {
        var ddl = document.getElementById('<%= ddlTipoIdentificacion.ClientID %>');
        if (!ddl) return true;

        var cfg = configTipos[ddl.value];
        if (!cfg) return true;

        var charCode = (typeof e.which === 'undefined') ? e.keyCode : e.which;
        if (charCode < 32) return true;

        if (cfg.soloNumerico) {
            return charCode >= 48 && charCode <= 57;
        }

        // Alfanumerico (Pasaporte) - permitir letras y números
        var char = String.fromCharCode(charCode);
        return /^[A-Z0-9]$/i.test(char);
    }

    function soloNumero(e) {
        var charCode = (typeof e.which === 'undefined') ? e.keyCode : e.which;
        if (charCode < 32) return true;
        return charCode >= 48 && charCode <= 57;
    }

    function validarIdEnVivo(txt) {
        var ddl   = document.getElementById('<%= ddlTipoIdentificacion.ClientID %>');
        var errId = document.getElementById('spanErrId');
        if (!ddl || !errId) return;

        var cfg = configTipos[ddl.value];
        if (!cfg) { errId.style.display = 'none'; return; }

        // Convertir a mayúsculas automáticamente para pasaporte (tipo alfanumérico)
        if (!cfg.soloNumerico && txt.value) {
            txt.value = txt.value.toUpperCase();
        }

        var val = txt.value.trim();

        // Validar longitud minima solo cuando el campo ya tiene caracteres suficientes
        // para no molestar mientras se escribe
        if (val.length > 0 && val.length < cfg.longitudMin) {
            errId.textContent   = 'Mínimo ' + cfg.longitudMin + ' caracteres';
            errId.style.display = 'inline';
            return;
        }

        // Validar patron cuando longitud es correcta
        if (val.length >= cfg.longitudMin && cfg.patronRegex) {
            var re = new RegExp(cfg.patronRegex);
            if (!re.test(val)) {
                errId.textContent   = cfg.soloNumerico
                    ? 'Solo se permiten números'
                    : 'Formato no válido';
                errId.style.display = 'inline';
                return;
            }
        }

        // Todo ok
        errId.style.display = 'none';
        errId.textContent   = '';
    }

    // ── Al cargar: restaurar placeholder/hint sin borrar el valor existente ───
    window.addEventListener('load', function () {
        var ddl   = document.getElementById('<%= ddlTipoIdentificacion.ClientID %>');
        var txtId = document.getElementById('<%= txtIdentificacion.ClientID %>');
        var hint = document.getElementById('lblHintIdentificacion');

        if (!ddl || !txtId) return;

        var cfg = configTipos[ddl.value];
        if (cfg) {
            txtId.placeholder = cfg.placeholder;
            txtId.maxLength = cfg.maxLength;
            if (hint) hint.innerText = '— ' + cfg.hint;
            // Validar el valor existente si lo hay
            if (txtId.value !== '') validarIdEnVivo(txtId);
        }
    });

</script>

</body>
</html>
