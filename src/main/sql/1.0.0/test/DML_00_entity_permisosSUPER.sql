set verify off;

define MASTER_SCHEMA = &Introduce_el_master_schema;

Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_COBROS_PAGOS_EXP'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'BADR-681', sysdate, 0);

   
Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'CREAR_EXCEPCIONES_CLIENTE'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'BADR-479', sysdate, 0);

Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'CREAR_EXCEPCIONES_CONTRATO'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'BADR-480', sysdate, 0);

   
Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'VER_TAB_GESTORES_EXPEDIENTE'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'BADR-681', sysdate, 0);


Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'BUSCAR-INCIDENCIAS-EXPEDIENTE'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'Óscar', sysdate, 0);

   
Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ALTA-INCIDENCIAS-EXPEDIENTE'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'Óscar', sysdate, 0);

   
Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'BORRAR-INCIDENCIAS-EXPEDIENTE'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'Óscar', sysdate, 0);

Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ES_PROVEEDOR'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'Óscar', sysdate, 0);

Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ((select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_ACCIONES_EXP'), (select pef_id from pef_perfiles where pef_descripcion='SUPER ADMINISTRADOR'), S_FUN_PEF.NEXTVAL, 0, 'Óscar', sysdate, 0);

  
commit;