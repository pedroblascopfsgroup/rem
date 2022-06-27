--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20220618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11856
--## PRODUCTO=NO
--## 
--## Finalidad: Crear vista para obtener la fecha de posesión de los activos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 [REMVIP-7883] Versión inicial (Creación de la vista)
--##        0.2 [REMVIP-9343] Actualización de condiciones
--##        0.3 [REMVIP-9856] Juan Bautista Alfonso - Actualizacion condiciones para sareb
--##	    0.4 [REMVIP-10845] Juan Bautista Alfonso - Nueva logica de calculo fecha toma posesion para caixabank
--##	    0.5 [HREOS-16597] Santi Monzó - Añadir la subcartera Jaguar
--##	    0.6 [REMVIP-11856] Cristian Montoya - Anyadido campo calculado Con Posesión
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE    
    ERR_NUM NUMBER; -- Numero de error
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); 
    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_FECHA_POSESION_ACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_FECHA_POSESION_ACTIVO...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_FECHA_POSESION_ACTIVO';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_FECHA_POSESION_ACTIVO... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_FECHA_POSESION_ACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_FECHA_POSESION_ACTIVO...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_FECHA_POSESION_ACTIVO';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_FECHA_POSESION_ACTIVO... borrada OK');
  END IF;

    
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_FECHA_POSESION_ACTIVO...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_FECHA_POSESION_ACTIVO 
	AS    
 	WITH AGRUPACION AS (SELECT AGA.AGR_ID, AGA.ACT_ID FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                    INNER JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID AND AGR.BORRADO = 0 AND AGR.DD_TAG_ID = 61
                    WHERE AGA.BORRADO = 0 AND AGA.AGA_PRINCIPAL IS NOT NULL),
     ACT_MATRIZ AS (SELECT AGA.AGR_ID, TTA.DD_TTA_CODIGO, BIE_ADJ.BIE_ADJ_ID, BIE_ADJ.BIE_ADJ_LANZAMIENTO_NECES, BIE_ADJ.BIE_ADJ_F_REA_LANZAMIENTO, BIE_ADJ.BIE_ADJ_F_REA_POSESION, ADN.ADN_FECHA_TITULO, ADN.FECHA_POSESION, SCR.DD_SCR_CODIGO FROM  '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                    INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
                    INNER JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON ACT.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
                    INNER JOIN '|| V_ESQUEMA ||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON ACT.DD_TTA_ID = TTA.DD_TTA_ID AND TTA.BORRADO = 0
                    LEFT JOIN '|| V_ESQUEMA ||'.ACT_AJD_ADJJUDICIAL AJD  ON AJD.ACT_ID = ACT.ACT_ID AND AJD.BORRADO = 0
                    LEFT JOIN '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION BIE_ADJ  ON BIE_ADJ.BIE_ADJ_ID = AJD.BIE_ADJ_ID AND BIE_ADJ.BORRADO = 0
                    LEFT JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL ADN  ON ADN.ACT_ID = ACT.ACT_ID AND ADN.BORRADO = 0
                    WHERE AGA.AGA_PRINCIPAL = 1 AND AGA.BORRADO = 0)
    SELECT DISTINCT ACT.ACT_ID,
        TTA.DD_TTA_CODIGO,
        CASE WHEN CRA.DD_CRA_CODIGO !=''03'' THEN
            CASE TTA.DD_TTA_CODIGO
                WHEN ''01'' THEN
                    CASE
                        WHEN BIE_ADJ.BIE_ADJ_ID IS NOT NULL AND BIE_ADJ.BIE_ADJ_LANZAMIENTO_NECES = 1
                            THEN BIE_ADJ.BIE_ADJ_F_REA_LANZAMIENTO
                            ELSE BIE_ADJ.BIE_ADJ_F_REA_POSESION
                                END
                WHEN ''02'' THEN
                    CASE WHEN SCR.DD_SCR_CODIGO IN (''138'',''151'',''152'',''70'') OR CRA.DD_CRA_CODIGO = ''02''
                            THEN ADN.FECHA_POSESION
                            ELSE ADN.ADN_FECHA_TITULO
                                END
                WHEN ''05'' THEN
                    CASE ACT_MATRIZ.DD_TTA_CODIGO
                        WHEN ''01'' THEN
                            CASE
                                WHEN ACT_MATRIZ.BIE_ADJ_ID IS NOT NULL AND ACT_MATRIZ.BIE_ADJ_LANZAMIENTO_NECES = 1
                                    THEN ACT_MATRIZ.BIE_ADJ_F_REA_LANZAMIENTO
                                ELSE ACT_MATRIZ.BIE_ADJ_F_REA_POSESION
                                END
                        WHEN ''02'' THEN 
                            CASE 
                                WHEN ACT_MATRIZ.DD_SCR_CODIGO IN (''138'',''151'',''152'',''70'') OR CRA.DD_CRA_CODIGO = ''02''
                                    THEN ACT_MATRIZ.FECHA_POSESION
                                ELSE ACT_MATRIZ.ADN_FECHA_TITULO
                                END 
                        END
                    END 
                ELSE
	                SPS.SPS_FECHA_TOMA_POSESION
            END AS FECHA_POSESION,
			CASE WHEN CRA.DD_CRA_CODIGO = ''07'' AND SCR.DD_SCR_CODIGO IN (''138'', ''151'', ''152'', ''70'', ''02'') AND ADN.ACT_ID IS NOT NULL THEN
			    (CASE WHEN ADN.FECHA_POSESION IS NOT NULL THEN
			        1
			    ELSE
			        0
			    END )  
			ELSE
			    CASE WHEN SPS.SPS_FECHA_REVISION_ESTADO IS NOT NULL OR SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL THEN
			        1
			    ELSE
			        0
			    END    
			END AS CON_POSESION
            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
            INNER JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON ACT.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID=CRA.DD_CRA_ID AND CRA.BORRADO = 0
            LEFT JOIN '|| V_ESQUEMA ||'.ACT_AJD_ADJJUDICIAL AJD  ON AJD.ACT_ID = ACT.ACT_ID AND AJD.BORRADO = 0
            LEFT JOIN '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION BIE_ADJ  ON BIE_ADJ.BIE_ADJ_ID = AJD.BIE_ADJ_ID AND BIE_ADJ.BORRADO = 0
            LEFT JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL ADN  ON ADN.ACT_ID = ACT.ACT_ID AND ADN.BORRADO = 0
            LEFT JOIN AGRUPACION ON ACT.ACT_ID = AGRUPACION.ACT_ID
            LEFT JOIN ACT_MATRIZ ON ACT_MATRIZ.AGR_ID = AGRUPACION.AGR_ID
            LEFT JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID=ACT.ACT_ID AND SPS.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.DD_TTA_TIPO_TITULO_ACTIVO TTA  ON TTA.DD_TTA_ID = ACT.DD_TTA_ID AND TTA.DD_TTA_CODIGO IN (''01'',''02'',''05'') AND TTA.BORRADO = 0
            WHERE ACT.BORRADO = 0';
        
DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_FECHA_POSESION_ACTIVO...Creada OK');
  
EXCEPTION
    WHEN OTHERS THEN
         ERR_NUM := SQLCODE;
         ERR_MSG := SQLERRM;

         DBMS_OUTPUT.PUT_LINE('KO no modificada');
         DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
         DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
         DBMS_OUTPUT.PUT_LINE(ERR_MSG);

         ROLLBACK;
         RAISE;   
		 
END;
/

EXIT;
