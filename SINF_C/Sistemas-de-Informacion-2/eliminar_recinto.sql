/*HE CAMBIADO LAS TABLAS PARA QUE SE ELIMINEN EN CASCADA ASÍ QUE CON ESTE CODIGO ES SUFICIENTE*/

CREATE PROCEDURE eliminar_recinto(IN nombre_recinto_eliminar VARCHAR(50))
BEGIN
    /*eliminar todas las filas de Localidad que tengan la clave foránea asociada al recinto eliminado*/
    DELETE FROM Localidad WHERE nombre_recinto_localidad = nombre_recinto_eliminar;

    /*eliminar todas las filas de Grada que tengan la clave foránea asociada al recinto eliminado*/
    DELETE FROM Grada WHERE nombre_recinto_grada = nombre_recinto_eliminar;

    /*eliminar la fila de Recinto*/
    DELETE FROM Recinto WHERE nombre_recinto = nombre_recinto_eliminar;
END
