create or replace PROCEDURE REFRESH_DATA_RULE_ENGINE AS
  CURSOR CUR IS
  SELECT /*+ PARALLEL */ per.per_id, per_riesgo, per_riesgo_autorizado, per_riesgo_ind, per_riesgo_dir_vencido,
					       per_sexo, per_empleado, per.DD_COS_ID, case when per.DD_COS_ID = 20 then 0 else 1 end as colectivo_singular,
					       per.dd_pnv_id, case when per_arq.titular is null then 0 else per_arq.titular end as per_titular,
					       per_riesgo_dispuesto, per.per_deuda_irregular_dir, per_nacionalidad, per_ecv, dd_sce_id,
					       ant.ant_reincidencia_internos, per.dd_tpe_id, per_pais_nacimiento,
					       dd_pol_id, per_fecha_nacimiento, per_arq.SERV_NOMINA_PENSION AS serv_nomina_pension, dd_rex_id,
					       per_fecha_constitucion, per.ofi_id,
					       CASE WHEN per_arq.PER_DOMIC_EXT IS NULL THEN 0 ELSE per_arq.PER_DOMIC_EXT END AS PER_DOMICI_EXT,
					       CASE WHEN per_arq.PER_DEUDA_DESC IS NULL THEN 0 ELSE per_arq.PER_DEUDA_DESC END AS PER_DEUDA_DESC,
					       mov_int_remuneratorios,
					       mov_int_moratorios, dd_apo_id, dd_gc1_id, cnt_fecha_esc,
					       cnt_fecha_constitucion, TRUNC (SYSDATE - mov.mov_cnt_fecha_ini_epi_irreg) AS dias_irregular,
					       mov_deuda_irregular, mov_saldo_dudoso, mov_provision, mov_provision_porcentaje,
					       mov_riesgo_garant, cnt_fecha_efc_ant, mov_ltv_ini, cnt_fecha_efc,
					       mov_comisiones, mov_dispuesto, dd_fno_id, cnt.dd_efc_id, dd_mon_id,
					       dd_ct1_id, cnt_domici_ext, CNT.dd_esc_id, cnt_arq.dd_ece_id, cnt_arq.iac_propietario as ent_propie, cnt_arq.SEGMENTO_CARTERA,
					       mov_ltv_fin, cnt_limite_ini, mov_saldo_pasivo, mov_fecha_pos_vencida, mov_limite_desc,
					       cnt_fecha_venc, cnt_fecha_creacion, mov_saldo_exce, mov_scoring, cnt_limite_fin,
					       dd_efc_id_ant, mov_gastos, per_arq.PER_DEUDA_IRREGULAR_HIPO, nvl(cnt_arq.CNT_DIAS_IRREGULAR_HIPO, 0) CNT_DIAS_IRREGULAR_HIPO,
					        CASE WHEN niv_codigoN0 ='0' THEN SUBSTR(zon_num_centroN0,-6, 4) ELSE NULL END AS CENTRONIVEL0,
					        CASE WHEN niv_codigoN0 ='1' THEN SUBSTR(zon_num_centroN0,-6, 4) WHEN niv_codigoN1 ='1' THEN SUBSTR(zon_num_centroN1,-6, 4) ELSE NULL END AS CENTRONIVEL1,
					        CASE
					        WHEN niv_codigoN0 ='2' THEN SUBSTR(zon_num_centroN0,-6, 4)
					        WHEN niv_codigoN1 ='2' THEN SUBSTR(zon_num_centroN1,-6, 4)
					        WHEN niv_codigoN2 ='2' THEN SUBSTR(zon_num_centroN2,-6, 4)
					        ELSE NULL END AS CENTRONIVEL2,
					        CASE
					        WHEN niv_codigoN0 ='3' THEN SUBSTR(zon_num_centroN0,-6, 4)
					        WHEN niv_codigoN1 ='3' THEN SUBSTR(zon_num_centroN1,-6, 4)
					        WHEN niv_codigoN2 ='3' THEN SUBSTR(zon_num_centroN2,-6, 4)
					        WHEN niv_codigoN3 ='3' THEN SUBSTR(zon_num_centroN3,-6, 4)
					        ELSE NULL END AS CENTRONIVEL3,
					        CASE
					        WHEN niv_codigoN0 ='4' THEN SUBSTR(zon_num_centroN0,-6, 4)
					        WHEN niv_codigoN1 ='4' THEN SUBSTR(zon_num_centroN1,-6, 4)
					        WHEN niv_codigoN2 ='4' THEN SUBSTR(zon_num_centroN2,-6, 4)
					        WHEN niv_codigoN3 ='4' THEN SUBSTR(zon_num_centroN3,-6, 4)
					        WHEN niv_codigoN4 ='4' THEN SUBSTR(zon_num_centroN4,-6, 4)
					        ELSE NULL END AS CENTRONIVEL4,
					        CASE
					        WHEN niv_codigoN0 ='5' THEN SUBSTR(zon_num_centroN0,-6, 4)
					        WHEN niv_codigoN1 ='5' THEN SUBSTR(zon_num_centroN1,-6, 4)
					        WHEN niv_codigoN2 ='5' THEN SUBSTR(zon_num_centroN2,-6, 4)
					        WHEN niv_codigoN3 ='5' THEN SUBSTR(zon_num_centroN3,-6, 4)
					        WHEN niv_codigoN4 ='5' THEN SUBSTR(zon_num_centroN4,-6, 4)
					        WHEN niv_codigoN5 ='5' THEN SUBSTR(zon_num_centroN5,-6, 4)
					        ELSE NULL END AS CENTRONIVEL5,
					        CASE
					        WHEN niv_codigoN0 ='6' THEN SUBSTR(zon_num_centroN0,-6, 4)
					        WHEN niv_codigoN1 ='6' THEN SUBSTR(zon_num_centroN1,-6, 4)
					        WHEN niv_codigoN2 ='6' THEN SUBSTR(zon_num_centroN2,-6, 4)
					        WHEN niv_codigoN3 ='6' THEN SUBSTR(zon_num_centroN3,-6, 4)
					        WHEN niv_codigoN4 ='6' THEN SUBSTR(zon_num_centroN4,-6, 4)
					        WHEN niv_codigoN5 ='6' THEN SUBSTR(zon_num_centroN5,-6, 4)
					        WHEN niv_codigoN6 ='6' THEN SUBSTR(zon_num_centroN6,-6, 4)
					        ELSE NULL END AS CENTRONIVEL6,
					        CASE
					        WHEN niv_codigoN0 ='7' THEN SUBSTR(zon_num_centroN0,-6, 4)
					        WHEN niv_codigoN1 ='7' THEN SUBSTR(zon_num_centroN1,-6, 4)
					        WHEN niv_codigoN2 ='7' THEN SUBSTR(zon_num_centroN2,-6, 4)
					        WHEN niv_codigoN3 ='7' THEN SUBSTR(zon_num_centroN3,-6, 4)
					        WHEN niv_codigoN4 ='7' THEN SUBSTR(zon_num_centroN4,-6, 4)
					        WHEN niv_codigoN5 ='7' THEN SUBSTR(zon_num_centroN5,-6, 4)
					        WHEN niv_codigoN6 ='7' THEN SUBSTR(zon_num_centroN6,-6, 4)
					        WHEN niv_codigoN7 ='7' THEN SUBSTR(zon_num_centroN7,-6, 4)
					        ELSE NULL END AS CENTRONIVEL7,
					        CASE
					        WHEN niv_codigoN0 ='8' THEN SUBSTR(zon_num_centroN0,-6, 4)
					        WHEN niv_codigoN1 ='8' THEN SUBSTR(zon_num_centroN1,-6, 4)
					        WHEN niv_codigoN2 ='8' THEN SUBSTR(zon_num_centroN2,-6, 4)
					        WHEN niv_codigoN3 ='8' THEN SUBSTR(zon_num_centroN3,-6, 4)
					        WHEN niv_codigoN4 ='8' THEN SUBSTR(zon_num_centroN4,-6, 4)
					        WHEN niv_codigoN5 ='8' THEN SUBSTR(zon_num_centroN5,-6, 4)
					        WHEN niv_codigoN6 ='8' THEN SUBSTR(zon_num_centroN6,-6, 4)
					        WHEN niv_codigoN7 ='8' THEN SUBSTR(zon_num_centroN7,-6, 4)
					        WHEN niv_codigoN8 ='8' THEN SUBSTR(zon_num_centroN8,-6, 4)
					        ELSE NULL END AS CENTRONIVEL8,
					        CASE
					        WHEN niv_codigoN0 ='9' THEN SUBSTR(zon_num_centroN0,-6, 4)
					        WHEN niv_codigoN1 ='9' THEN SUBSTR(zon_num_centroN1,-6, 4)
					        WHEN niv_codigoN2 ='9' THEN SUBSTR(zon_num_centroN2,-6, 4)
					        WHEN niv_codigoN3 ='9' THEN SUBSTR(zon_num_centroN3,-6, 4)
					        WHEN niv_codigoN4 ='9' THEN SUBSTR(zon_num_centroN4,-6, 4)
					        WHEN niv_codigoN5 ='9' THEN SUBSTR(zon_num_centroN5,-6, 4)
					        WHEN niv_codigoN6 ='9' THEN SUBSTR(zon_num_centroN6,-6, 4)
					        WHEN niv_codigoN7 ='9' THEN SUBSTR(zon_num_centroN7,-6, 4)
					        WHEN niv_codigoN8 ='9' THEN SUBSTR(zon_num_centroN8,-6, 4)
					        WHEN niv_codigoN9 ='9' THEN SUBSTR(zon_num_centroN9,-6, 4)
					        ELSE NULL END AS CENTRONIVEL9,
					        CASE WHEN niv_codigoPN0 ='0' THEN SUBSTR(zon_num_centroPN0,-6, 4) ELSE NULL END AS CENTRONIVELPER0,
					        CASE WHEN niv_codigoPN0 ='1' THEN SUBSTR(zon_num_centroPN0,-6, 4) WHEN niv_codigoPN1 ='1' THEN SUBSTR(zon_num_centroPN1,-6, 4) ELSE NULL END AS CENTRONIVELPER1,
					        CASE
					        WHEN niv_codigoPN0 ='2' THEN SUBSTR(zon_num_centroPN0,-6, 4)
					        WHEN niv_codigoPN1 ='2' THEN SUBSTR(zon_num_centroPN1,-6, 4)
					        WHEN niv_codigoPN2 ='2' THEN SUBSTR(zon_num_centroPN2,-6, 4)
					        ELSE NULL END AS CENTRONIVELPER2,
					        CASE
					        WHEN niv_codigoPN0 ='3' THEN SUBSTR(zon_num_centroPN0,-6, 4)
					        WHEN niv_codigoPN1 ='3' THEN SUBSTR(zon_num_centroPN1,-6, 4)
					        WHEN niv_codigoPN2 ='3' THEN SUBSTR(zon_num_centroPN2,-6, 4)
					        WHEN niv_codigoPN3 ='3' THEN SUBSTR(zon_num_centroPN3,-6, 4)
					        ELSE NULL END AS CENTRONIVELPER3,
					        CASE
					        WHEN niv_codigoPN0 ='4' THEN SUBSTR(zon_num_centroPN0,-6, 4)
					        WHEN niv_codigoPN1 ='4' THEN SUBSTR(zon_num_centroPN1,-6, 4)
					        WHEN niv_codigoPN2 ='4' THEN SUBSTR(zon_num_centroPN2,-6, 4)
					        WHEN niv_codigoPN3 ='4' THEN SUBSTR(zon_num_centroPN3,-6, 4)
					        WHEN niv_codigoPN4 ='4' THEN SUBSTR(zon_num_centroPN4,-6, 4)
					        ELSE NULL END AS CENTRONIVELPER4,
					        CASE
					        WHEN niv_codigoPN0 ='5' THEN SUBSTR(zon_num_centroPN0,-6, 4)
					        WHEN niv_codigoPN1 ='5' THEN SUBSTR(zon_num_centroPN1,-6, 4)
					        WHEN niv_codigoPN2 ='5' THEN SUBSTR(zon_num_centroPN2,-6, 4)
					        WHEN niv_codigoPN3 ='5' THEN SUBSTR(zon_num_centroPN3,-6, 4)
					        WHEN niv_codigoPN4 ='5' THEN SUBSTR(zon_num_centroPN4,-6, 4)
					        WHEN niv_codigoPN5 ='5' THEN SUBSTR(zon_num_centroPN5,-6, 4)
					        ELSE NULL END AS CENTRONIVELPER5,
					        CASE
					        WHEN niv_codigoPN0 ='6' THEN SUBSTR(zon_num_centroPN0,-6, 4)
					        WHEN niv_codigoPN1 ='6' THEN SUBSTR(zon_num_centroPN1,-6, 4)
					        WHEN niv_codigoPN2 ='6' THEN SUBSTR(zon_num_centroPN2,-6, 4)
					        WHEN niv_codigoPN3 ='6' THEN SUBSTR(zon_num_centroPN3,-6, 4)
					        WHEN niv_codigoPN4 ='6' THEN SUBSTR(zon_num_centroPN4,-6, 4)
					        WHEN niv_codigoPN5 ='6' THEN SUBSTR(zon_num_centroPN5,-6, 4)
					        WHEN niv_codigoPN6 ='6' THEN SUBSTR(zon_num_centroPN6,-6, 4)
					        ELSE NULL END AS CENTRONIVELPER6,
					        CASE
					        WHEN niv_codigoPN0 ='7' THEN SUBSTR(zon_num_centroPN0,-6, 4)
					        WHEN niv_codigoPN1 ='7' THEN SUBSTR(zon_num_centroPN1,-6, 4)
					        WHEN niv_codigoPN2 ='7' THEN SUBSTR(zon_num_centroPN2,-6, 4)
					        WHEN niv_codigoPN3 ='7' THEN SUBSTR(zon_num_centroPN3,-6, 4)
					        WHEN niv_codigoPN4 ='7' THEN SUBSTR(zon_num_centroPN4,-6, 4)
					        WHEN niv_codigoPN5 ='7' THEN SUBSTR(zon_num_centroPN5,-6, 4)
					        WHEN niv_codigoPN6 ='7' THEN SUBSTR(zon_num_centroPN6,-6, 4)
					        WHEN niv_codigoPN7 ='7' THEN SUBSTR(zon_num_centroPN7,-6, 4)
					        ELSE NULL END AS CENTRONIVELPER7,
					        CASE
					        WHEN niv_codigoPN0 ='8' THEN SUBSTR(zon_num_centroPN0,-6, 4)
					        WHEN niv_codigoPN1 ='8' THEN SUBSTR(zon_num_centroPN1,-6, 4)
					        WHEN niv_codigoPN2 ='8' THEN SUBSTR(zon_num_centroPN2,-6, 4)
					        WHEN niv_codigoPN3 ='8' THEN SUBSTR(zon_num_centroPN3,-6, 4)
					        WHEN niv_codigoPN4 ='8' THEN SUBSTR(zon_num_centroPN4,-6, 4)
					        WHEN niv_codigoPN5 ='8' THEN SUBSTR(zon_num_centroPN5,-6, 4)
					        WHEN niv_codigoPN6 ='8' THEN SUBSTR(zon_num_centroPN6,-6, 4)
					        WHEN niv_codigoPN7 ='8' THEN SUBSTR(zon_num_centroPN7,-6, 4)
					        WHEN niv_codigoPN8 ='8' THEN SUBSTR(zon_num_centroPN8,-6, 4)
					        ELSE NULL END AS CENTRONIVELPER8,
					        CASE
					        WHEN niv_codigoPN0 ='9' THEN SUBSTR(zon_num_centroPN0,-6, 4)
					        WHEN niv_codigoPN1 ='9' THEN SUBSTR(zon_num_centroPN1,-6, 4)
					        WHEN niv_codigoPN2 ='9' THEN SUBSTR(zon_num_centroPN2,-6, 4)
					        WHEN niv_codigoPN3 ='9' THEN SUBSTR(zon_num_centroPN3,-6, 4)
					        WHEN niv_codigoPN4 ='9' THEN SUBSTR(zon_num_centroPN4,-6, 4)
					        WHEN niv_codigoPN5 ='9' THEN SUBSTR(zon_num_centroPN5,-6, 4)
					        WHEN niv_codigoPN6 ='9' THEN SUBSTR(zon_num_centroPN6,-6, 4)
					        WHEN niv_codigoPN7 ='9' THEN SUBSTR(zon_num_centroPN7,-6, 4)
					        WHEN niv_codigoPN8 ='9' THEN SUBSTR(zon_num_centroPN8,-6, 4)
					        WHEN niv_codigoPN9 ='9' THEN SUBSTR(zon_num_centroPN9,-6, 4)
					        ELSE NULL END AS CENTRONIVELPER9
                  ,nvl(tin.dd_tin_titular, 0) es_titular
                  , per_arq.MAX_DIAS_IRREGULAR max_dias_irregular
					      FROM  per_personas per
					       LEFT JOIN cpe_contratos_personas cpe ON per.per_id = cpe.per_id --PER_CPE
                 				LEFT JOIN dd_tin_tipo_intervencion tin on cpe.dd_tin_id = tin.dd_tin_id
					       LEFT JOIN cnt_contratos cnt ON cpe.cnt_id = cnt.cnt_id        --CPE_CNT
					       LEFT JOIN mov_movimientos mov ON cnt.cnt_id = mov.cnt_id AND cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion --CNT_MOV
					       LEFT JOIN  ant_antecedentes ant ON ant.ant_id = per.ant_id
					       LEFT JOIN  pto_puntuacion_total pto ON pto.per_id = per.per_id AND (pto.pto_activo = 1 OR pto.pto_activo IS NULL) --PER_PTO
					       LEFT JOIN  per_gcl pg ON pg.per_id = per.per_id
					       LEFT JOIN  gcl_grupos_clientes gcl ON pg.gcl_id = gcl.gcl_id
					       LEFT JOIN  PER_PRECALCULO_ARQ per_arq on per.per_cod_cliente_entidad = per_arq.per_cod_cliente_entidad
					       LEFT JOIN  CNT_PRECALCULO_ARQ cnt_arq on cnt.cnt_contrato = cnt_arq.cnt_contrato
					       LEFT JOIN (select cnt_id,
				                zonN0.zon_id as zon_idN0, zonN0.zon_cod as zon_codN0, zonN0.zon_num_centro as zon_num_centroN0, zonN0.zon_descripcion as zon_descripcionN0, zonN0.zon_pid as zon_pidN0, nivN0.niv_id as niv_idN0, nivN0.niv_codigo as niv_codigoN0, nivN0.niv_descripcion as niv_descripcionN0,
				                zonN1.zon_id as zon_idN1, zonN1.zon_cod as zon_codN1, zonN1.zon_num_centro as zon_num_centroN1, zonN1.zon_descripcion as zon_descripcionN1, zonN1.zon_pid as zon_pidN1, nivN1.niv_id as niv_idN1, nivN1.niv_codigo as niv_codigoN1, nivN1.niv_descripcion as niv_descripcionN1,
				                zonN2.zon_id as zon_idN2, zonN2.zon_cod as zon_codN2, zonN2.zon_num_centro as zon_num_centroN2, zonN2.zon_descripcion as zon_descripcionN2, zonN2.zon_pid as zon_pidN2, nivN2.niv_id as niv_idN2, nivN2.niv_codigo as niv_codigoN2, nivN2.niv_descripcion as niv_descripcionN2,
				                zonN3.zon_id as zon_idN3, zonN3.zon_cod as zon_codN3, zonN3.zon_num_centro as zon_num_centroN3, zonN3.zon_descripcion as zon_descripcionN3, zonN3.zon_pid as zon_pidN3, nivN3.niv_id as niv_idN3, nivN3.niv_codigo as niv_codigoN3, nivN3.niv_descripcion as niv_descripcionN3,
				                zonN4.zon_id as zon_idN4, zonN4.zon_cod as zon_codN4, zonN4.zon_num_centro as zon_num_centroN4, zonN4.zon_descripcion as zon_descripcionN4, zonN4.zon_pid as zon_pidN4, nivN4.niv_id as niv_idN4, nivN4.niv_codigo as niv_codigoN4, nivN4.niv_descripcion as niv_descripcionN4,
				                zonN5.zon_id as zon_idN5, zonN5.zon_cod as zon_codN5, zonN5.zon_num_centro as zon_num_centroN5, zonN5.zon_descripcion as zon_descripcionN5, zonN5.zon_pid as zon_pidN5, nivN5.niv_id as niv_idN5, nivN5.niv_codigo as niv_codigoN5, nivN5.niv_descripcion as niv_descripcionN5,
				                zonN6.zon_id as zon_idN6, zonN6.zon_cod as zon_codN6, zonN6.zon_num_centro as zon_num_centroN6, zonN6.zon_descripcion as zon_descripcionN6, zonN6.zon_pid as zon_pidN6, nivN6.niv_id as niv_idN6, nivN6.niv_codigo as niv_codigoN6, nivN6.niv_descripcion as niv_descripcionN6,
				                zonN7.zon_id as zon_idN7, zonN7.zon_cod as zon_codN7, zonN7.zon_num_centro as zon_num_centroN7, zonN7.zon_descripcion as zon_descripcionN7, zonN7.zon_pid as zon_pidN7, nivN7.niv_id as niv_idN7, nivN7.niv_codigo as niv_codigoN7, nivN7.niv_descripcion as niv_descripcionN7,
				                zonN8.zon_id as zon_idN8, zonN8.zon_cod as zon_codN8, zonN8.zon_num_centro as zon_num_centroN8, zonN8.zon_descripcion as zon_descripcionN8, zonN8.zon_pid as zon_pidN8, nivN8.niv_id as niv_idN8, nivN8.niv_codigo as niv_codigoN8, nivN8.niv_descripcion as niv_descripcionN8,
				                zonN9.zon_id as zon_idN9, zonN9.zon_cod as zon_codN9, zonN9.zon_num_centro as zon_num_centroN9, zonN9.zon_descripcion as zon_descripcionN9, zonN9.zon_pid as zon_pidN9, nivN9.niv_id as niv_idN9, nivN9.niv_codigo as niv_codigoN9, nivN9.niv_descripcion as niv_descripcionN9
				                from CNT_CONTRATOS cnt
				                join  zon_zonificacion zonN0 on cnt.zon_id=zonN0.zon_id
				                join  niv_nivel nivN0 on zonN0.niv_id=nivN0.niv_id
				                join  zon_zonificacion zonN1 on zonN0.zon_pid=zonN1.zon_id
				                join  niv_nivel nivN1 on zonN1.niv_id=nivN1.niv_id
				                join  zon_zonificacion zonN2 on zonN1.zon_pid=zonN2.zon_id
				                join  niv_nivel nivN2 on zonN2.niv_id=nivN2.niv_id
				                join  zon_zonificacion zonN3 on zonN2.zon_pid=zonN3.zon_id
				                join  niv_nivel nivN3 on zonN3.niv_id=nivN3.niv_id
				                join  zon_zonificacion zonN4 on zonN3.zon_pid=zonN4.zon_id
				                join  niv_nivel nivN4 on zonN4.niv_id=nivN4.niv_id
				                join  zon_zonificacion zonN5 on zonN4.zon_pid=zonN5.zon_id
				                join  niv_nivel nivN5 on zonN5.niv_id=nivN5.niv_id
				                join  zon_zonificacion zonN6 on zonN5.zon_pid=zonN6.zon_id
				                join  niv_nivel nivN6 on zonN6.niv_id=nivN6.niv_id
				                join  zon_zonificacion zonN7 on zonN6.zon_pid=zonN7.zon_id
				                join  niv_nivel nivN7 on zonN7.niv_id=nivN7.niv_id
				                join  zon_zonificacion zonN8 on zonN7.zon_pid=zonN8.zon_id
				                join  niv_nivel nivN8 on zonN8.niv_id=nivN8.niv_id
				                join  zon_zonificacion zonN9 on zonN8.zon_pid=zonN9.zon_id
				                join  niv_nivel nivN9 on zonN9.niv_id=nivN9.niv_id) NIVELESCNT ON NIVELESCNT.CNT_ID=CNT.CNT_ID
			               -- LEFT JOIN  DATA_RULE_ENGINE_PER_NIV NIVELESPER ON NIVELESPER.PER_ID=PER.PER_ID
				           LEFT JOIN (select per.per_id,
				                zonPN0.zon_id as zon_idPN0, zonPN0.zon_cod as zon_codPN0, zonPN0.zon_num_centro as zon_num_centroPN0, zonPN0.zon_descripcion as zon_descripcionPN0, zonPN0.zon_pid as zon_pidPN0, nivN0.niv_id as niv_idPN0, nivN0.niv_codigo as niv_codigoPN0, nivN0.niv_descripcion as niv_descripcionPN0,
				                zonPN1.zon_id as zon_idPN1, zonPN1.zon_cod as zon_codPN1, zonPN1.zon_num_centro as zon_num_centroPN1, zonPN1.zon_descripcion as zon_descripcionPN1, zonPN1.zon_pid as zon_pidPN1, nivN1.niv_id as niv_idPN1, nivN1.niv_codigo as niv_codigoPN1, nivN1.niv_descripcion as niv_descripcionPN1,
				                zonPN2.zon_id as zon_idPN2, zonPN2.zon_cod as zon_codPN2, zonPN2.zon_num_centro as zon_num_centroPN2, zonPN2.zon_descripcion as zon_descripcionPN2, zonPN2.zon_pid as zon_pidPN2, nivN2.niv_id as niv_idPN2, nivN2.niv_codigo as niv_codigoPN2, nivN2.niv_descripcion as niv_descripcionPN2,
				                zonPN3.zon_id as zon_idPN3, zonPN3.zon_cod as zon_codPN3, zonPN3.zon_num_centro as zon_num_centroPN3, zonPN3.zon_descripcion as zon_descripcionPN3, zonPN3.zon_pid as zon_pidPN3, nivN3.niv_id as niv_idPN3, nivN3.niv_codigo as niv_codigoPN3, nivN3.niv_descripcion as niv_descripcionPN3,
				                zonPN4.zon_id as zon_idPN4, zonPN4.zon_cod as zon_codPN4, zonPN4.zon_num_centro as zon_num_centroPN4, zonPN4.zon_descripcion as zon_descripcionPN4, zonPN4.zon_pid as zon_pidPN4, nivN4.niv_id as niv_idPN4, nivN4.niv_codigo as niv_codigoPN4, nivN4.niv_descripcion as niv_descripcionPN4,
				                zonPN5.zon_id as zon_idPN5, zonPN5.zon_cod as zon_codPN5, zonPN5.zon_num_centro as zon_num_centroPN5, zonPN5.zon_descripcion as zon_descripcionPN5, zonPN5.zon_pid as zon_pidPN5, nivN5.niv_id as niv_idPN5, nivN5.niv_codigo as niv_codigoPN5, nivN5.niv_descripcion as niv_descripcionPN5,
				                zonPN6.zon_id as zon_idPN6, zonPN6.zon_cod as zon_codPN6, zonPN6.zon_num_centro as zon_num_centroPN6, zonPN6.zon_descripcion as zon_descripcionPN6, zonPN6.zon_pid as zon_pidPN6, nivN6.niv_id as niv_idPN6, nivN6.niv_codigo as niv_codigoPN6, nivN6.niv_descripcion as niv_descripcionPN6,
				                zonPN7.zon_id as zon_idPN7, zonPN7.zon_cod as zon_codPN7, zonPN7.zon_num_centro as zon_num_centroPN7, zonPN7.zon_descripcion as zon_descripcionPN7, zonPN7.zon_pid as zon_pidPN7, nivN7.niv_id as niv_idPN7, nivN7.niv_codigo as niv_codigoPN7, nivN7.niv_descripcion as niv_descripcionPN7,
				                zonPN8.zon_id as zon_idPN8, zonPN8.zon_cod as zon_codPN8, zonPN8.zon_num_centro as zon_num_centroPN8, zonPN8.zon_descripcion as zon_descripcionPN8, zonPN8.zon_pid as zon_pidPN8, nivN8.niv_id as niv_idPN8, nivN8.niv_codigo as niv_codigoPN8, nivN8.niv_descripcion as niv_descripcionPN8,
				                zonPN9.zon_id as zon_idPN9, zonPN9.zon_cod as zon_codPN9, zonPN9.zon_num_centro as zon_num_centroPN9, zonPN9.zon_descripcion as zon_descripcionPN9, zonPN9.zon_pid as zon_pidPN9, nivN9.niv_id as niv_idPN9, nivN9.niv_codigo as niv_codigoPN9, nivN9.niv_descripcion as niv_descripcionPN9
				                from PER_PERSONAS per
				                join  zon_zonificacion zonPN0 on per.ofi_id=zonPN0.ofi_id
				                join  niv_nivel nivN0 on zonPN0.niv_id=nivN0.niv_id
				                join  zon_zonificacion zonPN1 on zonPN0.zon_pid=zonPN1.zon_id
				                join  niv_nivel nivN1 on zonPN1.niv_id=nivN1.niv_id
				                join  zon_zonificacion zonPN2 on zonPN1.zon_pid=zonPN2.zon_id
				                join  niv_nivel nivN2 on zonPN2.niv_id=nivN2.niv_id
				                join  zon_zonificacion zonPN3 on zonPN2.zon_pid=zonPN3.zon_id
				                join  niv_nivel nivN3 on zonPN3.niv_id=nivN3.niv_id
				                join  zon_zonificacion zonPN4 on zonPN3.zon_pid=zonPN4.zon_id
				                join  niv_nivel nivN4 on zonPN4.niv_id=nivN4.niv_id
				                join  zon_zonificacion zonPN5 on zonPN4.zon_pid=zonPN5.zon_id
				                join  niv_nivel nivN5 on zonPN5.niv_id=nivN5.niv_id
				                join  zon_zonificacion zonPN6 on zonPN5.zon_pid=zonPN6.zon_id
				                join  niv_nivel nivN6 on zonPN6.niv_id=nivN6.niv_id
				                join zon_zonificacion zonPN7 on zonPN6.zon_pid=zonPN7.zon_id
				                join niv_nivel nivN7 on zonPN7.niv_id=nivN7.niv_id
				                join zon_zonificacion zonPN8 on zonPN7.zon_pid=zonPN8.zon_id
				                join niv_nivel nivN8 on zonPN8.niv_id=nivN8.niv_id
				                join zon_zonificacion zonPN9 on zonPN8.zon_pid=zonPN9.zon_id
				                join niv_nivel nivN9 on zonPN9.niv_id=nivN9.niv_id) NIVELESPER ON NIVELESPER.PER_ID=PER.PER_ID
			               WHERE per.per_fecha_extraccion = (select max(per_fecha_extraccion) from PER_PERSONAS);
  TYPE T_DATA IS TABLE OF CUR%ROWTYPE INDEX BY BINARY_INTEGER;
  L_DATA T_DATA;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DATA_RULE_ENGINE';

  OPEN CUR;
  LOOP
    FETCH CUR  BULK COLLECT INTO L_DATA LIMIT 1000;

    FORALL I IN 1..L_DATA.COUNT
    INSERT INTO DATA_RULE_ENGINE VALUES L_DATA(I);


    EXIT WHEN CUR%NOTFOUND;

  END LOOP;
  CLOSE CUR;
  COMMIT;
END REFRESH_DATA_RULE_ENGINE;
