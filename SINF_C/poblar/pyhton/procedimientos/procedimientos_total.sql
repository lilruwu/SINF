CREATE DATABASE IF NOT EXISTS Taquilla;
USE Taquilla;

DELIMITER //

DROP PROCEDURE IF EXISTS crear_espectaculo//

CREATE PROCEDURE crear_espectaculo(
    IN nombre_espectaculo_in VARCHAR(50),
    IN descripcion_espectaculo_in VARCHAR(50),
    IN participantes_espectaculo_in VARCHAR(50)
)
BEGIN
    CREATE TABLE IF NOT EXISTS Espectaculo (
        nombre_espectaculo VARCHAR(50) PRIMARY KEY,
        descripcion_espectaculo VARCHAR(50),
        participantes_espectaculo VARCHAR(50)
    );

    INSERT INTO Espectaculo (nombre_espectaculo, descripcion_espectaculo, participantes_espectaculo)
    VALUES (nombre_espectaculo_in, descripcion_espectaculo_in, participantes_espectaculo_in);

    SELECT 'La tabla Espectaculo se ha creado correctamente y el espectáculo ha sido insertado.' AS mensaje;
END//

DELIMITER ;



CREATE DATABASE IF NOT EXISTS Taquilla;
USE Taquilla;

DROP TABLE IF EXISTS Recinto;
CREATE TABLE Recinto (
    nombre_recinto VARCHAR(50) PRIMARY KEY,
    localidades_recinto INT
);

DELIMITER //

DROP PROCEDURE IF EXISTS crear_recinto//

CREATE PROCEDURE crear_recinto(
    IN nombre_recinto_in VARCHAR(50),
    IN localidades_recinto_in INT
)
BEGIN
    INSERT INTO Recinto (nombre_recinto, localidades_recinto)
    VALUES (nombre_recinto_in, localidades_recinto_in);

    SELECT 'El recinto ha sido creado correctamente.' AS mensaje;
END//

DELIMITER ;



USE Taquilla;

DELIMITER //

DROP PROCEDURE IF EXISTS crear_gradas//

CREATE PROCEDURE crear_gradas(
    IN nombre_grada_in VARCHAR(50), 
    IN nombre_recinto_grada_in VARCHAR(50), 
    IN num_localidades_reservar_grada_in INT, 
    IN precio_grada_in INT
)
BEGIN

DECLARE localidades_recinto_proc INT;
DECLARE total_localidades_reservadas INT;

-- Obtener el número de localidades del recinto correspondiente
SELECT localidades_recinto INTO localidades_recinto_proc 
FROM Recinto WHERE nombre_recinto = nombre_recinto_grada_in;

-- Obtener el sumatorio de localidades reservadas para el recinto correspondiente
SELECT IFNULL(SUM(num_localidades_reservar_grada), 0) INTO total_localidades_reservadas
FROM Grada WHERE nombre_recinto_grada = nombre_recinto_grada_in;

IF total_localidades_reservadas + num_localidades_reservar_grada_in > localidades_recinto_proc THEN
    SIGNAL SQLSTATE '45001' 
        SET MESSAGE_TEXT = 'No hay tanto aforo';
ELSE
    -- Crear la tabla si no existe y hacer la inserción
    CREATE TABLE IF NOT EXISTS Grada (
        nombre_grada VARCHAR(50),
        nombre_recinto_grada VARCHAR(50),
        num_localidades_reservar_grada INT,
        precio_grada INT,
        FOREIGN KEY(nombre_recinto_grada) REFERENCES Recinto(nombre_recinto),
        PRIMARY KEY(nombre_grada, nombre_recinto_grada)
    );
    
    INSERT INTO Grada(nombre_grada, nombre_recinto_grada, num_localidades_reservar_grada, precio_grada) 
    VALUES (nombre_grada_in, nombre_recinto_grada_in, num_localidades_reservar_grada_in, precio_grada_in);
END IF;

END//

DELIMITER ;



CREATE DATABASE IF NOT EXISTS Taquilla;
USE Taquilla;
    
