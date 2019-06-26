--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20190625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4636
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4636'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
        
BEGIN	
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TIPO ALQUILER');
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.act_sps_sit_posesoria SET
					dd_tpa_id = null
					, sps_ocupado = 0
					, sps_con_titulo = null
					WHERE ACT_ID in (
					select sps.act_id from REM01.aux_inf_hreos_5932 aux
					inner join '||V_ESQUEMA||'.act_activo act on aux.id_haya = act.act_num_activo
					inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id  = pta.act_id
					inner join '||V_ESQUEMA||'.dd_eal_estado_alquiler eal on eal.dd_eal_id = pta.dd_eal_id
					inner join '||V_ESQUEMA||'.act_sps_sit_posesoria sps on act.act_id = sps.act_id
					WHERE eal.dd_eal_codigo = ''01'' AND (sps.dd_tpa_id <> NULL OR sps.sps_ocupado <> 0))';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado : '||SQL%ROWCOUNT||' registros');
		
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ESTADO ADECUACION');
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.act_sps_sit_posesoria SET
					dd_tpa_id = 1
					, sps_ocupado = 1
					, sps_con_titulo = 1
					WHERE ACT_ID in (
					select sps.act_id from '||V_ESQUEMA||'.aux_inf_hreos_5932 aux
					inner join '||V_ESQUEMA||'.act_activo act on aux.id_haya = act.act_num_activo
					inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id  = pta.act_id
					inner join '||V_ESQUEMA||'.dd_eal_estado_alquiler eal on eal.dd_eal_id = pta.dd_eal_id
					inner join '||V_ESQUEMA||'.act_sps_sit_posesoria sps on act.act_id = sps.act_id
					WHERE eal.dd_eal_codigo = ''02'' AND (sps.dd_tpa_id <> 1 OR sps.sps_ocupado <> 1 ))';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado : '||SQL%ROWCOUNT||' registros');
	
		
	COMMIT;
	
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
