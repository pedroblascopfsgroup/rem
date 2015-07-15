--##########################################
--## Author: Roberto con ayuda de David Gilsanz
--## Finalidad: actualizar datos de clientes para que funcione Recovery por algún bug de la aplicación 
--## INSTRUCCIONES:  Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
declare
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	
	update cli_clientes set borrado=1;

	COMMIT;

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
exit