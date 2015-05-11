set verify off;

define MASTER_SCHEMA = &Introduce_el_master_schema;

Insert into &MASTER_SCHEMA..FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (&MASTER_SCHEMA..s_fun_funciones.nextval, 'Permiso para poder exceptuar personas', 'CREAR_EXCEPCIONES_CLIENTE', 0, 'BADR-479', sysdate, 0);

Insert into &MASTER_SCHEMA..FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (&MASTER_SCHEMA..s_fun_funciones.nextval, 'Permiso para poder exceptuar contratos', 'CREAR_EXCEPCIONES_CONTRATO', 0, 'BADR-480', sysdate, 0);



CREATE SEQUENCE S_EXC_EXCEPTUACION
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;
  
  Insert into DD_MOE_MOTIVO_EXCEPTUACION
   (DD_MOE_ID, DD_MOE_CODIGO, DD_MOE_DESCRIPCION, DD_MOE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (1, '01', 'Decisión gestor', 'Decisión gestor', 0, 'BADR-479', sysdate, 0);

   commit;