--Actualizacion nombre asunto LITIGIOS CAJAMAR

MERGE INTO HAYA02.ASU_ASUNTOS ASU2 USING 
(SELECT * FROM (
WITH MIG_NOM_ASUNTO AS (
  SELECT CD_PROCEDIMIENTO, PER_NOM50 AS PER_NOM50, PER_DOC_ID AS PER_DOC_ID
  FROM
      (
          select distinct pdem.cd_procedimiento, per.per_doc_id, per.per_nom50, tin.DD_TIN_CODIGO, CPE_ORDEN
              , rank() over (partition by pdem.cd_procedimiento order by tin.DD_TIN_CODIGO, CPE_ORDEN ASC, cpe.fechacrear desc) RANKING
           from  HAYA02.mig_procedimientos_demandados pdem 
           inner join HAYA02.MIG_PROCEDIMIENTOS_OPERACIONES mpo on mpo.CD_PROCEDIMIENTO = pdem.CD_PROCEDIMIENTO
           inner join HAYA02.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = mpo.NUMERO_CONTRATO   
           inner join  HAYA02.CPE_CONTRATOS_PERSONAS cpe ON cnt.cnt_id = cpe.cnt_id 
          -- inner join  HAYA02.per_personas per on per.per_cod_cliente_entidad = pdem.CODIGO_PERSONA
           inner join  HAYA02.per_personas per on per.per_id = cpe.per_id
           inner join  HAYA02.DD_TIN_TIPO_INTERVENCION tin ON cpe.dd_tin_id = tin.dd_tin_id 
          where tin.DD_TIN_TITULAR = 1 -- AND CPE.CNT_ID = 6746736
            -- and mpo.NUMERO_CONTRATO = 34907200064946
  )
  WHERE RANKING = 1   
)
SELECT  distinct     PCAB.CD_PROCEDIMIENTO
          ,  substr(lpad(pop.numero_contrato,16,'0') || ' | ' || per_doc_id || ' | ' || per_nom50,1,50) AS NOMBRE_ASUNTO
          ,  PCAB.ENTIDAD_PROPIETARIA
          ,  PCAB.GESTION_PLATAFORMA
          ,  ASU.ASU_ID
FROM HAYA02.mig_procedimientos_cabecera pcab 
    INNER JOIN HAYA02.mig_procedimientos_operaciones pop on pcab.cd_procedimiento = pop.cd_procedimiento 
    INNER JOIN HAYA02.ASU_ASUNTOS ASU ON ASU.asu_id_externo = to_char(pop.CD_PROCEDIMIENTO)
    INNER JOIN MIG_NOM_ASUNTO MNA ON MNA.CD_PROCEDIMIENTO = pop.cd_procedimiento   
) ) TMP 
ON (ASU2.ASU_ID = TMP.ASU_ID)
WHEN MATCHED THEN 
UPDATE SET ASU2.ASU_NOMBRE = TMP.NOMBRE_ASUNTO;
          
COMMIT;          

EXIT;
/