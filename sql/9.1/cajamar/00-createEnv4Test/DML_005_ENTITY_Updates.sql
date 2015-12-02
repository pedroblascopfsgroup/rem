INSERT INTO CM01.FUN_PEF ( FUN_ID,PEF_ID,FP_ID,USUARIOCREAR,FECHACREAR ) VALUES ((SELECT FUN_ID FROM CMMASTER.FUN_FUNCIONES WHERE BORRADO = 0  AND FUN_DESCRIPCION = 'TAB_PRECONTENCIOSO_LIQ_BTN'),(SELECT PEF_ID FROM CM01.PEF_PERFILES WHERE BORRADO = 0  AND PEF_DESCRIPCION = 'Gestor Interno'),  CM01.S_FUN_PEF.nextval,  'JSV',SYSDATE);
INSERT INTO CM01.FUN_PEF ( FUN_ID,PEF_ID,FP_ID,USUARIOCREAR,FECHACREAR ) VALUES ((SELECT FUN_ID FROM CMMASTER.FUN_FUNCIONES WHERE BORRADO = 0  AND  FUN_DESCRIPCION = 'TAB_PRECONTENCIOSO_DOC_BTN'),(SELECT PEF_ID FROM CM01.PEF_PERFILES WHERE BORRADO = 0  AND  PEF_DESCRIPCION = 'Gestor Interno'), CM01.S_FUN_PEF.nextval,'JSV',SYSDATE);
INSERT INTO CM01.FUN_PEF ( FUN_ID,PEF_ID,FP_ID,USUARIOCREAR,FECHACREAR ) VALUES ( (SELECT FUN_ID FROM CMMASTER.FUN_FUNCIONES WHERE BORRADO = 0  AND FUN_DESCRIPCION = 'TAB_PRECONTENCIOSO_BUR_BTN'), (SELECT PEF_ID FROM CM01.PEF_PERFILES WHERE BORRADO = 0  AND PEF_DESCRIPCION = 'Gestor Interno'), CM01.S_FUN_PEF.nextval,'JSV',SYSDATE);
INSERT INTO CM01.FUN_PEF ( FUN_ID,PEF_ID,FP_ID,USUARIOCREAR,FECHACREAR ) VALUES ((SELECT FUN_ID FROM CMMASTER.FUN_FUNCIONES WHERE BORRADO = 0  AND FUN_DESCRIPCION = 'TAB_PRECONTENCIOSO_LIQ_BTN'), (SELECT PEF_ID FROM CM01.PEF_PERFILES WHERE BORRADO = 0  AND PEF_DESCRIPCION = 'Precontencioso'), CM01.S_FUN_PEF.nextval, 'JSV',SYSDATE);
INSERT INTO CM01.FUN_PEF ( FUN_ID,PEF_ID,FP_ID,USUARIOCREAR,FECHACREAR ) VALUES (  (SELECT FUN_ID FROM CMMASTER.FUN_FUNCIONES WHERE BORRADO = 0  AND FUN_DESCRIPCION = 'TAB_PRECONTENCIOSO_DOC_BTN'),(SELECT PEF_ID FROM CM01.PEF_PERFILES WHERE BORRADO = 0  AND PEF_DESCRIPCION = 'Precontencioso'), CM01.S_FUN_PEF.nextval, 'JSV',SYSDATE);
INSERT INTO CM01.FUN_PEF ( FUN_ID,PEF_ID,FP_ID,USUARIOCREAR,FECHACREAR ) VALUES ( (SELECT FUN_ID FROM CMMASTER.FUN_FUNCIONES WHERE BORRADO = 0  AND FUN_DESCRIPCION = 'TAB_PRECONTENCIOSO_BUR_BTN'),(SELECT PEF_ID FROM CM01.PEF_PERFILES WHERE BORRADO = 0  AND PEF_DESCRIPCION = 'Precontencioso'), CM01.S_FUN_PEF.nextval, 'JSV',SYSDATE);
--usuarios a despachos correctos
UPDATE CM01.USD_USUARIOS_DESPACHOS usd SET usd.USU_ID = (select usu.USU_ID from CMMASTER.USU_USUARIOS usu where usu.USU_USERNAME = 'val.gestliquidaciones'),usd.USUARIOMODIFICAR = 'JSV',usd.FECHAMODIFICAR = sysdate WHERE des_id = (select DES_ID from CM01.DES_DESPACHO_EXTERNO where DES_DESPACHO = 'Precontencioso - Gestor de liquidación');
UPDATE CM01.USD_USUARIOS_DESPACHOS usd SET usd.USU_ID = (select usu.USU_ID from CMMASTER.USU_USUARIOS usu where usu.USU_USERNAME = 'val.gestdocumentacion'),usd.USUARIOMODIFICAR = 'JSV',usd.FECHAMODIFICAR = sysdate WHERE usd.des_id = (select des.DES_ID from CM01.DES_DESPACHO_EXTERNO des where des.DES_DESPACHO = 'Precontencioso - Gestor de documentación');

