--Borrar historico > 30 dias y hoy
DELETE FROM MINIREC.H_PRE_JUDICIAL
WHERE TO_CHAR(FECHA_HISTORICO,'YYYYMMDD') LIKE TO_CHAR(SYSDATE,'YYYYMMDD')
OR TO_CHAR(FECHA_HISTORICO,'YYYYMMDD') < TO_CHAR(SYSDATE-30,'YYYYMMDD')
;
--Transferencia de los datos al historico
INSERT INTO MINIREC.H_PRE_JUDICIAL 
(
FECHA_HISTORICO,
ASU_ID,
ID_PROCEDIMIENTO,
DOCUMENTO,
NUM_CUENTA,
ENTI,
ENTIDAD,
SERVICER,
FECHA_SANCION_SAREB,
TITULOS,
PREPARACION_DOCUMENTACION,
ACTA_NOTARIAL,
BUROFAX_REMITIDO,
TURNADO
)
SELECT 
sysdate ,
ASU_ID,
ID_PROCEDIMIENTO,
DOCUMENTO,
NUM_CUENTA,
ENTI,
ENTIDAD,
SERVICER,
FECHA_SANCION_SAREB,
TITULOS,
PREPARACION_DOCUMENTACION,
ACTA_NOTARIAL,
BUROFAX_REMITIDO,
TURNADO
FROM MINIREC.PRE_JUDICIAL ORI 
;

--Truncado de tablas TDX
TRUNCATE TABLE MINIREC.PRE_JUDICIAL
;

--Generacion de las tablas TDX
INSERT INTO  MINIREC.PRE_JUDICIAL
(
ID_ASUNTO_HRE
,NUM_CUENTA
,ID_USUARIO_HAYA
,FC_WF_SANCION_PASE_A_LITIGIO
,FC_ALTA_PRECONTENCIOSO
)
SELECT 
ASU.ASU_ID AS ID_ASUNTO_HRE
,SUBSTR(CNT.CNT_CONTRATO, 11, 17) AS NUM_CUENTA
,USU.USU_USERNAME AS ID_USUARIO_HAYA
,PCO.FECHACREAR AS FC_WF_SANCION_PASE_A_LITIGIO
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

MERGE INTO MINIREC.PRE_JUDICIAL VAL
USING(
SELECT ASU_ID,CNT_ID,CNT_CONTRATO,PCO_BUR_ENVIO_FECHA_ENVIO FROM(
SELECT  BUR.CNT_ID,CNT_CONTRATO,PRC.ASU_ID,BUR.PCO_PRC_ID,ENVIO.PCO_BUR_ENVIO_FECHA_ENVIO, ROW_NUMBER() OVER (PARTITION BY BUR.CNT_ID,PRC.ASU_ID ORDER BY BUR.PCO_PRC_ID,PCO_BUR_ENVIO_FECHA_ENVIO ASC) RN FROM HAYA01.PCO_BUR_BUROFAX BUR
INNER JOIN HAYA01.PCO_BUR_ENVIO ENVIO ON ENVIO.PCO_BUR_BUROFAX_ID = BUR.PCO_BUR_BUROFAX_ID
INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PCO_PRC_ID = BUR.PCO_PRC_ID
INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PCO.PRC_ID
INNER JOIN HAYA01.CNT_CONTRATOS CNT ON BUR.CNT_ID=CNT.CNT_ID
INNER JOIN MINIREC.PRE_JUDICIAL VAL ON VAL.ID_ASUNTO_HRE=PRC.ASU_ID
)
WHERE RN=1)TMP
ON (VAL.ID_ASUNTO_HRE=TMP.ASU_ID AND VAL.NUM_CUENTA= SUBSTR(TMP.CNT_CONTRATO, 11, 17))
WHEN MATCHED THEN UPDATE SET VAL.FC_BUROFAX_REMITIDO=TMP.PCO_BUR_ENVIO_FECHA_ENVIO 
;

COMMIT;

-- MERGE DEL CAMPO FC_ACUSE_BUROFAX

MERGE INTO MINIREC.PRE_JUDICIAL VAL
USING(
SELECT ASU_ID,CNT_ID,CNT_CONTRATO,PCO_BUR_ENVIO_FECHA_ACUSO FROM(
SELECT  BUR.CNT_ID,CNT_CONTRATO,PRC.ASU_ID,BUR.PCO_PRC_ID,ENVIO.PCO_BUR_ENVIO_FECHA_ACUSO, ROW_NUMBER() OVER (PARTITION BY BUR.CNT_ID,PRC.ASU_ID ORDER BY BUR.PCO_PRC_ID,PCO_BUR_ENVIO_FECHA_ACUSO DESC) RN FROM HAYA01.PCO_BUR_BUROFAX BUR
INNER JOIN HAYA01.PCO_BUR_ENVIO ENVIO ON ENVIO.PCO_BUR_BUROFAX_ID = BUR.PCO_BUR_BUROFAX_ID AND PCO_BUR_ENVIO_FECHA_ACUSO IS NOT NULL
INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PCO_PRC_ID = BUR.PCO_PRC_ID
INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PCO.PRC_ID
INNER JOIN HAYA01.CNT_CONTRATOS CNT ON BUR.CNT_ID=CNT.CNT_ID
INNER JOIN MINIREC.PRE_JUDICIAL VAL ON VAL.ID_ASUNTO_HRE=PRC.ASU_ID
)
WHERE RN=1)TMP
ON (VAL.ID_ASUNTO_HRE=TMP.ASU_ID AND VAL.NUM_CUENTA=SUBSTR(TMP.CNT_CONTRATO, 11, 17))
WHEN MATCHED THEN UPDATE SET VAL.FC_ACUSE_BUROFAX=TMP.PCO_BUR_ENVIO_FECHA_ACUSO;