CREATE TABLE IF NOT EXISTS Localidad (
        localizacion_localidad VARCHAR(50),
        nombre_recinto_localidad VARCHAR(50),
        nombre_grada_localidad VARCHAR(50),
        precio_base_localidad INT,
        estado_localidad ENUM('disponible', 'no disponible')
    );
DELIMITER //
DROP PROCEDURE IF EXISTS crear_localidad;

CREATE PROCEDURE crear_localidad(
    IN p_localizacion VARCHAR(50), 
    IN p_nombre_recinto VARCHAR(50), 
    IN p_nombre_grada VARCHAR(50),
    IN p_precio_base INT, 
    IN p_estado ENUM('disponible', 'no disponible')
)
BEGIN
    DECLARE recinto_existe INT DEFAULT 0;
    DECLARE grada_existe INT DEFAULT 0;
    DECLARE num_tuplas INT DEFAULT 0;
    DECLARE num_localidades_reservar INT DEFAULT 0;
    
    -- Comprobar si el recinto existe
    SELECT COUNT(*) INTO recinto_existe FROM Recinto WHERE nombre_recinto = p_nombre_recinto;
    
    -- Comprobar si la grada existe y obtener el número de localidades a reservar
    SELECT num_localidades_reservar_grada, COUNT(*) INTO num_localidades_reservar, grada_existe 
    FROM Grada WHERE nombre_grada = p_nombre_grada AND nombre_recinto_grada = p_nombre_recinto
    GROUP BY num_localidades_reservar_grada;
    
    IF recinto_existe > 0 AND grada_existe > 0 THEN
        -- Obtener el número de tuplas con el mismo recinto y la misma grada
        SELECT COUNT(*) INTO num_tuplas FROM Localidad WHERE nombre_recinto_localidad = p_nombre_recinto AND nombre_grada_localidad = p_nombre_grada;
        
        -- Comprobar si se pueden reservar más localidades en la grada
        IF num_tuplas < num_localidades_reservar THEN
            -- Insertar nueva localidad si tanto el recinto como la grada existen y se pueden reservar más localidades
            INSERT INTO Localidad(localizacion_localidad, nombre_recinto_localidad, nombre_grada_localidad, precio_base_localidad, estado_localidad)
            VALUES (p_localizacion, p_nombre_recinto, p_nombre_grada, p_precio_base, p_estado);
        
            -- Imprimir el número de tuplas con el mismo recinto y la misma grada
            SELECT CONCAT("La localidad ha sido creada exitosamente. Hay ", num_tuplas+1, " localidades en la misma grada y el mismo recinto.") AS mensaje;
        ELSE
            SELECT "Error: No se pueden reservar más localidades en esta grada." AS mensaje;
        END IF;
    ELSE
        SELECT "Error: El recinto o la grada no existen." AS mensaje;
    END IF;
END//

DELIMITER ;


CREATE DATABASE IF NOT EXISTS Taquilla;
USE Taquilla;

DROP PROCEDURE IF EXISTS CrearEvento;

DROP PROCEDURE IF EXISTS Error;



DELIMITER //

CREATE PROCEDURE Error (
    ERRNO BIGINT UNSIGNED,
    message_text VARCHAR(100)
)

BEGIN
    SIGNAL SQLSTATE 'ERROR'
SET
    MESSAGE_TEXT = message_text,
    MYSQL_ERRNO = ERRNO;
END //




CREATE PROCEDURE CrearEvento (

    IN nombre_espectaculo_IN VARCHAR(50),
    IN nombre_recinto_IN VARCHAR(50),
    IN fecha_evento_IN DATETIME,
    IN estado_evento_IN VARCHAR(50)

)

