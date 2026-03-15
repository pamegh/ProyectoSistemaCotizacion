<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfiguracionMonedas.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.ConfiguracionMonedas" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Configuración de Monedas</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body>

<form id="form1" runat="server">

<div class="container mt-4">

    <div class="d-flex justify-content-between mb-3">

</div>

<div class="card">

<div class="card-header bg-dark text-white">
Administración de Monedas
    <div style="position:absolute; top:15px; right:20px;">

<asp:Button ID="btnCerrar"
runat="server"
Text="Atrás"
CssClass="btn btn-danger btn-sm"
OnClientClick="window.close(); return false;" />

</div>
</div>

<div class="card-body">

<div class="mb-3">
<label>Moneda</label>

<asp:DropDownList ID="ddlMoneda"
runat="server"
CssClass="form-control"
AutoPostBack="true"
OnSelectedIndexChanged="ddlMoneda_SelectedIndexChanged">
</asp:DropDownList>

</div>

<div class="mb-3">
<label>Código</label>

<asp:TextBox ID="txtCodigo"
runat="server"
CssClass="form-control"/>
</div>

<div class="mb-3">
<label>Nombre</label>

<asp:TextBox ID="txtNombre"
runat="server"
CssClass="form-control"/>
</div>

<div class="mb-3">
<label>Símbolo</label>

<asp:TextBox ID="txtSimbolo"
runat="server"
CssClass="form-control"/>
</div>

<div class="d-grid gap-2">

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

<asp:Label ID="lblMensaje"
runat="server"
CssClass="mt-3 fw-bold"></asp:Label>

</div>

</div>

</div>

</form>

</body>
</html>