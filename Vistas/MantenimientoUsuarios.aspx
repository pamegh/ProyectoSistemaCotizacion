<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MantenimientoUsuarios.aspx.cs"
    Inherits="ProyectoSistemaCotizacion.Vistas.MantenimientoUsuarios" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mantenimiento de Usuarios</title>
    <link href="../Estilos/MantenimientoUsuarios.css?v=2" rel="stylesheet" type="text/css" />
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>
<form id="form1" runat="server">

    <!-- HEADER -->
    <div class="header">

         <asp:Button 
        ID="btnInicio"
        runat="server"
        Text="← Inicio"
        CssClass="btn-back-icon"
        OnClick="btnInicio_Click" />
        <div class="header-container">
            <div class="logo">Sistema de Cotizaciones</div>
            <div class="nav">
            </div>
        </div>
    </div>

    <!-- CONTENEDOR PRINCIPAL -->
    <div class="main-container">
        <div class="card">

            <h2 class="title">Mantenimiento de Usuarios</h2>
            <p class="subtitle">Gestión de usuarios del sistema</p>

            <!-- Mensaje de resultado -->
            <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

            <!-- Búsqueda -->
            <div class="search-box">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="input"
                    Placeholder="Buscar usuario por nombre..."
                    AutoPostBack="true"
                    OnTextChanged="txtBuscar_TextChanged"
                    onkeyup="buscarUsuario()">
                </asp:TextBox>
            </div>

            <!-- GRID -->
            <asp:GridView
                ID="gvUsuarios"
                runat="server"
                AutoGenerateColumns="False"
                CssClass="tabla"
                OnRowCommand="gvUsuarios_RowCommand"
                OnRowDataBound="gvUsuarios_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="UsuarioId"      HeaderText="ID" />
                    <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre" />
                    <asp:BoundField DataField="Correo"         HeaderText="Correo" />
                    <asp:BoundField DataField="Telefono"       HeaderText="Teléfono" />
                    <asp:BoundField DataField="Rol"            HeaderText="Rol" />

                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <asp:Label ID="lblEstado" runat="server"
                                Text='<%# Eval("Estado") %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>

                            <%-- Editar datos (abre panel) --%>
                            <asp:LinkButton ID="btnEditar" runat="server"
                                CommandName="Editar"
                                CommandArgument='<%# Eval("UsuarioId") %>'
                                CssClass="btn-action"
                                ToolTip="Editar usuario">
                                <i class="fa-solid fa-user-pen"></i>
                            </asp:LinkButton>

                            <%-- Cambiar Rol --%>
                            <asp:LinkButton ID="btnCambiarRol" runat="server"
                                CommandName="CambiarRol"
                                CommandArgument='<%# Eval("UsuarioId") + "|" + Eval("Rol") %>'
                                CssClass="btn-action"
                                OnClientClick="return confirm('¿Desea cambiar el rol de este usuario?');">
                                <i class="fa-solid fa-user-shield"></i>
                            </asp:LinkButton>

                            <%-- Cambiar Estado --%>
                            <asp:LinkButton ID="btnCambiarEstado" runat="server"
                                CommandName="Estado"
                                CommandArgument='<%# Eval("UsuarioId") + "|" + Eval("Estado") %>'
                                CssClass="btn-action btn-danger"
                                OnClientClick="return confirm('¿Está seguro de cambiar el estado del usuario?');">
                                <i class="fa-solid fa-power-off"></i>
                            </asp:LinkButton>

                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <!-- PANEL DE EDICIÓN (se muestra al pulsar Editar) -->
            <asp:Panel ID="pnlEditar" runat="server" Visible="false" CssClass="panel-editar">

                <h3 class="title">Editar Usuario</h3>

                <asp:HiddenField ID="hfUsuarioId" runat="server" />

                <div class="form-grid">

                    <div class="form-group">
                        <label>Identificación <small>(no editable)</small></label>
                        <asp:TextBox ID="txtIdentificacionEdit" runat="server"
                            CssClass="input" Enabled="false" />
                    </div>

                    <div class="form-group">
                        <label>Nombre Completo</label>
                        <asp:TextBox ID="txtNombreEdit" runat="server" CssClass="input" />
                    </div>

                    <div class="form-group">
                        <label>Teléfono</label>
                        <asp:TextBox ID="txtTelefonoEdit" runat="server" CssClass="input" />
                    </div>

                    <div class="form-group">
                        <label>Correo Electrónico</label>
                        <asp:TextBox ID="txtCorreoEdit" runat="server" CssClass="input" />
                    </div>

                </div>

                <div class="form-actions">
                    <asp:Button ID="btnGuardarEdicion" runat="server" Text="Guardar Cambios"
                        CssClass="btn btn-primary" OnClick="btnGuardarEdicion_Click" />
                    <asp:Button ID="btnCancelarEdicion" runat="server" Text="Cancelar"
                        CssClass="btn btn-secondary" OnClick="btnCancelarEdicion_Click"
                        CausesValidation="false" />
                </div>

            </asp:Panel>

        </div>
    </div>

    <script>
        function buscarUsuario() {
            __doPostBack('<%= txtBuscar.UniqueID %>', '');
        }
        window.onload = function () {
            var tb = document.getElementById('<%= txtBuscar.ClientID %>');
            if (tb) { var l = tb.value.length; tb.focus(); tb.setSelectionRange(l, l); }
        };
    </script>

</form>
</body>
</html>