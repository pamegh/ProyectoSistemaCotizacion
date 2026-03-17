INSERT INTO Productos (codigo, nombre, moneda, estado, fecha_creacion, creado_por)
VALUES
('CC', 'Colón Crece', 'C', 'Activo', GETDATE(), 'admin'),
('CF', 'Colón Futuro Plus', 'C', 'Activo', GETDATE(), 'admin'),
('DS', 'Dólar Seguro', 'D', 'Activo', GETDATE(), 'admin'),
('DV', 'Dólar Visión', 'D', 'Activo', GETDATE(), 'admin');

--Insertar valores de Plazos
INSERT INTO Plazos (meses, dias, estado, fecha_creacion, creado_por)
VALUES
(0, 15, 'Activo', GETDATE(), 'admin'), -- 15 días
(1, 0, 'Activo', GETDATE(), 'admin'),
(2, 0, 'Activo', GETDATE(), 'admin'),
(3, 0, 'Activo', GETDATE(), 'admin'),
(4, 0, 'Activo', GETDATE(), 'admin'),
(5, 0, 'Activo', GETDATE(), 'admin'),
(6, 0, 'Activo', GETDATE(), 'admin'),
(7, 0, 'Activo', GETDATE(), 'admin'),
(8, 0, 'Activo', GETDATE(), 'admin'),
(9, 0, 'Activo', GETDATE(), 'admin'),
(10, 0, 'Activo', GETDATE(), 'admin'),
(11, 0, 'Activo', GETDATE(), 'admin'),
(12, 0, 'Activo', GETDATE(), 'admin'),
(13, 0, 'Activo', GETDATE(), 'admin'),
(14, 0, 'Activo', GETDATE(), 'admin'),
(15, 0, 'Activo', GETDATE(), 'admin'),
(16, 0, 'Activo', GETDATE(), 'admin'),
(17, 0, 'Activo', GETDATE(), 'admin'),
(18, 0, 'Activo', GETDATE(), 'admin'),
(19, 0, 'Activo', GETDATE(), 'admin'),
(20, 0, 'Activo', GETDATE(), 'admin'),
(21, 0, 'Activo', GETDATE(), 'admin'),
(22, 0, 'Activo', GETDATE(), 'admin'),
(23, 0, 'Activo', GETDATE(), 'admin'),
(24, 0, 'Activo', GETDATE(), 'admin');

/* ============================================================
   INSERT TASAS - SISTEMA DE COTIZADOR
   Productos:
   1 = CC (Colón Crece)
   2 = CF (Colón Futuro Plus)
   3 = DS (Dólar Seguro)
   4 = DV (Dólar Visión)
   ============================================================ */
   

/* =========================
   15 DÍAS (plazo_id = 1)
   Solo aplica para CC
   ========================= */
   Select * from Productos;
INSERT INTO Tasas VALUES
(1,1,3.1500,'Activo',GETDATE(),'admin',NULL,NULL);


/* =========================
   1 MES (plazo_id = 2)
   Aplica para CC y DS
   ========================= */
INSERT INTO Tasas VALUES
(1,2,3.2500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,2,1.0000,'Activo',GETDATE(),'admin',NULL,NULL);


/* =========================
   2 MESES (plazo_id = 3)
   Aplica para CC y DS
   ========================= */
INSERT INTO Tasas VALUES
(1,3,3.4000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,3,1.2500,'Activo',GETDATE(),'admin',NULL,NULL);


/* =========================
   3 MESES (plazo_id = 4)
   Aplica para TODOS los productos
   ========================= */
INSERT INTO Tasas VALUES
(1,4,3.6000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,4,3.8500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,4,1.5000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,4,2.7500,'Activo',GETDATE(),'admin',NULL,NULL);


/* ============================================================
   4 A 24 MESES (plazo_id 5 al 25)
   Todos los productos tienen tasa
   ============================================================ */
INSERT INTO Tasas VALUES

-- 4 meses (plazo_id = 5)
(1,5,3.7500,'Activo',GETDATE(),'admin',NULL,NULL),
(2,5,4.0000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,5,1.6500,'Activo',GETDATE(),'admin',NULL,NULL),
(4,5,2.9000,'Activo',GETDATE(),'admin',NULL,NULL),

-- 5 meses (plazo_id = 6)
(1,6,3.9000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,6,4.1500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,6,1.8000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,6,3.0500,'Activo',GETDATE(),'admin',NULL,NULL),

