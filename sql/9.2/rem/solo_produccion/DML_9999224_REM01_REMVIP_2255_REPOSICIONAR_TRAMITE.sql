--/*
--##########################################
--## AUTOR=Ivan Castelló
--## FECHA_CREACION=20181015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2255
--## PRODUCTO=NO
--##
--## Finalidad: Reposicionar tramite
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2255';
    
    --ACT_NUM_ACTIVO NUMBER(16);
    
 BEGIN

	REM01.REPOSICIONAMIENTO_TRAMITE('REMVIP-2255','102094','PosicionamientoYFirma','102094','11',PL_OUTPUT);
        DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

 UPDATE ECO_EXPEDIENTE_COMERCIAL SET ECO_FECHA_ANULACION = NULL WHERE ECO_NUM_EXPEDIENTE = 102094;
  
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
