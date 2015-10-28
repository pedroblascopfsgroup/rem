delete from minirec.rcv_gest_pdm_litigio;
commit;

insert into minirec.rcv_gest_pdm_litigio
WITH 
ULT_PROC_PADRE AS (
  SELECT /*+ MATERIALIZE */ PRC_ID, ASU_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, PRC_SALDO_RECUPERACION, DD_JUZ_ID, DD_JUZ_CODIGO, PRC_COD_PROC_EN_JUZGADO
  FROM (
    SELECT /*+ MATERIALIZE */ PRC.PRC_ID, PRC.ASU_ID, PRC.FECHACREAR, DD_TPO.DD_TPO_CODIGO, DD_TPO.DD_TPO_DESCRIPCION, PRC.PRC_SALDO_RECUPERACION, PRC.DD_JUZ_ID, DD_JUZ.DD_JUZ_CODIGO, PRC.PRC_COD_PROC_EN_JUZGADO
      ,ROW_NUMBER() OVER (PARTITION BY PRC.ASU_ID ORDER BY PRC.FECHACREAR DESC) PROC_NUM
    FROM BANK01.PRC_PROCEDIMIENTOS PRC
      INNER JOIN BANK01.DD_TPO_TIPO_PROCEDIMIENTO DD_TPO ON PRC.DD_TPO_ID = DD_TPO.DD_TPO_ID
      LEFT JOIN BANK01.DD_JUZ_JUZGADOS_PLAZA DD_JUZ ON PRC.DD_JUZ_ID = DD_JUZ.DD_JUZ_ID
    WHERE (
          UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%APELACION%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%CAMBIARIO%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%CONCURSO%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%EJECUTIVO%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%HIPOTECARIO%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%MONITORIO%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%ORDINARIO%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%PENAL%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%TERCERIA%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%VERBAL%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%NO JUDICIAL%'
          OR UPPER(DD_TPO.DD_TPO_DESCRIPCION) LIKE '%ABREVIADO%'
		  OR DD_TPO.DD_TPO_DESCRIPCION = 'T. de aceptacion y decision litigios'
		  OR DD_TPO.DD_TPO_DESCRIPCION = 'T. fase común'
		  OR DD_TPO.DD_TPO_DESCRIPCION = 'T. fase convenio' 
        )
        AND PRC.BORRADO = 0
		AND PRC.PRC_PRC_ID IS NULL
    )
  WHERE PROC_NUM = 1
),
ULTIMO_PROC_ASUNTO AS (
	SELECT /*+ MATERIALIZE */ ASU_ID, PRC_ID
	FROM (
	  SELECT ASU.ASU_ID, PRC.PRC_ID, ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID ORDER BY PRC.PRC_ID DESC) RN
	  FROM BANK01.ASU_ASUNTOS ASU
	  INNER JOIN BANK01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID ) TMP_AP
	WHERE RN = 1
),
ULTIMO_TRAMITE_SUBASTA_ASUNTO AS (
	SELECT /*+ MATERIALIZE */ ASU_ID, PRC_ID
	FROM (
	  SELECT ASU.ASU_ID, PRC.PRC_ID, ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID ORDER BY PRC.PRC_ID DESC) RN
	  FROM BANK01.ASU_ASUNTOS ASU
	  INNER JOIN BANK01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
	  INNER JOIN BANK01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = PRC.DD_TPO_ID
		AND TPO.DD_TPO_CODIGO IN ('P401', 'P409') ) TMP_AP
	WHERE RN = 1
),
FECHA_FINALIZACION AS (
	SELECT /*+ MATERIALIZE */ MAX(DPR.FECHAMODIFICAR) FECHAMODIFICAR, PRC.PRC_ID
	FROM BANK01.DPR_DECISIONES_PROCEDIMIENTOS DPR 
	LEFT JOIN BANK01.PRC_PROCEDIMIENTOS PRC ON DPR.PRC_ID = PRC.PRC_ID
	LEFT JOIN BANK01.ASU_ASUNTOS ASU ON PRC.ASU_ID = ASU.ASU_ID
	LEFT JOIN BANKMASTER.DD_EAS_ESTADO_ASUNTOS DD_EAS ON ASU.DD_EAS_ID = DD_EAS.DD_EAS_ID AND DD_EAS.DD_EAS_CODIGO IN ('05', '06')
	LEFT JOIN BANKMASTER.DD_EDE_ESTADOS_DECISION DD_EDE ON DPR.DD_EDE_ID = DD_EDE.DD_EDE_ID AND DD_EDE.DD_EDE_CODIGO = '02'
	WHERE DPR.DPR_FINALIZA = 1
	GROUP BY PRC.PRC_ID
),
DESPACHOS_PROCURADORES AS (
  SELECT /*+ MATERIALIZE */ DISTINCT GAA.ASU_ID, DES.DES_ID, DES.DES_DESPACHO, DES_CODIGO
  FROM BANK01.GAA_GESTOR_ADICIONAL_ASUNTO GAA
    INNER JOIN BANKMASTER.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = 'PROC'
    INNER JOIN BANK01.USD_USUARIOS_DESPACHOS USD ON GAA.USD_ID = USD.USD_ID
    INNER JOIN BANK01.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID
  WHERE GAA.BORRADO = 0
),
DESPACHOS_LETRADO AS (
  SELECT /*+ MATERIALIZE */ DISTINCT GAA.ASU_ID, DES.DES_ID, DES.DES_DESPACHO, DES.DES_CODIGO, USU.USU_USERNAME || ' - ' || USU.USU_NOMBRE || ' ' || USU.USU_APELLIDO1 || ' ' || USU.USU_APELLIDO2 NOMBRE_SUPERVISOR
  FROM BANK01.GAA_GESTOR_ADICIONAL_ASUNTO GAA
    INNER JOIN BANKMASTER.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = 'GEXT'
    INNER JOIN BANK01.USD_USUARIOS_DESPACHOS USD ON GAA.USD_ID = USD.USD_ID
    INNER JOIN BANK01.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID
	INNER JOIN BANKMASTER.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
),
DESPACHOS_LETRADO_SUPERVISOR AS (
  SELECT /*+ MATERIALIZE */ DISTINCT GAA.ASU_ID, DES.DES_ID, DES.DES_DESPACHO, DES.DES_CODIGO, USU.USU_USERNAME || ' - ' || USU.USU_NOMBRE || ' ' || USU.USU_APELLIDO1 || ' ' || USU.USU_APELLIDO2 NOMBRE_SUPERVISOR
  FROM BANK01.GAA_GESTOR_ADICIONAL_ASUNTO GAA
    INNER JOIN BANKMASTER.DD_TGE_TIPO_GESTOR TGE ON GAA.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = 'SUP'
    INNER JOIN BANK01.USD_USUARIOS_DESPACHOS USD ON GAA.USD_ID = USD.USD_ID
    INNER JOIN BANK01.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID
	INNER JOIN BANKMASTER.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
),
VALORES_ASU AS (
  SELECT PRC_ID, TAP_ID, TAP_CODIGO, TAP_DESCRIPCION, TEV_NOMBRE, TEV_VALOR, TFI_TIPO, TEV_MAS_RECIENTE
  FROM (
	  SELECT /*+ MATERIALIZE */ TAR.PRC_ID PRC_ID, TAP.TAP_ID TAP_ID, TAP.TAP_CODIGO TAP_CODIGO, TAP.TAP_DESCRIPCION TAP_DESCRIPCION, TEV.TEV_NOMBRE TEV_NOMBRE, TEV.TEV_VALOR TEV_VALOR, TFI.TFI_TIPO,
								ROW_NUMBER() OVER (PARTITION BY TAR.PRC_ID, TAP.TAP_ID, TEV.TEV_NOMBRE ORDER BY TEV.FECHACREAR DESC) TEV_MAS_RECIENTE
	  FROM BANK01.TAR_TAREAS_NOTIFICACIONES TAR
		INNER JOIN BANK01.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
		  INNER JOIN BANK01.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
			INNER JOIN BANK01.TFI_TAREAS_FORM_ITEMS TFI ON  TAP.TAP_ID = TFI.TAP_ID
			  INNER JOIN BANK01.TEV_TAREA_EXTERNA_VALOR TEV ON TEV.TEX_ID = TEX.TEX_ID AND UPPER(TFI.TFI_NOMBRE) = UPPER(TEV.TEV_NOMBRE) 
	  WHERE NOT TEV.TEV_VALOR IS NULL
	  ) TMP
	  WHERE TEV_MAS_RECIENTE = 1
),
ULTIMO_TAR AS (
  SELECT /*+ MATERIALIZE */ TAR_ID, PRC_ID, ASU_ID, FECHACREAR, TAP_CODIGO, TAR_FECHA_FIN, TAP_DESCRIPCION, DD_TPO_CODIGO, DD_TPO_DESCRIPCION
  FROM (
    SELECT /*+ MATERIALIZE */ TAR.TAR_ID, TAR.PRC_ID, PRC.ASU_ID, TAR.FECHACREAR, TAR.TAR_FECHA_FIN, TAP.TAP_CODIGO, TAP.TAP_DESCRIPCION,
		TPO.DD_TPO_CODIGO, TPO.DD_TPO_DESCRIPCION, ROW_NUMBER() OVER (PARTITION BY PRC.ASU_ID ORDER BY TAR.TAR_ID DESC) FILA
    FROM BANK01.PRC_PROCEDIMIENTOS PRC
      INNER JOIN BANK01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.PRC_ID = PRC.PRC_ID
      INNER JOIN BANK01.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
      INNER JOIN BANK01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
	    INNER JOIN BANK01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TAP.DD_TPO_ID = TPO.DD_TPO_ID
      LEFT JOIN BANK01.AUX_THR_TRADUC_HITOS_RECNAL THR ON THR.TAP_CODIGO = TAP.TAP_CODIGO
    WHERE TAR.TAR_FECHA_FIN IS NOT NULL
  )
  WHERE FILA=1
),
PER_DEMANDADO_PRINCIPAL AS (
SELECT /*+ MATERIALIZE */ PRC_ID, PER_ID, PER_COD_CLIENTE_ENTIDAD, DD_SCE_ID
FROM (
  SELECT PRC_PER.PRC_ID, PRC_PER.PER_ID, PER.PER_COD_CLIENTE_ENTIDAD, PER.DD_SCE_ID,  ROW_NUMBER() OVER (PARTITION BY PRC_PER.PRC_ID ORDER BY PER.PER_DEUDA_IRREGULAR DESC) NUM
  FROM BANK01.PRC_PER
    INNER JOIN BANK01.PER_PERSONAS PER ON PRC_PER.PER_ID = PER.PER_ID)
WHERE NUM = 1
),
ULTIMO_RECURSO AS (
SELECT /*+ MATERIALIZE */ PRC_ID, RCR_FECHA_RECURSO
FROM (
  SELECT RCR.PRC_ID, RCR.RCR_FECHA_RECURSO, ROW_NUMBER() OVER (PARTITION BY RCR.PRC_ID ORDER BY RCR.RCR_FECHA_RECURSO DESC) NUM
  FROM BANK01.RCR_RECURSOS_PROCEDIMIENTOS RCR)
WHERE NUM = 1
),
ULTIMO_PROC_ADJUDICACION AS (
  SELECT /*+ MATERIALIZE */ PRC_ID, ASU_ID
  FROM (
    SELECT /*+ MATERIALIZE */ PRC.PRC_ID, PRC.ASU_ID, PRC.FECHACREAR, DD_TPO.DD_TPO_CODIGO
      ,ROW_NUMBER() OVER (PARTITION BY PRC.ASU_ID ORDER BY PRC.FECHACREAR DESC) PROC_NUM
    FROM BANK01.PRC_PROCEDIMIENTOS PRC
      INNER JOIN BANK01.DD_TPO_TIPO_PROCEDIMIENTO DD_TPO ON PRC.DD_TPO_ID = DD_TPO.DD_TPO_ID
    WHERE DD_TPO.DD_TPO_CODIGO = 'P413'
        AND PRC.BORRADO = 0
    )
  WHERE PROC_NUM = 1
),
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
	SELECT CNT_ID, DEUDA, PRC_ID, EXP_ID, CD_EXPEDIENTE_NUSE, NUMERO_EXP_NUSE
	FROM (
		SELECT /*+ MATERIALIZE */ TMP_DEUDA.CNT_ID, TMP_DEUDA.DEUDA, PRCCEX.PRC_ID, EX.EXP_ID, EX.CD_EXPEDIENTE_NUSE, EX.NUMERO_EXP_NUSE, ROW_NUMBER() OVER (PARTITION BY PRCCEX.PRC_ID ORDER BY TMP_DEUDA.DEUDA DESC) CNT_MAYOR
		FROM (
			select /*+ MATERIALIZE */ CNT_ID, (MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA + MOV_INT_REMUNERATORIOS + MOV_GASTOS + MOV_COMISIONES + MOV_IMPUESTOS) DEUDA
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
		where rn = 1) TMP_DEUDA
		INNER JOIN BANK01.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CNT_ID = TMP_DEUDA.CNT_ID
		INNER JOIN BANK01.EXP_EXPEDIENTES EX ON EX.EXP_ID = CEX.EXP_ID
		INNER JOIN BANK01.PRC_CEX PRCCEX ON PRCCEX.CEX_ID = CEX.CEX_ID) TMP_CNT_MAYOR
	WHERE CNT_MAYOR = 1
),
PERSONA_TITULAR AS (
SELECT /*+ MATERIALIZE */ DISTINCT PP.PRC_ID, PEX.PER_ID, PER.PER_COD_CLIENTE_ENTIDAD
  FROM BANK01.ASU_ASUNTOS ASU, BANK01.PRC_PROCEDIMIENTOS PRC, BANK01.PRC_PER PP, BANK01.PEX_PERSONAS_EXPEDIENTE PEX, BANK01.PER_PERSONAS PER
  WHERE PRC.PRC_ID = PP.PRC_ID
  AND PRC.PRC_PRC_ID IS NULL
  AND PP.PER_ID = PER.PER_ID
  AND PRC.ASU_ID = ASU.ASU_ID
  AND ASU.EXP_ID = PEX.EXP_ID
  AND PER.PER_ID = PEX.PER_ID
  AND PEX.PEX_PASE = 1
  AND PEX.USUARIOCREAR IN ('MIGRABNKF2','MIGRACANF2')
),
PRC_BIE_ADJ AS (
	SELECT /*+ MATERIALIZE */ PRB.PRC_ID, MAX(ADJ.BIE_ADJ_F_DECRETO_FIRME) BIE_ADJ_F_DECRETO_FIRME
	FROM BANK01.PRB_PRC_BIE PRB
	JOIN BANK01.BIE_ADJ_ADJUDICACION ADJ ON PRB.BIE_ID = ADJ.BIE_ID
	GROUP BY PRB.PRC_ID
),
EXPEDIENTE_ASUNTO AS (
	SELECT /*+ MATERIALIZE */ EXP.EXP_ID, ASU.ASU_ID, EXP.CD_EXPEDIENTE_NUSE, EXP.NUMERO_EXP_NUSE
	FROM BANK01.EXP_EXPEDIENTES EXP 
	INNER JOIN BANK01.ASU_ASUNTOS ASU ON ASU.ASU_ID_EXTERNO = EXP.CD_PROCEDIMIENTO
)
SELECT DISTINCT
   CASE WHEN ULT_MOVIMIENTO_CNT.CD_EXPEDIENTE_NUSE IS NOT NULL THEN ULT_MOVIMIENTO_CNT.CD_EXPEDIENTE_NUSE ELSE EXPEDIENTE_ASUNTO.CD_EXPEDIENTE_NUSE END ID_EXPEDIENTE
  ,CASE WHEN ULT_MOVIMIENTO_CNT.EXP_ID IS NOT NULL THEN ULT_MOVIMIENTO_CNT.EXP_ID ELSE EXPEDIENTE_ASUNTO.EXP_ID END ID_EXPEDIENTE_RCV
  ,ASU.ASU_ID ID_ASUNTO_RCV
  ,CASE WHEN ULTPRC.PRC_ID IS NOT NULL THEN ULTPRC.PRC_ID ELSE ULTIMO_PROC_ASUNTO.PRC_ID END ID_PROCEDI_RCV
  ,CNT.CNT_ID ID_CUENTA_RCV
  ,CASE WHEN ULT_MOVIMIENTO_CNT.NUMERO_EXP_NUSE IS NOT NULL THEN ULT_MOVIMIENTO_CNT.NUMERO_EXP_NUSE ELSE EXPEDIENTE_ASUNTO.NUMERO_EXP_NUSE END NUMERO_EXP
  ,CASE DD_PAS.DD_PAS_CODIGO
    WHEN 'BANKIA' THEN '00000'
    WHEN 'SAREB' THEN '05074'
    ELSE NULL
  END ENTIDAD
  ,TO_NUMBER(ASU.ASU_ID_EXTERNO) ID_PROCEDI
  ,CASE
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%APELACION%' THEN 'APELACION'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%CAMBIARIO%' THEN 'CAMBIARIO'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%CONCURSO%' THEN 'CONCURSO'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%EJECUTIVO%' OR UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%NO JUDICIAL%' THEN 'EJECUTIVO'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%HIPOTECARIO%' THEN 'HIPOTECARIO'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%MONITORIO%' THEN 'MONITORIO'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%ORDINARIO%' THEN 'ORDINARIO'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%PENAL%' OR UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%ABREVIADO%' THEN 'PENAL'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%TERCERIA%' THEN 'TERCERIA'
      WHEN UPPER(ULTPRC.DD_TPO_DESCRIPCION) LIKE '%VERBAL%' THEN 'VERBAL'
	  WHEN ULTPRC.DD_TPO_DESCRIPCION = 'T. de aceptacion y decision litigios' THEN 'PRELITIGIO'
	  WHEN ULTPRC.DD_TPO_DESCRIPCION = 'T. fase común' THEN 'CONCURSO'
	  WHEN ULTPRC.DD_TPO_DESCRIPCION = 'T. fase convenio'  THEN 'CONCURSO'
  END TIPO_PROCEDI
  ,SUBSTR(CNT_CONTRATO,6,5) CLASE_P_P
  ,SUBSTR(CNT.CNT_CONTRATO,11,17) NUM_CUENTA
  ,CONCAT('00',SUBSTR(CNT.CNT_CONTRATO,28,15)) NUMERO_ESPEC
  ,SUBSTR(ULTPRC.PRC_COD_PROC_EN_JUZGADO,1,15) NUMERO_AUTOS
  ,NULL CENTRO_RECUP
  ,NULL COD9DN
  ,NULL COD9ZO
  ,OFI.OFI_CODIGO_OFICINA OFICINA_PRODUCTO
  ,ULTPRC.DD_JUZ_CODIGO ID_JUZGADO
  ,SUBSTR(DESP_LET.DES_CODIGO,1,15) ANAGRAMA_ABO
  ,SUBSTR(DESP_PROC.DES_CODIGO,1,15) ANAGRAMA_PRO
  ,DESPACHOS_LETRADO_SUPERVISOR.NOMBRE_SUPERVISOR SUPERVISOR_RCV
  ,ASU.FECHACREAR FECHA_ALTA 
  , CASE WHEN (FECHA_FINALIZACION.FECHAMODIFICAR IS NULL AND DD_EAS.DD_EAS_CODIGO IN ('05', '06')) THEN ULT_TAR.TAR_FECHA_FIN 
	ELSE NULL 
	END FECHA_BAJA
    ,PERSONA_TITULAR.PER_ID ID_PERSONA_RCV
    ,TO_CHAR(PERSONA_TITULAR.PER_COD_CLIENTE_ENTIDAD) NUMERO_PERSONA 
    ,DECODE(UPPER(ESC.DD_ESC_DESCRIPCION), 'ACTIVO', ULT_MOVIMIENTO_CNT.DEUDA,0) IMP_DEUDA
    ,CASE WHEN TEV_DEMANDA.TEV_VALOR LIKE '__-__-____' THEN TO_DATE(TEV_DEMANDA.TEV_VALOR, 'DD-MM-YYYY')
        WHEN TEV_DEMANDA.TEV_VALOR LIKE '____-__-__' THEN TO_DATE(TEV_DEMANDA.TEV_VALOR, 'YYYY-MM-DD')
        ELSE NULL 
      END FECHA_DEMANDA
    ,ULTPRC.PRC_SALDO_RECUPERACION IMPORTE_PRINCIPAL
    ,TO_NUMBER(REPLACE(TEV_COSTAS.TEV_VALOR,'.',',')) INTERESES_COSTAS
    ,TO_NUMBER(REPLACE(TEVIMPDEMAN.TEV_VALOR,'.',',')) IMPORTE_DEMANDA
    ,CASE WHEN TEV_FECHDESP.TEV_VALOR LIKE '__-__-____' THEN TO_DATE(TEV_FECHDESP.TEV_VALOR, 'DD-MM-YYYY')
        WHEN TEV_FECHDESP.TEV_VALOR LIKE '____-__-__' THEN TO_DATE(TEV_FECHDESP.TEV_VALOR, 'YYYY-MM-DD')
        ELSE NULL     
      END FECHA_DESPACHO_EJECUCION
	,CASE WHEN VALOR_FECHA_AUTO.TEV_VALOR LIKE '__-__-____' THEN TO_DATE(VALOR_FECHA_AUTO.TEV_VALOR, 'DD-MM-YYYY')
        WHEN VALOR_FECHA_AUTO.TEV_VALOR LIKE '____-__-__' THEN TO_DATE(VALOR_FECHA_AUTO.TEV_VALOR, 'YYYY-MM-DD')
        ELSE NULL 
      END FECHA_AUTO
	,CASE WHEN AUX_THR.COD_HITO_NAL IS NOT NULL THEN AUX_THR.COD_HITO_NAL ELSE 'A0000' END HITO_MAS_AVANZADO
    ,ULT_TAR.TAR_FECHA_FIN F_HITO_MAS_AVANZADO
	,ULT_TAR.TAP_CODIGO ID_ULT_TAR_REALIZADA_RCV
	,ULT_TAR.TAP_DESCRIPCION ULT_TAR_REALIZADA_RCV
	,ULT_TAR.TAR_FECHA_FIN F_ULT_TAR_REALIZADA_RCV
	,ULT_TAR.DD_TPO_CODIGO ID_TRAMITE_ACTUAL_RCV
	,ULT_TAR.DD_TPO_DESCRIPCION TRAMITE_ACTUAL_RCV
    ,NULL ID_PDM_PADRE
    ,CASE DD_EAS.DD_EAS_CODIGO WHEN '05' THEN 'FINPDM' WHEN '06' THEN 'FINPDM' ELSE 'VIV' END ESTADO
	,DD_EAS.DD_EAS_CODIGO ID_ESTADO_RCV
	,DD_EAS.DD_EAS_DESCRIPCION ESTADO_RCV
    ,DD_DFI.DD_DFI_DESCRIPCION MOTIVO_FINALIZ
    ,ULTRECUR.RCR_FECHA_RECURSO FEC_ADMISON_APEL
    ,TO_NUMBER(REPLACE(TEVIMPCOSTLET.TEV_VALOR,'.',',')) IMP_COSTAS_LTR
    ,TO_NUMBER(REPLACE(TEVIMPCOSTPROC.TEV_VALOR,'.',',')) IMP_COSTAS_PRO
    ,(TO_NUMBER(REPLACE(TEVIMPCOSTLET.TEV_VALOR,'.',',')) + TO_NUMBER(REPLACE(TEVIMPCOSTPROC.TEV_VALOR,'.',','))) IMP_COSTAS_TOT
    ,CASE WHEN GES.DD_GES_CODIGO = 'HAYA' THEN 'S' ELSE 'N' END IND_PLATAFORMA
    ,SEGTO.DD_SCE_DESCRIPCION SEGMENTO
