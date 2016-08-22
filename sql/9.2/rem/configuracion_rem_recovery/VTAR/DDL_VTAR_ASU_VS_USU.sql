
  CREATE OR REPLACE FORCE VIEW "REM01"."VTAR_ASU_VS_USU" ("USU_ID", "DES_ID", "DD_TGE_ID", "USU_ID_ORIGINAL", "ASU_ID", "GAS_ID", "DD_EST_ID", "ASU_FECHA_EST_ID", "ASU_PROCESS_BPM", "ASU_NOMBRE", "EXP_ID", "VERSION", "USUARIOCREAR", "FECHACREAR", "USUARIOMODIFICAR", "FECHAMODIFICAR", "USUARIOBORRAR", "FECHABORRAR", "BORRADO", "DD_EAS_ID", "ASU_ASU_ID", "ASU_OBSERVACION", "SUP_ID", "SUP_COM_ID", "COM_ID", "DCO_ID", "ASU_FECHA_RECEP_DOC", "USD_ID", "DTYPE", "DD_UCL_ID", "REF_ASESORIA", "LOTE", "DD_TAS_ID", "ASU_ID_EXTERNO", "DD_PAS_ID", "DD_GES_ID") AS 
  SELECT usd.usu_id,
      usd.des_id,
      ges.dd_tge_id,
      usd.usu_id usu_id_original,
      asu.ASU_ID,
      asu.GAS_ID,
      asu.DD_EST_ID,
      asu.ASU_FECHA_EST_ID,
      asu.ASU_PROCESS_BPM,
      asu.ASU_NOMBRE,
      asu.EXP_ID,
      asu.VERSION,
      asu.USUARIOCREAR,
      asu.FECHACREAR,
      asu.USUARIOMODIFICAR,
      asu.FECHAMODIFICAR,
      asu.USUARIOBORRAR,
      asu.FECHABORRAR,
      asu.BORRADO,
      asu.DD_EAS_ID,
      asu.ASU_ASU_ID,
      asu.ASU_OBSERVACION,
      asu.SUP_ID,
      asu.SUP_COM_ID,
      asu.COM_ID,
      asu.DCO_ID,
      asu.ASU_FECHA_RECEP_DOC,
      asu.USD_ID,
      asu.DTYPE,
      asu.DD_UCL_ID,
      asu.REF_ASESORIA,
      asu.LOTE,
      asu.DD_TAS_ID,
      asu.ASU_ID_EXTERNO,
      asu.DD_PAS_ID,
      asu.DD_GES_ID
    FROM REM01.asu_asuntos asu
    JOIN
      (SELECT asu_id, usd_id, 4 dd_tge_id FROM  REM01.asu_asuntos WHERE usd_id IS NOT NULL
      UNION ALL
      SELECT asu_id, usd_id, dd_tge_id
      FROM  REM01.gaa_gestor_adicional_asunto
      WHERE borrado = 0
      ) ges
    ON asu.asu_id = ges.asu_id
    JOIN  REM01.usd_usuarios_despachos usd
    ON ges.usd_id = usd.usd_id
 
 
 
 
 ;
 
