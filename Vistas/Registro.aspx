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

            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje" Visible="false"></asp:Label>

            <div class="form-grid">

                <%-- Tipo de Identificación --%>
                <div class="form-group">
                    <label>Tipo Identificación <span class="req">*</span></label>
                    <asp:DropDownList ID="ddlTipoIdentificacion" runat="server"
                        CssClass="input"
                        onchange="aplicarFormatoIdentificacion(this)">
                    </asp:DropDownList>
                </div>

                <%-- Número de Identificación --%>
                <div class="form-group">
                    <label>Número de Identificación <span class="req">*</span></label>
                    <asp:TextBox ID="txtIdentificacion" runat="server"
                        CssClass="input"
                        placeholder="Seleccione primero el tipo"
                        MaxLength="30" />
                    <span id="spnHintIdentificacion" class="campo-hint"></span>
                    <span id="spnErrorIdentificacion" class="campo-error" style="display:none;"></span>
                </div>

                <%-- Nombre Completo --%>
                <div class="form-group">
                    <label>Nombre Completo <span class="req">*</span></label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="input" MaxLength="150" />
                </div>

                <%-- Teléfono --%>
                <div class="form-group">
                    <label>Teléfono</label>
                    <asp:TextBox ID="txtTelefono" runat="server"
                        CssClass="input"
                        placeholder="Ej: 8888-8888"
                        MaxLength="9"
                        oninput="formatearTelefono(this)"
                        onblur="validarTelefonoCR(this)" />
                    <span class="campo-hint">Números de Costa Rica: 8 dígitos, inicia con 2, 4, 5, 6, 7 u 8</span>
                    <span id="spnErrorTelefono" class="campo-error" style="display:none;"></span>
                </div>

                <%-- Correo --%>
                <div class="form-group">
                    <label>Correo <span class="req">*</span></label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="input" TextMode="Email" MaxLength="100" />
                </div>

                <%-- Contraseña --%>
                <div class="form-group">
                    <label>Contraseña <span class="req">*</span></label>
                    <asp:TextBox ID="txtContrasena" runat="server" CssClass="input" TextMode="Password" MaxLength="100" />
                </div>

            </div>

            <div class="actions">
                <asp:Button ID="btnGuardar"
                    runat="server"
                    Text="Guardar Usuario"
                    CssClass="btn-primary"
                    OnClick="btnGuardar_Click"
                    OnClientClick="return validarFormulario();" />
            </div>

        </div>
    </div>

</form>

<%-- ═══════════════════════════════════════════════════════
     JavaScript: formato dinámico y validaciones cliente
     ═══════════════════════════════════════════════════════ --%>
