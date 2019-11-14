--/*
--##########################################
--## AUTOR=Lara Pablo Flores
--## FECHA_CREACION=20191030
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir valor default a ACT_CRG_CARGAS.CRG_IMPIDE_VENTA
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
    
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CRG_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CAMPO VARCHAR2(2400 CHAR) := 'CRG_IMPIDE_VENTA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_SQL_VALOR VARCHAR2(2400 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    
 

BEGIN
	

		
		--Comprobamos si existe foreign key FK_ACTIVO_GESTOR_PRECIO
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_TEXT_CAMPO||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] La columna CRG_IMPIDE_VENTA no existe.');		
		ELSE
			V_SQL := 'SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02''';
			EXECUTE IMMEDIATE V_SQL INTO V_SQL_VALOR;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_SQL_VALOR||'');
			
			IF V_SQL IS NOT NULL THEN
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET '||V_TEXT_CAMPO||' = '|| V_SQL_VALOR ||' WHERE '||V_TEXT_CAMPO||' IS NULL';
				EXECUTE IMMEDIATE V_MSQL;
				
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY (CRG_IMPIDE_VENTA DEFAULT '|| V_SQL_VALOR ||' NOT NULL)';
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CRG_IMPIDE_VENTA tiene valor por defecto No del diccionario DD_SIN_SINO');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe el valor adecuado para el diccionario ' ||V_ESQUEMA_M||'.DD_SIN_SINO');
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
