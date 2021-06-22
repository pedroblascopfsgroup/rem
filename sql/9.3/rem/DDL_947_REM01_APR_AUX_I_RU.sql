--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210624
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14420
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas AUX_I_RU_FACT_SIN_PROV_BFA, AUX_I_RU_LFACT_SIN_PROV_BFA y AUX_I_RU_FACT_PROV_BFA
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
	
	/***** AUX_I_RU_FACT_SIN_PROV_BFA *****/
	
	V_TABLA := 'AUX_I_RU_FACT_SIN_PROV_BFA';

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
                           , EJE_ANYO_FACTURA                  VARCHAR2(10 CHAR)
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
                           , COD_ENTIDAD_CONEXION              NUMBER(4)
                           , COD_OFICINA_EMISION_CONEXION      NUMBER(4)
                           , NUM_CONEXION                  	   NUMBER(13)
                           , FECHA_PAGO_NO_REAL_DE_LA_FACTU	   DATE
                           , FILLER                            VARCHAR2(69 CHAR)
                           ,TIPO_DEDUCIBILIDAD                 VARCHAR2(1 CHAR)
                           ,PORCENTAJE_DEDUCIBILIDAD           NUMBER(6,3)
                   	)';

                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.TIPO_DEDUCIBILIDAD IS '' Tipo de deducibilidad a aplicar en factura. Valores posibles: -'''' '''' NO APLICA ''''1'''' - PRORRATA GENERAL ''''2'''' - 0%  ''''3'''' - 100 % ''''4'''' - % DEDUCIBILIDAD''';
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.PORCENTAJE_DEDUCIBILIDAD IS '' Porcentaje de deducibilidad de factura.''';

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  

	/***** AUX_I_RU_LFACT_SIN_PROV_BFA *****/

	V_TABLA := 'AUX_I_RU_LFACT_SIN_PROV_BFA';
	
	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            ( 
                                 FAC_ID_REM                       VARCHAR2(20 CHAR)
                               , FAC_TIPO_REG                     NUMBER(1)
                               , NUM_ORDEN                        NUMBER(9)
                               , ID_ACTIVO_ESPECIAL               NUMBER(9)
                               , COD_GRUPO_GASTO                  NUMBER(2)
                               , COD_TIPO_ACCION                  NUMBER(2)
                               , COD_SUBTIPO_ACCION               NUMBER(2)
                               , COD_USUARIO_REFERENCIA           VARCHAR2(8 CHAR)
                               , COD_ENTIDAD_SOLICITANTE_ACCION   NUMBER(4)
                               , OFICINA_CENTRO_SOLICITANTE       NUMBER(4)
                               , IMPORTE_PREVISTO_ACCION          NUMBER(15,2)
                               , SIGNO_IMPORTE_PREVISTO_ACCION    VARCHAR2(1 CHAR)
                               , FECHA_INI_REAL_ACCION            DATE
                               , FECHA_FIN_REAL_ACCION            DATE
                               , COD_CONCEPTO_CONTABLE            NUMBER(5)
                               , IND_EXCLUSION_IMP_DIRECTO        VARCHAR2(1 CHAR)
                               , FILLER                           VARCHAR2(207 CHAR)
                               ,GPV_CONCEPTO                      VARCHAR2(254 CHAR)
                               ,ACT_ID                            NUMBER(16,0)
                           )';


                           EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_ID IS '' Campo utilizado para evitar error en los casos en los que el activo no tiene ID_ACTIVO_ESPECIAL''';

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  
	

		/***** APR_AUX_I_RU_FACT_CON_PROV *****/
	
	V_TABLA := 'AUX_I_RU_FACT_PROV_BFA';
	
	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            (
                                ID_ACTIVO_ESPECIAL            NUMBER(9) 
                              , COD_GRUPO_GASTO               NUMBER(2) 
                              , COD_TIPO_CONCEPTO_GASTO       NUMBER(2)    
                              , COD_SUBTIPO_GASTO             NUMBER(2)    
                              , PERIODICIDAD_PAGO             VARCHAR2(1 CHAR)    
                              , FECHA_DEVENGO                 DATE
                              , FECHA_FIN_PERIODO             DATE
                              , FECHA_PAGO                    DATE
                              , FECHA_LIMITE_PAGO             DATE
                              , COD_SITUACION_GASTO           NUMBER(2)    
                              , FECHA_ESTADO_ESTIMADO_IMP     DATE
                              , FECHA_ESTADO_CONOCIDO_IMP     DATE
                              , FECHA_ESTADO_AUTORIZADO_IMP   DATE
                              , FECHA_ESTADO_PAGADO_IMP       DATE
                              , IMPORTE_GASTO                 NUMBER(15,2)
                              , SIGNO_IMPORTE_GASTO           VARCHAR2(1 CHAR)
                              , RECARGO_EN_IMPORTE_GASTO      NUMBER(13,2)
                              , SIGNO_REGARGO_REAL            VARCHAR2(1 CHAR)
                              , IMPORTE_DEMORA_GASTO          NUMBER(13,2)
                              , SIGNO_INT_DEMORA_REAL         VARCHAR2(1 CHAR)
                              , IMPORTE_COSTAS                NUMBER(13,2)
                              , SIGNO_IMPORTE_COSTAS          VARCHAR2(1 CHAR)
                              , IMPORTE_OTROS_INCREMENTOS     NUMBER(13,2)
                              , SIGNO_OTROS_INCREMENTOS       VARCHAR2(1 CHAR)
                              , IMPORTE_DESCUENTO_GASTOS      NUMBER(13,2)
                              , COD_UNIDAD_MONETARIA          NUMBER(3)
                              , IMPORTE_IMPUESTOS_GASTO       NUMBER(15,2)
                              , COD_TIPO_IMPUESTO             NUMBER(2)
                              , COD_TIPO_NEGOCIADO            NUMBER(2)
                              , COD_ENTIDAD_CONEXION          NUMBER(4)
                              , COD_OFICINA_EMISION_CONEXION  NUMBER(4)
                              , NUM_CONEXION                  NUMBER(13)
                              , NUM_PROVISION_FONDOS          NUMBER(9)
                              , FECHA_ANULACION_GASTO         DATE
                              , COD_MOTIVO_NO_AUTORIZACION    NUMBER(2)
                              , IND_AUTORIZACION_G            VARCHAR2(1 CHAR)
                              , FECHA_AUTORIZACION_FACTURA    DATE
                              , COD_TIPO_ERROR                NUMBER(2)
                              , FECHA_PAGO_NO_REAL            DATE
                              , FECHA_PAGO_PROVEEDOR          DATE
                              , FECHA_ENTRADA_APLICACION      DATE
                              , COD_APLICACION_INFOCAM        VARCHAR2(3 CHAR)
                              , COD_SUBAPLICACION_INFOCAM     VARCHAR2(2 CHAR)
                              , NUM_CLIENTE_INTERCAMBIO       VARCHAR2(13 CHAR)
                              , COD_TIPO_PARTIDA              VARCHAR2(1 CHAR)
                              , ID_PARTIDA                    VARCHAR2(11 CHAR)
                              , FAC_ID_REM                    VARCHAR2(20 CHAR)
                              , COD_USUARIO_AUTORIZA          VARCHAR2(8 CHAR)
                              , COD_USUARIO_DEBLE_FIRMA       VARCHAR2(8 CHAR)
                              , FILLER                        vARCHAR2(68 CHAR)
                              , COLFIN                        VARCHAR2(2 CHAR)
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
