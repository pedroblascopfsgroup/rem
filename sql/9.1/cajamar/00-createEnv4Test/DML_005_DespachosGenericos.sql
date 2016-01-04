--solicita doc
update CM01.DD_PCO_DOC_SOLICIT_TIPOACTOR set DD_PCO_DSA_CODIGO = 'GESTORIA_PREDOC' where DD_PCO_DSA_CODIGO = 'GEST';

--Despacho
INSERT INTO CM01.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(CM01.s_des_despacho_externo.nextval,'Gestoría Preparación Documental 1',(SELECT dd_tde_id FROM CMmaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = 'GESTORIA_PREDOC'),(SELECT MAX(zon_id) FROM CM01.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);
INSERT INTO CM01.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(CM01.s_des_despacho_externo.nextval,'Registro De La Propiedad',(SELECT dd_tde_id FROM CMmaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = 'REGPROP_PCO'),(SELECT MAX(zon_id) FROM CM01.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);
INSERT INTO CM01.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(CM01.s_des_despacho_externo.nextval,'Archivo',(SELECT dd_tde_id FROM CMmaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = 'ARCHIVO_PCO'),(SELECT MAX(zon_id) FROM CM01.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);
INSERT INTO CM01.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(CM01.s_des_despacho_externo.nextval,'Notaria',(SELECT dd_tde_id FROM CMmaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = 'NOTARI'),(SELECT MAX(zon_id) FROM CM01.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);

-- USUARIO
insert into CMmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMmaster.s_usu_usuarios.nextval, 1,'val.GestoriaPreoc','1234','Usuario Gestoría Preparación Documental 1','Gestoría Preparación Documental 1','','' , 'JSV', sysdate, 0,0);
insert into CMmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMmaster.s_usu_usuarios.nextval, 1,'val.RegistroPropiedad','1234','Usuario Registro Propiedad','Registro De La Propiedad','','' , 'JSV', sysdate, 0,0);
insert into CMmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMmaster.s_usu_usuarios.nextval, 1,'val.Archivo','1234','Usuario Archivo','Archivo','','' , 'JSV', sysdate, 0,0);
insert into CMmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMmaster.s_usu_usuarios.nextval, 1,'val.Notaria','1234','Usuario Notaria','Notaria','','' , 'JSV', sysdate, 0,0);

--USUARIO A DESOPACHO
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMmaster.usu_usuarios usu where usu.usu_username = 'val.GestoriaPreoc'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Gestoría Preparación Documental 1'),1,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMmaster.usu_usuarios usu where usu.usu_username = 'val.RegistroPropiedad'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Registro De La Propiedad'),1,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMmaster.usu_usuarios usu where usu.usu_username = 'val.Archivo'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Archivo'),1,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMmaster.usu_usuarios usu where usu.usu_username = 'val.Notaria'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Notaria'),1,0 , 'JSV', sysdate );

commit;
