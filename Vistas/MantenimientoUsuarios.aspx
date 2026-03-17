<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MantenimientoUsuarios.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.MantenimientoUsuarios" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administración de Usuarios</title>
    <link href="../Estilos/DashboardAdmin.css" rel="stylesheet" />
    <link href="../Estilos/MantenimientoUsuarios.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>
<form id="form1" runat="server">

    <!-- HEADER -->
    <div class="header">
        <div class="header-container">
            <div class="logo">Sistema de Cotizaciones</div>
            <div class="nav">
                <a href="DashboardAdministrador.aspx">
               <i class="fa-solid fa-arrow-left"></i> Volver al Dashboard
               </a>
            </div>
        </div>
    </div>

    <!-- MENSAJE DE FEEDBACK -->
    <div class="main-container">
        <div class="card">

            <h2 class="title">Administración de Usuarios</h2>
            <p class="subtitle">Gestión de usuarios del sistema</p>

            <!-- Mensaje de éxito / error -->
            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje" Visible="false"></asp:Label>

            <!-- Búsqueda de usuario  -->
            <div class="search-box">
                <asp:TextBox
                    ID="txtBuscar"
                    runat="server"
                    CssClass="input"
                    Placeholder="Buscar usuario por nombre..."
                    AutoPostBack="true"
                    OnTextChanged="txtBuscar_TextChanged"
                    onkeyup="buscarUsuario()">
                </asp:TextBox>
            </div>

            <!-- Tabla de usuarios -->
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
                            <asp:Label
                                ID="lblEstado"
                                runat="server"
                                Text='<%# Eval("Estado") %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>

                            <!-- Botón cambiar ROL (Usuario ↔ Administrador) -->
                            <asp:LinkButton
                                ID="btnCambiarRol"
                                runat="server"
                                CommandName="CambiarRol"
                                CommandArgument='<%# Eval("UsuarioId") + "|" + Eval("Rol") %>'
                                CssClass="btn-action"
                                ToolTip='<%# Eval("Rol").ToString() == "Administrador" ? "Quitar Administrador" : "Hacer Administrador" %>'
                                OnClientClick="return confirm('¿Está seguro de cambiar el rol de este usuario?');">
                                <i class="fa-solid fa-user-shield"></i>
                            </asp:LinkButton>

                            <!-- Botón cambiar ESTADO (Activo ↔ Inactivo) -->
                            <asp:LinkButton
                                ID="btnCambiarEstado"
                                runat="server"
                                CommandName="Estado"
                                CommandArgument='<%# Eval("UsuarioId") + "|" + Eval("Estado") %>'
                                CssClass="btn-action btn-danger"
                                ToolTip='<%# Eval("Estado").ToString() == "Activo" ? "Desactivar usuario" : "Activar usuario" %>'
                                OnClientClick="return confirm('¿Está seguro de cambiar el estado del usuario?');">
                                <i class="fa-solid fa-power-off"></i>
                            </asp:LinkButton>

                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>

        </div>
    </div>

    <script>
        function buscarUsuario() {
            __doPostBack('<%= txtBuscar.UniqueID %>', '');
        }

        window.onload = function () {
            var textbox = document.getElementById('<%= txtBuscar.ClientID %>');
            if (textbox) {
                var len = textbox.value.length;
                textbox.focus();
                textbox.setSelectionRange(len, len);
            }
        };
    </script>

</form>
</body>
</html>