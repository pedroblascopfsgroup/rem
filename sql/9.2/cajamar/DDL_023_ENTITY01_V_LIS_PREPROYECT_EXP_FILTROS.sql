--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160315
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2.1-cj
--## INCIDENCIA_LINK=CMREC-2748
--## PRODUCTO=NO
--## Finalidad: Se modifica la vista DATE_EXTRA1
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'V_LIS_PREPROYECT_EXP_FILTROS';    
    
BEGIN
	
    EXECUTE IMMEDIATE '
		CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA|| ' AS
  		WITH
			N_PROPUESTAS AS (
			  SELECT EXP_ID, COUNT(1) NUMERO
			  FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU
			  WHERE ACU.BORRADO = 0
			  GROUP BY EXP_ID)
        
      ,CEX_CONTRATOS_EXPEDIENTE_M AS (
        SELECT CEX.CNT_ID, CEX.EXP_ID, VEN.VEN_DATE_EXTRA1 FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
		LEFT JOIN '||V_ESQUEMA||'.VEN_VENCIDOS VEN ON CEX.CNT_ID = VEN.CNT_ID
        WHERE CEX.BORRADO = 0
      )

			,MOVS_EXP AS (
			  SELECT CEX.EXP_ID, NVL(SUM(MOV.MOV_RIESGO),0) RIESGO, NVL(SUM(MOV.MOV_DEUDA_IRREGULAR),0) DEUDA_IRREGULAR, MOV.MOV_FECHA_POS_VENCIDA FECHA_POS_VENCIDA
			  FROM CEX_CONTRATOS_EXPEDIENTE_M CEX
            INNER JOIN '||V_ESQUEMA||'.V_LIS_PREPROYECT_MOV MOV ON MOV.CNT_ID = CEX.CNT_ID AND MOV.MOV_DEUDA_IRREGULAR > 0
			  GROUP BY CEX.EXP_ID, MOV.MOV_FECHA_POS_VENCIDA
			)

			,CNT_MAS_VENCIDO_EXP AS (
        SELECT EXP_ID, DIAS_VENCIDOS FROM (
			  SELECT EXP_ID
			    ,CASE WHEN TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA)  < 0 THEN 0 ELSE TRUNC(SYSDATE-MOV.MOV_FECHA_POS_VENCIDA) END DIAS_VENCIDOS
			    ,ROW_NUMBER() OVER (PARTITION BY EXP_ID ORDER BY (SYSDATE-MOV.MOV_FECHA_POS_VENCIDA) DESC) NUMERO
			  FROM CEX_CONTRATOS_EXPEDIENTE_M CEX
            INNER JOIN '||V_ESQUEMA||'.V_LIS_PREPROYECT_MOV MOV ON MOV.CNT_ID = CEX.CNT_ID AND MOV.MOV_DEUDA_IRREGULAR > 0)
        WHERE NUMERO = 1
			)

			,REGULACION_CNT_EXP AS (
			  SELECT CNT.CNT_ID, MAX(ACU.ACU_FECHA_LIMITE) FECHA_REGU
			    FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT
			      INNER JOIN '||V_ESQUEMA||'.TEA_CNT ON TEA_CNT.CNT_ID = CNT.CNT_ID AND TEA_CNT.BORRADO = 0
			        INNER JOIN '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA ON TEA.TEA_ID = TEA_CNT.TEA_ID AND TEA.BORRADO = 0
			          INNER JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON ACU.ACU_ID = TEA.ACU_ID AND ACU.BORRADO = 0
			  WHERE CNT.BORRADO = 0
			  GROUP BY CNT.CNT_ID
			)

	      ,TITULARES_EXP AS (
	        SELECT PER.PER_DOC_ID, UPPER(PER.PER_NOMBRE || '' '' || PER.PER_APELLIDO1 || '' '' || PER.PER_APELLIDO2) PER_NOM_COMPLETO, CEX.EXP_ID
	          FROM CEX_CONTRATOS_EXPEDIENTE_M CEX
	              INNER JOIN (SELECT CNT_ID, PER_ID, DD_TIN_ID FROM '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS WHERE BORRADO = 0) CPE ON CPE.CNT_ID = CEX.CNT_ID
	                INNER JOIN (SELECT DD_TIN_ID FROM '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION WHERE BORRADO=0 AND DD_TIN_TITULAR = 1) TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID
	                  INNER JOIN (SELECT PER_ID, PER_DOC_ID, PER_NOMBRE, PER_APELLIDO1, PER_APELLIDO2 FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE BORRADO = 0) PER ON PER.PER_ID = CPE.PER_ID
	      )
	
	      ,CLIENTES_EXP AS (
	        SELECT PER.PER_DOC_ID, UPPER(PER_NOMBRE || '' '' || PER_APELLIDO1 || '' '' || PER_APELLIDO2) PER_NOM_COMPLETO, CEX.EXP_ID
	          FROM CEX_CONTRATOS_EXPEDIENTE_M CEX
	              INNER JOIN (SELECT CNT_ID, CLI_ID FROM '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE WHERE BORRADO = 0) CCL ON CCL.CNT_ID = CEX.CNT_ID
	                INNER JOIN (SELECT CLI_ID, PER_ID FROM '||V_ESQUEMA||'.CLI_CLIENTES WHERE BORRADO = 0) CLI ON CCL.CLI_ID = CLI.CLI_ID
                    INNER JOIN (SELECT PER_ID, PER_DOC_ID, PER_NOMBRE, PER_APELLIDO1, PER_APELLIDO2 FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE BORRADO = 0) PER ON PER.PER_ID = CLI.PER_ID
	      )

			 SELECT EXP.EXP_ID, CNT.CNT_ID
			  ,EGT.DD_EGT_CODIGO ESTADO_GESTION_COD
			  ,DDTPE.DD_TPE_CODIGO TIPO_PERSONA_COD
			  ,MOVS_EXP.RIESGO RIESGO_TOTAL_EXP
			  ,MOVS_EXP.DEUDA_IRREGULAR DEUDA_IRREGULAR_EXP
        	  ,VENC_CNT.DIAS_VENCIDOS
        	  ,CASE WHEN VENC_CNT.DIAS_VENCIDOS < 0
			  	THEN NULL
				ELSE TRUNC(MOVS_EXP.FECHA_POS_VENCIDA + 90)
			   END FECHA_PASE_A_MORA_EXP        
			  ,DDTDV.DD_TDV_CODIGO TRAMO_EXP
			  ,TPA.DD_TPA_CODIGO TIPO_PROPUESTA_COD
			  ,CASE WHEN NP.NUMERO IS NULL THEN 0 ELSE NP.NUMERO END NUM_PROPUESTAS
			  ,ZON.ZON_COD
			  ,DDEST.DD_EST_CODIGO FASE_COD
			  ,CNT.CNT_CONTRATO NRO_CONTRATO
			  ,REGUCNT.FECHA_REGU FECHA_PREV_REGU_CNT
			  ,ZONCNT.ZON_COD ZON_COD_CONTRATO
	          ,TITULARES_EXP.PER_DOC_ID NIF_TITULAR
              ,TITULARES_EXP.PER_NOM_COMPLETO NOM_TITULAR
	          ,CLIENTES_EXP.PER_DOC_ID NIF_CLIENTE
              ,CLIENTES_EXP.PER_NOM_COMPLETO NOM_CLIENTE
			FROM (SELECT EXP_ID, OFI_ID, DD_EST_ID, DD_TPX_ID FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES WHERE BORRADO = 0) EXP
			  LEFT JOIN (SELECT DD_TPX_ID FROM CM01.DD_TPX_TIPO_EXPEDIENTE WHERE DD_TPX_CODIGO <> ''REC'')  TPX ON TPX.DD_TPX_ID = EXP.DD_TPX_ID
			  LEFT JOIN CEX_CONTRATOS_EXPEDIENTE_M CEX ON CEX.EXP_ID = EXP.EXP_ID
			    LEFT JOIN (SELECT CNT_ID, CNT_CONTRATO, OFI_ID FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE BORRADO = 0) CNT ON CNT.CNT_ID = CEX.CNT_ID
			      LEFT JOIN REGULACION_CNT_EXP REGUCNT ON REGUCNT.CNT_ID = CNT.CNT_ID
        	  LEFT JOIN (SELECT OFI_ID FROM '||V_ESQUEMA||'.OFI_OFICINAS WHERE BORRADO = 0) OFICNT ON OFICNT.OFI_ID = CNT.OFI_ID
          	    LEFT JOIN (SELECT ZON_COD, OFI_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE BORRADO = 0) ZONCNT ON ZONCNT.OFI_ID = OFICNT.OFI_ID
			  LEFT JOIN (SELECT ACU_ID, EXP_ID FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS WHERE BORRADO = 0) ACU ON ACU.EXP_ID = EXP.EXP_ID
			    LEFT JOIN (SELECT ACU_ID, DD_EGT_ID, DD_TPA_ID FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO WHERE BORRADO = 0) TEA ON TEA.ACU_ID = ACU.ACU_ID
			      LEFT JOIN (SELECT DD_EGT_ID, DD_EGT_CODIGO FROM '||V_ESQUEMA_M||'.DD_EGT_EST_GEST_TERMINO WHERE BORRADO = 0) EGT ON EGT.DD_EGT_ID = TEA.DD_EGT_ID
			      LEFT JOIN (SELECT DD_TPA_ID, DD_TPA_CODIGO FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE BORRADO = 0) TPA ON TPA.DD_TPA_ID = TEA.DD_TPA_ID
			  LEFT JOIN (SELECT EXP_ID, PER_ID FROM '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE WHERE BORRADO = 0) PEX ON PEX.EXP_ID = EXP.EXP_ID
			    LEFT JOIN (SELECT PER_ID, DD_TPE_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE BORRADO = 0) PER ON PER.PER_ID = PEX.PER_ID
			      LEFT JOIN (SELECT DD_TPE_ID, DD_TPE_CODIGO FROM '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA WHERE BORRADO = 0) DDTPE ON DDTPE.DD_TPE_ID = PER.DD_TPE_ID
			  LEFT JOIN N_PROPUESTAS NP ON NP.EXP_ID = EXP.EXP_ID
			  LEFT JOIN (SELECT OFI_ID FROM '||V_ESQUEMA||'.OFI_OFICINAS WHERE BORRADO = 0) OFI ON OFI.OFI_ID = EXP.OFI_ID
			    LEFT JOIN (SELECT ZON_COD, OFI_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE BORRADO = 0) ZON ON ZON.OFI_ID = OFI.OFI_ID
			  LEFT JOIN (SELECT DD_EST_ID, DD_EST_CODIGO FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE BORRADO = 0) DDEST ON DDEST.DD_EST_ID = EXP.DD_EST_ID
			  LEFT JOIN MOVS_EXP ON MOVS_EXP.EXP_ID = EXP.EXP_ID
			  LEFT JOIN CNT_MAS_VENCIDO_EXP VENC_CNT ON VENC_CNT.EXP_ID = EXP.EXP_ID
			    LEFT JOIN (SELECT DD_TDV_CODIGO, DD_TDV_DIA_INICIO, DD_TDV_DIA_FIN FROM '||V_ESQUEMA||'.DD_TDV_TRAMOS_DIAS_VENCIDOS) DDTDV ON VENC_CNT.DIAS_VENCIDOS BETWEEN DDTDV.DD_TDV_DIA_INICIO AND DDTDV.DD_TDV_DIA_FIN
      		  LEFT JOIN TITULARES_EXP ON TITULARES_EXP.EXP_ID = EXP.EXP_ID
      		  LEFT JOIN CLIENTES_EXP ON CLIENTES_EXP.EXP_ID = EXP.EXP_ID
			WHERE MOVS_EXP.DEUDA_IRREGULAR > 0';
			
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
