set verify off;

define MASTER_SCHEMA = BANKMASTER;
 
 -- insertar permisos
 
 insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_VER_CARTERAS'),  
        (select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR'), 'BADR-120', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_CARTERAS'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);
 
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_CARTERASESQUEMA'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_REPARTOSUBCARTERAS'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_VER_METAS'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-178', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_METAS'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-178', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_VER_AGENCIAS'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_AGENCIAS'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_ESQUEMA'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_VER_ESQUEMA'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_VER_POLITICAS'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_POLITICA'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-120', sysdate);        
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_VER_RANKING'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-305', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_RANKING'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-305', sysdate);        
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_VER_FACTURACION'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-305', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_FACTURACION'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-305', sysdate);        
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_VER_PROC_FACTURACION'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-405', sysdate);
        
insert into fun_pef (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR) 
values (s_fun_pef.nextval, (select fun_id from &MASTER_SCHEMA..fun_funciones where fun_descripcion = 'ROLE_CONF_PROC_FACTURACION'),  
        ((select pef_id from pef_perfiles where pef_descripcion = 'SUPER ADMINISTRADOR')), 'BADR-405', sysdate);  
        
commit;