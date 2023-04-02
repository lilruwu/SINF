CREATE DATABASE practica2;

USE practica2;

CREATE TABLE `Actores` (
    `ID_actor` int NOT NULL,
    `nombre` varchar(25) NOT NULL,
    `edad` int CHECK (edad >= 0 AND edad <= 120),
    `nacionalidad` varchar(25) not null,
    PRIMARY KEY (`ID_actor`)
);

CREATE TABLE `Directores` (
    `ID_director` int NOT NULL,
    `nombre` varchar(25) NOT NULL,
    `edad` int CHECK (edad >= 0 AND edad <= 120),
    `nacionalidad` varchar(25) not null,
    PRIMARY KEY (`ID_director`)
);

CREATE TABLE `Peliculas` (
    `ID_pelicula` int NOT NULL,
    `nombre` varchar(25) NOT NULL,
    `ID_director` int,
    `nacionalidad` varchar(25) not null,
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


INSERT INTO `Actores` (`ID_actor`, `nombre`, `edad`, `nacionalidad`) VALUES
(1, 'Tom Hanks', 65, 'USA'), 
(2, 'Meryl Streep', 72, 'USA'), 
(3, 'Leonardo DiCaprio', 47, 'USA'), 
(4, 'Viola Davis', 56, 'USA'), 
(5, 'Denzel Washington', 67, 'USA');

INSERT INTO `Directores` (`ID_director`, `nombre`, `edad`,`nacionalidad`) VALUES
(1, 'Steven Spielberg', 75, 'USA'), 
(2, 'Quentin Tarantino', 58, 'USA'), 
(3, 'Christopher Nolan', 51, 'England'),
(4, 'Martin Scorsese', 79, 'USA'), 
(5, 'Ava DuVernay', 49, 'USA');

INSERT INTO `Peliculas` (`ID_pelicula`, `nombre`, `ID_director`,`nacionalidad`) VALUES
(1, 'The Godfather', 4, 'USA'), 
(2, 'The Shawshank Redemption', 4, 'USA'), 
(3, 'The Dark Knight', 3, 'USA'), 
(4, 'Schindlers List', 1, 'USA'), 
(5, 'Pulp Fiction', 2, 'USA');

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

DELIMITER //

CREATE PROCEDURE listar_directores_peliculas()
BEGIN
    SELECT Peliculas.nombre, Directores.nombre AS Directores 
    FROM Peliculas 
    INNER JOIN Directores ON Peliculas.ID_director = Directores.ID_director;
END;

CREATE PROCEDURE consultaPorNacionalidad(in nacion varchar(25))
BEGIN
    SELECT * from Peliculas where nacionalidad = nacion;
    SELECT * from Directores where nacionalidad = nacion;
    SELECT * from Actores where nacionalidad = nacion;
END;

CREATE PROCEDURE peliculasPorNacionalidad(in nacion varchar(25))
BEGIN
    SELECT * from Peliculas where nacionalidad = nacion;
END;

CREATE PROCEDURE ponerMayusculas(in palabra varchar(25))
BEGIN
    select upper(palabra);
END;

CREATE PROCEDURE insertar_pelicula(ID_pelicula int,nombre varchar(25),ID_director int,nacionalidad varchar(25))
BEGIN
    START TRANSACTION;
    INSERT INTO Peliculas (`ID_pelicula`, `nombre`, `ID_director`,`nacionalidad`) VALUES (ID_pelicula,nombre,ID_director,nacionalidad);
    COMMIT;
END;

/*DISIPADORES*/
CREATE TRIGGER actualizar_nacionalidades_pelis

AFTER INSERT ON Peliculas
FOR EACH ROW
BEGIN
    IF NEW.Nacionalidad = 'Spain' THEN
        INSERT INTO Spain (IMBds) VALUES (NEW.ID_pelicula);
    ELSEIF NEW.Nacionalidad = 'USA' THEN
        INSERT INTO USA (IMBds) VALUES (NEW.ID_pelicula);
    ELSEIF NEW.Nacionalidad = 'England' THEN
        INSERT INTO England (IMBds) VALUES (NEW.ID_pelicula);
    ELSEIF NEW.Nacionalidad = 'Mexico' THEN
        INSERT INTO Mexico (IMBds) VALUES (NEW.ID_pelicula);
    END IF;

END;

CREATE TRIGGER actualizar_nacionalidades_actores

AFTER INSERT ON Actores
FOR EACH ROW
BEGIN
    IF NEW.Nacionalidad = 'Spain' THEN
        INSERT INTO Spain (IMBds) VALUES (NEW.ID_actor);
    ELSEIF NEW.Nacionalidad = 'USA' THEN
        INSERT INTO USA (IMBds) VALUES (NEW.ID_actor);
    ELSEIF NEW.Nacionalidad = 'England' THEN
        INSERT INTO England (IMBds) VALUES (NEW.ID_actor);
    ELSEIF NEW.Nacionalidad = 'Mexico' THEN
        INSERT INTO Mexico (IMBds) VALUES (NEW.ID_actor);
    END IF;

END;

CREATE TRIGGER actualizar_nacionalidades_directores

AFTER INSERT ON Directores
FOR EACH ROW
BEGIN
    IF NEW.Nacionalidad = 'Spain' THEN
        INSERT INTO Spain (IMBds) VALUES (NEW.ID_director);
    ELSEIF NEW.Nacionalidad = 'USA' THEN
        INSERT INTO USA (IMBds) VALUES (NEW.ID_director);
    ELSEIF NEW.Nacionalidad = 'England' THEN
        INSERT INTO England (IMBds) VALUES (NEW.ID_director);
    ELSEIF NEW.Nacionalidad = 'Mexico' THEN
        INSERT INTO Mexico (IMBds) VALUES (NEW.ID_director);
    END IF;

END;

/*EJERCICIO 12 BY GEPETO*/
CREATE TRIGGER asegurar_actores AFTER INSERT ON Peliculas
FOR EACH ROW
BEGIN
    DECLARE num_actores INT;
    SELECT COUNT(*) INTO num_actores FROM PeliculasActores WHERE ID_pelicula = NEW.ID_pelicula;
    IF num_actores = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se pueden insertar películas sin actores asociados';
        ROLLBACK;
    END IF;
END;

/*SE ACABARON LOS DISIPADORES*/

CREATE PROCEDURE contar_directores()
BEGIN
    DECLARE num_directores INT;
    SELECT COUNT(*) INTO num_directores FROM Directores;

    

    SET @num_llamados = IFNULL(@num_llamados, 0) + 1;
    
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'cuentaDirectores') THEN
        SET @num_llamados=0;
        CREATE TABLE cuentaDirectores (
            fecha_hora DATETIME,
            num_directores INT,
            num_llamados INT
        );
    END IF;

    if @num_llamados >= 10 THEN

    delete from cuentaDirectores order by fecha_hora limit 1;

    end if;
    

  
    INSERT INTO cuentaDirectores (fecha_hora, num_directores, num_llamados) VALUES (NOW(), num_directores, @num_llamados);
