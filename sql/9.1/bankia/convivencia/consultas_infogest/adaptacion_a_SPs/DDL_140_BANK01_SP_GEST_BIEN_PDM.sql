--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20151101
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1335
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        	0.1 Versión inicial
--##		
--#########################################
--*/
 
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE GEST_BIEN_PDM AUTHID CURRENT_USER AS

BEGIN
/* v0.1 */

	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_BIEN_PDM', 'INSERT EN MINIREC.RCV_GEST_BIEN_PDM', 'INICIO', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE('[INFO] La tabla MINIREC.RCV_GEST_BIEN_PDM va a ser truncada.');

	#ESQUEMA_MINIREC#.OPERACION_DDL.DDL_TABLE('TRUNCATE','RCV_GEST_BIEN_PDM');

COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla MINIREC.RCV_GEST_BIEN_PDM truncada.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a insertar registros en MINIREC.RCV_GEST_BIEN_PDM.');

INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_BIEN_PDM
	WITH ULTIMA_TAREA AS 
		(SELECT /*+ MATERIALIZE */ PRC_ID, ASU_ID, DD_TPO_ID, BIE_ID, TAP_CODIGO, TAP_DESCRIPCION, TAR_FECHA_FIN, COD_HITO_NAL
		 FROM 
			(SELECT DISTINCT PRC.PRC_ID, PRC.DD_TPO_ID , TAR.ASU_ID , PRB2.BIE_ID, TAR.TAR_ID
				, tap.tap_codigo, tap.tap_descripcion, tar.tar_fecha_fin
				, trd.cod_hito_nal
				, ROW_NUMBER() OVER (PARTITION BY TAR.asu_id, PRB2.BIE_ID ORDER BY PRB2.BIE_ID, TAR.TAR_ID DESC) ORDEN
			FROM #ESQUEMA#.PRB_PRC_BIE                 PRB2
				,#ESQUEMA#.PRC_PROCEDIMIENTOS          PRC
				,#ESQUEMA#.TAR_TAREAS_NOTIFICACIONES   TAR
				,#ESQUEMA#.TEX_TAREA_EXTERNA           TEX
				,#ESQUEMA#.TAP_TAREA_PROCEDIMIENTO     TAP
				,#ESQUEMA#.AUX_THR_TRADUC_HITOS_RECNAL TRD
				,#ESQUEMA#.DD_TPO_TIPO_PROCEDIMIENTO   TPO
			WHERE PRC.ASU_ID = TAR.ASU_ID
				AND PRC.PRC_ID = PRB2.PRC_ID
				AND TRD.DD_TPO_CODIGO in ('P401','P409','P413','P416','P417','P418','P419','P09')
				AND TRD.DD_TPO_CODIGO = TPO.DD_TPO_CODIGO
				AND PRC.DD_TPO_ID = TAP.DD_TPO_ID
				AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
				AND TAP.TAP_CODIGO = TRD.TAP_CODIGO
				AND TAR.TAR_ID = TEX.TAR_ID
				AND TEX.TAP_ID = TAP.TAP_ID
				AND NOT (TAR.BORRADO=0 AND NVL(TAR.TAR_TAREA_FINALIZADA,0)=0)
			) 
		WHERE ORDEN = 1
		),
		PRIMERA_VALORACION AS 
		(SELECT /*+ MATERIALIZE */ BIE_ID,BIE_IMPORTE_VALOR_TASACION,BIE_FECHA_VALOR_TASACION
		FROM 
			(SELECT /*+ MATERIALIZE */ BIEVAL.BIE_ID, BIEVAL.BIE_IMPORTE_VALOR_TASACION, BIEVAL.BIE_FECHA_VALOR_TASACION
					 , ROW_NUMBER() OVER (PARTITION BY BIE_ID ORDER BY BIE_FECHA_VALOR_SUBJETIVO ASC) VALORACION_NUM
			FROM #ESQUEMA#.BIE_VALORACIONES BIEVAL
			) 
		WHERE VALORACION_NUM = 1
		),
		ULTIMA_VALORACION AS 
		(SELECT /*+ MATERIALIZE */ BIE_ID,BIE_IMPORTE_VALOR_TASACION,BIE_FECHA_VALOR_TASACION
		FROM 
			(SELECT /*+ MATERIALIZE */ BIEVAL.BIE_ID, BIEVAL.BIE_IMPORTE_VALOR_TASACION, BIEVAL.BIE_FECHA_VALOR_TASACION
					 , ROW_NUMBER() OVER (PARTITION BY BIE_ID ORDER BY BIE_FECHA_VALOR_SUBJETIVO DESC) VALORACION_NUM
			FROM #ESQUEMA#.BIE_VALORACIONES BIEVAL
			) 
		WHERE VALORACION_NUM = 1
		),
		FECHAS_ACTA_SUBASTA AS
		(SELECT A.PRC_ID, TO_DATE(D.TEV_VALOR,'YYYY-MM-DD') AS FECHA_REGISTRO_ACTA
		FROM #ESQUEMA#.PRC_PROCEDIMIENTOS 			A
			,#ESQUEMA#.TAR_TAREAS_NOTIFICACIONES 	B
			,#ESQUEMA#.TEX_TAREA_EXTERNA 			C
			,#ESQUEMA#.TEV_TAREA_EXTERNA_VALOR 		D
			,#ESQUEMA#.TAP_TAREA_PROCEDIMIENTO 		E
		WHERE A.PRC_ID = B.PRC_ID
			AND B.TAR_ID = C.TAR_ID
			AND C.TEX_ID = D.TEX_ID
			AND C.TAP_ID = E.TAP_ID
			AND E.DD_TPO_ID = A.DD_TPO_ID
			AND E.TAP_CODIGO IN ('P401_RegistrarActaSubasta','P409_RegistrarActaSubasta') 
			AND D.TEV_NOMBRE = ('fecha')
		)
		SELECT DISTINCT 
			 GUI.ID_PROCEDI                                       ID_PROCEDI
		   , GUI.ID_ASUNTO_RCV                                    ID_ASUNTO_RCV
		   , GUI.ID_PROCEDI_RCV                                   ID_PROCEDI_RCV
		   , BIE.BIE_ID                                           ID_BIEN_RCV
		   , BIE.BIE_CODIGO_EXTERNO                               ID_BIEN
		   , MAX(TRUNC(SUB.SUB_FECHA_SENYALAMIENTO))              FEC_SE_SUBASTA
		   , NVL(MAX(BIE.BIE_TIPO_SUBASTA),0)                     VALOR_JUDICIAL
		   , DECODE(MAX(DD_ESU.DD_ESU_CODIGO),'CEL','S','N')      SUBASTA_CELEBRADA
		   , TRUNC(MAX(SUB.SUB_FECHA_SENYALAMIENTO))              FEC_CELB_SUBASTA
		   , MAX(DECODE(ADJ.BIE_ADJ_CESION_REMATE,1,'1',NULL, NULL, DECODE(UPPER(EAD.DD_EAD_DESCRIPCION),'ENTIDAD','1','2')))  		ID_RESULTADO_SUBASTA_RCV
		   , MAX(DECODE(ADJ.BIE_ADJ_CESION_REMATE,1,'CESION',NULL,NULL,UPPER(EAD.DD_EAD_DESCRIPCION)))   							RESULTADO_SUBASTA_RCV  
		   , MAX(DECODE(ADJ.BIE_ADJ_CESION_REMATE,1,'CES',NULL,NULL,DECODE(UPPER(EAD.DD_EAD_DESCRIPCION),'ENTIDAD','ADJ','TER'))) 	RESULTADO_SUBASTA
		   , MAX(ADJ.BIE_ADJ_IMPORTE_ADJUDICACION)                IMPORTE_SUBASTA
		   , MAX(DD_MOTCANCEL.DD_MCS_CODIGO)                      ID_MOTIVO_SUBASTA_RCV
		   , CASE 
				WHEN MAX(DD_MOTCANCEL.DD_MCS_CODIGO) IS NULL
				  THEN NULL
				  ELSE DECODE(MAX(DD_MOTCANCEL.DD_MCS_CODIGO)
							 ,'ACU','REG','EAC','SUS'
							 ,'CAN')
			 END                                                  MOTIVO_SUBASTA_RCV
		   , MAX(DD_MOTCANCEL.DD_MCS_DESCRIPCION)                 MOTIVO_SUBASTA
		   , MAX(FACTS.FECHA_REGISTRO_ACTA)                       FEC_RECEPCION_ACTA
		   , MAX(ADJ.BIE_ADJ_F_DECRETO_N_FIRME)                   FEC_AUTO_ADJ_NO
		   , MAX(ADJ.BIE_ADJ_F_DECRETO_FIRME)                     FEC_AUTO_ADJ
		   , MAX(ULT_TAR.TAP_CODIGO)                              ID_ULT_TAR_REALIZADA_RCV
		   , MAX(ULT_TAR.TAP_DESCRIPCION)                         ULT_TAR_REALIZADA_RCV
		   , MAX(ULT_TAR.COD_HITO_NAL)                            HITO_MAS_AVANZADO
		   , MAX(trunc(ULT_TAR.TAR_FECHA_FIN))                    F_HITO_MAS_AVANZADO
		   , MAX(BIE.BIE_NUMERO_ACTIVO)                           NUMERO_ACTIVO
		   , MAX(LOS.LOS_NUM_LOTE)                                LOTE
		   , MAX(PRIBIEVAL.BIE_IMPORTE_VALOR_TASACION)            TASACION_ACTIVOS_INI
		   , MAX(PRIBIEVAL.BIE_FECHA_VALOR_TASACION)              FECHA_RECEP_INI_TASACION
		   , MAX(PRIBIEVAL.BIE_FECHA_VALOR_TASACION)              FECHA_REALIZ_INI_TASACION
		   , MAX(PRIBIEVAL.BIE_FECHA_VALOR_TASACION)              FECHA_PETIC_INI_TASACION
		   , MAX(ULTBIEVAL.BIE_IMPORTE_VALOR_TASACION)            TASACION_ACTIVOS_ULT
		   , MAX(ULTBIEVAL.BIE_FECHA_VALOR_TASACION)              FECHA_RECEP_ULT_TASACION
		   , MAX(ULTBIEVAL.BIE_FECHA_VALOR_TASACION)              FECHA_REALIZ_ULT_TASACION
		   , MAX(ULTBIEVAL.BIE_FECHA_VALOR_TASACION)              FECHA_PETIC_ULT_TASACION
		   , MAX(ADJ.BIE_ADJ_F_INSCRIP_TITULO)                    FEC_INSCR_TITULO
		   , MAX(ADJ.BIE_ADJ_F_REA_POSESION)                      FEC_REALI_POSES
		   , MAX(ADJ.BIE_ADJ_F_REA_LANZAMIENTO)                   FEC_REALI_LANZA
		   , MAX(ADJ.BIE_ADJ_F_ENVIO_LLAVES)                      FEC_RECEP_LLAVES
		   , MAX(ADJ.BIE_ADJ_F_RECEP_DEPOSITARIO_F)               FECHA_CESION_FONDO
		   , CASE MAX(BIE_ADJ_CESION_REMATE) 
			   WHEN 1 THEN 'S'
			   ELSE 'N' END                                       TRATADA_CESION
		   , NULL                                                 TRATADO_TESTIMONIO
		   , NULL                                                 TRATADA_INSCRIPCION
		   , NULL                                                 TRATADA_POSESION
		FROM #ESQUEMA_MINIREC#.RCV_GEST_PDM_LITIGIO 	GUI
		   , #ESQUEMA#.PRB_PRC_BIE 						PRB
		   , #ESQUEMA#.PRC_PROCEDIMIENTOS 				PRC
		   , #ESQUEMA#.BIE_BIEN 						BIE 
		   , #ESQUEMA#.BIE_ADJ_ADJUDICACION 			ADJ 
		   , #ESQUEMA#.DD_EAD_ENTIDAD_ADJUDICA 			EAD 
		   , PRIMERA_VALORACION 						PRIBIEVAL 
		   , ULTIMA_VALORACION 							ULTBIEVAL 
		   , #ESQUEMA#.LOB_LOTE_BIEN 					LOB 
		   , #ESQUEMA#.LOS_LOTE_SUBASTA 				LOS
		   , #ESQUEMA#.SUB_SUBASTA 						SUB 
		   , #ESQUEMA#.DD_ESU_ESTADO_SUBASTA 			DD_ESU
		   , #ESQUEMA#.DD_MCS_MOT_CANCEL_SUBASTA 		DD_MOTCANCEL
		   , ULTIMA_TAREA 								ULT_TAR
		   , FECHAS_ACTA_SUBASTA 						FACTS
		WHERE GUI.ID_ASUNTO_RCV = PRC.ASU_ID
			AND PRC.PRC_ID = PRB.PRC_ID
			AND PRB.BIE_ID = BIE.BIE_ID
			AND PRC.ASU_ID = ULT_TAR.ASU_ID (+)
			AND BIE.BIE_ID = ADJ.BIE_ID(+)
			AND ADJ.DD_EAD_ID = EAD.DD_EAD_ID(+)
			AND BIE.BIE_ID = PRIBIEVAL.BIE_ID(+)
			AND BIE.BIE_ID = ULTBIEVAL.BIE_ID(+)
			AND BIE.BIE_ID = LOB.BIE_ID(+)
			AND LOB.LOS_ID = LOS.LOS_ID(+)
			AND GUI.ID_ASUNTO_RCV = SUB.ASU_ID(+)
			AND SUB.DD_ESU_ID = DD_ESU.DD_ESU_ID(+)
			AND SUB.DD_MCS_ID = DD_MOTCANCEL.DD_MCS_ID(+)
			AND PRC.PRC_ID = FACTS.PRC_ID (+)
		GROUP BY
			 GUI.ID_PROCEDI
		   , GUI.ID_ASUNTO_RCV
		   , GUI.ID_PROCEDI_RCV
		   , BIE.BIE_ID
		   , BIE.BIE_CODIGO_EXTERNO;
   
