-- ============================================================
-- BASE DE DATOS : Apf_cotizaciones
-- PROYECTO      : Sistema de Cotizacion APF
-- ESTANDARES    : Tatiana Brenes Campos 
-- VERSION       : 6.0 - FINAL DEFINITIVO
-- FECHA         : 2026-03-15
-- SOLUCION      : Cada SP en su propio lote con USE explicito.
-- ============================================================

USE [master]
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Apf_cotizaciones')
BEGIN
    ALTER DATABASE [Apf_cotizaciones] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [Apf_cotizaciones];
END
GO

CREATE DATABASE [Apf_cotizaciones]
GO
ALTER DATABASE [Apf_cotizaciones] SET COMPATIBILITY_LEVEL = 160
GO
ALTER DATABASE [Apf_cotizaciones] SET RECOVERY SIMPLE
GO
ALTER DATABASE [Apf_cotizaciones] SET MULTI_USER
GO

USE [Apf_cotizaciones]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SECCION 1: TABLAS
-- ============================================================

CREATE TABLE [dbo].[Monedas] (
    [moneda_id]          INT         IDENTITY(1,1) NOT NULL,
    [codigo]             CHAR(3)     NOT NULL,
    [nombre]             VARCHAR(50) NOT NULL,
    [simbolo]            VARCHAR(5)  NOT NULL,
    [estado]             VARCHAR(10) NOT NULL CONSTRAINT DF_Monedas_estado         DEFAULT ('Activo'),
    [fecha_creacion]     DATETIME    NOT NULL CONSTRAINT DF_Monedas_fecha_creacion  DEFAULT (GETDATE()),
    [creado_por]         VARCHAR(50) NOT NULL,
    [fecha_modificacion] DATETIME    NULL,
    [modificado_por]     VARCHAR(50) NULL,
    CONSTRAINT PK_Monedas        PRIMARY KEY CLUSTERED ([moneda_id] ASC),
    CONSTRAINT UQ_Monedas_codigo UNIQUE ([codigo]),
    CONSTRAINT CK_Monedas_estado CHECK ([estado] IN ('Activo','Inactivo'))
)
GO

CREATE TABLE [dbo].[Tipos_identificacion] (
    [tipo_identificacion_id] INT          IDENTITY(1,1) NOT NULL,
    [codigo]                 VARCHAR(20)  NOT NULL,
    [nombre]                 VARCHAR(100) NOT NULL,
    [descripcion]            VARCHAR(200) NULL,
    [longitud_min]           INT          NOT NULL,
    [longitud_max]           INT          NOT NULL,
    [patron_regex]           VARCHAR(200) NOT NULL,
    [solo_numerico]          BIT          NOT NULL CONSTRAINT DF_TiposId_solo_numerico DEFAULT (1),
    [estado]                 BIT          NOT NULL CONSTRAINT DF_TiposId_estado         DEFAULT (1),
    [fecha_creacion]         DATETIME     NOT NULL CONSTRAINT DF_TiposId_fecha_creacion DEFAULT (GETDATE()),
    [creado_por]             VARCHAR(50)  NULL,
    [fecha_modificacion]     DATETIME     NULL,
    [modificado_por]         VARCHAR(50)  NULL,
    CONSTRAINT PK_Tipos_identificacion PRIMARY KEY CLUSTERED ([tipo_identificacion_id] ASC),
    CONSTRAINT UQ_TiposId_codigo       UNIQUE ([codigo])
)
GO

CREATE TABLE [dbo].[Usuarios] (
    [usuario_id]             INT          IDENTITY(1,1) NOT NULL,
    [tipo_identificacion_id] INT          NOT NULL,
    [identificacion]         VARCHAR(30)  NOT NULL,
    [nombre_completo]        VARCHAR(150) NOT NULL,
    [telefono]               VARCHAR(20)  NULL,
    [correo]                 VARCHAR(100) NOT NULL,
    [contrasena]             VARCHAR(255) NOT NULL,
    [rol]                    VARCHAR(10)  NOT NULL,
    [estado]                 VARCHAR(20)  NOT NULL,
    [fecha_creacion]         DATETIME     NOT NULL CONSTRAINT DF_Usuarios_fecha_creacion DEFAULT (GETDATE()),
    [creado_por]             VARCHAR(50)  NOT NULL,
    [fecha_modificacion]     DATETIME     NULL,
    [modificado_por]         VARCHAR(50)  NULL,
    CONSTRAINT PK_Usuarios                    PRIMARY KEY CLUSTERED ([usuario_id] ASC),
    CONSTRAINT UQ_Usuarios_correo             UNIQUE ([correo]),
    CONSTRAINT UQ_Usuarios_identificacion     UNIQUE ([identificacion]),
    CONSTRAINT FK_Usuarios_TipoIdentificacion FOREIGN KEY ([tipo_identificacion_id])
        REFERENCES [dbo].[Tipos_identificacion] ([tipo_identificacion_id]),
    CONSTRAINT CK_Usuarios_estado      CHECK ([estado] IN ('Activo','Inactivo','Bloqueado','Eliminado')),
    CONSTRAINT CK_Usuarios_rol         CHECK ([rol]    IN ('ADMIN','NORMAL')),
    CONSTRAINT CK_Usuarios_id_longitud CHECK (LEN([identificacion]) >= 6 AND LEN([identificacion]) <= 30)
)
GO

CREATE TABLE [dbo].[Productos] (
    [producto_id]        INT          IDENTITY(1,1) NOT NULL,
    [moneda_id]          INT          NULL,
    [codigo]             VARCHAR(10)  NOT NULL,
    [nombre]             VARCHAR(100) NOT NULL,
    [estado]             VARCHAR(20)  NOT NULL,
    [fecha_creacion]     DATETIME     NOT NULL CONSTRAINT DF_Productos_fecha_creacion DEFAULT (GETDATE()),
    [creado_por]         VARCHAR(50)  NOT NULL,
    [fecha_modificacion] DATETIME     NULL,
    [modificado_por]     VARCHAR(50)  NULL,
    CONSTRAINT PK_Productos         PRIMARY KEY CLUSTERED ([producto_id] ASC),
    CONSTRAINT UQ_Productos_codigo  UNIQUE ([codigo]),
    CONSTRAINT FK_Productos_Monedas FOREIGN KEY ([moneda_id])
        REFERENCES [dbo].[Monedas] ([moneda_id]),
    CONSTRAINT CK_Productos_estado  CHECK ([estado] IN ('Activo','Inactivo','Eliminado'))
)
GO

CREATE TABLE [dbo].[Plazos] (
    [plazo_id]           INT         IDENTITY(1,1) NOT NULL,
    [meses]              INT         NOT NULL,
    [dias]               INT         NOT NULL,
    [estado]             VARCHAR(20) NOT NULL,
    [fecha_creacion]     DATETIME    NOT NULL CONSTRAINT DF_Plazos_fecha_creacion DEFAULT (GETDATE()),
    [creado_por]         VARCHAR(50) NOT NULL,
    [fecha_modificacion] DATETIME    NULL,
    [modificado_por]     VARCHAR(50) NULL,
    CONSTRAINT PK_Plazos        PRIMARY KEY CLUSTERED ([plazo_id] ASC),
    CONSTRAINT CK_Plazos_estado CHECK ([estado] IN ('Activo','Inactivo'))
)
GO

