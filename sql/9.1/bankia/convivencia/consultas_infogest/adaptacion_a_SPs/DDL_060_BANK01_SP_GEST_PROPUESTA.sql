--/*
--##########################################
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
--##########################################
--*/
 
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE GEST_PROPUESTA AUTHID CURRENT_USER AS

BEGIN
/* v0.1 */
	
	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_PROPUESTA', 'INSERT EN MINIREC.RCV_GEST_PROPUESTA', 'INICIO', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE('[INFO] La tabla MINIREC.RCV_GEST_PROPUESTA va a ser truncada.');

	#ESQUEMA_MINIREC#.OPERACION_DDL.DDL_TABLE('TRUNCATE','RCV_GEST_PROPUESTA');

COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla MINIREC.RCV_GEST_PROPUESTA truncada.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a insertar registros en MINIREC.RCV_GEST_PROPUESTA.');

INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_PROPUESTA
	WITH 
	ULT_MOVIMIENTO_CNT AS 
		(SELECT CNT_ID, DEUDA, PRC_ID, EXP_ID, CD_EXPEDIENTE_NUSE, CODIGO_PROCEDIMIENTO_NUSE
		FROM 
			(SELECT /*+ MATERIALIZE */ TMP_DEUDA.CNT_ID, TMP_DEUDA.DEUDA, PRCCEX.PRC_ID, EX.EXP_ID, EX.CD_EXPEDIENTE_NUSE,
					EX.CODIGO_PROCEDIMIENTO_NUSE, ROW_NUMBER() OVER (PARTITION BY PRCCEX.PRC_ID ORDER BY TMP_DEUDA.DEUDA DESC) CNT_MAYOR
			FROM 
				(SELECT /*+ MATERIALIZE */ CNT_ID, (MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA + MOV_INT_MORATORIOS + MOV_GASTOS + MOV_COMISIONES + MOV_IMPUESTOS) DEUDA
				FROM (
				  SELECT MOV.CNT_ID
					,ROW_NUMBER () OVER (PARTITION BY mov.cnt_id ORDER BY mov.mov_fecha_extraccion DESC) RN
					,MOV.MOV_POS_VIVA_NO_VENCIDA 
					,MOV.MOV_POS_VIVA_VENCIDA 
					,MOV.MOV_INT_REMUNERATORIOS 
					,MOV.MOV_INT_MORATORIOS 
					,MOV.MOV_GASTOS 
					,MOV.MOV_COMISIONES 
					,MOV.MOV_IMPUESTOS
					FROM #ESQUEMA#.MOV_MOVIMIENTOS MOV) TMP_MOV
					WHERE rn = 1
				) TMP_DEUDA
			INNER JOIN #ESQUEMA#.CEX_CONTRATOS_EXPEDIENTE 	CEX 
				ON CEX.CNT_ID = TMP_DEUDA.CNT_ID
			INNER JOIN #ESQUEMA#.EXP_EXPEDIENTES 			EX 
				ON EX.EXP_ID = CEX.EXP_ID
			INNER JOIN #ESQUEMA#.PRC_CEX PRCCEX 
				ON PRCCEX.CEX_ID = CEX.CEX_ID
			) TMP_CNT_MAYOR
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
	 ,null FECHA_ALTA_CIERRE	
	 ,NULL PREDOMINANTE 
	 ,'INTERVENCIÓN EN SUBASTA NLEC' FINALIDAD
	 ,DECODE(ESU.DD_ESU_CODIGO,'PIN','ELA','PPR','ELA', 'SUS','ANU','CAN','ANU','PAC','APR','PCE','APR','CEL','FIN',NULL) SITUACION_ACTUAL
	 ,UMC.DEUDA    IMPORTE_PROPUESTA 
	 ,TRUNC(SUB.SUB_FECHA_SOLICITUD) FECHA_PROPUESTA
	 ,TAR_F_ENVIO.TEV_VALOR FECHA_ENVIO
	 ,DECODE(TSU.DD_TSU_CODIGO,'DEL',TAR_F_ENVIO.TEV_VALOR,'NDE',TAR_F_APROB.TEV_VALOR) FECHA_ACEPTACION
	 ,DECODE(TSU.DD_TSU_CODIGO,'DEL',TAR_F_ENVIO.TEV_VALOR,'NDE',TAR_F_APROB.TEV_VALOR) FECHA_APROBACION
	FROM 
		(SELECT DISTINCT TAR.ASU_ID,tev.tev_nombre, TO_DATE(tev.tev_valor,'YYYY-MM-DD') AS TEV_VALOR
		 FROM #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES TAR
			, #ESQUEMA#.TEX_TAREA_EXTERNA         TEX
			, #ESQUEMA#.TAP_TAREA_PROCEDIMIENTO   TAP
			, #ESQUEMA#.TEV_TAREA_EXTERNA_VALOR   TEV
		WHERE TAR.TAR_ID = TEX.TAR_ID
		  AND TEX.TAP_ID = TAP.TAP_ID
		  AND TEX.TEX_ID = TEV.TEX_ID
		  AND TAP.TAP_CODIGO IN ('P409_PrepararPropuestaSubasta','P401_PrepararPropuestaSubasta')
		  AND TRIM(TEV.TEV_NOMBRE) = 'fechaPropuesta'
		) TAR_F_ENVIO,
		(SELECT DISTINCT TAR.ASU_ID, TEV.TEV_NOMBRE, TO_DATE(TEV.TEV_VALOR,'YYYY-MM-DD') AS TEV_VALOR
		 FROM #ESQUEMA#.tar_tareas_notificaciones TAR
			, #ESQUEMA#.tex_tarea_externa         TEX
			, #ESQUEMA#.tap_tarea_procedimiento   TAP
			, #ESQUEMA#.tev_tarea_externa_valor   TEV
		WHERE TAR.TAR_ID = TEX.TAR_ID
		  AND TEX.TAP_ID = TAP.TAP_ID
		  AND TEX.TEX_ID = TEV.TEX_ID
		  AND TAP.TAP_CODIGO IN ('P401_ValidarPropuesta','P409_ValidarPropuesta')
		  AND TRIM(TEV.TEV_NOMBRE) = 'fechaDecision'
		) TAR_F_APROB,
	#ESQUEMA#.DD_TSU_TIPO_SUBASTA 			TSU
	,#ESQUEMA#.ULT_MOVIMIENTO_CNT 			UMC
	,#ESQUEMA#.TEX_TAREA_EXTERNA 			TEX
	,#ESQUEMA#.TAP_TAREA_PROCEDIMIENTO 		TAP
	,#ESQUEMA#.TAR_TAREAS_NOTIFICACIONES 	TAR
	,#ESQUEMA#.SUB_SUBASTA 					SUB
	,#ESQUEMA#.PRC_PROCEDIMIENTOS 			PRC
	,#ESQUEMA#.DD_ESU_ESTADO_SUBASTA 		ESU
	,#ESQUEMA_MINIREC#.RCV_GEST_PDM_LITIGIO A
	WHERE SUB.ASU_ID             = A.ID_ASUNTO_RCV
	  AND PRC.PRC_ID             = SUB.PRC_ID
	  AND TAR.ASU_ID             = SUB.ASU_ID  
	  AND TAP.DD_TPO_ID          = PRC.DD_TPO_ID
	  AND TAP.TAP_CODIGO 		IN ('P401_SolicitudSubasta', 'P409_SolicitudSubasta')    
	  AND TEX.TAR_ID             = TAR.TAR_ID  
	  AND TEX.TAP_ID             = TAP.TAP_ID
	  AND TSU.DD_TSU_ID          = SUB.DD_TSU_ID 
	  AND ESU.DD_ESU_ID          = SUB.DD_ESU_ID  
	  AND SUB.PRC_ID         (+) = UMC.PRC_ID
	  AND TAR_F_ENVIO.ASU_ID (+) =  A.ID_ASUNTO_RCV
	  AND TAR_F_APROB.ASU_ID (+) =  A.ID_ASUNTO_RCV;
  
COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertados en MINIREC.RCV_GEST_PROPUESTA.');

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');
	
	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_PROPUESTA', 'INSERT EN MINIREC.RCV_GEST_PROPUESTA', 'FIN', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));


EXCEPTION
	
	WHEN OTHERS THEN
     
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(SQLERRM);

	ROLLBACK;
	RAISE;          

END GEST_PROPUESTA;
/

EXIT;
