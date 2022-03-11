--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20220222
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17217
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas AUX_INFORME_GASTOS_CAIXA
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
V_TABLA VARCHAR2(40 CHAR) := 'AUX_INFORME_GASTOS_CAIXA';

BEGIN
	


	/***** H_AUX_I_RU_LFACT_SIN_PROV_BFA *****/

	V_TABLA := 'AUX_INFORME_GASTOS_CAIXA';
	
	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            ( 
                                 NUM_GASTO                       VARCHAR2(20 CHAR)
                               , EJERCICIO                        NUMBER(4)
                               , ESTADO_GASTO                     VARCHAR2(40 CHAR)
                               , EMISOR	                    VARCHAR2(40 CHAR)
                               , NIF		                    VARCHAR2(11 CHAR)
                               , PROPIETARIO                      VARCHAR2(15 CHAR)
                               , GESTORIA	                    VARCHAR2(15 CHAR)
                               , TIPO_GASTO                       VARCHAR2(40 CHAR)
                               , SUBTIPO_GASTO		    VARCHAR2(40 CHAR)
                               , PERIOCIDAD			    VARCHAR2(10 CHAR)
                               , CONCEPTO		            VARCHAR2(200 CHAR)
                               , NUM_ACTIVO			    NUMBER(15)
                               , PORCENTAJE_PROPIEDAD             NUMBER(3)
                               , SITUACION_COMERCIAL_ACTIVO       VARCHAR2(40 CHAR)
                               , FECHA_DEVENGO_ESPECIAL           DATE
                               , FECHA_ENVIO_PAGO	            DATE
                               , FECHA_ENVIO_INFORMATIVA	    DATE
                               , IMPORTE_TOTAL_GASTO              NUMBER(20,2)
                               ,IMPORTE_ACTIVO_GASTO              NUMBER(20,2)
                               ,FECHA_EMISION                     DATE
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