CREATE TABLE [dbo].[Tasas] (
    [tasa_id]            INT          IDENTITY(1,1) NOT NULL,
    [producto_id]        INT          NOT NULL,
    [plazo_id]           INT          NOT NULL,
    [tasa_anual]         DECIMAL(6,4) NOT NULL,
    [estado]             VARCHAR(20)  NOT NULL,
    [fecha_creacion]     DATETIME     NOT NULL CONSTRAINT DF_Tasas_fecha_creacion DEFAULT (GETDATE()),
    [creado_por]         VARCHAR(50)  NOT NULL,
    [fecha_modificacion] DATETIME     NULL,
    [modificado_por]     VARCHAR(50)  NULL,
    CONSTRAINT PK_Tasas                PRIMARY KEY CLUSTERED ([tasa_id] ASC),
    CONSTRAINT UQ_Tasas_producto_plazo UNIQUE ([producto_id],[plazo_id]),
    CONSTRAINT FK_Tasas_Productos      FOREIGN KEY ([producto_id]) REFERENCES [dbo].[Productos] ([producto_id]),
    CONSTRAINT FK_Tasas_Plazos         FOREIGN KEY ([plazo_id])    REFERENCES [dbo].[Plazos]    ([plazo_id]),
    CONSTRAINT CK_Tasas_estado         CHECK ([estado] IN ('Activo','Inactivo'))
)
GO

CREATE TABLE [dbo].[Parametros] (
    [parametro_id]       INT          IDENTITY(1,1) NOT NULL,
    [clave]              VARCHAR(50)  NOT NULL,
    [valor]              VARCHAR(100) NOT NULL,
    [descripcion]        VARCHAR(200) NULL,
    [estado]             VARCHAR(20)  NOT NULL CONSTRAINT DF_Parametros_estado         DEFAULT ('Activo'),
    [fecha_creacion]     DATETIME     NOT NULL CONSTRAINT DF_Parametros_fecha_creacion DEFAULT (GETDATE()),
    [creado_por]         VARCHAR(50)  NOT NULL,
    [fecha_modificacion] DATETIME     NULL,
    [modificado_por]     VARCHAR(50)  NULL,
    CONSTRAINT PK_Parametros        PRIMARY KEY CLUSTERED ([parametro_id] ASC),
    CONSTRAINT UQ_Parametros_clave  UNIQUE ([clave]),
    CONSTRAINT CK_Parametros_estado CHECK ([estado] IN ('Activo','Inactivo'))
)
GO

CREATE TABLE [dbo].[Cotizaciones] (
    [cotizacion_id]       INT           IDENTITY(1,1) NOT NULL,
    [numero_cotizacion]   VARCHAR(20)   NOT NULL,
    [usuario_id]          INT           NOT NULL,
    [producto_id]         INT           NOT NULL,
    [plazo_id]            INT           NOT NULL,
    [monto]               DECIMAL(18,2) NOT NULL,
    [tasa_anual]          DECIMAL(6,4)  NOT NULL,
    [impuesto]            DECIMAL(5,2)  NOT NULL,
    [total_interes_bruto] DECIMAL(18,2) NULL,
    [total_impuesto]      DECIMAL(18,2) NULL,
    [total_interes_neto]  DECIMAL(18,2) NULL,
    [estado]              VARCHAR(20)   NOT NULL,
    [fecha_creacion]      DATETIME      NOT NULL CONSTRAINT DF_Cotizaciones_fecha_creacion DEFAULT (GETDATE()),
    [creado_por]          VARCHAR(50)   NOT NULL,
    [fecha_modificacion]  DATETIME      NULL,
    [modificado_por]      VARCHAR(50)   NULL,
    CONSTRAINT PK_Cotizaciones           PRIMARY KEY CLUSTERED ([cotizacion_id] ASC),
    CONSTRAINT UQ_Cotizaciones_numero    UNIQUE ([numero_cotizacion]),
    CONSTRAINT FK_Cotizaciones_Usuarios  FOREIGN KEY ([usuario_id])  REFERENCES [dbo].[Usuarios]  ([usuario_id]),
    CONSTRAINT FK_Cotizaciones_Productos FOREIGN KEY ([producto_id]) REFERENCES [dbo].[Productos] ([producto_id]),
    CONSTRAINT FK_Cotizaciones_Plazos    FOREIGN KEY ([plazo_id])    REFERENCES [dbo].[Plazos]    ([plazo_id]),
    CONSTRAINT CK_Cotizaciones_estado    CHECK ([estado] IN ('Activo','Finalizado','Eliminado'))
)
GO

CREATE TABLE [dbo].[Cotizaciones_detalle] (
    [detalle_id]         INT           IDENTITY(1,1) NOT NULL,
    [cotizacion_id]      INT           NOT NULL,
    [mes]                INT           NOT NULL,
    [interes_bruto]      DECIMAL(18,2) NOT NULL,
    [impuesto]           DECIMAL(18,2) NOT NULL,
    [interes_neto]       DECIMAL(18,2) NOT NULL,
    [estado]             VARCHAR(20)   NOT NULL,
    [fecha_creacion]     DATETIME      NOT NULL CONSTRAINT DF_CotizDet_fecha_creacion DEFAULT (GETDATE()),
    [creado_por]         VARCHAR(50)   NOT NULL,
    [fecha_modificacion] DATETIME      NULL,
    [modificado_por]     VARCHAR(50)   NULL,
    CONSTRAINT PK_Cotizaciones_detalle  PRIMARY KEY CLUSTERED ([detalle_id] ASC),
    CONSTRAINT FK_CotizDet_Cotizaciones FOREIGN KEY ([cotizacion_id]) REFERENCES [dbo].[Cotizaciones] ([cotizacion_id]),
    CONSTRAINT CK_CotizDet_estado       CHECK ([estado] IN ('Activo','Eliminado'))
)
GO

-- ============================================================
-- SECCION 2: DATOS INICIALES
-- ============================================================

SET IDENTITY_INSERT [dbo].[Monedas] ON
INSERT [dbo].[Monedas] ([moneda_id],[codigo],[nombre],[simbolo],[creado_por]) VALUES
(1,N'COL',N'Colon Costarricense',N'C',N'Sistema'),
(2,N'USD',N'Dolar Estadounidense',N'$',N'Sistema')
SET IDENTITY_INSERT [dbo].[Monedas] OFF
GO

SET IDENTITY_INSERT [dbo].[Tipos_identificacion] ON
INSERT [dbo].[Tipos_identificacion]
    ([tipo_identificacion_id],[codigo],[nombre],[descripcion],[longitud_min],[longitud_max],[patron_regex],[solo_numerico],[creado_por])
