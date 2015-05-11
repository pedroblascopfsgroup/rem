set verify off;

define MASTER_SCHEMA = &Introduce_el_master_schema;

SET DEFINE OFF;

Insert into &MASTER_SCHEMA..DD_TGE_TIPO_GESTOR
   (DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TGE_EDITABLE_WEB)
 Values
   (&MASTER_SCHEMA..s_dd_tge_tipo_gestor.nextval, 'GRECOBRO', 'Gestor recobro', 'Gestor recobro', 0, 'Óscar', sysdate, 0, 0);

COMMIT;


Insert into &MASTER_SCHEMA..FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (&MASTER_SCHEMA..s_fun_funciones.nextval, 'Permiso para poder ver acciones de un expediente', 'TAB_ACCIONES_EXP', 0, 'Óscar', sysdate, 0);



COMMIT;