FROM BANK01.ASU_ASUNTOS ASU 
  LEFT JOIN BANKMASTER.DD_EAS_ESTADO_ASUNTOS DD_EAS ON ASU.DD_EAS_ID = DD_EAS.DD_EAS_ID
  LEFT JOIN BANK01.DD_PAS_PROPIEDAD_ASUNTO DD_PAS ON ASU.DD_PAS_ID = DD_PAS.DD_PAS_ID
  LEFT JOIN DESPACHOS_LETRADO DESP_LET ON DESP_LET.ASU_ID = ASU.ASU_ID
  LEFT JOIN DESPACHOS_LETRADO_SUPERVISOR ON DESPACHOS_LETRADO_SUPERVISOR.ASU_ID = ASU.ASU_ID
  LEFT JOIN DESPACHOS_PROCURADORES DESP_PROC ON DESP_PROC.ASU_ID = ASU.ASU_ID
  LEFT JOIN ULT_PROC_PADRE ULTPRC ON ASU.ASU_ID = ULTPRC.ASU_ID
  INNER JOIN ULTIMO_PROC_ASUNTO ON ULTIMO_PROC_ASUNTO.ASU_ID = ASU.ASU_ID
  LEFT JOIN EXPEDIENTE_ASUNTO ON EXPEDIENTE_ASUNTO.ASU_ID = ULTIMO_PROC_ASUNTO.ASU_ID
  LEFT JOIN ULT_MOVIMIENTO_CNT ON ULT_MOVIMIENTO_CNT.PRC_ID = ULTIMO_PROC_ASUNTO.PRC_ID
  LEFT JOIN BANK01.CNT_CONTRATOS CNT ON ULT_MOVIMIENTO_CNT.CNT_ID = CNT.CNT_ID AND CNT.BORRADO = 0
  LEFT JOIN BANK01.EXT_IAC_INFO_ADD_CONTRATO EXT ON EXT.CNT_ID = CNT.CNT_ID
            AND EXT.DD_IFC_ID IN (SELECT /*+ MATERIALIZE */ DD.DD_IFC_ID  FROM BANK01.EXT_DD_IFC_INFO_CONTRATO DD WHERE DD.DD_IFC_CODIGO = 'NUMERO_ESPEC')
  LEFT JOIN BANK01.OFI_OFICINAS OFI ON CNT.OFI_ID_ADMIN = OFI.OFI_ID
  LEFT JOIN VALORES_ASU TEV_DEMANDA ON TEV_DEMANDA.PRC_ID = ULTPRC.PRC_ID 
    AND TEV_DEMANDA.TAP_CODIGO IN ('P01_DemandaCertificacionCargas',
                                 'P17_InterposicionDemandaMasBienes',
                                 'P04_InterposicionDemanda',
                                 'P25_interposicionDemanda',
                                 'P15_InterposicionDemandaMasBienes',
                                 'P03_InterposicionDemanda',
                                 'P02_InterposicionDemanda',
								 'P32_interposicionDemandaQuerella')
      AND UPPER(TEV_DEMANDA.TFI_TIPO) = 'DATE'
    LEFT JOIN VALORES_ASU TEV_COSTAS ON TEV_COSTAS.PRC_ID = ULTPRC.PRC_ID  /*ultpadre*/
      AND TEV_COSTAS.TAP_CODIGO IN ('P401_SenyalamientoSubasta','P409_SenyalamientoSubasta')
      AND UPPER(TEV_COSTAS.TEV_NOMBRE) = 'INTERESES'
    LEFT JOIN VALORES_ASU TEVIMPDEMAN ON TEVIMPDEMAN.PRC_ID = ULTPRC.PRC_ID /*ultpadre*/
      AND TEVIMPDEMAN.TAP_CODIGO IN ('P01_DemandaCertificacionCargas',
                                 'P17_InterposicionDemandaMasBienes',
                                 'P04_InterposicionDemanda',
                                 'P25_interposicionDemanda',
                                 'P15_InterposicionDemandaMasBienes',
                                 'P03_InterposicionDemanda',
                                 'P02_InterposicionDemanda',
								 'P32_interposicionDemandaQuerella')
      AND UPPER(TEVIMPDEMAN.TEV_NOMBRE)='PRINCIPALDEMANDA'      
    LEFT JOIN VALORES_ASU TEV_FECHDESP ON TEV_FECHDESP.PRC_ID = ULTPRC.PRC_ID /*ultpadre*/
      AND TEV_FECHDESP.TAP_CODIGO  IN ('P01_AutoDespachandoEjecucion', 'P15_AutoDespaEjecMasDecretoEmbargo_new1')
      AND UPPER(TEV_FECHDESP.TEV_NOMBRE)='FECHA'
  LEFT JOIN ULT_PROC ON ULT_PROC.ASU_ID = ASU.ASU_ID
  LEFT JOIN ULTIMO_TAR ULT_TAR ON ULT_TAR.ASU_ID = ASU.ASU_ID
    LEFT JOIN BANK01.AUX_THR_TRADUC_HITOS_RECNAL AUX_THR ON AUX_THR.TAP_CODIGO = ULT_TAR.TAP_CODIGO AND ULT_TAR.DD_TPO_CODIGO = AUX_THR.DD_TPO_CODIGO 
  LEFT JOIN ULTIMO_TRAMITE_SUBASTA_ASUNTO ON ULTIMO_TRAMITE_SUBASTA_ASUNTO.ASU_ID = ASU.ASU_ID
  LEFT JOIN VALORES_ASU TEVIMPCOSTLET ON TEVIMPCOSTLET.PRC_ID = ULTIMO_TRAMITE_SUBASTA_ASUNTO.PRC_ID /*ultpadre*/
    AND TEVIMPCOSTLET.TAP_CODIGO IN ('P401_SenyalamientoSubasta','P409_SenyalamientoSubasta')
    AND UPPER(TEVIMPCOSTLET.TEV_NOMBRE)='COSTASLETRADO'
  LEFT JOIN VALORES_ASU TEVIMPCOSTPROC ON TEVIMPCOSTPROC.PRC_ID = ULTIMO_TRAMITE_SUBASTA_ASUNTO.PRC_ID /*ultpadre*/
    AND TEVIMPCOSTPROC.TAP_CODIGO IN ('P401_SenyalamientoSubasta','P409_SenyalamientoSubasta')
    AND UPPER(TEVIMPCOSTPROC.TEV_NOMBRE)='COSTASPROCURADOR'
  LEFT JOIN FECHA_FINALIZACION ON FECHA_FINALIZACION.PRC_ID = ULTIMO_PROC_ASUNTO.PRC_ID
  LEFT JOIN BANK01.DPR_DECISIONES_PROCEDIMIENTOS DPR ON DPR.PRC_ID = ULTIMO_PROC_ASUNTO.PRC_ID AND DPR.TAR_ID = ULT_TAR.TAR_ID
  LEFT JOIN BANK01.DD_DFI_DECISION_FINALIZAR DD_DFI ON DD_DFI.DD_DFI_ID = DPR.DD_DFI_ID
  LEFT JOIN PER_DEMANDADO_PRINCIPAL PER ON PER.PRC_ID = ULTIMO_PROC_ASUNTO.PRC_ID
    LEFT JOIN BANK01.DD_SCE_SEGTO_CLI_ENTIDAD SEGTO ON SEGTO.DD_SCE_ID = PER.DD_SCE_ID
  LEFT JOIN ULTIMO_RECURSO ULTRECUR ON ULTRECUR.PRC_ID = ULTIMO_PROC_ASUNTO.PRC_ID
  LEFT JOIN BANK01.DD_GES_GESTION_ASUNTO GES ON GES.DD_GES_ID = ASU.DD_GES_ID
  LEFT JOIN VALORES_ASU VALOR_FECHA_AUTO ON ULTPRC.PRC_ID = VALOR_FECHA_AUTO.PRC_ID AND VALOR_FECHA_AUTO.TEV_NOMBRE = 'fechaAuto'
  LEFT JOIN PERSONA_TITULAR ON PERSONA_TITULAR.PRC_ID = ULTPRC.PRC_ID
  LEFT JOIN BANKMASTER.DD_ESC_ESTADO_CNT ESC ON ESC.DD_ESC_ID = CNT.DD_ESC_ID
