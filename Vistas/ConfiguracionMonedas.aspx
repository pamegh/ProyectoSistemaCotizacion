<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfiguracionMonedas.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.ConfiguracionMonedas" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Configuración de Monedas</title>
    <link href="../Estilos/ConfiguracionMonedas.css?v=3" rel="stylesheet" type="text/css" />
</head>
<body>

<form id="form1" runat="server">

<div class="container">

<div class="card">

<div class="card-header">
Administración de Monedas
    <asp:Button ID="btnCerrar"
runat="server"
Text="Atrás"
CssClass="btn-close"
OnClientClick="window.close(); return false;" />
</div>

<div class="card-body">

<asp:Label ID="lblMensaje"
runat="server"
CssClass="mensaje"
Visible="true"></asp:Label>

<div class="form-group">
<label>Moneda</label>

<asp:DropDownList ID="ddlMoneda"
runat="server"
CssClass="form-select"
AutoPostBack="true"
OnSelectedIndexChanged="ddlMoneda_SelectedIndexChanged">
</asp:DropDownList>

</div>

<div class="form-group">
<label>Código</label>

<asp:TextBox ID="txtCodigo"
runat="server"
CssClass="form-input"/>
</div>

<div class="form-group">
<label>Nombre</label>

<asp:TextBox ID="txtNombre"
runat="server"
CssClass="form-input"/>
</div>

<div class="form-group">
<label>Símbolo</label>

<asp:TextBox ID="txtSimbolo"
runat="server"
CssClass="form-input"/>
</div>

<div class="button-group">

<asp:Button ID="btnGuardar"
runat="server"
Text="Guardar"
CssClass="btn btn-success"
OnClick="btnGuardar_Click"/>

<asp:Button ID="btnEliminar"
runat="server"
Text="Eliminar"
CssClass="btn btn-danger"
OnClick="btnEliminar_Click"
OnClientClick="return confirm('¿Seguro que desea eliminar la moneda?');"/>

<asp:Button ID="btnNuevo"
runat="server"
Text="Nuevo"
CssClass="btn btn-secondary"
OnClick="btnNuevo_Click"/>

</div>

</div>

</div>

</div>

</form>

</body>
</html>