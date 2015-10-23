SET ECHO ON
WHENEVER SQLERROR EXIT ROLLBACK;

DEFINE master = &&ESQUEMA_MASTER

DELETE FROM ZON_PEF_USU WHERE USU_ID IN (SELECT USU_ID FROM &master .usu_usuarios WHERE USUARIOCREAR='PCOPrueba');
DELETE FROM &master .usu_usuarios WHERE USUARIOCREAR='PCOPrueba';
DELETE FROM ZON_PEF_USU WHERE USUARIOCREAR='PCOPrueba';
DELETE FROM TGP_TIPO_GESTOR_PROPIEDAD WHERE USUARIOCREAR='PCOPrueba';
DELETE FROM usd_usuarios_despachos WHERE USUARIOCREAR='PCOPrueba';
DELETE FROM DES_DESPACHO_EXTERNO WHERE USUARIOCREAR='PCOPrueba';
DELETE FROM &master .DD_TDE_TIPO_DESPACHO WHERE USUARIOCREAR='PCOPrueba';


/* DESPACHO APODERADO */

--Pasar esto a un DML
/*INSERT INTO &master .DD_TDE_TIPO_DESPACHO (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, USUARIOCREAR, FECHACREAR) 
	VALUES (1001, 'APOD', 'Apoderado', 'PCOPrueba', SYSDATE);
INSERT INTO TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID, DD_TGE_ID, TGP_CLAVE, TGP_VALOR, USUARIOCREAR, FECHACREAR) 
	VALUES (1001, (SELECT tg.dd_tge_id from &master .DD_TGE_TIPO_GESTOR tg where tg.dd_tge_codigo='APOD' ), 
	'DES_VALIDOS', 'APOD', 'PCOPrueba', SYSDATE);
INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (1001, 'Apoderado', 1001, 'PCOPrueba', SYSDATE);
*/
--DML hasta aquí

INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, 'Apoderado', (SELECT DD_TDE_ID FROM &master .DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = 'APOD'), 'PCOPrueba', SYSDATE);
	
INSERT INTO &master .usu_usuarios (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,
  		USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_EXTERNO,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,USU_FECHA_EXTRACCION,USU_BAJA_LDAP)
	VALUES (&master .s_usu_usuarios.nextval, 1, 'APODERADO', '1234', 'APODERADO', 'APODERADO', 'APODERADO', '111111111', 
		'my@email.com', 0, 'PCOPrueba', SYSDATE, 0, 1, TO_DATE('01/01/2017', 'dd/mm/yyyy'), 0, SYSDATE, 0);
-- EL APODERADO NO ACCEDE A RECOVERY
INSERT INTO ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR,	FECHACREAR, BORRADO, ZPU_FECHA_EXTRACCION)
	SELECT ZON_ID, PEF_ID, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='APODERADO'), S_ZON_PEF_USU.nextval, 
		0, 'PCOPrueba', SYSDATE, 0, ZPU_FECHA_EXTRACCION FROM ZON_PEF_USU WHERE ZPU_ID=10000000016501;

INSERT INTO usd_usuarios_despachos (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR) 
	VALUES (S_usd_usuarios_despachos.nextval, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='APODERADO'), (SELECT DES_ID FROM DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = 'Apoderado'), 1, 0, 'PCOPrueba', SYSDATE);


/* DESPACHO NOTARIO */

--Pasar esto a un DML
/*
INSERT INTO &master .DD_TGE_TIPO_GESTOR (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TGE_EDITABLE_WEB)
	SELECT &master .S_DD_TGE_TIPO_GESTOR.NEXTVAL, 'NOTARI', 'Notario', 'Notario', 'PCOPrueba', sysdate, 1 FROM DUAL;

INSERT INTO TGP_TIPO_GESTOR_PROPIEDAD  (TGP_ID, DD_TGE_ID, TGP_CLAVE, TGP_VALOR, USUARIOCREAR, FECHACREAR) 
	VALUES (20001, (SELECT tg.dd_tge_id from &master .DD_TGE_TIPO_GESTOR tg where tg.dd_tge_codigo='NOTARI' ), 
	'DES_VALIDOS', 'NOTARI', 'PCOPrueba', SYSDATE);
INSERT INTO &master .DD_TDE_TIPO_DESPACHO (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, USUARIOCREAR, FECHACREAR) 
	VALUES (20001, 'NOTARI', 'Notario', 'PCOPrueba', SYSDATE);
INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (20001, 'Notaría', 20001, 'PCOPrueba', SYSDATE);
*/
--DML hasta aquí


INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, 'Notaría', (SELECT DD_TDE_ID FROM &master .DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = 'NOTARI'), 'PCOPrueba', SYSDATE);

INSERT INTO &master .usu_usuarios (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,
  		USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_EXTERNO,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,USU_FECHA_EXTRACCION,USU_BAJA_LDAP)
	VALUES (&master .s_usu_usuarios.nextval, 1, 'NOTARIO', '1234', 'NOTARIO', 'NOTARIO', 'NOTARIO', '111111111', 
		'my@email.com', 0, 'PCOPrueba', SYSDATE, 0, 1, TO_DATE('01/01/2017', 'dd/mm/yyyy'), 0, SYSDATE, 0);
-- EL NOTARIO NO ACCEDE A RECOVERY
--INSERT INTO ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR,	FECHACREAR, BORRADO, ZPU_FECHA_EXTRACCION)
--	SELECT ZON_ID, PEF_ID, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='NOTARIO'), S_ZON_PEF_USU.nextval, 
--		0, 'PCOPrueba', SYSDATE, 0, ZPU_FECHA_EXTRACCION FROM ZON_PEF_USU WHERE ZPU_ID=10000000016501;
	
INSERT INTO usd_usuarios_despachos (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR) 
	VALUES (S_usd_usuarios_despachos.nextval, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='NOTARIO'), (SELECT DES_ID FROM DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = 'Notaría'), 1, 0, 'PCOPrueba', SYSDATE);


/* DESPACHO PREPARADOR DOCUMENTAL */

--Pasar esto a un DML
/*
INSERT INTO TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID, DD_TGE_ID, TGP_CLAVE, TGP_VALOR, USUARIOCREAR, FECHACREAR) 
	VALUES (30001, (SELECT tg.dd_tge_id from &master .DD_TGE_TIPO_GESTOR tg where tg.dd_tge_codigo='PREDOC' ), 
	'DES_VALIDOS', 'PREDOC', 'PCOPrueba', SYSDATE);
INSERT INTO &master .DD_TDE_TIPO_DESPACHO (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, USUARIOCREAR, FECHACREAR) 
	VALUES (30001, 'PREDOC', 'Preparador Documental', 'PCOPrueba', SYSDATE);
INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (30001, 'Preparador Documental', 30001, 'PCOPrueba', SYSDATE);
*/
--DML hasta aquí

INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, 'Preparador Documental', (SELECT DD_TDE_ID FROM &master .DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = 'PREDOC'), 'PCOPrueba', SYSDATE);
	
INSERT INTO &master .usu_usuarios (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,
  		USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_EXTERNO,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,USU_FECHA_EXTRACCION,USU_BAJA_LDAP)
	VALUES (&master .s_usu_usuarios.nextval, 1, 'PREDOC', '1234', 'PREDOC', 'PREDOC', 'PREDOC', '111111111', 
		'my@email.com', 0, 'PCOPrueba', SYSDATE, 0, 1, TO_DATE('01/01/2017', 'dd/mm/yyyy'), 0, SYSDATE, 0);
INSERT INTO ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR,	FECHACREAR, BORRADO, ZPU_FECHA_EXTRACCION)
	SELECT ZON_ID, PEF_ID, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='PREDOC'), S_ZON_PEF_USU.nextval, 
		0, 'PCOPrueba', SYSDATE, 0, ZPU_FECHA_EXTRACCION FROM ZON_PEF_USU WHERE ZPU_ID=10000000016501;
	--
