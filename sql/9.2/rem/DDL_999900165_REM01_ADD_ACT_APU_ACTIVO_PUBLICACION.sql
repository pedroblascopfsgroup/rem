--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20180510
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-4077
--## PRODUCTO=NO
--##
--## Finalidad: Añadir columna AJD_NUM_AUTO y AJD_PROCURADOR a APR_AUX_BIE_ADJ_ADJUDICACION
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA; 
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('ES_CONDICONADO_ANTERIOR','number(1) default 0 not null')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] INICIO DEL PROCESO');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);    
		 -- Comprobamos si existe la columna en APR_AUX_BIEN_DACIONES
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER =  '''|| V_ESQUEMA ||''' AND TABLE_NAME = '''||V_TEXT_TABLA||''' AND COLUMN_NAME =  '''||V_TMP_TIPO_DATA(1)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
		IF V_NUM_TABLAS = 0 THEN 
			V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ADD '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', COLUMNA AÑADIDA CON ÉXITO');
			
		    -- Creamos comentarios  
		    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS ''Valor anterior de ES_CONDICIONADO que se calcula en V_COND_DISPONIBILIDAD.ES_CONDICIONADO'' ';      
		    EXECUTE IMMEDIATE V_MSQL;
			
		    DBMS_OUTPUT.PUT_LINE ( '[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Comentario en columna creado');			
			
		ELSE    
			DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', LA TABLA YA TIENE DICHA COLUMNA');
		END IF;
	END LOOP;
	
	V_TEXT_TABLA := 'ACT_AHP_HIST_PUBLICACION';
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);    
		 -- Comprobamos si existe la columna en APR_AUX_BIEN_DACIONES
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER =  '''|| V_ESQUEMA ||''' AND TABLE_NAME = '''||V_TEXT_TABLA||''' AND COLUMN_NAME =  '''||V_TMP_TIPO_DATA(1)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
		IF V_NUM_TABLAS = 0 THEN 
			V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ADD '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', COLUMNA AÑADIDA CON ÉXITO');
			
		    -- Creamos comentarios  
		    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS ''Valor anterior de ES_CONDICIONADO que se calcula en V_COND_DISPONIBILIDAD.ES_CONDICIONADO'' ';      
		    EXECUTE IMMEDIATE V_MSQL;
			
		    DBMS_OUTPUT.PUT_LINE ( '[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Comentario en columna creado');			
			
		ELSE    
			DBMS_OUTPUT.PUT_LINE('[INFO]: '|| V_ESQUEMA || '.'||V_TEXT_TABLA||', LA TABLA YA TIENE DICHA COLUMNA');
		END IF;
	END LOOP;	
	
    COMMIT;
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
