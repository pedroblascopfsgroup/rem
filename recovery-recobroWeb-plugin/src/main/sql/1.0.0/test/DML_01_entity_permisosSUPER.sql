set verify off;

define MASTER_SCHEMA = BANKMASTER;
define PERFIL = SPADM;
 
 -- insertar permisos
 
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_CICLORECOBRO_EXPEDIENTE'),  
        (select pef_id from pef_perfiles where pef_codigo = '&PERFIL.'), 'CARLOS', sysdate);
 
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_CICLORECOBRO_PERS_EXPEDIENTE'),  
        (select pef_id from pef_perfiles where pef_codigo = '&PERFIL.'), 'CARLOS', sysdate);
 
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_CICLORECOBRO_CNT_EXPEDIENTE'),  
        (select pef_id from pef_perfiles where pef_codigo = '&PERFIL.'), 'CARLOS', sysdate);
 
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_CICLORECOBRO_PERSONA'),  
        (select pef_id from pef_perfiles where pef_codigo = '&PERFIL.'), 'CARLOS', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'TAB_CICLORECOBRO_CONTRATO'),  
        (select pef_id from pef_perfiles where pef_codigo = '&PERFIL.'), 'CARLOS', sysdate);        
 
commit;