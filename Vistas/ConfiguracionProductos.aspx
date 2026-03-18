<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfiguracionProductos.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.ConfiguracionProductos" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Configuración - APF</title>
    <link href="../Estilos/Configuracion.css?v=4" rel="stylesheet" type="text/css" />
</head>
<body>

<form id="form1" runat="server">

<div class="main-wrapper">
<div class="layout-grid">

<div class="col-left">
<div class="card">

<div class="page-header">

<asp:Button 
    ID="btnAtras"
    runat="server"
    Text="Volver"
    CssClass="btn-back-icon"
    OnClick="btnAtras_Click" />

<h2 class="page-title">Configuración de Productos</h2>

</div> 

<div class="card-header card-header-primary">
Tabla Financiera
</div>

<div class="card-body">

<asp:GridView ID="gvTablaFinanciera"
runat="server"
CssClass="tabla-financiera"
AutoGenerateColumns="true">
</asp:GridView>

</div>
</div>
</div>

<div class="col-right">
<div class="card">

<div class="card-header card-header-dark">
    <span>Administración</span>

   <asp:LinkButton 
    ID="btnRefrescar"
    runat="server"
    CssClass="btn-refresh"
    OnClick="btnRefrescar_Click"
    ToolTip="Refrescar">
    ↻
</asp:LinkButton>
</div>

      <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="panel-mensaje">
    <asp:Label 
        ID="lblMensaje" 
        runat="server" 
        CssClass="mensaje">
    </asp:Label>
</asp:Panel>

<div class="card-body">

<div class="form-group">

<label>Tipo</label>

<asp:DropDownList
ID="ddlEntidad"
runat="server"
CssClass="form-select"
AutoPostBack="true"
OnSelectedIndexChanged="ddlEntidad_SelectedIndexChanged">

<asp:ListItem Value="">-- Seleccione --</asp:ListItem>
<asp:ListItem Value="Producto">Producto</asp:ListItem>
<asp:ListItem Value="Plazo">Plazo</asp:ListItem>
<asp:ListItem Value="Tasa">Tasa</asp:ListItem>

</asp:DropDownList>

</div>

<asp:Panel ID="pnlFormulario" runat="server" Visible="false">

<asp:Panel ID="pnlProducto" runat="server" Visible="false">

<div class="mb-3">
<label>Producto</label>

<asp:DropDownList
ID="ddlProductoBuscar"
runat="server"
CssClass="form-select"
AutoPostBack="true"
OnSelectedIndexChanged="ddlProductoBuscar_SelectedIndexChanged">
</asp:DropDownList>

</div>

<asp:Panel ID="pnlNombreProducto" runat="server" CssClass="form-group">

<label>Nombre</label>

<asp:TextBox
ID="txtNombreProducto"
runat="server"
CssClass="form-input">
</asp:TextBox>

</asp:Panel>

<asp:Panel ID="pnlMonedaProducto" runat="server" CssClass="form-group">

<label>Moneda</label>

<div class="input-group">

<asp:DropDownList
ID="ddlMonedaProducto"
runat="server"
CssClass="form-select">
</asp:DropDownList>

<asp:Button
ID="btnNuevaMoneda"
runat="server"
Text="+"
CssClass="btn btn-icon"
OnClientClick="window.open('ConfiguracionMonedas.aspx','_blank'); return false;" />
</div>

</asp:Panel>

<asp:Panel ID="pnlPlazosProducto" runat="server" CssClass="form-group">

<label>Seleccione los plazos</label>

<asp:CheckBoxList
ID="chkPlazos"
runat="server"
CssClass="checkbox-list"
AutoPostBack="true"
OnSelectedIndexChanged="chkPlazos_SelectedIndexChanged">
</asp:CheckBoxList>

</asp:Panel>

<asp:Panel ID="pnlTasasProducto" runat="server" CssClass="form-group">

<label>Tasas de interés (%)</label>

<asp:GridView ID="gvTasasProducto" runat="server" AutoGenerateColumns="false" CssClass="tabla-simple">
    <Columns>

        <asp:TemplateField HeaderText="Plazo">
            <ItemTemplate>
                <%# Eval("Plazo") %>
                <asp:HiddenField ID="hfPlazoId" runat="server"
                    Value='<%# Eval("PlazoId") %>' />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Tasa (%)">
            <ItemTemplate>
                <asp:TextBox ID="txtTasa" runat="server"
                    CssClass="form-input"
                    Text='<%# Eval("Tasa") %>'>
                </asp:TextBox>
            </ItemTemplate>
        </asp:TemplateField>

    </Columns>
</asp:GridView>

</asp:Panel>

</asp:Panel>

<asp:Panel ID="pnlPlazo" runat="server" Visible="false">

<div class="form-group">

<label>Plazo</label>

<asp:DropDownList
ID="ddlPlazoBuscar"
runat="server"
CssClass="form-select"
AutoPostBack="true"
OnSelectedIndexChanged="ddlPlazoBuscar_SelectedIndexChanged">
</asp:DropDownList>

</div>

<asp:Panel ID="pnlMesesPlazo" runat="server" CssClass="form-group">

<label>Meses</label>

<asp:TextBox
ID="txtMesesPlazo"
runat="server"
CssClass="form-input">
</asp:TextBox>

