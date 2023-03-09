CREATE DATABASE practica2;

USE practica2;

CREATE TABLE `Actores` (
    `ID_actor` int NOT NULL,
    `nombre` varchar(25) NOT NULL,
    PRIMARY KEY (`ID_actor`)
);

CREATE TABLE `Directores` (
    `ID_director` int NOT NULL,
    `nombre` varchar(25) NOT NULL,
    PRIMARY KEY (`ID_director`)
);

CREATE TABLE `Peliculas` (
    `ID_pelicula` int NOT NULL,
    `nombre` varchar(25) NOT NULL,
    `ID_director` int,
    PRIMARY KEY (`ID_pelicula`),
    FOREIGN KEY (`ID_director`) REFERENCES `Directores`(`ID_director`)
);

CREATE TABLE `peliculas_actores` (
    `ID_pelicula` int NOT NULL,
    `nombre_pelicula` varchar(25) NOT NULL,
    `ID_actor` int NOT NULL,
    `nombre_actor` varchar(25) NOT NULL,
    imbd int NOT NULL,
    PRIMARY KEY (`ID_pelicula`, `ID_actor`),
    FOREIGN KEY (`ID_actor`) REFERENCES `Actores`(`ID_actor`),
    FOREIGN KEY (`ID_pelicula`) REFERENCES `Peliculas`(`ID_pelicula`)
);

INSERT INTO `Actores` (`ID_actor`, `nombre`) VALUES
(1, 'Tom Hanks'), 
(2, 'Meryl Streep'), 
(3, 'Leonardo DiCaprio'), 
(4, 'Viola Davis'), 
(5, 'Denzel Washington');

INSERT INTO `Directores` (`ID_director`, `nombre`) VALUES
(1, 'Steven Spielberg'), 
(2, 'Quentin Tarantino'), 
(3, 'Christopher Nolan'), 
(4, 'Martin Scorsese'), 
(5, 'Ava DuVernay');

INSERT INTO `Peliculas` (`ID_pelicula`, `nombre`, `ID_director`) VALUES
(1, 'The Godfather', 4), 
(2, 'The Shawshank Redemption', 4), 
(3, 'The Dark Knight', 3), 
(4, 'Schindlers List', 1), 
(5, 'Pulp Fiction', 2);

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

