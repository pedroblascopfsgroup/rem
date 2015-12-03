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

CREATE OR REPLACE PROCEDURE GEST_BIEN_LITIGIO AUTHID CURRENT_USER AS

BEGIN
/* v0.1 */

	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_BIEN_LITIGIO', 'INSERT EN MINIREC.RCV_GEST_BIEN_LITIGIO', 'INICIO', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE('[INFO] La tabla MINIREC.RCV_GEST_BIEN_LITIGIO va a ser truncada.');

	#ESQUEMA_MINIREC#.OPERACION_DDL.DDL_TABLE('TRUNCATE','RCV_GEST_BIEN_LITIGIO');

COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla MINIREC.RCV_GEST_BIEN_LITIGIO truncada.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a insertar registros en MINIREC.RCV_GEST_BIEN_LITIGIO.');

INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_BIEN_LITIGIO
	SELECT DISTINCT BIE.BIE_CODIGO_EXTERNO                           AS ID_BIEN
		 , BIE.BIE_ID                                                AS ID_BIEN_RCV
		 , DECODE(TBI.DD_TBI_CODIGO
				 ,'01','INM'
				 ,'02','BMB'
				 ,'03','EFE'
				 ,'05','VAL')                                        AS TIPO_BIEN
		 , DECODE(DD_TPN_CODIGO,'00',NULL,SUBSTR(DD_TPN_CODIGO,1,2)) AS CLASE
		 , DECODE(DD_TPN_CODIGO,'00',NULL,SUBSTR(DD_TPN_CODIGO,3,2)) AS SUBCLASE 
		 , SUBSTR(REG.BIE_DREG_NUM_FINCA,1,9)                        AS NUM_FINCA
		 , LOC.BIE_LOC_COD_POST                                      AS COD_POSTAL
		 , LOC.BIE_LOC_POBLACION                                     AS LOCALIDAD_FINCA
		 , SUBSTR(REG.BIE_DREG_NUM_REGISTRO,1,3)                     AS NUM_REGISTRO
		 , REG.BIE_DREG_MUNICIPIO_LIBRO                              AS PLAZA_REGISTRO
		 , SUBSTR(BIE.BIE_REFERENCIA_CATASTRAL,1,20)                 AS REF_CATASTRAL
		 , BIE.BIE_DESCRIPCION                                       AS DESC_BIEN
		 , PRV.DD_PRV_DESCRIPCION                                    AS PROVINCIA
		 , DECODE(TPN.DD_TPN_CODIGO,'00',NULL,TPN.DD_TPN_CODIGO)     AS COTSIT    
		 , SUBSTR(LOC.BIE_LOC_DIRECCION,1,60)                        AS DIRECCION_IN
		 , NULL                                                      AS NUMERO_PISO
		 , NULL                                                      AS ESCALERA
		 , NULL                                                      AS PUERTA
		 , REG.BIE_DREG_TOMO                                         AS TOMO
		 , REG.BIE_DREG_FOLIO                                        AS FOLIO
		 , REG.BIE_DREG_LIBRO                                        AS LIBRO
	 FROM #ESQUEMA_MASTER#.DD_PRV_PROVINCIA   		PRV
		 , #ESQUEMA#.DD_TPN_TIPO_INMUEBLE         	TPN
		 , #ESQUEMA#.DD_TBI_TIPO_BIEN             	TBI
		 , #ESQUEMA#.BIE_LOCALIZACION             	LOC
		 , #ESQUEMA#.BIE_DATOS_REGISTRALES        	REG
		 , #ESQUEMA#.BIE_ADICIONAL                	ADI
		 , #ESQUEMA#.BIE_BIEN                     	BIE
		 , #ESQUEMA_MINIREC#.RCV_GEST_BIEN_PDM    	GUI	 
	 WHERE BIE.BIE_ID          = GUI.ID_BIEN_RCV
		 AND ADI.BIE_ID          = BIE.BIE_ID
		 AND REG.BIE_ID          = ADI.BIE_ID
		 AND LOC.BIE_ID          = REG.BIE_ID
		 AND TPN.DD_TPN_ID   (+) = ADI.DD_TPN_ID
		 AND TBI.DD_TBI_ID   (+) = BIE.DD_TBI_ID
		 AND PRV.DD_PRV_ID   (+) = LOC.DD_PRV_ID
		 AND TPN.USUARIOCREAR(+) = 'MIG';
   
COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertados en MINIREC.RCV_GEST_BIEN_LITIGIO.');

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');
	
	INSERT INTO #ESQUEMA_MINIREC#.RCV_GEST_LOG VALUES (#ESQUEMA_MINIREC#.S_RCV_GEST_LOG.NEXTVAL, 'RCV_GEST_BIEN_LITIGIO', 'INSERT EN MINIREC.RCV_GEST_BIEN_LITIGIO', 'FIN', TO_CHAR(SYSTIMESTAMP, 'DD/MM/RR HH24:MI:SS'));


EXCEPTION
	
	WHEN OTHERS THEN
     
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(SQLERRM);

	ROLLBACK;
	RAISE;          

END GEST_BIEN_LITIGIO;
/

EXIT;
