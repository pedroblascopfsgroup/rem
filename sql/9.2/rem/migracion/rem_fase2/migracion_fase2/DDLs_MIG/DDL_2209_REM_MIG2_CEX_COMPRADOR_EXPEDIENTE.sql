--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-791
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_CEX_COMPRADOR_EXPEDIENTE'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_CEX_COMPRADOR_EXPEDIENTE';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
        CEX_COD_OFERTA                                          NUMBER(16,0)                NOT NULL,     
        CEX_COD_COMPRADOR                                       NUMBER(16,0)                            NOT NULL,     
        CEX_COD_ESTADO_CIVIL                            VARCHAR2(20 CHAR),
        CEX_COD_REGIMEN_MATRIMONIAL                     VARCHAR2(20 CHAR),
        CEX_DOCUMENTO_CONYUGE                           VARCHAR2(50 CHAR),
        CEX_IND_ANTIGUO_DEUDOR                          NUMBER(1,0),
        CEX_COD_USO_ACTIVO                                      VARCHAR2(20 CHAR),
        CEX_IMPORTE_PROPORCIONAL_OFR            NUMBER(16,2),
        CEX_IMPORTE_FINANCIADO                          NUMBER(16,2),
        CEX_RESPONSABLE_TRAMITACION                     VARCHAR2(256 CHAR),
        CEX_IND_PBC                                                     NUMBER(1,0),
        CEX_PORCENTAJE_COMPRA                           NUMBER(16,2),
        CEX_IND_TITULAR_RESERVA                         NUMBER(1,0),
        CEX_IND_TITULAR_CONTRATACION            NUMBER(1,0),
        CEX_NOMBRE_REPRESENTANTE                        VARCHAR2(256 CHAR),
        CEX_APELLIDOS_REPRESENTANTE                     VARCHAR2(256 CHAR),
        CEX_COD_TIPO_DOC_RTE                            VARCHAR2(20 CHAR),
        CEX_DOCUMENTO_RTE                                       VARCHAR2(50 CHAR),
        CEX_TELEFONO1_RTE                                       VARCHAR2(50 CHAR),
        CEX_TELEFONO2_RTE                                       VARCHAR2(50 CHAR),
        CEX_EMAIL_RTE                                           VARCHAR2(50 CHAR),
        CEX_COD_TIPO_VIA_RTE                            VARCHAR2(20 CHAR),
        CEX_DIRECCION_RTE                                       VARCHAR2(256 CHAR),
        CEX_COD_LOCALIDAD_RTE                           VARCHAR2(20 CHAR),
        CEX_CODIGO_POSTAL_RTE                           VARCHAR2(5 CHAR),
        CEX_COD_UNIDADPOBLACIONAL_RTE           VARCHAR2(20 CHAR),
        CEX_COD_PROVINCIA_RTE                           VARCHAR2(20 CHAR),
        CEX_FECHA_PETICION                                      DATE,
        CEX_FECHA_RESOLUCION                            DATE
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
