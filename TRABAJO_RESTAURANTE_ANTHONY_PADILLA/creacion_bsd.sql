CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    clave VARCHAR(200) NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('admin','mesonero','cajero'))
);

CREATE TABLE mesas (
    id SERIAL PRIMARY KEY,
    numero INT UNIQUE NOT NULL,
    estado VARCHAR(20) DEFAULT 'libre'
        CHECK (estado IN ('libre','ocupada','reservada'))
);

CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    categoria_id INT NOT NULL,
    stock INT DEFAULT 0,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE comandas (
    id SERIAL PRIMARY KEY,
    mesa_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha TIMESTAMP DEFAULT NOW(),
    estado VARCHAR(20) DEFAULT 'pendiente'
        CHECK (estado IN ('pendiente','en_proceso','servida','pagada','cancelada')),
    total NUMERIC(12,2) DEFAULT 0,
    FOREIGN KEY (mesa_id) REFERENCES mesas(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE detalle_comandas (
    id SERIAL PRIMARY KEY,
    comanda_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(12,2) GENERATED ALWAYS AS (cantidad * precio) STORED,
    FOREIGN KEY (comanda_id) REFERENCES comandas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE pagos (
    id SERIAL PRIMARY KEY,
    comanda_id INT NOT NULL,
    fecha TIMESTAMP DEFAULT NOW(),
    monto_total NUMERIC(12,2) NOT NULL,
    FOREIGN KEY (comanda_id) REFERENCES comandas(id)
);

CREATE TABLE detalle_pagos (
    id SERIAL PRIMARY KEY,
    pago_id INT NOT NULL,
    metodo VARCHAR(20) NOT NULL
        CHECK (metodo IN ('efectivo','punto','transferencia','divisa')),
    monto NUMERIC(12,2) NOT NULL,
    FOREIGN KEY (pago_id) REFERENCES pagos(id)
);