INSERT INTO usd_usuarios_despachos (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR) 
	VALUES (S_usd_usuarios_despachos.nextval, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='PREDOC'), (SELECT DES_ID FROM DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = 'Preparador Documental'), 0, 0, 'PCOPrueba', SYSDATE);


/* DESPACHO GESTORIA PCO */

--Pasar esto a un DML
/*
INSERT INTO TGP_TIPO_GESTOR_PROPIEDAD (TGP_ID, DD_TGE_ID, TGP_CLAVE, TGP_VALOR, USUARIOCREAR, FECHACREAR) 
	VALUES (40001, (SELECT tg.dd_tge_id from &master .DD_TGE_TIPO_GESTOR tg where tg.dd_tge_codigo='GESTORIA_PREDOC' ), 
	'DES_VALIDOS', 'GEST_PCO', 'PCOPrueba', SYSDATE);
INSERT INTO &master .DD_TDE_TIPO_DESPACHO (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, USUARIOCREAR, FECHACREAR) 
	VALUES (40001, 'GEST_PCO', 'Gestoria de Precontencioso', 'PCOPrueba', SYSDATE);
INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (40001, 'Gestoria de Precontencioso', 40001, 'PCOPrueba', SYSDATE);
*/
--DML hasta aquí
INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, 'Gestoria de Precontencioso', (SELECT DD_TDE_ID FROM &master .DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = 'GESTORIA_PREDOC'), 'PCOPrueba', SYSDATE);

INSERT INTO &master .usu_usuarios (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,
  		USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_EXTERNO,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,USU_FECHA_EXTRACCION,USU_BAJA_LDAP)
	VALUES (&master .s_usu_usuarios.nextval, 1, 'GEST_PCO', '1234', 'GEST_PCO', 'GEST_PCO', 'GEST_PCO', '111111111', 
		'my@email.com', 0, 'PCOPrueba', SYSDATE, 0, 1, TO_DATE('01/01/2017', 'dd/mm/yyyy'), 0, SYSDATE, 0);
INSERT INTO ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR,	FECHACREAR, BORRADO, ZPU_FECHA_EXTRACCION)
	SELECT ZON_ID, PEF_ID, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='GEST_PCO'), S_ZON_PEF_USU.nextval, 
		0, 'PCOPrueba', SYSDATE, 0, ZPU_FECHA_EXTRACCION FROM ZON_PEF_USU WHERE ZPU_ID=10000000016501;
	
INSERT INTO usd_usuarios_despachos (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR) 
	VALUES (S_usd_usuarios_despachos.nextval, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='GEST_PCO'), (SELECT DES_ID FROM DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = 'Gestoria de Precontencioso'), 1, 0, 'PCOPrueba', SYSDATE);


/* LETRADO */

--Pasar esto a un DML
/*
UPDATE TGP_TIPO_GESTOR_PROPIEDAD SET TGP_VALOR=TGP_VALOR||',LET_PCO' 
	WHERE  DD_TGE_ID=(SELECT tg.dd_tge_id from &master .DD_TGE_TIPO_GESTOR tg where tg.dd_tge_codigo='LETR');

INSERT INTO &master .DD_TDE_TIPO_DESPACHO (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, USUARIOCREAR, FECHACREAR) 
	VALUES (50001, 'LET_PCO', 'Letrado Precontencioso', 'PCOPrueba', SYSDATE);
INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (50001, 'Letrado Precontencioso', 50001, 'PCOPrueba', SYSDATE);
*/
--DML hasta aquí

INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, 'Letrado Precontencioso', (SELECT DD_TDE_ID FROM &master .DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = 'LET_PCO'), 'PCOPrueba', SYSDATE);
	
INSERT INTO &master .usu_usuarios (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,
  		USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_EXTERNO,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,USU_FECHA_EXTRACCION,USU_BAJA_LDAP)
	VALUES (&master .s_usu_usuarios.nextval, 1, 'LET_PCO', '1234', 'LET_PCO', 'LET_PCO', 'LET_PCO', '111111111', 
		'my@email.com', 0, 'PCOPrueba', SYSDATE, 0, 1, TO_DATE('01/01/2017', 'dd/mm/yyyy'), 0, SYSDATE, 0);
