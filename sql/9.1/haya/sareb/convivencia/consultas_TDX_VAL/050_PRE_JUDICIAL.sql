--Truncado de tablas TDX
TRUNCATE TABLE MINIREC.VAL_PRE_JUDICIAL;

--Generacion de las tablas TDX
INSERT INTO VAL_PRE_JUDICIAL(
ID_ASUNTO_HRE
,NUM_CUENTA
,ID_USUARIO_HAYA
,FC_ALTA_PRECONTENCIOSO
)
SELECT 
ASU.ASU_ID AS ID_ASUNTO_HRE
,CNT.CNT_CONTRATO AS NUM_CUENTA
,USU.USU_USERNAME AS ID_USUARIO_HAYA
,PCO.FECHACREAR AS FC_ALTA_PRECONTENCIOSO
FROM HAYA01.ASU_ASUNTOS ASU
INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
INNER JOIN HAYA01.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.EXP_ID = ASU.EXP_ID
INNER JOIN HAYA01.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID
INNER JOIN HAYA01.DD_TAC_TIPO_ACTUACION TAC ON  TAC.DD_TAC_ID=PRC.DD_TAC_ID
INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID=PRC.PRC_ID
INNER JOIN HAYA01.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.ASU_ID = ASU.ASU_ID
INNER JOIN HAYAMASTER.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID=TGE.DD_TGE_ID
INNER JOIN HAYA01.USD_USUARIOS_DESPACHOS USD ON USD.USD_ID=GAA.USD_ID
INNER JOIN HAYAMASTER.USU_USUARIOS USU ON USU.USU_ID=USD.USU_ID
WHERE  TAC.DD_TAC_CODIGO LIKE 'PCO'
AND TGE.DD_TGE_CODIGO LIKE 'PREDOC'
;

COMMIT;

--MERGE DEL CAMPO FC_BUROFAX_REMITIDO
MERGE INTO MINIREC.VAL_PRE_JUDICIAL VAL
USING(
SELECT ASU_ID,CNT_ID,CNT_CONTRATO,PCO_BUR_ENVIO_FECHA_ENVIO FROM(
SELECT  BUR.CNT_ID,CNT_CONTRATO,PRC.ASU_ID,BUR.PCO_PRC_ID,ENVIO.PCO_BUR_ENVIO_FECHA_ENVIO, ROW_NUMBER() OVER (PARTITION BY BUR.CNT_ID,PRC.ASU_ID ORDER BY BUR.PCO_PRC_ID,PCO_BUR_ENVIO_FECHA_ENVIO ASC) RN FROM HAYA01.PCO_BUR_BUROFAX BUR
INNER JOIN HAYA01.PCO_BUR_ENVIO ENVIO ON ENVIO.PCO_BUR_BUROFAX_ID = BUR.PCO_BUR_BUROFAX_ID
INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PCO_PRC_ID = BUR.PCO_PRC_ID
INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PCO.PRC_ID
INNER JOIN HAYA01.CNT_CONTRATOS CNT ON BUR.CNT_ID=CNT.CNT_ID
INNER JOIN MINIREC.VAL_PRE_JUDICIAL VAL ON VAL.ID_ASUNTO_HRE=PRC.ASU_ID
)
WHERE RN=1)TMP
ON (VAL.ID_ASUNTO_HRE=TMP.ASU_ID AND VAL.NUM_CUENTA=TMP.CNT_CONTRATO)
WHEN MATCHED THEN UPDATE SET VAL.FC_BUROFAX_REMITIDO=TMP.PCO_BUR_ENVIO_FECHA_ENVIO 
;

COMMIT;

-- MERGE DEL CAMPO FC_ACUSE_BUROFAX
MERGE INTO MINIREC.VAL_PRE_JUDICIAL VAL
USING(
SELECT ASU_ID,CNT_ID,CNT_CONTRATO,PCO_BUR_ENVIO_FECHA_ACUSO FROM(
SELECT  BUR.CNT_ID,CNT_CONTRATO,PRC.ASU_ID,BUR.PCO_PRC_ID,ENVIO.PCO_BUR_ENVIO_FECHA_ACUSO, ROW_NUMBER() OVER (PARTITION BY BUR.CNT_ID,PRC.ASU_ID ORDER BY BUR.PCO_PRC_ID,PCO_BUR_ENVIO_FECHA_ACUSO DESC) RN FROM HAYA01.PCO_BUR_BUROFAX BUR
INNER JOIN HAYA01.PCO_BUR_ENVIO ENVIO ON ENVIO.PCO_BUR_BUROFAX_ID = BUR.PCO_BUR_BUROFAX_ID AND PCO_BUR_ENVIO_FECHA_ACUSO IS NOT NULL
INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PCO_PRC_ID = BUR.PCO_PRC_ID
INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PCO.PRC_ID
INNER JOIN HAYA01.CNT_CONTRATOS CNT ON BUR.CNT_ID=CNT.CNT_ID
INNER JOIN MINIREC.VAL_PRE_JUDICIAL VAL ON VAL.ID_ASUNTO_HRE=PRC.ASU_ID
)
WHERE RN=1)TMP
ON (VAL.ID_ASUNTO_HRE=TMP.ASU_ID AND VAL.NUM_CUENTA=TMP.CNT_CONTRATO)
WHEN MATCHED THEN UPDATE SET VAL.FC_ACUSE_BUROFAX=TMP.PCO_BUR_ENVIO_FECHA_ACUSO;

COMMIT;

