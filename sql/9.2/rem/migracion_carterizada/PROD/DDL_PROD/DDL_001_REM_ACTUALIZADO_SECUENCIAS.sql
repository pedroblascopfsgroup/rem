--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20170616
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2264
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización de secuencias usadas en las tablas de volcado
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
V_ESQUEMA VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ACA_CABECERA';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
(
	ACT_NUMERO_ACTIVO	   		NUMBER(16,0)                NOT NULL,     
	ACT_NUMERO_UVEM				NUMBER(16,0),
	ACT_NUMERO_PRINEX			NUMBER(16,0),
	ACT_NUMERO_SAREB			VARCHAR2(55 CHAR),		
	ENTIDAD_PROPIETARIA			VARCHAR2(20 CHAR) 			NOT NULL,
	ENTIDAD_ORIGEN				VARCHAR2(25 CHAR),
	ENTIDAD_ORIGEN_ANTERIOR		VARCHAR2(20 CHAR),
	ACT_DESCRIPCION				VARCHAR2(250 CHAR),
	ACT_RATING					VARCHAR2(20 CHAR), 
	ACT_DIVISION_HORIZONTAL		NUMBER(1,0),
	ACT_FECHA_REV_CARGAS		DATE,
	ACT_CON_CARGAS				NUMBER(1,0),
	TIPO_ACTIVO					VARCHAR2(20 CHAR), 
	SUBTIPO_ACTIVO				VARCHAR2(20 CHAR), 
	ESTADO_ACTIVO				VARCHAR2(20 CHAR), 
	USO_ACTIVO					VARCHAR2(20 CHAR), 
	TIPO_TITULO					VARCHAR2(20 CHAR), 
	SUBTIPO_TITULO				VARCHAR2(20 CHAR), 
	ACT_VPO						NUMBER(1,0),
	ESTADO_ADMISION				NUMBER(1,0)					NOT NULL,
	ESTADO_GESTION				NUMBER(1,0)					NOT NULL,
	GESTION_HRE					NUMBER(1,0),
	SELLO_CALIDAD				NUMBER(1,0),
	SITUACION_COMERCIAL			VARCHAR2(20 CHAR)
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_MASTER != V_ESQUEMA THEN

EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_MASTER||'" WITH GRANT OPTION';

DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_MASTER||''); 

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