VALUES
(1,N'FISICA',   N'Cedula Fisica',   N'Documento nacional de persona fisica en Costa Rica', 9, 9,N'\d{9}',        1,N'Sistema'),
(2,N'JURIDICA', N'Cedula Juridica', N'Identificacion oficial de personas juridicas en CR',10,10,N'[0-9]{10}',     1,N'Sistema'),
(3,N'DIMEX',    N'DIMEX',           N'Documento de Identidad Migratorio para Extranjeros', 11,12,N'[0-9]{11,12}', 1,N'Sistema'),
(4,N'NITE',     N'NITE',            N'Numero de Identificacion Tributaria Especial',       10,10,N'[0-9]{10}',    1,N'Sistema'),
(5,N'PASAPORTE',N'Pasaporte',       N'Documento internacional de viaje',                    6,20,N'[A-Za-z0-9]+', 0,N'Sistema')
SET IDENTITY_INSERT [dbo].[Tipos_identificacion] OFF
GO

SET IDENTITY_INSERT [dbo].[Parametros] ON
INSERT [dbo].[Parametros] ([parametro_id],[clave],[valor],[descripcion],[creado_por])
VALUES (1,N'IMPUESTO_RENTA',N'13',N'Porcentaje de impuesto sobre intereses bancarios (%)',N'Sistema')
SET IDENTITY_INSERT [dbo].[Parametros] OFF
GO

SET IDENTITY_INSERT [dbo].[Productos] ON
INSERT [dbo].[Productos] ([producto_id],[moneda_id],[codigo],[nombre],[estado],[creado_por]) VALUES
(1,1,N'CC',N'Colon Crece',      N'Activo',N'Sistema'),
(2,1,N'CF',N'Colon Futuro Plus',N'Activo',N'Sistema'),
(3,2,N'DS',N'Dolar Seguro',     N'Activo',N'Sistema'),
(4,2,N'DV',N'Dolar Vision',     N'Activo',N'Sistema')
SET IDENTITY_INSERT [dbo].[Productos] OFF
GO

SET IDENTITY_INSERT [dbo].[Plazos] ON
INSERT [dbo].[Plazos] ([plazo_id],[meses],[dias],[estado],[creado_por]) VALUES
( 3, 2,0,N'Activo',N'Sistema'),( 4, 3,0,N'Activo',N'Sistema'),( 5, 4,0,N'Activo',N'Sistema'),
( 6, 5,0,N'Activo',N'Sistema'),( 7, 6,0,N'Activo',N'Sistema'),( 8, 7,0,N'Activo',N'Sistema'),
( 9, 8,0,N'Activo',N'Sistema'),(10, 9,0,N'Activo',N'Sistema'),(11,10,0,N'Activo',N'Sistema'),
(12,11,0,N'Activo',N'Sistema'),(13,12,0,N'Activo',N'Sistema'),(14,13,0,N'Activo',N'Sistema'),
(15,14,0,N'Activo',N'Sistema'),(16,15,0,N'Activo',N'Sistema'),(17,16,0,N'Activo',N'Sistema'),
(18,17,0,N'Activo',N'Sistema'),(19,18,0,N'Activo',N'Sistema'),(20,19,0,N'Activo',N'Sistema'),
(21,20,0,N'Activo',N'Sistema'),(22,21,0,N'Activo',N'Sistema'),(23,22,0,N'Activo',N'Sistema'),
(24,23,0,N'Activo',N'Sistema'),(25,24,0,N'Activo',N'Sistema')
SET IDENTITY_INSERT [dbo].[Plazos] OFF
GO

SET IDENTITY_INSERT [dbo].[Tasas] ON
INSERT [dbo].[Tasas] ([tasa_id],[producto_id],[plazo_id],[tasa_anual],[estado],[creado_por]) VALUES
(48,1, 3,3.4000,N'Activo',N'Sistema'),(49,1, 4,3.6000,N'Activo',N'Sistema'),
(50,1, 5,3.7500,N'Activo',N'Sistema'),(51,1, 6,3.9000,N'Activo',N'Sistema'),
(52,1, 7,4.1000,N'Activo',N'Sistema'),(53,1, 8,4.2500,N'Activo',N'Sistema'),
(54,1, 9,4.4000,N'Activo',N'Sistema'),(55,1,10,4.5500,N'Activo',N'Sistema'),
(56,1,11,4.7000,N'Activo',N'Sistema'),(57,1,12,4.8500,N'Activo',N'Sistema'),
(58,1,13,5.0000,N'Activo',N'Sistema'),(59,1,14,5.1000,N'Activo',N'Sistema'),
(60,1,15,5.2000,N'Activo',N'Sistema'),(61,1,16,5.3000,N'Activo',N'Sistema'),
(62,1,17,5.4000,N'Activo',N'Sistema'),(63,1,18,5.5000,N'Activo',N'Sistema'),
(64,1,19,5.6500,N'Activo',N'Sistema'),(65,1,20,5.8000,N'Activo',N'Sistema'),
(66,1,21,5.9500,N'Activo',N'Sistema'),(67,1,22,6.1000,N'Activo',N'Sistema'),
(68,1,23,6.2500,N'Activo',N'Sistema'),(69,1,24,6.4000,N'Activo',N'Sistema'),
(98,1,25,6.5500,N'Activo',N'Sistema'),
( 6,2, 6,4.0000,N'Activo',N'Sistema'),( 7,2, 7,4.1500,N'Activo',N'Sistema'),
( 8,2, 8,4.3500,N'Activo',N'Sistema'),( 9,2, 9,4.5000,N'Activo',N'Sistema'),
(10,2,10,4.6500,N'Activo',N'Sistema'),(11,2,11,4.8000,N'Activo',N'Sistema'),
(12,2,12,4.9500,N'Activo',N'Sistema'),(13,2,13,5.1000,N'Activo',N'Sistema'),
(14,2,14,5.3000,N'Activo',N'Sistema'),(15,2,15,5.4000,N'Activo',N'Sistema'),
(16,2,16,5.5000,N'Activo',N'Sistema'),(17,2,17,5.6000,N'Activo',N'Sistema'),
(18,2,18,5.7000,N'Activo',N'Sistema'),(19,2,19,5.8000,N'Activo',N'Sistema'),
(20,2,20,5.9500,N'Activo',N'Sistema'),(21,2,21,6.1000,N'Activo',N'Sistema'),
(22,2,22,6.2500,N'Activo',N'Sistema'),(23,2,23,6.4000,N'Activo',N'Sistema'),
(24,2,24,6.5500,N'Activo',N'Sistema'),(99,2,25,6.9000,N'Activo',N'Sistema'),
(71,3, 3,1.2500,N'Activo',N'Sistema'),(72,3, 4,1.5000,N'Activo',N'Sistema'),
(73,3, 5,1.6500,N'Activo',N'Sistema'),(74,3, 6,1.8000,N'Activo',N'Sistema'),
(75,3, 7,2.0000,N'Activo',N'Sistema'),(76,3, 8,2.1500,N'Activo',N'Sistema'),
(77,3, 9,2.3000,N'Activo',N'Sistema'),(78,3,10,2.4500,N'Activo',N'Sistema'),
(79,3,11,2.6000,N'Activo',N'Sistema'),(80,3,12,2.7500,N'Activo',N'Sistema'),
(81,3,13,2.9000,N'Activo',N'Sistema'),(82,3,14,3.0000,N'Activo',N'Sistema'),
(83,3,15,3.1000,N'Activo',N'Sistema'),(84,3,16,3.2000,N'Activo',N'Sistema'),
(85,3,17,3.3000,N'Activo',N'Sistema'),(86,3,18,3.4000,N'Activo',N'Sistema'),
(87,3,19,3.5500,N'Activo',N'Sistema'),(88,3,20,3.7000,N'Activo',N'Sistema'),
(89,3,21,3.8500,N'Activo',N'Sistema'),(90,3,22,4.0000,N'Activo',N'Sistema'),
(91,3,23,4.1500,N'Activo',N'Sistema'),(92,3,24,4.3000,N'Activo',N'Sistema'),
(100,3,25,4.4500,N'Activo',N'Sistema'),
(27,4, 4,2.7500,N'Activo',N'Sistema'),(28,4, 5,2.9000,N'Activo',N'Sistema'),
(29,4, 6,3.0500,N'Activo',N'Sistema'),(30,4, 7,3.2500,N'Activo',N'Sistema'),
(31,4, 8,3.4000,N'Activo',N'Sistema'),(32,4, 9,3.5500,N'Activo',N'Sistema'),
(33,4,10,3.7000,N'Activo',N'Sistema'),(34,4,11,3.8500,N'Activo',N'Sistema'),
(35,4,12,4.0000,N'Activo',N'Sistema'),(36,4,13,4.2000,N'Activo',N'Sistema'),
(37,4,14,4.3000,N'Activo',N'Sistema'),(38,4,15,4.4000,N'Activo',N'Sistema'),
(39,4,16,4.5000,N'Activo',N'Sistema'),(40,4,17,4.6000,N'Activo',N'Sistema'),
(41,4,18,4.7000,N'Activo',N'Sistema'),(42,4,19,4.8500,N'Activo',N'Sistema'),
(43,4,20,5.0000,N'Activo',N'Sistema'),(44,4,21,5.1500,N'Activo',N'Sistema'),
(45,4,22,5.3000,N'Activo',N'Sistema'),(46,4,23,5.4500,N'Activo',N'Sistema'),
(47,4,24,5.6000,N'Activo',N'Sistema'),(101,4,25,6.8500,N'Activo',N'Sistema')
SET IDENTITY_INSERT [dbo].[Tasas] OFF
GO

