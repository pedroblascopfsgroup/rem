--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=201600802
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG_ACA_CATASTRO_ACTIVO'
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
V_ESQUEMA_1 VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := '#ESQUEMA#'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ACA_CATASTRO_ACTIVO_BNK';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
	ACT_NUMERO_ACTIVO	   			NUMBER(16,0)                NOT NULL,  
	CAT_REF_CATASTRAL				VARCHAR2(50 CHAR),
	CAT_POLIGONO					VARCHAR2(50 CHAR),
	CAT_PARCELA						VARCHAR2(50 CHAR),
	CAT_TITULAR_CATASTRAL			VARCHAR2(250 CHAR),
	CAT_SUPERFICIE_CONSTRUIDA		NUMBER(16,2),
	CAT_SUPERFICIE_UTIL				NUMBER(16,2),
	CAT_SUPERFICIE_REPER_COMUN		NUMBER(16,2),
	CAT_SUPERFICIE_PARCELA			NUMBER(16,2),
	CAT_SUPERFICIE_SUELO			NUMBER(16,2),
	CAT_VALOR_CATASTRAL_CONST		NUMBER(16,2),
	CAT_VALOR_CATASTRAL_SUELO		NUMBER(16,2),
	CAT_FECHA_REV_VALOR_CATASTRAL	DATE,
	CAT_IND_INTERFAZ_BANKIA			VARCHAR2(1 CHAR)
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
