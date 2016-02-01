--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20151229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc35
--## INCIDENCIA_LINK=CMREC-1676
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Se actualiza la fecha de fin de vigencia de la contraseña y la contraseña a todos los usuarios
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** USU_USUARIOS ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.USU_USUARIOS... Inicio de la actualización'); 

	V_SQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_PASSWORD = ''1234'', USU_FECHA_VIGENCIA_PASS = TO_DATE(''31/12/9999'', ''dd/mm/yyyy''), USUARIOMODIFICAR = ''CMREC-1676'', FECHAMODIFICAR = SYSDATE';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;
    	
	DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.USU_USUARIOS... Fin de la actualización'); 
	
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

EXIT;
