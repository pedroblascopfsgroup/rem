--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160920
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_PVE_PROVEEDORES'
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
V_ESQUEMA_1 VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := '#ESQUEMA#'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
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
	PVE_COD_UVEM	   					VARCHAR2(50 CHAR)       NOT NULL,     
	PVE_COD_TIPO_PROVEEDOR				VARCHAR2(20 CHAR)		NOT NULL,
	PVE_NOMBRE							VARCHAR2(250 CHAR)		NOT NULL,
	PVE_NOMBRE_COMERCIAL				VARCHAR2(250 CHAR)		NOT NULL,
	PVE_COD_TIPO_DOCUMENTO				VARCHAR2(20 CHAR),	
	PVE_DOCUMENTO_ID					VARCHAR2(20 CHAR),
	PVE_CON_ZONA_GEOGRAFICA				VARCHAR2(20 CHAR),
	PVE_COD_PROVINCIA					VARCHAR2(20 CHAR),
	PVE_COD_LOCALIDAD					VARCHAR2(20 CHAR),
	PVE_COD_POSTAL						NUMBER(8,0),
	PVE_DIRECCION						VARCHAR2(250 CHAR),
	PVE_TELEFONO1						VARCHAR2(20 CHAR),
	PVE_TELEFONO2						VARCHAR2(20 CHAR),
	PVE_FAX								VARCHAR2(20 CHAR),
	PVE_EMAIL							VARCHAR2(50 CHAR),
	PVE_PAGINA_WEB						VARCHAR2(50 CHAR),
	PVE_IND_FRANQUICIA					NUMBER(1,0),
	PVE_IND_IVA_CAJA					NUMBER(1,0),
	PVE_NUM_CUENTA						VARCHAR2(50 CHAR),
	PVE_COD_TIPO_COLABORADOR			VARCHAR2(20 CHAR),
	PVE_COD_TIPO_PERSONA				VARCHAR2(20 CHAR),
	PVE_RAZON_SOCIAL					VARCHAR2(20 CHAR),
	PVE_FECHA_ALTA						DATE					NOT NULL,
	PVE_FECHA_BAJA						DATE,
	PVE_IND_LOCALIZADO					NUMBER(1,0),
	PVE_COD_ESTADO						VARCHAR2(20 CHAR),
	PVE_FECHA_CONSTITUCION				DATE,
	PVE_AMBITO							VARCHAR2(100 CHAR),
	PVE_OBSERVACIONES					VARCHAR2(200 CHAR),
	PVE_IND_HOMOLOGADO					NUMBER(1,0),
	PVE_COD_CALIFICACION				VARCHAR2(20 CHAR),
	PVE_TOP								NUMBER(1,0),
	PVE_TITULAR							VARCHAR2(200 CHAR),
	PVE_IND_RETENER						NUMBER(1,0),
	PVE_COD_MOTIVO_RETENCION			VARCHAR2(20 CHAR),
	PVE_FECHA_RETENCION					DATE,
	PVE_FECHA_PBC						DATE,
	PVE_COD_RES_PROCESO_BLANQUEO		VARCHAR2(20 CHAR)
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
