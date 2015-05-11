set verify off;

define MASTER_SCHEMA = &Introduce_el_master_schema;

Insert into &MASTER_SCHEMA..FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (&MASTER_SCHEMA..s_fun_funciones.nextval, 'Permiso para poder ver cobros/pagos de un expediente', 'TAB_COBROS_PAGOS_EXP', 0, 'BADR-681', sysdate, 0);



COMMIT;
