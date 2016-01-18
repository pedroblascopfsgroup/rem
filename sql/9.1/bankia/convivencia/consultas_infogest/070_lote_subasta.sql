DELETE FROM MINIREC.RCV_GEST_LOTE_SUBASTA;
commit;

INSERT INTO MINIREC.RCV_GEST_LOTE_SUBASTA
SELECT 
   A.ID_PROCEDI
  ,A.ID_ASUNTO_RCV
  ,A.ID_PROCEDI_RCV
  ,LOS.LOS_NUM_LOTE LOTE
  , A.ID_PROPUESTA_RCV
  ,DECODE(ESU.DD_ESU_CODIGO,'CEL','S',' ') AS CELEBRADA
  ,SUB.SUB_FECHA_SENYALAMIENTO FECHA_SUBASTA
  ,MAX(MIG.CON_POSTORES)  POSTORES
  ,DECODE(MAX(BAD.BIE_ADJ_CESION_REMATE),1,'CES',DECODE(MIN(UPPER(EAD.DD_EAD_DESCRIPCION)),'ENTIDAD','ADJ',null,null,'TER')) RESULTADO_SUBASTA
  ,DECODE(MAX(BAD.BIE_ADJ_CESION_REMATE),1,'1',DECODE(MIN(UPPER(EAD.DD_EAD_DESCRIPCION)),'ENTIDAD','1',null,null,'2'))  ID_RESULTADO_SUBASTA_RCV
  ,DECODE(MAX(BAD.BIE_ADJ_CESION_REMATE),1,'CESION',MIN(UPPER(EAD.DD_EAD_DESCRIPCION)))   RESULTADO_SUBASTA_RCV       
  ,MIN(EAD.DD_EAD_CODIGO)             ENTIDAD_ADJ_RCV			
  ,DECODE(MAX(BAD.BIE_ADJ_CESION_REMATE),1,'S',' ') CESION_REMATE_RCV 
FROM MINIREC.RCV_GEST_PROPUESTA A
INNER JOIN bank01.SUB_SUBASTA SUB ON A.ID_PROPUESTA_RCV = SUB.PRC_ID
INNER JOIN bank01.LOS_LOTE_SUBASTA LOS ON SUB.SUB_ID = LOS.SUB_ID
INNER JOIN bank01.LOB_LOTE_BIEN LOB ON LOS.LOS_ID = LOB.LOS_ID
INNER JOIN bank01.BIE_ADJ_ADJUDICACION BAD ON LOB.BIE_ID = BAD.BIE_ID
LEFT JOIN bank01.DD_EAD_ENTIDAD_ADJUDICA EAD ON BAD.DD_EAD_ID  = EAD.DD_EAD_ID
LEFT JOIN bank01.DD_ESU_ESTADO_SUBASTA ESU ON SUB.DD_ESU_ID = ESU.DD_ESU_ID
LEFT JOIN bank01.MIG_PROCS_SUBASTAS_LOTES MIG ON SUB.CD_SUBASTA_ORIG = MIG.CD_SUBASTA
GROUP BY A.ID_PROCEDI
  ,A.ID_ASUNTO_RCV
  ,A.ID_PROCEDI_RCV
  ,LOS.LOS_NUM_LOTE
  , A.ID_PROPUESTA_RCV
  ,ESU.DD_ESU_CODIGO
  ,SUB.SUB_FECHA_SENYALAMIENTO;  
COMMIT;


