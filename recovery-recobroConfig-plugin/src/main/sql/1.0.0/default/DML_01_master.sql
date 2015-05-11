
INSERT INTO dd_tde_tipo_despacho
    (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
VALUES (S_dd_tde_tipo_despacho.nextval, 'AGER', 'Agencia de recobro', 'Agencia de recobro', '0', 'SAG', sysdate, '0');

commit;

-- ROLES DE AGENCIAS

Insert into FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_FUN_FUNCIONES.nextVal, 'Ver menu configuracion de Agencias', 'ROLE_VER_AGENCIAS', 0, 'DIANA', sysdate, 0);

Insert into FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_FUN_FUNCIONES.nextVal, 'Modificación de Agencias', 'ROLE_CONF_AGENCIAS', 0, 'DIANA', sysdate, 0);
   
-- ROLES DE CARTERAS  

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_VER_CARTERAS', 'Permite ver el menú de carteras',0,'BADR-120',sysdate,0);   
   
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_CARTERAS', 'Permite la configuración de carteras',0,'BADR-120',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_CARTERASESQUEMA', 'Permite grabar/Modificar las carteras del esquema',0,'BADR-182',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_REPARTOSUBCARTERAS', 'Permite grabar/Modificar las subcarteras del esquema',0,'BADR-182',sysdate,0);

-- roles de esquemas 

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_VER_ESQUEMA', 'Permite ver el menú de esquemas de agencias',0,'DIANA',sysdate,0);   
   
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_ESQUEMA', 'Permite la configuración de esquemas de agencias',0,'DIANA',sysdate,0);

-- ROLES DE ITINERARIOS METAS VOLANTES  

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_VER_METAS', 'Permite ver el menú de metas volantes',0,'BADR-178',sysdate,0);   
   
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_METAS', 'Permite la configuración de metas volantes',0,'BADR-178',sysdate,0);


-- ROLES DE MODELOS RANKING  

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_VER_RANKING', 'Permite ver el menú de Modelos de Ranking',0,'BADR-305',sysdate,0);   
   
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_RANKING', 'Permite la configuración de Modelos de Ranking',0,'BADR-305',sysdate,0);


-- ROLES DE MODELOS DE FACTURACION  

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_VER_FACTURACION', 'Permite ver el menú de modelos de facturación',0,'BADR-305',sysdate,0);   
   
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_FACTURACION', 'Permite la configuración de modelos de facturación',0,'BADR-305',sysdate,0);

-- ROLES DE PROCESOS DE FACTURACION  

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_VER_PROC_FACTURACION', 'Permite ver el menú de procesos de facturación',0,'BADR-405',sysdate,0);   
   
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_PROC_FACTURACION', 'Permite la configuración de procesos de facturación',0,'BADR-405',sysdate,0);

-- ROLES DE POLITICAS
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_POLITICA', 'Permite editar modelos de políticas',0,'BADR-178',sysdate,0);   

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_VER_POLITICAS', 'Permite ver el menú de políticas de acuerdo',0,'BADR-178',sysdate,0);  
        
commit;        