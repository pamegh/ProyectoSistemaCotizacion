-- ============================================================
--  SICAPF - Sistema de Cotizaciones APF
--  Script Version: V14 Definitivo
--  Fecha: 2026-04-10
--  Descripcion: Script limpio, independiente de maquina.
--               Elimina y recrea la base de datos completa.
--               9 tablas | 52 procedimientos almacenados
--               Incluye datos semilla completos.
--  Cambios V14:
--    - sp_ListarCotizaciones: agrega @moneda_id como filtro
--      opcional, incluye moneda_id y nombre_moneda en el SELECT,
--      y cambia JOIN de Monedas de LEFT a INNER.
-- ============================================================

USE [master]
GO

-- ============================================================
--  1. DROP Y CREACION DE BASE DE DATOS
-- ============================================================
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Apf_cotizaciones')
BEGIN
    ALTER DATABASE [Apf_cotizaciones] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [Apf_cotizaciones];
END
GO

CREATE DATABASE [Apf_cotizaciones]
GO

USE [Apf_cotizaciones]
GO

-- ============================================================
--  2. TABLAS
-- ============================================================

-- Tipos_identificacion
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tipos_identificacion](
    [tipo_identificacion_id] [int] IDENTITY(1,1) NOT NULL,
    [codigo]           [varchar](20)  NOT NULL,
    [nombre]           [varchar](100) NOT NULL,
    [descripcion]      [varchar](255) NULL,
    [longitud_min]     [int]          NOT NULL DEFAULT(1),
    [longitud_max]     [int]          NOT NULL DEFAULT(20),
    [patron_regex]     [varchar](100) NULL,
    [solo_numerico]    [bit]          NOT NULL DEFAULT(0),
    [estado]           [bit]          NOT NULL DEFAULT(1),
    [fecha_creacion]   [datetime]     NOT NULL DEFAULT(GETDATE()),
    [creado_por]       [varchar](50)  NOT NULL,
    [fecha_modificacion] [datetime]   NULL,
    [modificado_por]   [varchar](50)  NULL,
    CONSTRAINT [PK_Tipos_identificacion] PRIMARY KEY CLUSTERED ([tipo_identificacion_id] ASC)
) ON [PRIMARY]
GO

-- Monedas
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monedas](
    [moneda_id]        [int] IDENTITY(1,1) NOT NULL,
    [codigo]           [char](3)     NOT NULL,
    [nombre]           [varchar](50) NOT NULL,
    [simbolo]          [varchar](5)  NOT NULL,
    [estado]           [varchar](10) NOT NULL DEFAULT('Activo'),
    [fecha_creacion]   [datetime]    NOT NULL DEFAULT(GETDATE()),
    [creado_por]       [varchar](50) NOT NULL,
    [fecha_modificacion] [datetime]  NULL,
    [modificado_por]   [varchar](50) NULL,
    CONSTRAINT [PK_Monedas] PRIMARY KEY CLUSTERED ([moneda_id] ASC)
) ON [PRIMARY]
GO

-- Parametros
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parametros](
    [parametro_id]     [int] IDENTITY(1,1) NOT NULL,
    [clave]            [varchar](50)  NOT NULL,
    [valor]            [varchar](100) NOT NULL,
    [descripcion]      [varchar](200) NULL,
    [estado]           [varchar](20)  NOT NULL DEFAULT('ACTIVO'),
    [fecha_creacion]   [datetime]     NOT NULL DEFAULT(GETDATE()),
    [creado_por]       [varchar](50)  NOT NULL,
    [fecha_modificacion] [datetime]   NULL,
    [modificado_por]   [varchar](50)  NULL,
    CONSTRAINT [PK_Parametros] PRIMARY KEY CLUSTERED ([parametro_id] ASC)
) ON [PRIMARY]
GO

-- Productos
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
    [producto_id]      [int] IDENTITY(1,1) NOT NULL,
    [moneda_id]        [int]          NOT NULL,
    [codigo]           [varchar](10)  NOT NULL,
    [nombre]           [varchar](100) NOT NULL,
    [estado]           [varchar](20)  NOT NULL DEFAULT('Activo'),
    [fecha_creacion]   [datetime]     NOT NULL DEFAULT(GETDATE()),
    [creado_por]       [varchar](50)  NOT NULL,
    [fecha_modificacion] [datetime]   NULL,
    [modificado_por]   [varchar](50)  NULL,
    CONSTRAINT [PK_Productos] PRIMARY KEY CLUSTERED ([producto_id] ASC)
) ON [PRIMARY]
GO

-- Plazos
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Plazos](
    [plazo_id]         [int] IDENTITY(1,1) NOT NULL,
    [meses]            [int]          NOT NULL DEFAULT(0),
    [dias]             [int]          NOT NULL DEFAULT(0),
    [estado]           [varchar](20)  NOT NULL DEFAULT('Activo'),
    [fecha_creacion]   [datetime]     NOT NULL DEFAULT(GETDATE()),
    [creado_por]       [varchar](50)  NOT NULL,
    [fecha_modificacion] [datetime]   NULL,
    [modificado_por]   [varchar](50)  NULL,
    CONSTRAINT [PK_Plazos] PRIMARY KEY CLUSTERED ([plazo_id] ASC)
) ON [PRIMARY]
GO

