-- ══════════════════════════════════════════════════════════════
-- Corrección de patrones regex y longitudes en TiposIdentificacion
-- ══════════════════════════════════════════════════════════════

-- Cédula Física (CF): formato 0-0000-0000
-- Con guiones tiene 11 chars, sin guiones 9 dígitos
-- La regex de BD ya valida con guiones: ^\d{1,2}-\d{4}-\d{4}$
-- Corregir longitud para que cuente los guiones (11 chars con guiones)
UPDATE Tipos_identificacion
SET longitud_min  = 11,
    longitud_max  = 11,
    patron_regex  = '^\d{1}-\d{4}-\d{4}$'
WHERE codigo = 'CF';

-- Cédula Jurídica (CJ): formato 3-000-000000
-- DEBE iniciar con 3, con guiones = 12 chars, sin guiones = 10 dígitos
UPDATE Tipos_identificacion
SET longitud_min  = 12,
    longitud_max  = 12,
    patron_regex  = '^3-\d{3}-\d{6}$'
WHERE codigo = 'CJ';

-- DIMEX (DX): 11 o 12 dígitos numéricos (sin guiones)
UPDATE Tipos_identificacion
SET longitud_min  = 11,
    longitud_max  = 12,
    patron_regex  = '^\d{11,12}$'
WHERE codigo = 'DX';

-- Pasaporte (PA): letras y números, 6-20 caracteres
UPDATE Tipos_identificacion
SET longitud_min  = 6,
    longitud_max  = 20,
    patron_regex  = '^[A-Z0-9]{6,20}$'
WHERE codigo = 'PA';

-- Verificar resultado
SELECT tipo_identificacion_id, codigo, nombre,
       longitud_min, longitud_max, patron_regex
FROM Tipos_identificacion
ORDER BY tipo_identificacion_id;