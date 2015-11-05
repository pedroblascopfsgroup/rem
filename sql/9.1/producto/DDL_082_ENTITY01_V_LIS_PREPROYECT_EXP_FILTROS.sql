--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=26-10-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-340
--## PRODUCTO=SI
--## Finalidad: DDL Creación vista para filtrado del listado de preproyectado
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
	
    -- Comprobamos si existe la vista   
    V_SQL := 'SELECT COUNT(1) FROM ALL_MVIEWS WHERE MVIEW_NAME = '''||V_NOMBRE_VISTA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    if V_NUM_TABLAS > 0 
     
     then          
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' Ya Existe');
          V_MSQL := 'DROP MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA;
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||'... Vista borrada');
    END IF;
        
    EXECUTE IMMEDIATE '
		CREATE MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA|| ' AS	
			WITH 
			N_PROPUESTAS AS (
			  SELECT /*+ MATERIALIZE */ EXP_ID, COUNT(1) NUMERO
			  FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU
			  WHERE ACU.BORRADO = 0
			  GROUP BY EXP_ID)
			  
			,MOVS_EXP AS (
			  SELECT /*+ MATERIALIZE */ CEX.EXP_ID, NVL(SUM(MOV.MOV_RIESGO),0) RIESGO, NVL(SUM(MOV.MOV_DEUDA_IRREGULAR),0) DEUDA_IRREGULAR
			  FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
			    INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID AND CNT.BORRADO = 0
			      INNER JOIN '||V_ESQUEMA||'.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION
			  WHERE CEX.BORRADO = 0
			  GROUP BY CEX.EXP_ID
			)  
			
			,CNT_MAS_VENCIDO_EXP AS (
			  SELECT /*+ MATERIALIZE */ EXP_ID
			    ,CASE WHEN TRUNC(SYSDATE-CNT_FECHA_VENC)  < 0 THEN 0 ELSE TRUNC(SYSDATE-CNT_FECHA_VENC) END DIAS_VENCIDOS
			    ,ROW_NUMBER() OVER (PARTITION BY EXP_ID ORDER BY (SYSDATE-CNT_FECHA_VENC) DESC) NUMERO
			  FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
			    INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID AND CNT.BORRADO = 0
			  WHERE CEX.BORRADO = 0
			)
			
			,REGULACION_CNT_EXP AS (
			  SELECT /*+ MATERIALIZE */ CNT.CNT_ID, MAX(ACU.ACU_FECHA_LIMITE) FECHA_REGU
			    FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT
			      INNER JOIN '||V_ESQUEMA||'.TEA_CNT ON TEA_CNT.CNT_ID = CNT.CNT_ID AND TEA_CNT.BORRADO = 0
			        INNER JOIN '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA ON TEA.TEA_ID = TEA_CNT.TEA_ID AND TEA.BORRADO = 0
			          INNER JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON ACU.ACU_ID = TEA.ACU_ID AND ACU.BORRADO = 0
			  WHERE CNT.BORRADO = 0
			  GROUP BY CNT.CNT_ID
			)
			  
			 SELECT DISTINCT EXP.EXP_ID, CNT.CNT_ID
			  ,EGT.DD_EGT_CODIGO ESTADO_GESTION_COD
			  ,DDTPE.DD_TPE_CODIGO TIPO_PERSONA_COD
			  ,MOVS_EXP.RIESGO RIESGO_TOTAL_EXP
			  ,MOVS_EXP.DEUDA_IRREGULAR DEUDA_IRREGULAR_EXP
			  ,DDTDV.DD_TDV_CODIGO TRAMO_EXP
			  ,TPA.DD_TPA_CODIGO TIPO_PROPUESTA_COD
			  ,CASE WHEN NP.NUMERO IS NULL THEN 0 ELSE NP.NUMERO END NUM_PROPUESTAS
			  ,ZON.ZON_COD
			  ,DDEST.DD_EST_CODIGO FASE_COD
			  ,CNT.CNT_CONTRATO NRO_CONTRATO  
			  ,REGUCNT.FECHA_REGU FECHA_PREV_REGU_CNT
			  ,ZONCNT.ZON_COD ZON_COD_CONTRATO
			FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP
			  LEFT JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.EXP_ID = EXP.EXP_ID AND CEX.BORRADO = 0
			    LEFT JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID AND CNT.BORRADO = 0
			      LEFT JOIN REGULACION_CNT_EXP REGUCNT ON REGUCNT.CNT_ID = CNT.CNT_ID        
			      LEFT JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION ZONCNT ON ZONCNT.ZON_ID = CNT.ZON_ID AND ZONCNT.BORRADO = 0
			  LEFT JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON ACU.EXP_ID = EXP.EXP_ID AND ACU.BORRADO = 0
			    LEFT JOIN '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA ON TEA.ACU_ID = ACU.ACU_ID AND TEA.BORRADO = 0
			      LEFT JOIN '||V_ESQUEMA_M||'.DD_EGT_EST_GEST_TERMINO EGT ON EGT.DD_EGT_ID = TEA.DD_EGT_ID AND EGT.BORRADO = 0
			      LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO TPA ON TPA.DD_TPA_ID = TEA.DD_TPA_ID AND TPA.BORRADO = 0
			  LEFT JOIN '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE PEX ON PEX.EXP_ID = EXP.EXP_ID AND PEX.BORRADO = 0
			    LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON PER.PER_ID = PEX.PER_ID AND PER.BORRADO = 0
			      LEFT JOIN '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA DDTPE ON DDTPE.DD_TPE_ID = PER.DD_TPE_ID AND DDTPE.BORRADO = 0
			  LEFT JOIN N_PROPUESTAS NP ON NP.EXP_ID = EXP.EXP_ID
			  LEFT JOIN '||V_ESQUEMA||'.OFI_OFICINAS OFI ON OFI.OFI_ID = EXP.OFI_ID AND OFI.BORRADO = 0
			    LEFT JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION ZON ON ZON.OFI_ID = OFI.OFI_ID AND OFI.BORRADO = 0
			  LEFT JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS DDEST ON DDEST.DD_EST_ID = EXP.DD_EST_ID AND DDEST.BORRADO = 0
			  LEFT JOIN MOVS_EXP ON MOVS_EXP.EXP_ID = EXP.EXP_ID
			  LEFT JOIN CNT_MAS_VENCIDO_EXP VENC_CNT ON VENC_CNT.EXP_ID = EXP.EXP_ID AND VENC_CNT.NUMERO = 1
			    LEFT JOIN '||V_ESQUEMA||'.DD_TDV_TRAMOS_DIAS_VENCIDOS DDTDV ON VENC_CNT.DIAS_VENCIDOS BETWEEN DDTDV.DD_TDV_DIA_INICIO AND DDTDV.DD_TDV_DIA_FIN  
			WHERE EXP.BORRADO = 0 ORDER BY EXP.EXP_ID, CNT.CNT_ID';
			    
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