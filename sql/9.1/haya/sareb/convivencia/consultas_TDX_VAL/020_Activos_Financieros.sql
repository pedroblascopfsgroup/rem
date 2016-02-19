--Truncado de tablas TDX
TRUNCATE TABLE MINIREC.VAL_ACTIVOS_FINANCIEROS;

--Generacion de las tablas TDX
INSERT INTO  MINIREC.VAL_ACTIVOS_FINANCIEROS
(
ASU_ID,
ID_PROCEDIMIENTO,
ENTI,
ENTIDAD,
SERVICER,
NUM_CUENTA,
DEUDA_ACTUAL ,
DEUDA_ACTUAL_PRI,
DEUDA_ACTUAL_INT ,
DEUDA_ACTUAL_GAS
)
SELECT 
  PRC.ASU_ID,
  PRC.PRC_ID,  
  '2038',
  'BANKIA',
  'HAYA',
  SUBSTR(CNT.CNT_CONTRATO,11,17),  
  MOV.MOV_POS_VIVA_VENCIDA+MOV.MOV_INT_REMUNERATORIOS+MOV.MOV_INT_MORATORIOS+MOV.MOV_GASTOS AS DEUDA_ACTUAL,
  MOV.MOV_POS_VIVA_VENCIDA AS DEUDA_ACTUAL_PRI,
  MOV.MOV_INT_REMUNERATORIOS + MOV_INT_MORATORIOS AS DEUDA_ACTUAL_INT,
  MOV.MOV_GASTOS AS DEUDA_ACTUAL_GAS
FROM  HAYA01.PRC_PROCEDIMIENTOS PRC
INNER JOIN HAYA01.ASU_ASUNTOS ASU ON ASU.ASU_ID=PRC.ASU_ID
INNER JOIN HAYA01.CEX_CONTRATOS_EXPEDIENTE CEX ON ASU.EXP_ID = CEX.EXP_ID
INNER JOIN HAYA01.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID
LEFT JOIN HAYA01.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID=CNT.CNT_ID
INNER JOIN MINIREC.VAL_PROC_JUDICIAL_FOTO FOTO ON FOTO.ID_PROCEDIMIENTO=PRC.PRC_ID
WHERE PRC.PRC_PRC_ID IS NULL
AND (MOV.MOV_FECHA_EXTRACCION=(
    SELECT MAX(MOV2.MOV_FECHA_EXTRACCION) FROM HAYA01.MOV_MOVIMIENTOS MOV2 WHERE MOV2.CNT_ID=CNT.CNT_ID
) OR MOV.MOV_FECHA_EXTRACCION IS NULL)
;
