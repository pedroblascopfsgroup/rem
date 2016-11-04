--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-791
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_VIS_VISITAS'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_VIS_VISITAS';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
        VIS_COD_VISITA_WEBCOM                           NUMBER(16,0)                NOT NULL,     
        VIS_COD_CLIENTE_WEBCOM                          NUMBER(16,0)                            NOT NULL,
        VIS_ACT_NUMERO_ACTIVO                           NUMBER(16,0)                            NOT NULL,
        VIS_COD_ESTADO_VISITA                           VARCHAR2(20 CHAR),              
        VIS_COD_SUBESTADO_VISISTA                       VARCHAR2(20 CHAR),
        VIS_COD_PROCEDENCIA                                     VARCHAR2(20 CHAR),
        VIS_COD_SUBPROCEDENCIA                          VARCHAR2(20 CHAR),
        VIS_FECHA_SOLCITUD                                      DATE,
        VIS_FECHA_CONCERTACION                          DATE,
        VIS_FECHA_REAL_VISITA                           DATE,
        VIS_COD_PRESCRIPTOR_UVEM                        VARCHAR2(50 CHAR),
        VIS_IND_VISITA_PRESCRIPTOR                      NUMBER(1,0),
        VIS_COD_API_RESPONSABLE_UVEM            VARCHAR2(50 CHAR),
        VIS_IND_VISITA_API_RESPONSABLE          NUMBER(1,0),
        VIS_COD_API_CUSTODIO_UVEM                       VARCHAR2(50 CHAR),
        VIS_IND_VISITA_API_CUSTODIO                     NUMBER(1,0),
        VIS_COD_FVD_UVEM                                        VARCHAR2(50 CHAR),
        VIS_IND_VISITA_FVD                                      NUMBER(1,0),
        VIS_OBSERVACIONES                                       VARCHAR2(250 CHAR)
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
