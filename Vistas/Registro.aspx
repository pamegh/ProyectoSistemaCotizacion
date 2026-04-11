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
            <div class="logo">APF Cotizaciones</div>
            <nav class="nav">
                <a href="<%= ResolveUrl("~/Vistas/DashboardPrincipal.aspx") %>">Inicio</a>
                <a href="<%= ResolveUrl("~/Vistas/Login.aspx") %>">Iniciar Sesión</a>
            </nav>
        </div>
    </header>

    <div class="main-container">
        <div class="card">

            <asp:Label ID="lblTitulo"    runat="server" CssClass="title"    Text="Registro de Usuario"></asp:Label>
            <br />
            <asp:Label ID="lblSubtitulo" runat="server" CssClass="subtitle" Text="Complete la información para crear un nuevo usuario"></asp:Label>
            <asp:Label ID="lblMensaje"   runat="server" CssClass="mensaje"  Visible="false"></asp:Label>

            <div class="form-grid">

                <%-- Tipo de Identificación --%>
                <div class="form-group">
                    <label>Tipo Identificación <span style="color:red">*</span></label>
                    <asp:DropDownList ID="ddlTipoIdentificacion" runat="server"
                        CssClass="input"
                        onchange="actualizarPlaceholderIdentificacion(this)">
                    </asp:DropDownList>
                </div>

                <%-- Número de Identificación --%>
                <div class="form-group">
                    <label>
                        Número de Identificación <span style="color:red">*</span>
                        <small id="lblHintIdentificacion" style="font-weight:normal; color:#888; font-size:0.82em;"></small>
                    </label>
                    <asp:TextBox ID="txtIdentificacion" runat="server"
                        CssClass="input" MaxLength="20"
                        onkeypress="return filtrarTeclaId(event)"
                        oninput="validarIdEnVivo(this)" />
                    <span id="spanErrId" style="color:red; font-size:0.85em; display:none;"></span>
                </div>

                <%-- Nombre Completo --%>
                <div class="form-group">
                    <label>Nombre Completo <span style="color:red">*</span></label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="input" MaxLength="150" />
                </div>

                <%-- Teléfono --%>
                <div class="form-group">
                    <label>
                        Teléfono <span style="color:red">*</span>
                        <small style="font-weight:normal; color:#888; font-size:0.82em;">8 dígitos CR, inicia con 2,4,6,7 u 8</small>
                    </label>
                    <asp:TextBox ID="txtTelefono" runat="server"
                        CssClass="input" MaxLength="8"
                        placeholder="Ej: 88887777"
                        onkeypress="return soloNumero(event)" />
                </div>

                <%-- Correo --%>
                <div class="form-group">
                    <label>Correo <span style="color:red">*</span></label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="input" TextMode="Email" MaxLength="100" />
                </div>

                <%-- Contraseña --%>
                <div class="form-group">
                    <label>
                        Contraseña <span style="color:red">*</span>
                        <small style="font-weight:normal; color:#888; font-size:0.82em;">Mínimo 6 caracteres</small>
                    </label>
                    <asp:TextBox ID="txtContrasena" runat="server" CssClass="input" TextMode="Password" MaxLength="50" />
                </div>

            </div>

            <div class="actions">
                <asp:Button ID="btnGuardar" runat="server"
                    Text="Guardar Usuario"
                    CssClass="btn-primary"
                    OnClick="btnGuardar_Click" />
            </div>

        </div>
    </div>

</form>

<script type="text/javascript">

    // ── Diccionario JSON del servidor, indexado por ID numerico del tipo ───────
    // configTipos["1"] => { placeholder, hint, maxLength, longitudMin, soloNumerico, patronRegex }
    var configTipos = <%= TiposIdentificacionJson %>;

    // ── Al cambiar tipo: actualiza placeholder, hint, maxlength, limpia campo ──
    function actualizarPlaceholderIdentificacion(ddl) {
        var val = ddl.value;
        var txtId = document.getElementById('<%= txtIdentificacion.ClientID %>');
        var hint  = document.getElementById('lblHintIdentificacion');
        var errId = document.getElementById('spanErrId');

        if (!txtId) return;

        txtId.value = '';
        if (errId) { errId.style.display = 'none'; errId.textContent = ''; }

        var cfg = configTipos[val];
        if (cfg) {
            txtId.placeholder = cfg.placeholder;
            txtId.maxLength   = cfg.maxLength;
            if (hint) hint.innerText = '— ' + cfg.hint;
        } else {
            txtId.placeholder = '';
            txtId.maxLength   = 20;
            if (hint) hint.innerText = '';
        }
        txtId.focus();
    }

    // ── Filtrar teclas segun tipo: solo numeros o alfanumerico ────────────────
    function filtrarTeclaId(e) {
        var ddl = document.getElementById('<%= ddlTipoIdentificacion.ClientID %>');
        if (!ddl) return true;
        var cfg = configTipos[ddl.value];
        if (!cfg) return true;

        var charCode = (typeof e.which === 'undefined') ? e.keyCode : e.which;
        if (charCode < 32) return true; // teclas de control

        if (cfg.soloNumerico) {
            return charCode >= 48 && charCode <= 57; // solo digitos
        }
        // Alfanumerico (Pasaporte) - solo mayúsculas y números
        var char = String.fromCharCode(charCode);
        return /^[A-Z0-9]$/i.test(char);
    }

    // ── Solo numeros para telefono ────────────────────────────────────────────
    function soloNumero(e) {
        var charCode = (typeof e.which === 'undefined') ? e.keyCode : e.which;
        if (charCode < 32) return true;
        return charCode >= 48 && charCode <= 57;
    }

    // ── Validar identificacion en vivo mientras escribe ───────────────────────
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

        if (val.length > 0 && val.length < cfg.longitudMin) {
            errId.textContent   = 'Mínimo ' + cfg.longitudMin + ' caracteres';
            errId.style.display = 'inline';
            return;
        }

        if (val.length >= cfg.longitudMin && cfg.patronRegex) {
            var re = new RegExp(cfg.patronRegex);
            if (!re.test(val)) {
                errId.textContent   = cfg.soloNumerico ? 'Solo se permiten números' : 'Formato no válido';
                errId.style.display = 'inline';
                return;
            }
        }

        errId.style.display = 'none';
        errId.textContent   = '';
    }

    // ── Al cargar: restaurar placeholder/hint sin borrar valor existente ──────
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
            if (txtId.value !== '') validarIdEnVivo(txtId);
        }
    });

</script>

</body>
</html>