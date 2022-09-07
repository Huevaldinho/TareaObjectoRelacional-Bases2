CREATE DATABASE TareaObjetoRelacional;

--Tipos
CREATE TYPE Autor AS(--Listo
    nombre varchar (100),
    alias varchar(100)
);
CREATE TYPE Direccion AS(--Listo
    provincia varchar(30) ,
    canton varchar(30) ,
    distrito varchar(30) ,
    linkGoogleMaps varchar(250)
);
CREATE TYPE Persona AS(--Listo
    numeroCedula integer,
    nombre varchar(20),
    apellidos varchar(20) array[3],
    fechaNacimiento date,
    correos varchar(100) array[2],
    telefonos varchar(10) array[2]
);
--Suponiendo que la tienda física vende discos físicos.
CREATE TYPE Producto AS(--Listo
    cantidad int,
    precio integer,
    nombre varchar(30),
    autores Autor array[10],
    descripcion varchar(30) array[10],
    categorias varchar(30) array[5]
);
CREATE TYPE Proveedor AS(--Listo
    nombre varchar(30),
    direccion Direccion,
    productos Producto array[50]
);
--Tablas
CREATE TABLE Cliente(--Listo
    idCliente serial primary key,
    datosPersonales Persona not null
);
CREATE TABLE Empleado(--Listo
    idEmpleado serial primary key,
    datosPersonales Persona not null
);
CREATE TABLE Venta(--Listo
    idVenta serial primary key,
    idEmpleado int not null,
    idCliente int not null,
    costo money,
    productos Producto array[10],

    CONSTRAINT fk_idEmpleado FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado),
    CONSTRAINT fk_idCliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);
CREATE TABLE Productos(
    idProducto serial primary key, 
    producto Producto not null
);
CREATE TABLE Proveedores(
    idProveedor serial primary key,
    datosProveedor Proveedor
);