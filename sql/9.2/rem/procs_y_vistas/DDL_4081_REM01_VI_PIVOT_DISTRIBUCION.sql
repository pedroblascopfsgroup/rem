--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20181016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-966
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 20161006 Versión inicial 
--##        0.2 20161221 Gustavo Mora: incluimos campo trasteros
--##	    0.3 20181016 Javier Pons: No mostrar distribuciones con tipología != vivienda 	
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_PIVOT_DISTRIBUCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'
	AS
		SELECT ICO_ID, DORMITORIOS, BANYOS, ASEOS, GARAJES, TERRAZAS_CUBIERTAS, TERRAZAS_DESCUBIERTAS, TRASTEROS
		FROM (SELECT  DIS.ICO_ID, TPH.DD_TPH_CODIGO, DIS_CANTIDAD
				FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS 
				INNER JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON DIS.DD_TPH_ID = TPH.DD_TPH_ID
				INNER JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON DIS.ICO_ID = ICO.ICO_ID
				INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACTIVO ON ICO.ACT_ID = ACTIVO.ACT_ID
				INNER JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON ACTIVO.DD_TPA_ID = TPA.DD_TPA_ID
				WHERE DIS.BORRADO = 0
				AND ACTIVO.DD_TPA_ID = (SELECT TPA.DD_TPA_ID
								FROM DD_TPA_TIPO_ACUERDO TPA
								WHERE DD_TPA_CODIGO = ''02''))
		PIVOT(SUM(DIS_CANTIDAD) FOR DD_TPH_CODIGO IN (''01'' DORMITORIOS, ''02'' BANYOS, ''04'' ASEOS, ''12'' GARAJES, ''15'' TERRAZAS_CUBIERTAS,''16'' TERRAZAS_DESCUBIERTAS, ''11'' TRASTEROS))';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  
END;
/

EXIT;