-- Tasas
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasas](
    [tasa_id]          [int] IDENTITY(1,1) NOT NULL,
    [producto_id]      [int]             NOT NULL,
    [plazo_id]         [int]             NOT NULL,
    [tasa_anual]       [decimal](6,4)    NOT NULL,
    [estado]           [varchar](20)     NOT NULL DEFAULT('Activo'),
    [fecha_creacion]   [datetime]        NOT NULL DEFAULT(GETDATE()),
    [creado_por]       [varchar](50)     NOT NULL,
    [fecha_modificacion] [datetime]      NULL,
    [modificado_por]   [varchar](50)     NULL,
    CONSTRAINT [PK_Tasas] PRIMARY KEY CLUSTERED ([tasa_id] ASC),
    CONSTRAINT [FK_Tasas_Productos] FOREIGN KEY ([producto_id]) REFERENCES [dbo].[Productos]([producto_id]),
    CONSTRAINT [FK_Tasas_Plazos]    FOREIGN KEY ([plazo_id])    REFERENCES [dbo].[Plazos]([plazo_id])
) ON [PRIMARY]
GO

-- Usuarios
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
    [usuario_id]             [int] IDENTITY(1,1) NOT NULL,
    [tipo_identificacion_id] [int]           NOT NULL,
    [identificacion]         [varchar](30)   NOT NULL,
    [nombre_completo]        [varchar](150)  NOT NULL,
    [telefono]               [varchar](20)   NULL,
    [correo]                 [varchar](100)  NOT NULL,
    [contrasena]             [varchar](255)  NOT NULL,
    [rol]                    [varchar](10)   NOT NULL DEFAULT('NORMAL'),
    [estado]                 [varchar](20)   NOT NULL DEFAULT('Activo'),
    [fecha_creacion]         [datetime]      NOT NULL DEFAULT(GETDATE()),
    [creado_por]             [varchar](50)   NOT NULL,
    [fecha_modificacion]     [datetime]      NULL,
    [modificado_por]         [varchar](50)   NULL,
    CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED ([usuario_id] ASC),
    CONSTRAINT [FK_Usuarios_TiposId] FOREIGN KEY ([tipo_identificacion_id])
        REFERENCES [dbo].[Tipos_identificacion]([tipo_identificacion_id])
) ON [PRIMARY]
GO

-- Cotizaciones
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cotizaciones](
    [cotizacion_id]        [int] IDENTITY(1,1) NOT NULL,
    [numero_cotizacion]    [varchar](20)   NOT NULL,
    [usuario_id]           [int]           NOT NULL,
    [producto_id]          [int]           NOT NULL,
    [plazo_id]             [int]           NOT NULL,
    [monto]                [decimal](18,2) NOT NULL,
    [tasa_anual]           [decimal](6,4)  NOT NULL,
    [impuesto]             [decimal](5,2)  NOT NULL,
    [total_interes_bruto]  [decimal](18,2) NULL,
    [total_impuesto]       [decimal](18,2) NULL,
    [total_interes_neto]   [decimal](18,2) NULL,
    [estado]               [varchar](20)   NOT NULL DEFAULT('Activo'),
    [fecha_creacion]       [datetime]      NOT NULL DEFAULT(GETDATE()),
    [creado_por]           [varchar](50)   NOT NULL,
    [fecha_modificacion]   [datetime]      NULL,
    [modificado_por]       [varchar](50)   NULL,
    CONSTRAINT [PK_Cotizaciones] PRIMARY KEY CLUSTERED ([cotizacion_id] ASC),
    CONSTRAINT [FK_Cotizaciones_Usuarios]  FOREIGN KEY ([usuario_id])  REFERENCES [dbo].[Usuarios]([usuario_id]),
    CONSTRAINT [FK_Cotizaciones_Productos] FOREIGN KEY ([producto_id]) REFERENCES [dbo].[Productos]([producto_id]),
    CONSTRAINT [FK_Cotizaciones_Plazos]    FOREIGN KEY ([plazo_id])    REFERENCES [dbo].[Plazos]([plazo_id])
) ON [PRIMARY]
GO

-- Cotizaciones_detalle
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cotizaciones_detalle](
    [detalle_id]         [int] IDENTITY(1,1) NOT NULL,
    [cotizacion_id]      [int]           NOT NULL,
    [mes]                [int]           NOT NULL,
    [interes_bruto]      [decimal](18,2) NOT NULL,
    [impuesto]           [decimal](18,2) NOT NULL,
    [interes_neto]       [decimal](18,2) NOT NULL,
    [estado]             [varchar](20)   NOT NULL DEFAULT('Activo'),
    [fecha_creacion]     [datetime]      NOT NULL DEFAULT(GETDATE()),
    [creado_por]         [varchar](50)   NOT NULL,
    [fecha_modificacion] [datetime]      NULL,
    [modificado_por]     [varchar](50)   NULL,
    CONSTRAINT [PK_Cotizaciones_detalle] PRIMARY KEY CLUSTERED ([detalle_id] ASC),
    CONSTRAINT [FK_Detalle_Cotizaciones] FOREIGN KEY ([cotizacion_id]) REFERENCES [dbo].[Cotizaciones]([cotizacion_id])
) ON [PRIMARY]
GO

