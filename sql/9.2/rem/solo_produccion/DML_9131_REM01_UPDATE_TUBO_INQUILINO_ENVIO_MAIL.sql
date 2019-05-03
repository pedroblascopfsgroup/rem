--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4118
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar email donde se reciben las ofertas de alquiler del tubo de inquilinos.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 CHAR);
        
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] Comienza el proceso de actualizacion del correo de tubo de inquilinos.');

    V_SQL:= ' UPDATE ' || V_ESQUEMA || '.TUBO_INQUILINO_ENVIO_MAIL
	      SET A = ''alquileres@haya.es'',
	      USUARIOMODIFICAR = ''REMVIP-4118'',
	      FECHAMODIFICAR = SYSDATE
	    ';		 

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se modifica el correo destinatario. '||SQL%ROWCOUNT||' registro actualizado.');

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Se ha terminado el proceso.');
 
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
