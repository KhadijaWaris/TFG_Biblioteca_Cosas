-- ============================================================
-- BIBLIOTECA DE LAS COSAS - UAB
-- Base de datos relacional - Oracle SQL Developer
-- ============================================================



-- Tipos de usuario según perfil y prioridad de acceso
CREATE TABLE tipo_usuario (
    id_tipo         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(100)   NOT NULL,
    descripcion     VARCHAR2(255),
    prioridad       NUMBER(2)       NOT NULL, -- 1=mayor prioridad
    requiere_membresia  CHAR(1)     DEFAULT 'S' CHECK (requiere_membresia IN ('S','N')),
    CONSTRAINT uq_tipo_nombre UNIQUE (nombre)
);

-- Valores de tipo_usuario
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Comunidad UAB - Estudiante', 'Estudiantes matriculados en la UAB', 1, 'S');
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Comunidad UAB - PDI', 'Personal Docente e Investigador de la UAB', 1, 'S');
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Comunidad UAB - PAS', 'Personal de Administración y Servicios de la UAB', 1, 'S');
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Organización sin ánimo de lucro', 'Entidades sin fines lucrativos', 2, 'S');
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Empresa pequeña', 'PYMEs y micropymes', 3, 'S');
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Comunidad entorno - Bellaterra', 'Residentes en Bellaterra', 4, 'S');
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Comunidad entorno - Sabadell', 'Residentes en Sabadell', 4, 'S');
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Público general', 'Resto de usuarios sin adscripción específica', 5, 'S');
INSERT INTO tipo_usuario (nombre, descripcion, prioridad, requiere_membresia)
VALUES ('Borsa (sin membresía)', 'Acceso únicamente al servicio de donación Borsa', 5, 'N');

-- Tipos de documento de identificación
CREATE TABLE tipo_documento_id (
    id_tipo_doc     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(80)    NOT NULL,
    descripcion     VARCHAR2(200),
    CONSTRAINT uq_tipo_doc UNIQUE (nombre)
);

INSERT INTO tipo_documento_id (nombre, descripcion) VALUES ('Tarjeta universitaria UAB', 'Identificación exclusiva comunidad UAB');
INSERT INTO tipo_documento_id (nombre, descripcion) VALUES ('DNI', 'Documento Nacional de Identidad');
INSERT INTO tipo_documento_id (nombre, descripcion) VALUES ('Pasaporte', 'Pasaporte internacional');
INSERT INTO tipo_documento_id (nombre, descripcion) VALUES ('NIF empresa', 'Número de Identificación Fiscal de empresa');
INSERT INTO tipo_documento_id (nombre, descripcion) VALUES ('Carné de conducir', 'Permiso de conducción como documento de identidad');

-- Categorías de objetos
CREATE TABLE categoria_objeto (
    id_categoria    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(100)   NOT NULL,
    descripcion     VARCHAR2(255),
    CONSTRAINT uq_cat_nombre UNIQUE (nombre)
);

-- Estados posibles de un objeto en el sistema
CREATE TABLE estado_objeto (
    id_estado       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(80)    NOT NULL,
    descripcion     VARCHAR2(255),
    disponible_prestamo CHAR(1)     DEFAULT 'N' CHECK (disponible_prestamo IN ('S','N')),
    CONSTRAINT uq_estado_nombre UNIQUE (nombre)
);

INSERT INTO estado_objeto (nombre, descripcion, disponible_prestamo)
VALUES ('Disponible', 'Artículo en buen estado, listo para préstamo', 'S');
INSERT INTO estado_objeto (nombre, descripcion, disponible_prestamo)
VALUES ('En préstamo', 'Artículo actualmente prestado a un usuario', 'N');
INSERT INTO estado_objeto (nombre, descripcion, disponible_prestamo)
VALUES ('En revisión', 'Artículo pendiente de evaluación por el personal', 'N');
INSERT INTO estado_objeto (nombre, descripcion, disponible_prestamo)
VALUES ('En reparación', 'Artículo en proceso de reparación', 'N');
INSERT INTO estado_objeto (nombre, descripcion, disponible_prestamo)
VALUES ('Retirado', 'Artículo retirado del inventario (irreparable)', 'N');
INSERT INTO estado_objeto (nombre, descripcion, disponible_prestamo)
VALUES ('Reciclado', 'Artículo derivado a reciclaje tras no poder ser reparado', 'N');
INSERT INTO estado_objeto (nombre, descripcion, disponible_prestamo)
VALUES ('Borsa - disponible', 'Artículo en el servicio de donación Borsa', 'N');
INSERT INTO estado_objeto (nombre, descripcion, disponible_prestamo)
VALUES ('Borsa - donado', 'Artículo ya donado a través del servicio Borsa', 'N');