-- ============================================================
--  3. DATOS SEMILLA
-- ============================================================

-- Tipos de identificacion
SET IDENTITY_INSERT [dbo].[Tipos_identificacion] ON
GO
INSERT INTO [dbo].[Tipos_identificacion]
    ([tipo_identificacion_id],[codigo],[nombre],[descripcion],[longitud_min],[longitud_max],[patron_regex],[solo_numerico],[estado],[fecha_creacion],[creado_por])
VALUES
    (1,'FISICA',   'Cedula Fisica',   'Documento nacional de persona fisica en Costa Rica', 9,  9,  '\d{9}',       1, 1, GETDATE(), 'Sistema'),
    (2,'JURIDICA', 'Cedula Juridica', 'Identificacion oficial de personas juridicas en CR', 10, 10, '[0-9]{10}',   1, 1, GETDATE(), 'Sistema'),
    (3,'DIMEX',    'DIMEX',           'Documento de Identidad Migratorio para Extranjeros', 11, 12, '[0-9]{11,12}',1, 1, GETDATE(), 'Sistema'),
    (4,'NITE',     'NITE',            'Numero de Identificacion Tributaria Especial',       10, 10, '[0-9]{10}',   1, 1, GETDATE(), 'Sistema'),
    (5,'PASAPORTE','Pasaporte',       'Documento internacional de viaje',                   6,  20, '[A-Za-z0-9]+',0, 1, GETDATE(), 'Sistema')
GO
SET IDENTITY_INSERT [dbo].[Tipos_identificacion] OFF
GO

-- Monedas
SET IDENTITY_INSERT [dbo].[Monedas] ON
GO
INSERT INTO [dbo].[Monedas] ([moneda_id],[codigo],[nombre],[simbolo],[estado],[fecha_creacion],[creado_por])
VALUES
    (1,'COL','Colon Costarricense',  'C',  'Activo', GETDATE(),'Sistema'),
    (2,'USD','Dolar Estadounidense', '$',  'Activo', GETDATE(),'Sistema'),
    (3,'MXN','Peso mexicano',        '$',  'Activo', GETDATE(),'Sistema'),
    (4,'EU ','Euro',                 '@',  'Activo', GETDATE(),'Sistema')
GO
SET IDENTITY_INSERT [dbo].[Monedas] OFF
GO

-- Parametros (solo ACTIVO el id=2)
SET IDENTITY_INSERT [dbo].[Parametros] ON
GO
INSERT INTO [dbo].[Parametros] ([parametro_id],[clave],[valor],[descripcion],[estado],[fecha_creacion],[creado_por])
VALUES
    (1,'IMPUESTO','15','Porcentaje de impuesto sobre intereses bancarios (%)','INACTIVO',GETDATE(),'Sistema'),
    (2,'IMPUESTO','25','CAPAA','ACTIVO',GETDATE(),'Sistema')
GO
SET IDENTITY_INSERT [dbo].[Parametros] OFF
GO

-- Productos
SET IDENTITY_INSERT [dbo].[Productos] ON
GO
INSERT INTO [dbo].[Productos] ([producto_id],[moneda_id],[codigo],[nombre],[estado],[fecha_creacion],[creado_por])
VALUES
    (1,2,'CC','Colon Aumento',  'Activo',GETDATE(),'Sistema'),
    (2,1,'CF','Colon Futuro Plus','Activo',GETDATE(),'Sistema'),
    (3,2,'DS','Dolar Seguro',   'Activo',GETDATE(),'Sistema'),
    (4,2,'DV','Dolar Vision',   'Activo',GETDATE(),'Sistema')
GO
SET IDENTITY_INSERT [dbo].[Productos] OFF
GO

