--/*
--##########################################
--## AUTOR=rlb
--## FECHA_CREACION=20190305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-xxx
--## PRODUCTO=NO
--##
--## Finalidad: Borrar trigger
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
    --V_TABLA VARCHAR2(25 CHAR):= 'ACT_SPS_SIT_POSESORIA';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 CHAR);
	--V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-172';
    
    --ACT_NUM_ACTIVO NUMBER(16);

   SOLICITA_RESERVA VARCHAR2(50 CHAR);
   TCC_DESC VARCHAR2(50 CHAR);
   PLAZO_FIRMA VARCHAR2(50 CHAR);
   IMPORTE_RESERVA VARCHAR2(50 CHAR); 
    
 BEGIN

    V_SQL := 'DROP TRIGGER '||V_ESQUEMA||'.AUDIT_ACT_APU_ACTPUB';

    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('TRIGGER BORRADO');
  
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
