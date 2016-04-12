--/*
--##########################################
--## AUTOR=CARLOS PEREZ
--## FECHA_CREACION=20160407
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-2819
--## PRODUCTO=NO
--## Finalidad: Se modifica la vista incluyendo el importe pdte diferir!
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'V_LIS_PREPROYECT_CNT';    
    
BEGIN
	    
    EXECUTE IMMEDIATE '		
  CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA|| ' AS
			WITH
											NUM_TERMINOS_CNT AS (
			  									SELECT CNT.CNT_ID, COUNT(1) TERMINOS
			  									FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT
			    									INNER JOIN '||V_ESQUEMA||'.TEA_CNT ON TEA_CNT.CNT_ID = CNT.CNT_ID AND TEA_CNT.BORRADO = 0
			      										INNER JOIN '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA ON TEA.TEA_ID = TEA_CNT.TEA_ID AND TEA.BORRADO = 0
												WHERE CNT.BORRADO = 0
			  									GROUP BY CNT.CNT_ID
											)

											,REGULACION_CNT AS (
											  SELECT CNT.CNT_ID, MAX(ACU.ACU_FECHA_LIMITE) FECHA_REGU
											    FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT
											      INNER JOIN '||V_ESQUEMA||'.TEA_CNT ON TEA_CNT.CNT_ID = CNT.CNT_ID AND TEA_CNT.BORRADO = 0
											        INNER JOIN '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA ON TEA.TEA_ID = TEA_CNT.TEA_ID AND TEA.BORRADO = 0
											          INNER JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON ACU.ACU_ID = TEA.ACU_ID AND ACU.BORRADO = 0
											  WHERE CNT.BORRADO = 0
											  GROUP BY CNT.CNT_ID
											)

									      ,ULTIMO_TEA_CNT AS (
									        SELECT CNT_ID, TEA_ID FROM (
									                SELECT TEAC.CNT_ID, TEAC.TEA_ID,
									                ROW_NUMBER() OVER (PARTITION BY CNT_ID ORDER BY TEA_CNT_ID DESC) NPROP
									                FROM '||V_ESQUEMA||'.TEA_CNT TEAC
									                WHERE TEAC.BORRADO = 0
									        ) WHERE NPROP = 1
									      )

				                        ,TITULARES_CNT AS (
				                          SELECT PER_DOC_ID, UPPER(PER_NOMBRE || '' '' || PER_APELLIDO1 ||  '' '' || PER_APELLIDO2) PER_NOM_COMPLETO, CNT_ID 
				                            FROM '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE
				                              INNER JOIN '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1 AND TIN.BORRADO = 0
				                                INNER JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON PER.PER_ID = CPE.PER_ID AND PER.BORRADO = 0
				                          WHERE CPE.BORRADO = 0
				                        )
				                        
				                        ,CLIENTES_CNT AS (
				                          SELECT PER_DOC_ID, UPPER(PER_NOMBRE || '' '' || PER_APELLIDO1 ||  '' '' || PER_APELLIDO2) PER_NOM_COMPLETO, CNT_ID
				                          FROM '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE CCL
				                            INNER JOIN '||V_ESQUEMA||'.CLI_CLIENTES CLI ON CLI.BORRADO = 0 AND CCL.CLI_ID = CLI.CLI_ID
				                              INNER JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON PER.BORRADO = 0 AND CLI.PER_ID = PER.PER_ID
				                          WHERE CCL.BORRADO=0
				                        )

										SELECT DISTINCT CNT.CNT_ID
										  ,CNT.CNT_CONTRATO
										  ,CEX.EXP_ID
										  ,MOV.MOV_RIESGO RIESGO_TOTAL
										  ,MOV.MOV_DEUDA_IRREGULAR DEUDA_IRREGULAR
										  ,DDTDVCNT.DD_TDV_DESCRIPCION TRAMO
										  ,CASE WHEN TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA) < 0 THEN 0
                      						ELSE TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA)
                      					   END DIAS_VENCIDOS
										  ,CASE WHEN TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA) < 0
										    THEN NULL
										    ELSE TRUNC((SYSDATE+90) - TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA))
										  END FECHA_PASE_A_MORA_CNT
										  ,TPA.DD_TPA_DESCRIPCION PROPUESTA
										  ,EGT.DD_EGT_DESCRIPCION ESTADO_GESTION
										  ,REGUCNT.FECHA_REGU FECHA_PREV_REGU_CNT

										  ,EGT.DD_EGT_CODIGO ESTADO_GESTION_COD
										  ,DDTPE.DD_TPE_CODIGO TIPO_PERSONA_COD
										  ,DDTDVCNT.DD_TDV_CODIGO TRAMO_COD
										  ,TPAF.DD_TPA_CODIGO TIPO_PROPUESTA_COD
										  ,CASE WHEN NTC.TERMINOS IS NULL THEN 0 ELSE NTC.TERMINOS END N_PROPUESTAS
										  ,ZON.ZON_COD ZON_EXP
										  ,DDEST.DD_EST_CODIGO FASE_COD
										  ,ZONCNT.ZON_COD ZON_COD_CONTRATO
					                      ,TITULARES_CNT.PER_DOC_ID NIF_TITULAR
					                      ,TITULARES_CNT.PER_NOM_COMPLETO NOM_TITULAR                      
					                      ,CLIENTES_CNT.PER_DOC_ID NIF_CLIENTE
					                      ,CLIENTES_CNT.PER_NOM_COMPLETO NOM_CLIENTE
										  ,OFI.OFI_CODIGO OFI_CODIGO
											 --, (NVL(VEN.VEN_IMPORTE_INICIAL,0)/100) IMPORTE_INICIAL
						                      , (NVL(VEN.VEN_IMPORTE_PTE_DIFER,0)/100) IMPORTE_PTE_DIFER
						                     -- , (NVL(VEN.VEN_CAPITAL_VIVO,0)/100) CAPITAL_VIVO
										FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT
											LEFT JOIN  '||V_ESQUEMA_M||'.DD_ESC_ESTADO_CNT ESC ON ESC.BORRADO = 0 AND ESC.DD_ESC_ID = CNT.DD_ESC_ID
										  	LEFT JOIN (SELECT EXP_ID, CNT_ID FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE WHERE BORRADO = 0) CEX ON CEX.CNT_ID = CNT.CNT_ID
										    LEFT JOIN (SELECT EXP_ID, DD_TPX_ID, DD_EST_ID, OFI_ID FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES WHERE BORRADO=0) EXP ON EXP.EXP_ID = CEX.EXP_ID
											LEFT JOIN (SELECT DD_TPX_ID FROM '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE WHERE DD_TPX_CODIGO <> ''REC'') TPX ON TPX.DD_TPX_ID = EXP.DD_TPX_ID
										    LEFT JOIN (SELECT DD_EST_ID, DD_EST_CODIGO FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE BORRADO = 0) DDEST ON DDEST.DD_EST_ID = EXP.DD_EST_ID
										    LEFT JOIN (SELECT OFI_ID, OFI_CODIGO FROM '||V_ESQUEMA||'.OFI_OFICINAS WHERE BORRADO = 0) OFI ON OFI.OFI_ID = EXP.OFI_ID
										    LEFT JOIN (SELECT OFI_ID, ZON_COD FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE BORRADO = 0) ZON ON ZON.OFI_ID = OFI.OFI_ID
									    	LEFT JOIN '||V_ESQUEMA||'.V_LIS_PREPROYECT_MOV MOV ON MOV.CNT_ID = CNT.CNT_ID
										  	LEFT JOIN (SELECT DD_TDV_CODIGO, DD_TDV_DESCRIPCION, DD_TDV_DIA_INICIO, DD_TDV_DIA_FIN FROM '||V_ESQUEMA||'.DD_TDV_TRAMOS_DIAS_VENCIDOS) DDTDVCNT ON TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA) BETWEEN DDTDVCNT.DD_TDV_DIA_INICIO AND DDTDVCNT.DD_TDV_DIA_FIN
										  	LEFT JOIN REGULACION_CNT REGUCNT ON REGUCNT.CNT_ID = CNT.CNT_ID
										  	LEFT JOIN ULTIMO_TEA_CNT ULT_TEA ON ULT_TEA.CNT_ID = CNT.CNT_ID
										    LEFT JOIN (SELECT TEA_ID, DD_TPA_ID, DD_EGT_ID FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO WHERE BORRADO = 0) TEA ON TEA.TEA_ID = ULT_TEA.TEA_ID
										    LEFT JOIN (SELECT DD_TPA_ID, DD_TPA_DESCRIPCION FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE BORRADO = 0) TPA ON TPA.DD_TPA_ID = TEA.DD_TPA_ID
										    LEFT JOIN (SELECT DD_EGT_ID, DD_EGT_DESCRIPCION, DD_EGT_CODIGO FROM '||V_ESQUEMA_M||'.DD_EGT_EST_GEST_TERMINO WHERE BORRADO = 0 ) EGT ON EGT.DD_EGT_ID = TEA.DD_EGT_ID
										  	LEFT JOIN (SELECT TEA_ID, CNT_ID FROM '||V_ESQUEMA||'.TEA_CNT WHERE BORRADO = 0) TEA_CNT ON TEA_CNT.CNT_ID = CNT.CNT_ID
										    LEFT JOIN (SELECT TEA_ID, DD_TPA_ID FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO WHERE BORRADO = 0) TEAF ON TEAF.TEA_ID = TEA_CNT.TEA_ID
									    	LEFT JOIN (SELECT DD_TPA_ID, DD_TPA_CODIGO FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE BORRADO = 0) TPAF ON TPAF.DD_TPA_ID = TEAF.DD_TPA_ID
										  	LEFT JOIN NUM_TERMINOS_CNT NTC ON NTC.CNT_ID = CNT.CNT_ID
										  	LEFT JOIN (SELECT CNT_ID, PER_ID FROM '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS WHERE BORRADO = 0) CPE ON CPE.CNT_ID = CNT.CNT_ID
										  	LEFT JOIN (SELECT PER_ID, DD_TPE_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE BORRADO = 0) PER ON PER.PER_ID = CPE.PER_ID
										  	LEFT JOIN (SELECT DD_TPE_ID, DD_TPE_CODIGO FROM '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA WHERE BORRADO = 0) DDTPE ON DDTPE.DD_TPE_ID = PER.DD_TPE_ID
										  	LEFT JOIN (SELECT OFI_ID FROM '||V_ESQUEMA||'.OFI_OFICINAS WHERE BORRADO = 0) OFICNT ON OFICNT.OFI_ID = CNT.OFI_ID
									  	  	LEFT JOIN (SELECT ZON_COD, OFI_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE BORRADO = 0) ZONCNT ON ZONCNT.OFI_ID = OFICNT.OFI_ID
									      	LEFT JOIN TITULARES_CNT ON TITULARES_CNT.CNT_ID = CNT.CNT_ID
									      	LEFT JOIN CLIENTES_CNT ON CLIENTES_CNT.CNT_ID = CNT.CNT_ID
										  	LEFT JOIN VEN_VENCIDOS VEN ON VEN.CNT_ID = CNT.CNT_ID AND VEN.BORRADO = 0
  	 									WHERE CNT.BORRADO = 0 AND ESC.DD_ESC_CODIGO = ''0''';
			
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada');			    


EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;			