-- Plazos (id 3..27, los mismos de V13 fuente)
SET IDENTITY_INSERT [dbo].[Plazos] ON
GO
INSERT INTO [dbo].[Plazos] ([plazo_id],[meses],[dias],[estado],[fecha_creacion],[creado_por])
VALUES
    (3,  2, 0,'Activo',  GETDATE(),'Sistema'),
    (4,  3, 0,'Activo',  GETDATE(),'Sistema'),
    (5,  4, 0,'Activo',  GETDATE(),'Sistema'),
    (6,  5, 0,'Activo',  GETDATE(),'Sistema'),
    (7,  6, 0,'Activo',  GETDATE(),'Sistema'),
    (8,  7, 0,'Activo',  GETDATE(),'Sistema'),
    (9,  8, 0,'Activo',  GETDATE(),'Sistema'),
    (10, 9, 0,'Activo',  GETDATE(),'Sistema'),
    (11,10, 0,'Activo',  GETDATE(),'Sistema'),
    (12,11, 0,'Activo',  GETDATE(),'Sistema'),
    (13,12, 0,'Activo',  GETDATE(),'Sistema'),
    (14,13, 0,'Activo',  GETDATE(),'Sistema'),
    (15,14, 0,'Activo',  GETDATE(),'Sistema'),
    (16,15, 0,'Activo',  GETDATE(),'Sistema'),
    (17,16, 0,'Activo',  GETDATE(),'Sistema'),
    (18,17, 0,'Activo',  GETDATE(),'Sistema'),
    (19,18, 0,'Activo',  GETDATE(),'Sistema'),
    (20,19, 0,'Activo',  GETDATE(),'Sistema'),
    (21,20, 0,'Activo',  GETDATE(),'Sistema'),
    (22,21, 0,'Activo',  GETDATE(),'Sistema'),
    (23,22, 0,'Activo',  GETDATE(),'Sistema'),
    (24,23, 0,'Activo',  GETDATE(),'Sistema'),
    (25,24, 0,'Activo',  GETDATE(),'Sistema'),
    (26, 1,15,'Inactivo',GETDATE(),'Sistema'),
    (27, 1, 5,'Activo',  GETDATE(),'Sistema')
GO
SET IDENTITY_INSERT [dbo].[Plazos] OFF
GO

