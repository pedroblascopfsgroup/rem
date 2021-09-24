--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210601
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9856
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_REMVIP_15200'
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
V_TABLA VARCHAR2(40 CHAR) := 'AUX_HREOS_15200_1';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
		(
		CODIGO_OFERTA	NUMBER(16,0),
		OF_SOSPECHOSA	NUMBER(1,0),
		ENTIDAD_FINANCIERA	NUMBER(1,0),
		MEDIO_PAGO	NUMBER(1,0),
		OCULTA_IDENTIDAD_TITULAR	NUMBER(1,0),
		ACTITUD_INCOHERENTE	NUMBER(1,0),
		PAGO_INTERMEDIARIO	NUMBER(1,0),
		TITULOS_PORTADOR	NUMBER(1,0),
		PAIS_TRANFERENCIA	NUMBER(2,0),
		FINALIDAD_OPERACION	VARCHAR2(2 CHAR),
		MOTIVO_COMPRA		VARCHAR2(1 CHAR),
		ORI_FONDOS_PROPIOS	NUMBER(16,2),
		ORI_FONDOS_BANCO	NUMBER(16,2),
		PROC_FONDOS_PROPIOS	NUMBER(16,0),
		DETECCION_INDICIO	NUMBER(1,0),
		SANCION_PBCHRE	NUMBER(1,0),
		FECHASANCION_PBCHRE	DATE,
		INFORME_PBCHRE	VARCHAR2(100 CHAR),
		RIESGO_OPERACION	VARCHAR2(1 CHAR),
		VALIDAR_DOCUMENTACION	NUMBER(1,0)	
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

/

EXIT;

