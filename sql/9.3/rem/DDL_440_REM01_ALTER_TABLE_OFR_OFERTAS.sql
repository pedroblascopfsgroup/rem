--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20191004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7933
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-7933'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ALTER TABLA OFR_OFERTAS');
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''OFR_FECHA_RESOLUCIÓN_CES'' 
														 and TABLE_NAME = ''OFR_OFERTAS'' 
														 and OWNER = '''||V_ESQUEMA||'''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.OFR_OFERTAS
				   RENAME COLUMN OFR_FECHA_RESOLUCIÓN_CES TO OFR_FECHA_RESOLUCION_CES';
		
		EXECUTE IMMEDIATE V_MSQL;
			
		DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA MODIFICADA');	
	
	ELSE 
		
		DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA OFR_OFERTAS.OFR_FECHA_RESOLUCIÓN_CES NO EXISTE');
		
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZAR OFR_OFERTAS');
 
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