WHERE ASU.BORRADO = 0;

COMMIT;

MERGE INTO MINIREC.RCV_GEST_PDM_LITIGIO RCV
USING  ( SELECT ID_PROCEDI, FECHA_ALTA, FECHA_BAJA, ESTADO
			FROM PFSRECOVERY.TMP_RCV_GEST_PDM_LITIGIO) TMP
ON (RCV.ID_PROCEDI = TMP.ID_PROCEDI)                       
WHEN MATCHED THEN 
UPDATE SET 	 RCV.FECHA_BAJA = TMP.FECHA_BAJA
			,RCV.ESTADO = TMP.ESTADO;

COMMIT;

MERGE INTO MINIREC.RCV_GEST_PDM_LITIGIO RCV
USING  ( SELECT ID_PROCEDI, F_HITO_MAS_AVANZADO
			FROM PFSRECOVERY.TMP_RCV_GEST_PDM_LITIGIO_FHITO) TMP
ON (RCV.ID_PROCEDI = TMP.ID_PROCEDI)                       
WHEN MATCHED THEN 
UPDATE SET 	 RCV.F_HITO_MAS_AVANZADO = TMP.F_HITO_MAS_AVANZADO;

COMMIT;

UPDATE MINIREC.RCV_GEST_PDM_LITIGIO SET HITO_MAS_AVANZADO = 'F9999' WHERE ESTADO = 'FINPDM';
UPDATE MINIREC.RCV_GEST_PDM_LITIGIO SET HITO_MAS_AVANZADO = 'F9999' WHERE ESTADO = 'FINACT'; 
COMMIT;