-- 6 meses (plazo_id = 7)
(1,7,4.1000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,7,4.3500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,7,2.0000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,7,3.2500,'Activo',GETDATE(),'admin',NULL,NULL),

-- 7 meses (plazo_id = 8)
(1,8,4.2500,'Activo',GETDATE(),'admin',NULL,NULL),
(2,8,4.5000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,8,2.1500,'Activo',GETDATE(),'admin',NULL,NULL),
(4,8,3.4000,'Activo',GETDATE(),'admin',NULL,NULL),

-- 8 meses (plazo_id = 9)
(1,9,4.4000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,9,4.6500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,9,2.3000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,9,3.5500,'Activo',GETDATE(),'admin',NULL,NULL),

-- 9 meses (plazo_id = 10)
(1,10,4.5500,'Activo',GETDATE(),'admin',NULL,NULL),
(2,10,4.8000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,10,2.4500,'Activo',GETDATE(),'admin',NULL,NULL),
(4,10,3.7000,'Activo',GETDATE(),'admin',NULL,NULL),

-- 10 meses (plazo_id = 11)
(1,11,4.7000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,11,4.9500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,11,2.6000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,11,3.8500,'Activo',GETDATE(),'admin',NULL,NULL),

-- 11 meses (plazo_id = 12)
(1,12,4.8500,'Activo',GETDATE(),'admin',NULL,NULL),
(2,12,5.1000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,12,2.7500,'Activo',GETDATE(),'admin',NULL,NULL),
(4,12,4.0000,'Activo',GETDATE(),'admin',NULL,NULL),

-- 12 meses (plazo_id = 13)
(1,13,5.0000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,13,5.3000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,13,2.9000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,13,4.2000,'Activo',GETDATE(),'admin',NULL,NULL),

-- 13 a 24 meses continúan mismo patrón hasta plazo_id = 25
(1,14,5.1000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,14,5.4000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,14,3.0000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,14,4.3000,'Activo',GETDATE(),'admin',NULL,NULL),

(1,15,5.2000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,15,5.5000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,15,3.1000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,15,4.4000,'Activo',GETDATE(),'admin',NULL,NULL),

(1,16,5.3000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,16,5.6000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,16,3.2000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,16,4.5000,'Activo',GETDATE(),'admin',NULL,NULL),

(1,17,5.4000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,17,5.7000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,17,3.3000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,17,4.6000,'Activo',GETDATE(),'admin',NULL,NULL),

(1,18,5.5000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,18,5.8000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,18,3.4000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,18,4.7000,'Activo',GETDATE(),'admin',NULL,NULL),

(1,19,5.6500,'Activo',GETDATE(),'admin',NULL,NULL),
(2,19,5.9500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,19,3.5500,'Activo',GETDATE(),'admin',NULL,NULL),
(4,19,4.8500,'Activo',GETDATE(),'admin',NULL,NULL),

(1,20,5.8000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,20,6.1000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,20,3.7000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,20,5.0000,'Activo',GETDATE(),'admin',NULL,NULL),

(1,21,5.9500,'Activo',GETDATE(),'admin',NULL,NULL),
(2,21,6.2500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,21,3.8500,'Activo',GETDATE(),'admin',NULL,NULL),
(4,21,5.1500,'Activo',GETDATE(),'admin',NULL,NULL),

(1,22,6.1000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,22,6.4000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,22,4.0000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,22,5.3000,'Activo',GETDATE(),'admin',NULL,NULL),

(1,23,6.2500,'Activo',GETDATE(),'admin',NULL,NULL),
(2,23,6.5500,'Activo',GETDATE(),'admin',NULL,NULL),
(3,23,4.1500,'Activo',GETDATE(),'admin',NULL,NULL),
(4,23,5.4500,'Activo',GETDATE(),'admin',NULL,NULL),

(1,24,6.4000,'Activo',GETDATE(),'admin',NULL,NULL),
(2,24,6.7000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,24,4.3000,'Activo',GETDATE(),'admin',NULL,NULL),
(4,24,5.6000,'Activo',GETDATE(),'admin',NULL,NULL),

(1,25,6.5500,'Activo',GETDATE(),'admin',NULL,NULL),
(2,25,6.9000,'Activo',GETDATE(),'admin',NULL,NULL),
(3,25,4.4500,'Activo',GETDATE(),'admin',NULL,NULL),
(4,25,6.8500,'Activo',GETDATE(),'admin',NULL,NULL);

Select * from Plazos;
Select * from Tasas
Select * from Productos

Delete from Productos;

DBCC CHECKIDENT ('Productos', RESEED, 0);
