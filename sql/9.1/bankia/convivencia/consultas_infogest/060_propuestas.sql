DELETE FROM MINIREC.RCV_GEST_PROPUESTA;
commit;

INSERT INTO MINIREC.RCV_GEST_PROPUESTA
WITH ULT_MOVIMIENTO_CNT AS (
	SELECT CNT_ID, DEUDA, PRC_ID, EXP_ID, CD_EXPEDIENTE_NUSE, CODIGO_PROCEDIMIENTO_NUSE
	FROM (
		SELECT /*+ MATERIALIZE */ TMP_DEUDA.CNT_ID, TMP_DEUDA.DEUDA, PRCCEX.PRC_ID, EX.EXP_ID, EX.CD_EXPEDIENTE_NUSE, EX.CODIGO_PROCEDIMIENTO_NUSE, ROW_NUMBER() OVER (PARTITION BY PRCCEX.PRC_ID ORDER BY TMP_DEUDA.DEUDA DESC) CNT_MAYOR
		FROM (
			select /*+ MATERIALIZE */ CNT_ID, (MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA + MOV_INT_MORATORIOS + MOV_GASTOS + MOV_COMISIONES + MOV_IMPUESTOS) DEUDA
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
)
SELECT DISTINCT
  UMC.EXP_ID             ID_EXPEDIENTE_RCV 
 ,A.ID_ASUNTO_RCV
 ,A.ID_PROCEDI_RCV
 ,A.ID_PROCEDI
 ,UMC.CD_EXPEDIENTE_NUSE ID_EXPEDIENTE
 ,SUB.CD_SUBASTA_ORIG    ID_PROPUESTA_NAL
 ,SUB.PRC_ID ID_PROPUESTA_RCV
 ,null ID_ACUERDO_CIERRE	
 ,null        FECHA_ALTA_CIERRE	
  ,NULL PREDOMINANTE 
  ,'INTERVENCIÓN EN SUBASTA NLEC' FINALIDAD
  ,DECODE(ESU.DD_ESU_CODIGO,'PIN','ELA','PPR','ELA', 'SUS','ANU','CAN','ANU','PAC','APR','PCE','APR','CEL','FIN',NULL) SITUACION_ACTUAL
  ,UMC.DEUDA    IMPORTE_PROPUESTA 
 ,TRUNC(SUB.SUB_FECHA_SOLICITUD) FECHA_PROPUESTA
 ,TAR_F_ENVIO.TEV_VALOR FECHA_ENVIO
  ,DECODE(TSU.DD_TSU_CODIGO,'DEL',TAR_F_ENVIO.TEV_VALOR,'NDE',TAR_F_APROB.TEV_VALOR) FECHA_ACEPTACION
  ,DECODE(TSU.DD_TSU_CODIGO,'DEL',TAR_F_ENVIO.TEV_VALOR,'NDE',TAR_F_APROB.TEV_VALOR) FECHA_APROBACION
 ,TRUNC(SUB.SUB_FECHA_SOLICITUD)  FECHA_INICIO_SITUACION


FROM  (
select DISTINCT TAR.ASU_ID,tev.tev_nombre, TO_DATE(tev.tev_valor,'YYYY-MM-DD') AS TEV_VALOR
 from BANK01.tar_tareas_notificaciones tar
    , BANK01.tex_tarea_externa         tex
    , BANK01.tap_tarea_procedimiento   tap
    , BANK01.tev_tarea_externa_valor   tev
where tar.tar_id = tex.tar_id
  and tex.tap_id = tap.tap_id
  and tex.tex_id = tev.tex_id
  and tap.tap_codigo in ('P409_PrepararPropuestaSubasta','P401_PrepararPropuestaSubasta')
  and trim(tev.tev_nombre) = 'fechaPropuesta'
)                TAR_F_ENVIO,
(
select DISTINCT TAR.ASU_ID,tev.tev_nombre, TO_DATE(tev.tev_valor,'YYYY-MM-DD') AS TEV_VALOR
 from BANK01.tar_tareas_notificaciones tar
    , BANK01.tex_tarea_externa         tex
    , BANK01.tap_tarea_procedimiento   tap
    , BANK01.tev_tarea_externa_valor   tev
where tar.tar_id = tex.tar_id
  and tex.tap_id = tap.tap_id
  and tex.tex_id = tev.tex_id
  and tap.tap_codigo in ('P401_ValidarPropuesta','P409_ValidarPropuesta')
  and trim(tev.tev_nombre) = 'fechaDecision'
)                TAR_F_APROB,
BANK01.DD_TSU_TIPO_SUBASTA TSU,
BANK01.ULT_MOVIMIENTO_CNT UMC,
BANK01.TEX_TAREA_EXTERNA TEX,
BANK01.TAP_TAREA_PROCEDIMIENTO TAP,
BANK01.TAR_TAREAS_NOTIFICACIONES TAR,
BANK01.SUB_SUBASTA SUB,
BANK01.PRC_PROCEDIMIENTOS PRC,
BANK01.DD_ESU_ESTADO_SUBASTA ESU,
MINIREC.RCV_GEST_PDM_LITIGIO A
WHERE SUB.ASU_ID             = A.ID_ASUNTO_RCV
  AND PRC.PRC_ID             = SUB.PRC_ID
  AND TAR.ASU_ID             = SUB.ASU_ID  
  AND TAP.DD_TPO_ID          = PRC.DD_TPO_ID
  AND TAP.TAP_CODIGO IN ('P401_SolicitudSubasta', 'P409_SolicitudSubasta')    
  AND TEX.TAR_ID             = TAR.TAR_ID  
  AND TEX.TAP_ID             = TAP.TAP_ID
  AND TSU.DD_TSU_ID          = SUB.DD_TSU_ID 
  AND ESU.DD_ESU_ID          = SUB.DD_ESU_ID  
  AND SUB.PRC_ID         (+) = UMC.PRC_ID
  AND TAR_F_ENVIO.ASU_ID (+) =  A.ID_ASUNTO_RCV
  AND TAR_F_APROB.ASU_ID (+) =  A.ID_ASUNTO_RCV   ;
COMMIT;


-- MERGE APR

MERGE INTO 	MINIREC.RCV_GEST_PROPUESTA RCV
USING
(
select prc.asu_id, prc.prc_id,tev.tev_nombre, tev.tev_valor
    from BANK01.TEV_TAREA_EXTERNA_VALOR tev
    inner join BANK01.TEX_TAREA_EXTERNA tex on tex.TEX_ID = tev.TEX_ID
    inner join BANK01.TAR_TAREAS_NOTIFICACIONES tar on tar.tar_id = tex.tar_id
    inner join BANK01.TAP_TAREA_PROCEDIMIENTO tap on tap.tap_id = tex.tap_id
    inner join BANK01.PRC_PROCEDIMIENTOS prc on prc.prc_id = tar.prc_id
    where (UPPER(tap.TAP_CODIGO) LIKE 'P401%' OR UPPER(tap.TAP_CODIGO) LIKE 'P409%')
    and tev.tev_nombre = 'fechaSolicitud'
) TMP
    on (RCV.ID_PROPUESTA_RCV = TMP.PRC_ID)
    WHEN MATCHED THEN
    UPDATE SET RCV.FECHA_INICIO_SITUACION = TO_DATE(TMP.TEV_VALOR, 'YYYY-MM-DD')
    where TMP.TEV_NOMBRE = 'fechaSolicitud'
    and RCV.SITUACION_ACTUAL = 'APR';
    COMMIT;
    
-- MERGE FIN

MERGE INTO MINIREC.RCV_GEST_PROPUESTA RCV
USING
(
select prc.asu_id, prc.prc_id,tev.tev_nombre, tev.tev_valor
    from BANK01.TEV_TAREA_EXTERNA_VALOR tev
    inner join BANK01.TEX_TAREA_EXTERNA tex on tex.TEX_ID = tev.TEX_ID
    inner join BANK01.TAR_TAREAS_NOTIFICACIONES tar on tar.tar_id = tex.tar_id
    inner join BANK01.TAP_TAREA_PROCEDIMIENTO tap on tap.tap_id = tex.tap_id
    inner join BANK01.PRC_PROCEDIMIENTOS prc on prc.prc_id = tar.prc_id
    where (UPPER(tap.TAP_CODIGO) LIKE 'P401%' OR UPPER(tap.TAP_CODIGO) LIKE 'P409%')
    and tev.tev_nombre = 'fechaAnuncio'
) TMP
    on (RCV.ID_PROPUESTA_RCV = TMP.PRC_ID)
    WHEN MATCHED THEN
    UPDATE SET RCV.FECHA_INICIO_SITUACION = TO_DATE(TMP.TEV_VALOR, 'YYYY-MM-DD')
    where TMP.TEV_NOMBRE = 'fechaAnuncio'
    and RCV.SITUACION_ACTUAL = 'FIN';
    COMMIT;
    
-- MERGE ANU

MERGE INTO MINIREC.RCV_GEST_PROPUESTA RCV
USING
(
select prc.asu_id, prc.prc_id,tev.tev_nombre, tev.tev_valor
    from BANK01.TEV_TAREA_EXTERNA_VALOR tev
    inner join BANK01.TEX_TAREA_EXTERNA tex on tex.TEX_ID = tev.TEX_ID
    inner join BANK01.TAR_TAREAS_NOTIFICACIONES tar on tar.tar_id = tex.tar_id
    inner join BANK01.TAP_TAREA_PROCEDIMIENTO tap on tap.tap_id = tex.tap_id
    inner join BANK01.PRC_PROCEDIMIENTOS prc on prc.prc_id = tar.prc_id
    where (UPPER(tap.TAP_CODIGO) LIKE 'P401%' OR UPPER(tap.TAP_CODIGO) LIKE 'P409%')
    and tev.tev_nombre = 'fechaSuspension'
) TMP
    on (RCV.ID_PROPUESTA_RCV = TMP.PRC_ID)
    WHEN MATCHED THEN
    UPDATE SET RCV.FECHA_INICIO_SITUACION = TO_DATE(TMP.TEV_VALOR, 'YYYY-MM-DD')
    where TMP.TEV_NOMBRE = 'fechaSuspension'
    and RCV.SITUACION_ACTUAL = 'ANU';
    COMMIT;   