MERGE INTO MINIREC.RCV_GEST_PDM_LITIGIO RCV
USING (
	SELECT PRC.PRC_ID, SUM(TMP_DEUDA.DEUDA) SUM_DEUDA
	FROM BANK01.PRC_PROCEDIMIENTOS PRC
	INNER JOIN BANK01.PRC_CEX PC ON PRC.PRC_ID = PC.PRC_ID
	INNER JOIN BANK01.CEX_CONTRATOS_EXPEDIENTE CEX ON PC.CEX_ID = CEX.CEX_ID
	INNER JOIN BANK01.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID
	INNER JOIN (
		  select CNT_ID, (MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA + MOV_INT_REMUNERATORIOS + MOV_GASTOS + MOV_COMISIONES + MOV_IMPUESTOS) DEUDA
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
					from BANK01.MOV_MOVIMIENTOS mov					
					) tmp_mov
			where rn = 1) TMP_DEUDA ON TMP_DEUDA.CNT_ID = CNT.CNT_ID
      INNER JOIN BANKMASTER.DD_ESC_ESTADO_CNT ESC ON ESC.DD_ESC_ID = CNT.DD_ESC_ID
      WHERE UPPER(ESC.DD_ESC_DESCRIPCION) = 'ACTIVO'
	AND EXISTS (SELECT 1 FROM MINIREC.RCV_GEST_PDM_LITIGIO RCV
					  WHERE RCV.ID_PROCEDI_RCV = PRC.PRC_ID)
	GROUP BY PRC.PRC_ID
	) SRC
