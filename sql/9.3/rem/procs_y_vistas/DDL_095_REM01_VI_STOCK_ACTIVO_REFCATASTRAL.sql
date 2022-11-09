--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20221013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16549
--## PRODUCTO=NO
--## Finalidad: Vista Materializada exclusiva para Stock que contiene la relación de activos y su última referencia catastral
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Versión Julián Dolz - Añadir campo CAT_CORRECTO
--##        0.3 [REMVIP-12572] IRC - Filtro borrado
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_STOCK_ACTIVO_REFCATASTRAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista Materializada exclusiva para Stock que contiene la relación de activos y su última referencia catastral.'; -- Vble. para los comentarios de las tablas
    
    
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
		SELECT AUX.ACT_ID, AUX.CAT_REF_CATASTRAL, AUX.CAT_CORRECTO FROM (
			SELECT CAT.ACT_ID, CAT.CAT_REF_CATASTRAL, CAT.CAT_CORRECTO,
			ROW_NUMBER() OVER (PARTITION BY CAT.ACT_ID ORDER BY CAT.CAT_ID DESC) REF
			FROM '||V_ESQUEMA||'.ACT_CAT_CATASTRO CAT WHERE CAT.BORRADO = 0) AUX
		WHERE AUX.REF = 1';
				

 	 DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  
 	--Creamos indice
  	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.VI_STOCK_ACTIVO_REFCAT_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ACT_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VI_STOCK_ACTIVO_REFCAT_IDX... Indice creado.'); 
 	 
	
	-- Creamos primary key
	V_MSQL := 'ALTER MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' ADD (CONSTRAINT VI_STOCK_ACTIVO_REFCAT_PK PRIMARY KEY (ACT_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VI_STOCK_ACTIVO_REFCAT_PK... PK creada.');
	
	
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
