--##########################################
--## Author: Roberto
--## Finalidad: DML para actualizar los passwords de los usuarios de prueba
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.	    
			    
BEGIN	  
	
	update HAYAMASTER.usu_usuarios set usu_password='HREMAD1234', usu_nombre=usu_nombre||'_H' where usu_username like '%_H';
	
	update HAYAMASTER.usu_usuarios set usu_password='HREVLC1234', usu_nombre=usu_nombre||'_V' where usu_username like '%_V' and usu_username not in ('XPCIERV');
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('El proceso ha finalizado correctamente.');
	
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