ON (RCV.ID_PROCEDI_RCV = SRC.PRC_ID)
WHEN MATCHED THEN
UPDATE SET RCV.IMP_DEUDA = SRC.SUM_DEUDA;

COMMIT;

---IMPORTE_DEMANDA de CONCURSOS:

MERGE INTO MINIREC.RCV_GEST_PDM_LITIGIO RCV
USING (
 WITH
 IMP_DEMANDA_TAR AS  
 (SELECT SUM(TO_NUMBER(REPLACE(TEV.TEV_VALOR,'.',','))) TEV_VALOR,PRC.PRC_PRC_ID PRC_ID, prc.usuariocrear
                                    FROM BANK01.TEV_TAREA_EXTERNA_VALOR   TEV,
                                         BANK01.TAP_TAREA_PROCEDIMIENTO   TAP,
                                         BANK01.TEX_TAREA_EXTERNA         TEX,
                                         BANK01.TAR_TAREAS_NOTIFICACIONES TAR,                                                    
                                         BANK01.PRC_PROCEDIMIENTOS        PRC
                                   WHERE TAR.PRC_ID         = PRC.PRC_ID
                                     AND TAR.TAR_TAREA      = 'Presentar escrito de insinuación'
                                     AND TEX.TAR_ID         = TAR.TAR_ID   
                                     AND TAP.TAP_ID         = TEX.TAP_ID
                                     AND TAP.TAP_CODIGO     = 'P412_PresentarEscritoInsinuacion'       
                                     AND TEV.TEX_ID         = TEX.TEX_ID 
                                     AND TEV.TEV_NOMBRE IN ('tCredMasa','tCredPrivEsp','tCredOrd','tCredSub','tCredContigentes' )
                                  GROUP BY PRC.PRC_PRC_ID  , prc.usuariocrear ) ,
IMP_DEMANDA_PRC AS
( SELECT DISTINCT PRC_SALDO_RECUPERACION PRC_SALDO_REC,PRC.PRC_ID PRC_ID
   FROM BANK01.PRC_PROCEDIMIENTOS PRC  )
SELECT CASE WHEN upper(NVL(usuariocrear,'MIGRA')) like '%MIGRA%' THEN IDP.PRC_SALDO_REC ELSE IDT.TEV_VALOR END IMPORTE_DEMANDA,
       NVL(IDT.PRC_ID,IDP.PRC_ID) PRC_ID
   FROM IMP_DEMANDA_PRC IDP left JOIN
         IMP_DEMANDA_TAR IDT ON IDP.PRC_ID = IDT.PRC_ID
	) IDC
