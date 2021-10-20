--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
--## PRODUCTO=NO
--## Finalidad: DDL VISTA PARA LAS SUBDIVISIONES DE AGRUPACION
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Se actualiza para nivelar los ID's de esta vista y V_ACTIVOS_SUBDIVISION
--##		0.3 Se añade codigo subtipo activo
--##        0.4 Se añade un LEFT JOIN al cruce con la DD_SAC - Daniel Algaba - 20211018 - HREOS-15634
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);
    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_SUBDIVISIONES_AGRUPACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_SUBDIVISIONES_AGRUPACION...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_SUBDIVISIONES_AGRUPACION';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_SUBDIVISIONES_AGRUPACION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_SUBDIVISIONES_AGRUPACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_SUBDIVISIONES_AGRUPACION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_SUBDIVISIONES_AGRUPACION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_SUBDIVISIONES_AGRUPACION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_SUBDIVISIONES_AGRUPACION...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_SUBDIVISIONES_AGRUPACION 

	AS
		SELECT 
			ACT_SD.ID, 
			AGA.AGR_ID, 
			ACT_SD.DESCRIPCION,
			ACT_SD.COD_SUBTIPO_ACTIVO,
			ACT_SD.DORMITORIOS,
			ACT_SD.PLANTAS,
			COUNT(*) AS NUM_ACTIVOS FROM(
							SELECT SUBD.ID, SUBD.ACT_ID,
							CASE TPA.DD_TPA_CODIGO
								WHEN ''02''	THEN TPA.DD_TPA_DESCRIPCION || '' - '' || SAC.DD_SAC_DESCRIPCION || NVL2(SUBD.PLANTAS,'' - '' || SUBD.PLANTAS ||'' PLANTA'' || DECODE(SUBD.PLANTAS,1,'''',''S''),NULL) || NVL2(SUBD.DORMITORIOS,'' - '' || SUBD.DORMITORIOS ||'' DORMITORIO''|| DECODE(SUBD.DORMITORIOS,1,'''',''S'')  ,NULL)
  								ELSE TPA.DD_TPA_DESCRIPCION || '' - '' || SAC.DD_SAC_DESCRIPCION
							END DESCRIPCION,
		SAC.DD_SAC_CODIGO AS COD_SUBTIPO_ACTIVO,
              SUBD.DORMITORIOS,
              SUBD.PLANTAS
							FROM (
									SELECT ACT.ACT_ID, ACT.DD_TPA_ID, ACT.DD_SAC_ID, NVL(VIV.VIV_NUM_PLANTAS_INTERIOR,0) PLANTAS, NVL(SUM (DECODE (DIS.DD_TPH_ID, 1, DIS.DIS_CANTIDAD, NULL)),0) DORMITORIOS, 
									NVL(SUM (DECODE (DIS.DD_TPH_ID, 2, DIS.DIS_CANTIDAD, NULL)),0) BANYOS,
									ORA_HASH(
												  act.dd_tpa_id
			                                   || act.dd_sac_id
			                                   || NVL (viv.viv_num_plantas_interior, 0)
			                                   || NVL (SUM (DECODE (dis.dd_tph_id, 1, dis.dis_cantidad, NULL)), 0)
			                                   || NVL (SUM (DECODE (dis.dd_tph_id, 2, dis.dis_cantidad, NULL)), 0)
											) ID
                                    FROM ' || V_ESQUEMA || '.act_activo act
                                    JOIN ' || V_ESQUEMA || '.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
                                     LEFT JOIN ' || V_ESQUEMA || '.V_MAX_ACT_HIC_EST_INF_COM MAXHIC ON (MAXHIC.ACT_ID = ACT.ACT_ID AND MAXHIC.POS = 1) 
                                     LEFT JOIN ' || V_ESQUEMA || '.DD_AIC_ACCION_INF_COMERCIAL AIC ON AIC.DD_AIC_ID = MAXHIC.DD_AIC_ID AND AIC.BORRADO = 0
                                     LEFT JOIN ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES BIEDREG ON ACT.BIE_ID = BIEDREG.BIE_ID AND BIEDREG.BORRADO = 0
                                     LEFT JOIN ' || V_ESQUEMA || '.ACT_VIV_VIVIENDA VIV ON VIV.ICO_ID = ICO.ICO_ID 
                                     LEFT JOIN ' || V_ESQUEMA || '.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = VIV.ICO_ID AND DIS.BORRADO = 0
                                    WHERE ACT.BORRADO = 0
									GROUP BY ACT.ACT_ID, ACT.DD_TPA_ID, ACT.DD_SAC_ID, NVL(VIV.VIV_NUM_PLANTAS_INTERIOR,0)
							) SUBD
							JOIN ' || V_ESQUEMA || '.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = SUBD.DD_TPA_ID
							LEFT JOIN ' || V_ESQUEMA || '.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = SUBD.DD_SAC_ID
			) ACT_SD
		JOIN ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT_SD.ACT_ID
		JOIN ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
		WHERE ((AGR.DD_TAG_ID = (SELECT TA.DD_TAG_ID FROM ' || V_ESQUEMA || '.DD_TAG_TIPO_AGRUPACION TA WHERE TA.DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 0) OR ( EXISTS  (SELECT 1 FROM ' || V_ESQUEMA || '.DD_TAG_TIPO_AGRUPACION TA WHERE TA.DD_TAG_CODIGO != ''16'' AND TA.DD_TAG_ID = AGR.DD_TAG_ID)))
		GROUP BY ACT_SD.ID, AGA.AGR_ID, ACT_SD.DESCRIPCION,ACT_SD.COD_SUBTIPO_ACTIVO,ACT_SD.DORMITORIOS,ACT_SD.PLANTAS';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_SUBDIVISIONES_AGRUPACION...Creada OK');
  
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
