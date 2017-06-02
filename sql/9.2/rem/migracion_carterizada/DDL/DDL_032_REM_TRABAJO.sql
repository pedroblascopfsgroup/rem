--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=201600802
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG_ATR_TRABAJO'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ATR_TRABAJO';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
	ACT_NUMERO_ACTIVO					NUMBER(16,0),
	AGR_UVEM							NUMBER(16,0),
	TBJ_NUM_TRABAJO						NUMBER(16,0),
	PVC_DOCIDENTIF						VARCHAR2(20 CHAR),
	TIPO_TRABAJO						VARCHAR2(20 CHAR),
	SUBTIPO_TRABAJO						VARCHAR2(20 CHAR),
	ESTADO_TRABAJO						VARCHAR2(20 CHAR),
	TBJ_DESCRIPCION						VARCHAR2(256 CHAR),
	TBJ_FECHA_SOLICITUD					DATE,
	TBJ_FECHA_APROBACION				DATE,
	TBJ_FECHA_INICIO					DATE,
	TBJ_FECHA_FIN						DATE,
	TBJ_FECHA_FIN_COMPROMISO			DATE,
	TBJ_FECHA_TOPE						DATE,
	TBJ_FECHA_HORA_CONCRETA				TIMESTAMP,
	TBJ_URGENTE							NUMBER(1,0),
	TBJ_CON_RIESGO_TERCEROS				NUMBER(1,0),
	TBJ_CUBRE_SEGURO					NUMBER(1,0),
	TBJ_CIA_ASEGURADORA					VARCHAR2(256 CHAR),
	TIPO_CALIDAD						VARCHAR2(20 CHAR),
	TBJ_TERCERO_NOMBRE					VARCHAR2(256 CHAR),
	TBJ_TERCERO_EMAIL					VARCHAR2(256 CHAR),
	TBJ_TERCERO_DIRECCION				VARCHAR2(256 CHAR),
	TBJ_TERCERO_CONTACTO				VARCHAR2(256 CHAR),
	TBJ_TERCERO_TEL1					VARCHAR2(16 CHAR),
	TBJ_TERCERO_TEL2					VARCHAR2(16 CHAR),
	TBJ_IMPORTE_PENAL_DIARIO			NUMBER(16,2),
	TBJ_OBSERVACIONES					VARCHAR2(1024 CHAR),
	TBJ_CONTINUO_OBSERVACIONES			VARCHAR2(1024 CHAR),
	TBJ_IMPORTE_TOTAL					NUMBER(16,2),
	TBJ_FECHA_DENEGACION				DATE		
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

