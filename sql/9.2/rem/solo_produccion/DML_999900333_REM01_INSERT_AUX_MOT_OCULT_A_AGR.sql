--/*
--##########################################
--## AUTOR=JIN LI, HU
--## FECHA_CREACION=20181004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4525
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'AUX_MOT_OCULT_A_AGR';  -- Tabla a modificar  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4525'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	
	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (OCULTO, DD_MTO_CODIGO, AGR_ID) (
		SELECT DISTINCT
		oculto,
		dd_mto_codigo,
		agr_id
		FROM
			(
				SELECT
					oculto,
					dd_mto_codigo,
					agr_id,
					ROW_NUMBER() OVER(
						PARTITION BY agr_id
						ORDER BY
							orden ASC
					) rownumber
				FROM
					(
						SELECT
							aga.agr_id
									   /*, DECODE(SCM.DD_SCM_CODIGO,''05'',1,0)OCULTO*/ /*Vendido*/,
							1 oculto /*Vendido*/,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_activo act
							JOIN '||V_ESQUEMA||'.dd_scm_situacion_comercial scm ON scm.dd_scm_id = act.dd_scm_id
																		 AND scm.dd_scm_codigo = ''05''
																		 AND scm.borrado = 0
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''13''
																			 AND mto.borrado = 0 /*Vendido*/
						WHERE
							act.borrado = 0
						UNION
						SELECT
							aga.agr_id,
							1 oculto,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_pac_perimetro_activo act
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''08''
																			 AND mto.borrado = 0 /*Salida Perímetro*/
						WHERE
							act.borrado = 0
							AND   act.pac_incluido = 0
											 
						UNION
						SELECT
							aga.agr_id,
							1 oculto,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_pta_patrimonio_activo act
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''05''
																			 AND mto.borrado = 0 /*No adecuado*/
						WHERE
							(
								act.dd_ada_id = (
									SELECT
										ddada.dd_ada_id
									FROM
										'||V_ESQUEMA||'.dd_ada_adecuacion_alquiler ddada
									WHERE
										ddada.borrado = 0
										AND   ddada.dd_ada_codigo = ''02''
								)
								OR    act.dd_ada_id IS NULL
							)
							AND   act.borrado = 0
							AND   act.check_hpm = 1
											                                                                
						UNION
						SELECT
							aga.agr_id,
							1 oculto,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_pac_perimetro_activo act
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''01''
																			 AND mto.borrado = 0 /*No Publicable*/
						WHERE
							act.borrado = 0
							AND   act.pac_check_publicar = 0
											                                   
						UNION
						SELECT
							aga.agr_id
									   /*, DECODE(SCM.DD_SCM_CODIGO,''01'',1,0)OCULTO*/ /*No comercializable*/,
							1 oculto /*No comercializable*/,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_activo act
							JOIN '||V_ESQUEMA||'.dd_scm_situacion_comercial scm ON scm.dd_scm_id = act.dd_scm_id
																		 AND scm.dd_scm_codigo = ''01''
																		 AND scm.borrado = 0
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''02''
																			 AND mto.borrado = 0 /*No Comercializable*/
						WHERE
							act.borrado = 0
										
						UNION
						SELECT
							aga.agr_id
									   /*, DECODE(SCM.DD_SCM_CODIGO,''04'',1,0)OCULTO*/ /*Reservado*/,
							1 oculto /*Reservado*/,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_activo act
							JOIN '||V_ESQUEMA||'.dd_scm_situacion_comercial scm ON scm.dd_scm_id = act.dd_scm_id
																		 AND scm.dd_scm_codigo = ''04''
																		 AND scm.borrado = 0
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''07''
																			 AND mto.borrado = 0 /*Reservado*/
						WHERE
							act.borrado = 0
											
						UNION
						SELECT
							aga.agr_id,
							1 oculto,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_apu_activo_publicacion act
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							JOIN '||V_ESQUEMA||'.act_sps_sit_posesoria sps ON sps.act_id = act.act_id
																	AND sps.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tco_tipo_comercializacion ddtco ON ddtco.dd_tco_id = act.dd_tco_id
																			 AND ddtco.dd_tco_codigo IN (
								''02'',
								''03'',
								''04''
							)
																			 AND ddtco.borrado = 0
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''03''
																			 AND mto.borrado = 0 /*Alquilado*/
						WHERE
							act.borrado = 0
							AND   sps.sps_ocupado = 1
							AND   sps.sps_con_titulo = 1
							AND   (
								(
									trunc(sps.sps_fecha_titulo) <= trunc(SYSDATE)
									AND   trunc(sps.sps_fecha_venc_titulo) >= trunc(SYSDATE)
								)
								OR    (
									trunc(sps.sps_fecha_titulo) <= trunc(SYSDATE)
									AND   sps.sps_fecha_venc_titulo IS NULL
								)
							)
											                                                   
						UNION
						SELECT
							aga.agr_id,
							1 oculto,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_apu_activo_publicacion act
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							JOIN '||V_ESQUEMA||'.v_cond_disponibilidad v ON v.act_id = act.act_id
																  AND v.es_condicionado = 0
							JOIN '||V_ESQUEMA||'.v_cambio_estado_publi_agr est ON est.agr_id = agr.agr_id
																		AND est.informe_comercial = 0 
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''06''
																			 AND mto.borrado = 0 /*Revisión Publicación*/
						WHERE
							act.borrado = 0.
							AND   act.es_condiconado_anterior = 1 
											                                       
						UNION
						SELECT
							aga.agr_id,
							1 oculto,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_apu_activo_publicacion act
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							JOIN '||V_ESQUEMA||'.dd_tco_tipo_comercializacion ddtco ON ddtco.dd_tco_id = act.dd_tco_id
																			 AND ddtco.dd_tco_codigo IN (
								''02'',
								''03'',
								''04''
							)
																			 AND ddtco.borrado = 0
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''14''
																			 AND mto.borrado = 0 /*Precio*/
						WHERE
							act.borrado = 0
							AND   act.apu_check_pub_sin_precio_a = 0
							AND   NOT EXISTS (
								SELECT
									1
								FROM
									'||V_ESQUEMA||'.act_val_valoraciones val
									JOIN '||V_ESQUEMA||'.dd_tpc_tipo_precio tpc ON tpc.dd_tpc_id = val.dd_tpc_id
																		 AND   tpc.borrado = 0
																		 AND   tpc.dd_tpc_codigo = ''03''/*Aprobado de renta (web)*/
								WHERE
									val.borrado = 0
									AND   val.act_id = act.act_id
							)
                                 
						UNION
						SELECT
							aga.agr_id,
							1 oculto,
							mto.dd_mto_codigo,
							mto.dd_mto_orden orden
						FROM
							'||V_ESQUEMA||'.act_apu_activo_publicacion act
							JOIN '||V_ESQUEMA||'.act_aga_agrupacion_activo aga ON aga.act_id = act.act_id
																		AND aga.borrado = 0
							JOIN '||V_ESQUEMA||'.act_agr_agrupacion agr ON agr.agr_id = aga.agr_id
																 AND agr.borrado = 0
							JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
																	 AND tag.borrado = 0
																	 AND tag.dd_tag_codigo = ''02''	/*Restringida*/
																	 AND (
								agr.agr_fin_vigencia IS NULL
								OR trunc(agr.agr_fin_vigencia) >= trunc(SYSDATE)
							)
							JOIN '||V_ESQUEMA||'.act_sps_sit_posesoria sps ON sps.act_id = act.act_id
																	AND sps.borrado = 0
																	AND act.dd_epa_id = (
								SELECT
									ddepa.dd_epa_id
								FROM
									'||V_ESQUEMA||'.dd_epa_estado_pub_alquiler ddepa
								WHERE
									ddepa.borrado = 0
									AND   ddepa.dd_epa_codigo = ''04''
							)/*Oculto Alquiler*/
							LEFT JOIN '||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto ON mto.dd_mto_codigo = ''04''
																			 AND mto.borrado = 0 /*Revisión adecuación*/
						WHERE
							act.borrado = 0
							AND   (
								(
									EXISTS (
										SELECT
											1
										FROM
											'||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto2
										WHERE
											mto2.dd_mto_codigo = ''03'' /*Alquilado*/
											AND   mto2.borrado = 0
											AND   mto2.dd_mto_id = act.dd_mto_a_id
									)
									AND   (
										sps.sps_ocupado = 0
										OR    sps.sps_con_titulo = 0
										OR    sps.sps_fecha_venc_titulo <= SYSDATE
									)
								)
								OR    (
									EXISTS (
										SELECT
											1
										FROM
											'||V_ESQUEMA||'.dd_mto_motivos_ocultacion mto2
										WHERE
											mto2.dd_mto_codigo = ''04'' /*Revisión adecuación*/
											AND   mto2.borrado = 0
											AND   mto2.dd_mto_id = act.dd_mto_a_id
									)
									AND   EXISTS (
										SELECT
											1
										FROM
											'||V_ESQUEMA||'.act_pta_patrimonio_activo pta
										WHERE
											(
												pta.dd_ada_id = (
													SELECT
														ddada.dd_ada_id
													FROM
														'||V_ESQUEMA||'.dd_ada_adecuacion_alquiler ddada
													WHERE
														ddada.borrado = 0
														AND   ddada.dd_ada_codigo = ''02''
												)
												OR    pta.dd_ada_id IS NULL
											)
											AND   pta.borrado = 0
											AND   pta.check_hpm = 1
											AND   pta.act_id = act.act_id
									)
								)
							)                                         
					)
			) aux
		WHERE
		aux.rownumber = 1
	)';
	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS CORRECTAMENTE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA AUX_MOT_OCULT_A_AGR ACTUALIZADA CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
