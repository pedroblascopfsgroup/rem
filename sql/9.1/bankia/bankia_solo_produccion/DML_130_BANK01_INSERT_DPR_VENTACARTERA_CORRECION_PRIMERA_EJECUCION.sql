INSERT INTO BANK01.DPR_DECISIONES_PROCEDIMIENTOS (
DPR_ID,
PRC_ID,
DPR_FINALIZA,
DPR_COMENTARIOS,
DD_DFI_ID,
DPR_PARALIZA,
DD_EDE_ID,
VERSION,
USUARIOCREAR,
FECHACREAR
)
WITH ULTIMO_PROC_ASUNTOS_CERRAR AS ( --ULTIMOS PROCEDIMIENTOS DE TODOS LOS ASUNTOS
	SELECT /*+ MATERIALIZE */ TMP_AP.PRC_ID
	FROM (
	  SELECT ASU.ASU_ID, PRC.PRC_ID, ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID ORDER BY PRC.PRC_ID DESC) RN
	  FROM BANK01.ASU_ASUNTOS ASU
	  INNER JOIN BANK01.PRC_PROCEDIMIENTOS PRC 
      ON PRC.ASU_ID = ASU.ASU_ID 
    INNER JOIN BANK01.FIN_AUX_PRC_CERRAR_FINAL FIN 
      ON FIN.ASU_ID = PRC.ASU_ID
    ) TMP_AP
	WHERE RN = 1
),
DECISIONES AS (
	SELECT 
	DISTINCT DPR.PRC_ID
	FROM BANK01.DPR_DECISIONES_PROCEDIMIENTOS DPR
	INNER JOIN ULTIMO_PROC_ASUNTOS_CERRAR ULT
	  ON ULT.PRC_ID = DPR.PRC_ID
	WHERE DPR.DD_DFI_ID != 21
	  OR DPR.DD_DFI_ID IS NULL
),
TEXTO_CNT AS ( -- NOS TRAEMOS EL CNT_ID Y EL TEXTO_VENTA DE CONTRATOS
  SELECT 
  INI.PRC_ID,
  TMP.TEXTO_VENTA
  FROM BANK01.CNT_CONTRATOS CNT
  INNER JOIN BANK01.TMP_CONTRATOS_VENTA TMP
    ON (TMP.NUMERO_CONTRATO = TO_NUMBER(SUBSTR(CNT.CNT_CONTRATO,11,17))
    AND TMP.TIPO_PRODUCTO   = SUBSTR(CNT.CNT_CONTRATO,6,5)
    AND TMP.NUMERO_ESPEC    = TO_NUMBER(SUBSTR(CNT.CNT_CONTRATO,28,15)))
  INNER JOIN BANK01.FIN_AUX_PRC_CERRAR_INICIAL INI
    ON CNT.CNT_ID = INI.CNT_ID
)
SELECT 
BANK01.S_DPR_DEC_PROCEDIMIENTOS.NEXTVAL DPR_ID,
DECISIONES.PRC_ID PRC_ID,
1 DPR_FINALIZA,
'Venta de cartera promoción '||TEXTO_CNT.TEXTO_VENTA DPR_COMENTARIOS,
(SELECT DD_DFI_ID FROM BANK01.DD_DFI_DECISION_FINALIZAR WHERE DD_DFI_CODIGO = 'VENTACAR') DD_DFI_ID,
0 DPR_PARALIZA,
(SELECT DD_EDE_ID FROM BANKMASTER.DD_EDE_ESTADOS_DECISION WHERE DD_EDE_DESCRIPCION = 'ACEPTADO') DD_EDE_ID,
0 VERSION,
'BKREC-1701' USUARIOCREAR,
SYSDATE FECHACREAR
FROM DECISIONES
INNER JOIN TEXTO_CNT
  ON DECISIONES.PRC_ID = TEXTO_CNT.PRC_ID;
