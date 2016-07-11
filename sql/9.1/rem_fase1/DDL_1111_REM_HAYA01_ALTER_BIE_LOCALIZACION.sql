--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Modificacion longitud LOC_PISO y LOC_PUERTA
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
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
 	table_count number(3); -- Vble. para validar la existencia de las Tablas.
 	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN
	
	-- Comprobamos si ya se ha añadido
	V_MSQL := '
	SELECT COUNT(1) 
	FROM ALL_TAB_COLUMNS 
	WHERE COLUMN_NAME= ''BIE_LOC_PISO'' 
	and DATA_TYPE = ''VARCHAR2'' 
	and TABLE_NAME=''BIE_LOCALIZACION'' 
	and CHAR_LENGTH = 11
	and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION.BIE_LOC_PISO... Ya está modificado');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.BIE_LOCALIZACION MODIFY BIE_LOC_PISO VARCHAR2(11 CHAR)';
		
		DBMS_OUTPUT.PUT('[INFO] BIE_LOCALIZACION.BIE_LOC_PISO: ALTERADO...');
		
		DBMS_OUTPUT.PUT_LINE('OK');
	END IF;
	
	-- Comprobamos si ya se ha añadido
	V_MSQL := '
	SELECT COUNT(1) 
	FROM ALL_TAB_COLUMNS 
	WHERE COLUMN_NAME= ''BIE_LOC_PUERTA'' 
	and DATA_TYPE = ''VARCHAR2'' 
	and TABLE_NAME=''BIE_LOCALIZACION'' 
	and CHAR_LENGTH = 17
	and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION.BIE_LOC_PUERTA... Ya está modificado');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.BIE_LOCALIZACION MODIFY BIE_LOC_PUERTA VARCHAR2(17 CHAR)';
		
		DBMS_OUTPUT.PUT('[INFO] BIE_LOCALIZACION.BIE_LOC_PUERTA: ALTERADO...');
		
		DBMS_OUTPUT.PUT_LINE('OK');
	END IF;
	
	
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