-- Tasas (producto CF=2, DV=4, CC=1, DS=3)
SET IDENTITY_INSERT [dbo].[Tasas] ON
GO
-- Producto CF (id=2): plazos 6..24
INSERT INTO [dbo].[Tasas] ([tasa_id],[producto_id],[plazo_id],[tasa_anual],[estado],[fecha_creacion],[creado_por])
VALUES
    (6, 2, 6, 4.0000,'Activo',GETDATE(),'Sistema'),
    (7, 2, 7, 4.1500,'Activo',GETDATE(),'Sistema'),
    (8, 2, 8, 4.3500,'Activo',GETDATE(),'Sistema'),
    (9, 2, 9, 4.5000,'Activo',GETDATE(),'Sistema'),
    (10,2,10, 4.6500,'Activo',GETDATE(),'Sistema'),
    (11,2,11, 4.8000,'Activo',GETDATE(),'Sistema'),
    (12,2,12, 4.9500,'Activo',GETDATE(),'Sistema'),
    (13,2,13, 5.1000,'Activo',GETDATE(),'Sistema'),
    (14,2,14, 5.3000,'Activo',GETDATE(),'Sistema'),
    (15,2,15, 5.4000,'Activo',GETDATE(),'Sistema'),
    (16,2,16, 5.5000,'Activo',GETDATE(),'Sistema'),
    (17,2,17, 5.6000,'Activo',GETDATE(),'Sistema'),
    (18,2,18, 5.7000,'Activo',GETDATE(),'Sistema'),
    (19,2,19, 5.8000,'Activo',GETDATE(),'Sistema'),
    (20,2,20, 5.9500,'Activo',GETDATE(),'Sistema'),
    (21,2,21, 6.1000,'Activo',GETDATE(),'Sistema'),
    (22,2,22, 6.2500,'Activo',GETDATE(),'Sistema'),
    (23,2,23, 6.4000,'Activo',GETDATE(),'Sistema'),
    (24,2,24, 6.5500,'Activo',GETDATE(),'Sistema'),
    -- Producto DV (id=4): plazos 4..24
    (27,4, 4, 2.7500,'Activo',GETDATE(),'Sistema'),
    (28,4, 5, 2.9000,'Activo',GETDATE(),'Sistema'),
    (29,4, 6, 3.0500,'Activo',GETDATE(),'Sistema'),
    (30,4, 7, 3.2500,'Activo',GETDATE(),'Sistema'),
    (31,4, 8, 3.4000,'Activo',GETDATE(),'Sistema'),
    (32,4, 9, 3.5500,'Activo',GETDATE(),'Sistema'),
    (33,4,10, 3.7000,'Activo',GETDATE(),'Sistema'),
    (34,4,11, 3.8500,'Activo',GETDATE(),'Sistema'),
    (35,4,12, 4.0000,'Activo',GETDATE(),'Sistema'),
    (36,4,13, 4.2000,'Activo',GETDATE(),'Sistema'),
    (37,4,14, 4.3000,'Activo',GETDATE(),'Sistema'),
    (38,4,15, 4.4000,'Activo',GETDATE(),'Sistema'),
    (39,4,16, 4.5000,'Activo',GETDATE(),'Sistema'),
    (40,4,17, 4.6000,'Activo',GETDATE(),'Sistema'),
    (41,4,18, 4.7000,'Activo',GETDATE(),'Sistema'),
    (42,4,19, 4.8500,'Activo',GETDATE(),'Sistema'),
    (43,4,20, 5.0000,'Activo',GETDATE(),'Sistema'),
    (44,4,21, 5.1500,'Activo',GETDATE(),'Sistema'),
    (45,4,22, 5.3000,'Activo',GETDATE(),'Sistema'),
    (46,4,23, 5.4500,'Activo',GETDATE(),'Sistema'),
    (47,4,24, 5.6000,'Activo',GETDATE(),'Sistema'),
    -- Producto CC (id=1): plazos 3..24
    (48,1, 3, 4.0000,'Activo',GETDATE(),'Sistema'),
    (49,1, 4, 3.6000,'Activo',GETDATE(),'Sistema'),
    (50,1, 5, 3.7500,'Activo',GETDATE(),'Sistema'),
    (51,1, 6, 3.9000,'Activo',GETDATE(),'Sistema'),
    (52,1, 7,10.0000,'Activo',GETDATE(),'Sistema'),
    (53,1, 8, 4.2500,'Activo',GETDATE(),'Sistema'),
    (54,1, 9, 4.4000,'Activo',GETDATE(),'Sistema'),
    (55,1,10, 4.5500,'Activo',GETDATE(),'Sistema'),
    (56,1,11, 4.7000,'Activo',GETDATE(),'Sistema'),
    (57,1,12, 4.8500,'Activo',GETDATE(),'Sistema'),
    (58,1,13, 5.0000,'Activo',GETDATE(),'Sistema'),
    (59,1,14, 5.1000,'Activo',GETDATE(),'Sistema'),
    (60,1,15, 5.2000,'Activo',GETDATE(),'Sistema'),
    (61,1,16, 5.3000,'Activo',GETDATE(),'Sistema'),
    (62,1,17, 5.4000,'Activo',GETDATE(),'Sistema'),
    (63,1,18, 5.5000,'Activo',GETDATE(),'Sistema'),
    (64,1,19, 5.6500,'Activo',GETDATE(),'Sistema'),
    (65,1,20, 5.8000,'Activo',GETDATE(),'Sistema'),
    (66,1,21, 5.9500,'Activo',GETDATE(),'Sistema'),
    (67,1,22, 6.1000,'Activo',GETDATE(),'Sistema'),
    (68,1,23, 6.2500,'Activo',GETDATE(),'Sistema'),
    (69,1,24, 6.4000,'Activo',GETDATE(),'Sistema'),
    -- Producto DS (id=3): plazos 3..24
    (71,3, 3, 1.2500,'Activo',GETDATE(),'Sistema'),
    (72,3, 4, 1.5000,'Activo',GETDATE(),'Sistema'),
    (73,3, 5, 1.6500,'Activo',GETDATE(),'Sistema'),
    (74,3, 6, 1.8000,'Activo',GETDATE(),'Sistema'),
    (75,3, 7, 2.0000,'Activo',GETDATE(),'Sistema'),
    (76,3, 8, 2.1500,'Activo',GETDATE(),'Sistema'),
    (77,3, 9, 2.3000,'Activo',GETDATE(),'Sistema'),
    (78,3,10, 2.4500,'Activo',GETDATE(),'Sistema'),
    (79,3,11, 2.6000,'Activo',GETDATE(),'Sistema'),
    (80,3,12, 2.7500,'Activo',GETDATE(),'Sistema'),
    (81,3,13, 2.9000,'Activo',GETDATE(),'Sistema'),
    (82,3,14, 3.0000,'Activo',GETDATE(),'Sistema'),
    (83,3,15, 3.1000,'Activo',GETDATE(),'Sistema'),
    (84,3,16, 3.2000,'Activo',GETDATE(),'Sistema'),
    (85,3,17, 3.3000,'Activo',GETDATE(),'Sistema'),
    (86,3,18, 3.4000,'Activo',GETDATE(),'Sistema'),
    (87,3,19, 3.5500,'Activo',GETDATE(),'Sistema'),
    (88,3,20, 3.7000,'Activo',GETDATE(),'Sistema'),
    (89,3,21, 3.8500,'Activo',GETDATE(),'Sistema'),
    (90,3,22, 4.0000,'Activo',GETDATE(),'Sistema'),
    (91,3,23, 4.1500,'Activo',GETDATE(),'Sistema'),
    (92,3,24, 4.3000,'Activo',GETDATE(),'Sistema')
GO
SET IDENTITY_INSERT [dbo].[Tasas] OFF
GO

-- Usuarios (contrasenas hasheadas SHA-256)
-- admin@sistema.com / admin123  | pam@gmail.com / 12345
-- juana@gmail.com / pass123     | carlos@gmail.com / pass
-- karla@gmail.com / pass
SET IDENTITY_INSERT [dbo].[Usuarios] ON
GO
INSERT INTO [dbo].[Usuarios]
    ([usuario_id],[tipo_identificacion_id],[identificacion],[nombre_completo],[telefono],[correo],[contrasena],[rol],[estado],[fecha_creacion],[creado_por])
