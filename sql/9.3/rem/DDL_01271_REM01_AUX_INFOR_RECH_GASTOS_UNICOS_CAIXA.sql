--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20220329
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17301
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas AUX_INFOR_RECH_UNICOS_CAIXA
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-17301]- DAP
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(40 CHAR) := 'AUX_INFOR_RECH_UNICOS_CAIXA';

BEGIN
	


	/***** AUX_INFOR_RECH_UNICOS_CAIXA *****/

	V_TABLA := 'AUX_INFOR_RECH_UNICOS_CAIXA';
	
	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            ( 
                                 NUM_GASTO                        NUMBER(16,0)
                               , EMISOR	                          VARCHAR2(250 CHAR)
                               , COD_EMISOR                       VARCHAR2(50 CHAR)
                               , NIF_EMISOR		                  VARCHAR2(20 CHAR)
                               , PROPIETARIO                      VARCHAR2(100 CHAR)
                               , DESTINATARIO_GASTO               VARCHAR2(100 CHAR)
                               , GESTORIA	                      VARCHAR2(250 CHAR)
                               , EJERCICIO                        NUMBER(4) 
                               , ESTADO_GASTO                     VARCHAR2(100 CHAR)
                               , ESTADO_AUTORIZ_HAYA              VARCHAR2(100 CHAR)
                               , ESTADO_AUTORIZ_PROP              VARCHAR2(100 CHAR)
                               , FECHA_EMISION                    DATE
                               , FECHA_DEVENGO_ESPECIAL           DATE
                               , FECHA_ENVIO_PAGO	              DATE
                               , FECHA_ENVIO_INFORMATIVA	      DATE
                               , CLIENTE_PAGADOR                  VARCHAR2(100 CHAR)
                               , CLIENTE_INFORMADO                VARCHAR2(100 CHAR)
                               , TIPO_GASTO                       VARCHAR2(100 CHAR)
                               , SUBTIPO_GASTO		              VARCHAR2(100 CHAR)
                               , CONCEPTO		                  VARCHAR2(256 CHAR)
                               , CICLICO		                  VARCHAR2(2 CHAR)
                               , IMPORTE_TOTAL                    NUMBER(16,2)
                               , RETENCION_IRPF                   NUMBER(16,2)
                               , LINEA_GASTO_MARCADA_SIN_ACTIVOS  VARCHAR2(2 CHAR)
                               , MENSAJE_ERROR                    VARCHAR2(500 CHAR)
                               , RETORNO_RECIBIDO                 VARCHAR2(300 CHAR)
                               , FECHA_PROCESADO                  VARCHAR2(100 CHAR)
                               , SISTEMA_CLIENTE                  VARCHAR2(100 CHAR)
                           )';


                           

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  
	

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
