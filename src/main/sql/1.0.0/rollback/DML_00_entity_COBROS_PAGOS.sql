set verify off;

define MASTER_SCHEMA = &Introduce_el_master_schema;


DELETE FROM FUN_PEF WHERE FUN_ID = (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_COBROS_PAGOS_EXP');

DELETE FROM &MASTER_SCHEMA..FUN_FUNCIONES WHERE FUN_DESCRIPCION = 'TAB_COBROS_PAGOS_EXP';


COMMIT;
