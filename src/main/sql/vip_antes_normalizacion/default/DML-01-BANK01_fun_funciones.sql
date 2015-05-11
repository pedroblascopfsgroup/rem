Insert into BANKMASTER.FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (bankmaster.s_fun_funciones.nextval, 'Permite ver la notificacion de demandados antigua', 'TAB-NOTIFICACION-DEMANDADOS-MSV', 0, 'DD', sysdate, 0);

Insert into BANKMASTER.FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (bankmaster.s_fun_funciones.nextval, 'Permite ver la notificacion de demandados v4', 'TAB-NOTIFICACION-DEMANDADOS-v4', 0, 'DD', sysdate, 0);

COMMIT;