END //


DELIMITER ;

drop procedure if exists extraer_imbds;
DELIMITER &&
CREATE PROCEDURE extraer_imbds(IN nac CHAR(50))
BEGIN
DECLARE codigo INT;
DECLARE done BOOLEAN;
DECLARE imbds_cursor CURSOR FOR ((SELECT ID_director FROM Directores WHERE Nacionalidad=nac)union(SELECT ID_pelicula FROM Peliculas WHERE Nacionalidad=nac)union
(SELECT ID_actor FROM Actores WHERE Nacionalidad=nac));
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;/**esto servira para parar el bucle cuando no hay mas tuplas*/
IF nac = 'Spain' THEN
DROP TABLE IF EXISTS Spain;
CREATE TABLE Spain(
    IMBds INT UNSIGNED
);

OPEN imbds_cursor;/*se abre el cursor para utilizarlo*/

loop1:LOOP/*loop con etiqueta*/
FETCH imbds_cursor INTO codigo;/*saca el valor de la tupla de la busqueda y lo mete en codigo*/
IF done = TRUE THEN /*si no quedan mas tuplas, el handler se activara y pondra @done a true*/
LEAVE loop1;
ELSE 
INSERT INTO Spain VALUES (codigo);
END IF;
END LOOP;

CLOSE imbds_cursor;
END IF;

IF nac = 'USA' THEN
DROP TABLE IF EXISTS USA;
CREATE TABLE USA(
    IMBds INT UNSIGNED
);

OPEN imbds_cursor;/*se abre el cursor para utilizarlo*/

loop1:LOOP/*loop con etiqueta*/
FETCH imbds_cursor INTO codigo;/*saca el valor de la tupla de la busqueda y lo mete en codigo*/
IF done = TRUE THEN /*si no quedan mas tuplas, el handler se activara y pondra @done a true*/
LEAVE loop1;
ELSE 
INSERT INTO USA VALUES (codigo);
END IF;
END LOOP;
CLOSE imbds_cursor;
END IF;

IF nac = 'England' THEN
DROP TABLE IF EXISTS England;
CREATE TABLE England(
    IMBds INT UNSIGNED
);
OPEN imbds_cursor;/*se abre el cursor para utilizarlo*/

loop1:LOOP/*loop con etiqueta*/
FETCH imbds_cursor INTO codigo;/*saca el valor de la tupla de la busqueda y lo mete en codigo*/
IF done = TRUE THEN /*si no quedan mas tuplas, el handler se activara y pondra @done a true*/
LEAVE loop1;
ELSE 
INSERT INTO England VALUES (codigo);
END IF;
END LOOP;
CLOSE imbds_cursor;
END IF;

IF nac = 'Mexico' THEN
DROP TABLE IF EXISTS Mexico;
CREATE TABLE Mexico(
    IMBds INT UNSIGNED
);
OPEN imbds_cursor;/*se abre el cursor para utilizarlo*/

loop1:LOOP/*loop con etiqueta*/
FETCH imbds_cursor INTO codigo;/*saca el valor de la tupla de la busqueda y lo mete en codigo*/
IF done = TRUE THEN /*si no quedan mas tuplas, el handler se activara y pondra @done a true*/
LEAVE loop1;
ELSE 
INSERT INTO Mexico VALUES (codigo);
END IF;
END LOOP;

CLOSE imbds_cursor;
END IF;
END 
&&/**no usar el mismo nombre para los parametros que para las columnas de las tablas -> los confundira*/
