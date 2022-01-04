--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11001
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Utiliza tabla ACT_EXG_EXCLUSION_GENCAT para excluir activos de la vista
--##		    0.3 Se añade Cerberus - Apple - Vicente Martinez
--##        0.4 Se añaden subcarteras de Divarian
--##        0.5 Se añaden subcarteras de BBVA
--##        0.6 Se añaden subcarteras de BBVA 2.0
--##        0.7 Se materializa la vista
--##        0.8 Se añade la cartera titulizada REMVIP-11001
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
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER(16); -- Vble. para validar la existencia de vista.
    
BEGIN
	
--VI_ACTIVOS_AFECTOS_GENCAT v0.6

  SELECT COUNT(1) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_ACTIVOS_AFECTOS_GENCAT' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA > 0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_ACTIVOS_AFECTOS_GENCAT';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT... borrada OK');
  END IF;

  SELECT COUNT(1) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_ACTIVOS_AFECTOS_GENCAT' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA > 0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_ACTIVOS_AFECTOS_GENCAT';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT...');
  EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT
  	REFRESH COMPLETE ON DEMAND START WITH SYSDATE NEXT SYSDATE + 1
      AS
        WITH FECHA_ADJUDICACION AS 
        (
          SELECT ACT.ACT_ID
          , CASE WHEN TTA.DD_TTA_CODIGO = ''01'' AND AJD.AJD_ID IS NOT NULL THEN 
		            CASE WHEN ADJ.BIE_ADJ_F_DECRETO_FIRME IS NOT NULL THEN ADJ.BIE_ADJ_F_DECRETO_FIRME --Fecha firmeza auto adjudicación del activo.
		                 WHEN ADJ.BIE_ADJ_F_DECRETO_N_FIRME IS NOT NULL THEN ADJ.BIE_ADJ_F_DECRETO_N_FIRME --Fecha auto adjudicación del activo.
		                 ELSE NULL
		            END
         	   WHEN TTA.DD_TTA_CODIGO = ''02'' AND ADN.ADN_ID IS NOT NULL THEN 
		            CASE WHEN ADN.ADN_FECHA_FIRMA_TITULO IS NOT NULL THEN ADN.ADN_FECHA_FIRMA_TITULO --Fecha de firma del título.
		                 WHEN ADN.ADN_FECHA_TITULO IS NOT NULL THEN ADN.ADN_FECHA_TITULO --Fecha del título.
		                 ELSE NULL
		            END
    	  END FECHA_ADJUDICACION
          , ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID 
          ORDER BY 
          CASE WHEN TTA.DD_TTA_CODIGO = ''01'' AND AJD.AJD_ID IS NOT NULL THEN 
		            CASE WHEN ADJ.BIE_ADJ_F_DECRETO_FIRME IS NOT NULL THEN ADJ.BIE_ADJ_F_DECRETO_FIRME --Fecha firmeza auto adjudicación del activo.
		                 WHEN ADJ.BIE_ADJ_F_DECRETO_N_FIRME IS NOT NULL THEN ADJ.BIE_ADJ_F_DECRETO_N_FIRME --Fecha auto adjudicación del activo.
		                 ELSE NULL
		            END
	           WHEN TTA.DD_TTA_CODIGO = ''02'' AND ADN.ADN_ID IS NOT NULL THEN 
		            CASE WHEN ADN.ADN_FECHA_FIRMA_TITULO IS NOT NULL THEN ADN.ADN_FECHA_FIRMA_TITULO --Fecha de firma del título.
		                 WHEN ADN.ADN_FECHA_TITULO IS NOT NULL THEN ADN.ADN_FECHA_TITULO --Fecha del título.
		                 ELSE NULL
		            END
	      END NULLS LAST) RN
          FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
          JOIN '|| V_ESQUEMA ||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID AND TTA.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID = ACT.ACT_ID AND ADN.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION ADJ ON ADJ.BIE_ID = ACT.BIE_ID AND ADJ.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID = ACT.ACT_ID AND AJD.BORRADO = 0
          AND AJD.BIE_ADJ_ID = ADJ.BIE_ADJ_ID
          WHERE ACT.BORRADO = 0
        )
        SELECT ACT.ACT_ID
        FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
        JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION LOC ON LOC.BIE_ID = ACT.BIE_ID AND LOC.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.ACT_LOC_LOCALIZACION ACT_LOC ON ACT_LOC.ACT_ID = ACT.ACT_ID
        AND LOC.BIE_LOC_ID = ACT_LOC.BIE_LOC_ID
        AND ACT_LOC.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.CMU_CONFIG_MUNICIPIOS CMU ON CMU.DD_LOC_ID = LOC.DD_LOC_ID AND CMU.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
        AND SCR.DD_CRA_ID = CRA.DD_CRA_ID
        JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
        JOIN REMMASTER.DD_LOC_LOCALIDAD DD_LOC ON DD_LOC.DD_LOC_ID = LOC.DD_LOC_ID AND DD_LOC.BORRADO = 0
        JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO = 0
        JOIN FECHA_ADJUDICACION ADJ ON ADJ.ACT_ID = ACT.ACT_ID AND ADJ.RN = 1
        WHERE ACT.BORRADO = 0
        AND ADJ.FECHA_ADJUDICACION > TO_DATE(''07/04/2008'',''DD/MM/YYYY'')
        AND TPA.DD_TPA_CODIGO = ''02''
        AND (CRA.DD_CRA_CODIGO, SCR.DD_SCR_CODIGO) IN (
        (''03'',''06''),(''03'',''07''),(''03'',''08''),(''03'',''09'')
        ,(''02'',''04'')
        ,(''01'',''02'')
        ,(''08'',''18''),(''08'',''56''),(''08'',''57''),(''08'',''58''),(''08'',''59''),(''08'',''60''),(''08'',''136''),(''08'',''64'')
        ,(''06'',''16''),(''07'',''138''),(''07'',''151''),(''07'',''152''), (''16'', ''153''), (''16'', ''154''), (''16'', ''155''), (''16'', ''156''), (''16'', ''157''), (''16'', ''158''),
        (''18'',''162''),(''18'',''163'')
        )
	AND NOT EXISTS ( SELECT 1
			 FROM '|| V_ESQUEMA ||'.ACT_EXG_EXCLUSION_GENCAT EXG
			 WHERE EXG.ACT_ID = ACT.ACT_ID ) 
		MINUS
		    SELECT AGA.ACT_ID 
			FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
		    JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
		    JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.DD_TAG_CODIGO = ''16'' AND TAG.BORRADO = 0
		    WHERE AGA.AGA_PRINCIPAL = 0 
		';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_ACTIVOS_AFECTOS_GENCAT...Creada OK');
  
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