-- Origen de los objetos
CREATE TABLE origen_objeto (
    id_origen       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(100)   NOT NULL,
    descripcion     VARCHAR2(255)
);

INSERT INTO origen_objeto (nombre, descripcion) VALUES ('Donación UAB - Punto Limpio CircuLab', 'Material donado por la propia UAB a través del CircuLab');
INSERT INTO origen_objeto (nombre, descripcion) VALUES ('Donación comunidad', 'Material aportado por la comunidad del entorno cercano');
INSERT INTO origen_objeto (nombre, descripcion) VALUES ('Adquisición propia', 'Material adquirido directamente por la Biblioteca de las Cosas');

-- Estados del préstamo
CREATE TABLE estado_prestamo (
    id_estado_p     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(80)    NOT NULL,
    descripcion     VARCHAR2(255),
    CONSTRAINT uq_estado_prestamo UNIQUE (nombre)
);

INSERT INTO estado_prestamo (nombre, descripcion) VALUES ('Activo', 'Préstamo en curso, artículo en poder del usuario');
INSERT INTO estado_prestamo (nombre, descripcion) VALUES ('Devuelto', 'Artículo devuelto correctamente y en revisión');
INSERT INTO estado_prestamo (nombre, descripcion) VALUES ('Devuelto con incidencia', 'Artículo devuelto con daños o problemas registrados');
INSERT INTO estado_prestamo (nombre, descripcion) VALUES ('Retrasado', 'Préstamo superado el plazo acordado sin devolución');
INSERT INTO estado_prestamo (nombre, descripcion) VALUES ('Cancelado', 'Préstamo cancelado antes de la recogida del artículo');

-- ============================================================
-- ENTIDADES PRINCIPALES
-- ============================================================

-- Tabla de usuarios
CREATE TABLE usuario (
    id_usuario          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre              VARCHAR2(100)   NOT NULL,
    apellidos           VARCHAR2(150)   NOT NULL,
    email               VARCHAR2(150)   UNIQUE NOT NULL,
    telefono            VARCHAR2(20),
    id_tipo_usuario     NUMBER          NOT NULL,
    id_tipo_doc         NUMBER          NOT NULL,
    num_documento       VARCHAR2(50)    NOT NULL,
    fecha_registro      DATE            DEFAULT SYSDATE NOT NULL,
    activo              CHAR(1)         DEFAULT 'S' CHECK (activo IN ('S','N')),
    observaciones       VARCHAR2(500),
    CONSTRAINT fk_usuario_tipo    FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario(id_tipo),
    CONSTRAINT fk_usuario_doc     FOREIGN KEY (id_tipo_doc)     REFERENCES tipo_documento_id(id_tipo_doc),
    CONSTRAINT uq_usuario_doc     UNIQUE (id_tipo_doc, num_documento)
);

-- Tabla de membresías
CREATE TABLE membresia (
    id_membresia        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario          NUMBER          NOT NULL,
    fecha_inicio        DATE            NOT NULL,
    fecha_fin           DATE            NOT NULL,
    activa              CHAR(1)         DEFAULT 'S' CHECK (activa IN ('S','N')),
    cuota_pagada        NUMBER(8,2)     DEFAULT 0,
    fecha_pago          DATE,
    observaciones       VARCHAR2(300),
    CONSTRAINT fk_membresia_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT ck_mem_fechas        CHECK (fecha_fin > fecha_inicio),
    CONSTRAINT ck_mem_cuota         CHECK (cuota_pagada >= 0)
);

