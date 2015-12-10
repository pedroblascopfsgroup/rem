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

CREATE OR REPLACE PROCEDURE GEST_LOTE_RESOLUCION AUTHID CURRENT_USER AS

BEGIN
/* v0.1 */

	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_LOTE_RESOLUCION', 'INSERT EN MINIREC.RCV_GEST_LOTE_RESOLUCION', 'INICIO', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE('[INFO] La tabla MINIREC.RCV_GEST_LOTE_RESOLUCION va a ser truncada.');

	#ESQUEMA_MINIREC#.OPERACION_DDL.DDL_TABLE('TRUNCATE','RCV_GEST_LOTE_RESOLUCION');

COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla MINIREC.RCV_GEST_LOTE_RESOLUCION truncada.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a insertar registros en MINIREC.RCV_GEST_LOTE_RESOLUCION.');

INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOTE_RESOLUCION
	SELECT A.ID_ASUNTO_RCV
		 , A.ID_PROCEDI_RCV
		 , A.ID_PROCEDI
		 , A.ID_PROPUESTA_RCV
		 , LOS.LOS_NUM_LOTE                 		AS LOTE
		 , LOS.LOS_PUJA_POSTORES_HASTA      		AS PUJAR_HASTA
		 , SUM(ADJ.BIE_ADJ_IMPORTE_ADJUDICACION) 	AS IMPORTE_ADJ
	FROM #ESQUEMA_MINIREC#.RCV_GEST_PROPUESTA 		A
		 ,#ESQUEMA#.BIE_ADJ_ADJUDICACION 			ADJ
		 ,#ESQUEMA#.LOB_LOTE_BIEN        			LOB
		 ,#ESQUEMA#.LOS_LOTE_SUBASTA     			LOS
		 ,#ESQUEMA#.SUB_SUBASTA          			SUB
	WHERE A.ID_PROPUESTA_RCV = SUB.PRC_ID
		AND LOS.SUB_ID = SUB.SUB_ID 
		AND LOB.LOS_ID = LOS.LOS_ID 
		AND ADJ.BIE_ID = LOB.BIE_ID
	GROUP BY  A.ID_ASUNTO_RCV
		 , A.ID_PROCEDI_RCV
		 , A.ID_PROCEDI
		 , A.ID_PROPUESTA_RCV
		 , LOS.LOS_NUM_LOTE
		 , LOS.LOS_PUJA_POSTORES_HASTA;
     
COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertados en MINIREC.RCV_GEST_LOTE_RESOLUCION.');

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');
	
	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_LOTE_RESOLUCION', 'INSERT EN MINIREC.RCV_GEST_LOTE_RESOLUCION', 'FIN', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));


EXCEPTION
	
	WHEN OTHERS THEN
     
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(SQLERRM);

	ROLLBACK;
	RAISE;          

END GEST_LOTE_RESOLUCION;
/

EXIT;
