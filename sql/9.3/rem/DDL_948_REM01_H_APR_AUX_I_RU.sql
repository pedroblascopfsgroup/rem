--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210621
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMNIVDOS-5257
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas  H_APR_AUX_I_RU_LFACT_SIN_PROV_BFA y H_APR_AUX_I_RU_FACT_PROV_BFA
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
	


	/***** H_APR_AUX_I_RU_LFACT_SIN_PROV_BFA *****/

	V_TABLA := 'H_APR_AUX_I_RU_LFACT_SIN_PROV_BFA';
	
	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            ( 
                                 FAC_ID_REM                       VARCHAR2(20 CHAR)
                               , FAC_TIPO_REG                     NUMBER(1)
                               , NUM_ORDEN                        NUMBER(3)
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
                               ,FECHA_PROCESADO                   DATE
                               ,ID_ROW                            ROWID
                           )';


                           

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  
	

		/***** APR_AUX_I_RU_FACT_CON_PROV *****/
	
	V_TABLA := 'H_APR_AUX_I_RU_FACT_PROV_BFA';
	
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
                              , FILLER                        VARCHAR2(68 CHAR)
                              , COLFIN                        VARCHAR2(2 CHAR)
                              ,FECHA_PROCESADO                DATE
                              ,ID_ROW                         ROWID
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
