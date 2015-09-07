MERGE INTO bank01.cnv_aux_ccdd_pr_conv_cierr_dd dd
   USING (SELECT cdd.id_acuerdo_cierre, hijo1.prc_id nuevo
            FROM bank01.cnv_aux_ccdd_pr_conv_cierr_dd cdd JOIN bank01.prc_procedimientos prc ON cdd.prc_id = prc.prc_id AND prc.borrado = 0
                 JOIN bank01.dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
                 JOIN bank01.prc_procedimientos hijo1 ON cdd.prc_id = hijo1.prc_prc_id AND hijo1.borrado = 0
                 JOIN bank01.dd_tpo_tipo_procedimiento tpo_hijo1 ON hijo1.dd_tpo_id = tpo_hijo1.dd_tpo_id AND tpo.dd_tpo_id = 2444
                 JOIN bank01.prb_prc_bie prb ON cdd.bie_id = prb.bie_id AND hijo1.prc_id = prb.prc_id
           WHERE fecha_entrega IS NULL
             AND resultado_validacion = 1
             AND entidad = 'SAREB'
             AND fecha_alta >= '04/08/2015'
             AND cdd.id_acuerdo_cierre NOT IN (SELECT   cdd.id_acuerdo_cierre
                                                   FROM bank01.cnv_aux_ccdd_pr_conv_cierr_dd cdd JOIN bank01.prc_procedimientos prc ON cdd.prc_id = prc.prc_id AND prc.borrado = 0
                                                        JOIN bank01.dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
                                                        JOIN bank01.prc_procedimientos hijo1 ON cdd.prc_id = hijo1.prc_prc_id AND hijo1.borrado = 0
                                                        JOIN bank01.dd_tpo_tipo_procedimiento tpo_hijo1 ON hijo1.dd_tpo_id = tpo_hijo1.dd_tpo_id AND tpo.dd_tpo_id = 2444
                                                        JOIN bank01.prb_prc_bie prb ON cdd.bie_id = prb.bie_id AND hijo1.prc_id = prb.prc_id
                                                  WHERE fecha_entrega IS NULL AND resultado_validacion = 1 AND entidad = 'SAREB' AND fecha_alta >= '04/08/2015'
                                               GROUP BY cdd.id_acuerdo_cierre
                                                 HAVING COUNT (*) > 1)) tmp2
   ON (dd.id_acuerdo_cierre = tmp2.id_acuerdo_cierre)
   WHEN MATCHED THEN
      UPDATE
         SET dd.prc_id = tmp2.nuevo;