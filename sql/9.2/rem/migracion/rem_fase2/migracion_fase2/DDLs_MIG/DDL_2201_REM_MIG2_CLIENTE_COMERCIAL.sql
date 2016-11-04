--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-791
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_CLC_CLIENTE_COMERCIAL'
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
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_CLC_CLIENTE_COMERCIAL';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
        CLC_COD_CLIENTE_WEBCOM                  NUMBER(16,0)                NOT NULL,     
        CLC_COD_CLIENTE_HAYA                    NUMBER(16,0),
        CLC_COD_CLIENTE_UVEM                    NUMBER(16,0),
        CLC_RAZON_SOCIAL                                VARCHAR2(256 CHAR),             
        CLC_NOMBRE                                              VARCHAR2(256 CHAR),
        CLC_APELLIDOS                                   VARCHAR2(256 CHAR),
        CLC_FECHA_ALTA                                  DATE,
        CLC_COD_USUARIO_LDAP_ACCION             VARCHAR2(50 CHAR),
        CLC_COD_TIPO_DOCUMENTO                  VARCHAR2(20 CHAR),
        CLC_DOCUMENTO                                   VARCHAR2(50 CHAR),
        CLC_COD_TIPO_DOC_RTE                    VARCHAR2(20 CHAR),
        CLC_DOCUMENTO_RTE                               VARCHAR2(50 CHAR),
        CLC_TELEFONO1                                   VARCHAR2(50 CHAR),
        CLC_TELEFONO2                                   VARCHAR2(50 CHAR),
        CLC_EMAIL                                               VARCHAR2(50 CHAR),
        CLC_COD_TIPO_VIA                                VARCHAR2(20 CHAR),
        CLC_CLC_DIRECCION                               VARCHAR2(100 CHAR),
        CLC_NUMEROCALLE                                 VARCHAR2(100 CHAR),
        CLC_ESCALERA                                    VARCHAR2(10 CHAR),
        CLC_PLANTA                                              VARCHAR2(10 CHAR),
        CLC_PUERTA                                              VARCHAR2(10 CHAR),
        CLC_COD_LOCALIDAD                               VARCHAR2(20 CHAR),
        CLC_CODIGO_POSTAL                               VARCHAR2(5 CHAR),
        CLC_COD_UNIDADPOBLACIONAL               VARCHAR2(20 CHAR),
        CLC_COD_PROVINCIA                               VARCHAR2(20 CHAR),
        CLC_OBSERVACIONES                               VARCHAR2(256 CHAR)
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
