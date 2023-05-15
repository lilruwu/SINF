CREATE DATABASE practica4;

USE practica4;

CREATE TABLE `Actores` (
    `ID_actor` int AUTO_INCREMENT,
    `nombre` varchar(25) NOT NULL,
    `edad` int CHECK (edad >= 0 AND edad <= 120),
    `nacionalidad` varchar(25) default 'USA',
    `fecha_creacion` timestamp default NOW(),
    PRIMARY KEY (`ID_actor`)
);

CREATE TABLE `Directores` (
    `ID_director` int AUTO_INCREMENT,
    `nombre` varchar(25) NOT NULL,
    `edad` int CHECK (edad >= 0 AND edad <= 120),
    `nacionalidad` varchar(25) default 'USA',
    `fecha_creacion` timestamp default NOW(),
    PRIMARY KEY (`ID_director`)
);

CREATE TABLE `Peliculas` (
    `ID_pelicula` int AUTO_INCREMENT,
    `nombre` varchar(25) NOT NULL,
    `ID_director` int,
    `rating` decimal(3,2), /*el 3 es la cantidad de digitos y el 2 la cantidad de decimales despues de la coma*/
    `nacionalidad` varchar(25) default 'USA',
    `fecha_creacion` timestamp default NOW(),
    PRIMARY KEY (`ID_pelicula`),
    FOREIGN KEY (`ID_director`) REFERENCES `Directores`(`ID_director`)
);

CREATE TABLE `peliculas_actores` (
    `ID_pelicula` int NOT NULL,
    `nombre_pelicula` varchar(25) NOT NULL,
    `ID_actor` int NOT NULL,
    `nombre_actor` varchar(25) NOT NULL,
    `imbd` int,
    PRIMARY KEY (`ID_pelicula`, `ID_actor`),
    FOREIGN KEY (`ID_actor`) REFERENCES `Actores`(`ID_actor`),
    FOREIGN KEY (`ID_pelicula`) REFERENCES `Peliculas`(`ID_pelicula`)
);



INSERT INTO `Actores` (`ID_actor`, `nombre`, `edad`) VALUES
(1, 'Tom Hanks', 65), 
(2, 'Meryl Streep', 72), 
(3, 'Leonardo DiCaprio', 47), 
(4, 'Viola Davis', 56), 
(5, 'Denzel Washington', 67);

INSERT INTO `Directores` (`ID_director`, `nombre`, `edad`) VALUES
(1, 'Steven Spielberg', 75), 
(2, 'Quentin Tarantino', 58), 
(3, 'Christopher Nolan', 51), 
(4, 'Martin Scorsese', 79), 
(5, 'Ava DuVernay', 49);


INSERT INTO `Peliculas` (`nombre`, `ID_director`, `rating`) VALUES
('The Godfather', 4, 8.50), 
('The Shawshank Redemption', 4, 9.00), 
('The Dark Knight', 3, 4.55), 
('Schindlers List', 1, 9.58), 
('Pulp Fiction', 2, 7.50);

INSERT INTO `peliculas_actores` (`ID_pelicula`, `nombre_pelicula`, `ID_actor`, `nombre_actor`,imbd) VALUES
(1, 'The Godfather', 1, 'Tom Hanks',0068646),
(1, 'The Godfather', 2, 'Meryl Streep',0068646),
(1, 'The Godfather', 4, 'Viola Davis',0068646),
(2, 'The Shawshank Redemption', 1, 'Tom Hanks',0111161),
(2, 'The Shawshank Redemption', 3, 'Leonardo DiCaprio',0111161),
(2, 'The Shawshank Redemption', 5, 'Denzel Washington',0111161),
(3, 'The Dark Knight', 1, 'Tom Hanks',0468569),
(3, 'The Dark Knight', 3, 'Leonardo DiCaprio',0468569),
(4, 'Schindlers List', 2, 'Meryl Streep',0108052),
(4, 'Schindlers List', 4, 'Viola Davis',0108052),
(5, 'Pulp Fiction', 2, 'Meryl Streep',0110912),
(5, 'Pulp Fiction', 3, 'Leonardo DiCaprio',0110912),
(5, 'Pulp Fiction', 5, 'Denzel Washington',0110912);

CREATE VIEW Vista_Peliculas AS
SELECT nombre, nacionalidad FROM Peliculas;

CREATE VIEW ej7 AS 
SELECT p.nombre AS titulo, p.nacionalidad AS nacionalidad_pelicula, d.nombre AS director, GROUP_CONCAT(a.nombre SEPARATOR ', ') AS actores
FROM Peliculas p 
INNER JOIN Directores d ON p.ID_director = d.ID_director 
INNER JOIN peliculas_actores pa ON p.ID_pelicula = pa.ID_pelicula 
INNER JOIN Actores a ON pa.ID_actor = a.ID_actor 
GROUP BY p.ID_pelicula;

ALTER VIEW ej7
AS
SELECT p.ID_pelicula, p.nombre AS nombre_pelicula, p.nacionalidad AS nacionalidad_pelicula, d.nombre AS nombre_director, a.ID_actor, a.nombre AS nombre_actor, pa.imbd
FROM Peliculas p
INNER JOIN Directores d ON p.ID_director = d.ID_director
INNER JOIN peliculas_actores pa ON p.ID_pelicula = pa.ID_pelicula
INNER JOIN Actores a ON pa.ID_actor = a.ID_actor


CREATE USER usuario1 IDENTIFIED BY 'contrasena1';
CREATE USER usuario2 IDENTIFIED BY 'contrasena2';

REVOKE ALL PRIVILEGES FROM usuario1;
REVOKE ALL PRIVILEGES FROM usuario2;


GRANT SELECT ON Vista_Peliculas TO usuario1;
GRANT SELECT ON ej7 TO usuario2;




