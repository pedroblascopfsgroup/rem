delete from minirec.rcv_gest_cuenta_pdm;
commit;

insert into minirec.rcv_gest_cuenta_pdm
WITH 
ULT_PROC AS (
	SELECT /*+ MATERIALIZE */ PRC_ID, ASU_ID, DD_TPO_CODIGO
	FROM (
			SELECT /*+ MATERIALIZE */ PRC.PRC_ID, PRC.ASU_ID, PRC.FECHACREAR, DD_TPO.DD_TPO_CODIGO
			,ROW_NUMBER() OVER (PARTITION BY PRC.ASU_ID ORDER BY PRC.PRC_ID DESC) PROC_NUM
			FROM BANK01.PRC_PROCEDIMIENTOS PRC
			INNER JOIN BANK01.DD_TPO_TIPO_PROCEDIMIENTO DD_TPO ON PRC.DD_TPO_ID = DD_TPO.DD_TPO_ID
			WHERE PRC.BORRADO = 0
		)
	WHERE PROC_NUM = 1
	),
ULT_MOVIMIENTO_CNT AS (
	select /*+ MATERIALIZE */ CNT_ID, MOV_POS_VIVA_NO_VENCIDA, MOV_POS_VIVA_VENCIDA, MOV_INT_REMUNERATORIOS, MOV_INT_MORATORIOS, MOV_GASTOS, MOV_COMISIONES, MOV_IMPUESTOS 
	from (
	  select mov.CNT_ID
		,ROW_NUMBER () OVER (PARTITION BY mov.cnt_id ORDER BY mov.mov_fecha_extraccion DESC) rn
		,MOV.MOV_POS_VIVA_NO_VENCIDA 
		,MOV.MOV_POS_VIVA_VENCIDA 
		,MOV.MOV_INT_REMUNERATORIOS 
		,MOV.MOV_INT_MORATORIOS 
		,MOV.MOV_GASTOS 
		,MOV.MOV_COMISIONES 
		,MOV.MOV_IMPUESTOS
		from BANK01.MOV_MOVIMIENTOS mov) tmp_mov
	where rn = 1
)
SELECT 
	DISTINCT
	TO_NUMBER(ASU.ASU_ID_EXTERNO) ID_PROCEDI
	,CEX.EXP_ID ID_EXPEDIENTE_RCV
	,ASU.ASU_ID ID_ASUNTO_RCV
	,PDM.ID_PROCEDI_RCV
	,CNT.CNT_ID ID_CUENTA_RCV
	,NULL RELACION_CTA
	,CASE DD_PAS.DD_PAS_CODIGO
		WHEN 'BANKIA' THEN '00000'
		WHEN 'SAREB' THEN '05074'
		ELSE NULL
		END ENTIDAD
	,SUBSTR(CNT_CONTRATO,6,5) CLASE_P_P
	,SUBSTR(CNT.CNT_CONTRATO,11,17) NUM_CUENTA 
	,CONCAT('00',SUBSTR(CNT.CNT_CONTRATO,28,15)) NUMERO_ESPEC
	,OFI.OFI_CODIGO_OFICINA OFICINA_PRODUCTO
	,DECODE(UPPER(ESC.DD_ESC_DESCRIPCION), 'ACTIVO', MOV.MOV_POS_VIVA_NO_VENCIDA,0) CAPITAL_PENDIENTE
	,DECODE(UPPER(ESC.DD_ESC_DESCRIPCION), 'ACTIVO', MOV.MOV_POS_VIVA_VENCIDA,0) CAPITAL_VENCIDO
	,DECODE(UPPER(ESC.DD_ESC_DESCRIPCION), 'ACTIVO', MOV.MOV_INT_REMUNERATORIOS,0) INTERESES_VENCIDOS
	,DECODE(UPPER(ESC.DD_ESC_DESCRIPCION), 'ACTIVO', MOV.MOV_INT_MORATORIOS,0) INTERESES_DEMORA
	,DECODE(UPPER(ESC.DD_ESC_DESCRIPCION), 'ACTIVO', MOV.MOV_GASTOS,0) GASTOS
	,DECODE(UPPER(ESC.DD_ESC_DESCRIPCION), 'ACTIVO', MOV.MOV_COMISIONES,0) COMISIONES_TOTALES
	,DECODE(UPPER(ESC.DD_ESC_DESCRIPCION), 'ACTIVO', MOV.MOV_IMPUESTOS,0) IMPUESTOS
	,GES.DD_GES_CODIGO IND_GEST_HAYA
FROM BANK01.ASU_ASUNTOS ASU
INNER JOIN MINIREC.RCV_GEST_PDM_LITIGIO PDM ON PDM.ID_ASUNTO_RCV = ASU.ASU_ID
LEFT JOIN BANK01.DD_PAS_PROPIEDAD_ASUNTO DD_PAS ON ASU.DD_PAS_ID = DD_PAS.DD_PAS_ID
LEFT JOIN BANKMASTER.DD_EAS_ESTADO_ASUNTOS DD_EAS ON ASU.DD_EAS_ID = DD_EAS.DD_EAS_ID
INNER JOIN ULT_PROC ULTPRC ON ASU.ASU_ID = ULTPRC.ASU_ID
INNER JOIN BANK01.PRC_CEX PRCCEX ON ULTPRC.PRC_ID = PRCCEX.PRC_ID
INNER JOIN BANK01.CEX_CONTRATOS_EXPEDIENTE CEX ON PRCCEX.CEX_ID = CEX.CEX_ID
INNER JOIN BANK01.CNT_CONTRATOS CNT ON CEX.CNT_ID = CNT.CNT_ID AND CNT.BORRADO = 0 
LEFT JOIN BANKMASTER.DD_ESC_ESTADO_CNT ESC ON ESC.DD_ESC_ID = CNT.DD_ESC_ID
LEFT JOIN BANK01.EXT_IAC_INFO_ADD_CONTRATO EXT ON EXT.CNT_ID = CNT.CNT_ID
		AND EXT.DD_IFC_ID IN (SELECT /*+ MATERIALIZE */ DD.DD_IFC_ID FROM BANK01.EXT_DD_IFC_INFO_CONTRATO DD WHERE DD.DD_IFC_CODIGO = 'NUMERO_ESPEC')
INNER JOIN ULT_MOVIMIENTO_CNT MOV ON CNT.CNT_ID = MOV.CNT_ID 
LEFT JOIN BANK01.OFI_OFICINAS OFI ON CNT.OFI_ID_ADMIN = OFI.OFI_ID
LEFT JOIN BANK01.DD_GES_GESTION_ASUNTO GES ON ASU.DD_GES_ID = GES.DD_GES_ID
WHERE ASU.BORRADO = 0;

commit;
