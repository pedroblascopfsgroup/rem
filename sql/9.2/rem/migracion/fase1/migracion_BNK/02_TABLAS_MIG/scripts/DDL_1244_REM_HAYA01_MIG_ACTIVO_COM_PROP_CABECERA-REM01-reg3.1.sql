--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=201600802
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG_CPC_PROP_CABECERA'
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REM01'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
V_TABLA VARCHAR2(40 CHAR) := 'MIG_CPC_PROP_CABECERA_BNK';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
	CPR_COD_COM_PROP_UVEM	   		VARCHAR2(10 CHAR)                NOT NULL,  
	CPR_CONSTITUIDA					NUMBER(1,0),
	CPR_NOMBRE						VARCHAR2(100 CHAR),
	CPR_NIF							VARCHAR2(20 CHAR),
	CPR_DIRECCION					VARCHAR2(250 CHAR),
	CPR_NUM_CUENTA					VARCHAR2(50 CHAR),
	CPR_PRESIDENTE_NOMBRE			VARCHAR2(100 CHAR),
	CPR_PRESIDENTE_TELF				VARCHAR2(20 CHAR),
	CPR_PRESIDENTE_TELF2			VARCHAR2(20 CHAR),
	CPR_PRESIDENTE_EMAIL			VARCHAR2(100 CHAR),
	CPR_PRESIDENTE_DIR				VARCHAR2(250 CHAR),
	CPR_FECHA_INI					DATE,
	CPR_FECHA_FIN					DATE,
	CPR_ADMINISTRADOR_NOMBRE		VARCHAR2(100 CHAR),
	CPR_ADMINISTRADOR_TELF			VARCHAR2(20 CHAR),
	CPR_ADMINISTRADOR_TELF2			VARCHAR2(20 CHAR),
	CPR_ADMINISTRADOR_DIR			VARCHAR2(250 CHAR),
	CPR_ADMINISTRADOR_EMAIL			VARCHAR2(100 CHAR),
	CPR_IMPORTEMEDIO				NUMBER(16,2),
	CPR_ESTATUTOS					NUMBER(1,0),
	CPR_LIBRO_EDIFICIO				NUMBER(1,0),
	CPR_CERTIFICADO_ITE				NUMBER(1,0),
	CPR_OBSERVACIONES				VARCHAR2(512 CHAR)
)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';

DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