UPDATE CM01.GAA_GESTOR_ADICIONAL_ASUNTO SET
DD_TGE_ID = (SELECT DD_TGE_ID FROM CMMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO = 'CM_GL_PCO'),
USUARIOMODIFICAR= 'JSV',
FECHAMODIFICAR = sysdate
WHERE USD_ID = (select usd.usd_id from CM01.USD_USUARIOS_DESPACHOS usd where usd.USU_ID = (select usu.USU_ID from CMMASTER.USU_USUARIOS usu where usu.USU_USERNAME = 'val.gestliquidaciones') and des_id = (select DES_ID from CM01.DES_DESPACHO_EXTERNO where DES_DESPACHO = 'Precontencioso - Gestor de liquidación'));

UPDATE CM01.GAA_GESTOR_ADICIONAL_ASUNTO SET
DD_TGE_ID = (SELECT DD_TGE_ID FROM CMMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO = 'CM_GD_PCO'),
USUARIOMODIFICAR= 'JSV',
FECHAMODIFICAR = sysdate
WHERE USD_ID = (select usd.usd_id from CM01.USD_USUARIOS_DESPACHOS usd where usd.USU_ID = (select usu.USU_ID from CMMASTER.USU_USUARIOS usu where usu.USU_USERNAME = 'val.gestdocumentacion')and usd.des_id = (select des.DES_ID from CM01.DES_DESPACHO_EXTERNO des where des.DES_DESPACHO = 'Precontencioso - Gestor de documentación'));


UPDATE CM01.GAH_GESTOR_ADICIONAL_HISTORICO SET
GAH_TIPO_GESTOR_ID = (SELECT DD_TGE_ID FROM CMMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO = 'CM_GL_PCO'),
USUARIOMODIFICAR= 'JSV',
FECHAMODIFICAR = sysdate
WHERE GAH_GESTOR_ID = (select usd.usd_id from CM01.USD_USUARIOS_DESPACHOS usd where usd.USU_ID = (select usu.USU_ID from CMMASTER.USU_USUARIOS usu where usu.USU_USERNAME = 'val.gestliquidaciones') and des_id = (select DES_ID from CM01.DES_DESPACHO_EXTERNO where DES_DESPACHO = 'Precontencioso - Gestor de liquidación'));

UPDATE CM01.GAH_GESTOR_ADICIONAL_HISTORICO SET
GAH_TIPO_GESTOR_ID = (SELECT DD_TGE_ID FROM CMMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO = 'CM_GD_PCO'),
USUARIOMODIFICAR= 'JSV',
FECHAMODIFICAR = sysdate
WHERE GAH_GESTOR_ID = (select usd.usd_id from CM01.USD_USUARIOS_DESPACHOS usd where usd.USU_ID = (select usu.USU_ID from CMMASTER.USU_USUARIOS usu where usu.USU_USERNAME = 'val.gestdocumentacion')and usd.des_id = (select des.DES_ID from CM01.DES_DESPACHO_EXTERNO des where des.DES_DESPACHO = 'Precontencioso - Gestor de documentación'));


insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMmaster.usu_usuarios usu where usu.usu_username = 'val.gestdocumentacion'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Precontencioso - Gestor de documentación'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMmaster.usu_usuarios usu where usu.usu_username = 'val.gestliquidaciones'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Precontencioso - Gestor de liquidación'),0,0 , 'JSV', sysdate );

COMMIT;
