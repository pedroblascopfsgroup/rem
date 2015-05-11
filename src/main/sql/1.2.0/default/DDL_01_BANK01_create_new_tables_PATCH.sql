 CREATE MATERIALIZED VIEW BATCH_RCF_ENTRADA 
 		   (rcf_esq_id,
           rcf_esq_plazo,
           rcf_esq_fecha_lib,
           rcf_esq_borrado,
           rcf_dd_ees_id,
           rcf_dd_ees_codigo,
           rcf_dd_ees_borrado,
           rcf_dd_mtr_id,
           rcf_dd_mtr_codigo,
           rcf_dd_mtr_borrado,
           rcf_car_id,
           rcf_car_nombre,
           rcf_car_borrado,
           rcf_dd_eca_id,
           rcf_dd_eca_codigo,
           rcf_dd_eca_borrado,
           rd_id,
           rd_name,
           rd_definition,
           rd_borrado,
           rcf_age_id,
           rcf_age_nombre,
           rcf_age_codigo,
           rcf_age_borrado,
           rcf_esc_id,
           rcf_esc_prioridad,
           rcf_esc_borrado,
           rcf_dd_tce_id,
           rcf_dd_tce_codigo,
           rcf_dd_tce_borrado,
           rcf_dd_tgc_id,
           rcf_dd_tgc_codigo,
           rcf_dd_tgc_borrado,
           rcf_dd_aer_id,
           rcf_dd_aer_codigo,
           rcf_dd_aer_borrado,
           rcf_sca_id,
           rcf_sca_nombre,
           rcf_sca_particion,
           rcf_sca_borrado,
           rcf_dd_tpr_id,
           rcf_dd_tpr_codigo,
           rcf_dd_tpr_borrado,
           rcf_itv_id,
           rcf_itv_nombre,
           rcf_itv_fecha_alta,
           rcf_itv_plazo_max,
           rcf_itv_no_gest,
           rcf_itv_borrado,
           rcf_mfa_id,
           rcf_mfa_nombre,
           rcf_mfa_borrado,
           rcf_poa_id,
           rcf_poa_codigo,
           rcf_poa_borrado,
           rcf_mor_id,
           rcf_mor_nombre,
           rcf_mor_borrado,
           rcf_sua_id,
           rcf_sua_coeficiente,
           rcf_sua_borrado,
           rcf_sur_id,
           rcf_sur_posicion,
           rcf_sur_porcentaje,
           rcf_sur_borrado
          )
	BUILD IMMEDIATE
	REFRESH FORCE ON DEMAND
	WITH PRIMARY KEY
	AS
   SELECT esq.rcf_esq_id AS rcf_esq_id, esq.rcf_esq_plazo AS rcf_esq_plazo,
          esq.rcf_esq_fecha_lib AS rcf_esq_fecha_lib,
          esq.borrado AS rcf_esq_borrado, ees.rcf_dd_ees_id AS rcf_dd_ees_id,
          ees.rcf_dd_ees_codigo AS rcf_dd_ees_codigo,
          ees.borrado AS rcf_dd_ees_borrado,
          mtr.rcf_dd_mtr_id AS rcf_dd_mtr_id,
          mtr.rcf_dd_mtr_codigo AS rcf_dd_mtr_codigo,
          mtr.borrado AS rcf_dd_mtr_borrado, car.rcf_car_id AS rcf_car_id,
          car.rcf_car_nombre AS rcf_car_nombre,
          car.borrado AS rcf_car_borrado,
          CAST (NULL AS NUMBER (16)) AS rcf_dd_eca_id,   --ECA.RCF_DD_ECA_ID ,
          CAST (NULL AS NUMBER (16)) AS rcf_dd_eca_codigo,
                                                     --ECA.RCF_DD_ECA_CODIGO ,
          CAST (NULL AS NUMBER (16)) AS rcf_dd_eca_borrado,    --ECA.BORRADO ,
          rul.rd_id AS rd_id, rul.rd_name AS rd_name,
          rul.rd_definition AS rd_definition, rul.borrado AS rd_borrado,
          age.rcf_age_id AS rcf_age_id, age.rcf_age_nombre AS rcf_age_nombre,
          age.rcf_age_codigo AS rcf_age_codigo,
          age.borrado AS rcf_age_borrado, esc.rcf_esc_id AS rcf_esc_id,
          esc.rcf_esc_prioridad AS rcf_esc_prioridad,
          esc.borrado AS rcf_esc_borrado, tce.dd_tce_id AS rcf_dd_tce_id,
          tce.dd_tce_codigo AS rcf_dd_tce_codigo,
          tce.borrado AS rcf_dd_tce_borrado, tgc.dd_tgc_id AS rcf_dd_tgc_id,
          tgc.dd_tgc_codigo AS rcf_dd_tgc_codigo,
          tgc.borrado AS rcf_dd_tgc_borrado, aer.dd_aer_id AS rcf_dd_aer_id,
          aer.dd_aer_codigo AS rcf_dd_aer_codigo,
          aer.borrado AS rcf_dd_aer_borrado, sca.rcf_sca_id AS rcf_sca_id,
          sca.rcf_sca_nombre AS rcf_sca_nombre,
          sca.rcf_sca_particion AS rcf_sca_particion,
          sca.borrado AS rcf_sca_borrado, tpr.rcf_dd_tpr_id AS rcf_dd_tpr_id,
          tpr.rcf_dd_tpr_codigo AS rcf_dd_tpr_codigo,
          tpr.borrado AS rcf_dd_tpr_borrado, itv.rcf_itv_id AS rcf_itv_id,
          itv.rcf_itv_nombre AS rcf_itv_nombre,
          itv.rcf_itv_fecha_alta AS rcf_itv_fecha_alta,
          itv.rcf_itv_plazo_max AS rcf_itv_plazo_max,
          itv.rcf_itv_no_gest AS rcf_itv_no_gest,
          itv.borrado AS rcf_itv_borrado, mfa.rcf_mfa_id AS rcf_mfa_id,
          mfa.rcf_mfa_nombre AS rcf_mfa_nombre,
          mfa.borrado AS rcf_mfa_borrado, poa.rcf_poa_id AS rcf_poa_id,
          poa.rcf_poa_codigo AS rcf_poa_codigo,
          poa.borrado AS rcf_poa_borrado, mor.rcf_mor_id AS rcf_mor_id,
          mor.rcf_mor_nombre AS rcf_mor_nombre,
          mor.borrado AS rcf_mor_borrado, sua.rcf_sua_id AS rcf_sua_id,
          sua.rcf_sua_coeficiente AS rcf_sua_coeficiente,
          sua.borrado AS rcf_sua_borrado, sur.rcf_sur_id AS rcf_sur_id,
          sur.rcf_sur_posicion AS rcf_sur_posicion,
          sur.rcf_sur_porcentaje AS rcf_sur_porcentaje,
          sur.borrado AS rcf_sur_borrado
     FROM rcf_esq_esquema esq JOIN rcf_dd_mtr_modelo_transicion mtr
          ON esq.rcf_dd_mtr_id = mtr.rcf_dd_mtr_id
          JOIN rcf_dd_ees_estado_esquema ees
          ON esq.rcf_dd_ees_id = ees.rcf_dd_ees_id
          JOIN rcf_esc_esquema_carteras esc ON esq.rcf_esq_id = esc.rcf_esq_id
          LEFT JOIN rcf_dd_tgc_tipo_gestion_cart tgc ON esc.dd_tgc_id =
                                                                 tgc.dd_tgc_id
          JOIN rcf_dd_tce_tipo_cartera_esq tce ON esc.dd_tce_id =
                                                                 tce.dd_tce_id
          LEFT JOIN rcf_dd_aer_ambito_exp_rec aer ON esc.dd_aer_id = aer.dd_aer_id
          JOIN rcf_car_cartera car ON esc.rcf_car_id = car.rcf_car_id
          --JOIN RCF_DD_ECA_ESTADO_CARTERA ECA ON CAR.RCF_DD_ECA_ID = ECA.RCF_DD_ECA_ID
          JOIN rule_definition rul ON car.rd_id = rul.rd_id
          LEFT JOIN rcf_sca_subcartera sca
          ON esc.rcf_esc_id = sca.rcf_esc_id AND sca.borrado = 0
          LEFT JOIN rcf_dd_tpr_tipo_reparto_subc tpr
          ON sca.rcf_dd_tpr_id = tpr.rcf_dd_tpr_id AND tpr.borrado = 0
          LEFT JOIN rcf_itv_iti_metas_volantes itv
          ON sca.rcf_itv_id = itv.rcf_itv_id AND itv.borrado = 0
          LEFT JOIN rcf_mfa_modelos_facturacion mfa
          ON sca.rcf_mfa_id = mfa.rcf_mfa_id AND mfa.borrado = 0
          LEFT JOIN rcf_sua_subcartera_agencias sua
          ON sca.rcf_sca_id = sua.rcf_sca_id AND sua.borrado = 0
          LEFT JOIN rcf_age_agencias age
          ON sua.rcf_age_id = age.rcf_age_id AND age.borrado = 0
          LEFT JOIN rcf_sur_subcartera_ranking sur
          ON sca.rcf_sca_id = sur.rcf_sur_id AND sur.borrado = 0
          LEFT JOIN rcf_poa_politica_acuerdos poa
          ON sca.rcf_poa_id = poa.rcf_poa_id AND poa.borrado = 0
          LEFT JOIN rcf_mor_modelo_ranking mor ON sca.rcf_mor_id =
                                                                mor.rcf_mor_id
    WHERE ees.rcf_dd_ees_codigo IN ('EXG', 'LBR');
