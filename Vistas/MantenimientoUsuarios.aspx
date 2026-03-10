<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MantenimientoUsuarios.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.MantenimientoUsuarios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mantenimiento de Usuarios</title>
</head>

<body>

<form id="form1" runat="server">

    <h2>Mantenimiento de Usuarios</h2>

    <asp:GridView 
        ID="gvUsuarios"
        runat="server"
        AutoGenerateColumns="False"
        Width="100%">

        <Columns>

            <asp:BoundField DataField="UsuarioId" HeaderText="ID" />
            <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre Completo" />
            <asp:BoundField DataField="Correo" HeaderText="Correo" />
            <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
            <asp:BoundField DataField="Rol" HeaderText="Rol" />
            <asp:BoundField DataField="Estado" HeaderText="Estado" />

        </Columns>

    </asp:GridView>

</form>

</body>
</html>