BEGIN
    -- Pasos
    -- 
    --  1. Declaramos variables
    --  2. Checkeamos si existen el Recinto y el Espectaculo
    --  3. Check Fecha ? T-T
    --  4. Check dato Estado en los datos de entrada
    --  5. Hacemos el insert de los datos de entrada
    --  6. Gestion de las Localidades del Evento (JAJA salu2)


    -- TODO: 1.
    -- DECLARE numEventoNuevo INIT;
    -- DECLARE numLocalicades INIT;
    -- DECLARE cursorLocalidades


    -- 2.
    IF ( (SELECT EXISTS(SELECT * FROM Espectaculo WHERE nombre_espectaculo = nombre_espectaculo_IN) ) = '') THEN
        CALL Error(1, "No existe dicho Espectaculo.");
    END IF;

    IF ( (SELECT EXISTS(SELECT * FROM Recinto WHERE nombre_recinto = nombre_recinto_IN) ) = '') THEN
        CALL Error(2, "No existe dicho Recinto.");
    END IF;

    -- 3.
    -- ! Esto vamos a tener que retocarlo
    -- ! No es que tenga mucho sentido que puedan entrar eventos para ya
    IF (fecha_evento_IN <= NOW())  THEN
        CALL Error (3, "Fecha incorrecta.");
    END IF;

    -- 4. 
    -- ? Entiendo que cuando un Evento pasa el punto T1, donde no se pueden
    -- ? comprar entradas, es cuando pasa de Estado = Abierto a Estado = No Disponible
    IF ( estado_evento_IN = "Finalizado" ) THEN
        CALL Error (4, "Estado de Evento: Incorrecto.");
    END IF;

    -- 5.
    INSERT INTO Evento (nombre_espectaculo_evento, nombre_recinto_evento, fecha_evento, estado_evento)
    VALUE (nombre_espectaculo_IN, nombre_recinto_IN, fecha_evento_IN, estado_evento_IN);

    -- TODO: 6.
    
END //

DELIMITER ;



USE Taquilla;

DELIMITER //

DROP PROCEDURE IF EXISTS crear_usLoc;

CREATE PROCEDURE crear_usLoc(
    IN localizacion_localidad_in VARCHAR(50),
    IN nombre_grada_in VARCHAR(50),
    IN nombre_recinto_in VARCHAR(50),
    IN tipo_usuario ENUM('jubilado', 'parado', 'adulto', 'infantil')
)
BEGIN
    DECLARE consulta VARCHAR(50);

    SELECT localizacion_localidad INTO consulta
    FROM Localidad
    WHERE nombre_recinto_localidad = nombre_recinto_in
        AND localizacion_localidad = localizacion_localidad_in
        AND nombre_grada_localidad = nombre_grada_in;

    IF consulta = localizacion_localidad_in THEN
        INSERT INTO UsLoc VALUES (tipo_usuario, localizacion_localidad_in, nombre_grada_in, nombre_recinto_in);
    END IF;
END//

DELIMITER ;



INSERT INTO Usuario VALUES ('adulto', 0);
INSERT INTO Usuario VALUES ('parado', 10);
INSERT INTO Usuario VALUES ('jubilado', 20);
INSERT INTO Usuario VALUES ('infantil', 30);

CALL crear_usLoc('Asiento 1', 'Grada Norte', 'Camp Nou', 'adulto');



CREATE DATABASE IF NOT EXISTS Taquilla;
USE Taquilla;

DELIMITER //