</asp:Panel>

<asp:Panel ID="pnlDiasPlazo" runat="server" CssClass="form-group">

<label>Días</label>

<asp:DropDownList ID="ddlDiasPlazo" runat="server" CssClass="form-select">
</asp:DropDownList>

</asp:Panel>

<asp:Panel ID="pnlProductosPlazo" runat="server" CssClass="form-group">

<label>Aplicar este plazo a productos</label>

<asp:CheckBoxList
ID="chkProductosPlazo"
runat="server"
CssClass="checkbox-list"
AutoPostBack="true"
OnSelectedIndexChanged="chkProductosPlazo_SelectedIndexChanged">
</asp:CheckBoxList>

</asp:Panel>

<asp:Panel ID="pnlTasasPlazo" runat="server" CssClass="form-group">

<label>Tasas para los productos seleccionados</label>

<asp:GridView
ID="gvTasasPlazo"
runat="server"
AutoGenerateColumns="false"
CssClass="tabla-simple">

<Columns>

<asp:BoundField DataField="Producto" HeaderText="Producto" />

<asp:TemplateField HeaderText="Tasa (%)">

<ItemTemplate>

<asp:HiddenField
ID="hfProductoId"
runat="server"
Value='<%# Eval("ProductoId") %>' />

<asp:TextBox
ID="txtTasa"
runat="server"
CssClass="form-input"
Text='<%# Bind("Tasa") %>' />

</ItemTemplate>

</asp:TemplateField>

</Columns>

</asp:GridView>

</asp:Panel>

</asp:Panel>

<asp:Panel ID="pnlTasaFiltros" runat="server" Visible="false">

<div class="form-group">

<label>Producto</label>

<asp:DropDownList
ID="ddlProductoTasa"
runat="server"
CssClass="form-select"
AutoPostBack="true"
AppendDataBoundItems="true"
OnSelectedIndexChanged="ddlProductoTasa_SelectedIndexChanged">

<asp:ListItem Value="">-- Seleccione producto --</asp:ListItem>

</asp:DropDownList>

</div>

<div class="form-group">

<label>Plazo</label>

<asp:DropDownList 
    ID="ddlPlazoTasa"
    runat="server"
    CssClass="form-select"
    AutoPostBack="true"
    OnSelectedIndexChanged="ddlPlazoTasa_SelectedIndexChanged">
</asp:DropDownList>

</div>

<asp:Panel ID="pnlTasaEditar" runat="server" CssClass="form-group">

<label>Tasa</label>

<asp:TextBox
ID="txtTasaEditar"
runat="server"
CssClass="form-input"
TextMode="Number"
step="0.0001">
</asp:TextBox>

</asp:Panel>

</asp:Panel>
    </asp:Panel>
<div class="button-group">

<asp:Button
ID="btnGuardar"
runat="server"
Text="Guardar"
CssClass="btn btn-success"
OnClick="btnGuardar_Click" />

<asp:Button
ID="btnEliminar"
runat="server"
Text="Eliminar"
CssClass="btn btn-danger"
OnClick="btnEliminar_Click"
    />

<asp:Button
ID="btnNuevo"
runat="server"
Text="Nuevo"
CssClass="btn btn-secondary"
OnClick="btnNuevo_Click" />
</div>
</div>
</div>

<div class="card card-margin-top">

<div class="card-header card-header-warning">
Administración de Impuestos
</div>

<div class="card-body">

<div class="form-group">
<label>Impuesto activo</label>

<asp:Label
ID="lblImpuestoActivo"
runat="server"
CssClass="label-display label-success">
</asp:Label>

</div>

<div class="form-group">
    <asp:HiddenField ID="hfParametroId" runat="server" />

<label>Seleccionar impuesto</label>

<asp:DropDownList
ID="ddlImpuestos"
runat="server"
CssClass="form-select"
AutoPostBack="true"
OnSelectedIndexChanged="ddlImpuestos_SelectedIndexChanged">
</asp:DropDownList>

</div>



<div class="form-group">

<label>Nombre</label>

<asp:TextBox
ID="txtNombreImpuesto"
runat="server"
CssClass="form-input">
</asp:TextBox>

</div>

<div class="form-group">

<label>Porcentaje (%)</label>

<asp:TextBox
ID="txtPorcentajeImpuesto"
runat="server"
CssClass="form-input"
TextMode="Number"
step="0.01">
</asp:TextBox>

</div>

<div class="button-group">

<asp:Button
ID="btnGuardarImpuesto"
runat="server"
Text="Guardar"
CssClass="btn btn-success"
OnClick="btnGuardarImpuesto_Click" />

<asp:Button
ID="btnEliminarImpuesto"
runat="server"
Text="Eliminar"
CssClass="btn btn-danger"
OnClick="btnEliminarImpuesto_Click" />

<asp:Button
ID="btnNuevoImpuesto"
runat="server"
Text="Nuevo"
CssClass="btn btn-secondary"
OnClick="btnNuevoImpuesto_Click" />

    <div class="mensaje-container">
<asp:Label 
    ID="lblMensajeImpuesto"
    runat="server"
    CssClass="label-success">
</asp:Label>
</div>
</div>

</div>
</div>

</div>

</div>
</div>

</form>
</body>
</html>