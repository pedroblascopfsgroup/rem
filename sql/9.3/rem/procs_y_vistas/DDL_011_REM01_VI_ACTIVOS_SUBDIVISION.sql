--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
--## PRODUCTO=SI
--## Finalidad: DDL VISTA PARA LAS SUBDIVISIONES DE AGRUPACION
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial (JOSE VILLEL 20160510)
--##        0.2 Creación columna de Estado de publicación
--##		0.3 Se ha creado la vista V_COND_PUBLICACION y se hace un join con esta vista para sacar los campos COND_PUBL_VENTA y COND_PUBL_ALQUILER + añadir la columna publicado
--##		0.4 Se actualiza para nivelar los ID's de esta vista y V_SUBDIVISIONES_AGRUPACION
--##        0.5 Se añade un LEFT JOIN al cruce con la DD_SAC - Daniel Algaba - 20211018 - HREOS-15634
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    SEQ_COUNT NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
    TABLE_COUNT NUMBER(3); -- Vble. para validar la existencia de las Tablas.
    V_COLUMN_COUNT NUMBER(3); -- Vble. para validar la existencia de las Columnas.    
    V_CONSTRAINT_COUNT NUMBER(3); -- Vble. para validar la existencia de las Constraints.
    ERR_NUM NUMBER; -- N?mero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN
--v0.2
  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVOS_SUBDIVISION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_ACTIVOS_SUBDIVISION';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVOS_SUBDIVISION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ACTIVOS_SUBDIVISION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_ACTIVOS_SUBDIVISION 

	AS
		SELECT ACT_SD.ID, AGA.AGR_ID, ACT_SD.ACT_ID, ACT_SD.ACT_NUM_ACTIVO, ACT_SD.BIE_DREG_NUM_FINCA, ACT_SD.DD_TPA_DESCRIPCION, ACT_SD.DD_SAC_DESCRIPCION, ACT_SD.DD_AIC_DESCRIPCION,
DECODE(TCO.DD_TCO_CODIGO ,''03'',EPA.DD_EPA_DESCRIPCION,''01'',EPV.DD_EPV_DESCRIPCION,''02'',EPA.DD_EPA_DESCRIPCION||''/''||EPV.DD_EPV_DESCRIPCION) AS PUBLICADO,
COND.COND_PUBL_VENTA, COND.COND_PUBL_ALQUILER

  FROM (SELECT SUBD.ID, SUBD.ACT_ID, SUBD.ACT_NUM_ACTIVO, SUBD.BIE_DREG_NUM_FINCA, TPA.DD_TPA_DESCRIPCION, SAC.DD_SAC_DESCRIPCION, SUBD.DD_AIC_DESCRIPCION
          FROM (SELECT   ACT.ACT_ID, ACT.ACT_NUM_ACTIVO, ACT.DD_TPA_ID, ACT.DD_SAC_ID, BIEDREG.BIE_DREG_NUM_FINCA, AIC.DD_AIC_DESCRIPCION,
                         ORA_HASH (   ACT.DD_TPA_ID
                                   || ACT.DD_SAC_ID
                                   || NVL (VIV.VIV_NUM_PLANTAS_INTERIOR, 0)
                                   || NVL (SUM (DECODE (DIS.DD_TPH_ID, 1, DIS.DIS_CANTIDAD, NULL)), 0)
                                   || NVL (SUM (DECODE (DIS.DD_TPH_ID, 2, DIS.DIS_CANTIDAD, NULL)), 0)
                                  ) ID
 

                    FROM '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO 
						JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID AND ACT.BORRADO = 0
                         LEFT JOIN '|| V_ESQUEMA ||'.V_MAX_ACT_HIC_EST_INF_COM MAXHIC ON (MAXHIC.ACT_ID = ACT.ACT_ID AND MAXHIC.POS = 1)
                         LEFT JOIN '|| V_ESQUEMA ||'.DD_AIC_ACCION_INF_COMERCIAL AIC ON AIC.DD_AIC_ID = MAXHIC.DD_AIC_ID
                         LEFT JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BIEDREG ON ACT.BIE_ID = BIEDREG.BIE_ID AND BIEDREG.BORRADO = 0
                         LEFT JOIN '|| V_ESQUEMA ||'.ACT_VIV_VIVIENDA VIV ON VIV.ICO_ID = ICO.ICO_ID
                         LEFT JOIN '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = VIV.ICO_ID AND DIS.BORRADO = 0
                   WHERE ICO.BORRADO = 0
                GROUP BY ACT.ACT_ID, ACT.ACT_NUM_ACTIVO, ACT.DD_TPA_ID, ACT.DD_SAC_ID, BIEDREG.BIE_DREG_NUM_FINCA, AIC.DD_AIC_DESCRIPCION, NVL (VIV.VIV_NUM_PLANTAS_INTERIOR, 0)) SUBD
               JOIN
               DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = SUBD.DD_TPA_ID
               LEFT JOIN DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = SUBD.DD_SAC_ID
               ) ACT_SD
        
		JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT_SD.ACT_ID
		INNER JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID 
		INNER JOIN DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID 
		JOIN ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT_SD.ACT_ID AND APU.BORRADO = 0
		JOIN V_COND_PUBLICACION COND ON ACT_SD.ACT_ID = COND.ACT_ID
		LEFT JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.BORRADO = 0
		LEFT JOIN DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID
        LEFT JOIN DD_EPA_ESTADO_PUB_ALQUILER EPA ON  EPA.DD_EPA_ID = APU.DD_EPA_ID
		WHERE ((AGA.AGA_PRINCIPAL = 0 AND TAG.DD_TAG_CODIGO=''16'' ) OR (TAG.DD_TAG_CODIGO != ''16'')) ';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION...Creada OK');
  
END;
/

EXIT;
