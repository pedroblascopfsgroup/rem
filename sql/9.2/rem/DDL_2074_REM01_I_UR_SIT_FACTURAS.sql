--/*
--######################################### 
--## AUTOR=CLV
--## FECHA_CREACION=20161026
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-XXX
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
	
	V_TABLA := 'APR_AUX_I_UR_FACT_SIT';

	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            (
                             FAC_ID_REM                        VARCHAR2(20 CHAR)
                           , FAC_TIPO_REG                      NUMBER(1)
                           , FAC_COD_SUBTIPO                   VARCHAR2(1 CHAR)
                           , SOCIEDAD_PAGADORA                 NUMBER(5)
                           , EJE_ANYO_FACTURA                  VARCHAR2(4 CHAR)
                           , COD_TIPO_DOC                      VARCHAR2(1 CHAR)
                           , NIF_CIF_PROVEEDOR                 VARCHAR2(10 CHAR)
                           , ID_PROVEEDOR                      NUMBER(9)
                           , COD_TIPO_OPERACION                NUMBER(2)
                           , NUM_FACT_PROVEEDOR                VARCHAR2(20 CHAR)
                           , FECHA_EMISION                     DATE
                           , COD_MODALIDAD_PAGO                NUMBER(2)
                           , COD_FORMA_PAGO                    NUMBER(2)
                           , IMPORTE_BASE_IMPUESTO             NUMBER(15,2)
                           , SIGNO_IMP_BASE_IMPUESTO           VARCHAR2(1 CHAR)
                           , COD_UNIDAD_MONETARIA              NUMBER(3)
                           , COD_TIPO_IMPUESTO                 NUMBER(2)
                           , COD_SUBTIPO_IMPUESTO              NUMBER(2)
                           , PORC_APLIC_IMPUESTO               NUMBER(5,2)
                           , IMPORTE_BASE_IMPUESTO_DIR         NUMBER(15,2)
                           , SIGNO_IMP_BASE_IMPUESTO_DIR       VARCHAR2(1 CHAR)
                           , COD_TIPO_IMPUESTO_DIR             NUMBER(2)
                           , COD_SUBTIPO_IMPUESTO_DIR          NUMBER(2)
                           , PORC_APLIC_IMPUESTO_DIR           NUMBER(5,2)
                           , IND_CALCULO_IMPUESTO_IND          VARCHAR2(1 CHAR)
                           , COD_USUARIO                       VARCHAR2(8 CHAR)
                           , COD_USUARIO_AUTORIZA              VARCHAR2(8 CHAR)
                           , COD_USUARIO_VERIFICA              VARCHAR2(8 CHAR)
                           , COD_USUARIO_DOBLE_FIRMA           VARCHAR2(8 CHAR)
                           , COD_TIPO_PARTIDA                  VARCHAR2(1 CHAR)
                           , ID_PARTIDA                        VARCHAR2(11 CHAR)
                           , IND_IVA_CRITERIO_CAJA             VARCHAR2(1 CHAR)
                           , SITUACION_FACTURA_UVEM            NUMBER(2)
                           , RETORNO_RECHAZO_CONTAX            NUMBER(3)
                           , FECHA_RECHAZO_CONTAX              DATE
                           , SITUACION_FACTURA_GRM             NUMBER(2)
                           , RETORNO_UVEM                      NUMBER(3)
                           , FECHA_PAGO			               DATE
                           , COD_OFICINA_EMISION_CONEXION      NUMBER(4)
                           , FECHA_CONTAB_FACT                 DATE
                           , FILLER                            VARCHAR2(82 CHAR)        
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
