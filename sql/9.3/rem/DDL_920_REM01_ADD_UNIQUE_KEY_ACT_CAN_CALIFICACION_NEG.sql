--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20191126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8607
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar el defecto inscripción.
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

    V_TABLA3 VARCHAR2(50 CHAR) := 'ACT_CAN_CALIFICACION_NEG';

    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar


BEGIN

		
	-----------------------------------------------------------------------------------------------------------
	------------------- 		CREACION TABLA ACT_CAN_CALIFICACION_NEG  	-----------------------------------
	-----------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA3||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA3||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		
		V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TABLA3||''' and owner = '''||V_ESQUEMA||''' and constraint_name=''UK_ACT_CAN_CALIFICACION_NEG''';
		
		IF V_NUM_TABLAS = 1 THEN
		-- Creamos primary key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA3||' DROP CONSTRAINT UK_'||V_TABLA3||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.UK_'||V_TABLA3||'... UK borrada.');
			
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA3||' ADD (CONSTRAINT UK_'||V_TABLA3||'_V2 UNIQUE (ACT_ID,DD_MCN_ID,DD_CAN_ID,BORRADO, AHT_ID))';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.UK_'||V_TABLA3||'_V2... UK creada.');
		
		END IF;
	
	
	END IF;
	-- Comprobamos si existe la secuencia
		
	
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