<script type="text/javascript">

    // ── JSON inyectado desde servidor (todos los tipos de la BD) ─────
    var tiposIdentificacion = <%= TiposIdentificacionJson %>;

    // ── Formatos visuales por código exacto de BD ────────────────────
    // CF = Cédula Física      → 0-0000-0000  (9 dígitos + 2 guiones = 11 chars)
    // CJ = Cédula Jurídica    → 3-000-000000 (siempre inicia con 3)
    // DX = DIMEX              → 11-12 dígitos numéricos
    // PA = Pasaporte          → alfanumérico, 6-20 chars
    var formatosPorCodigo = {
        "CF": {
            placeholder: "Ej: 1-0234-0567",
            hint: "Cédula Física: 9 dígitos con formato 0-0000-0000",
            mascara: "cf"   // aplicar formato automático
        },
        "CJ": {
            placeholder: "Ej: 3-101-123456",
            hint: "Cédula Jurídica: inicia con 3, formato 3-000-000000",
            mascara: "cj"
        },
        "DX": {
            placeholder: "Ej: 11600123456",
            hint: "DIMEX: 11 o 12 dígitos, solo números"
        },
        "PA": {
            placeholder: "Ej: A1234567",
            hint: "Pasaporte: letras y números, entre 6 y 20 caracteres"
        }
    };

    // ── Al cambiar el tipo de identificación ─────────────────────────
    function aplicarFormatoIdentificacion(ddl) {
        var id = ddl.value;
        var txtId = document.getElementById('<%= txtIdentificacion.ClientID %>');
        var hint = document.getElementById('spnHintIdentificacion');
        var errSpn = document.getElementById('spnErrorIdentificacion');

        txtId.value = '';
        errSpn.style.display = 'none';
        errSpn.textContent = '';
        txtId.classList.remove('input-error');

        if (id === '0') {
            txtId.placeholder = 'Seleccione primero el tipo';
            txtId.readOnly = true;
            hint.textContent = '';
            txtId.oninput = null;
            txtId.onblur = null;
            return;
        }

        var tipo = tiposIdentificacion[id];
        if (!tipo) return;

        var fmt = formatosPorCodigo[tipo.codigo] || {};

        txtId.readOnly = false;
        txtId.placeholder = fmt.placeholder || ('Ingrese su ' + tipo.nombre);
        hint.textContent = fmt.hint || ('Entre ' + tipo.longitudMin + ' y ' + tipo.longitudMax + ' caracteres');

        // Limitar a solo numérico o alfanumérico + aplicar máscara
        txtId.oninput = function () { aplicarMascara(this, tipo.codigo); };
        txtId.onblur = function () { validarIdentificacion(tipo); };
    }

    // ── Máscara visual al escribir ────────────────────────────────────
    function aplicarMascara(input, codigo) {
        var raw = input.value.replace(/\D/g, ''); // solo dígitos

        if (codigo === 'CF') {
            // Formato: 0-0000-0000 (1-4-4)
            raw = raw.substring(0, 9);
            var parte1 = raw.substring(0, 1);
            var parte2 = raw.substring(1, 5);
            var parte3 = raw.substring(5, 9);
            var resultado = parte1;
            if (parte2) resultado += '-' + parte2;
            if (parte3) resultado += '-' + parte3;
            input.value = resultado;

        } else if (codigo === 'CJ') {
            // Formato: 3-000-000000 (1-3-6) — primer dígito siempre 3
            if (raw.length > 0 && raw[0] !== '3') {
                raw = '3' + raw.replace(/^3*/, '').substring(0, 9);
            }
            raw = raw.substring(0, 10);
            var p1 = raw.substring(0, 1);  // "3"
            var p2 = raw.substring(1, 4);  // 3 dígitos
            var p3 = raw.substring(4, 10); // 6 dígitos
            var res = p1;
            if (p2) res += '-' + p2;
            if (p3) res += '-' + p3;
            input.value = res;

        } else if (codigo === 'DX') {
            // Solo números, 11-12 dígitos
            input.value = raw.substring(0, 12);

        } else if (codigo === 'PA') {
            // Alfanumérico: permitir letras y números
            input.value = input.value.replace(/[^A-Za-z0-9]/g, '').substring(0, 20).toUpperCase();
        }
    }

    // ── Validar identificación según tipo ────────────────────────────
    function validarIdentificacion(tipo) {
        var txtId = document.getElementById('<%= txtIdentificacion.ClientID %>');
        var errSpn = document.getElementById('spnErrorIdentificacion');
        var valor  = txtId.value.trim();

        errSpn.style.display = 'none';
        txtId.classList.remove('input-error');

        if (valor === '') return true;

        // Para CF y CJ la regex de BD incluye guiones; para DX y PA no
        var codigo = tipo.codigo;

        // Validación especial Jurídica: debe iniciar con 3
        if (codigo === 'CJ') {
            var soloDigitosCJ = valor.replace(/-/g, '');
            if (soloDigitosCJ[0] !== '3') {
                mostrarErrorCampo(errSpn, txtId, 'La Cédula Jurídica debe iniciar con el dígito 3.');
                return false;
            }
        }

        // Validar contra regex de BD
        if (tipo.patronRegex && tipo.patronRegex !== '') {
            var re = new RegExp(tipo.patronRegex);
            if (!re.test(valor)) {
                var mensajes = {
                    "CF": "Formato inválido. Use el formato 0-0000-0000 (9 dígitos).",
                    "CJ": "Formato inválido. Use el formato 3-000-000000 (10 dígitos, inicia con 3).",
                    "DX": "DIMEX debe tener entre 11 y 12 dígitos numéricos.",
                    "PA": "Pasaporte: solo letras y números, entre 6 y 20 caracteres."
                };
                mostrarErrorCampo(errSpn, txtId, mensajes[codigo] || 'Formato de identificación inválido.');
                return false;
            }
        }

        return true;
    }

    // ── Formatear teléfono automáticamente (XXXX-XXXX) ───────────────
    function formatearTelefono(input) {
        var val = input.value.replace(/\D/g, '').substring(0, 8);
        input.value = val.length > 4
            ? val.substring(0, 4) + '-' + val.substring(4)
            : val;
    }

    // ── Validar teléfono Costa Rica ───────────────────────────────────
    // Válidos: 8 dígitos iniciando en 2 (fijo), 4 (VoIP), 5, 6, 7 u 8 (cel)
    function validarTelefonoCR(input) {
        var errSpn      = document.getElementById('spnErrorTelefono');
        var val         = input.value.trim();
        var soloDigitos = val.replace(/-/g, '');

        errSpn.style.display = 'none';
        input.classList.remove('input-error');

        if (val === '') return true; // opcional

        if (!/^[245678]\d{7}$/.test(soloDigitos)) {
            mostrarErrorCampo(errSpn, input,
                'Teléfono inválido. Debe tener 8 dígitos e iniciar con 2, 4, 5, 6, 7 u 8.');
            return false;
        }
        return true;
    }

    // ── Validación completa antes de enviar ───────────────────────────
    function validarFormulario() {
        var ddl  = document.getElementById('<%= ddlTipoIdentificacion.ClientID %>');
        var id   = ddl.value;
        var tipo = (id !== '0') ? tiposIdentificacion[id] : null;

        var idOk  = tipo ? validarIdentificacion(tipo) : true;
        var telOk = validarTelefonoCR(document.getElementById('<%= txtTelefono.ClientID %>'));

        return idOk && telOk;
    }

    // ── Helper ────────────────────────────────────────────────────────
    function mostrarErrorCampo(spn, input, msg) {
        spn.textContent   = msg;
        spn.style.display = 'block';
        input.classList.add('input-error');
    }

    // ── Al cargar: restaurar estado si hay tipo seleccionado (edición) ─
    window.onload = function() {
        var ddl   = document.getElementById('<%= ddlTipoIdentificacion.ClientID %>');
        var txtId = document.getElementById('<%= txtIdentificacion.ClientID %>');
        var hint = document.getElementById('spnHintIdentificacion');
        var id = ddl.value;

        if (id && id !== '0') {
            var tipo = tiposIdentificacion[id];
            if (tipo) {
                var fmt = formatosPorCodigo[tipo.codigo] || {};
                if (!txtId.value) txtId.placeholder = fmt.placeholder || '';
                hint.textContent = fmt.hint || '';
                txtId.readOnly = false;
                txtId.oninput = function () { aplicarMascara(this, tipo.codigo); };
                txtId.onblur = function () { validarIdentificacion(tipo); };
            }
        } else {
            txtId.readOnly = true;
        }
    };
</script>

</body>
</html>
