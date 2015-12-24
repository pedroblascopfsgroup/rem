-- actualizar la configuraci�n para utilizar los TGE SUP y GEXT

-- GEXT

update hayamaster.dd_sta_subtipo_tarea_base  set dd_tge_id = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEXT'), usuariomodificar = 'SAG', fechamodificar = sysdate
where dd_tge_id = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CJ-LETR');

update hayamaster.dd_tge_tipo_gestor set borrado = 1, usuarioborrar = 'SAG', fechaborrar = sysdate
where dd_tge_codigo = 'CJ-LETR';

delete from TGP_TIPO_GESTOR_PROPIEDAD tgp where dd_tge_id = (select dd_tge_id from hayamaster.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'GEXT');

insert into TGP_TIPO_GESTOR_PROPIEDAD tgp (tgp.TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values 
(s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (select dd_tge_id from hayamaster.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'GEXT'),
 'DES_VALIDOS', (select tde.dd_tde_codigo from hayamaster.dd_tde_tipo_despacho tde where tde.dd_tde_codigo = 'D-CJ-LETR'),
 'SAG', sysdate);
 
update des_despacho_externo set dd_tde_id = (select dd_tde_id from hayamaster.dd_tde_tipo_despacho where dd_tde_codigo = 'D-CJ-LETR'), usuariomodificar = 'SAG', fechamodificar = sysdate
where des_despacho = 'Despacho Letrado';

-- SUP

update hayamaster.dd_sta_subtipo_tarea_base  set dd_tge_id = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP'), usuariomodificar = 'SAG', fechamodificar = sysdate
where dd_tge_id = (select dd_tge_id from hayamaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCONGE');

update hayamaster.dd_tge_tipo_gestor set borrado = 1, usuarioborrar = 'SAG', fechaborrar = sysdate
where dd_tge_codigo = 'SUCONGE';

delete from TGP_TIPO_GESTOR_PROPIEDAD tgp where dd_tge_id = (select dd_tge_id from hayamaster.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'SUP');

insert into TGP_TIPO_GESTOR_PROPIEDAD tgp (tgp.TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values 
(s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (select dd_tge_id from hayamaster.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'SUP'),
 'DES_VALIDOS', (select tde.dd_tde_codigo from hayamaster.dd_tde_tipo_despacho tde where tde.dd_tde_codigo = 'D-SUCONGE'),
 'SAG', sysdate);
 
UPDATE TAP_TAREA_PROCEDIMIENTO tap SET tap.DD_TSUP_ID = (select dd_tge_id from hayamaster.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'SUP'), usuariomodificar = 'SAG', fechamodificar = sysdate WHERE tap.DD_TSUP_ID = (select dd_tge_id from hayamaster.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'SUCONGE'); 
 
-- insertar usuario administrador
insert into hayamaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( hayamaster.s_usu_usuarios.nextval, (select ID from HAYAMASTER.ENTIDAD where DESCRIPCION = 'CAJAMAR'),'HAYACAJAMAR','1234','HAYACAJAMAR','','','' , 'JSV', sysdate, 0,0);

insert into HAYA02.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id,  zpu.usu_id,zpu.pef_id, zpu.usuariocrear, zpu.fechacrear)values ( HAYA02.s_zon_pef_usu.nextval, (select max(zon_id) from HAYA02.zon_zonificacion where zon_cod ='01'),(SELECT usu_id FROM hayamaster.usu_usuarios WHERE usu_username = 'HAYACAJAMAR'),(SELECT pef_id FROM HAYA02.pef_perfiles WHERE pef_codigo = 'HAYAADMIN'),'JSV', sysdate); 

-- actualizar algunos TGE

update hayamaster.dd_tge_tipo_gestor set dd_tge_descripcion = 'CJ - Supervisor Asesor�a jur�dica', dd_tge_descripcion_larga = 'CJ - Supervisor Asesor�a jur�dica' where dd_tge_codigo = 'SAJUR';

update hayamaster.dd_tge_tipo_gestor set dd_tge_descripcion = 'CJ - Supervisor HRE gesti�n llaves', dd_tge_descripcion_larga = 'CJ - Supervisor HRE gesti�n llaves', borrado = 0, usuarioborrar = null, fechaborrar = null where dd_tge_codigo = 'SPGL';

update hayamaster.dd_tge_tipo_gestor set borrado = 1, usuarioborrar = 'SAG', fechaborrar = sysdate where dd_tge_codigo in ('CJ-GESEXT','CJ-SUEXT');
