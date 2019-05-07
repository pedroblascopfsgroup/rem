--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190411
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6164
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
	V_MSQL VARCHAR(4000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(200 CHAR);
    PL_OUTPUT VARCHAR2(32000 CHAR);
    P_ACT_ID NUMBER;
    P_ALL_ACTIVOS NUMBER;

BEGIN			
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] CORREGIR CAMPOS MAL INFORMADOS PESTAÑA PATRIMONIO '); 
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO SET 
					DD_ADA_ID = NULL
				,   DD_EAL_ID = NULL
				,   DD_TPI_ID = NULL
				,   CHECK_SUBROGADO = NULL
				,   PTA_RENTA_ANTIGUA = NULL
				WHERE ACT_ID in (select ACT.ACT_ID
									from '||V_ESQUEMA||'.ACT_ACTIVO act
									INNER JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON act.act_id = PTA.ACT_ID
									where PTA.CHECK_HPM = 0 
										AND (   PTA.DD_ADA_ID is not null
												OR PTA.DD_EAL_ID is not null 
												OR PTA.DD_TPI_ID is not null 
												OR PTA.CHECK_SUBROGADO is not null 
												OR PTA.PTA_RENTA_ANTIGUA IS NOT NULL))';   
                                
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
					DD_TAL_ID = NULL
				WHERE ACT_ID in (select ACT.ACT_ID
									from '||V_ESQUEMA||'.ACT_ACTIVO act
									INNER JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON act.act_id = PTA.ACT_ID
									where CHECK_HPM = 0 AND ACT.DD_TAL_ID is not null)'; 
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
				SET DD_TAL_ID = NULL 
				WHERE ACT_ID in (    
									SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
									LEFT JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA on act.act_id = pta.act_id
									WHERE act.BORRADO = 0 AND ACT.DD_TAL_ID is not null
									MINUS 
									SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
									INNER JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA on act.act_id = pta.act_id
									WHERE act.BORRADO = 0
								)'; 
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
				
				
				
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
				SET DD_TAL_ID = NULL 
				WHERE ACT_ID in (    
									SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
									LEFT JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA on act.act_id = pta.act_id
									WHERE act.BORRADO = 0 AND ACT.DD_TAL_ID is not null
									MINUS 
									SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
									INNER JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA on act.act_id = pta.act_id
									WHERE act.BORRADO = 0
								)'; 
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO act
				using (SELECT ACT.ACT_ID , APU. DD_TCO_ID 
						FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
						INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU on ACT.ACT_ID = APU.ACT_ID
						WHERE ACT.USUARIOMODIFICAR like ''HREOS-5932%'' AND ACT.BORRADO = 0) AUX
				on (act.act_id = aux.act_id)
				WHEN MATCHED THEN UPDATE SET 
				act.dd_tco_id = aux.dd_tco_id'; 
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
	
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');

	
EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