DROP PROCEDURE IF EXISTS crearOferta//
CREATE PROCEDURE crearOferta(
    IN nombreEspectaculo CHAR(50),
    IN nombreRecinto CHAR(50),
    IN fechaEvento DATETIME,
    IN tipoUsuarioOfertado CHAR(50),
    IN localizacionLocalidad CHAR(50),
    IN nombreGrada CHAR(50)
)
BEGIN
    DECLARE done BOOLEAN;
    DECLARE valido BOOLEAN;
    DECLARE consulta VARCHAR(50);
    DECLARE localidad VARCHAR(50);
    DECLARE recinto VARCHAR(100);
    DECLARE cursito CURSOR FOR (SELECT nombre_recinto_localidad FROM Localidad WHERE localizacion_localidad=localizacionLocalidad AND nombre_grada_localidad=nombreGrada);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    
    SET valido = FALSE;
    SET done = FALSE;
    
    CREATE TABLE IF NOT EXISTS Oferta(
        nombre_espectaculo_oferta VARCHAR(50),
        nombre_recinto_oferta VARCHAR(50),
        tipo_usuario_oferta ENUM('jubilado', 'parado', 'adulto', 'infantil'),
        localizacion_localidad_oferta VARCHAR(50),
        nombre_grada_oferta VARCHAR(50),
        fecha_evento_oferta DATETIME,
        estado_localidad_oferta ENUM('pre-reservado', 'reservado', 'deteriorado', 'libre'),
        FOREIGN KEY(tipo_usuario_oferta, localizacion_localidad_oferta, nombre_grada_oferta, nombre_recinto_oferta) 
        REFERENCES UsLoc(tipo_usuario_usloc, localizacion_localidad_usloc, nombre_grada_usloc, nombre_recinto_usloc),
        PRIMARY KEY(nombre_espectaculo_oferta, nombre_recinto_oferta, tipo_usuario_oferta, localizacion_localidad_oferta, nombre_grada_oferta)
    );
    
    SELECT nombre_espectaculo_evento INTO consulta FROM Evento WHERE nombre_recinto_evento = nombreRecinto AND nombre_espectaculo_evento = nombreEspectaculo AND fecha_evento = fechaEvento;
    SELECT estado_localidad INTO localidad FROM Localidad WHERE nombre_recinto_localidad = nombreRecinto AND nombre_grada_localidad = nombreGrada AND localizacion_localidad = localizacionLocalidad;
    SELECT(consulta);
    
    OPEN cursito;
    
    loop1:LOOP
        FETCH cursito INTO recinto;
        SELECT(recinto);
        SELECT(localidad);
        
        IF done = TRUE THEN 
            LEAVE loop1;
        ELSE 
            IF recinto = nombreRecinto THEN
                IF consulta IS NOT NULL THEN
                    IF localidad = 'disponible' THEN
                        SET valido = TRUE;
                        LEAVE loop1;
                    ELSE 
                        SELECT 'No se creo la oferta' AS mensaje;
                    END IF;
                END IF;
            END IF;
        END IF;
    END LOOP;
    
    CLOSE cursito;
    
    IF valido = TRUE THEN 
        INSERT INTO Oferta VALUES (nombreEspectaculo, nombreRecinto, tipoUsuarioOfertado, localizacionLocalidad, nombreGrada, fechaEvento, 'libre');
    END IF;
END //
DELIMITER ;
----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS Taquilla;
USE Taquilla;

SET FOREIGN_KEY_CHECKS=0;

DROP PROCEDURE IF EXISTS ComprarEntrada;
DROP PROCEDURE IF EXISTS CalcularPrecio;
DROP PROCEDURE IF EXISTS ttt;


DELIMITER //

-- CREATE PROCEDURE ttt ()
-- BEGIN
--     DECLARE precio FLOAT;
--     -- CALL CalcularPrecio("Grada Norte", "Camp Nou", "parado", "Romero", "Camp Nou", "Grada Norte", precio);
--     CALL CalcularPrecio ("Grada Norte", "Camp Nou", "Romero", "parado", precio);
--     SELECT precio AS message;
-- END //



