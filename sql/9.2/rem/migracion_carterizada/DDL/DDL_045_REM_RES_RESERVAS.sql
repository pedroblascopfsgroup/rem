--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-791
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_RES_RESERVAS'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_RES_RESERVAS';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
        RES_COD_NUM_RESERVA                             NUMBER(16,0)                NOT NULL,     
        RES_COD_OFERTA                                  NUMBER(16,0)                NOT NULL,     
        RES_FECHA_SOLICITUD                             DATE,
        RES_FECHA_FIRMA                                 DATE,
        RES_FECHA_VENCIMIENTO                   DATE,
        RES_FECHA_ANULACION                             DATE,
        RES_COD_MOTIVO_ANULACION                VARCHAR2(20 CHAR),
        RES_IND_IMP_ANULACION                   NUMBER(1,0),
        RES_IMPORTE_DEVUELTO                    NUMBER(16,2),
        RES_COD_TIPO_ARRA                               NUMBER(16,0),
        RES_COD_ESTADO_RESERVA                  NUMBER(16,0),
        RES_IMPORTE                                             NUMBER(16,2)                            NOT NULL,
        RES_FECHA_RESOLUCION                    DATE,
        RES_FECHA_AMPLIACION                    DATE
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
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