ON (RCV.ID_PROCEDI_RCV = IDC.PRC_ID)
WHEN MATCHED THEN
UPDATE SET RCV.IMPORTE_DEMANDA = IDC.IMPORTE_DEMANDA
where RCV.TIPO_PROCEDI = 'CONCURSO' ;

COMMIT;

-- FECHA DEMANDA CONCURSOS
MERGE INTO MINIREC.RCV_GEST_PDM_LITIGIO RCV
USING  ( SELECT distinct to_date(tev_valor, 'YYYY-MM-DD') tev_valor, asu.asu_id_externo
		FROM bank01.asu_asuntos asu INNER JOIN 
			 bank01.prc_procedimientos prc on prc.asu_id = asu.asu_id inner join
			 bank01.tar_tareas_notificaciones tar on tar.prc_id = prc.prc_id inner join
			 bank01.tex_tarea_externa tex on tex.tar_id = tar.tar_id and tex.tap_id = (select tap_id from BANK01.TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P412_RegistrarPublicacionBOE') inner join
			 bank01.tev_tarea_externa_valor tev on tev.tex_id = tex.tex_id and tev.tev_nombre = 'fechaAuto'
	 ) SRC
ON (RCV.ID_PROCEDI = SRC.asu_id_externo)                       
WHEN MATCHED THEN 
UPDATE SET 	 RCV.FECHA_DEMANDA = SRC.TEV_VALOR
WHERE RCV.TIPO_PROCEDI = 'CONCURSO';

COMMIT;

-- COD9DZ, COD9DN
MERGE INTO MINIREC.RCV_GEST_PDM_LITIGIO PDM
USING ( select distinct 
				aux.dz,
				aux.dt,
				aux.cnt_id
		from (   
		   select DISTINCT
				lpad(dz.ofi_codigo_oficina,4,'0') dz,
				lpad(dt.ofi_codigo_oficina,4,'0') dt,
				cnt.cnt_id       
		   from bank01.cnt_contratos cnt INNER JOIN
		    MINIREC.RCV_GEST_PDM_LITIGIO pdm on cnt.cnt_id = pdm.id_cuenta_rcv left join  
				bank01.ofi_oficinas ofi on ofi.ofi_id = cnt.ofi_id_admin left join
				bank01.zon_zonificacion zonofi on zonofi.ofi_id = ofi.ofi_id left join
				bank01.zon_zonificacion zondz on zondz.zon_id = zonofi.zon_pid left join
				bank01.ofi_oficinas dz on dz.ofi_id = zondz.ofi_id left join
				bank01.zon_zonificacion zondt on zondt.zon_id = zondz.zon_pid left join
				bank01.ofi_oficinas dt on dt.ofi_id = zondt.ofi_id left join 
				bank01.ofi_oficinas oficentro on oficentro.ofi_codigo = cnt.cnt_cod_centro
        ) aux
    ) SRC
ON (PDM.ID_CUENTA_RCV = SRC.CNT_ID)
WHEN MATCHED THEN
UPDATE SET  
			PDM.COD9ZO = SRC.DZ,
			PDM.COD9DN = SRC.DT ;

COMMIT;
			
-- CENTRO RECUPERACION
MERGE INTO MINIREC.RCV_GEST_PDM_LITIGIO PDM
USING ( with personas_ofi_gestora as (
            select icc.per_id, icc.icc_value
            from bank01.ext_icc_info_extra_cli icc inner join 
                bank01.ext_dd_ifx_info_extra_cli ifx on ifx.dd_ifx_id = icc.dd_ifx_id and dd_ifx_codigo = 'COD_OFICINA_GESTORA'
            )
        select centro_recuperaciones, cnt_id
        from (
            select distinct 
                    lpad(oficr.ofi_codigo_oficina,4,'0') centro_recuperaciones,
                    cpe.cnt_id,
                    ROW_NUMBER () OVER (PARTITION BY cpe.cnt_id ORDER BY cpe.cpe_orden) rn
            from 
              bank01.cpe_contratos_personas cpe  INNER JOIN
              MINIREC.RCV_GEST_PDM_LITIGIO pdm on cpe.cnt_id = pdm.id_cuenta_rcv inner join
              bank01.dd_tin_tipo_intervencion tin on tin.dd_tin_id = cpe.dd_tin_id and tin.DD_TIN_TITULAR = 1 left join 
              personas_ofi_gestora on personas_ofi_gestora.per_id = cpe.per_id inner join
              bank01.ofi_oficinas oficr on oficr.ofi_codigo_oficina = personas_ofi_gestora.icc_value
          ) orden 
          where rn = 1
    ) SRC
ON (PDM.ID_CUENTA_RCV = SRC.CNT_ID)
WHEN MATCHED THEN
UPDATE SET  PDM.CENTRO_RECUP = SRC.centro_recuperaciones;

COMMIT;
