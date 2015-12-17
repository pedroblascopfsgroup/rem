UPDATE HAYA02.DES_DESPACHO_EXTERNO SET  DD_TDE_ID = (select DD_TDE_ID from  HAYAMASTER.DD_TDE_TIPO_DESPACHO where DD_TDE_CODIGO  = 'GESTORIA_PREDOC'),
USUARIOMODIFICAR = 'JSV',FECHAMODIFICAR = sysdate WHERE des_despacho = 'Gestoría Preparación Documental 1';

insert into HAYA02.TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID,DD_TGE_ID,TGP_CLAVE,TGP_VALOR,USUARIOCREAR,FECHACREAR ) values (
 HAYA02.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval,
 (select DD_TGE_ID from HAYAMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO = 'SUP_PCO'),'DES_VALIDOS',
 'SUP_PCO'
 ,'JSV',sysdate);

--GESTORIA_PREDOC
insert into HAYA02.TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID,DD_TGE_ID,TGP_CLAVE,TGP_VALOR,USUARIOCREAR,FECHACREAR ) values (
 HAYA02.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval,
 (select DD_TGE_ID from HAYAMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO = 'GESTORIA_PREDOC'),'DES_VALIDOS',
 'GESTORIA_PREDOC'
 ,'JSV',sysdate);
 
-- revisar TGE

update hayamaster.dd_tge_tipo_gestor set 
       dd_tge_descripcion = 'Supervisor expediente judicial'
where dd_tge_codigo = 'SUP_PCO';

update hayamaster.dd_tge_tipo_gestor set 
       dd_tge_descripcion = 'CJ - Gestor de Estudio'
where dd_tge_codigo = 'CM_GE_PCO';

update hayamaster.dd_tge_tipo_gestor set 
       dd_tge_descripcion = 'CJ - Gestor de Documentación'
where dd_tge_codigo = 'CM_GD_PCO';

update hayamaster.dd_tge_tipo_gestor set 
       dd_tge_descripcion = 'CJ - Gestor de Liquidación'
where dd_tge_codigo = 'CM_GL_PCO';

update hayamaster.dd_tge_tipo_gestor set borrado = 0, fechaborrar = null, usuarioborrar = null,
       dd_tge_descripcion = 'CJ - Gestoría preparación documental'
where dd_tge_codigo = 'GESTORIA_PREDOC';

update hayamaster.dd_tge_tipo_gestor set 
       dd_tge_descripcion = 'Notaria'
where dd_tge_codigo = 'NOTARI';

update hayamaster.dd_tge_tipo_gestor set 
       dd_tge_descripcion = 'Archivo'
where dd_tge_codigo = 'ARCHIVO_PCO';

update hayamaster.dd_tge_tipo_gestor set 
       dd_tge_descripcion = 'Registro de la propiedad'
where dd_tge_codigo = 'REGPROP_PCO';

insert into hayamaster.dd_tge_tipo_gestor (dd_tge_id, dd_tge_codigo, dd_tge_descripcion, dd_tge_descripcion_larga, usuariocrear, fechacrear) values(
hayamaster.s_dd_tge_tipo_gestor.nextval, 'OFICINA', 'CJ - Oficina', 'CJ - Oficina', 'SAG', sysdate);

insert into HAYA02.TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID,DD_TGE_ID,TGP_CLAVE,TGP_VALOR,USUARIOCREAR,FECHACREAR ) values (
 HAYA02.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval,
 (select DD_TGE_ID from HAYAMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO = 'OFICINA'),'DES_VALIDOS',
 'OFICINA'
 ,'JSV',sysdate);

-- Revisar TDE y DES

delete from HAYA02.des_despacho_externo des where des.des_despacho = 'Despacho Oficina';