SET IDENTITY_INSERT [dbo].[Usuarios] ON
INSERT [dbo].[Usuarios]
    ([usuario_id],[tipo_identificacion_id],[identificacion],[nombre_completo],
     [telefono],[correo],[contrasena],[rol],[estado],[creado_por])
VALUES (4,1,N'123456789',N'ADMINISTRADOR',N'85555555',N'admin@sistema.com',
        N'3eb3fe66b31e3b4d10fa70b5cad49c7112294af6ae4e476a1c405155d45aa121',
        N'ADMIN',N'Activo',N'Sistema')
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO

-- ============================================================
-- SECCION 3: STORED PROCEDURES
-- Cada SP tiene su propio: USE [Apf_cotizaciones] GO
-- Esto garantiza el contexto correcto en SSMS.
-- ============================================================

-- ------------------------------------------------------------
-- SP: sp_ObtenerParametro
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerParametro]
    @clave VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Parametros WHERE clave = @clave AND estado = 'Activo')
    BEGIN
        SELECT 0 AS resultado, 'Parametro no encontrado.' AS mensaje, NULL AS valor;
        RETURN;
    END
    SELECT 1 AS resultado, 'OK' AS mensaje, valor, descripcion
    FROM Parametros WHERE clave = @clave AND estado = 'Activo';
END
GO

-- ------------------------------------------------------------
-- SP: sp_ActualizarParametro
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ActualizarParametro]
    @clave VARCHAR(50), @valor VARCHAR(100), @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Parametros WHERE clave = @clave AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'Parametro no encontrado.' AS mensaje; RETURN; END
    IF (@valor IS NULL OR LTRIM(RTRIM(@valor)) = '')
    BEGIN SELECT 0 AS resultado, 'El valor no puede estar vacio.' AS mensaje; RETURN; END
    UPDATE Parametros
    SET valor = @valor, fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE clave = @clave AND estado = 'Activo';
    SELECT 1 AS resultado, 'Parametro actualizado correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ListarMonedas
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarMonedas]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT moneda_id, codigo, nombre, simbolo
    FROM Monedas WHERE estado = 'Activo' ORDER BY nombre;
END
GO

-- ------------------------------------------------------------
-- SP: sp_InsertarMoneda
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarMoneda]
    @codigo CHAR(3), @nombre VARCHAR(50), @simbolo VARCHAR(5), @creado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF (@codigo IS NULL OR LTRIM(RTRIM(@codigo)) = '')
    BEGIN SELECT 0 AS resultado, 'Ingrese el codigo.' AS mensaje; RETURN; END
    IF (@nombre IS NULL OR LTRIM(RTRIM(@nombre)) = '')
    BEGIN SELECT 0 AS resultado, 'Ingrese el nombre.' AS mensaje; RETURN; END
    IF EXISTS (SELECT 1 FROM Monedas WHERE codigo = UPPER(@codigo))
    BEGIN SELECT 0 AS resultado, 'El codigo ya existe.' AS mensaje; RETURN; END
    IF EXISTS (SELECT 1 FROM Monedas WHERE nombre = @nombre)
    BEGIN SELECT 0 AS resultado, 'El nombre ya existe.' AS mensaje; RETURN; END
    INSERT INTO Monedas (codigo, nombre, simbolo, estado, fecha_creacion, creado_por)
    VALUES (UPPER(@codigo), @nombre, @simbolo, 'Activo', GETDATE(), @creado_por);
    SELECT 1 AS resultado, 'Moneda creada correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ActualizarMoneda
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ActualizarMoneda]
    @moneda_id INT, @codigo CHAR(3), @nombre VARCHAR(50),
    @simbolo VARCHAR(5), @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Monedas WHERE moneda_id = @moneda_id)
    BEGIN SELECT 0 AS resultado, 'La moneda no existe.' AS mensaje; RETURN; END
    IF EXISTS (SELECT 1 FROM Monedas WHERE codigo = @codigo AND moneda_id <> @moneda_id)
    BEGIN SELECT 0 AS resultado, 'El codigo ya esta registrado.' AS mensaje; RETURN; END
    UPDATE Monedas
    SET codigo = @codigo, nombre = @nombre, simbolo = @simbolo,
        fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE moneda_id = @moneda_id;
    SELECT 1 AS resultado, 'Moneda actualizada correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_EliminarMoneda
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_EliminarMoneda]
    @moneda_id INT, @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Monedas WHERE moneda_id = @moneda_id AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'La moneda no existe o ya fue eliminada.' AS mensaje; RETURN; END
    IF EXISTS (SELECT 1 FROM Productos WHERE moneda_id = @moneda_id AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'No se puede eliminar: existen productos activos asociados.' AS mensaje; RETURN; END
    UPDATE Monedas
    SET estado = 'Inactivo', fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE moneda_id = @moneda_id;
    SELECT 1 AS resultado, 'Moneda eliminada correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerMonedaPorId
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerMonedaPorId]
    @moneda_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT moneda_id, codigo, nombre, simbolo, estado
    FROM Monedas WHERE moneda_id = @moneda_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_TipoIdentificacion_Obtener
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_TipoIdentificacion_Obtener]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT tipo_identificacion_id, codigo, nombre, descripcion,
           longitud_min, longitud_max, patron_regex, solo_numerico,
           estado, fecha_creacion, fecha_modificacion, creado_por, modificado_por
    FROM Tipos_identificacion WHERE estado = 1;
