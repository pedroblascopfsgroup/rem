Insert into BANKMASTER.FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (bankmaster.s_fun_funciones.nextval, 'Permite cambiar el estado de una incidencia.', 'CAMBIAR-ESTADO-INCIDENCIA', 0, 'DD', sysdate, 0);

COMMIT;
