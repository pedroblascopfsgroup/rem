--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20201009
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11616
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_BBVA_ACTIVOS'; -- Nombre de la tabl
    V_COLUMN_NAME VARCHAR2(50 CHAR):= 'BBVA_COD_PROMOCION'; -- Nombre de la columna
    V_COLUMN_TYPE VARCHAR2(50 CHAR):= 'VARCHAR2(20 CHAR)'; -- Type de la columna
    V_COLUMN_COMMENT VARCHAR2(250 CHAR):= 'Código de promoción del activo bbva.'; -- Comentario de la columna
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ALTER TABLA ' || V_TABLA);
		
		V_MSQL := ' SELECT COUNT(*) 
			    FROM USER_TAB_COLS
			    WHERE COLUMN_NAME = '''|| V_COLUMN_NAME ||'''
			    AND TABLE_NAME = '''|| V_TABLA ||'''';
	
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FILAS;
		
		IF V_NUM_FILAS = 0 THEN
	
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'|| V_TABLA ||'
						ADD '|| V_COLUMN_NAME ||' '|| V_COLUMN_TYPE;
	
			EXECUTE IMMEDIATE V_MSQL;
	
			EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'|| V_TABLA ||'.'|| V_COLUMN_NAME ||' is '''|| V_COLUMN_COMMENT ||'''';
			
			DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA YA EXISTE');

		END IF;
	
 
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