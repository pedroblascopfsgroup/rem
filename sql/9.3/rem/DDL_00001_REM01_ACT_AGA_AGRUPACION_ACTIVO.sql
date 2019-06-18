--/*
--##########################################
--## AUTOR=Juan Angel Sánchez
--## FECHA_CREACION=20190504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6363
--## PRODUCTO=NO
--## Finalidad: Añadimos columna ACT_AGA_ID_PRINEX_HPM
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--## 		0.2 Cambiar tipo columna ACT_AGA_ID_PRINEX_HPM de Number a Varchar2
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

    V_TEXT1 VARCHAR2(2400 CHAR) := 'ID Prinex HPM'; -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_AGA_AGRUPACION_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.    
    
    
BEGIN
	
	-- Comprobamos si existe columna DD_SCR_ID (si es así, no hacemos nada)
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''ACT_AGA_ID_PRINEX_HPM'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_AGA_ID_PRINEX_HPM... Ya existe');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA|| ' SET ACT_AGA_ID_PRINEX_HPM = '''' ';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ... ACT_AGA_ID_PRINEX_HPM Columna BORRADA en tabla');
			
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   MODIFY ACT_AGA_ID_PRINEX_HPM VARCHAR2(20 CHAR)
			';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ... Columna ACT_AGA_ID_PRINEX_HPM MODIFICADA en tabla, con tipo VARCHAR2(20 CHAR) ');
	ELSE
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''ACT_AGA_ID_PRINEX_HPM'' and DATA_TYPE = ''VARCHAR2'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS = 0 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (ACT_AGA_ID_PRINEX_HPM VARCHAR2(20 CHAR))';	
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_AGA_ID_PRINEX_HPM... Creado');
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_AGA_ID_PRINEX_HPM IS '''||V_TEXT1||'''  ';
			DBMS_OUTPUT.PUT_LINE('[INFO] ... ACT_AGA_ID_PRINEX_HPM Columna CREADA en la tabla');
		ELSE
		 	DBMS_OUTPUT.PUT_LINE('[INFO] ... ACT_AGA_ID_PRINEX_HPM Columna ya existe en la tabla');
		END IF;
	END IF;


	
	EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;          

END;

/

EXIT
