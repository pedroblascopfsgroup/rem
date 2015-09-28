TRUNCATE TABLE PER_PERSONAS_FORMULAS;
TRUNCATE TABLE TMP_PER_MOV;

INSERT INTO TMP_PER_EST_CICLO_VIDA
select per_id, est.dd_ecv_descripcion from per_personas c, DD_ECV_ESTADO_CICLO_VIDA est 
          WHERE trim(c.per_ecv) = trim(est.dd_ecv_codigo) and c.borrado = 0 ;
          
INSERT INTO TMP_PER_MOV
SELECT CPE.PER_ID, MOV.MOV_ID, TIN.DD_TIN_TITULAR
FROM CPE_CONTRATOS_PERSONAS CPE
  JOIN DD_TIN_TIPO_INTERVENCION TIN ON CPE.DD_TIN_ID = TIN.DD_TIN_ID
  JOIN CNT_CONTRATOS CNT ON CPE.CNT_ID = CNT.CNT_ID
  JOIN MOV_MOVIMIENTOS MOV ON CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION;

BEGIN  
  utiles.analiza_tabla('HAYA01','TMP_PER_MOV');
END;
/

INSERT INTO TMP_PER_DVENC_RIES_DIREC          
select CPE.PER_ID, FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) MIN_MOV_FECHA_POS_VENCIDA 
FROM CPE_CONTRATOS_PERSONAS CPE
  JOIN TMP_PER_MOV REL ON CPE.PER_ID = REL.PER_ID AND REL.DD_TIN_TITULAR = 1
  JOIN MOV_MOVIMIENTOS MOV ON MOV.MOV_ID = REL.MOV_ID
GROUP BY CPE.PER_ID;          
          
INSERT INTO TMP_PER_DVENC_RIES_INDIREC
select CPE.PER_ID, FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) 
FROM CPE_CONTRATOS_PERSONAS CPE
  JOIN TMP_PER_MOV REL ON CPE.PER_ID = REL.PER_ID AND REL.DD_TIN_TITULAR = 0
  JOIN MOV_MOVIMIENTOS MOV ON MOV.MOV_ID = REL.MOV_ID
GROUP BY CPE.PER_ID;
          
INSERT INTO TMP_PER_RIESGO_TOTAL
select CPE.PER_ID, sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)
FROM CPE_CONTRATOS_PERSONAS CPE
  JOIN TMP_PER_MOV REL ON CPE.PER_ID = REL.PER_ID
  JOIN MOV_MOVIMIENTOS MOV ON MOV.MOV_ID = REL.MOV_ID
GROUP BY CPE.PER_ID;

INSERT INTO TMP_PER_RIESGO_TOTAL_DIRECTO
select CPE.PER_ID, sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)
FROM CPE_CONTRATOS_PERSONAS CPE
  JOIN TMP_PER_MOV REL ON CPE.PER_ID = REL.PER_ID AND REL.DD_TIN_TITULAR = 1
  JOIN MOV_MOVIMIENTOS MOV ON MOV.MOV_ID = REL.MOV_ID
GROUP BY CPE.PER_ID;

INSERT INTO TMP_PER_RIESGO_TOTAL_INDIRECTO
select CPE.PER_ID, sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)
FROM CPE_CONTRATOS_PERSONAS CPE
  JOIN TMP_PER_MOV REL ON CPE.PER_ID = REL.PER_ID AND REL.DD_TIN_TITULAR = 0
  JOIN MOV_MOVIMIENTOS MOV ON MOV.MOV_ID = REL.MOV_ID
GROUP BY CPE.PER_ID;

INSERT INTO TMP_PER_SITUACION_CLIENTE
select C.PER_ID, est.dd_est_descripcion 
from cli_clientes c
  JOIN HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS est ON c.dd_est_id = est.dd_est_id
WHERE c.borrado = 0;

INSERT INTO TMP_PER_DIAS_VENCIDO
select CPE.PER_ID, FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) 
FROM CPE_CONTRATOS_PERSONAS CPE
  JOIN TMP_PER_MOV REL ON CPE.PER_ID = REL.PER_ID
  JOIN MOV_MOVIMIENTOS MOV ON MOV.MOV_ID = REL.MOV_ID
GROUP BY CPE.PER_ID;

INSERT INTO TMP_PER_NUM_EXP_ACTIVOS
select PEX.PER_ID, count(distinct exp.exp_id) 
from EXP_EXPEDIENTES exp 
   JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id 
  JOIN HAYAMASTER.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id 
WHERE pex.borrado = 0 and exp.borrado = 0 and dd_eex.dd_eex_codigo in ('1','4','2')
GROUP  BY PEX.PER_ID;

INSERT INTO TMP_PER_NUM_ASU_ACTIVOS
SELECT cpe.per_id , COUNT (DISTINCT asu.asu_id) FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id
            JOIN PRC_CEX pc ON pc.prc_id = prc.prc_id JOIN CEX_CONTRATOS_EXPEDIENTE cex ON pc.cex_id = cex.cex_id
            JOIN CNT_CONTRATOS cnt ON cex.cnt_id = cnt.cnt_id JOIN CPE_CONTRATOS_PERSONAS cpe ON cpe.cnt_id = cnt.cnt_id
            JOIN HAYAMASTER.dd_eas_estado_asuntos dd_eas ON asu.dd_eas_id = dd_eas.dd_eas_id
            WHERE asu.borrado = 0 and prc.borrado = 0 and dd_eas.dd_eas_codigo in ('03','01','02')
