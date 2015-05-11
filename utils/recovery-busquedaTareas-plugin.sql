-- *************************************************************************** --
-- **    Insertar las dos funciones para habilitar la busqueda de tareas    ** --
-- **    																    ** --
-- *************************************************************************** --

INSERT INTO PFSMASTER.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (PFSMASTER.S_FUN_FUNCIONES.NEXTVAL, 'Ver el buscador de tareas', 'BUSCAR-TAREAS', 0, 'SAG', SYSDATE, 0);

INSERT INTO PFSMASTER.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (PFSMASTER.S_FUN_FUNCIONES.NEXTVAL, 'Visibilidad sobre tareas no propias', 'VISIBILIDAD-TAREAS-NOPROPIAS', 0, 'SAG', SYSDATE, 0);

