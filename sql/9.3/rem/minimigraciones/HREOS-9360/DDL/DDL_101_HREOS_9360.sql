--/*
--#########################################
--## AUTOR=José Antonio Gigante
--## FECHA_CREACION=20200205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9360
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_INSERTA_LLAVES_ACTIVO'
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
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'AUX_INSERTA_LLAVES_ACTIVO';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE 
'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||
'(
	ACT_NUM_ACTIVO                  VARCHAR(20 CHAR),
    LLV_NUM_LLAVE                   VARCHAR(20 CHAR),
    LLV_CODE                        VARCHAR(64 CHAR),
    DD_TTE_CODIGO_TENEDOR           VARCHAR(20 CHAR),
    LLV_COD_TENEDOR                 VARCHAR(100 CHAR),
    LLV_FECHA_ANILLADO              VARCHAR(20 CHAR),
    LLV_FECHA_RECEPCION             VARCHAR(20 CHAR),
    LLV_COMPLETO                    VARCHAR(20 CHAR),
    LLV_OBSERVACIONES               VARCHAR(100 CHAR),
    LLV_COD_TENEDOR_NO_PVE          VARCHAR(100 CHAR)
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

