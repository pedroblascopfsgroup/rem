DECLARE
  CURSOR C_FORMULAS IS 
  select 
    PER_MAIN.PER_ID
    , (select est.dd_ecv_descripcion from per_personas c, DD_ECV_ESTADO_CICLO_VIDA est 
          WHERE trim(c.per_ecv) = trim(est.dd_ecv_codigo) and c.borrado = 0 
          and c.per_id = PER_MAIN.PER_ID) EST_CICLO_VIDA
          
    , (select FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV
          WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION 
          and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 1)
          AND CPE.PER_ID = PER_MAIN.PER_ID) AS DIAS_VENC_RIESGO_DIRECTO
          
    , (select FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV
          WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION 
          and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 0) 
          AND CPE.PER_ID = PER_MAIN.PER_ID) AS DIAS_VENC_RIESGO_INDIRECTO
          
    ,(select sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)
          FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV
          WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION
          and cpe.per_id = PER_MAIN.PER_ID) AS RIESGO_TOTAL    
          
    , (select sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)
          FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV
          WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION
          and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 1)
          and cpe.per_id = PER_MAIN.PER_ID) AS RIESGO_TOTAL_DIRECTO
          
    , (select sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)
           FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV
           WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION
          and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 0)
           and cpe.per_id = PER_MAIN.PER_ID) AS RIESGO_TOTAL_INDIRECTO
           
    , (select est.dd_est_descripcion from cli_clientes c,HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS est
          WHERE c.dd_est_id = est.dd_est_id and c.borrado = 0
          and c.per_id = PER_MAIN.PER_ID) AS SITUACION_CLIENTE       
          
    , (select FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV
            WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION
            AND CPE.PER_ID = PER_MAIN.PER_ID) AS DIAS_VENCIDO
            
    , (select count(distinct exp.exp_id) from EXP_EXPEDIENTES exp 
            JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id 
            JOIN HAYAMASTER.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id 
            WHERE pex.borrado = 0 and exp.borrado = 0 and dd_eex.dd_eex_codigo in ('1','4','2')
            and pex.per_id = PER_MAIN.PER_ID) AS NUM_EXP_ACTIVOS
            
    , (SELECT COUNT (DISTINCT asu.asu_id) FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id
            JOIN PRC_CEX pc ON pc.prc_id = prc.prc_id JOIN CEX_CONTRATOS_EXPEDIENTE cex ON pc.cex_id = cex.cex_id
            JOIN CNT_CONTRATOS cnt ON cex.cnt_id = cnt.cnt_id JOIN CPE_CONTRATOS_PERSONAS cpe ON cpe.cnt_id = cnt.cnt_id
            JOIN HAYAMASTER.dd_eas_estado_asuntos dd_eas ON asu.dd_eas_id = dd_eas.dd_eas_id
            WHERE asu.borrado = 0 and prc.borrado = 0 and dd_eas.dd_eas_codigo in ('03','01','02')
            and cpe.per_id = PER_MAIN.PER_ID) AS NUM_ASU_ACTIVOS
            
    ,(SELECT COUNT (DISTINCT asu.asu_id) FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id
            JOIN PRC_PER PRCPER ON PRC.PRC_ID = PRCPER.PRC_ID
            WHERE asu.borrado = 0 and prc.borrado = 0 and PRCPER.PER_ID = PER_MAIN.PER_ID) AS NUM_ASU_ACTIVOS_POR_PRC
            
    , (SELECT COALESCE ((SELECT CASE WHEN COUNT (DISTINCT asu.asu_id) > 0
            THEN 'En Asunto' ELSE NULL END FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id
            JOIN PRC_CEX pc ON pc.prc_id = prc.prc_id JOIN CEX_CONTRATOS_EXPEDIENTE cex ON pc.cex_id = cex.cex_id
            JOIN CNT_CONTRATOS cnt ON cex.cnt_id = cnt.cnt_id JOIN CPE_CONTRATOS_PERSONAS cpe ON cpe.cnt_id = cnt.cnt_id
            JOIN HAYAMASTER.dd_eas_estado_asuntos dd_eas ON asu.dd_eas_id = dd_eas.dd_eas_id
            WHERE asu.borrado = 0 and prc.borrado = 0 and dd_eas.dd_eas_codigo IN ('01','02','03')
            and cpe.per_id = PER_MAIN.PER_ID),
            (SELECT CASE WHEN COUNT (EXP.exp_id) > 0 THEN 'Expediente interno' ELSE NULL END
            from EXP_EXPEDIENTES exp
            JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id
            JOIN DD_TPX_TIPO_EXPEDIENTE tpx on TPX.DD_TPX_ID=EXP.DD_TPX_ID and TPX.DD_TPX_CODIGO='INT'
            JOIN HAYAMASTER.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id
            WHERE pex.borrado = 0 and exp.borrado = 0 
            and dd_eex.dd_eex_codigo in ('1','2','4')
            and pex.per_id = PER_MAIN.PER_ID),
            (SELECT CASE WHEN COUNT (EXP.exp_id) > 0 
            THEN 'Expediente de recobro' ELSE NULL END 
            from EXP_EXPEDIENTES exp 
            JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id 
            JOIN DD_TPX_TIPO_EXPEDIENTE tpx on TPX.DD_TPX_ID=EXP.DD_TPX_ID and TPX.DD_TPX_CODIGO='REC'
            JOIN HAYAMASTER.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id 
            WHERE pex.borrado = 0 and exp.borrado = 0 
            and dd_eex.dd_eex_codigo in ('1','2','4')
            and pex.per_id = PER_MAIN.PER_ID), 
            (SELECT est.dd_est_descripcion 
            FROM HAYAMASTER.dd_est_estados_itinerarios est 
            WHERE est.dd_est_id = COALESCE (cli.dd_est_id, NULL)), 'Normal') 
            FROM cpe_contratos_personas cpe 
            LEFT JOIN cli_clientes cli ON cpe.per_id = cli.per_id AND cli.borrado = 0 WHERE cpe.per_id = PER_MAIN.PER_ID AND ROWNUM = 1) AS SITUACION
    
    , (SELECT COALESCE(
            (SELECT CASE
            WHEN COUNT (1) > 0
                THEN 'Titular CP'
               ELSE NULL 
            END 
            FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, HAYAMASTER.dd_eex_estado_expediente dd_eex
            where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id 
            and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4')  and cex.cex_pase = 1 and tin.dd_tin_titular = 1 
            ), 
            (SELECT CASE 
            WHEN COUNT (1) > 0 
               THEN 'Titular OC'
             ELSE NULL 
            END 
            FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, HAYAMASTER.dd_eex_estado_expediente dd_eex 
            where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id 
              and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4')  and cex.cex_pase = 0 and tin.dd_tin_titular = 1 
            ), 
            (SELECT CASE
             WHEN COUNT (*) > 0 
                THEN 'Avalista' 
             ELSE NULL 
            END 
            FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, HAYAMASTER.dd_eex_estado_expediente dd_eex 
            where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id 
               and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4') and tin.dd_tin_avalista = 1 
            ), '') 
            FROM PER_PERSONAS per 
            WHERE per.per_id = PER_MAIN.PER_ID AND ROWNUM = 1) AS RELACION_EXP
    
    ,(select icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.per_id = PER_MAIN.per_id
              and icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'SERV_NOMINA_PENSION'
            )) AS SERV_NOMINIA_PENSION
            
    , (select icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.per_id = PER_MAIN.per_id 
              and icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'ULTIMA_ACTUACION'
            )) AS ULTIMA_ACTUACION
            
    , (select icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.per_id = PER_MAIN.per_id 
              and icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'num_extra1'
            )) AS DISPUESTO_NO_VENCIDO 
            
    , (select icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.per_id = PER_MAIN.per_id 
              and icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'num_extra2'
            )) AS DISPUESTO_VENCIDO   
            
    , (select tcn.dd_tcn_descripcion from EXT_ICC_INFO_EXTRA_CLI icc, HAYAMASTER.DD_TCN_TIPO_CNAE tcn
              where icc.per_id = PER_MAIN.per_id 
              and icc.icc_value = tcn.dd_tcn_codigo
              and icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'char_extra1'
            )) AS DESC_CNAE        
    from PER_PERSONAS PER_MAIN WHERE ROWNUM <= 100000;

  TYPE T_FORMULAS IS TABLE OF C_FORMULAS%ROWTYPE INDEX BY PLS_INTEGER;
  L_FORMULAS T_FORMULAS;
BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_PER_PERSONAS_FORMULAS';

    OPEN C_FORMULAS;
    LOOP
      FETCH C_FORMULAS BULK COLLECT INTO L_FORMULAS LIMIT 10000;
      
      FORALL i IN 1 .. L_FORMULAS.COUNT
           INSERT INTO TMP_PER_PERSONAS_FORMULAS VALUES L_FORMULAS(i);
          
      EXIT WHEN C_FORMULAS%NOTFOUND ;
      
    END LOOP;
    
    CLOSE C_FORMULAS;
    
    COMMIT;
END;