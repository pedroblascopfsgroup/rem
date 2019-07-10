--/*
--##########################################
--## AUTOR=rlb
--## FECHA_CREACION=20190710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4642
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Direccion separada por espacios
--##		0.3 HECTOR GOMEZ - (20181018) - HREOS-4633
--##		0.4 Marco Munoz - HREOS-4756
--##		0.5 Se modifica la vista para mejorar el rendimiento
--##		0.6 Se modifica la vista para que tenga en cuenta el borrado lógico de las distribuciones
--##		0.7 Se añaden las nuevas columnas de publicaciones
--##		0.8 Se realiza un Join con la vista V_COND_PUBLICACION para sacar los campos COND_PUBL_VENTA, COND_PUBL_ALQUILER (HREOS-4907)
--##        0.9 Se cambia la query de GENCAT para actualizarla a los nuevos requerimientos
--##        0.10 Cambiamos la vista para que calcule desde la vista gencat.
--##	    0.11 Se añade una columna más para calcular el estado del titulo
--##        0.12 Se añade una condición para mostrar las UAs borradas. HREOS-6767
--##		0.13 Se añade la columna de precio renta - REMVIP-4642
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVOS_AGRUPACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION...');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_ACTIVOS_AGRUPACION';  
		DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVOS_AGRUPACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION...');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ACTIVOS_AGRUPACION';  
		DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION...');
  V_MSQL := 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_ACTIVOS_AGRUPACION
	AS
		SELECT DISTINCT DECODE (AGRU.AGR_ACT_PRINCIPAL, ACT.ACT_ID, 1, 0) AS PRINCIPAL,
     	(TVI.DD_TVI_DESCRIPCION || '' '' || LOC.BIE_LOC_NOMBRE_VIA || '' '' || LOC.BIE_LOC_NUMERO_DOMICILIO || '' '' || LOC.BIE_LOC_PUERTA) AS DIRECCION,
		LOC.BIE_LOC_PUERTA,
		BIE.BIE_DREG_NUM_FINCA,
        0 AS NUMEROPROPIETARIOS,
		NULL AS PROPIETARIO,
		AGR.AGA_FECHA_INCLUSION,
		ACT.ACT_ID,
		ACT.ACT_NUM_ACTIVO,
		ACT.ACT_NUM_ACTIVO_REM,
		TPA.DD_TPA_DESCRIPCION,
		SAC.DD_SAC_DESCRIPCION,
		AGR.AGR_ID,
		AGR.AGA_ID,
        BIE.BIE_DREG_SUPERFICIE_CONSTRUIDA,
	 	REG.REG_SUPERFICIE_UTIL,
        REG.REG_SUPERFICIE_ELEM_COMUN,
        REG.REG_SUPERFICIE_PARCELA,
		(SELECT MAX (VAL2.VAL_IMPORTE) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 WHERE VAL2.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN (''03'') AND BORRADO = 0) AND (VAL2.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL2.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY'')) AND VAL2.ACT_ID = ACT.ACT_ID AND VAL2.BORRADO = 0) AS VAL_IMPORTE_APROBADO_RENTA,
		(SELECT MAX (VAL2.VAL_IMPORTE) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 WHERE VAL2.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN (''02'') AND BORRADO = 0) AND (VAL2.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL2.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY'')) AND VAL2.ACT_ID = ACT.ACT_ID AND VAL2.BORRADO = 0) AS VAL_IMPORTE_APROBADO_VENTA,
        (SELECT MAX (VAL2.VAL_IMPORTE) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 WHERE VAL2.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN (''04'') AND BORRADO = 0) AND (VAL2.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL2.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY'')) AND VAL2.ACT_ID = ACT.ACT_ID AND VAL2.BORRADO = 0) AS VAL_IMPORTE_MINIMO_AUTORIZADO,
        (SELECT MAX (VAL2.VAL_IMPORTE) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 WHERE VAL2.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN (''01'') AND BORRADO = 0) AND (VAL2.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL2.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY'')) AND VAL2.ACT_ID = ACT.ACT_ID AND VAL2.BORRADO = 0) AS VAL_NETO_CONTABLE,
        AGR.AGA_PRINCIPAL AS ACTIVO_MATRIZ,
		AGR.BORRADO,
		AGR.ACT_AGA_ID_PRINEX_HPM AS ID_PRINEX_HPM,
        SCM.DD_SCM_DESCRIPCION AS SITUACION_COMERCIAL,
        SPS.SPS_OCUPADO,
		SPS.SPS_CON_TITULO,
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
        AS SDV_NOMBRE,
        DECODE(TCO.DD_TCO_CODIGO ,''03'',EPA.DD_EPA_DESCRIPCION,''01'',EPV.DD_EPV_DESCRIPCION,''02'',EPA.DD_EPA_DESCRIPCION||''/''||EPV.DD_EPV_DESCRIPCION) AS PUBLICADO,
		(SELECT MAX (VAL2.VAL_IMPORTE) FROM
			(SELECT VAL5.ACT_ID, VAL5.VAL_IMPORTE, VAL5.VAL_FECHA_INICIO, MAX(VAL5.VAL_FECHA_INICIO) OVER(PARTITION BY VAL5.ACT_ID) AS FECHA_MAX
				 FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL5 INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC5 ON VAL5.DD_TPC_ID = TPC5.DD_TPC_ID AND TPC5.DD_TPC_CODIGO = ''13'' AND TPC5.BORRADO = 0
					WHERE (VAL5.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL5.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY''))
						AND TO_DATE(VAL5.VAL_FECHA_INICIO,''DD/MM/YYYY'') <= TO_DATE(sysdate,''DD/MM/YYYY'') AND VAL5.BORRADO = 0) VAL2
			WHERE VAL2.VAL_FECHA_INICIO = VAL2.FECHA_MAX AND VAL2.ACT_ID = ACT.ACT_ID) AS VAL_IMPORTE_DESCUENTO_PUBLICO,
        NULL AS GENCAT,
        V_PUBL.COND_PUBL_VENTA,
        V_PUBL.COND_PUBL_ALQUILER,
		ETI.DD_ETI_CODIGO AS ESTADO_TITULO
		FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO 			AGR
		INNER JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION 			AGRU 	ON AGRU.AGR_ID = AGR.AGR_ID 		 AND AGRU.BORRADO = 0
    	INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO 					ACT  	ON ACT.ACT_ID = AGR.ACT_ID 			 AND ACT.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL          ICO     ON ACT.ACT_ID = ICO.ACT_ID           AND ICO.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.ACT_VIV_VIVIENDA                VIV     ON VIV.ICO_ID = ICO.ICO_ID 
    	INNER JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION 				LOC  	ON ACT.BIE_ID = LOC.BIE_ID 			 AND LOC.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_TVI_TIPO_VIA 			TVI  	ON LOC.DD_TVI_ID = TVI.DD_TVI_ID 	 AND TVI.BORRADO = 0
    	INNER JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES 			BIE  	ON ACT.BIE_ID = BIE.BIE_ID 			 AND BIE.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL         REG     ON ACT.ACT_ID = REG.ACT_ID           AND REG.BORRADO = 0
    	INNER JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO 			TPA  	ON TPA.DD_TPA_ID = ACT.DD_TPA_ID 	 AND TPA.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO 			SAC  	ON SAC.DD_SAC_ID = ACT.DD_SAC_ID 	 AND SAC.BORRADO = 0
    	INNER JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL 	SCM  	ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 	 AND SCM.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA 			SPS  	ON SPS.ACT_ID = ACT.ACT_ID 			 AND SPS.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION 		ACT_APU ON ACT_APU.ACT_ID = ACT.ACT_ID 		 AND ACT_APU.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER 		EPA 	ON ACT_APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA 		EPV 	ON ACT_APU.DD_EPV_ID = EPV.DD_EPV_ID AND EPV.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION 	TCO 	ON TCO.DD_TCO_ID= ACT_APU.DD_TCO_ID  AND TCO.BORRADO = 0
        LEFT JOIN REM01.ACT_TIT_TITULO                  TIT     ON TIT.ACT_ID = ACT.ACT_ID           AND TIT.BORRADO = 0
        LEFT JOIN REM01.DD_ETI_ESTADO_TITULO            ETI     ON ETI.DD_ETI_ID = TIT.DD_ETI_ID     AND ETI.BORRADO = 0
		INNER JOIN '|| V_ESQUEMA ||'.V_COND_PUBLICACION             V_PUBL  ON V_PUBL.ACT_ID = ACT.ACT_ID	
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
		LEFT JOIN '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT GEN ON GEN.ACT_ID = ACT.ACT_ID
        LEFT JOIN REM01.DD_TAG_TIPO_AGRUPACION TAG ON AGRU.DD_TAG_ID = TAG.DD_TAG_ID
		WHERE AGR.BORRADO = 0 OR (AGR.BORRADO = 1 AND TAG.DD_TAG_CODIGO = ''16'')';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION...Creada OK');
  
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

