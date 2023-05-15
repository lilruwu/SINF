CREATE DATABASE practica2;

CREATE TABLE `Actores` (
    `nombre` varchar(25) NOT NULL,
    `ID_actor` int NOT NULL,
    PRIMARY KEY (`ID_actor`)
);

CREATE TABLE `Directores` (
    `nombre` varchar(25) NOT NULL,
    `ID_director` int NOT NULL,
    PRIMARY KEY (`ID_director`)
);

CREATE TABLE `Peliculas` (
    `nombre` varchar(25) NOT NULL,
    `ID_pelicula` int NOT NULL,
    PRIMARY KEY (`ID_pelicula`)
);

INSERT INTO `Actores` (`nombre`, `ID_actor`) VALUES
('Tom Hanks', 1), 
('Meryl Streep', 2), 
('Leonardo DiCaprio', 3), 
('Viola Davis', 4), 
('Denzel Washington', 5);

INSERT INTO `Directores` (`nombre`, `ID_director`) VALUES
('Steven Spielberg', 1), 
('Quentin Tarantino', 2), 
('Christopher Nolan', 3), 
('Martin Scorsese', 4), 
('Ava DuVernay', 5);

INSERT INTO `Peliculas` (`nombre`, `ID_pelicula`) VALUES
('The Godfather', 1), 
('The Shawshank Redemption', 2), 
('The Dark Knight', 3), 
('Schindlers List', 4), 
('Pulp Fiction', 5);