COMMIT;

	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_BIEN_PDM', 'INSERT EN MINIREC.RCV_GEST_BIEN_PDM', 'FIN', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertados en MINIREC.RCV_GEST_BIEN_PDM.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se va a actualizar MINIREC.RCV_GEST_BIEN_PDM.SUBASTA_CELEBRADA');
	
	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_BIEN_PDM', 'MERGE EN MINIREC.RCV_GEST_BIEN_PDM.SUBASTA_CELEBRADA', 'INICIO', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

MERGE INTO MINIREC.RCV_GEST_BIEN_PDM A
USING (
WITH ULTIMA_TAREA AS 
(
SELECT /*+ MATERIALIZE */ PRC_ID, ASU_ID, DD_TPO_ID, BIE_ID, TAP_CODIGO, TAP_DESCRIPCION, TAR_FECHA_FIN, COD_HITO_NAL
   FROM (SELECT DISTINCT PRC.PRC_ID, PRC.DD_TPO_ID , TAR.ASU_ID , PRB2.BIE_ID, TAR.TAR_ID
             , TAP.TAP_CODIGO, TAP.TAP_DESCRIPCION, TAR.TAR_FECHA_FIN
             , TRD.COD_HITO_NAL
             , ROW_NUMBER() OVER (PARTITION BY TAR.ASU_ID, PRB2.BIE_ID ORDER BY PRB2.BIE_ID, TAR.TAR_ID DESC) ORDEN
          FROM BANK01.PRB_PRC_BIE                 PRB2
             , BANK01.PRC_PROCEDIMIENTOS          PRC
             , BANK01.TAR_TAREAS_NOTIFICACIONES   TAR
             , BANK01.TEX_TAREA_EXTERNA           TEX
             , BANK01.TAP_TAREA_PROCEDIMIENTO     TAP
             , BANK01.AUX_THR_TRADUC_HITOS_RECNAL TRD
             , BANK01.DD_TPO_TIPO_PROCEDIMIENTO   TPO
         WHERE PRC.ASU_ID = TAR.ASU_ID
           AND PRC.PRC_ID = PRB2.PRC_ID
           AND TRD.DD_TPO_CODIGO IN ('P401','P409','P413','P416','P417','P418','P419','P09')
           AND TRD.DD_TPO_CODIGO = TPO.DD_TPO_CODIGO
           AND PRC.DD_TPO_ID = TAP.DD_TPO_ID
           AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
           AND TAP.TAP_CODIGO = TRD.TAP_CODIGO
           AND TAR.TAR_ID = TEX.TAR_ID
           AND TEX.TAP_ID = TAP.TAP_ID
           AND NOT (TAR.BORRADO=0 AND NVL(TAR.TAR_TAREA_FINALIZADA,0)=0)
       ) WHERE ORDEN = 1
),

FECHAS_ACTA_SUBASTA AS
(
SELECT A.PRC_ID, TO_DATE(D.TEV_VALOR,'YYYY-MM-DD') AS FECHA_REGISTRO_ACTA
FROM BANK01.PRC_PROCEDIMIENTOS A, BANK01.TAR_TAREAS_NOTIFICACIONES B, BANK01.TEX_TAREA_EXTERNA C, BANK01.TEV_TAREA_EXTERNA_VALOR D,
     BANK01.TAP_TAREA_PROCEDIMIENTO E
WHERE A.PRC_ID = B.PRC_ID
AND B.TAR_ID = C.TAR_ID
AND C.TEX_ID = D.TEX_ID
AND C.TAP_ID = E.TAP_ID
AND E.DD_TPO_ID = A.DD_TPO_ID
AND E.TAP_CODIGO IN ('P401_REGISTRARACTASUBASTA','P409_REGISTRARACTASUBASTA') 
AND D.TEV_NOMBRE = ('FECHA')
)
SELECT DISTINCT DECODE(ESU.DD_ESU_CODIGO,'CEL','S','N')      AS SUBASTA_CELEBRADA, SUB.PRC_ID, SUB.ASU_ID, LOB.BIE_ID,TAP_DESCRIPCION, TAR_FECHA_FIN, COD_HITO_NAL, (FECH.FECHA_REGISTRO_ACTA)                       AS FEC_RECEPCION_ACTA
FROM BANK01.SUB_SUBASTA SUB 
INNER JOIN BANK01.DD_ESU_ESTADO_SUBASTA ESU ON SUB.DD_ESU_ID = ESU.DD_ESU_ID
INNER JOIN BANK01.LOS_LOTE_SUBASTA LOS ON SUB.SUB_ID = LOS.SUB_ID
INNER JOIN BANK01.LOB_LOTE_BIEN LOB ON LOS.LOS_ID = LOB.LOS_ID
INNER JOIN MINIREC.RCV_GEST_BIEN_PDM RCV ON LOB.BIE_ID=RCV.ID_BIEN_RCV
INNER JOIN ULTIMA_TAREA TAREA ON TAREA.PRC_ID=SUB.PRC_ID
INNER JOIN FECHAS_ACTA_SUBASTA FECH ON TAREA.PRC_ID = FECH.PRC_ID
WHERE  (LOB.BIE_ID,FECH.FECHA_REGISTRO_ACTA) IN (SELECT LOB.BIE_ID,FECH.FECHA_REGISTRO_ACTA FROM BANK01.SUB_SUBASTA SUB 
INNER JOIN BANK01.DD_ESU_ESTADO_SUBASTA ESU ON SUB.DD_ESU_ID = ESU.DD_ESU_ID
INNER JOIN BANK01.LOS_LOTE_SUBASTA LOS ON SUB.SUB_ID = LOS.SUB_ID
INNER JOIN BANK01.LOB_LOTE_BIEN LOB ON LOS.LOS_ID = LOB.LOS_ID
INNER JOIN MINIREC.RCV_GEST_BIEN_PDM RCV ON LOB.BIE_ID=RCV.ID_BIEN_RCV
INNER JOIN ULTIMA_TAREA TAREA ON TAREA.PRC_ID=SUB.PRC_ID
INNER JOIN FECHAS_ACTA_SUBASTA FECH ON TAREA.PRC_ID = FECH.PRC_ID GROUP BY LOB.BIE_ID,FECH.FECHA_REGISTRO_ACTA HAVING COUNT(*)=1)) B
ON ( A.ID_ASUNTO_RCV=B.ASU_ID AND A.ID_BIEN_RCV=B.BIE_ID) 
WHEN MATCHED THEN UPDATE SET A.SUBASTA_CELEBRADA=B.SUBASTA_CELEBRADA;

COMMIT;

	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_BIEN_PDM', 'MERGE EN MINIREC.RCV_GEST_BIEN_PDM.SUBASTA_CELEBRADA', 'FIN', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en MINIREC.RCV_GEST_BIEN_PDM.SUBASTA_CELEBRADA');

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');


EXCEPTION
	
	WHEN OTHERS THEN
     
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(SQLERRM);

	ROLLBACK;
	RAISE;          

END GEST_BIEN_PDM;
/

EXIT;
