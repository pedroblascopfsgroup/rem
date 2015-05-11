set verify off;

define MASTER_SCHEMA = &Introduce_el_master_schema;

Insert into &MASTER_SCHEMA..FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (&MASTER_SCHEMA..s_fun_funciones.nextval, 'Permiso para poder buscar incidencias expediente', 'BUSCAR-INCIDENCIAS-EXPEDIENTE', 0, 'Óscar', sysdate, 0);


Insert into &MASTER_SCHEMA..FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (&MASTER_SCHEMA..s_fun_funciones.nextval, 'Permiso para poder buscar incidencias expediente', 'ALTA-INCIDENCIAS-EXPEDIENTE', 0, 'Óscar', sysdate, 0);


Insert into &MASTER_SCHEMA..FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (&MASTER_SCHEMA..s_fun_funciones.nextval, 'Permiso para poder buscar incidencias expediente', 'BORRAR-INCIDENCIAS-EXPEDIENTE', 0, 'Óscar', sysdate, 0);

Insert into &MASTER_SCHEMA..FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (&MASTER_SCHEMA..s_fun_funciones.nextval, 'Permiso que restringe la visibilidad', 'ES_PROVEEDOR', 0, 'Óscar', sysdate, 0);

Insert into PEF_PERFILES
   (PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO, PEF_ES_CARTERIZADO, DTYPE)
 Values
   (S_PEF_PERFILES.NEXTVAL, 'PROVEEDOR RECOBRO', 'PROVEEDOR', 0, 'Óscar', sysdate, 0, '10000000001301', 0, 'EXTPerfil');

Insert into &MASTER_SCHEMA..DD_TDE_TIPO_DESPACHO
   (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (71, '7', 'Despacho Proveedor Recobro', 'Despacho Proveedor Recobro', 0, 'Óscar', sysdate, 0);

 
CREATE SEQUENCE S_IEX_INCIDENCIA_EXPEDIENTE
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;
  
COMMIT;
