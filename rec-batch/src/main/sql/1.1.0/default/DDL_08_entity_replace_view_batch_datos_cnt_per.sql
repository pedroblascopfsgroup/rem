CREATE OR REPLACE VIEW BATCH_DATOS_CNT_PER AS
     SELECT CPE.CNT_ID
        , CPE.PER_ID
        , TIN.DD_TIN_CODIGO AS CNT_PER_TIN
        , CPE.CPE_ORDEN AS CNT_PER_OIN
      FROM  CPE_CONTRATOS_PERSONAS CPE
        JOIN DD_TIN_TIPO_INTERVENCION TIN ON CPE.DD_TIN_ID = TIN.DD_TIN_ID
      WHERE CPE.BORRADO = 0
            AND (DD_TIN_EXP_RECOBRO_SN = 1);