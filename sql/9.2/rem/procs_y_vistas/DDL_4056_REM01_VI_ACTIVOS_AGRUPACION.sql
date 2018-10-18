--/*
--##########################################
--## AUTOR=HECTOR GOMEZ
--## FECHA_CREACION=20181018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4633
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Direccion separada por espacios
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
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
  V_MSQL := 'CREATE VIEW ' || V_ESQUEMA || '.V_ACTIVOS_AGRUPACION 
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
		ACT.DD_SAC_ID,
		AGR.AGR_ID,
		AGR.AGA_ID,
        BIE.BIE_DREG_SUPERFICIE_CONSTRUIDA,
		(SELECT MAX (VAL2.VAL_IMPORTE) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 WHERE VAL2.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = ''02'' AND BORRADO = 0) AND (VAL2.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL2.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY'')) AND VAL2.ACT_ID = ACT.ACT_ID AND VAL2.BORRADO = 0) AS VAL_IMPORTE_APROBADO_VENTA,
        (SELECT MAX (VAL2.VAL_IMPORTE) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 WHERE VAL2.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = ''04'' AND BORRADO = 0) AND (VAL2.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL2.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY'')) AND VAL2.ACT_ID = ACT.ACT_ID AND VAL2.BORRADO = 0) AS VAL_IMPORTE_MINIMO_AUTORIZADO,
        (SELECT MAX (VAL2.VAL_IMPORTE) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL2 WHERE VAL2.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = ''01'' AND BORRADO = 0) AND (VAL2.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL2.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY'')) AND VAL2.ACT_ID = ACT.ACT_ID AND VAL2.BORRADO = 0) AS VAL_NETO_CONTABLE,
        --AGR.AGA_PRINCIPAL,
        SCM.DD_SCM_DESCRIPCION AS SITUACION_COMERCIAL,
        SPS.SPS_OCUPADO,
		SPS.SPS_CON_TITULO,
		SDV.DESCRIPCION AS SDV_NOMBRE,
		    DECODE(TCO.DD_TCO_CODIGO ,''03'',EPA.DD_EPA_DESCRIPCION,''01'',EPV.DD_EPV_DESCRIPCION,''02'',EPA.DD_EPA_DESCRIPCION||''/''||EPV.DD_EPV_DESCRIPCION) AS PUBLICADO,
    (SELECT MAX (VAL2.VAL_IMPORTE) FROM
			(SELECT VAL5.ACT_ID, VAL5.VAL_IMPORTE, VAL5.VAL_FECHA_INICIO, MAX(VAL5.VAL_FECHA_INICIO) OVER(PARTITION BY VAL5.ACT_ID) AS FECHA_MAX
				 FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL5 INNER JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC5 ON VAL5.DD_TPC_ID = TPC5.DD_TPC_ID AND TPC5.DD_TPC_CODIGO = ''13'' AND TPC5.BORRADO = 0
					WHERE (VAL5.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL5.VAL_FECHA_FIN,''DD/MM/YYYY'') >= TO_DATE(sysdate,''DD/MM/YYYY''))
						AND TO_DATE(VAL5.VAL_FECHA_INICIO,''DD/MM/YYYY'') <= TO_DATE(sysdate,''DD/MM/YYYY'') AND VAL5.BORRADO = 0) VAL2
			WHERE VAL2.VAL_FECHA_INICIO = VAL2.FECHA_MAX AND VAL2.ACT_ID = ACT.ACT_ID) AS VAL_IMPORTE_DESCUENTO_PUBLICO

    	FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGR
		INNER JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGRU ON AGRU.AGR_ID = AGR.AGR_ID AND AGRU.BORRADO = 0
    	INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGR.ACT_ID AND ACT.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION LOC ON ACT.BIE_ID = LOC.BIE_ID AND LOC.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_TVI_TIPO_VIA TVI ON LOC.DD_TVI_ID = TVI.DD_TVI_ID AND TVI.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0
    	LEFT JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.BORRADO = 0
      LEFT JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT_APU ON ACT_APU.ACT_ID = ACT.ACT_ID AND ACT_APU.BORRADO = 0
      LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON ACT_APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.BORRADO = 0
      LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON ACT_APU.DD_EPV_ID = EPV.DD_EPV_ID AND EPV.BORRADO = 0
      LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID= ACT_APU.DD_TCO_ID AND TCO.BORRADO = 0
  		INNER JOIN '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION ACT_SD ON ACT.ACT_ID = ACT_SD.ACT_ID
  		INNER JOIN '|| V_ESQUEMA ||'.V_SUBDIVISIONES_AGRUPACION SDV ON ACT_SD.AGR_ID = SDV.AGR_ID AND SDV.ID = ACT_SD.ID';

    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_AGRUPACION...Creada OK');
  
END;
/

EXIT;

