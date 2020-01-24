--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20191209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-8782
--## PRODUCTO=NO
--##
--## Finalidad: Script que pone valores a los campos fechacrear y usuariocrear que tienen NULL.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TABLA VARCHAR2(30 CHAR) := 'TAC_TAREAS_ACTIVOS';  -- Tabla a modificar
  V_USR VARCHAR2(30 CHAR) := 'HREOS-8782'; -- USUARIOCREAR/USUARIOMODIFICAR


BEGIN
  
  
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comprovaciones previas...');
  -- Verificar si la tabla existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = upper('''||V_ESQUEMA||''')';
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  IF V_NUM_TABLAS = 1 THEN
    
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla ' ||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');  

  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR IS NULL';
  	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a modificar '||V_NUM_TABLAS||' valores...');
  	
  	IF V_NUM_TABLAS > 0 THEN
    	
		EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
	        	SET 
				USUARIOCREAR = '''||V_USR||''',
	 	    	FECHACREAR = SYSDATE
				WHERE USUARIOCREAR IS NULL 
	         	';
	ELSE
	    DBMS_OUTPUT.PUT_LINE('[INFO] No hay registros para modificar en ' ||V_ESQUEMA|| '.'||V_TABLA);
	END IF;
          
    COMMIT;
    
  ELSE
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TABLA||'... No existe.');
  END IF;
    
  DBMS_OUTPUT.PUT_LINE('[FIN]');    

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

EXIT;