END
GO

-- ------------------------------------------------------------
-- SP: sp_Login
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_Login]
    @correo VARCHAR(100), @contrasena VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE correo = @correo)
    BEGIN SELECT 0 AS usuario_id, 'El usuario no existe.' AS mensaje; RETURN; END
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE correo = @correo AND contrasena = @contrasena)
    BEGIN SELECT 0 AS usuario_id, 'Contrasena incorrecta.' AS mensaje; RETURN; END
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE correo = @correo AND estado = 'Activo')
    BEGIN SELECT 0 AS usuario_id, 'Su cuenta esta desactivada. Contacte al administrador.' AS mensaje; RETURN; END
    SELECT usuario_id, identificacion, nombre_completo, telefono, correo,
           rol, estado, fecha_creacion, '' AS mensaje
    FROM Usuarios
    WHERE correo = @correo AND contrasena = @contrasena AND estado = 'Activo';
END
GO

-- ------------------------------------------------------------
-- SP: sp_RegistrarUsuario
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_RegistrarUsuario]
    @identificacion VARCHAR(30), @nombre_completo VARCHAR(150),
    @telefono VARCHAR(20) = NULL, @correo VARCHAR(100),
    @contrasena VARCHAR(255), @tipo_identificacion_id INT, @creado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF (@identificacion IS NULL OR LTRIM(RTRIM(@identificacion)) = '')
    BEGIN SELECT 0 AS usuario_id, 'La identificacion es obligatoria.' AS mensaje; RETURN; END
    IF (@nombre_completo IS NULL OR LTRIM(RTRIM(@nombre_completo)) = '')
    BEGIN SELECT 0 AS usuario_id, 'El nombre completo es obligatorio.' AS mensaje; RETURN; END
    IF (@correo IS NULL OR LTRIM(RTRIM(@correo)) = '')
    BEGIN SELECT 0 AS usuario_id, 'El correo es obligatorio.' AS mensaje; RETURN; END
    IF EXISTS (SELECT 1 FROM Usuarios WHERE correo = @correo)
    BEGIN SELECT 0 AS usuario_id, 'El correo ya esta registrado.' AS mensaje; RETURN; END
    IF EXISTS (SELECT 1 FROM Usuarios WHERE identificacion = @identificacion)
    BEGIN SELECT 0 AS usuario_id, 'La identificacion ya esta registrada.' AS mensaje; RETURN; END
    INSERT INTO Usuarios (tipo_identificacion_id, identificacion, nombre_completo,
        telefono, correo, contrasena, rol, estado, fecha_creacion, creado_por)
    VALUES (@tipo_identificacion_id, @identificacion, @nombre_completo,
        @telefono, @correo, @contrasena, 'NORMAL', 'Activo', GETDATE(), @creado_por);
    SELECT SCOPE_IDENTITY() AS usuario_id, 'Usuario registrado correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ListarUsuarios
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarUsuarios]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT usuario_id, identificacion, nombre_completo,
           telefono, correo, rol, estado
    FROM Usuarios ORDER BY nombre_completo;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerUsuarioPorId
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerUsuarioPorId]
    @usuario_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT usuario_id, tipo_identificacion_id, identificacion,
           nombre_completo, telefono, correo, rol, estado
    FROM Usuarios WHERE usuario_id = @usuario_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ActualizarUsuario
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ActualizarUsuario]
    @usuario_id INT, @tipo_identificacion_id INT,
    @identificacion VARCHAR(30), @nombre_completo VARCHAR(150),
    @telefono VARCHAR(20) = NULL, @correo VARCHAR(100),
    @contrasena_actual VARCHAR(255) = NULL,
    @contrasena_nueva  VARCHAR(255) = NULL,
    @modificado_por    VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE usuario_id = @usuario_id)
    BEGIN SELECT 0 AS resultado, 'Usuario no encontrado.' AS mensaje; RETURN; END
    IF (@contrasena_nueva IS NOT NULL AND @contrasena_nueva <> '')
    BEGIN
        DECLARE @pwd_bd VARCHAR(255);
        SELECT @pwd_bd = contrasena FROM Usuarios WHERE usuario_id = @usuario_id;
        IF (@pwd_bd <> @contrasena_actual)
        BEGIN SELECT 0 AS resultado, 'La contrasena actual es incorrecta.' AS mensaje; RETURN; END
    END
    UPDATE Usuarios
    SET tipo_identificacion_id = @tipo_identificacion_id,
        identificacion   = @identificacion,
        nombre_completo  = @nombre_completo,
        telefono         = @telefono,
        correo           = @correo,
        contrasena       = CASE WHEN @contrasena_nueva IS NOT NULL AND @contrasena_nueva <> ''
                                THEN @contrasena_nueva ELSE contrasena END,
        fecha_modificacion = GETDATE(),
        modificado_por   = @modificado_por
    WHERE usuario_id = @usuario_id;
    SELECT 1 AS resultado, 'Datos actualizados correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_CambiarEstadoUsuario
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_CambiarEstadoUsuario]
    @usuario_id INT, @estado VARCHAR(20), @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE usuario_id = @usuario_id)
    BEGIN SELECT 0 AS resultado, 'Usuario no encontrado.' AS mensaje; RETURN; END
    IF @estado NOT IN ('Activo', 'Inactivo', 'Bloqueado')
    BEGIN SELECT 0 AS resultado, 'Estado no valido.' AS mensaje; RETURN; END
    UPDATE Usuarios
    SET estado = @estado, fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE usuario_id = @usuario_id;
    SELECT 1 AS resultado, 'Estado actualizado correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ListarProductos
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarProductos]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT producto_id, moneda_id, codigo, nombre, estado
    FROM Productos WHERE estado = 'Activo' ORDER BY nombre;
END
GO

