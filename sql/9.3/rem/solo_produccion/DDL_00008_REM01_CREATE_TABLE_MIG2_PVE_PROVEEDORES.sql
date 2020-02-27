--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-6357
--## PRODUCTO=NO
--##
--## Finalidad: Creación de tabla de migración
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
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_PVE_PROVEEDORES';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
	PVE_COD_ORIGEN                          VARCHAR2(20 CHAR), 
    TIPO_PROVEEDOR                          VARCHAR2(20 CHAR),
    PVE_NOMBRE                              VARCHAR2(250 CHAR),
    PVE_NOMBRE_COMERCIAL                    VARCHAR2(250 CHAR),
    TIPO_DOCUMENTO                          VARCHAR2(20 CHAR),
    PVE_DOCIDENTIF                          VARCHAR2(20 CHAR),
    ZONA_GEOGRAFICA                         VARCHAR2(20 CHAR),
    PVE_PROVINCIA                           VARCHAR2(20 CHAR),
    PVE_LOCALIDAD                           VARCHAR2(20 CHAR),
    PVE_CP                                  NUMBER(8,0),
    PVE_DIRECCION                           VARCHAR2(250 CHAR),
    PVE_TELF1                               VARCHAR2(20 CHAR),
    PVE_TELF2                               VARCHAR2(20 CHAR),
    PVE_FAX                                 VARCHAR2(20 CHAR),
    PVE_EMAIL                               VARCHAR2(50 CHAR),
    PVE_PAGINA_WEB                          VARCHAR2(50 CHAR),
    PVE_FRANQUICIA                          NUMBER(1,0),
    PVE_IVA_CAJA                            NUMBER(1,0),
    PVE_NUM_CUENTA                          VARCHAR2(50 CHAR),
    PVE_COD_TIPO_COLABORADOR                VARCHAR2(20 CHAR),
    PVE_COD_TIPO_PERSONA                    VARCHAR2(20 CHAR),
    PVE_RAZON_SOCIAL                        VARCHAR2(20 CHAR),
    PVE_FECHA_ALTA                          DATE,
    PVE_FECHA_BAJA                          DATE,
    PVE_IND_LOCALIZADO                      NUMBER(1,0),
    PVE_COD_ESTADO                          VARCHAR2(20 CHAR),
    PVE_FECHA_CONSTITUCION                  DATE,
    PVE_AMBITO                              VARCHAR2(100 CHAR),
    PVE_OBSERVACIONES                       VARCHAR2(200 CHAR),
    PVE_IND_HOMOLOGADO                      NUMBER(1,0),
    PVE_COD_CALIFICACION                    VARCHAR2(20 CHAR),
    PVE_TOP                                 NUMBER(1,0),
    PVE_TITULAR                             VARCHAR2(200 CHAR),
    PVE_IND_RETENER                         NUMBER(1,0),
    PVE_COD_MOTIVO_RETENCION                VARCHAR2(20 CHAR),
    PVE_FECHA_RETENCION                     DATE,
    PVE_FECHA_PBC                           DATE,
    PVE_COD_RES_PROCESO_BLANQUEO            VARCHAR2(20 CHAR),
    PVE_COD_API_PROVEEDOR                   VARCHAR2(4 CHAR),
    PVE_IND_MODIFICAR_DATOS_WEB             NUMBER(1,0),
    BORRADO 				    NUMBER(1,0) DEFAULT 0 NOT NULL,
    VALIDACION 	                            NUMBER(1) DEFAULT 0 NOT NULL 
)'
;


DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;

EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_COD_ORIGEN IS ''Código identificador único del proveedor en origen.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.TIPO_PROVEEDOR IS ''Tipo de proveedor (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_NOMBRE IS ''Nombre proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_NOMBRE_COMERCIAL IS ''Nombre comercial del proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.TIPO_DOCUMENTO IS ''Tipo documento del proveedor . (código según dicc. datos)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_DOCIDENTIF IS ''Número de documento identificativo del proveedor.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.ZONA_GEOGRAFICA IS ''Zona geográfica proveedor (código según dicc. datos)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_PROVINCIA IS ''Provincia del proveedor (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_LOCALIDAD IS ''Localidad (municipio) del proveedor (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_CP IS ''Codigo postal del proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_DIRECCION IS ''Dirección del proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_TELF1 IS ''Número de teléfono 1 del proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_TELF2 IS ''Número de teléfono 2 del proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_FAX IS ''Fax del proveedor.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_EMAIL IS ''Email del proveedor.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_PAGINA_WEB IS ''WEB del proveedor.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_FRANQUICIA IS ''Indicador si el proveedor es franquicia o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_IVA_CAJA IS ''Indicador si el proveedor tiene IVA con criterio en caja o no''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_NUM_CUENTA IS ''Datos domiciliación bancaria''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_COD_TIPO_COLABORADOR IS ''Código identificador del Tipo de Colaborador (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_COD_TIPO_PERSONA IS ''Código identificador del Tipo de Persona (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_RAZON_SOCIAL IS ''Razón Social''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_FECHA_ALTA IS ''Fecha de Alta del Proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_FECHA_BAJA IS ''Fecha de Baja del Proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_IND_LOCALIZADO IS ''Indicador de si el Proveedor está localizado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_COD_ESTADO IS ''Código identificador del Estado del Proveedor (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_FECHA_CONSTITUCION IS ''Fecha de Constitución del Proveedor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_AMBITO IS ''Ámbito territorial del proveedor.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_OBSERVACIONES IS ''Observaciones del proveedor.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_IND_HOMOLOGADO IS ''Indicador de si el Proveedor está Homologado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_COD_CALIFICACION IS ''Código identificador de la Calificación del Proveedor (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_TOP IS ''Indicador de si el proveedor está en el top150 o no''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_TITULAR IS ''Nombre y apellidos del titular de la cuenta bancaria''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_IND_RETENER IS ''Indicador si se tienen que retener los pagos al proveedor o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_COD_MOTIVO_RETENCION IS ''Código identificador de la Calificación del Proveedor (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_FECHA_RETENCION IS ''Fecha de retención de pagos.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_FECHA_PBC IS ''Fecha proceso de blanqueo de capitales.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_COD_RES_PROCESO_BLANQUEO IS ''Código identificador del Resultado proceso de blanqueo de capitales del Proveedor (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_COD_API_PROVEEDOR IS ''Código identificador del proveedor según su API''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_PVE_PROVEEDORES.PVE_IND_MODIFICAR_DATOS_WEB IS ''Indicador de si el Proveedor puede modificar datos WEB''';


COMMIT;
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