CREATE PROCEDURE CalcularPrecio (

    -- Datos Grada      ---> IncrementoPrecio
    -- Datos Localidad  ---> PrecioBase
    -- Datos Usuario    ---> DescuentoPrecio

    IN nombreGrada VARCHAR(50),
    IN nombreRecinto VARCHAR(50),
    IN localizacionLocalidad VARCHAR(50),
    IN tipoUsuario VARCHAR(50),
    
    OUT precioFinal FLOAT

)
BEGIN
    
    DECLARE incrementoPrecioGrada FLOAT;
    DECLARE precioBaseLocalidad FLOAT;
    DECLARE descuentoUsuario FLOAT;

    -- Check si existe dicha Infraestructura
    IF ( (SELECT EXISTS(SELECT * FROM Recinto WHERE nombre_recinto = nombreRecinto) ) = 0) THEN
        CALL Error(2, "No existe dicho Recinto.");
    END IF;

    IF ( (SELECT EXISTS(SELECT * FROM Grada WHERE nombre_grada = nombreGrada AND nombre_recinto_grada = nombreRecinto) ) = 0) THEN
        CALL Error(6, "No existe dicha Grada.");
    END IF;

    IF ( (SELECT EXISTS(SELECT * FROM Localidad 
    WHERE localizacion_localidad = localizacionLocalidad AND nombre_recinto_localidad = nombreRecinto AND nombre_grada_localidad = nombreGrada) ) = 0) THEN
        CALL Error(7, "No existe dicha Localidad.");
    END IF;


    SELECT precio_grada INTO incrementoPrecioGrada
    FROM Grada
    WHERE nombre_grada = nombreGrada AND
        nombre_recinto_grada = nombreRecinto
    ;

    SELECT precio_base_localidad INTO precioBaseLocalidad 
    FROM Localidad
    WHERE localizacion_localidad = localizacionLocalidad AND
        nombre_recinto_localidad = nombreRecinto AND
        nombre_grada_localidad = nombreGrada
    ;


    SELECT descuento_usuario INTO descuentoUsuario
    FROM Usuario
    WHERE tipo_usuario = tipoUsuario; 

    SET precioFinal = incrementoPrecioGrada * precioBaseLocalidad * descuentoUsuario;

END // 



CREATE PROCEDURE ComprarEntrada (

    IN dni_cliente_IN VARCHAR(50),
    IN tipo_usuario_IN VARCHAR(50),

    IN nombre_espectaculo_ofertaIN VARCHAR(50), 
    IN nombre_recinto_ofertaIN VARCHAR(50), 
    IN localizacion_localidad_ofertaIN VARCHAR(50), 
    IN nombre_grada_ofertaIN VARCHAR(50),
    IN fecha_evento_ofertaIN DATETIME


)
BEGIN
    DECLARE precio FLOAT;
    DECLARE consulta VARCHAR(50);
    
    SELECT dni_cliente INTO consulta FROM Cliente WHERE dni_cliente = dni_cliente_IN;
    
    IF consulta IS NULL THEN
    	CALL Error (10,"Cliente inexistente");
    END IF;

    IF (SELECT EXISTS(SELECT * FROM Evento WHERE (
        nombre_espectaculo_evento = nombre_espectaculo_ofertaIN AND
        nombre_recinto_evento = nombre_recinto_ofertaIN AND
        fecha_evento = fecha_evento_ofertaIN AND
        estado_evento = "abierto"
    )) = 0 ) THEN 
        CALL Error (5, "Evento inexistente.");
    END IF;

    IF (SELECT EXISTS (SELECT * FROM Localidad WHERE (
        localizacion_localidad = localizacion_localidad_ofertaIN AND
        nombre_recinto_localidad = nombre_recinto_ofertaIN AND
        nombre_grada_localidad = nombre_grada_ofertaIN AND
        estado_localidad = 'disponible'
    )) = 0) THEN
        CALL Error(8, "Localidad no disponible.");
    END IF;

    IF (SELECT EXISTS (SELECT * FROM Oferta WHERE (
        nombre_espectaculo_oferta = nombre_espectaculo_ofertaIN AND
        nombre_recinto_oferta = nombre_recinto_ofertaIN AND
        localizacion_localidad_oferta = localizacion_localidad_ofertaIN AND
      	tipo_usuario_oferta = tipo_usuario_IN AND
        nombre_grada_oferta = nombre_grada_ofertaIN AND
        fecha_evento_oferta = fecha_evento_ofertaIN AND
        estado_localidad_oferta = 'libre'
    )) = 0 ) THEN
        CALL Error (9, "No existen ofertas para esta localidad.");
    END IF;

    CALL CalcularPrecio (nombre_grada_ofertaIN, nombre_recinto_ofertaIN, localizacion_localidad_ofertaIN, tipo_usuario_IN, precio);


    INSERT INTO Compra (
        dni_cliente_compra,
        tipo_usuario_compra,
        espectaculo_compra,
        fecha_compra,
        localizacion_localidad_compra,
        nombre_grada_compra,
        nombre_recinto_compra,
        precioFinal
    ) 
    Values (
        dni_cliente_IN,
        tipo_usuario_IN,
        nombre_espectaculo_ofertaIN,
        fecha_evento_ofertaIN,
        localizacion_localidad_ofertaIN,
        nombre_grada_ofertaIN,
        nombre_recinto_ofertaIN,
        precio
    );

    UPDATE Oferta SET estado_localidad_oferta = 'pre-reservado'  
    WHERE (
        nombre_espectaculo_oferta = nombre_espectaculo_ofertaIN AND
        nombre_recinto_oferta = nombre_recinto_ofertaIN AND
        localizacion_localidad_oferta = localizacion_localidad_ofertaIN AND
        nombre_grada_oferta = nombre_grada_ofertaIN AND
        fecha_evento_oferta = fecha_evento_ofertaIN
    );


