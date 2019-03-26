--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_GGE_GASTOS_GESTION'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_GGE_GASTOS_GESTION';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
                
        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
                GGE_COD_GASTO_PROVEEDOR                                         NUMBER(16),
                GGE_IND_AUTORIZ_PROP                                            NUMBER(1),
                GGE_COD_MOT_AUTORIZ_PROP                                        VARCHAR2(20 CHAR),
                GGE_COD_EST_AUTORIZ_PROP                                        VARCHAR2(20 CHAR),
                GGE_FECHA_EST_AUTORIZ_PROP                                      DATE,
                GGE_MOT_RECHAZO_PROP                                            VARCHAR2(512 CHAR),
                GGE_OBSERVACIONES                                               VARCHAR2(250 CHAR),
                GGE_FECHA_ALTA                                                  DATE,
                GGE_COD_USUARIO_ALTA                                            VARCHAR2(20 CHAR),
                GGE_COD_EST_AUTORIZ_ADMIN                                       VARCHAR2(20 CHAR),
                GGE_FECHA_ESTADO_AUTORIZ_ADMIN                           		DATE,
                GGE_COD_USU_EST_AUTORIZ_ADMIN                            		VARCHAR2(20 CHAR),
                GGE_COD_MOT_RECH_AUTORIZ_ADMIN                           		VARCHAR2(20 CHAR),
                GGE_FECHA_ANULACION                                             DATE,
                GGE_COD_USUARIO_ANULACION                                       VARCHAR2(20 CHAR),
                GGE_COD_MOTIVO_ANULACION_GASTO                          		VARCHAR2(20 CHAR),
                GGE_FECHA_RETENCION_PAGO                                        DATE,
                GGE_COD_USUARIO_RETENCION_PAGO                          		VARCHAR2(20 CHAR),
                GGE_COD_MOTIVO_RETENCION_PAGO                          		    VARCHAR2(20 CHAR),
                GGE_GPV_ID                                                      NUMBER(16)                 NOT NULL,
                GGE_FECHA_ENVIO_GESTORIA										DATE,
				GGE_FECHA_ENVIO_PRPTRIO											DATE,
				GGE_FECHA_RECEPCION_GESTORIA									DATE,
				GGE_FECHA_RECEPCION_PRPTRIO										DATE     
        , VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
        ;

        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

	    EXECUTE IMMEDIATE 'CREATE INDEX "REM01"."IDX_GGE_GPV_ID" ON "REM01"."MIG2_GGE_GASTOS_GESTION" ("GGE_GPV_ID") 
	    PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
	    STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
	    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
	    BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
	    TABLESPACE "REM_IDX" ';

        IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

                EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
                DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

        END IF;
        
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_GASTO_PROVEEDOR IS ''Código identificador único del Gasto del Proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_IND_AUTORIZ_PROP IS ''Indicador si el Gasto Requiere Autorización del Propietario''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_MOT_AUTORIZ_PROP IS ''Código del Motivo de Autorización del Propietario (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_EST_AUTORIZ_PROP IS ''Código del Estado de Autorización del Propietario (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_EST_AUTORIZ_PROP IS ''Fecha del Estado de la Autorización del Propietario''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_MOT_RECHAZO_PROP IS ''Motivo de Rechazo del Propietario''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_OBSERVACIONES IS ''Observaciones''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_ALTA IS ''Fecha de Alta''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_USUARIO_ALTA IS ''USERNAME en REM del Usuario que da de Alta la Gestión del Gasto (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_EST_AUTORIZ_ADMIN IS ''Código del Estado de la Autorización por Administración (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_ESTADO_AUTORIZ_ADMIN IS ''Fecha del Estado de la Autorización por Administración''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_USU_EST_AUTORIZ_ADMIN IS ''USERNAME en REM del Usuario que cambia el Estado de Autorización Administración (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_MOT_RECH_AUTORIZ_ADMIN IS ''Código del Motivo de Rechazo de la Autorización por Administración (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_ANULACION IS ''Fecha de Anulación''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_USUARIO_ANULACION IS ''USERNAME en REM del Usuario que da Anula el Gasto (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_MOTIVO_ANULACION_GASTO IS ''Código del Motivo de Anulación del Gasto (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_RETENCION_PAGO IS ''Fecha de Retención del Pago''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_USUARIO_RETENCION_PAGO IS ''USERNAME en REM del Usuario que da Retiene el Pago (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_COD_MOTIVO_RETENCION_PAGO IS ''Código del Motivo de Retención del Pago (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_GPV_ID IS ''Identificador único autogenerado del gasto''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_ENVIO_GESTORIA IS ''Fecha del último envio a la gestoria''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_ENVIO_PRPTRIO IS ''Fecha del último envio al propietario''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_RECEPCION_GESTORIA IS ''Fecha de la última recepción de la gestoria''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GGE_GASTOS_GESTION.GGE_FECHA_RECEPCION_PRPTRIO IS ''Fecha de la última recepción del propieatario''';

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
