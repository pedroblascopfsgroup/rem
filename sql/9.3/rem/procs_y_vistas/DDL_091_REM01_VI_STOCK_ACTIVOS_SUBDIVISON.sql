--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220422
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11478
--## PRODUCTO=NO
--## Finalidad: Vista Materializada exclusiva para Stock que contiene la relación de activos y subdivisiones.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se añade un LEFT JOIN al cruce con la DD_SAC - Daniel Algaba - 20211018 - HREOS-15634
--##        0.3 Se añade banyos al ora_hash para aumentar precision en el id - Juan Bautista Alfonso - 20220413 - REMVIP-11478
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_STOCK_ACTIVOS_SUBDIVISON'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista Materializada exclusiva para Stock que contiene la relación de activos y subdivisiones'; -- Vble. para los comentarios de las tablas
    
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
  EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
		SELECT SUBD.ACT_ID, SUBD.ID  FROM (
			SELECT ACT.ACT_ID, ACT.DD_TPA_ID, ACT.DD_SAC_ID,
      ORA_HASH ( ACT.DD_TPA_ID
          || ACT.DD_SAC_ID
          || NVL (ICO.ICO_NUM_PLANTAS, 0)
          || NVL (ICO.ICO_NUM_DORMITORIOS, 0)
          || NVL (ICO.ICO_NUM_BANYOS, 0)
      ) ID
			FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
      WHERE ACT.BORRADO = 0 AND ICO.BORRADO = 0
			GROUP BY ACT.ACT_ID,
		    ACT.ACT_NUM_ACTIVO,
		    ACT.DD_TPA_ID,
		    ACT.DD_SAC_ID,
		    ICO.ICO_NUM_PLANTAS,
        ICO.ICO_NUM_DORMITORIOS,
        ICO.ICO_NUM_BANYOS
		)SUBD
		INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = SUBD.DD_TPA_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = SUBD.DD_SAC_ID';

  	DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');

  	--Creamos indice
  	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.VI_STOCK_ACTIVOS_SUBDV_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ACT_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VI_STOCK_ACTIVOS_SUBDV_IDX... Indice creado.');
	
	
	-- Creamos primary key
	V_MSQL := 'ALTER MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' ADD (CONSTRAINT VI_STOCK_ACTIVOS_SUBDV_PK PRIMARY KEY (ACT_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VI_STOCK_ACTIVOS_SUBDV_PK... PK creada.');
	
	
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