END //

DELIMITER ;

-------------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS Taquilla;
USE Taquilla;

USE Taquilla;

DELIMITER //

DROP PROCEDURE IF EXISTS anular_compra;

CREATE PROCEDURE anular_compra(
    IN dni_cliente VARCHAR(50), 
    IN tipo_usuario ENUM('jubilado', 'parado', 'adulto', 'infantil'),
    IN espectaculo VARCHAR(50),
    IN fecha DATETIME,
    IN localizacion_localidad VARCHAR(50),
    IN nombre_grada VARCHAR(50),
    IN nombre_recinto VARCHAR(50)
)
BEGIN
    -- Eliminar la tupla de la tabla Compra que coincida con los valores pasados por parámetro
    DELETE FROM Compra 
    WHERE dni_cliente_compra = dni_cliente
    AND tipo_usuario_compra = tipo_usuario 
    AND espectaculo_compra = espectaculo 
    AND fecha_compra = fecha 
    AND localizacion_localidad_compra = localizacion_localidad 
    AND nombre_grada_compra = nombre_grada 
    AND nombre_recinto_compra = nombre_recinto;

    -- Cambiar el estado de la tupla de la tabla Oferta que coincida con los valores pasados por parámetro
    UPDATE Oferta
    SET estado_localidad_oferta = 'libre'
    WHERE nombre_espectaculo_oferta = espectaculo 
    AND nombre_recinto_oferta = nombre_recinto 
    AND tipo_usuario_oferta = tipo_usuario 
    AND localizacion_localidad_oferta = localizacion_localidad 
    AND nombre_grada_oferta = nombre_grada 
    AND fecha_evento_oferta = fecha 
    AND estado_localidad_oferta = 'pre-reservado';
END//

DELIMITER ;

CALL crear_espectaculo('El Clasico', 'El partido del año', 'Barca, Real Madrid');
CALL crear_recinto('Camp Nou', 8900);
CALL crear_gradas('Grada Norte', 'Camp Nou', 1000, 50);
CALL crear_localidad('Asiento 1', 'Camp Nou', 'Grada Norte', 50, 'disponible');
CALL CrearEvento('El Clasico', 'Camp Nou', '2023-12-12 20:00:00', 'Abierto');
CALL crear_usLoc('Asiento 1', 'Grada Norte', 'Camp Nou', 'adulto');
CALL crearOferta('El Clasico', 'Camp Nou', '2023-12-12 20:00:00', 'adulto', 'Asiento 1', 'Grada Norte');


SELECT * FROM UsLoc;
SELECT * FROM Usuario;
SELECT * FROM Localidad;
SELECT * FROM Grada;
SELECT * FROM Recinto;
SELECT * FROM Espectaculo;
SELECT * FROM Evento;
SELECT * FROM Oferta;
SELECT * FROM Compra;
