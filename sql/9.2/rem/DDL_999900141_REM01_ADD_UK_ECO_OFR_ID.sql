--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.8
--## INCIDENCIA_LINK=HREOS-3044
--## PRODUCTO=NO
--## Finalidad: Se añade UK a OFR_ID en ECO
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COLUMN_NAME VARCHAR2(30 CHAR) := 'OFR_ID';

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla y el campo ya existen
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND COLUMN_NAME = '''||V_COLUMN_NAME||''' AND OWNER = '''||V_ESQUEMA||''' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... existe.');
		-- Comprobamos si existe la clave única
		V_SQL := 'SELECT COUNT(1)
			FROM ALL_CONS_COLUMNS T1
			JOIN ALL_CONSTRAINTS T2 ON T1.CONSTRAINT_NAME = T2.CONSTRAINT_NAME AND T2.CONSTRAINT_TYPE = ''U''
			WHERE T1.COLUMN_NAME = '''||V_COLUMN_NAME||''' AND T1.TABLE_NAME = '''||V_TEXT_TABLA||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		IF V_NUM_TABLAS = 0 THEN
			V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
				ADD CONSTRAINT UK_ECO_OFR_ID UNIQUE ('||V_COLUMN_NAME||')';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'... Clave única creada para el campo '||V_COLUMN_NAME||'.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'... Ya tiene clave única para el campo '||V_COLUMN_NAME||'.');
		END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... no existe.');
	END IF; 
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');

	COMMIT;

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
EXIT