-- ------------------------------------------------------------
-- SP: sp_InsertarProducto
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarProducto]
    @codigo VARCHAR(10), @nombre VARCHAR(100),
    @moneda_id INT, @creado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Productos WHERE codigo = @codigo)
    BEGIN SELECT 0 AS resultado, 'El codigo ya existe.' AS mensaje, NULL AS producto_id; RETURN; END
    IF EXISTS (SELECT 1 FROM Productos WHERE nombre = @nombre)
    BEGIN SELECT 0 AS resultado, 'Ya existe un producto con ese nombre.' AS mensaje, NULL AS producto_id; RETURN; END
    INSERT INTO Productos (moneda_id, codigo, nombre, estado, fecha_creacion, creado_por)
    VALUES (@moneda_id, @codigo, @nombre, 'Activo', GETDATE(), @creado_por);
    DECLARE @nuevo_id INT = SCOPE_IDENTITY();
    SELECT 1 AS resultado, 'Producto creado correctamente.' AS mensaje, @nuevo_id AS producto_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ActualizarProducto
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ActualizarProducto]
    @producto_id INT, @nombre VARCHAR(100),
    @moneda_id INT, @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Productos WHERE producto_id = @producto_id)
    BEGIN SELECT 0 AS resultado, 'El producto no existe.' AS mensaje; RETURN; END
    IF (@nombre IS NULL OR LTRIM(RTRIM(@nombre)) = '')
    BEGIN SELECT 0 AS resultado, 'El nombre es obligatorio.' AS mensaje; RETURN; END
    IF NOT EXISTS (SELECT 1 FROM Monedas WHERE moneda_id = @moneda_id AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'La moneda no existe o esta inactiva.' AS mensaje; RETURN; END
    IF EXISTS (SELECT 1 FROM Productos WHERE nombre = @nombre AND producto_id <> @producto_id)
    BEGIN SELECT 0 AS resultado, 'Ya existe un producto con ese nombre.' AS mensaje; RETURN; END
    UPDATE Productos
    SET nombre = @nombre, moneda_id = @moneda_id,
        fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE producto_id = @producto_id;
    SELECT 1 AS resultado, 'Producto actualizado correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_EliminarProducto
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_EliminarProducto]
    @producto_id INT, @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Productos WHERE producto_id = @producto_id)
    BEGIN SELECT 0 AS resultado, 'El producto no existe.' AS mensaje; RETURN; END
    BEGIN TRAN;
        UPDATE Productos
        SET estado = 'Inactivo', fecha_modificacion = GETDATE(), modificado_por = @modificado_por
        WHERE producto_id = @producto_id;
        UPDATE Tasas
        SET estado = 'Inactivo', fecha_modificacion = GETDATE(), modificado_por = @modificado_por
        WHERE producto_id = @producto_id;
    COMMIT TRAN;
    SELECT 1 AS resultado, 'Producto y sus tasas desactivados correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerProductoPorId
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerProductoPorId]
    @producto_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT producto_id, moneda_id, codigo, nombre, estado
    FROM Productos WHERE producto_id = @producto_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerProductoPorCodigo
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerProductoPorCodigo]
    @codigo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT producto_id FROM Productos WHERE codigo = @codigo AND estado = 'Activo';
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerProductoPorNombre
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerProductoPorNombre]
    @nombre VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT producto_id FROM Productos WHERE nombre = @nombre AND estado = 'Activo';
END
GO

-- ------------------------------------------------------------
-- SP: sp_ListarPlazos
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarPlazos]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT plazo_id, meses, dias,
        CASE
            WHEN meses > 0 AND dias > 0 THEN
                CAST(meses AS VARCHAR) +
                CASE WHEN meses = 1 THEN ' mes y ' ELSE ' meses y ' END +
                CAST(dias AS VARCHAR) +
                CASE WHEN dias = 1 THEN ' dia' ELSE ' dias' END
            WHEN meses > 0 THEN
                CAST(meses AS VARCHAR) +
                CASE WHEN meses = 1 THEN ' mes' ELSE ' meses' END
            WHEN dias > 0 THEN
                CAST(dias AS VARCHAR) +
                CASE WHEN dias = 1 THEN ' dia' ELSE ' dias' END
            ELSE '0 dias'
        END AS descripcion
    FROM Plazos WHERE estado = 'Activo' ORDER BY meses, dias;
END
GO

-- ------------------------------------------------------------
-- SP: sp_InsertarPlazo
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarPlazo]
    @meses INT, @dias INT, @creado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF (@meses IS NULL) SET @meses = 0;
    IF (@dias  IS NULL) SET @dias  = 0;
    IF (@meses = 0 AND @dias = 0)
    BEGIN SELECT 0 AS resultado, 'Debe ingresar meses o dias.' AS mensaje, NULL AS plazo_id; RETURN; END
    IF (@meses < 0 OR @dias < 0)
    BEGIN SELECT 0 AS resultado, 'Los valores no pueden ser negativos.' AS mensaje, NULL AS plazo_id; RETURN; END
    IF EXISTS (SELECT 1 FROM Plazos WHERE meses = @meses AND dias = @dias AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'Este plazo ya existe.' AS mensaje, NULL AS plazo_id; RETURN; END
    INSERT INTO Plazos (meses, dias, estado, fecha_creacion, creado_por)
    VALUES (@meses, @dias, 'Activo', GETDATE(), @creado_por);
    DECLARE @nuevo_id INT = SCOPE_IDENTITY();
    SELECT 1 AS resultado, 'Plazo creado correctamente.' AS mensaje, @nuevo_id AS plazo_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ActualizarPlazo
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ActualizarPlazo]
    @plazo_id INT, @meses INT, @dias INT, @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Plazos WHERE plazo_id = @plazo_id)
    BEGIN SELECT 0 AS resultado, 'El plazo no existe.' AS mensaje; RETURN; END
    UPDATE Plazos
    SET meses = @meses, dias = @dias,
        fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE plazo_id = @plazo_id;
    SELECT 1 AS resultado, 'Plazo actualizado correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_EliminarPlazo
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_EliminarPlazo]
    @plazo_id INT, @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Plazos WHERE plazo_id = @plazo_id)
    BEGIN SELECT 0 AS resultado, 'El plazo no existe.' AS mensaje; RETURN; END
    BEGIN TRAN;
        UPDATE Plazos
        SET estado = 'Inactivo', fecha_modificacion = GETDATE(), modificado_por = @modificado_por
        WHERE plazo_id = @plazo_id;
        UPDATE Tasas
        SET estado = 'Inactivo', fecha_modificacion = GETDATE(), modificado_por = @modificado_por
        WHERE plazo_id = @plazo_id;
    COMMIT TRAN;
    SELECT 1 AS resultado, 'Plazo y sus tasas desactivados correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerPlazoPorId
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerPlazoPorId]
    @plazo_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT plazo_id, meses, dias, estado FROM Plazos WHERE plazo_id = @plazo_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ListarTasas
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarTasas]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.tasa_id, t.producto_id, t.plazo_id,
           p.nombre AS producto, pl.meses, pl.dias, t.tasa_anual, t.estado
    FROM Tasas t
    INNER JOIN Productos p  ON t.producto_id = p.producto_id
    INNER JOIN Plazos    pl ON t.plazo_id    = pl.plazo_id
    WHERE t.estado = 'Activo'
    ORDER BY p.nombre, pl.meses, pl.dias;
END
GO