VALUES
    (4,1,'123456789', 'ADMINISTRADOR',      '85888888','admin@sistema.com','3eb3fe66b31e3b4d10fa70b5cad49c7112294af6ae4e476a1c405155d45aa121','ADMIN', 'Activo',GETDATE(),'Sistema'),
    (5,1,'604490050', 'HAZEL PAMELA GONZALEZ','88054751','pam@gmail.com',  '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5','NORMAL','Activo',GETDATE(),'Sistema'),
    (6,1,'704560456', 'JUANITA PEREZ',       '62854674','juana@gmail.com', '5e026d60d4f0f507116e10f3cd0e676f0b4687cc1320382360932957c3699f94','NORMAL','Activo',GETDATE(),'Sistema'),
    (7,3,'11256478932','CARLOS ARIAS',       '41111111','carlos@gmail.com','1a4fc95fa572bd535a12cec9db0377cad32666af15265ffb95de13e44bb7b099','NORMAL','Activo',GETDATE(),'Sistema'),
    (8,1,'116700608', 'KARLA BRENES',        '87213232','karla@gmail.com', '5f3ccb45b80c0114f234f672b7b4fba499ab973d66dded35b0efca59d48c7e2f','NORMAL','Activo',GETDATE(),'Sistema')
GO
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO

-- Cotizacion de ejemplo
SET IDENTITY_INSERT [dbo].[Cotizaciones] ON
GO
INSERT INTO [dbo].[Cotizaciones]
    ([cotizacion_id],[numero_cotizacion],[usuario_id],[producto_id],[plazo_id],[monto],[tasa_anual],[impuesto],
     [total_interes_bruto],[total_impuesto],[total_interes_neto],[estado],[fecha_creacion],[creado_por])
VALUES
    (1,'COT-0001',8,2,14,1000000.00,5.3000,25.00,57416.67,14354.17,43062.50,'Activo',GETDATE(),'admin')
GO
SET IDENTITY_INSERT [dbo].[Cotizaciones] OFF
GO

-- Detalle de cotizacion de ejemplo (13 meses)
SET IDENTITY_INSERT [dbo].[Cotizaciones_detalle] ON
GO
INSERT INTO [dbo].[Cotizaciones_detalle]
    ([detalle_id],[cotizacion_id],[mes],[interes_bruto],[impuesto],[interes_neto],[estado],[fecha_creacion],[creado_por])
