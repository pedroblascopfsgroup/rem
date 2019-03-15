--/*
--##########################################
--## AUTOR=Sonia Garcia
--## FECHA_CREACION=20190315
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5823
--## PRODUCTO=NO
--## Finalidad: Añadimos a la tabla de diccionario DD_GRF_GESTORIA_RECEP_FICH los campos que asignan a una gestoria el nombre de usuario (username) de tipo gestor de gestoría de plusvalía y postventa.
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
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_GRF_GESTORIA_RECEP_FICH'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar las valoraciones de los activos.'; -- Vble. para los comentarios de las tablas

    V_TABLA_FK VARCHAR2(40 CHAR) := '';

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Vamos a incluir nuevos campos.');

	-- Comprobamos si existe la tabla a incluir nuevos campos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Seguimos la ejecución.');
		
		-- Comprobamos si existe columna USERNAME_GTOPOSTV
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE UPPER(COLUMN_NAME)= ''USERNAME_GTOPOSTV'' and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.USERNAME_GTOPOSTV... Ya existe en la tabla');
		ELSE
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (USERNAME_GTOPOSTV VARCHAR2(50 CHAR))';	
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.USERNAME_GTOPOSTV... Creado');
		END IF;


		-- Comprobamos si existe columna USERNAME_GTOPLUS
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE UPPER(COLUMN_NAME)= ''USERNAME_GTOPLUS'' and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.USERNAME_GTOPLUS... Ya existe en la tabla');
		ELSE
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (USERNAME_GTOPLUS VARCHAR2(50 CHAR))';	
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.USERNAME_GTOPLUS... Creado');
		END IF;


	ELSE 
		DBMS_OUTPUT.PUT_LINE('[ALERT] ' || V_ESQUEMA || '.'||V_TABLA||'... La tabla no existe. No podemos incluir los nuevos campos.');
	END IF;
	

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