-- Tabla de objetos del catálogo
CREATE TABLE objeto (
    id_objeto           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre              VARCHAR2(150)   NOT NULL,
    descripcion         VARCHAR2(500),
    id_categoria        NUMBER          NOT NULL,
    id_origen           NUMBER          NOT NULL,
    id_estado_actual    NUMBER          NOT NULL,
    fecha_ingreso       DATE            DEFAULT SYSDATE NOT NULL,
    ubicacion           VARCHAR2(200),           -- referencia a plataforma Circulab
    codigo_circulab     VARCHAR2(100),           -- identificador en Circulab
    num_serie           VARCHAR2(100),
    marca               VARCHAR2(100),
    modelo              VARCHAR2(100),
    anyo_fabricacion    NUMBER(4),
    valor_estimado      NUMBER(8,2),
    max_dias_prestamo   NUMBER(3)       DEFAULT 7,
    activo              CHAR(1)         DEFAULT 'S' CHECK (activo IN ('S','N')),
    observaciones       VARCHAR2(500),
    CONSTRAINT fk_objeto_categoria  FOREIGN KEY (id_categoria)     REFERENCES categoria_objeto(id_categoria),
    CONSTRAINT fk_objeto_origen     FOREIGN KEY (id_origen)        REFERENCES origen_objeto(id_origen),
    CONSTRAINT fk_objeto_estado     FOREIGN KEY (id_estado_actual) REFERENCES estado_objeto(id_estado),
    CONSTRAINT ck_objeto_valor      CHECK (valor_estimado >= 0),
    CONSTRAINT ck_objeto_dias       CHECK (max_dias_prestamo > 0)
);

-- Tabla de préstamos
CREATE TABLE prestamo (
    id_prestamo         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario          NUMBER          NOT NULL,
    id_objeto           NUMBER          NOT NULL,
    id_estado_prestamo  NUMBER          NOT NULL,
    fecha_solicitud     DATE            DEFAULT SYSDATE NOT NULL,
    fecha_prevista_dev  DATE            NOT NULL,
    fecha_devolucion    DATE,                    -- NULL si todavía no devuelto
    id_personal_entrega NUMBER,                  -- personal que gestionó la entrega
    id_personal_recogida NUMBER,                 -- personal que gestionó la devolución
    observaciones_salida    VARCHAR2(500),       -- estado del objeto al salir
    observaciones_entrada   VARCHAR2(500),       -- estado del objeto al volver
    incidencia          CHAR(1)         DEFAULT 'N' CHECK (incidencia IN ('S','N')),
    CONSTRAINT fk_prestamo_usuario  FOREIGN KEY (id_usuario)         REFERENCES usuario(id_usuario),
    CONSTRAINT fk_prestamo_objeto   FOREIGN KEY (id_objeto)          REFERENCES objeto(id_objeto),
    CONSTRAINT fk_prestamo_estado   FOREIGN KEY (id_estado_prestamo) REFERENCES estado_prestamo(id_estado_p),
    CONSTRAINT ck_prestamo_fechas   CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_solicitud)
);

-- Historial de estados de cada objeto (trazabilidad completa)
CREATE TABLE historial_estado_objeto (
    id_historial        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_objeto           NUMBER          NOT NULL,
    id_estado_anterior  NUMBER,
    id_estado_nuevo     NUMBER          NOT NULL,
    fecha_cambio        DATE            DEFAULT SYSDATE NOT NULL,
    id_prestamo_asociado NUMBER,                 -- si el cambio está relacionado con un préstamo
    motivo              VARCHAR2(300),
    registrado_por      VARCHAR2(100),           -- nombre del personal que hizo el cambio
    CONSTRAINT fk_hist_objeto   FOREIGN KEY (id_objeto)          REFERENCES objeto(id_objeto),
    CONSTRAINT fk_hist_est_ant  FOREIGN KEY (id_estado_anterior) REFERENCES estado_objeto(id_estado),
    CONSTRAINT fk_hist_est_nvo  FOREIGN KEY (id_estado_nuevo)    REFERENCES estado_objeto(id_estado),
    CONSTRAINT fk_hist_prestamo FOREIGN KEY (id_prestamo_asociado) REFERENCES prestamo(id_prestamo)
);

