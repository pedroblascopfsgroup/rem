--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17546
--## PRODUCTO=NO
--## Finalidad: Vista Materializada exclusiva para Stock que contiene la relación de activos con agrupaciones ObrasNuevas, LotesRestringidos, Asistidas, LotesRestringidosAlquiler y LotesRestringidosOBREM.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial ANAHUAC DE VICENTE
--##		0.2 Versión Adrián Molina Garrido
--##		0.3 Se añaden las nuevas agrupaciones Restringida Alquiler y Restringida OB-REM
--##    0.4 HREOS-17546 se anyaden campos para OBRA_NUEVA_PISO_PILOTO y OBRA_NUEVA_FECHA_ESCRITURACION
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_STOCK_PIVOT_AGRUP_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista Materializada exclusiva para Stock que contiene la relación de activos con agrupaciones ObrasNuevas, LotesRestringidos, Asistidas, LotesRestringidosAlquiler y LotesRestringidosOBREM'; -- Vble. para los comentarios de las tablas
    
    
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN/*versión 0.3*/

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
  EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
		SELECT ACT_ID, 
		OBRA_NUEVA_NUM_REM, 
		OBRA_NUEVA_PRINCIPAL, 
    OBRA_NUEVA_PISO_PILOTO, 
		OBRA_NUEVA_FECHA_ESCRITURACION, 
		LOTE_NUM_REM, 
		LOTE_PRINCIPAL, 
		ASISTIDA_NUM_REM, 
		ASISTIDA_PRINCIPAL,
    LOTE_ALQUILER_NUM_REM, 
    LOTE_ALQUILER_PRINCIPAL, 
    LOTE_OBREM_NUM_REM, 
    LOTE_OBREM_PRINCIPAL
		FROM (
			SELECT AGR.AGR_NUM_AGRUP_REM,
		      AGA.ACT_ID,
		      TAG.DD_TAG_CODIGO,
		      DECODE (AGR.AGR_ACT_PRINCIPAL, AGA.ACT_ID, 1, 0) AS PRINCIPAL,
          AGA.PISO_PILOTO,
		      AGA.AGA_FECHA_ESCRITURACION
		    FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR
		    JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID
		    JOIN DD_TAG_TIPO_AGRUPACION TAG ON (TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.DD_TAG_CODIGO IN (''01'',''02'',''13'',''17'',''18''))
		    WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL
		) PIVOT (MAX(AGR_NUM_AGRUP_REM) AS NUM_REM, MAX(PRINCIPAL) AS PRINCIPAL, MAX(PISO_PILOTO) AS PISO_PILOTO, MAX(AGA_FECHA_ESCRITURACION) AS FECHA_ESCRITURACION
             FOR DD_TAG_CODIGO IN (''01'' OBRA_NUEVA,''02'' LOTE,''13'' ASISTIDA,''17'' LOTE_ALQUILER,''18'' LOTE_OBREM))';
				

  	DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  	
  	--Creamos indice
  	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.VI_STOCK_PIVOT_AGRUP_ACT_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ACT_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VI_STOCK_PIVOT_AGRUP_ACT_IDX... Indice creado.');
		
	-- Creamos primary key
	V_MSQL := 'ALTER MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' ADD (CONSTRAINT VI_STOCK_PIVOT_AGRUP_ACT_PK PRIMARY KEY (ACT_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VI_STOCK_PIVOT_AGRUP_ACT_PK... PK creada.');
		
    -- Creamos comentario	
	V_MSQL := 'COMMENT ON MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Comentario creado.');
  
EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;