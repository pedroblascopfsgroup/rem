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
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ESTADO ALQUILER');
	
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.act_pta_patrimonio_activo PTA
					USING (select act.act_id, EALaux.DD_EAL_ID
                            from '||V_ESQUEMA||'.aux_inf_hreos_5932 aux
                            inner join '||V_ESQUEMA||'.act_activo act on aux.id_haya = act.act_num_activo
                            inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id = pta.act_id
                            left join '||V_ESQUEMA||'.dd_ada_adecuacion_alquiler ada on ada.dd_ada_id = pta.dd_ada_id
                            left join '||V_ESQUEMA||'.dd_tpi_tipo_inquilino tpi on pta.dd_tpi_id = tpi.dd_tpi_id
                            left join '||V_ESQUEMA||'.dd_eal_estado_alquiler eal on eal.dd_eal_id = pta.dd_eal_id
                            left join '||V_ESQUEMA||'.dd_tal_tipo_alquiler tal on tal.dd_tal_id = act.dd_tal_id
                            INNER JOIN '||V_ESQUEMA||'.dd_eal_estado_alquiler EALaux on AUX.alquilado = EALaux.DD_EAL_CODIGO
                            where (eal.dd_eal_codigo <> aux.alquilado OR (aux.alquilado is not null  and  eal.dd_eal_codigo is null)  OR (aux.alquilado is  null  and  eal.dd_eal_codigo is not null))
                    ) AUX
					ON (PTA.ACT_ID = AUX.ACT_ID)
					WHEN MATCHED THEN UPDATE SET
						PTA.DD_EAL_ID = AUX.DD_EAL_ID
					,   PTA.USUARIOMODIFICAR = '''||V_USR||'''
					,   PTA.FECHAMODIFICAR = SYSDATE';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado : '||SQL%ROWCOUNT||' registros');
		
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
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
