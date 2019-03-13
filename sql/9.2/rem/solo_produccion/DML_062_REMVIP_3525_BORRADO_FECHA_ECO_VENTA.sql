--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3525
--## PRODUCTO=NO
--##
--## Finalidad:  
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
    V_TABLA VARCHAR2(25 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3525';
    
    
 BEGIN

    		V_SQL := 'UPDATE REM01.ECO_EXPEDIENTE_COMERCIAL 
				   SET ECO_FECHA_VENTA = null,
				   USUARIOMODIFICAR = ''REMVIP-3525'',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE ECO_NUM_EXPEDIENTE IN (116060,
								116268,
								115711,
								115686,
								116402,
								128614,
								137046,
								137275,
								149927,
								150320,
								148913,
								110033,
								127093,
								135116,
								140245,
								148345,
								150192,
								104056,
								110750,
								116071,
								115685,
								131394,
								137242,
								143488,
								140662,
								134205,
								135719,
								125553,
								130557,
								146242,
								141111,
								137778,
								115664,
								126053,
								137777,
								115201,
								136311
								)';	  
	
  EXECUTE IMMEDIATE V_SQL;

 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

