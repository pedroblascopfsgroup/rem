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

CREATE OR REPLACE PROCEDURE GEST_CUENTA_PROP AUTHID CURRENT_USER AS

BEGIN
/* v0.1 */

	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_CUENTA_PROP', 'INSERT EN MINIREC.RCV_GEST_CUENTA_PROP', 'INICIO', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE('[INFO] La tabla MINIREC.RCV_GEST_CUENTA_PROP va a ser truncada.');

	#ESQUEMA_MINIREC#.OPERACION_DDL.DDL_TABLE('TRUNCATE','RCV_GEST_CUENTA_PROP');

COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla MINIREC.RCV_GEST_CUENTA_PROP truncada.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a insertar registros en MINIREC.RCV_GEST_CUENTA_PROP.');

INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_CUENTA_PROP
	SELECT DISTINCT
	  CNT.CNT_ID                       										ID_CUENTA_RCV 
	  ,DECODE(PAS.DD_PAS_CODIGO,'BANKIA','00000','SAREB','05074','00000') 	ENTIDAD
	  ,SUBSTR(CNT_CONTRATO,6,5)        										CLASE_P_P
	  ,SUBSTR(CNT.CNT_CONTRATO,11,17)  										NUM_CUENTA
	  ,CONCAT('00',SUBSTR(CNT.CNT_CONTRATO,28,15)) 							NUMERO_ESPEC
	  ,A.ID_PROPUESTA_RCV  
	  ,NULL                            										TIPO_RELACION
	FROM #ESQUEMA_MINIREC#.RCV_GEST_PROPUESTA 	A
		,#ESQUEMA#.EXT_IAC_INFO_ADD_CONTRATO 	EXT 
		,#ESQUEMA#.CNT_CONTRATOS             	CNT
		,#ESQUEMA#.CEX_CONTRATOS_EXPEDIENTE  	CNX
		,#ESQUEMA#.PRC_CEX                   	CEX
		,#ESQUEMA#.ASU_ASUNTOS               	ASU
		,#ESQUEMA#.DD_PAS_PROPIEDAD_ASUNTO   	PAS 
	WHERE A.ID_ASUNTO_RCV = ASU.ASU_ID
		AND ASU.DD_PAS_ID = PAS.DD_PAS_ID
		AND A.ID_PROPUESTA_RCV = CEX.PRC_ID
		AND CEX.CEX_ID = CNX.CEX_ID
		AND CNX.CNT_ID = CNT.CNT_ID
		AND EXT.CNT_ID      = CNT.CNT_ID
		AND EXT.DD_IFC_ID IN 
			(SELECT DD.DD_IFC_ID 
			FROM #ESQUEMA#.EXT_DD_IFC_INFO_CONTRATO DD 
			WHERE DD.DD_IFC_CODIGO = 'NUMERO_ESPEC');

COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertados en MINIREC.RCV_GEST_CUENTA_PROP.');

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');
	
	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_CUENTA_PROP', 'INSERT EN MINIREC.RCV_GEST_CUENTA_PROP', 'FIN', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));


EXCEPTION
	
	WHEN OTHERS THEN
     
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(SQLERRM);

	ROLLBACK;
	RAISE;          

END GEST_CUENTA_PROP;
/

EXIT;
