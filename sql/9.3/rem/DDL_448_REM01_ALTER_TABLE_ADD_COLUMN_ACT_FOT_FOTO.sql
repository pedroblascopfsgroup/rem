--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8002
--## PRODUCTO=NO
--## Finalidad: Campo nuevo para gestionar id de descripcion foto
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'ACT_FOT_FOTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	-- Verificar si la tabla ya existe.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

	-- Si existe la tabla
	IF V_COUNT = 1 THEN

		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''DD_DFA_ID'' AND TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

		-- Si existe la tabla
		IF V_COUNT = 1 THEN

			DBMS_OUTPUT.PUT_LINE('AÑADIR NUEVO CAMPO EN '||V_TEXT_TABLA||''); 

			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD DD_DFA_ID NUMBER(16)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('CAMPO AÑADIDO EN '||V_TEXT_TABLA||': DD_DFA_ID'); 

			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_DFA_ID FOREIGN KEY (DD_DFA_ID)
					REFERENCES '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO(DD_DFA_ID) ON DELETE SET NULL ENABLE';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('CONSTRAINT FK_DD_DFA_ID CREADA EN '||V_TEXT_TABLA||''); 

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_DFA_ID IS ''FK referenciada a ID descripcion foto''';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('COMENTARIO AÑADIDO EN NUEVO CAMPO DE '||V_TEXT_TABLA||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('CAMPO DD_DFA_ID YA EXISTE EN '||V_TEXT_TABLA||''); 

		END IF;
	
	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... No existe.');

	END IF; 
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' CREADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN 
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



