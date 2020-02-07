--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200205
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6363
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir mediadores
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_ECO_ID NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_MODIFICAR VARCHAR2(100 CHAR):= 'REMVIP-6363';
  V_COUNT NUMBER(16):= 0;
  V_COUNT2 NUMBER(16):= 0;
  V_COUNT3 NUMBER(16):= 0;
  V_RESULT VARCHAR(2000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL T1
			USING(
			    SELECT AUX.ACT_NUM_ACTIVO, AUX.COD_PRV, ACT.ACT_ID, PVE.PVE_ID
			    FROM '||V_ESQUEMA||'.AUX_REMVIP_6363 AUX 
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO 
			    INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_REM = AUX.COD_PRV 
			)T2
		ON (T1.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN UPDATE SET
		T1.ICO_MEDIADOR_ESPEJO_ID = T2.PVE_ID,
		T1.USUARIOMODIFICAR = ''REMVIP-6363'',
		T1.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ACTUALIZAN '||SQL%ROWCOUNT||' registros ACT_ICO_INFO_COMERCIAL'); 	


	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI T1
		    	USING( 
			    SELECT AUX.ACT_NUM_ACTIVO, AUX.COD_PRV, ACT.ACT_ID, PVE.PVE_ID
			    FROM '||V_ESQUEMA||'.AUX_REMVIP_6363 AUX 
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO 
			    INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_REM = AUX.COD_PRV 
			) T2
		    ON (T1.ACT_ID = T2.ACT_ID AND T1.DD_TRL_ID = 2)
		   WHEN NOT MATCHED THEN INSERT (T1.ICM_ID,
                                        	T1.ACT_ID,
		                                T1.ICO_MEDIADOR_ID,
		                                T1.ICM_FECHA_DESDE,
		                                T1.ICM_FECHA_HASTA,
		                                T1.VERSION,
		                                T1.USUARIOCREAR,
		                                T1.FECHACREAR,
		                                T1.BORRADO,
						T1.DD_TRL_ID)
		                        VALUES ('||V_ESQUEMA||'.S_ACT_ICM_INF_COMER_HIST_MEDI.NEXTVAL,
		                                T2.ACT_ID,
		                                T2.PVE_ID,
		                                SYSDATE,
		                                NULL,
                                        	0,
		                                ''REMVIP-6363'',
		                                SYSDATE,
		                                0,
                                       		2
		                                )';	


	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se INSERTAN '||SQL%ROWCOUNT||' registros ACT_ICM_INF_COMER_HIST_MEDI'); 

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
                    
