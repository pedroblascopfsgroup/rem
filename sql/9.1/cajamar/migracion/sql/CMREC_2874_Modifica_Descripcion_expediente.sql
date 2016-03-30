--Actualizacion nombre asunto LITIGIOS CAJAMAR
-- GMN 20160329 CMREC-2875
-- Modificamos la descripción del expediente a:
--   . Expediente: Persona de pase del expediente 
--   . Asuntos de Litigios: Cod. Contrato | NIF | Nombre y apellidos 1er titular
--   . Asuntos de Concursos: NIF | Nombre y apellidos 1er titular

--Corrección descripción expediente con demandados
MERGE INTO CM01.EXP_EXPEDIENTES EXP USING 
(SELECT * FROM (
WITH MIG_NOM_ASUNTO AS (
  SELECT CD_PROCEDIMIENTO, PER_NOM50 AS PER_NOM50, PER_DOC_ID AS PER_DOC_ID
  FROM
      (
          select distinct pdem.cd_procedimiento, per.per_doc_id, per.per_nom50, tin.DD_TIN_CODIGO, CPE_ORDEN
              , rank() over (partition by pdem.cd_procedimiento order by tin.DD_TIN_CODIGO, CPE_ORDEN ASC) RANKING
           from  CM01.mig_procedimientos_demandados pdem 
           inner join CM01.MIG_PROCEDIMIENTOS_OPERACIONES mpo on mpo.CD_PROCEDIMIENTO = pdem.CD_PROCEDIMIENTO
           inner join CM01.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = mpo.NUMERO_CONTRATO   
           inner join  CM01.CPE_CONTRATOS_PERSONAS cpe ON cnt.cnt_id = cpe.cnt_id 
          -- inner join  CM01.per_personas per on per.per_cod_cliente_entidad = pdem.CODIGO_PERSONA
           inner join  CM01.per_personas per on per.per_id = cpe.per_id
           inner join  CM01.DD_TIN_TIPO_INTERVENCION tin ON cpe.dd_tin_id = tin.dd_tin_id 
          where tin.DD_TIN_TITULAR = 1 -- AND CPE.CNT_ID = 6746736
            -- and mpo.NUMERO_CONTRATO = 34907200064946
  )
  WHERE RANKING = 1   
)
SELECT       PCAB.CD_PROCEDIMIENTO
          ,  per_nom50 AS NOMBRE_ASUNTO
          ,  PCAB.ENTIDAD_PROPIETARIA
          ,  PCAB.GESTION_PLATAFORMA
          ,  ASU.ASU_ID
          ,  ASU.EXP_ID
FROM CM01.mig_procedimientos_cabecera pcab 
    INNER JOIN CM01.mig_procedimientos_operaciones pop on pcab.cd_procedimiento = pop.cd_procedimiento 
    INNER JOIN CM01.ASU_ASUNTOS ASU ON ASU.asu_id_externo = pop.CD_PROCEDIMIENTO 
    INNER JOIN MIG_NOM_ASUNTO MNA ON MNA.CD_PROCEDIMIENTO = pop.cd_procedimiento   
) ) TMP 
ON (EXP.EXP_ID = TMP.EXP_ID)
WHEN MATCHED THEN 
UPDATE SET EXP.EXP_DESCRIPCION = TMP.NOMBRE_ASUNTO;
          
COMMIT;          


-- Actualizamos contratos con ceros a la izquierda de contencioso

--UPDATE CM01.asu_asuntos
--SET asu_nombre = substr(lpad(substr(asu_nombre,1,INSTR(asu_nombre,'|', 1) -2),16,'0') || substr(asu_nombre,INSTR(asu_nombre,'|', 1) - 1, 50),1,50) 
--WHERE usuariocrear = 'MIGRACM01'
--AND INSTR(asu_nombre,'|', 1) > 2;

--COMMIT;

-- Actualizamos descripcion expedientes concursos
--   . Expediente: Persona de pase del expediente 
--   . Asuntos de Concursos: NIF | Nombre y apellidos 1er titular

