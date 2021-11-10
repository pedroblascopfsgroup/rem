--/*
--######################################### 
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210616
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-13884
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas de SITUACIONES FACTURAS 
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
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(40 CHAR) := '';

BEGIN
	
	/***** APR_AUX_I_UR_FACT_SIT *****/
	
	V_TABLA := 'APR_AUX_I_UR_FACT_SIT_SAPBC';

	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            (
                             FAC_ID_REM                        VARCHAR2(20 CHAR)
                           , NUM_PROVISION_REM		 VARCHAR2(20 CHAR)
                           , NUM_LINEA			 VARCHAR2(3 CHAR)
                           , ID_ACTIVO 			 NUMBER(9, 0)
                           , GRUPO_GASTO			 VARCHAR2(2 CHAR)
                           , TIPO_ACCION			 VARCHAR2(2 CHAR)
                           , SUBTIPO_ACCION			 VARCHAR2(2 CHAR)
                           , RETORNO_SAPBC                     VARCHAR2(3 CHAR)
                           , FECHA_ESTADO_SAPBC		 VARCHAR2(8 CHAR)
                           , TEXT_MENSAJE_SAPBC                VARCHAR2(73 CHAR)
                           , FILLER                            VARCHAR2(161 CHAR)  
                                
                   	)';

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  

	/***** APR_AUX_I_UR_FACT_SIT_REJECTS *****/

	V_TABLA := 'APR_AUX_I_UR_FACT_SIT_REJECTS';
	
	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            ( 
                                 ERRORCODE	VARCHAR2(255 CHAR)
								,ERRORMESSAGE	VARCHAR2(2048 CHAR)
								,ROWREJECTED	VARCHAR2(2048 CHAR)
                           )';

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  

	
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
