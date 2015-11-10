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

CREATE OR REPLACE PROCEDURE GEST_BIEN_CUENTA AS

BEGIN
/* v0.1 */

	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_BIEN_CUENTA', 'INSERT EN MINIREC.RCV_GEST_BIEN_CUENTA', 'INICIO', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE('[INFO] La tabla MINIREC.RCV_GEST_BIEN_CUENTA va a ser truncada.');

	#ESQUEMA_MINIREC#.OPERACION_DDL.DDL_TABLE('TRUNCATE','RCV_GEST_BIEN_CUENTA');

COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla MINIREC.RCV_GEST_BIEN_CUENTA truncada.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a insertar registros en MINIREC.RCV_GEST_BIEN_CUENTA.');

INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_BIEN_CUENTA
	SELECT DISTINCT A.ID_BIEN            AS ID_BIEN
		 , A.ID_BIEN_RCV                 AS ID_BIEN_RCV
		 , B.CNT_ID                      AS ID_CUENTA_RCV
		 , SUBSTR(D.CNT_CONTRATO,1,5)    AS ENTIDAD
		 , SUBSTR(D.CNT_CONTRATO,6,5)    AS CLASE_P_P 
		 , SUBSTR(D.CNT_CONTRATO,11,17)  AS NUM_CUENTA 
		 , SUBSTR(D.CNT_CONTRATO,28,15)  AS NUMERO_ESPEC
		 , NULL                          AS REL_BIEN_CTA
		 , C.BIE_IMPORTE_VALOR_TASACION  AS TASACION_INI
	  FROM #ESQUEMA_MINIREC#.RCV_GEST_BIEN_PDM A
		 , #ESQUEMA#.BIE_CNT                   B
		 , #ESQUEMA#.BIE_VALORACIONES          C
		 , #ESQUEMA#.CNT_CONTRATOS             D
	WHERE A.ID_BIEN_RCV = B.BIE_ID
		AND A.ID_BIEN_RCV = C.BIE_ID
		AND B.CNT_ID = D.CNT_ID;
   
COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertados en MINIREC.RCV_GEST_BIEN_CUENTA.');

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');
	
	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_BIEN_CUENTA', 'INSERT EN MINIREC.RCV_GEST_BIEN_CUENTA', 'FIN', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));


EXCEPTION
	
	WHEN OTHERS THEN
     
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(SQLERRM);

	ROLLBACK;
	RAISE;          

END GEST_BIEN_CUENTA;
/

EXIT;
