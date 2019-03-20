--/* 
--##########################################
--## AUTOR=Sonia Garcia Mochales
--## FECHA_CREACION=20190305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=func-rem-alquileres
--## INCIDENCIA_LINK=HREOS-5684
--## PRODUCTO=NO
--##
--## Finalidad:  Cambio tamaño Cuerpo en la tabla ENVIO_MAIL_CONTRATO_ALQUILER.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial 
--##########################################
--*/

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

    V_TABLA VARCHAR2(2400 CHAR) := 'ENVIO_MAIL_CONTRATO_ALQUILER'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COLUMN VARCHAR2(2400 CHAR) := 'CUERPO'; -- Vble. auxiliar para almacenar el nombre de la columna a modificar.
    V_NEW_TYPE VARCHAR2(4000 CHAR) := 'VARCHAR2(4000 CHAR) '; -- Vble. auxiliar para almacenar nuevo tipo de dato de la columna a modificar.

BEGIN
	
	-- Comprobamos si existe la tabla  
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Seguimos la ejecución.');

	
		-- Comprobamos si existe columna CUERPO
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COLUMN||'''';
        	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
         
	
		IF V_NUM_TABLAS = 0 THEN
			
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.' || V_COLUMN ||'... Columna no existe en la tabla y no se puede modificar');
           
			ELSE
			          	 
           		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY (' || V_COLUMN ||' ' || V_NEW_TYPE ||')';	
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'|| V_COLUMN ||'... Modificado');
            
		END IF;

	ELSE 
		DBMS_OUTPUT.PUT_LINE('[ALERT] ' || V_ESQUEMA || '.'||V_TABLA||'... La tabla no existe. No podemos incluir los nuevos campos.');
	END IF;
DBMS_OUTPUT.PUT_LINE('[FIN CAMPOS]');

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

EXIT;