VALUES
    (1, 1, 1, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (2, 1, 2, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (3, 1, 3, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (4, 1, 4, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (5, 1, 5, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (6, 1, 6, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (7, 1, 7, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (8, 1, 8, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (9, 1, 9, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (10,1,10, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (11,1,11, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (12,1,12, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin'),
    (13,1,13, 4416.67,1104.17,3312.50,'Activo',GETDATE(),'admin')
GO
SET IDENTITY_INSERT [dbo].[Cotizaciones_detalle] OFF
GO

-- ============================================================
--  4. STORED PROCEDURES
--     Cada SP lleva su propio USE + GO para garantizar contexto
-- ============================================================

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
    BEGIN SELECT 0 AS resultado, 'El impuesto no existe.' AS mensaje; RETURN; END
    UPDATE Parametros SET estado = 'INACTIVO';
    UPDATE Parametros SET estado = 'ACTIVO' WHERE parametro_id = @impuesto_id;
    SELECT 1 AS resultado, 'Impuesto activado correctamente.' AS mensaje;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ActualizarParametro]
    @parametro_id   INT,
    @clave          VARCHAR(50),
    @valor          VARCHAR(100),
    @descripcion    VARCHAR(200) = NULL,
    @estado         VARCHAR(20),
    @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Parametros WHERE parametro_id = @parametro_id)
    BEGIN SELECT 0 AS resultado, 'El parametro no existe.' AS mensaje; RETURN; END
    IF (@valor IS NULL OR LTRIM(RTRIM(@valor)) = '')
    BEGIN SELECT 0 AS resultado, 'El valor no puede estar vacio.' AS mensaje; RETURN; END
    IF @clave <> 'IMPUESTO' AND
       EXISTS (SELECT 1 FROM Parametros WHERE clave = @clave AND parametro_id <> @parametro_id)
    BEGIN SELECT 0 AS resultado, 'La clave ya esta registrada en otro parametro.' AS mensaje; RETURN; END
    UPDATE Parametros
    SET clave = @clave, valor = @valor, descripcion = @descripcion,
        estado = @estado, fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE parametro_id = @parametro_id;
    SELECT 1 AS resultado, 'Parametro actualizado correctamente.' AS mensaje;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_CambiarEstadoUsuario]
    @usuario_id INT, @estado VARCHAR(20), @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE usuario_id = @usuario_id)
    BEGIN SELECT 0 AS resultado, 'Usuario no encontrado.' AS mensaje; RETURN; END
    IF @estado NOT IN ('Activo','Inactivo','Bloqueado')
    BEGIN SELECT 0 AS resultado, 'Estado no valido.' AS mensaje; RETURN; END
    UPDATE Usuarios
    SET estado = @estado, fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE usuario_id = @usuario_id;
    SELECT 1 AS resultado, 'Estado actualizado correctamente.' AS mensaje;
END
GO

-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_CambiarRolUsuario]
    @usuario_id INT, @rol VARCHAR(10), @modificado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE usuario_id = @usuario_id)
    BEGIN SELECT 0 AS resultado, 'Usuario no encontrado.' AS mensaje; RETURN; END
    IF @rol NOT IN ('ADMIN','NORMAL')
    BEGIN SELECT 0 AS resultado, 'Rol invalido. Use ADMIN o NORMAL.' AS mensaje; RETURN; END
    UPDATE Usuarios
    SET rol = @rol, fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE usuario_id = @usuario_id;
    SELECT 1 AS resultado, 'Rol actualizado correctamente.' AS mensaje;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_EliminarParametro]
(
    @parametro_id   INT,
    @modificado_por VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Parametros WHERE parametro_id = @parametro_id)
    BEGIN SELECT 0 AS resultado, 'El parametro no existe.' AS mensaje; RETURN; END
    UPDATE Parametros
    SET estado = 'INACTIVO', fecha_modificacion = GETDATE(), modificado_por = @modificado_por
    WHERE parametro_id = @parametro_id;
    SELECT 1 AS resultado, 'Parametro eliminado correctamente.' AS mensaje;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ImpuestoActivo]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 parametro_id, clave, valor, descripcion, estado
    FROM Parametros WHERE estado = 'ACTIVO';
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarCotizaciones]
    @numero_cotizacion   VARCHAR(20),
    @usuario_id          INT,
    @producto_id         INT,
    @plazo_id            INT,
    @monto               DECIMAL(18,2),
    @tasa_anual          DECIMAL(6,4),
    @impuesto            DECIMAL(5,2),
    @total_interes_bruto DECIMAL(18,2),
    @total_impuesto      DECIMAL(18,2),
    @total_interes_neto  DECIMAL(18,2),
    @creado_por          VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Cotizaciones
    (
        numero_cotizacion, usuario_id, producto_id, plazo_id,
        monto, tasa_anual, impuesto,
        total_interes_bruto, total_impuesto, total_interes_neto,
        estado, fecha_creacion, creado_por
    )
    VALUES
    (
        @numero_cotizacion, @usuario_id, @producto_id, @plazo_id,
        @monto, @tasa_anual, @impuesto,
        @total_interes_bruto, @total_impuesto, @total_interes_neto,
        'Activo', GETDATE(), @creado_por
    );
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS cotizacion_id;
END
GO

-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_InsertarDetalleCotizacion]
    @cotizacion_id INT, @mes INT, @interes_bruto DECIMAL(18,2),
    @impuesto DECIMAL(18,2), @interes_neto DECIMAL(18,2), @creado_por VARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF; -- OFF para que ExecuteNonQuery retorne filas afectadas
    INSERT INTO Cotizaciones_detalle
        (cotizacion_id, mes, interes_bruto, impuesto, interes_neto, estado, fecha_creacion, creado_por)
    VALUES
        (@cotizacion_id, @mes, @interes_bruto, @impuesto, @interes_neto, 'Activo', GETDATE(), @creado_por);
END
GO

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
    IF @clave = 'IMPUESTO' AND @estado = 'ACTIVO'
    BEGIN
        UPDATE Parametros SET estado = 'INACTIVO' WHERE clave = 'IMPUESTO';
    END
    IF EXISTS (SELECT 1 FROM Parametros WHERE clave = @clave AND valor = @valor)
    BEGIN SELECT 0 AS resultado, 'Ya existe un parametro con ese valor.' AS mensaje; RETURN; END
    INSERT INTO Parametros (clave, valor, descripcion, estado, fecha_creacion, creado_por)
    VALUES (@clave, @valor, @descripcion, @estado, GETDATE(), @creado_por);
    SELECT 1 AS resultado, 'Parametro insertado correctamente.' AS mensaje;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarCotizaciones]
    @usuario_id INT = NULL,
    @moneda_id  INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.cotizacion_id,
           c.numero_cotizacion,
           u.nombre_completo AS cliente,
           p.nombre          AS producto,
           c.monto,
           c.total_interes_neto,
           c.fecha_creacion,
           m.simbolo         AS simbolo_moneda,
           m.moneda_id,
           m.nombre          AS nombre_moneda,
           CASE
               WHEN pl.meses > 0 AND pl.dias > 0 THEN
                   CAST(pl.meses AS VARCHAR) + ' meses y ' + CAST(pl.dias AS VARCHAR) + ' dias'
               WHEN pl.meses > 0 THEN
                   CAST(pl.meses AS VARCHAR) + ' meses'
               ELSE
                   CAST(pl.dias AS VARCHAR) + ' dias'
           END AS plazo
    FROM Cotizaciones c
    INNER JOIN Usuarios  u  ON c.usuario_id  = u.usuario_id
    INNER JOIN Productos p  ON c.producto_id = p.producto_id
    INNER JOIN Monedas   m  ON p.moneda_id   = m.moneda_id
    INNER JOIN Plazos    pl ON c.plazo_id    = pl.plazo_id
    WHERE c.estado <> 'Eliminado'
      AND (@usuario_id IS NULL OR c.usuario_id = @usuario_id)
      AND (@moneda_id  IS NULL OR m.moneda_id  = @moneda_id)
    ORDER BY c.fecha_creacion DESC;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarMonedas]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT moneda_id, codigo, nombre, simbolo, estado,
           fecha_creacion, creado_por, fecha_modificacion, modificado_por
    FROM Monedas WHERE estado = 'Activo' ORDER BY nombre;
