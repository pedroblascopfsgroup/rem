DELETE FROM MINIREC.RCV_GEST_PERSONA_PDM;
commit;

INSERT INTO MINIREC.RCV_GEST_PERSONA_PDM
WITH 
ULTIMO_TAREA_PRP AS 
( SELECT /*+ MATERIALIZE */ PRC_id, DD_TPO_ID, tap_codigo, tap_descripcion, tar_fecha_fin, cod_hito_nal
       , ROW_NUMBER() OVER (PARTITION BY asu_id ORDER BY TAR_ID DESC) ORDEN
  FROM (SELECT DISTINCT PRC.PRC_ID, PRC.DD_TPO_ID , TAR.ASU_ID , TAR.TAR_ID
             , tap.tap_codigo, tap.tap_descripcion, tar.tar_fecha_fin
             , trd.cod_hito_nal
          FROM BANK01.PRC_PROCEDIMIENTOS          PRC
             , BANK01.TAR_TAREAS_NOTIFICACIONES   TAR
             , BANK01.TEX_TAREA_EXTERNA           TEX
             , BANK01.TAP_TAREA_PROCEDIMIENTO     TAP
             , BANK01.AUX_THR_TRADUC_HITOS_RECNAL TRD
             , BANK01.DD_TPO_TIPO_PROCEDIMIENTO TPO
         WHERE PRC.ASU_ID = TAR.ASU_ID
           AND PRC.DD_TPO_ID = TAP.DD_TPO_ID
           AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
           AND TAP.TAP_CODIGO = TRD.TAP_CODIGO
           AND TRD.DD_TPO_CODIGO = TPO.DD_TPO_CODIGO
		   AND SUBSTR(TRD.COD_HITO_NAL,1,1) = 'A'
           AND TAR.TAR_ID = TEX.TAR_ID
           AND TEX.TAP_ID = TAP.TAP_ID
           AND TAR.BORRADO <> 0
       UNION
       SELECT DISTINCT PRC.PRC_ID, PRC.DD_TPO_ID , TAR.ASU_ID , TAR.TAR_ID
             , tap.tap_codigo, tap.tap_descripcion, tar.tar_fecha_fin
             , trd.cod_hito_nal
          FROM BANK01.PRC_PROCEDIMIENTOS          PRC
             , BANK01.TAR_TAREAS_NOTIFICACIONES   TAR
             , BANK01.TEX_TAREA_EXTERNA           TEX
             , BANK01.TAP_TAREA_PROCEDIMIENTO     TAP
             , BANK01.AUX_THR_TRADUC_HITOS_RECNAL TRD
             , BANK01.DD_TPO_TIPO_PROCEDIMIENTO TPO
         WHERE PRC.ASU_ID = TAR.ASU_ID
           AND PRC.DD_TPO_ID = TAP.DD_TPO_ID
           AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
           AND TAP.TAP_CODIGO = TRD.TAP_CODIGO
           AND TRD.DD_TPO_CODIGO = TPO.DD_TPO_CODIGO
           AND TAR.TAR_ID = TEX.TAR_ID
           AND TEX.TAP_ID = TAP.TAP_ID
           AND (TAR.BORRADO=0 AND TAR.TAR_TAREA_FINALIZADA=0)
       )
),
FECHAS AS(
	SELECT B.PRC_ID
		 , MAX( CASE WHEN E.TAP_CODIGO = 'P22_AutoDeclarandoConcurso'
						 AND D.TEV_NOMBRE = 'fecha'
						 THEN TO_DATE(D.TEV_VALOR,'YYYY-MM-DD') 
						ELSE NULL END)           AS FECHA_AUTO_DECLARACION
		 , MAX( CASE WHEN E.TAP_CODIGO = 'P17_RegistrarResolucion'
						 AND D.TEV_NOMBRE = 'fechaResolucion'
						 THEN TO_DATE(D.TEV_VALOR,'YYYY-MM-DD') 
						ELSE NULL END)           AS FECHA_RESOLUCION
	FROM BANK01.PRC_PROCEDIMIENTOS A, BANK01.TAR_TAREAS_NOTIFICACIONES B, BANK01.TEX_TAREA_EXTERNA C, BANK01.TEV_TAREA_EXTERNA_VALOR D, BANK01.TAP_TAREA_PROCEDIMIENTO E
	WHERE A.PRC_ID = B.PRC_ID
	AND B.TAR_ID = C.TAR_ID
	AND C.TEX_ID = D.TEX_ID
	AND C.TAP_ID = E.TAP_ID
	AND E.DD_TPO_ID = A.DD_TPO_ID
	AND E.TAP_CODIGO(+) in ('P22_AutoDeclarandoConcurso','P17_RegistrarResolucion')
	AND D.TEV_NOMBRE(+) in ('fechaResolucion','fecha')
	GROUP BY B.PRC_ID
),
PERSONAS_TITULARES AS (
	select per_id, cpe_orden, relacion_pdm
	from (
		select per.per_id, cpe.CPE_ORDEN, 'TIT' RELACION_PDM,
			row_number () over(partition by per.per_id order by cpe.CPE_ORDEN asc) rn_orden
		from BANK01.PER_PERSONAS per
		inner join BANK01.CPE_CONTRATOS_PERSONAS cpe on per.PER_ID = cpe.PER_ID
		inner join BANK01.DD_TIN_TIPO_INTERVENCION tin on tin.DD_TIN_ID = cpe.DD_TIN_ID
		where tin.DD_TIN_TITULAR = 1)
	where rn_orden = 1
),
PERSONAS_AVALISTAS AS (
	select per_id, cpe_orden, relacion_pdm
	from (
		select per.per_id, cpe.CPE_ORDEN, 'FIA' RELACION_PDM,
			row_number () over(partition by per.per_id order by cpe.CPE_ORDEN asc) rn_orden
		from BANK01.PER_PERSONAS per
		inner join BANK01.CPE_CONTRATOS_PERSONAS cpe on per.PER_ID = cpe.PER_ID
		inner join BANK01.DD_TIN_TIPO_INTERVENCION tin on tin.DD_TIN_ID = cpe.DD_TIN_ID
		where tin.DD_TIN_AVALISTA = 1 and tin.DD_TIN_TITULAR = 0)
	where rn_orden = 1
),
PERSONAS_OTROS AS (
	select per_id, cpe_orden, relacion_pdm
	from (
		select per.per_id, cpe.CPE_ORDEN, 'OTR' RELACION_PDM,
			row_number () over(partition by per.per_id order by cpe.CPE_ORDEN asc) rn_orden
		from BANK01.PER_PERSONAS per
		inner join BANK01.CPE_CONTRATOS_PERSONAS cpe on per.PER_ID = cpe.PER_ID
		inner join BANK01.DD_TIN_TIPO_INTERVENCION tin on tin.DD_TIN_ID = cpe.DD_TIN_ID
		where tin.DD_TIN_AVALISTA = 0 and tin.DD_TIN_TITULAR = 0)
	where rn_orden = 1
)
SELECT DISTINCT
       GUI.ID_PROCEDI                        as ID_PROCEDI
     , GUI.ID_PROCEDI_RCV
     , PER.PER_ID                            as ID_PERSONA_RCV
     , TO_CHAR(PER.PER_COD_CLIENTE_ENTIDAD)  as NUMERO_PERSONA
     , COALESCE(PERSONAS_TITULARES.CPE_ORDEN,PERSONAS_AVALISTAS.CPE_ORDEN,PERSONAS_OTROS.CPE_ORDEN) as ORDEN_PER_PDM
     , COALESCE(PERSONAS_TITULARES.RELACION_PDM,PERSONAS_AVALISTAS.RELACION_PDM,PERSONAS_OTROS.RELACION_PDM) as REL_PER_PDM
     , ULT.COD_HITO_NAL                      as HITO_MAS_AVANZADO
     , ULT.TAR_FECHA_FIN                     as F_HITO_MAS_AVANZADO
     , ULT.TAP_CODIGO                        as ID_ULT_TAR_REALIZADA_RCV
     , ULT.TAP_DESCRIPCION                   as ULT_TAR_REALIZADA_RCV
     , FECHAS.FECHA_AUTO_DECLARACION
     , FECHAS.FECHA_RESOLUCION
  FROM MINIREC.RCV_GEST_PDM_LITIGIO       GUI 
     , BANK01.PRC_PROCEDIMIENTOS          PRC
     , BANK01.PRC_PER                     PRP
     , BANK01.PER_PERSONAS                PER
     , ULTIMO_TAREA_PRP                   ULT
     , FECHAS
	 , PERSONAS_TITULARES
	 , PERSONAS_AVALISTAS
	 , PERSONAS_OTROS
 WHERE GUI.ID_ASUNTO_RCV = PRC.ASU_ID
  AND PRC.PRC_ID = ULT.PRC_ID AND ULT.ORDEN = 1
   AND PRC.DD_TPO_ID = ULT.DD_TPO_ID
   AND PRC.PRC_ID = PRP.PRC_ID (+)
   AND PRP.PER_ID = PER.PER_ID (+)
   AND PRC.PRC_ID = FECHAS.PRC_ID (+)
   AND PER.PER_ID = PERSONAS_TITULARES.PER_ID (+)
   AND PER.PER_ID = PERSONAS_AVALISTAS.PER_ID (+)
   AND PER.PER_ID = PERSONAS_OTROS.PER_ID (+);
COMMIT;

