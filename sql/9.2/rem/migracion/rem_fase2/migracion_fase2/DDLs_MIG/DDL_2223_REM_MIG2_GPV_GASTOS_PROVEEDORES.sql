--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_GPV_GASTOS_PROVEEDORES'
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
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REM01';       --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_GPV_GASTOS_PROVEEDORES';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
                
        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
                GPV_COD_GASTO_PROVEEDOR                 NUMBER(16),
                GPV_REFERENCIA_EMISOR                   VARCHAR2(128 CHAR),
                GPV_COD_PVE_UVEM_EMISOR                 NUMBER(16)                              NOT NULL,
                GPV_COD_TIPO_GASTO                              VARCHAR2(20 CHAR),
                GPV_COD_SUBTIPO_GASTO                   VARCHAR2(20 CHAR),
                GPV_CONCEPTO                                    VARCHAR2(256 CHAR),
                GPV_COD_PERIODICIDAD                    VARCHAR2(20 CHAR),
                GPV_FECHA_EMISION                               DATE,
                GPV_FECHA_NOTIFICACION                  DATE,
                GPV_COD_DESTINATARIO                    VARCHAR2(20 CHAR),
                GPV_IND_CUBRE_SEGURO                    NUMBER(1),
                GPV_OBSERVACIONES                               VARCHAR2(512 CHAR),
                GPV_COD_GASTO_AGRUPADO                  NUMBER(9,0),
                GPV_ID                                                  NUMBER(16,0)                    NOT NULL,
                GPV_COD_TIPO_OPERACION                  VARCHAR2(20 CHAR)               NOT NULL,
                GPV_NUMERO_FACTURA_UVEM                 VARCHAR2(20 CHAR),
                GPV_NUMERO_PROVISION_FONDOS             VARCHAR2(20 CHAR),
                GPV_NUMERO_PRESUPUESTO                  VARCHAR2(20 CHAR)
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
