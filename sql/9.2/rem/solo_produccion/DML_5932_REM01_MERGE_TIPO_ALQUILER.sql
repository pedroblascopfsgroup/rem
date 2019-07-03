--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20190625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5932
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-5932'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
        
BEGIN	
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TIPO ALQUILER');
	
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
					USING ( select act.act_id , TALaux.dd_tal_id 
                                from '||V_ESQUEMA||'.aux_inf_hreos_5932 aux
                                inner join '||V_ESQUEMA||'.act_activo act on aux.id_haya = act.act_num_activo
                                inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id = pta.act_id
                                left join '||V_ESQUEMA||'.dd_ada_adecuacion_alquiler ada on ada.dd_ada_id = pta.dd_ada_id
                                left join '||V_ESQUEMA||'.dd_tpi_tipo_inquilino tpi on pta.dd_tpi_id = tpi.dd_tpi_id
                                left join '||V_ESQUEMA||'.dd_eal_estado_alquiler eal on eal.dd_eal_id = pta.dd_eal_id
                                left join '||V_ESQUEMA||'.dd_tal_tipo_alquiler tal on tal.dd_tal_id = act.dd_tal_id
                                INNER JOIN '||V_ESQUEMA||'.DD_TAL_TIPO_ALQUILER TALaux on AUX.TIPO_CONTRATO_ALQUILER = TALaux.DD_TAL_CODIGO
                                where (tal.dd_tal_codigo <> aux.tipo_contrato_alquiler OR (aux.tipo_contrato_alquiler is not null  and  tal.dd_tal_codigo is null)  OR (aux.tipo_contrato_alquiler is  null  and  tal.dd_tal_codigo is not null))
                    ) AUX
					ON (ACT.ACT_ID = AUX.ACT_ID)
					WHEN MATCHED THEN UPDATE SET
						ACT.DD_TAL_ID = AUX.DD_TAL_ID
					,   ACT.USUARIOMODIFICAR = '''||V_USR||'''
					,   ACT.FECHAMODIFICAR = SYSDATE';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado : '||SQL%ROWCOUNT||' registros');
		
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ESTADO ADECUACION');
	
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.act_pta_patrimonio_activo PTA
					USING (select PTA.act_id, ADAAUX.DD_ADA_ID
                            from REM01.aux_inf_hreos_5932 aux
                            inner join '||V_ESQUEMA||'.act_activo act on aux.id_haya = act.act_num_activo
                            inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id = pta.act_id
                            left join '||V_ESQUEMA||'.dd_ada_adecuacion_alquiler ada on ada.dd_ada_id = pta.dd_ada_id
                            left join '||V_ESQUEMA||'.dd_tpi_tipo_inquilino tpi on pta.dd_tpi_id = tpi.dd_tpi_id
                            left join '||V_ESQUEMA||'.dd_eal_estado_alquiler eal on eal.dd_eal_id = pta.dd_eal_id
                            left join '||V_ESQUEMA||'.dd_tal_tipo_alquiler tal on tal.dd_tal_id = act.dd_tal_id
                            INNER JOIN '||V_ESQUEMA||'.dd_ada_adecuacion_alquiler ADAAUX on AUX.estado_adecuacion = ADAAUX.DD_ADA_CODIGO
                            where (ada.dd_ada_codigo <> aux.estado_adecuacion OR (aux.estado_adecuacion is not null  and  ada.dd_ada_codigo is null)  OR (aux.estado_adecuacion is  null  and  ada.dd_ada_codigo is not null))
                    ) AUX
					ON (PTA.ACT_ID = AUX.ACT_ID)
					WHEN MATCHED THEN UPDATE SET
						PTA.DD_ADA_ID = AUX.DD_ADA_ID
					,   PTA.USUARIOMODIFICAR = '''||V_USR||'''
					,   PTA.FECHAMODIFICAR = SYSDATE';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado : '||SQL%ROWCOUNT||' registros');
		
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TIPO INQUILINO');
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.act_pta_patrimonio_activo PTA
					USING (select PTA.act_id, TPIAUX.DD_TPI_ID
                            from REM01.aux_inf_hreos_5932 aux
                            inner join '||V_ESQUEMA||'.act_activo act on aux.id_haya = act.act_num_activo
                            inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id = pta.act_id
                            left join '||V_ESQUEMA||'.dd_ada_adecuacion_alquiler ada on ada.dd_ada_id = pta.dd_ada_id
                            left join '||V_ESQUEMA||'.dd_tpi_tipo_inquilino tpi on pta.dd_tpi_id = tpi.dd_tpi_id
                            left join '||V_ESQUEMA||'.dd_eal_estado_alquiler eal on eal.dd_eal_id = pta.dd_eal_id
                            left join '||V_ESQUEMA||'.dd_tal_tipo_alquiler tal on tal.dd_tal_id = act.dd_tal_id
                            INNER JOIN '||V_ESQUEMA||'.dd_tpi_tipo_inquilino TPIAUX on AUX.inquilino_ant_prop = TPIAUX.DD_TPI_CODIGO
                            where (tpi.dd_tpi_codigo <> aux.inquilino_ant_prop OR (aux.inquilino_ant_prop is not null  and  tpi.dd_tpi_codigo is null)  OR (aux.inquilino_ant_prop is  null  and  tpi.dd_tpi_codigo is not null))
                    ) AUX
					ON (PTA.ACT_ID = AUX.ACT_ID)
					WHEN MATCHED THEN UPDATE SET
						PTA.DD_TPI_ID = AUX.DD_TPI_ID
					,   PTA.USUARIOMODIFICAR = '''||V_USR||'''
					,   PTA.FECHAMODIFICAR = SYSDATE';
					
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado : '||SQL%ROWCOUNT||' registros');
		
					
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION CHECK SUBROGADO');
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.act_pta_patrimonio_activo PTA
					USING (select pta.act_id , aux.subrogado 
							from '||V_ESQUEMA||'.aux_inf_hreos_5932 aux
							inner join '||V_ESQUEMA||'.act_activo act on aux.id_haya = act.act_num_activo
							inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id = pta.act_id
							where (pta.check_subrogado <> aux.subrogado OR (aux.subrogado is not null  and pta.check_subrogado is null)  OR (aux.subrogado is  null  and pta.check_subrogado is not null))
					
                    ) AUX
					ON (PTA.ACT_ID = AUX.ACT_ID)
					WHEN MATCHED THEN UPDATE SET
						PTA.check_subrogado = AUX.subrogado
					,   PTA.USUARIOMODIFICAR = '''||V_USR||'''
					,   PTA.FECHAMODIFICAR = SYSDATE';
					
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado : '||SQL%ROWCOUNT||' registros');
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION CHECK RENTA ANTIGUA');
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.act_pta_patrimonio_activo PTA
					USING (select pta.act_id , aux.renta_antigua 
							from '||V_ESQUEMA||'.aux_inf_hreos_5932 aux
							inner join '||V_ESQUEMA||'.act_activo act on aux.id_haya = act.act_num_activo
							inner join '||V_ESQUEMA||'.act_pta_patrimonio_activo pta on act.act_id = pta.act_id
							where (pta.pta_renta_antigua <> aux.renta_antigua OR (aux.renta_antigua is not null  and pta.pta_renta_antigua is null)  OR (aux.renta_antigua is  null  and pta.pta_renta_antigua is not null))
					
                    ) AUX
					ON (PTA.ACT_ID = AUX.ACT_ID)
					WHEN MATCHED THEN UPDATE SET
						PTA.pta_renta_antigua = AUX.renta_antigua
					,   PTA.USUARIOMODIFICAR = '''||V_USR||'''
					,   PTA.FECHAMODIFICAR = SYSDATE';
					
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
