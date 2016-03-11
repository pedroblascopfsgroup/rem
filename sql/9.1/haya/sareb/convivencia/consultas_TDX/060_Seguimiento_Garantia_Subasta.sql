--Borrado de historico
DELETE FROM MINIREC.H_SEG_GARANTIAS_SUBASTAS
WHERE TO_CHAR(FECHA_HISTORICO,'YYYYMMDD') LIKE TO_CHAR(SYSDATE,'YYYYMMDD')
OR TO_CHAR(FECHA_HISTORICO,'YYYYMMDD') < TO_CHAR(SYSDATE-+30,'YYYYMMDD')
;

--Transferencia de los datos al historico
INSERT INTO MINIREC.H_SEG_GARANTIAS_SUBASTAS
(
FECHA_HISTORICO,
	ASU_ID,
ID_PROCEDIMIENTO,
NUM_CUENTA,
IDGA,
ADJ001,
ADJ317,
ENTI,
ENTIDAD,
SERVICER,
FECHA_SUBASTA,
CLASE_SUBASTA,
SITUACION_SUBASTA,
ASISTENCIA_SUBASTA,
RESULTADO_SUBASTA,
CESION_REMATE,
IMPORTE_ADJUDICACION,
FECHA_FIRME_ADJ,
FECHA_EXP_TEST,
FECHA_INSC_REG,
FECHA_LANZAMIENTO,
FECHA_POSESION
)
SELECT 
sysdate ,
ASU_ID,
SEG.ID_PROCEDIMIENTO,
SEG.NUM_CUENTA,
SEG.IDGA,
SEG.ADJ001,
SEG.ADJ317,
SEG.ENTI,
SEG.ENTIDAD,
SEG.SERVICER,
SEG.FECHA_SUBASTA,
SEG.CLASE_SUBASTA,
SEG.SITUACION_SUBASTA,
SEG.ASISTENCIA_SUBASTA,
SEG.RESULTADO_SUBASTA,
SEG.CESION_REMATE,
SEG.IMPORTE_ADJUDICACION,
SEG.FECHA_FIRME_ADJ,
SEG.FECHA_EXP_TEST,
SEG.FECHA_INSC_REG,
SEG.FECHA_LANZAMIENTO,
SEG.FECHA_POSESION
FROM MINIREC.SEGUIMIENTO_GARANTIAS_SUBASTAS SEG;

--Truncado de tablas TDX
TRUNCATE TABLE MINIREC.SEGUIMIENTO_GARANTIAS_SUBASTAS;

