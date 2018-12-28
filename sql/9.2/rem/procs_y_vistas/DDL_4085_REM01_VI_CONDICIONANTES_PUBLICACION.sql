--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2629
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    
    err_num NUMBER; 							-- N?mero de errores
    err_msg VARCHAR2(2048); 					-- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 	-- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_COND_PUBLICACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_COND_PUBLICACION...');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_COND_PUBLICACION';  
		DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_COND_PUBLICACION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_COND_PUBLICACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_PUBLICACION...');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_COND_PUBLICACION';  
		DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_PUBLICACION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_COND_PUBLICACION...');
  V_MSQL := 'CREATE OR REPLACE VIEW '|| V_ESQUEMA ||'.V_COND_PUBLICACION AS
    	WITH INFORME_APROBADO AS (
	    SELECT ACT_ID
	    FROM (
		SELECT HIC.ACT_ID, ROW_NUMBER() OVER (PARTITION BY HIC.ACT_ID ORDER BY HIC.HIC_FECHA DESC) REF
		FROM '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST HIC
		INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = HIC.ACT_ID AND ICO.BORRADO = 0
		INNER JOIN '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL DDAIC ON DDAIC.DD_AIC_ID = HIC.DD_AIC_ID
		WHERE HIC.BORRADO = 0 AND DDAIC.DD_AIC_CODIGO = ''02''
		)
	    WHERE REF = 1
	    )
	, PRECIO_APROBADO AS (
	    SELECT VAL.ACT_ID, TPC.DD_TPC_CODIGO
	    FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
	    INNER JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO IN (''02'', ''03'')
	    WHERE VAL.BORRADO = 0 AND NVL(VAL.VAL_IMPORTE, 0) > 0 
		AND NVL(VAL.VAL_FECHA_INICIO,TO_DATE(''01/01/1900'',''DD/MM/YYYY'')) <= SYSDATE
		AND NVL(VAL.VAL_FECHA_FIN,SYSDATE) >= SYSDATE
	    )
	SELECT DISTINCT ACT.ACT_ID, 
	    CASE 
		WHEN TCO.DD_TCO_CODIGO = ''01'' OR TCO.DD_TCO_CODIGO = ''02''
		THEN
		    CASE 
		        WHEN ACT.ACT_ADMISION = 1 AND ACT.ACT_GESTION = 1 AND NVL2(INF.ACT_ID, 0, 1) = 0 
		            AND (NVL(PRC.DD_TPC_CODIGO, ''00'') = ''02'' OR APU.APU_CHECK_PUB_SIN_PRECIO_V = 1) 
		        THEN 1
		        WHEN ACT.ACT_ADMISION = 0 AND ACT.ACT_GESTION = 0 AND NVL2(INF.ACT_ID, 0, 1) = 1 
		            AND (PRC.DD_TPC_CODIGO IS NULL AND APU.APU_CHECK_PUB_SIN_PRECIO_V = 0) 
		        THEN 0
		        ELSE 2
		    END
	    END AS COND_PUBL_VENTA,
	    CASE 
		WHEN TCO.DD_TCO_CODIGO = ''02'' OR TCO.DD_TCO_CODIGO = ''03''
		THEN
		    CASE 
		        WHEN TPA.DD_TPA_CODIGO = ''02'' 
		        THEN
		            CASE 
		                WHEN ACT.ACT_ADMISION = 1 AND ACT.ACT_GESTION = 1 AND NVL2(INF.ACT_ID, 0, 1) = 0 
		                    AND (NVL(ADA.DD_ADA_CODIGO, ''00'') = ''01'' OR NVL(ADA.DD_ADA_CODIGO, ''00'') = ''03'')
		                    AND TPD.DD_TPD_CODIGO = ''11'' 
		                    AND (NVL(PRC.DD_TPC_CODIGO, ''00'') = ''03'' OR APU.APU_CHECK_PUB_SIN_PRECIO_A = 1)
		                THEN 1
		                WHEN ACT.ACT_ADMISION = 0 AND ACT.ACT_GESTION = 0 AND NVL2(INF.ACT_ID, 0, 1) = 1 
		                    AND (NVL(ADA.DD_ADA_CODIGO, ''00'') <> ''01'' AND NVL(ADA.DD_ADA_CODIGO, ''00'') <> ''03'')
		                    AND TPD.DD_TPD_CODIGO <> ''11'' 
		                    AND (NVL(PRC.DD_TPC_CODIGO, ''00'') = ''03'' OR APU.APU_CHECK_PUB_SIN_PRECIO_A = 0)
		                THEN 0
		                ELSE 2
		            END
		        ELSE
		            CASE 
		                WHEN ACT.ACT_ADMISION = 1 AND ACT.ACT_GESTION = 1 AND NVL2(INF.ACT_ID, 0, 1) = 0 
		                    AND (NVL(ADA.DD_ADA_CODIGO, ''00'') = ''01'' OR NVL(ADA.DD_ADA_CODIGO, ''00'') = ''03'')
		                    AND (NVL(PRC.DD_TPC_CODIGO, ''00'') = ''03'' OR APU.APU_CHECK_PUB_SIN_PRECIO_A = 1)
		                THEN 1
		                WHEN ACT.ACT_ADMISION = 0 AND ACT.ACT_GESTION = 0 AND NVL2(INF.ACT_ID, 0, 1) = 1 
		                    AND (NVL(ADA.DD_ADA_CODIGO, ''00'') <> ''01'' AND NVL(ADA.DD_ADA_CODIGO, ''00'') <> ''03'')
		                    AND (NVL(PRC.DD_TPC_CODIGO, ''00'') = ''03'' OR APU.APU_CHECK_PUB_SIN_PRECIO_A = 0)
		                THEN 0
		                ELSE 2
		            END
		    END
	    END AS COND_PUBL_ALQUILER
	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION 	APU ON APU.ACT_ID = ACT.ACT_ID       AND APU.BORRADO = 0
	INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.BORRADO = 0       
	INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO           TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
	LEFT JOIN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO    ADO ON ACT.ACT_ID = ADO.ACT_ID       AND ADO.BORRADO = 0
	LEFT JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO      CFD ON CFD.CFD_ID = ADO.CFD_ID       AND CFD.BORRADO = 0
	LEFT JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO         TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0
	LEFT JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO     PTA ON PTA.ACT_ID = ACT.ACT_ID       AND PTA.BORRADO = 0
	LEFT JOIN '||V_ESQUEMA||'.DD_ADA_ADECUACION_ALQUILER    ADA ON PTA.DD_ADA_ID = ADA.DD_ADA_ID AND ADA.BORRADO = 0
	LEFT JOIN PRECIO_APROBADO                               PRC ON PRC.ACT_ID = ACT.ACT_ID
	LEFT JOIN INFORME_APROBADO                              INF ON INF.ACT_ID = ACT.ACT_ID';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_PUBLICACION...Creada OK');
  
END;
/
EXIT;

