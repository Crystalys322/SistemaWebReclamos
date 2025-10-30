-- ------------------------------------------------------------
-- Base de datos: sisreclamos_jvl
-- ------------------------------------------------------------

DROP DATABASE IF EXISTS sisreclamos_jvl;
CREATE DATABASE sisreclamos_jvl CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sisreclamos_jvl;

-- ------------------------------------------------------------
-- Tabla: roles
-- ------------------------------------------------------------

CREATE TABLE roles (
    idRol INT AUTO_INCREMENT PRIMARY KEY,
    nombreRol VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT INTO roles (nombreRol) VALUES
    ('ADMINISTRADOR'),
    ('USUARIO');

-- ------------------------------------------------------------
-- Tabla: usuarios
-- ------------------------------------------------------------

CREATE TABLE usuarios (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    idRol INT NOT NULL,
    ipAutorizada VARCHAR(45) DEFAULT NULL,
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    fechaRegistro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idRol) REFERENCES roles(idRol)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO usuarios (nombre, correo, password, idRol, ipAutorizada, estado) VALUES
    ('Administrador General', 'admin@sisreclamos.local', 'admin123', 1, NULL, 'ACTIVO'),
    ('Usuario Demo', 'usuario@sisreclamos.local', 'usuario123', 2, NULL, 'ACTIVO');

-- ------------------------------------------------------------
-- Tabla: categorias
-- ------------------------------------------------------------

CREATE TABLE categorias (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombreCategoria VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT INTO categorias (nombreCategoria) VALUES
    ('Servicios Generales'),
    ('Infraestructura'),
    ('Tecnología');

-- ------------------------------------------------------------
-- Tabla: reclamos
-- ------------------------------------------------------------

CREATE TABLE reclamos (
    idReclamo INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    idCategoria INT NOT NULL,
    descripcion TEXT NOT NULL,
    fechaRegistro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente','En atención','Resuelto') NOT NULL DEFAULT 'Pendiente',
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (idCategoria) REFERENCES categorias(idCategoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabla: seguimientos
-- ------------------------------------------------------------

CREATE TABLE seguimientos (
    idSeguimiento INT AUTO_INCREMENT PRIMARY KEY,
    idReclamo INT NOT NULL,
    idUsuario INT DEFAULT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observacion TEXT,
    nuevoEstado ENUM('Pendiente','En atención','Resuelto') NOT NULL,
    FOREIGN KEY (idReclamo) REFERENCES reclamos(idReclamo)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Vistas de apoyo para reportes
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_reclamos_por_estado AS
SELECT estado, COUNT(*) AS total
FROM reclamos
GROUP BY estado;

CREATE OR REPLACE VIEW vw_reclamos_por_categoria AS
SELECT c.nombreCategoria AS categoria, COUNT(*) AS total
FROM reclamos r
INNER JOIN categorias c ON r.idCategoria = c.idCategoria
GROUP BY c.nombreCategoria;

-- ------------------------------------------------------------
-- Datos de ejemplo para flujo completo
-- ------------------------------------------------------------

INSERT INTO reclamos (idUsuario, idCategoria, descripcion, estado)
VALUES
    (2, 1, 'Fuga de agua en el baño principal.', 'Pendiente'),
    (2, 2, 'Luz parpadeante en el pasillo.', 'En atención');

INSERT INTO seguimientos (idReclamo, idUsuario, observacion, nuevoEstado)
VALUES
    (2, 1, 'Electricista asignado, visita programada.', 'En atención');
