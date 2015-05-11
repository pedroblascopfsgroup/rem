set verify off;

define MASTER_SCHEMA = BANKMASTER;
 
 -- insertar permisos
 
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_CONTRATO_RECIBOS'),  
        (select pef_id from pef_perfiles where pef_id = 10000000000005), 'CARLOS', sysdate);
        
COMMIT;