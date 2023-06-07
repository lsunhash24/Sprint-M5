/* Sprint Módulo 5
     Integrantes: Valentina Urrutia M
			      Patricio Foitzick
			      Luis Sanhueza

* Se crea base de datos local de nombre “telovendo”.*/
CREATE DATABASE telovendo;

/* Se crea usuario con permisos totales sobre la base de datos anteriormente creada.*/
CREATE USER admintienda WITH SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE telovendo TO admintienda;

-- Se crea la tabla clientes
drop table if exists clientes;
CREATE TABLE clientes
(
codigo int PRIMARY KEY,
nombres varchar(20),
apellidos varchar(30),
telefono varchar (12),
direccion varchar(50),
comuna varchar(20),
correo varchar(20));

-- se crea la tabla categorias
drop table if exists categorias;
CREATE TABLE categorias
(
id int PRIMARY KEY,
nombre_categoria varchar(50));

-- se crea la tabla proveedores
drop table if exists proveedores;
CREATE TABLE proveedores
(
id int PRIMARY KEY,
rut_proveedor varchar(12),
razon_social varchar(50),
direccion varchar(100),	
rep_legal varchar(50),
telefono1 varchar (12),
telefono2 varchar (12),	
nombre_contacto varchar(50),
correo varchar(40));	

-- se crea la tabla productos
drop table if exists productos;
CREATE TABLE productos
(
sku varchar(30) PRIMARY KEY,
nombre_producto varchar(50),
id_categoria int,
id_proveedor int,	
precio float,
color varchar(20),
stock int,
FOREIGN KEY (id_categoria) REFERENCES categorias(id),
FOREIGN KEY (id_proveedor) REFERENCES proveedores(id));	

-- Ingreso 5 clientes **

INSERT INTO clientes (
codigo, nombres, apellidos, telefono, direccion, comuna, correo)
VALUES
(1600,'Javier','Almanza Lopez','56989562316','direccion16','comuna6','correo16@correo.cl'),
(1700,'Ismael','Labrador Cisterna','56989562317','direccion17','comuna11','correo17@correo.cl'),
(1800,'Alejandro','Robles Rivas','56989562318','direccion18','comuna3','correo18@correo.cl'),
(1900,'Angel','Durán Rodriguez','56989562319','direccion19','comuna3','correo19@correo.cl'),
(2000,'Daniel','Gonzalez Miranda','56989505263','direccion20','comuna10','correo20@correo.cl');

-- Ingreso de categorias **

INSERT INTO categorias (
id, nombre_categoria)
VALUES 
(1,'Televisores'),
(2,'Equipos de musica'),
(3,'Celulares'),
(4,'Electrodomesticos'),
(5,'Instrumentos de precisión');

-- Ingreso de proveedores **

INSERT INTO proveedores (
id, rut_proveedor, razon_social, direccion, rep_legal, telefono1, telefono2, nombre_contacto, correo)
VALUES 
(1,'77.887.009-K','Importadora Naranjo Spa','Prat 148','Nicolás Poblete','56989745213','56996852314','Juan Cáceres','naranjo@naranfo.cl'),
(2,'87.125.058-1','Importadora Saturno Spa','OHiggins 748','Luis Alarcón','56989745213','56996852314','Juan Cáceres','saturno@saturno.cl'),
(3,'93.150.850-7','Magallanes Spa','Prat 148','Nicolás Poblete','56989745213','56996852314','Juan Cáceres','naranjo@naranfo.cl'),
(4,'76.250.751-3','Avalos Hermanos EIRL','Prat 148','Nicolás Poblete','56989745213','56996852314','Juan Cáceres','naranjo@naranfo.cl'),
(5,'83.470.682-2','Importadora Landes Ltda.','Prat 148','Nicolás Poblete','56989745213','56996852314','Juan Cáceres','naranjo@naranfo.cl');

-- Ingreso de 10 productos **

INSERT INTO productos (
sku, nombre_producto, id_categoria, id_proveedor, precio, color, stock)
VALUES 
('mvs00205','Celular LG A20',3,1,350000,'rojo',15),
('mvs00207','Celular LG A30',3,1,420000,'azul',10),
('mvs00281','Celular iphone 14',3,4,9400000,'azul',5),
('mvs00292','Celular iphone 10',3,4,553500,'gris',4),
('mvs00510','Televisor 55PJK Panasonic', 1,2,580000,'negro',8),
('mvs00520','Televisor 65rdw Panasonic', 1,2,620000,'negro',7),
('mvs00530','Televisor 42power Samsung', 1,2,375000,'negro',12),
('mvs00603','Equipo audio 180bar Sony', 2,3,580000,'negro',15),
('mvs00815','Tester Fluke 90V', 5,5,365180,'amarillo',10),
('mvs00890','Nivel laser 870rx', 5,5,128500,'naranjo',7);



/*Manipulación de datos - Consultas SQL.
1. Identifique cual es la categoria que mas se repite.*/
 SELECT nombre_categoria FROM categorias
 INNER JOIN productos on categorias.id = productos.id_categoria	
 GROUP BY nombre_categoria
 HAVING COUNT(*) = ( SELECT MAX(contador)
                    FROM ( SELECT nombre_categoria, COUNT(productos.id_categoria) AS contador
                    FROM categorias INNER JOIN productos on categorias.id = productos.id_categoria	
					GROUP BY nombre_categoria) T);

--2. Identifique cuales son los productos con mayor stock.
 SELECT sku,nombre_producto,stock FROM productos ORDER BY stock DESC LIMIT 5;

--3. Identifique el color común de los productos.
 SELECT color as mas_comun FROM productos 
 GROUP BY color
 HAVING COUNT(*) = (SELECT MAX(contador)
				    FROM (SELECT color, COUNT(color) as contador 
				    FROM productos GROUP BY color)T);

--4. Identifique a los proveedores con menor stock.
SELECT id, rut_proveedor, razon_social, SUM(productos.stock) AS total_stock 
FROM proveedores INNER JOIN productos on proveedores.id = productos.id_proveedor
GROUP BY id ORDER BY total_stock ASC LIMIT 3;

--5. Cambiar la categoria mas popular por "Electrónica y computación":

update categorias set nombre_categoria = 'Electrónica y computación'
where nombre_categoria = (SELECT nombre_categoria FROM categorias
						  INNER JOIN productos on categorias.id = productos.id_categoria	
						  GROUP BY nombre_categoria
						  HAVING COUNT(*) = ( SELECT MAX(contador)
						  FROM ( SELECT nombre_categoria, COUNT(productos.id_categoria) AS contador
						  FROM categorias INNER JOIN productos on categorias.id = productos.id_categoria	
						  GROUP BY nombre_categoria) T));
						  
-- Revisamos que el cambio se haya efectuado						  
SELECT * FROM categorias ORDER BY id ASC;






