<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MantenimientoUsuarios.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.MantenimientoUsuarios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mantenimiento de Usuarios</title>

    <link href="~/Estilos/MantenimientoUsuarios.css" rel="stylesheet" />

    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

    <form id="form1" runat="server">

        <!-- HEADER -->
        <div class="header">
            <div class="header-container">

                <div class="logo">
                    Sistema de Cotizaciones
                </div>

                <div class="nav">
                    <a href="Menu.aspx">Inicio</a>
                    <a href="Registro.aspx">Nuevo Usuario</a>
                </div>

            </div>
        </div>

        <!-- CONTENEDOR PRINCIPAL -->
        <div class="main-container">

            <div class="card">

                <h2 class="title">Mantenimiento de Usuarios</h2>
                <p class="subtitle">Gestión de usuarios del sistema</p>

                <!-- Busqueda por nombre -->
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

                <asp:GridView
                    ID="gvUsuarios"
                    runat="server"
                    AutoGenerateColumns="False"
                    CssClass="tabla"
                    OnRowCommand="gvUsuarios_RowCommand"
                    OnRowDataBound="gvUsuarios_RowDataBound">

                    <Columns>

                        <asp:BoundField DataField="UsuarioId" HeaderText="ID" />
                        <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre" />
                        <asp:BoundField DataField="Correo" HeaderText="Correo" />
                        <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="Rol" HeaderText="Rol" />

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

                                <asp:LinkButton
                                    ID="btnEditar"
                                    runat="server"
                                    CommandName="Editar"
                                    CommandArgument='<%# Eval("UsuarioId") %>'
                                    CssClass="btn-action">

                                <i class="fa-solid fa-user-pen"></i>

                                </asp:LinkButton>

                                <asp:LinkButton
                                    ID="btnCambiarEstado"
                                    runat="server"
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

                <script>

                    function buscarUsuario() {

                        __doPostBack('<%= txtBuscar.UniqueID %>', '');

                    }

                </script>

                <script>

                    function ponerCursorFinal() {

                        var textbox = document.getElementById('<%= txtBuscar.ClientID %>');

                        var len = textbox.value.length;

                        textbox.focus();

                        textbox.setSelectionRange(len, len);

                    }

                    window.onload = ponerCursorFinal;

                </script>

            </div>

        </div>

    </form>

</body>
</html>
