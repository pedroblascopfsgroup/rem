Insert into BANKMASTER.FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (bankmaster.s_fun_funciones.nextval, 'Permite ver la pestaña de embargos de un bien', 'VER_EMBARGOS_DEL_BIEN', 0, 'DD', sysdate, 0);

COMMIT;