-- Tabla de incidencias / reparaciones
CREATE TABLE incidencia_reparacion (
    id_incidencia       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_objeto           NUMBER          NOT NULL,
    id_prestamo         NUMBER,                  -- NULL si la incidencia no viene de un préstamo
    fecha_deteccion     DATE            DEFAULT SYSDATE NOT NULL,
    descripcion_dano    VARCHAR2(500)   NOT NULL,
    derivado_reparacion CHAR(1)         DEFAULT 'S' CHECK (derivado_reparacion IN ('S','N')),
    fecha_reparacion    DATE,
    resultado_reparacion VARCHAR2(300),
    reparado_ok         CHAR(1)         CHECK (reparado_ok IN ('S','N')),
    derivado_reciclaje  CHAR(1)         DEFAULT 'N' CHECK (derivado_reciclaje IN ('S','N')),
    registrado_por      VARCHAR2(100),
    CONSTRAINT fk_incid_objeto   FOREIGN KEY (id_objeto)   REFERENCES objeto(id_objeto),
    CONSTRAINT fk_incid_prestamo FOREIGN KEY (id_prestamo) REFERENCES prestamo(id_prestamo)
);

-- ============================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ============================================================

CREATE INDEX idx_objeto_estado     ON objeto(id_estado_actual);
CREATE INDEX idx_objeto_categoria  ON objeto(id_categoria);
CREATE INDEX idx_prestamo_usuario  ON prestamo(id_usuario);
CREATE INDEX idx_prestamo_objeto   ON prestamo(id_objeto);
CREATE INDEX idx_prestamo_estado   ON prestamo(id_estado_prestamo);
CREATE INDEX idx_prestamo_fechas   ON prestamo(fecha_prevista_dev);
CREATE INDEX idx_membresia_usuario ON membresia(id_usuario);
CREATE INDEX idx_hist_objeto       ON historial_estado_objeto(id_objeto);
CREATE INDEX idx_hist_fecha        ON historial_estado_objeto(fecha_cambio);

COMMIT;

-- ============================================================
-- CONSULTAS OPERATIVAS PRINCIPALES
-- ============================================================

-- 1. Inventario actual: objetos disponibles para préstamo
SELECT
    o.id_objeto,
    o.nombre,
    o.marca,
    o.modelo,
    c.nombre        AS categoria,
    o.ubicacion,
    o.codigo_circulab,
    o.max_dias_prestamo
FROM objeto o
JOIN categoria_objeto c ON o.id_categoria = c.id_categoria
JOIN estado_objeto    e ON o.id_estado_actual = e.id_estado
WHERE e.disponible_prestamo = 'S'
  AND o.activo = 'S'
ORDER BY c.nombre, o.nombre;

-- 2. Préstamos activos con riesgo de retraso (vencen en los próximos 2 días)
SELECT
    p.id_prestamo,
    u.nombre || ' ' || u.apellidos  AS usuario,
    u.email,
    u.telefono,
    o.nombre                        AS objeto,
    p.fecha_solicitud,
    p.fecha_prevista_dev,
    TRUNC(p.fecha_prevista_dev) - TRUNC(SYSDATE) AS dias_restantes
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN objeto  o ON p.id_objeto  = o.id_objeto
JOIN estado_prestamo ep ON p.id_estado_prestamo = ep.id_estado_p
WHERE ep.nombre = 'Activo'
  AND p.fecha_prevista_dev <= SYSDATE + 2
ORDER BY p.fecha_prevista_dev;

-- 3. Préstamos vencidos (retrasados)
SELECT
    p.id_prestamo,
    u.nombre || ' ' || u.apellidos  AS usuario,
    u.email,
    o.nombre                        AS objeto,
    p.fecha_prevista_dev,
    TRUNC(SYSDATE) - TRUNC(p.fecha_prevista_dev) AS dias_retraso
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN objeto  o ON p.id_objeto  = o.id_objeto
JOIN estado_prestamo ep ON p.id_estado_prestamo = ep.id_estado_p
WHERE ep.nombre = 'Activo'
  AND p.fecha_prevista_dev < SYSDATE
ORDER BY dias_retraso DESC;