--Generacion de las tablas TDX
INSERT INTO MINIREC.SEGUIMIENTO_GARANTIAS_SUBASTAS
(
ASU_ID,
ID_PROCEDIMIENTO,
NUM_CUENTA,
IDGA,
ADJ001,
ADJ317,
ENTI,
ENTIDAD,
SERVICER,
FECHA_SUBASTA,
CLASE_SUBASTA,
SITUACION_SUBASTA,
ASISTENCIA_SUBASTA,
RESULTADO_SUBASTA,
CESION_REMATE,
IMPORTE_ADJUDICACION,
FECHA_FIRME_ADJ,
FECHA_EXP_TEST,
FECHA_INSC_REG,
FECHA_LANZAMIENTO,
FECHA_POSESION
)
WITH POSTORES AS(
  SELECT 
    PRC.PRC_ID,
    TEV.TEV_VALOR
  FROM HAYA01.PRC_PROCEDIMIENTOS PRC
    INNER JOIN HAYA01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.PRC_ID = PRC.PRC_ID
    INNER JOIN HAYA01.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID=TAR.TAR_ID
    INNER JOIN HAYA01.TEV_TAREA_EXTERNA_VALOR TEV ON TEV.TEX_ID=TEX.TEX_ID
  WHERE TEV_NOMBRE = 'comboPostores'
    AND TAR.TAR_TAREA LIKE 'Celebración de subasta'
    AND TAR.FECHACREAR=(
      SELECT MAX(TAR.FECHACREAR) 
      FROM HAYA01.TAR_TAREAS_NOTIFICACIONES TAR2 
      WHERE PRC.PRC_ID=TAR.PRC_ID
      GROUP BY TAR.PRC_ID
    )
)
Select 
  ASU_ID,
  PRC_ID,
  substr(CNT_CONTRATO,11,17),
  max(BIE_SAREB_ID), 
  max(ADJ001),
  max(ADJ317),
  '2038',
  'BANKIA',
  'HAYA',
  max(SUB_FECHA_SENYALAMIENTO),
  Clase_subasta,
  SituacionSubasta,
  MAX(TEV_VALOR) Asistencia_Subasta,
  max(RESULTADO_SUBASTA),
  max(cesion_remate),
  max(Importe_Adjudicación),
  max(Fecha_Adjudicacion),
  max(fecha_testimonio),
  max(Inscripción_Registro),
  max(Lanzamiento),
  max(Posesion)
  
  from(  
  SELECT distinct
    ASU.ASU_ID,
    nvl(PRC.PRC_PRC_ID,PRC.PRC_ID) as PRC_ID,
    CNT.CNT_CONTRATO,
    B.BIE_SAREB_ID,
    B.BIE_NUMERO_ACTIVO ADJ001,
    B.BIE_NUMERO_ACTIVO ADJ317,
    S.SUB_FECHA_SENYALAMIENTO,
    CASE WHEN ASU.DD_TAS_ID=2 THEN 'CONCURSO' ELSE 'JUDICIAL' END as Clase_subasta,
    CASE 
    WHEN ESU.DD_ESU_CODIGO='SUS' THEN 'SUSPENDIDA' WHEN  ESU.DD_ESU_CODIGO='CEL' THEN 'CELEBRADA' ELSE 'PENDIENTE' END AS SituacionSubasta,
    CASE POST.TEV_VALOR
      WHEN '01' THEN 'SIN POSTORES'
      WHEN 'No' THEN 'SIN POSTORES'
      WHEN '02' THEN 'CON POSTORES'
      WHEN 'Si' THEN 'CON POSTORES'
      ELSE'SIN DATOS'
    END AS TEV_VALOR ,
    CASE 
    WHEN ESU.DD_ESU_CODIGO='CEL' THEN
      CASE 
        WHEN ADJ.DD_EAD_ID=24 THEN 'ADJUDICADO SAREB' 
        WHEN ADJ.DD_EAD_ID=25 THEN 'ADJUDICADO TERCEROS' 
      ELSE 'SIN DATOS' 
      end 
    ELSE 'SIN DATOS'
    END as RESULTADO_SUBASTA,
    
    CASE WHEN BIE_ADJ_CESION_REMATE=1 THEN 'si'
        WHEN BIE_ADJ_CESION_REMATE=0 THEN 'no'
        WHEN BIE_ADJ_CESION_REMATE is null THEN 'no'
    END as cesion_remate,
    BIE_ADJ_IMPORTE_ADJUDICACION as Importe_Adjudicación,
    BIE_ADJ_F_DECRETO_FIRME Fecha_Adjudicacion ,
    BIE_ADJ_F_DECRETO_FIRME - 5 fecha_testimonio,
    BIE_ADJ_F_PRES_INS as Inscripción_Registro ,
    BIE_ADJ_F_REA_LANZAMIENTO Lanzamiento,
    BIE_ADJ_F_REA_POSESION Posesion
  FROM HAYA01.ASU_ASUNTOS ASU
    INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON ASU.ASU_ID = PRC.ASU_ID 
    INNER JOIN HAYA01.PRB_PRC_BIE PRB ON PRB.PRC_ID=PRC.PRC_ID
    INNER JOIN HAYA01.BIE_BIEN B ON B.BIE_ID = PRB.BIE_ID
    LEFT JOIN HAYA01.BIE_ADJ_ADJUDICACION ADJ ON B.BIE_ID = ADJ.BIE_ID
    LEFT JOIN HAYA01.SUB_SUBASTA S ON S.prc_ID=PRC.prc_ID  
    INNER JOIN HAYA01.BIE_ADICIONAL ADI ON ADI.BIE_ID=B.BIE_ID
    LEFT JOIN HAYA01.DD_ESU_ESTADO_SUBASTA ESU ON ESU.DD_ESU_ID=S.DD_ESU_ID
    LEFT JOIN HAYA01.BIE_CNT BIECNT ON BIECNT.BIE_ID=B.BIE_ID
    LEFT JOIN HAYA01.CNT_CONTRATOS CNT ON CNT.CNT_ID = BIECNT.CNT_ID
    LEFT JOIN POSTORES POST ON POST.PRC_ID=PRC.PRC_ID
    INNER JOIN MINIREC.PROCEDIMIENTO_JUDICIAL_FOTO FOTO ON FOTO.ID_PROCEDIMIENTO=PRC.PRC_ID
)

Group by( ASU_ID,PRC_ID, CNT_CONTRATO,ADJ001,ADJ317,Clase_subasta,SituacionSubasta,SUB_FECHA_SENYALAMIENTO)
;
