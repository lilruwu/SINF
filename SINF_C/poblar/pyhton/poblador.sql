USE Taquilla2;

LOAD DATA INFILE 'nuevos_estadios.csv' INTO TABLE Recinto  FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n'  IGNORE 1 ROWS;


ALTER TABLE Espectaculo MODIFY descripcion_espectaculo VARCHAR(100);

LOAD DATA INFILE 'nuevas_pelis.csv'
INTO TABLE Espectaculo
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nombre_espectaculo, participantes_espectaculo, descripcion_espectaculo);
