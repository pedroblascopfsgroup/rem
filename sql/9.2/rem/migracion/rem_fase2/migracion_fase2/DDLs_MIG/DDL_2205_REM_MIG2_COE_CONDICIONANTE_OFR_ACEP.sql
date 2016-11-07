--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-791
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_COE_CONDICIONAN_OFR_ACEP'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_COE_CONDICIONAN_OFR_ACEP';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
        COE_COD_OFERTA                                                  NUMBER(16,0)                NOT NULL,     
        COE_SOLICITA_FINANCIACION                               NUMBER(1,0),     
        COE_ENTIDAD_FINANCIACION_AJENA                  VARCHAR2(50 CHAR),
        COE_COD_TIPO_CALCULO                                    VARCHAR2(20 CHAR),
    COE_PORCENTAJE_RESERVA                                      NUMBER(16,2),
        COE_PLAZO_FIRMA_RESERVA                                 NUMBER(16,0),
        COE_IMPORTE_RESERVA                                             NUMBER(16,2),
        COE_COD_TIPO_IMPUESTO                                   VARCHAR2(20 CHAR),
        COE_TIPO_APLICABLE                                              NUMBER(16,2),
        COE_IND_RENUNCIA_EXENCION                               NUMBER(1,0),
        COE_IND_RESERVA_CON_IMPUESTO                    NUMBER(1,0),
        COE_GASTOS_PLUSVALIA                                    NUMBER(16,2),
        COE_COD_TIPO_PORCTA_PLUSVALIA                   VARCHAR2(20 CHAR),
        COE_GASTOS_NOTARIA                                              NUMBER(16,2),
        COE_COD_TIPO_PORCTA_NOTARIA                             VARCHAR2(20 CHAR),
        COE_GASTOS_OTROS                                                NUMBER(16,2),
        COE_COD_TIPO_PORCTA_OTROS                               VARCHAR2(20 CHAR),
        COE_FECHA_ACTUALIZACION_CARGAS                  DATE,
        COE_CARGAS_IMPUESTOS                                    NUMBER(16,2),
        COE_COD_TIPO_CARGAS_IMPUESTOS                   VARCHAR2(20 CHAR),
        COE_CARGAS_COMUNIDAD                                    NUMBER(16,2),
        COE_COD_TIPO_CARGAS_COMUNIDAD                   VARCHAR2(20 CHAR),
        COE_COE_CARGAS_OTROS                                    NUMBER(16,2),
        COE_COD_TIPO_CARGAS_OTROS                               VARCHAR2(20 CHAR),
        COE_IND_SUJETO_TANTEO_RETRACTO                  NUMBER(1,0),
        COE_IND_RENUNCIA_SNMTO_EVICCI                   NUMBER(1,0),
        COE_IND_RENUNCIA_SNMTO_VICIO                    NUMBER(1,0),
        COE_IND_VPO                                                             NUMBER(1,0),
        COE_IND_LICENCIA                                                NUMBER(1,0),
        COE_COD_TIPO_LICENCIA                                   VARCHAR2(20 CHAR),
        COE_IND_PROCEDE_DESCALIFICA                             NUMBER(1,0),
        COE_COD_SITUACION_POSESORIA                             VARCHAR2(20 CHAR),
        COE_COD_ESTADO_TITULO                                   VARCHAR2(20 CHAR),
        COE_IND_POSESION_INICIAL                                NUMBER(1,0)     
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