GROUP BY cpe.per_id;

INSERT INTO TMP_PER_NUM_ASU_ACT_POR_PRC
SELECT PRCPER.PER_ID, COUNT (DISTINCT asu.asu_id) FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id
            JOIN PRC_PER PRCPER ON PRC.PRC_ID = PRCPER.PRC_ID
            WHERE asu.borrado = 0 and prc.borrado = 0
GROUP BY PRCPER.PER_ID;

INSERT INTO TMP_PER_SITUACION
SELECT PER_ID, VALUE FROM (
  SELECT cpe.per_id, COALESCE ((SELECT CASE WHEN COUNT (DISTINCT asu.asu_id) > 0
            THEN 'En Asunto' ELSE NULL END FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id
            JOIN PRC_CEX pc ON pc.prc_id = prc.prc_id JOIN CEX_CONTRATOS_EXPEDIENTE cex ON pc.cex_id = cex.cex_id
            JOIN CNT_CONTRATOS cnt ON cex.cnt_id = cnt.cnt_id JOIN CPE_CONTRATOS_PERSONAS cpe ON cpe.cnt_id = cnt.cnt_id
            JOIN HAYAMASTER.dd_eas_estado_asuntos dd_eas ON asu.dd_eas_id = dd_eas.dd_eas_id
            WHERE asu.borrado = 0 and prc.borrado = 0 and dd_eas.dd_eas_codigo IN ('01','02','03')),
            (SELECT CASE WHEN COUNT (EXP.exp_id) > 0 THEN 'Expediente interno' ELSE NULL END
            from EXP_EXPEDIENTES exp
            JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id
            JOIN DD_TPX_TIPO_EXPEDIENTE tpx on TPX.DD_TPX_ID=EXP.DD_TPX_ID and TPX.DD_TPX_CODIGO='INT'
            JOIN HAYAMASTER.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id
            WHERE pex.borrado = 0 and exp.borrado = 0 
            and dd_eex.dd_eex_codigo in ('1','2','4')),
            (SELECT CASE WHEN COUNT (EXP.exp_id) > 0 
            THEN 'Expediente de recobro' ELSE NULL END 
            from EXP_EXPEDIENTES exp 
            JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id 
            JOIN DD_TPX_TIPO_EXPEDIENTE tpx on TPX.DD_TPX_ID=EXP.DD_TPX_ID and TPX.DD_TPX_CODIGO='REC'
            JOIN HAYAMASTER.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id 
            WHERE pex.borrado = 0 and exp.borrado = 0 
            and dd_eex.dd_eex_codigo in ('1','2','4')), 
            (SELECT est.dd_est_descripcion 
            FROM HAYAMASTER.dd_est_estados_itinerarios est 
            WHERE est.dd_est_id = COALESCE (cli.dd_est_id, NULL)), 'Normal') VALUE
            , ROW_NUMBER() OVER (PARTITION BY CPE.PER_ID ORDER BY CPE.PER_ID) ORD
            FROM cpe_contratos_personas cpe 
            LEFT JOIN cli_clientes cli ON cpe.per_id = cli.per_id AND cli.borrado = 0
) WHERE ORD = 1
;

-- COMENTADO POR CUESTIÓN DE RENDIMIENTO
--INSERT INTO TMP_PER_RELACION_EXP
--SELECT PER_ID, VALUE FROM (
--  SELECT PER.PER_ID , COALESCE(
--            (SELECT CASE
--            WHEN COUNT (1) > 0
--                THEN 'Titular CP'
--               ELSE NULL 
--            END 
--            FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, HAYAMASTER.dd_eex_estado_expediente dd_eex
--            where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id 
--            and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4')  and cex.cex_pase = 1 and tin.dd_tin_titular = 1 
--            ), 
--            (SELECT CASE 
--            WHEN COUNT (1) > 0 
--               THEN 'Titular OC'
--             ELSE NULL 
--            END 
--            FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, HAYAMASTER.dd_eex_estado_expediente dd_eex 
--            where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id 
--              and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4')  and cex.cex_pase = 0 and tin.dd_tin_titular = 1 
--            ), 
--            (SELECT CASE
--             WHEN COUNT (1) > 0 
--                THEN 'Avalista' 
--             ELSE NULL 
--            END 
--            FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, HAYAMASTER.dd_eex_estado_expediente dd_eex 
--            where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id 
--               and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4') and tin.dd_tin_avalista = 1 
--            ), '') VALUE, ROW_NUMBER() OVER (PARTITION BY PER.PER_ID ORDER BY PER.PER_ID) ORD 
--            FROM PER_PERSONAS per
--) WHERE ORD = 1;

INSERT INTO TMP_PER_SERV_NOMINIA_PENSION
select icc.per_id, icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'SERV_NOMINA_PENSION'
            );
            