-- 4. Historial completo de un objeto específico
SELECT
    h.fecha_cambio,
    ea.nombre   AS estado_anterior,
    en.nombre   AS estado_nuevo,
    h.motivo,
    h.registrado_por,
    h.id_prestamo_asociado
FROM historial_estado_objeto h
LEFT JOIN estado_objeto ea ON h.id_estado_anterior = ea.id_estado
JOIN      estado_objeto en ON h.id_estado_nuevo     = en.id_estado
WHERE h.id_objeto = :id_objeto  -- reemplazar con el ID concreto
ORDER BY h.fecha_cambio DESC;

-- 5. Estadísticas de préstamos por categoría (último año)
SELECT
    c.nombre            AS categoria,
    COUNT(p.id_prestamo) AS total_prestamos,
    COUNT(DISTINCT o.id_objeto) AS objetos_distintos,
    ROUND(AVG(
        NVL(p.fecha_devolucion, SYSDATE) - p.fecha_solicitud
    ), 1)               AS duracion_media_dias
FROM prestamo p
JOIN objeto           o ON p.id_objeto    = o.id_objeto
JOIN categoria_objeto c ON o.id_categoria = c.id_categoria
WHERE p.fecha_solicitud >= ADD_MONTHS(SYSDATE, -12)
GROUP BY c.nombre
ORDER BY total_prestamos DESC;

-- 6. Usuarios con membresía activa y número de préstamos en curso
SELECT
    u.id_usuario,
    u.nombre || ' ' || u.apellidos     AS usuario,
    t.nombre                            AS tipo_usuario,
    m.fecha_fin                         AS fin_membresia,
    COUNT(p.id_prestamo)                AS prestamos_activos
FROM usuario u
JOIN tipo_usuario    t  ON u.id_tipo_usuario   = t.id_tipo
JOIN membresia       m  ON u.id_usuario         = m.id_usuario
LEFT JOIN prestamo   p  ON u.id_usuario         = p.id_usuario
                       AND p.id_estado_prestamo IN (
                               SELECT id_estado_p FROM estado_prestamo WHERE nombre = 'Activo'
                           )
WHERE m.activa = 'S'
  AND m.fecha_fin >= SYSDATE
GROUP BY u.id_usuario, u.nombre, u.apellidos, t.nombre, m.fecha_fin
ORDER BY u.apellidos, u.nombre;

-- 7. Objetos en reparación o revisión (seguimiento de mantenimiento)
SELECT
    o.id_objeto,
    o.nombre,
    c.nombre        AS categoria,
    e.nombre        AS estado_actual,
    ir.fecha_deteccion,
    ir.descripcion_dano,
    ir.reparado_ok,
    ir.derivado_reciclaje
FROM objeto o
JOIN categoria_objeto       c  ON o.id_categoria     = c.id_categoria
JOIN estado_objeto           e  ON o.id_estado_actual  = e.id_estado
LEFT JOIN incidencia_reparacion ir ON o.id_objeto      = ir.id_objeto
WHERE e.nombre IN ('En revisión','En reparación')
ORDER BY ir.fecha_deteccion;

-- 8. Verificación rápida de elegibilidad de usuario para préstamo
-- (membresía vigente y sin préstamos vencidos)
SELECT
    u.nombre || ' ' || u.apellidos AS usuario,
    CASE
        WHEN m.id_membresia IS NULL THEN 'SIN MEMBRESÍA ACTIVA'
        WHEN EXISTS (
            SELECT 1 FROM prestamo p2
            JOIN estado_prestamo ep2 ON p2.id_estado_prestamo = ep2.id_estado_p
            WHERE p2.id_usuario = u.id_usuario
              AND ep2.nombre    = 'Retrasado'
        ) THEN 'BLOQUEADO - PRÉSTAMO VENCIDO'
        ELSE 'APTO PARA PRÉSTAMO'
    END AS estado_acceso
FROM usuario u
LEFT JOIN membresia m ON u.id_usuario = m.id_usuario
                     AND m.activa     = 'S'
                     AND m.fecha_fin >= SYSDATE
WHERE u.id_usuario = :id_usuario;  -- reemplazar con el ID concreto
