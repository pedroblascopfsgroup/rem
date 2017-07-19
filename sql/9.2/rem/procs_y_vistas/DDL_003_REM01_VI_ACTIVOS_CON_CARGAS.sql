--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20170515
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1954
--## PRODUCTO=NO
--## Finalidad: Vista que indica si un activo tiene cargas o no.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 20161006 Versión inicial 
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_ACTIVOS_CON_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista que indica si un activo tiene cargas o no.'; -- Vble. para los comentarios de las tablas
    
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
		SELECT  
		ACT.ACT_ID,
		NVL2(AUX.ACT_ID, 1 ,0) AS CON_CARGAS
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		LEFT JOIN (
		  SELECT CRG.CRG_ID, CRG.ACT_ID
		  FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG
		  INNER JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS BCG ON BCG.BIE_CAR_ID = CRG.BIE_CAR_ID
		  LEFT JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA DDSIC ON DDSIC.DD_SIC_ID = BCG.DD_SIC_ID AND DDSIC.DD_SIC_CODIGO IN(''VIG'' , ''NCN'', ''SAN'')
      UNION
      SELECT CRG.CRG_ID, CRG.ACT_ID
      FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG
      INNER JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS BCG ON BCG.BIE_CAR_ID = CRG.BIE_CAR_ID
		  LEFT JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA DDSIC2 ON DDSIC2.DD_SIC_ID = BCG.DD_SIC_ID2 AND DDSIC2.DD_SIC_CODIGO IN(''VIG'' , ''NCN'', ''SAN'')
		) AUX ON AUX.ACT_ID =ACT.ACT_ID
    where act.borrado = 0
		GROUP BY ACT.ACT_ID, AUX.ACT_ID';      
			
			

  	DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
	  
END;
/

EXIT;