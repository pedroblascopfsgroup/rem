--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221115
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.11
--## INCIDENCIA_LINK=HREOS-18941
--## PRODUCTO=NO
--## 
--## Finalidad:
--## 
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial - [HREOS-18941] - Alejandra García
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	TABLE_COUNT NUMBER(10,0) := 0;
	TABLE_COUNT_2 NUMBER(10,0) := 0;
	MAX_NUM_OFR NUMBER(10,0) := 0;
	V_NUM_TABLAS NUMBER(10,0) := 0;
	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
	V_SENTENCIA VARCHAR2(32000 CHAR);
	V_NUM_TABLAS_2 NUMBER(16);
	V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN

	--Inicio del proceso de volcado sobre OFR_OFERTAS


V_SENTENCIA := 'TRUNCATE TABLE '||V_ESQUEMA||'.APR_AUX_HREOS_18797_CONSULTA';

	EXECUTE IMMEDIATE V_SENTENCIA;

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.APR_AUX_HREOS_18797_CONSULTA');

	
	V_SENTENCIA := 'INSERT INTO '||V_ESQUEMA||'.APR_AUX_HREOS_18797_CONSULTA(
						 NUM_OFERTA            
						,ACT_ID		
						,ECO_ID		
						,TBJ_ID		
						,TPO_ID		
						,TAP_ID		
						,USU_ID		
						,SUP_ID		
						,TAREA_ANTIGUA_TRAMITE 
						,TAREA_NUEVA_TRAMITE   
						,TRA_ID		
						,TAR_ID_ANTERIOR	
						,TEX_ID_ANTERIOR	
						,TAR_ID		
						,TEX_ID		
					)
					SELECT 
					 	 NUM_OFERTA            
						,ACT_ID		
						,ECO_ID		
						,TBJ_ID		
						,TPO_ID		
						,TAP_ID		
						,USU_ID		
						,SUP_ID		
						,TAREA_ANTIGUA_TRAMITE 
						,TAREA_NUEVA_TRAMITE   
						,TRA_ID		
						,TAR_ID_ANTERIOR	
						,TEX_ID_ANTERIOR	
						,TAR_ID		
						,TEX_ID	
					FROM '||V_ESQUEMA||'.APR_AUX_HREOS_18797 AUX';
                   
        	EXECUTE IMMEDIATE V_SENTENCIA;
        	
       		V_SENTENCIA := 'MERGE INTO '||V_ESQUEMA||'.APR_AUX_HREOS_18797_CONSULTA T1 
			   				USING(
								SELECT DISTINCT      
									 AUX.NUM_OFERTA		
									,EEC.DD_EEC_CODIGO
									,EEB.DD_EEB_CODIGO
									,CAIXA.OFR_NUM_OFERTA_CAIXA 
								FROM '||V_ESQUEMA||'.APR_AUX_HREOS_18797 AUX
								JOIN  '||V_ESQUEMA||'.OFR_OFERTAS OFR  ON OFR.OFR_NUM_OFERTA = AUX.NUM_OFERTA
									AND OFR.BORRADO = 0
								JOIN  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO  ON ECO.OFR_ID = OFR.OFR_ID
									AND ECO.BORRADO = 0
								JOIN  '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC  ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
									AND EEC.BORRADO = 0
								JOIN  '||V_ESQUEMA||'.DD_EEB_ESTADO_EXPEDIENTE_BC EEB  ON EEB.DD_EEB_ID = ECO.DD_EEB_ID
									AND EEB.BORRADO = 0
								JOIN '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA CAIXA ON CAIXA.OFR_ID = OFR.OFR_ID
									AND CAIXA.BORRADO = 0
                    		)
							T2 ON (T1.NUM_OFERTA = T2.NUM_OFERTA)
							WHEN MATCHED THEN UPDATE SET
							 T1.DD_EEC_CODIGO_ANTIGUO = T2.DD_EEC_CODIGO
							,T1.DD_EEB_CODIGO_ANTIGUO = T2.DD_EEB_CODIGO
							,T1.OFR_NUM_OFERTA_CAIXA  = T2.OFR_NUM_OFERTA_CAIXA ';
                   
        	EXECUTE IMMEDIATE V_SENTENCIA;
        	
        	
        	   

	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'..APR_AUX_HREOS_18797_CONSULTA cargada. '||SQL%ROWCOUNT||' Filas.');
	
	COMMIT;

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------');
		DBMS_OUTPUT.put_line(V_SENTENCIA);
		ROLLBACK;
		RAISE;
END;
/
EXIT;