MERGE INTO CM01.EXP_EXPEDIENTES EXP USING 
(select distinct CD_CONCURSO, NUMERO_CONTRATO, nif, NVL(per_nom50,nif)  AS EXP_DESCRIPCION
from (
     SELECT mca.CD_CONCURSO , mopc.NUMERO_CONTRATO, mca.nif, per.per_nom50
           ,rank() over (partition by mca.CD_CONCURSO, mopc.NUMERO_CONTRATO, mca.nif
                             order by  per.per_nom50 DESC) RANKING2
     FROM  CM01.MIG_CONCURSOS_CABECERA mca
          ,(
             SELECT CD_CONCURSO, NUMERO_CONTRATO
               FROM
                   (
                     SELECT DISTINCT 
                            MCO.NUMERO_CONTRATO, MCO.CD_CONCURSO, MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA as deuda, MOV.MOV_ID 
                           , rank() over (partition by MCO.CD_CONCURSO 
                                              order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC, MOV.MOV_ID) RANKING
                     FROM CM01.MIG_CONCURSOS_OPERACIONES MCO
                     inner JOIN CM01.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = MCO.NUMERO_CONTRATO
                     inner JOIN CM01.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION
                    ) cnt
                WHERE RANKING = 1
            ) mopc
          , CM01.per_personas per
      WHERE mca.cd_concurso = mopc.cd_concurso (+)
        AND mca.nif = per.per_doc_id (+)
        --AND mca.cd_concurso = 1100748519
     ) r
   WHERE r.RANKING2 = 1
) TMP 
ON (EXP.CD_PROCEDIMIENTO = TMP.CD_CONCURSO)
WHEN MATCHED THEN 
UPDATE SET EXP.EXP_DESCRIPCION = TMP.EXP_DESCRIPCION;   
   
COMMIT;   




-- Actualizamos nombres asunto precontencioso 

MERGE INTO CM01.EXP_EXPEDIENTES EXP  USING
    (SELECT  distinct (select dd_TPX_ID from CM01.DD_TPX_TIPO_EXPEDIENTE where DD_TPX_CODIGO = 'RECU') as dd_tpx_id,
					   per_nom50 AS EXP_DESCRIPCION,
					   COD_RECOVERY as CD_EXPEDIENTE
				  FROM
				  (
          SELECT MIN(PER_NOM50) AS PER_NOM50, MIN(PER_DOC_ID) AS PER_DOC_ID, COD_RECOVERY AS COD_RECOVERY, CNT_CONTRATO AS CNT_CONTRATO
				  FROM
				  (
				   	SELECT DISTINCT PER_NOM50, PER_DOC_ID, CNT.CNT_CONTRATO, TMP.COD_RECOVERY, tin.DD_TIN_CODIGO, CPE_ORDEN, rank() over (partition by TMP.COD_RECOVERY order by tin.DD_TIN_CODIGO, CPE_ORDEN DESC) RANKING
					  FROM CM01.CPE_CONTRATOS_PERSONAS cpe
					  INNER JOIN CM01.CNT_CONTRATOS cnt ON cnt.cnt_id = cpe.cnt_id
					  INNER JOIN ( select DISTINCT
                                   cab.cd_expediente cod_recovery, 
                                   cab.cd_expediente cod_workflow, 
                                   null fecha_sareb, 
                                   null fecha_peticion, 
                                   MAX(op.NUMERO_CONTRATO) cnt_contrato
                            from CM01.mig_expedientes_cabecera cab
                            inner join CM01.mig_expedientes_operaciones op on cab.cd_expediente = op.cd_expediente
                          GROUP BY cab.cd_expediente) TMP              
            ON tmp.cnt_contrato = cnt.cnt_contrato
					  INNER JOIN CM01.PER_PERSONAS per ON per.per_id = cpe.per_id 
            INNER JOIN CM01.DD_TIN_TIPO_INTERVENCION tin ON cpe.dd_tin_id = tin.dd_tin_id          
            WHERE tin.DD_TIN_TITULAR = 1                      
            )  
    		   WHERE RANKING = 1
           GROUP BY COD_RECOVERY, CNT_CONTRATO
        )
) AUX
ON (EXP.CD_EXPEDIENTE_NUSE = AUX.CD_EXPEDIENTE AND exp.usuariocrear = 'MIGRACM01PCO')        
WHEN MATCHED THEN 
UPDATE SET EXP.EXP_DESCRIPCION = AUX.EXP_DESCRIPCION;

COMMIT;


UPDATE CM01.PCO_PRC_PROCEDIMIENTOS PCO
                SET PCO_PRC_NOM_EXP_JUD = (SELECT EXP.EXP_DESCRIPCION
                                             FROM CM01.EXP_EXPEDIENTES EXP
                                                , CM01.ASU_ASUNTOS ASU
                                                , CM01.PRC_PROCEDIMIENTOS PRC
                                             WHERE EXP.EXP_ID = ASU.EXP_ID
                                               AND ASU.ASU_ID = PRC.ASU_ID
                                               AND PRC.PRC_ID = PCO.PRC_ID
                                               AND EXP.USUARIOCREAR like 'MIGRA%')
   ;
   
COMMIT;   


EXIT;
/