-- Merge de los campos FC_ENVIO_NOTARIA,FC_RECIBO_NOTARIA
MERGE INTO MINIREC.VAL_PRE_JUDICIAL VAL
USING(
SELECT 
CNT.CNT_CONTRATO
,ASU.ASU_ID
,SOL.PCO_DOC_DSO_FECHA_SOLICITUD
,SOL.PCO_DOC_DSO_FECHA_RECEPCION
FROM HAYA01.ASU_ASUNTOS ASU
INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
INNER JOIN HAYA01.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.EXP_ID = ASU.EXP_ID
INNER JOIN HAYA01.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID
INNER JOIN HAYA01.DD_TAC_TIPO_ACTUACION TAC ON  TAC.DD_TAC_ID=PRC.DD_TAC_ID
INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID=PRC.PRC_ID
INNER JOIN HAYA01.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.ASU_ID = ASU.ASU_ID
INNER JOIN HAYAMASTER.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID=TGE.DD_TGE_ID
INNER JOIN HAYA01.USD_USUARIOS_DESPACHOS USD ON USD.USD_ID=GAA.USD_ID
INNER JOIN HAYAMASTER.USU_USUARIOS USU ON USU.USU_ID=USD.USU_ID
INNER JOIN HAYA01.PCO_DOC_DOCUMENTOS DOC ON DOC.PCO_PRC_ID=PCO.PCO_PRC_ID AND DOC.PCO_DOC_PDD_UG_DESC=CNT.CNT_CONTRATO
INNER JOIN HAYA01.DD_TFA_FICHERO_ADJUNTO TFA ON TFA.DD_TFA_ID = DOC.DD_TFA_ID AND TFA.DD_TFA_CODIGO = 'ANLS' 
INNER JOIN HAYA01.PCO_DOC_SOLICITUDES SOL ON SOL.PCO_DOC_PDD_ID=DOC.PCO_DOC_PDD_ID
WHERE  TAC.DD_TAC_CODIGO LIKE 'PCO'
AND TGE.DD_TGE_CODIGO LIKE 'PREDOC'
)TMP
ON (VAL.ID_ASUNTO_HRE=TMP.ASU_ID AND VAL.NUM_CUENTA=TMP.CNT_CONTRATO)
WHEN MATCHED THEN UPDATE 
SET VAL.FC_ENVIO_NOTARIA=TMP.PCO_DOC_DSO_FECHA_SOLICITUD,
VAL.FC_RECIBO_NOTARIA=TMP.PCO_DOC_DSO_FECHA_RECEPCION
;

COMMIT;
-- Merge del campo FC_SOLICITUD_DOCUMENTACION
MERGE INTO VAL_PRE_JUDICIAL VAL
  USING (
        SELECT PCO_DOC_DSO_FECHA_SOLICITUD, ASU_ID, CNT_ID, CNT_CONTRATO FROM 
            (
                SELECT SOL.PCO_DOC_DSO_FECHA_SOLICITUD, CNT.CNT_ID, ASU.ASU_ID, ASU.EXP_ID, CEX.EXP_ID, CNT.CNT_CONTRATO,               
                      ROW_NUMBER () OVER (PARTITION BY CNT.CNT_ID, ASU.ASU_ID 
                      ORDER BY SOL.PCO_DOC_DSO_FECHA_SOLICITUD ASC) RN
                      
                FROM HAYA01.ASU_ASUNTOS ASU
                  INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
                  INNER JOIN HAYA01.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.EXP_ID = ASU.EXP_ID
                  INNER JOIN HAYA01.CNT_CONTRATOS CNT  ON CNT.CNT_ID = CEX.CNT_ID
                  INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID=PRC.PRC_ID
                  INNER JOIN HAYA01.PCO_DOC_DOCUMENTOS DOC  ON DOC.PCO_PRC_ID=PCO.PCO_PRC_ID AND DOC.PCO_DOC_PDD_UG_DESC=CNT.CNT_CONTRATO
                  INNER JOIN HAYA01.PCO_DOC_SOLICITUDES SOL ON SOL.PCO_DOC_PDD_ID=DOC.PCO_DOC_PDD_ID
                WHERE SOL.PCO_DOC_DSO_FECHA_SOLICITUD IS NOT NULL
                          
              ) 
              WHERE RN = 1)TMP
    ON (VAL.ID_ASUNTO_HRE = TMP.ASU_ID AND VAL.NUM_CUENTA = TMP.CNT_CONTRATO)
     WHEN MATCHED THEN
    UPDATE SET
     VAL.FC_SOLICITUD_DOCUMENTACION = TMP.PCO_DOC_DSO_FECHA_SOLICITUD;
COMMIT;      

-- Merge del campo FC_PARALIZADO
--MERGE INTO MINIREC.VAL_PRE_JUDICIAL VAL
--USING(
--WITH ULTIMO_PROCEDIMIENTO AS (
--SELECT ASU_ID,PRC_ID FROM(
--      SELECT ASU.ASU_ID, PRC.PRC_ID, ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID ORDER BY PRC.PRC_ID DESC) RN
--      FROM HAYA01.ASU_ASUNTOS ASU
--      INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
--      INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PRC.PRC_ID = PCO.PRC_ID)
--    WHERE RN=1)
--    SELECT ASU_ID,DPR_FECHA_PARA FROM HAYA01.DPR_DECISIONES_PROCEDIMIENTOS DPR
--    INNER JOIN ULTIMO_PROCEDIMIENTO ULT ON DPR.PRC_ID=ULT.PRC_ID
--    )
--TMP
--ON (VAL.ID_ASUNTO_HRE=TMP.ASU_ID)
--WHEN MATCHED THEN UPDATE SET VAL.FC_PARALIZADO=TMP.DPR_FECHA_PARA ;

Commit;