INSERT INTO HAYA02.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(HAYA02.s_des_despacho_externo.nextval,'Notaria',(SELECT dd_tde_id FROM hayamaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = 'NOTARI'),(SELECT MAX(zon_id) FROM HAYA02.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);
INSERT INTO HAYA02.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(HAYA02.s_des_despacho_externo.nextval,'Archivo',(SELECT dd_tde_id FROM hayamaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = 'ARCHIVO_PCO'),(SELECT MAX(zon_id) FROM HAYA02.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);
INSERT INTO HAYA02.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(HAYA02.s_des_despacho_externo.nextval,'Registro de la propiedad',(SELECT dd_tde_id FROM hayamaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = 'REGPROP_PCO'),(SELECT MAX(zon_id) FROM HAYA02.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);
INSERT INTO HAYA02.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(HAYA02.s_des_despacho_externo.nextval,'Oficinas',(SELECT dd_tde_id FROM hayamaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = 'OFICINA'),(SELECT MAX(zon_id) FROM HAYA02.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);

--creamos grupo
INSERT INTO hayamaster.usu_usuarios (usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES (hayamaster.s_usu_usuarios.nextval,1,'GRUPO-Notaria',null,'GRUPO-Notaria',1,1,'JSV',sysdate);
INSERT INTO hayamaster.usu_usuarios (usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES (hayamaster.s_usu_usuarios.nextval,1,'GRUPO-Archivo',null,'GRUPO-Archivo',1,1,'JSV',sysdate);
INSERT INTO hayamaster.usu_usuarios (usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES (hayamaster.s_usu_usuarios.nextval,1,'GRUPO-RegPropiedad',null,'GRUPO-RegPropiedad',1,1,'JSV',sysdate);
INSERT INTO hayamaster.usu_usuarios (usu_id,entidad_id,usu_username,usu_password,usu_nombre,usu_externo,usu_grupo,usuariocrear,fechacrear) VALUES (hayamaster.s_usu_usuarios.nextval,1,'GRUPO-Oficina',null,'GRUPO-Oficina',1,1,'JSV',sysdate);

--rel despacho con grupo
INSERT INTO HAYA02.USD_USUARIOS_DESPACHOS (USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES(HAYA02.s_usd_usuarios_despachos.nextval,(SELECT USU_ID FROM HAYAMASTER.USU_USUARIOS grupo WHERE grupo.USU_USERNAME ='GRUPO-Notaria'),(SELECT DES_ID FROM HAYA02.DES_DESPACHO_EXTERNO despa WHERE despa.DES_DESPACHO='Notaria' ),1,0,'JSV',sysdate);
INSERT INTO HAYA02.USD_USUARIOS_DESPACHOS (USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES(HAYA02.s_usd_usuarios_despachos.nextval,(SELECT USU_ID FROM HAYAMASTER.USU_USUARIOS grupo WHERE grupo.USU_USERNAME ='GRUPO-Archivo'),(SELECT DES_ID FROM HAYA02.DES_DESPACHO_EXTERNO despa WHERE despa.DES_DESPACHO='Archivo' ),1,0,'JSV',sysdate);
INSERT INTO HAYA02.USD_USUARIOS_DESPACHOS (USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES(HAYA02.s_usd_usuarios_despachos.nextval,(SELECT USU_ID FROM HAYAMASTER.USU_USUARIOS grupo WHERE grupo.USU_USERNAME ='GRUPO-RegPropiedad'),(SELECT DES_ID FROM HAYA02.DES_DESPACHO_EXTERNO despa WHERE despa.DES_DESPACHO='Registro de la propiedad' ),1,0,'JSV',sysdate);
INSERT INTO HAYA02.USD_USUARIOS_DESPACHOS (USD_ID,USU_ID,DES_ID,USD_GESTOR_DEFECTO,USD_SUPERVISOR,USUARIOCREAR,FECHACREAR) VALUES(HAYA02.s_usd_usuarios_despachos.nextval,(SELECT USU_ID FROM HAYAMASTER.USU_USUARIOS grupo WHERE grupo.USU_USERNAME ='GRUPO-Oficina'),(SELECT DES_ID FROM HAYA02.DES_DESPACHO_EXTERNO despa WHERE despa.DES_DESPACHO='Oficinas' ),1,0,'JSV',sysdate);

--creamos usuario generico
insert into hayamaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( hayamaster.s_usu_usuarios.nextval, (select ID from HAYAMASTER.ENTIDAD where DESCRIPCION = 'CAJAMAR'),'val.Notaria',null,'val.Notaria','','','' , 'JSV', sysdate, 0,0);
insert into hayamaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( hayamaster.s_usu_usuarios.nextval, (select ID from HAYAMASTER.ENTIDAD where DESCRIPCION = 'CAJAMAR'),'val.Archivo',null,'val.Archivo','','','' , 'JSV', sysdate, 0,0);
insert into hayamaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( hayamaster.s_usu_usuarios.nextval, (select ID from HAYAMASTER.ENTIDAD where DESCRIPCION = 'CAJAMAR'),'val.RegPropiedad',null,'val.RegPropiedad','','','' , 'JSV', sysdate, 0,0);
insert into hayamaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( hayamaster.s_usu_usuarios.nextval, (select ID from HAYAMASTER.ENTIDAD where DESCRIPCION = 'CAJAMAR'),'val.Oficina',null,'val.Oficina','','','' , 'JSV', sysdate, 0,0);

--relacionamos con despacho
insert into HAYA02.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (HAYA02.s_usd_usuarios_despachos.nextval,(select usu.usu_id from hayamaster.usu_usuarios usu where usu.usu_username = 'val.Notaria'), (select des.des_id from HAYA02.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Notaria'),0,0 , 'JSV', sysdate );
insert into HAYA02.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (HAYA02.s_usd_usuarios_despachos.nextval,(select usu.usu_id from hayamaster.usu_usuarios usu where usu.usu_username = 'val.Archivo'), (select des.des_id from HAYA02.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Archivo'),0,0 , 'JSV', sysdate );
insert into HAYA02.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (HAYA02.s_usd_usuarios_despachos.nextval,(select usu.usu_id from hayamaster.usu_usuarios usu where usu.usu_username = 'val.RegPropiedad'), (select des.des_id from HAYA02.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Registro de la propiedad'),0,0 , 'JSV', sysdate );
insert into HAYA02.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (HAYA02.s_usd_usuarios_despachos.nextval,(select usu.usu_id from hayamaster.usu_usuarios usu where usu.usu_username = 'val.Oficina'), (select des.des_id from HAYA02.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Oficinas'),0,0 , 'JSV', sysdate );

--relacionamos con grupo
INSERT INTO hayamaster.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (hayamaster.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from hayamaster.usu_usuarios usu where usu.usu_username = 'val.Notaria'), (SELECT usugrupo.usu_id FROM HAYA02.usd_usuarios_despachos usdgrupo INNER JOIN hayamaster.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GRUPO-Notaria' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO hayamaster.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (hayamaster.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from hayamaster.usu_usuarios usu where usu.usu_username = 'val.Archivo'), (SELECT usugrupo.usu_id FROM HAYA02.usd_usuarios_despachos usdgrupo INNER JOIN hayamaster.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GRUPO-Archivo' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO hayamaster.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (hayamaster.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from hayamaster.usu_usuarios usu where usu.usu_username = 'val.RegPropiedad'), (SELECT usugrupo.usu_id FROM HAYA02.usd_usuarios_despachos usdgrupo INNER JOIN hayamaster.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GRUPO-RegPropiedad' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO hayamaster.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (hayamaster.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from hayamaster.usu_usuarios usu where usu.usu_username = 'val.Oficina'), (SELECT usugrupo.usu_id FROM HAYA02.usd_usuarios_despachos usdgrupo INNER JOIN hayamaster.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GRUPO-Oficina' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );


-- configurar actores de precontencioso
update dd_pco_doc_solicit_tipoactor set dd_pco_dsa_trat_exp = 1;

update dd_pco_doc_solicit_tipoactor set dd_pco_dsa_acceso_recovery = 0 
where dd_pco_dsa_codigo in ('GESTORIA_PREDOC','NOTARI','REGPROP_PCO','ARCHIVO_PCO','OFICINA');

delete from dd_pco_doc_solicit_tipoactor where dd_pco_dsa_codigo = 'PREDOC';

insert into dd_pco_doc_solicit_tipoactor (DD_PCO_DSA_ID,DD_PCO_DSA_CODIGO,DD_PCO_DSA_DESCRIPCION,DD_PCO_DSA_DESCRIPCION_LARGA,DD_PCO_DSA_TRAT_EXP,DD_PCO_DSA_ACCESO_RECOVERY, USUARIOCREAR, FECHACREAR) values (
s_dd_pco_doc_solicit_actor.nextval, 'CM_GD_PCO', 'Gestor Documentacion', 'Gestor Documentacion', 1, 1, 'SAG', sysdate);

insert into dd_pco_doc_solicit_tipoactor (DD_PCO_DSA_ID,DD_PCO_DSA_CODIGO,DD_PCO_DSA_DESCRIPCION,DD_PCO_DSA_DESCRIPCION_LARGA,DD_PCO_DSA_TRAT_EXP,DD_PCO_DSA_ACCESO_RECOVERY, USUARIOCREAR, FECHACREAR) values (
s_dd_pco_doc_solicit_actor.nextval, 'CM_GL_PCO', 'Gestor Liquidacion', 'Gestor Liquidacion', 1, 1, 'SAG', sysdate);

insert into dd_pco_doc_solicit_tipoactor (DD_PCO_DSA_ID,DD_PCO_DSA_CODIGO,DD_PCO_DSA_DESCRIPCION,DD_PCO_DSA_DESCRIPCION_LARGA,DD_PCO_DSA_TRAT_EXP,DD_PCO_DSA_ACCESO_RECOVERY, USUARIOCREAR, FECHACREAR) values (
s_dd_pco_doc_solicit_actor.nextval, 'CM_GE_PCO', 'Gestor Estudio', 'Gestor Estudio', 1, 1, 'SAG', sysdate);