-- ------------------------------------------------------------
-- SP: sp_InsertarTasa
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarTasa]
    @producto_id INT, @plazo_id INT,
    @tasa_anual DECIMAL(6,4), @creado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF @tasa_anual <= 0
    BEGIN SELECT 0 AS resultado, 'La tasa debe ser mayor a 0.' AS mensaje; RETURN; END
    IF NOT EXISTS (SELECT 1 FROM Productos WHERE producto_id = @producto_id AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'El producto no existe o esta inactivo.' AS mensaje; RETURN; END
    IF NOT EXISTS (SELECT 1 FROM Plazos WHERE plazo_id = @plazo_id AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'El plazo no existe o esta inactivo.' AS mensaje; RETURN; END
    IF EXISTS (SELECT 1 FROM Tasas WHERE producto_id = @producto_id AND plazo_id = @plazo_id AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'Ya existe una tasa activa para este producto y plazo.' AS mensaje; RETURN; END
    INSERT INTO Tasas (producto_id, plazo_id, tasa_anual, estado, fecha_creacion, creado_por)
    VALUES (@producto_id, @plazo_id, @tasa_anual, 'Activo', GETDATE(), @creado_por);
    SELECT 1 AS resultado, 'Tasa creada correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ActualizarTasa
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ActualizarTasa]
    @tasa_id INT, @tasa_anual DECIMAL(6,4), @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Tasas WHERE tasa_id = @tasa_id)
    BEGIN SELECT 0 AS resultado, 'La tasa no existe.' AS mensaje; RETURN; END
    IF @tasa_anual <= 0
    BEGIN SELECT 0 AS resultado, 'La tasa debe ser mayor a cero.' AS mensaje; RETURN; END
    UPDATE Tasas
    SET tasa_anual = @tasa_anual,
        fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE tasa_id = @tasa_id;
    SELECT 1 AS resultado, 'Tasa actualizada correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_EliminarTasa
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_EliminarTasa]
    @tasa_id INT, @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Tasas WHERE tasa_id = @tasa_id)
    BEGIN SELECT 0 AS resultado, 'La tasa no existe.' AS mensaje; RETURN; END
    UPDATE Tasas
    SET estado = 'Inactivo', fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE tasa_id = @tasa_id;
    SELECT 1 AS resultado, 'Tasa desactivada correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerTasaPorId
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerTasaPorId]
    @tasa_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT tasa_id, producto_id, plazo_id, tasa_anual, estado
    FROM Tasas WHERE tasa_id = @tasa_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerTasaPorProductoYPlazo
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerTasaPorProductoYPlazo]
    @producto_id INT, @plazo_id INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Productos WHERE producto_id = @producto_id)
    BEGIN SELECT 0 AS resultado, 'El producto no existe.' AS mensaje, NULL AS tasa_id, NULL AS tasa_anual; RETURN; END
    IF NOT EXISTS (SELECT 1 FROM Plazos WHERE plazo_id = @plazo_id)
    BEGIN SELECT 0 AS resultado, 'El plazo no existe.' AS mensaje, NULL AS tasa_id, NULL AS tasa_anual; RETURN; END
    IF NOT EXISTS (SELECT 1 FROM Tasas WHERE producto_id = @producto_id AND plazo_id = @plazo_id AND estado = 'Activo')
    BEGIN SELECT 0 AS resultado, 'No existe tasa para este producto y plazo.' AS mensaje, NULL AS tasa_id, NULL AS tasa_anual; RETURN; END
    SELECT 1 AS resultado, 'OK' AS mensaje, tasa_id, tasa_anual
    FROM Tasas WHERE producto_id = @producto_id AND plazo_id = @plazo_id AND estado = 'Activo';
END
GO

-- ------------------------------------------------------------
-- SP: sp_InsertarCotizacion
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarCotizacion]
    @usuario_id INT, @producto_id INT, @plazo_id INT,
    @monto DECIMAL(18,2), @tasa_anual DECIMAL(6,4), @impuesto DECIMAL(5,2),
    @total_interes_bruto DECIMAL(18,2), @total_impuesto DECIMAL(18,2),
    @total_interes_neto DECIMAL(18,2), @creado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @nuevo_id INT;
    DECLARE @num_cot  VARCHAR(20);
    INSERT INTO Cotizaciones
        (numero_cotizacion, usuario_id, producto_id, plazo_id, monto, tasa_anual, impuesto,
         total_interes_bruto, total_impuesto, total_interes_neto, estado, fecha_creacion, creado_por)
    VALUES
        ('', @usuario_id, @producto_id, @plazo_id, @monto, @tasa_anual, @impuesto,
         @total_interes_bruto, @total_impuesto, @total_interes_neto, 'Activo', GETDATE(), @creado_por);
    SET @nuevo_id = SCOPE_IDENTITY();
    SET @num_cot  = 'COT-' + RIGHT('00000' + CAST(@nuevo_id AS VARCHAR), 5);
    UPDATE Cotizaciones SET numero_cotizacion = @num_cot WHERE cotizacion_id = @nuevo_id;
    SELECT @num_cot AS numero_cotizacion, @nuevo_id AS cotizacion_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_InsertarCotizacionDetalle
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarCotizacionDetalle]
    @cotizacion_id INT, @mes INT, @interes_bruto DECIMAL(18,2),
    @impuesto DECIMAL(18,2), @interes_neto DECIMAL(18,2), @creado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Cotizaciones_detalle
        (cotizacion_id, mes, interes_bruto, impuesto, interes_neto, estado, fecha_creacion, creado_por)
    VALUES
        (@cotizacion_id, @mes, @interes_bruto, @impuesto, @interes_neto, 'Activo', GETDATE(), @creado_por);
END
GO