INSERT INTO TMP_PER_ULTIMA_ACTUACION
select icc.per_id, icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where  icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'ULTIMA_ACTUACION'
            );
            
INSERT INTO TMP_PER_DISPUESTO_NO_VENCIDO
select icc.per_id, icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where  icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'num_extra1'
            );
          
INSERT INTO TMP_PER_DISPUESTO_VENCIDO
select icc.per_id, icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where  icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'num_extra2'
            );
            
INSERT INTO TMP_PER_DESC_CNAE
select icc.per_id, tcn.dd_tcn_descripcion 
from EXT_ICC_INFO_EXTRA_CLI icc
  JOIN HAYAMASTER.DD_TCN_TIPO_CNAE tcn ON icc.icc_value = tcn.dd_tcn_codigo
where  icc.dd_ifx_id = (
            select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = 'char_extra1'
            );

INSERT INTO PER_PERSONAS_FORMULAS (PER_ID, EST_CICLO_VIDA, DIAS_VENC_RIESGO_DIRECTO, DIAS_VENC_RIESGO_INDIRECTO
        , RIESGO_TOTAL, RIESGO_TOTAL_DIRECTO, RIESGO_TOTAL_INDIRECTO, SITUACION_CLIENTE, DIAS_VENCIDO
        , NUM_EXP_ACTIVOS, NUM_ASU_ACTIVOS, NUM_ASU_ACTIVOS_POR_PRC, SITUACION, RELACION_EXP, SERV_NOMINIA_PENSION
        , ULTIMA_ACTUACION, DISPUESTO_NO_VENCIDO, DISPUESTO_VENCIDO, DESC_CNAE)
SELECT PER.PER_ID
      , T1.EST_CICLO_VIDA
      , T2.MIN_MOV_FECHA_POS_VENCIDA
      , T3.DIAS_VENC_RIESGO_INDIRECTO
      , T4.RIESGO_TOTAL
      , T5.RIESGO_TOTAL_DIRECTO
      , T6.RIESGO_TOTAL_INDIRECTO
      , T7.SITUACION_CLIENTE
      , T8.DIAS_VENCIDO
      , T9.NUM_EXP_ACTIVOS
      , T10.NUM_ASU_ACTIVOS
      , T11.NUM_ASU_ACTIVOS_POR_PRC
      , T12.SITUACION
      , T13.RELACION_EXP
      , T14.SERV_NOMINIA_PENSION
      , T15.ULTIMA_ACTUACION
      , T16.DISPUESTO_NO_VENCIDO
      , T17.DISPUESTO_VENCIDO
      , T18.DESC_CNAE
FROM PER_PERSONAS PER
  LEFT JOIN TMP_PER_EST_CICLO_VIDA T1 ON PER.PER_ID = T1.PER_ID
  LEFT JOIN TMP_PER_DVENC_RIES_DIREC T2 ON PER.PER_ID = T2.PER_ID
  LEFT JOIN TMP_PER_DVENC_RIES_INDIREC T3 ON PER.PER_ID = T3.PER_ID
  LEFT JOIN TMP_PER_RIESGO_TOTAL T4 ON PER.PER_ID = T4.PER_ID
  LEFT JOIN TMP_PER_RIESGO_TOTAL_DIRECTO T5 ON PER.PER_ID = T5.PER_ID
  LEFT JOIN TMP_PER_RIESGO_TOTAL_INDIRECTO T6 ON PER.PER_ID = T6.PER_ID
  LEFT JOIN TMP_PER_SITUACION_CLIENTE T7 ON PER.PER_ID = T7.PER_ID
  LEFT JOIN TMP_PER_DIAS_VENCIDO T8 ON PER.PER_ID = T8.PER_ID
  LEFT JOIN TMP_PER_NUM_EXP_ACTIVOS T9 ON PER.PER_ID = T9.PER_ID
  LEFT JOIN TMP_PER_NUM_ASU_ACTIVOS T10 ON PER.PER_ID = T10.PER_ID
  LEFT JOIN TMP_PER_NUM_ASU_ACT_POR_PRC T11 ON PER.PER_ID = T11.PER_ID
  LEFT JOIN TMP_PER_SITUACION T12 ON PER.PER_ID = T12.PER_ID
  LEFT JOIN TMP_PER_RELACION_EXP T13 ON PER.PER_ID = T13.PER_ID
  LEFT JOIN TMP_PER_SERV_NOMINIA_PENSION T14 ON PER.PER_ID = T14.PER_ID
  LEFT JOIN TMP_PER_ULTIMA_ACTUACION T15 ON PER.PER_ID = T15.PER_ID
  LEFT JOIN TMP_PER_DISPUESTO_NO_VENCIDO T16 ON PER.PER_ID = T16.PER_ID
  LEFT JOIN TMP_PER_DISPUESTO_VENCIDO T17 ON PER.PER_ID = T17.PER_ID
  LEFT JOIN TMP_PER_DESC_CNAE T18 ON PER.PER_ID = T18.PER_ID;
  
COMMIT;