INSERT INTO ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR,	FECHACREAR, BORRADO, ZPU_FECHA_EXTRACCION)
	SELECT ZON_ID, PEF_ID, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='LET_PCO'), S_ZON_PEF_USU.nextval, 
		0, 'PCOPrueba', SYSDATE, 0, ZPU_FECHA_EXTRACCION FROM ZON_PEF_USU WHERE ZPU_ID=10000000016501;

INSERT INTO usd_usuarios_despachos (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR) 
	VALUES (S_usd_usuarios_despachos.nextval, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='LET_PCO'), (SELECT DES_ID FROM DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = 'Letrado Precontencioso'), 1, 0, 'PCOPrueba', SYSDATE);

/* SUPERVISOR */
INSERT into &master .DD_TDE_TIPO_DESPACHO (DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (&master .S_DD_TDE_TIPO_DESPACHO.nextval,'SUP_PCO','Supervisor de precontencioso','Supervisor de precontencioso','0','PCO',sysdate,null,null,null,null,'0');

INSERT INTO DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, DD_TDE_ID, USUARIOCREAR, FECHACREAR) 
	VALUES (S_DES_DESPACHO_EXTERNO.NEXTVAL, 'Supervisor Precontencioso', (SELECT DD_TDE_ID FROM &master .DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = 'SUP_PCO'), 'PCOPrueba', SYSDATE);
	
INSERT INTO &master .usu_usuarios (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,
  		USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_EXTERNO,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,USU_FECHA_EXTRACCION,USU_BAJA_LDAP)
	VALUES (&master .s_usu_usuarios.nextval, 1, 'SUP_PCO', '1234', 'SUP_PCO', 'SUP_PCO', 'SUP_PCO', '111111111', 
		'my@email.com', 0, 'PCOPrueba', SYSDATE, 0, 1, TO_DATE('01/01/2017', 'dd/mm/yyyy'), 0, SYSDATE, 0);
INSERT INTO ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR,	FECHACREAR, BORRADO, ZPU_FECHA_EXTRACCION)
	SELECT ZON_ID, PEF_ID, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='SUP_PCO'), S_ZON_PEF_USU.nextval, 
		0, 'PCOPrueba', SYSDATE, 0, ZPU_FECHA_EXTRACCION FROM ZON_PEF_USU WHERE ZPU_ID=10000000016501;

INSERT INTO usd_usuarios_despachos (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR) 
	VALUES (S_usd_usuarios_despachos.nextval, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='SUP_PCO'), (SELECT DES_ID FROM DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = 'Supervisor Precontencioso'), 1, 0, 'PCOPrueba', SYSDATE);

/* PROCURADOR */

INSERT INTO &master .usu_usuarios (USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,
  		USU_MAIL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_EXTERNO,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,USU_FECHA_EXTRACCION,USU_BAJA_LDAP)
	VALUES (&master .s_usu_usuarios.nextval, 1, 'PROCURADOR', '1234', 'PROCURADOR', 'PROCURADOR', 'PROCURADOR', '111111111', 
		'my@email.com', 0, 'PCOPrueba', SYSDATE, 0, 1, TO_DATE('01/01/2017', 'dd/mm/yyyy'), 0, SYSDATE, 0);
INSERT INTO ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR,	FECHACREAR, BORRADO, ZPU_FECHA_EXTRACCION)
	SELECT ZON_ID, PEF_ID, (SELECT USU_ID FROM &master .usu_usuarios WHERE USU_USERNAME='PROCURADOR'), S_ZON_PEF_USU.nextval, 
		0, 'PCOPrueba', SYSDATE, 0, ZPU_FECHA_EXTRACCION FROM ZON_PEF_USU WHERE ZPU_ID=10000000016501;

COMMIT;