COMMIT;

-- Merge de los campos FC_ENVIO_NOTARIA,FC_RECIBO_NOTARIA

MERGE INTO PRE_JUDICIAL VAL
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
LEFT JOIN HAYA01.DD_PCO_DOC_SOLICIT_TIPOACTOR ACT ON ACT.DD_PCO_DSA_ID = SOL.DD_PCO_DSA_ID
LEFT JOIN HAYA01.DD_PCO_DOC_SOLICIT_RESULTADO RES ON RES.DD_PCO_DSR_ID = SOL.DD_PCO_DSR_ID
WHERE  TAC.DD_TAC_CODIGO LIKE 'PCO'
AND TGE.DD_TGE_CODIGO LIKE 'PREDOC'
AND SOL.BORRADO = 0

)TMP
ON (VAL.ID_ASUNTO_HRE=TMP.ASU_ID AND VAL.NUM_CUENTA=SUBSTR(TMP.CNT_CONTRATO, 11, 17))
WHEN MATCHED THEN UPDATE 
SET VAL.FC_ENVIO_NOTARIA=TMP.PCO_DOC_DSO_FECHA_SOLICITUD,
VAL.FC_RECIBO_NOTARIA=TMP.PCO_DOC_DSO_FECHA_RECEPCION
;

COMMIT;

-- Merge del campo FC_SOLICITUD_DOCUMENTACION

MERGE INTO MINIREC.PRE_JUDICIAL VAL
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
    ON (VAL.ID_ASUNTO_HRE = TMP.ASU_ID AND VAL.NUM_CUENTA = SUBSTR(TMP.CNT_CONTRATO, 11, 17))
     WHEN MATCHED THEN
    UPDATE SET
     VAL.FC_SOLICITUD_DOCUMENTACION = TMP.PCO_DOC_DSO_FECHA_SOLICITUD;
COMMIT;      

-- Merge del campo FC_PARALIZADO

MERGE INTO MINIREC.PRE_JUDICIAL VAL
USING(
WITH ULTIMO_PROCEDIMIENTO AS (
SELECT ASU_ID,PRC_ID FROM(
      SELECT ASU.ASU_ID, PRC.PRC_ID, ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID ORDER BY PRC.PRC_ID DESC) RN
      FROM HAYA01.ASU_ASUNTOS ASU
      INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
      INNER JOIN HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PRC.PRC_ID = PCO.PRC_ID)
      WHERE RN=1)
    SELECT ult.ASU_ID,prc_fecha_paralizado from  ULTIMO_PROCEDIMIENTO ULT
    inner join HAYA01.PRC_PROCEDIMIENTOS prc on prc.PRC_ID=ult.prc_id
    )
TMP
ON (VAL.ID_ASUNTO_HRE=TMP.ASU_ID)
WHEN MATCHED THEN UPDATE SET VAL.FC_PARALIZADO=TMP.prc_fecha_paralizado;

Commit;

-- Merge de los campos FECHA_SANCION_SAREB y TURNADO

MERGE INTO MINIREC.PRE_JUDICIAL VAL
    USING (
        SELECT PRC.ASU_ID,TO_DATE(TEV.TEV_VALOR, 'yyyy-mm-dd')AS FECHA 
        FROM HAYA01.PCO_PRC_PROCEDIMIENTOS PCO
        INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PCO.PRC_ID=PRC.PRC_ID AND PRC.DD_TAC_ID=(SELECT TAC.DD_TAC_ID FROM HAYA01.DD_TAC_TIPO_ACTUACION TAC WHERE TAC.DD_TAC_CODIGO LIKE '%PCO%')
        INNER JOIN HAYA01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.PRC_ID = PRC.PRC_ID
        INNER JOIN HAYA01.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID AND TEX.TAP_ID=(SELECT TAP.TAP_ID  FROM HAYA01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO like 'PCO_ResolucionSareb%' )
        INNER JOIN HAYA01.TEV_TAREA_EXTERNA_VALOR TEV ON TEV.TEX_ID=TEX.TEX_ID AND TEV.TEV_NOMBRE LIKE 'fecha'
    ) FECHA
   ON (FECHA.ASU_ID=VAL.ID_ASUNTO_HRE)
   WHEN MATCHED THEN 
   UPDATE SET 
   VAL.FC_WF_LITIGIO_SANCION_SAREB=FECHA.FECHA,
   VAL.FC_TURNADO=FECHA.FECHA;
   
Commit;

-- Merge de los campos FECHA_ENVIO_LITIGIO

MERGE INTO MINIREC.PRE_JUDICIAL VAL
    USING (
      SELECT ASU.ASU_ID,
      TAR.TAR_FECHA_INI AS FC_WF_ENVIO_LITIGIO
      FROM HAYA01.ASU_ASUNTOS ASU
      INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
      inner join HAYA01.PCO_PRC_PROCEDIMIENTOS PCO ON PRC.PRC_ID=PCO.PRC_ID
      INNER JOIN HAYA01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.PRC_ID = PRC.PRC_ID
      INNER JOIN HAYA01.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID=TEX.TAR_ID
      INNER JOIN HAYA01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID=TEX.TAP_ID
      WHERE tar_tarea like 'Elevar a Sareb'
    ) TMP
   ON (TMP.ASU_ID=VAL.ID_ASUNTO_HRE)
   WHEN MATCHED THEN 
   UPDATE SET 
   VAL.FC_WF_ENVIO_LITIGIO=TMP.FC_WF_ENVIO_LITIGIO
   ;
   
Commit;
