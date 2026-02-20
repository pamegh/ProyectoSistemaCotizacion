<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfiguracionProductos.aspx.cs" Inherits="ProyectoSistemaCotizacion.Vistas.ConfiguracionProductos" %>

  <!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Configuración - APF</title>
    <link href="../Estilos/Configuracion.css" rel="stylesheet" />
</head>
<body>
<form id="form1" runat="server">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

<div class="container-fluid mt-4">
    <div class="row">

        <div class="col-md-8">
            <div class="card">
                <div class="page-header">
    <asp:Button ID="btnAtras" runat="server"
        Text="Volver"
        CssClass="btn-back-icon"
        OnClientClick="history.back(); return false;" />

    <h2 class="page-title">Configuración de Productos</h2>
</div>
                <div class="card-header bg-primary text-white">
                    Tabla Financiera
                </div>
                <div class="card-body">
                    <asp:GridView ID="gvTablaFinanciera" runat="server"
                        CssClass="table table-bordered table-striped text-center"
                        AutoGenerateColumns="true">
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card">
                <div class="card-header bg-dark text-white">
                    Administración
                </div>
                <div class="card-body">

                    <div class="mb-3">
                        <label>Tipo</label>
                        <asp:DropDownList ID="ddlEntidad" runat="server" CssClass="form-control"
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
        <asp:DropDownList ID="ddlProductoBuscar" runat="server"
            CssClass="form-control"
            AutoPostBack="true"
            OnSelectedIndexChanged="ddlProductoBuscar_SelectedIndexChanged">
        </asp:DropDownList>
    </div>

    <div class="mb-3">
        <label>Nombre</label>
        <asp:TextBox ID="txtNombreProducto" runat="server"
            CssClass="form-control"></asp:TextBox>
    </div>

</asp:Panel>


<asp:Panel ID="pnlPlazo" runat="server" Visible="false">

    <div class="mb-3">
        <label>Plazo</label>
        <asp:DropDownList ID="ddlPlazoBuscar" runat="server"
            CssClass="form-control"
            AutoPostBack="true"
            OnSelectedIndexChanged="ddlPlazoBuscar_SelectedIndexChanged">
        </asp:DropDownList>
    </div>

    <div class="mb-3">
        <label>Meses</label>
        <asp:TextBox ID="txtMesesPlazo" runat="server"
            CssClass="form-control"></asp:TextBox>
    </div>

    <div class="mb-3">
        <label>Días</label>
        <asp:TextBox ID="txtDiasPlazo" runat="server"
            CssClass="form-control"></asp:TextBox>
    </div>

</asp:Panel>

<asp:Panel ID="pnlTasaFiltros" runat="server" Visible="false">

    <div class="mb-3">
        <label>Producto</label>
        <asp:DropDownList ID="ddlProductoTasa" runat="server"
            CssClass="form-control"
            AutoPostBack="true"
            OnSelectedIndexChanged="ddlProductoTasa_SelectedIndexChanged">
        </asp:DropDownList>
    </div>

    <div class="mb-3">
        <label>Plazo</label>
        <asp:DropDownList ID="ddlPlazoTasa" runat="server"
            CssClass="form-control"
            AutoPostBack="true"
            OnSelectedIndexChanged="ddlPlazoTasa_SelectedIndexChanged">
        </asp:DropDownList>
    </div>

    <div class="mb-3">
        <label>Tasa</label>
        <asp:TextBox ID="txtTasaEditar" runat="server"
            CssClass="form-control"></asp:TextBox>
    </div>

</asp:Panel>


<div class="mt-3 d-grid gap-2">
    <asp:Button ID="btnGuardar" runat="server"
        Text="Guardar"
        CssClass="btn btn-success"
        OnClick="btnGuardar_Click" />

    <asp:Button ID="btnEliminar" runat="server"
        Text="Eliminar"
        CssClass="btn btn-danger"
        OnClick="btnEliminar_Click"
        OnClientClick="return confirm('¿Seguro que desea eliminar?');" />
</div>

<asp:Label ID="lblMensaje" runat="server"
    CssClass="mt-2 fw-bold"></asp:Label>

</asp:Panel>

                </div>
            </div>
        </div>

    </div>
</div>

</form>
</body>
</html>