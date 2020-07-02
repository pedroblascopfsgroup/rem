--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7589
--## PRODUCTO=NO
--##
--## Finalidad: crear tramite y cambiar comite
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    PL_OUTPUT VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-7589';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	
	V_MSQL := 'UPDATE COM_COMPRADOR 
				SET COM_NOMBRE = ''Luis Enrique'',
				    COM_APELLIDOS = ''Galiani Castro'',
				    COM_EMAIL = ''kavero20002002@yahoo.com'',
				    COM_DIRECCION = ''CL Miraalparque 13, pta A, plta 4'',
				    USUARIOMODIFICAR = '',
				    FECHAMODIFICAR = SYSDATE
				WHERE COM_DOCUMENTO = ''54393892L''';
    EXECUTE IMMEDIATE V_MSQL;
    
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