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
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_TAL_ID = NULL WHERE ACT_ID IN
				(SELECT ACT.ACT_ID 
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				INNER JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON ACT.ACT_ID = PTA.ACT_ID
				INNER JOIN '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER EAL ON EAL.DD_EAL_ID = PTA.DD_EAL_ID
				WHERE EAL.DD_EAL_CODIGO = ''01'' 
					AND ACT.DD_TAL_ID IS NOT NULL 
					AND ACT.BORRADO = 0 
					AND PTA.BORRADO = 0)';
	
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
	

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.act_sps_sit_posesoria SET 
			dd_tpa_id = (select dd_tpa_id from '||V_ESQUEMA||'.dd_tpa_tipo_titulo_act where dd_tpa_codigo = ''02'')
			,sps_ocupado = 0
			where act_id in (
	           select act.act_id
        	   from REM01.act_activo act
        	   inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id = pta.act_id
        	   inner join '||V_ESQUEMA||'.dd_eal_estado_alquiler eal on pta.dd_eal_id = eal.dd_eal_id
        	   inner join '||V_ESQUEMA||'.act_sps_sit_posesoria sps on sps.act_id = act.act_id
        	   left  join '||V_ESQUEMA||'.dd_tpa_tipo_titulo_act tpa on tpa.dd_tpa_id = sps.dd_tpa_id
        	   WHERE eal.dd_eal_codigo = ''01'' and act.usuarioborrar like ''HREOS-5932%'')' ;

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.act_sps_sit_posesoria SET 
			dd_tpa_id = (select dd_tpa_id from '||V_ESQUEMA||'.dd_tpa_tipo_titulo_act where dd_tpa_codigo = ''01'')
			,sps_ocupado = 1
		where act_id in (
		select act.act_id
	           from '||V_ESQUEMA||'.act_activo act
	           inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id = pta.act_id
	           inner join '||V_ESQUEMA||'.dd_eal_estado_alquiler eal on pta.dd_eal_id = eal.dd_eal_id
	           inner join '||V_ESQUEMA||'.act_sps_sit_posesoria sps on sps.act_id = act.act_id
	           left  join '||V_ESQUEMA||'.dd_tpa_tipo_titulo_act tpa on tpa.dd_tpa_id = sps.dd_tpa_id
	           WHERE eal.dd_eal_codigo = ''02'' and act.usuarioborrar like ''HREOS-5932%'' )' ;

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

	-- BORRADO DUPLICADOS aux_hreos_5932_perim
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.aux_hreos_5932_perim 
				WHERE ROWID IN  (select ROWID from ( 
						    select act_num_activo , row_number() over (partition by act_num_activo order by act_num_activo desc) AS ORDEN 
						    from '||V_ESQUEMA||'.aux_hreos_5932_perim AUX )
						where ORDEN > 1
						)';
						
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
