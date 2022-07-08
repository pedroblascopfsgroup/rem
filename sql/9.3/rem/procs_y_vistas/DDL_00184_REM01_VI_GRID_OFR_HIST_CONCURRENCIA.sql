--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17805
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        HREOS-HREOS-17805: Vista para sacar el histórico de concurrencias de una agrupación o activo, en concurrencia.
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
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_GRID_OFR_HIST_CONCURRENCIA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_HIST_CONCURRENCIA...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_HIST_CONCURRENCIA... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_GRID_OFR_HIST_CONCURRENCIA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_HIST_CONCURRENCIA...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_HIST_CONCURRENCIA... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_HIST_CONCURRENCIA...');
  V_MSQL := 'CREATE VIEW ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA
	AS
		 SELECT 
			CON.CON_ID,
			ACT.ACT_ID,
			ACT.ACT_NUM_ACTIVO,
			AGR.AGR_ID,
			AGR.AGR_NUM_AGRUP_REM,
			NVL2(AGR.AGR_NUM_AGRUP_REM, AGR.AGR_NUM_AGRUP_REM, ACT.ACT_NUM_ACTIVO) AS NUM_ACTIVO_AGRUPACION,
			CON.CON_IMPORTE_MIN_OFR,
			CON.CON_FECHA_INI,
			CON.CON_FECHA_FIN,
			OFR.OFR_ID,
			OFR.OFR_NUM_OFERTA,
      OFR.OFR_CONCURRENCIA
		FROM ' || V_ESQUEMA || '.CON_CONCURRENCIA CON
		INNER JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = CON.ACT_ID AND ACT.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = CON.AGR_ID AND AGR.BORRADO = 0
		INNER JOIN ' || V_ESQUEMA || '.ACT_OFR AOF ON AOF.ACT_ID = ACT.ACT_ID
		INNER JOIN ' || V_ESQUEMA || '.OFR_OFERTAS OFR ON OFR.OFR_ID = AOF.OFR_ID AND OFR.BORRADO = 0
		WHERE CON.BORRADO = 0
    AND OFR.OFR_CONCURRENCIA IS NOT NULL
    AND OFR.OFR_ID IN (SELECT OFR_ID FROM ' || V_ESQUEMA || '.VI_GRID_OFR_ACT_AGR_CONCU)
		ORDER BY CON.CON_ID DESC';
		
  EXECUTE IMMEDIATE	V_MSQL;
    
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_HIST_CONCURRENCIA...Creada OK');
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA IS ''VISTA PARA RECOGER EL HISTÓRICO DE OFERTAS DE CONCURRENCIA DE ACTIVOS Y AGRUPACIONES''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.OFR_NUM_OFERTA IS ''Número de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.NUM_ACTIVO_AGRUPACION IS ''Número de agrupación o activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.ACT_ID IS ''Código identificador único del activo.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.ACT_NUM_ACTIVO IS ''Número de activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.AGR_ID IS ''Código identificador único de la agrupación.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.AGR_NUM_AGRUP_REM IS ''Número de agrupación''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.OFR_ID IS ''Código identificador único de la oferta.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.CON_ID IS ''Código identificador único de la concurrencia relacionado con el activo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.CON_FECHA_INI IS ''Fecha inicio concurrencia''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.CON_FECHA_FIN IS ''Fecha fin concurrencia''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_HIST_CONCURRENCIA.OFR_CONCURRENCIA IS ''Código identificador oferta en concurrencia''';
  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_HIST_CONCURRENCIA...Creada OK');
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
