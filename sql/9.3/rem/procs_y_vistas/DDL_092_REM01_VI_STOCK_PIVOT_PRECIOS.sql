--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-14272
--## PRODUCTO=NO
--## Finalidad: Vista Materializada exclusiva para Stock que contiene la relación de activos con precios AprobadoVenta, AprobadoRenta, DescuentoWeb y MinimoAutorizado
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Sergio Gomez - HREOS-14272 Anyadir DPA al filtro por el TPC.DD_TPC_CODIGO
--##        0.3 [HREOS-14530] - Añadimos precio: MINIMO AUTORIZADO
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_STOCK_PIVOT_PRECIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista Materializada exclusiva para Stock que contiene la relación de activos con precios AprobadoVenta, AprobadoRenta, DescuentoWeb y MinimoAutorizado'; -- Vble. para los comentarios de las tablas
    
    
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
  		WITH PIVOT_DATA AS (
			SELECT * FROM (
				SELECT VAL.ACT_ID, TPC.DD_TPC_CODIGO, VAL.VAL_FECHA_INICIO, VAL.VAL_FECHA_FIN, VAL.VAL_IMPORTE			
				FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
		        JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON (VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO IN (''02'',''03'', ''04'', ''13'', ''DPA''))
		        WHERE VAL.BORRADO = 0
			) 
		)
		SELECT ACT_ID, 
		APROBADO_VENTA_WEB_F_INI, 
		APROBADO_VENTA_WEB_F_FIN, 
		APROBADO_VENTA_WEB, 
		APROBADO_RENTA_WEB_F_INI, 
		APROBADO_RENTA_WEB_F_FIN,
		APROBADO_RENTA_WEB,
		DESCUENTO_PUBLICADO_F_INI,
		DESCUENTO_PUBLICADO_F_FIN,
		DESCUENTO_PUBLICADO,
		DESCUENTO_PUBLICADO_ALQUILER_F_INI,
		DESCUENTO_PUBLICADO_ALQUILER_F_FIN,
		DESCUENTO_PUBLICADO_ALQUILER,
		MINIMO_AUTORIZADO	 
		FROM PIVOT_DATA
		PIVOT (
			MAX(VAL_FECHA_INICIO) AS F_INI,
			MAX(VAL_FECHA_FIN) AS F_FIN,
			MAX(VAL_IMPORTE) FOR DD_TPC_CODIGO IN (	
				''02'' AS "APROBADO_VENTA_WEB",
				''03'' AS "APROBADO_RENTA_WEB",
				''04'' AS "MINIMO_AUTORIZADO",
				''13'' AS "DESCUENTO_PUBLICADO",
				''DPA'' AS "DESCUENTO_PUBLICADO_ALQUILER"
			)
		)';
				

 	 DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  
 	--Creamos indice
  	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ACT_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
 	 
	-- Creamos primary key
	V_MSQL := 'ALTER MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' ADD (CONSTRAINT '||V_TEXT_VISTA||'_PK PRIMARY KEY (ACT_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_PK... PK creada.');
	
	
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