END
GO

-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ListarParametros]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT parametro_id, clave, valor, descripcion, estado,
           fecha_creacion, creado_por, fecha_modificacion, modificado_por
    FROM Parametros;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerCotizacionPorId]
    @cotizacion_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        c.cotizacion_id,
        c.numero_cotizacion,
        c.producto_id,
        u.nombre_completo               AS cliente,
        u.telefono,
        u.correo,
        p.nombre                        AS producto,
        c.monto,
        c.tasa_anual,
        c.impuesto,
        c.total_interes_neto,
        CASE
            WHEN pl.meses > 0 AND pl.dias > 0 THEN
                CAST(pl.meses AS VARCHAR) + ' meses y ' + CAST(pl.dias AS VARCHAR) + ' dias'
            WHEN pl.meses > 0 THEN
                CAST(pl.meses AS VARCHAR) + ' meses'
            ELSE
                CAST(pl.dias AS VARCHAR) + ' dias'
        END AS plazo
    FROM Cotizaciones c
    INNER JOIN Usuarios  u  ON c.usuario_id  = u.usuario_id
    INNER JOIN Productos p  ON c.producto_id = p.producto_id
    INNER JOIN Plazos    pl ON c.plazo_id    = pl.plazo_id
    WHERE c.cotizacion_id = @cotizacion_id;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerMonedaPorProducto]
    @producto_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT m.simbolo
    FROM Productos p
    INNER JOIN Monedas m ON p.moneda_id = m.moneda_id
    WHERE p.producto_id = @producto_id;
END
GO

-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerMonedaPorProductoNombre]
    @producto_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT m.nombre, m.simbolo
    FROM Productos p
    INNER JOIN Monedas m ON p.moneda_id = m.moneda_id
    WHERE p.producto_id = @producto_id AND p.estado = 'Activo';
END
GO

-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerParametro]
    @clave VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Parametros WHERE clave = @clave AND estado = 'ACTIVO')
    BEGIN
        SELECT 0 AS resultado, 'Parametro no encontrado.' AS mensaje, NULL AS valor;
        RETURN;
    END
    SELECT 1 AS resultado, 'OK' AS mensaje, valor, descripcion
    FROM Parametros WHERE clave = @clave AND estado = 'ACTIVO';
END
GO

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
    SELECT parametro_id, clave, valor, descripcion, estado,
           fecha_creacion, creado_por, fecha_modificacion, modificado_por
    FROM Parametros WHERE parametro_id = @parametro_id;
END
GO

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
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerSiguienteNumeroCotizacion]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ultimoNumero INT;
    SELECT @ultimoNumero = MAX(
        CAST(SUBSTRING(numero_cotizacion, 5, LEN(numero_cotizacion)) AS INT)
    )
    FROM Cotizaciones
    WHERE numero_cotizacion LIKE 'COT-%'
      AND ISNUMERIC(SUBSTRING(numero_cotizacion, 5, LEN(numero_cotizacion))) = 1;
    IF @ultimoNumero IS NULL SET @ultimoNumero = 0;
    SET @ultimoNumero = @ultimoNumero + 1;
    SELECT 'COT-' + RIGHT('0000' + CAST(@ultimoNumero AS VARCHAR), 4) AS numero_cotizacion;
END
GO

-- ------------------------------------------------------------
USE [Apf_cotizaciones]
GO
CREATE PROCEDURE [dbo].[sp_ObtenerTablaFinanciera]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @columnas      NVARCHAR(MAX);
    DECLARE @columnasLabel NVARCHAR(MAX);
    DECLARE @sql           NVARCHAR(MAX);

    SELECT @columnas = STRING_AGG(QUOTENAME(pr.nombre), ',')
    FROM Productos pr WHERE pr.estado = 'Activo';

    SELECT @columnasLabel = STRING_AGG(
        QUOTENAME(pr.nombre) + ' AS ' + QUOTENAME(pr.nombre + ' (' + m.simbolo + ')'),
        ','
    )
    FROM Productos pr
    INNER JOIN Monedas m ON pr.moneda_id = m.moneda_id
    WHERE pr.estado = 'Activo';

    IF @columnas IS NULL BEGIN SELECT 'Sin productos activos' AS mensaje; RETURN; END

    SET @sql = N'
    SELECT Plazo, ' + @columnasLabel + N'
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

-- ============================================================
--  FIN DEL SCRIPT V13
-- ============================================================
PRINT 'Base de datos Apf_cotizaciones creada correctamente (V14).'
PRINT 'Tablas: 9 | Stored Procedures: 52 | Usuarios: 5'
GO
