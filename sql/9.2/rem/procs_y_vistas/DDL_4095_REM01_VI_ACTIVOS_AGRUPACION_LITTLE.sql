--/*
--##########################################
--## AUTOR=rlb
--## FECHA_CREACION=20190711
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4642
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
SET DEFINE OFF;

DECLARE
    
    seq_count number(3); 						-- Vble. para validar la existencia de las Secuencias.
    table_count number(3); 						-- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); 					-- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); 				-- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; 							-- N?mero de errores
    err_msg VARCHAR2(2048); 					-- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 	-- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION_LIL...');
  V_MSQL := 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.V_ACTIVOS_AGRUPACION_LIL
	AS
		SELECT DISTINCT DECODE (AGRU.AGR_ACT_PRINCIPAL, ACT.ACT_ID, 1, 0) AS PRINCIPAL,
		AGR.AGA_FECHA_INCLUSION,
		ACT.ACT_ID,
		ACT.ACT_NUM_ACTIVO,
		ACT.ACT_NUM_ACTIVO_REM,
		TPA.DD_TPA_DESCRIPCION,
		SAC.DD_SAC_DESCRIPCION,
		AGR.AGR_ID,
		AGR.AGA_ID,
        AGR.AGA_PRINCIPAL AS ACTIVO_MATRIZ,
		AGR.BORRADO,
		AGR.ACT_AGA_ID_PRINEX_HPM AS ID_PRINEX_HPM,
        SCM.DD_SCM_DESCRIPCION AS SITUACION_COMERCIAL,
        SPS.SPS_OCUPADO,
		SPS.SPS_CON_TITULO,
		BIE.BIE_DREG_SUPERFICIE_CONSTRUIDA,
		LOC.BIE_LOC_PUERTA,
		TPA.DD_TPA_DESCRIPCION||'' - ''
        ||(SELECT DD_SAC_DESCRIPCION FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_ID = ACT.DD_SAC_ID)
        ||CASE WHEN TPA.DD_TPA_CODIGO = ''02'' AND NVL(VIV.VIV_NUM_PLANTAS_INTERIOR,0) = 1 THEN '' - 1 PLANTA'' 
               WHEN TPA.DD_TPA_CODIGO = ''02'' AND NVL(VIV.VIV_NUM_PLANTAS_INTERIOR,0) = 0 THEN '' - 0 PLANTAS''
               WHEN TPA.DD_TPA_CODIGO = ''02'' AND NVL(VIV.VIV_NUM_PLANTAS_INTERIOR,0) > 1 THEN '' - ''||NVL(VIV.VIV_NUM_PLANTAS_INTERIOR,0)||'' PLANTAS''
          END
        ||CASE WHEN TPA.DD_TPA_CODIGO = ''02'' AND NVL(DORMITORIOS.SUMA,0) = 1 THEN '' - 1 DORMITORIO'' 
               WHEN TPA.DD_TPA_CODIGO = ''02'' AND NVL(DORMITORIOS.SUMA,0) > 1 THEN '' - ''||DORMITORIOS.SUMA||'' DORMITORIOS''
          END
        ||CASE WHEN TPA.DD_TPA_CODIGO = ''02'' AND NVL(BANYO.SUMA,0) = 1 THEN '' - 1 BAÑO'' 
               WHEN TPA.DD_TPA_CODIGO = ''02'' AND NVL(BANYO.SUMA,0) > 1 THEN '' - ''||BANYO.SUMA||'' BAÑOS''
          END
        AS SDV_NOMBRE
		FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO 			AGR
		INNER JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION 			AGRU 	ON AGRU.AGR_ID = AGR.AGR_ID 		 AND AGRU.BORRADO = 0
    	INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO 					ACT  	ON ACT.ACT_ID = AGR.ACT_ID 			 AND ACT.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL          ICO     ON ACT.ACT_ID = ICO.ACT_ID           AND ICO.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_VIV_VIVIENDA                VIV     ON VIV.ICO_ID = ICO.ICO_ID 
    	INNER JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES 			BIE  	ON ACT.BIE_ID = BIE.BIE_ID 			 AND BIE.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION 				LOC  	ON ACT.BIE_ID = LOC.BIE_ID 			 AND LOC.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL         REG     ON ACT.ACT_ID = REG.ACT_ID           AND REG.BORRADO = 0
    	INNER JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO 			TPA  	ON TPA.DD_TPA_ID = ACT.DD_TPA_ID 	 AND TPA.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO 			SAC  	ON SAC.DD_SAC_ID = ACT.DD_SAC_ID 	 AND SAC.BORRADO = 0
    	INNER JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL 	SCM  	ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 	 AND SCM.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA 			SPS  	ON SPS.ACT_ID = ACT.ACT_ID 			 AND SPS.BORRADO = 0
 		LEFT JOIN (
            SELECT DISTINCT T2.ACT_ID, SUM(T4.DIS_CANTIDAD) OVER (PARTITION BY T2.ACT_ID,T5.DD_TPH_DESCRIPCION) AS SUMA
				FROM '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL 		T2 
				LEFT JOIN '|| V_ESQUEMA ||'.ACT_VIV_VIVIENDA 		T3 ON T3.ICO_ID = T2.ICO_ID	
				LEFT JOIN '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION 	T4 ON T4.ICO_ID = T2.ICO_ID AND T4.BORRADO = 0
				LEFT JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO 	T5 ON T5.DD_TPH_ID = T4.DD_TPH_ID AND T5.BORRADO = 0
            WHERE T5.DD_TPH_CODIGO IN (''01'') AND T2.BORRADO = 0
        ) DORMITORIOS ON (DORMITORIOS.ACT_ID = ACT.ACT_ID)
        LEFT JOIN (
            SELECT DISTINCT T2.ACT_ID, SUM(T4.DIS_CANTIDAD) OVER (PARTITION BY T2.ACT_ID,T5.DD_TPH_DESCRIPCION) AS SUMA 
            FROM  '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL 			T2 
				LEFT JOIN '|| V_ESQUEMA ||'.ACT_VIV_VIVIENDA 		T3 ON T3.ICO_ID = T2.ICO_ID 
				LEFT JOIN '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION 	T4 ON T4.ICO_ID = T2.ICO_ID AND T4.BORRADO = 0
				LEFT JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO 	T5 ON T5.DD_TPH_ID = T4.DD_TPH_ID AND T5.BORRADO = 0
            WHERE T5.DD_TPH_CODIGO IN (''02'') AND T2.BORRADO = 0
        ) BANYO ON (BANYO.ACT_ID = ACT.ACT_ID)
     
        LEFT JOIN REM01.DD_TAG_TIPO_AGRUPACION TAG ON AGRU.DD_TAG_ID = TAG.DD_TAG_ID
		WHERE AGR.BORRADO = 0 OR (AGR.BORRADO = 1 AND TAG.DD_TAG_CODIGO = ''16'')';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION_LIL...Creada OK');
  
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
