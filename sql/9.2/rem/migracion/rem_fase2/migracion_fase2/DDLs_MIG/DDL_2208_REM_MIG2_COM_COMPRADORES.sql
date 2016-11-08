--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-791
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_COM_COMPRADORES'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_COM_COMPRADORES';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
        COM_COD_COMPRADOR                               NUMBER(16,0)                NOT NULL,     
        COM_COD_TIPO_PERSONA                    VARCHAR2(20 CHAR),     
        COM_NOMBRE                                              VARCHAR2(256 CHAR),
        COM_APELLIDOS                                   VARCHAR2(256 CHAR),
        COM_COD_TIPO_DOCUMENTO                  VARCHAR2(20 CHAR),
        COM_DOCUMENTO                                   VARCHAR2(50 CHAR),
        COM_COD_TIPO_DOC_REPRESENT              VARCHAR2(20 CHAR),
        COM_DOCUMENTO_RTE                               VARCHAR2(50 CHAR),
        COM_TELEFONO1                                   VARCHAR2(50 CHAR),
        COM_TELEFONO2                                   VARCHAR2(50 CHAR),
        COM_EMAIL                                               VARCHAR2(50 CHAR),
        COM_COD_TIPO_VIA                                VARCHAR2(20 CHAR),
        COM_DIRECCION                                   VARCHAR2(256 CHAR),
        COM_NUMEROCALLE                                 VARCHAR2(100 CHAR),
        COM_ESCALERA                                    VARCHAR2(10 CHAR),
        COM_PLANTA                                              VARCHAR2(10 CHAR),
        COM_PUERTA                                              VARCHAR2(10 CHAR),
        COM_COD_LOCALIDAD                               VARCHAR2(20 CHAR),
        COM_CODIGO_POSTAL                               VARCHAR2(5 CHAR),
        COM_COD_UNIDADPOBLACIONAL               VARCHAR2(20 CHAR),
        COM_COD_PROVINCIA                               VARCHAR2(20 CHAR)
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