-- ------------------------------------------------------------
-- SP: sp_ListarCotizacionesPorUsuario
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarCotizacionesPorUsuario]
    @usuario_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.cotizacion_id, c.numero_cotizacion, p.nombre AS nombre_producto,
           pl.meses, pl.dias, c.monto, c.tasa_anual, c.impuesto,
           c.total_interes_bruto, c.total_impuesto, c.total_interes_neto,
           c.estado, c.fecha_creacion
    FROM Cotizaciones c
    INNER JOIN Productos p  ON c.producto_id = p.producto_id
    INNER JOIN Plazos    pl ON c.plazo_id    = pl.plazo_id
    WHERE c.usuario_id = @usuario_id AND c.estado <> 'Eliminado'
    ORDER BY c.fecha_creacion DESC;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerCotizacionPorId
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerCotizacionPorId]
    @cotizacion_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.cotizacion_id, c.numero_cotizacion,
           u.nombre_completo AS nombre_cliente, u.telefono, u.correo,
           p.nombre AS nombre_producto, pl.meses, pl.dias,
           c.monto, c.tasa_anual, c.impuesto,
           c.total_interes_bruto, c.total_impuesto, c.total_interes_neto,
           c.estado, c.fecha_creacion
    FROM Cotizaciones c
    INNER JOIN Usuarios  u  ON c.usuario_id  = u.usuario_id
    INNER JOIN Productos p  ON c.producto_id = p.producto_id
    INNER JOIN Plazos    pl ON c.plazo_id    = pl.plazo_id
    WHERE c.cotizacion_id = @cotizacion_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerDetalleCotizacion
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerDetalleCotizacion]
    @cotizacion_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT detalle_id, cotizacion_id, mes, interes_bruto, impuesto, interes_neto
    FROM Cotizaciones_detalle
    WHERE cotizacion_id = @cotizacion_id AND estado = 'Activo'
    ORDER BY mes;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerEstadisticasDashboard
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerEstadisticasDashboard]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        (SELECT COUNT(*) FROM Usuarios     WHERE estado = 'Activo') AS total_usuarios,
        (SELECT COUNT(*) FROM Cotizaciones WHERE estado = 'Activo') AS cotizaciones_activas,
        (SELECT COUNT(*) FROM Cotizaciones
         WHERE MONTH(fecha_creacion) = MONTH(GETDATE())
           AND YEAR(fecha_creacion)  = YEAR(GETDATE()))             AS reportes_generados,
        (SELECT COUNT(*) FROM Productos    WHERE estado = 'Activo') AS productos_disponibles;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerTablaFinanciera
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerTablaFinanciera]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @columnas NVARCHAR(MAX);
    DECLARE @sql      NVARCHAR(MAX);
    SELECT @columnas = STRING_AGG(QUOTENAME(nombre), ',')
    FROM Productos WHERE estado = 'Activo';
    IF @columnas IS NULL BEGIN SELECT 'Sin productos activos' AS mensaje; RETURN; END
    SET @sql = N'
    SELECT Plazo, ' + @columnas + N'
    FROM (
        SELECT p.meses, p.dias,
            CASE
                WHEN p.meses > 0 AND p.dias > 0 THEN
                    CAST(p.meses AS VARCHAR) +
                    CASE WHEN p.meses = 1 THEN N'' mes y '' ELSE N'' meses y '' END +
                    CAST(p.dias AS VARCHAR) +
                    CASE WHEN p.dias = 1 THEN N'' dia'' ELSE N'' dias'' END
                WHEN p.meses > 0 THEN
                    CAST(p.meses AS VARCHAR) +
                    CASE WHEN p.meses = 1 THEN N'' mes'' ELSE N'' meses'' END
                WHEN p.dias > 0 THEN
                    CAST(p.dias AS VARCHAR) +
                    CASE WHEN p.dias = 1 THEN N'' dia'' ELSE N'' dias'' END
                ELSE N''0 dias''
            END AS Plazo,
            pr.nombre, t.tasa_anual
        FROM Plazos p
        LEFT JOIN Tasas     t  ON p.plazo_id     = t.plazo_id     AND t.estado  = N''Activo''
        LEFT JOIN Productos pr ON pr.producto_id = t.producto_id  AND pr.estado = N''Activo''
        WHERE p.estado = N''Activo''
    ) AS fuente
    PIVOT (MAX(tasa_anual) FOR nombre IN (' + @columnas + N')) AS tabla_pivot
    ORDER BY meses, dias';
    EXEC sp_executesql @sql;
END
GO

-- ------------------------------------------------------------
-- SP: sp_TablaTasasPivot
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_TablaTasasPivot]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CASE WHEN pl.dias > 0
             THEN CAST(pl.dias  AS VARCHAR) + ' dias'
             ELSE CAST(pl.meses AS VARCHAR) + ' meses'
        END AS Plazo,
        ISNULL(MAX(CASE WHEN p.codigo = 'CC' THEN t.tasa_anual END), 0) AS CC,
        ISNULL(MAX(CASE WHEN p.codigo = 'CF' THEN t.tasa_anual END), 0) AS CF,
        ISNULL(MAX(CASE WHEN p.codigo = 'DS' THEN t.tasa_anual END), 0) AS DS,
        ISNULL(MAX(CASE WHEN p.codigo = 'DV' THEN t.tasa_anual END), 0) AS DV
    FROM Tasas t
    INNER JOIN Productos p  ON t.producto_id = p.producto_id
    INNER JOIN Plazos    pl ON t.plazo_id    = pl.plazo_id
    WHERE t.estado = 'Activo'
    GROUP BY pl.meses, pl.dias
    ORDER BY pl.meses, pl.dias;
END
GO

-- ============================================================
-- SECCION 4: SPs ADICIONALES DE PARAMETROS
-- Agregados segun el script de Allison (compañera)
-- ============================================================

-- ------------------------------------------------------------
-- SP: sp_ListarParametros
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarParametros]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        parametro_id,
        clave,
        valor,
        descripcion,
        estado,
        fecha_creacion,
        creado_por,
        fecha_modificacion,
        modificado_por
    FROM Parametros;
END
GO

-- ------------------------------------------------------------
-- SP: sp_InsertarParametro
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarParametro]
(
    @clave       VARCHAR(50),
    @valor       VARCHAR(100),
    @descripcion VARCHAR(200) = NULL,
    @estado      VARCHAR(20),
    @creado_por  VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Parametros
        (clave, valor, descripcion, estado, fecha_creacion, creado_por)
    VALUES
        (@clave, @valor, @descripcion, @estado, GETDATE(), @creado_por);
END
GO

-- ------------------------------------------------------------
-- SP: sp_EliminarParametro
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_EliminarParametro]
(
    @parametro_id  INT,
    @modificado_por VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Parametros WHERE parametro_id = @parametro_id)
    BEGIN
        SELECT 0 AS resultado, 'El parametro no existe.' AS mensaje;
        RETURN;
    END
    UPDATE Parametros
    SET estado             = 'INACTIVO',
        fecha_modificacion = GETDATE(),
        modificado_por     = @modificado_por
    WHERE parametro_id = @parametro_id;
    SELECT 1 AS resultado, 'Parametro eliminado correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ActivarImpuesto
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ActivarImpuesto]
(
    @impuesto_id INT
)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Parametros WHERE parametro_id = @impuesto_id)
    BEGIN
        SELECT 0 AS resultado, 'El impuesto no existe.' AS mensaje;
        RETURN;
    END
    -- Inactiva todos los parametros de impuesto
    UPDATE Parametros SET estado = 'INACTIVO';
    -- Activa solo el seleccionado
    UPDATE Parametros
    SET estado = 'ACTIVO'
    WHERE parametro_id = @impuesto_id;
    SELECT 1 AS resultado, 'Impuesto activado correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
-- SP: sp_ImpuestoActivo
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ImpuestoActivo]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1
        parametro_id,
        clave,
        valor,
        descripcion,
        estado
    FROM Parametros
    WHERE estado = 'ACTIVO';
END
GO

-- ------------------------------------------------------------
-- SP: sp_ObtenerParametroPorId
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerParametroPorId]
(
    @parametro_id INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        parametro_id,
        clave,
        valor,
        descripcion,
        estado
    FROM Parametros
    WHERE parametro_id = @parametro_id;
END
GO

-- ------------------------------------------------------------
-- SP: sp_sp_ObtenerParametroId
-- (nombre tal cual lo tiene el script de la compañera)
-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_sp_ObtenerParametroId]
(
    @parametro_id INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        parametro_id,
        clave,
        valor,
        descripcion,
        estado,
        fecha_creacion,
        creado_por,
        fecha_modificacion,
        modificado_por
    FROM Parametros
    WHERE parametro_id = @parametro_id;
END
GO

-- ============================================================
-- VERIFICACION FINAL
-- Debe mostrar: 9 tablas y 47 SPs
-- ============================================================
USE [Apf_cotizaciones]
GO
SELECT
    (SELECT COUNT(*) FROM Apf_cotizaciones.sys.tables)     AS total_tablas,
    (SELECT COUNT(*) FROM Apf_cotizaciones.sys.procedures) AS total_sps
GO

USE [master]
GO
