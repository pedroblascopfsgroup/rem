--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190208
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3315
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar comisionamiento
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
    V_TABLA VARCHAR2(32 CHAR):= 'TRF_TTR_PRC_HONORAR_TRAMOS';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3315';
 
 BEGIN

 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
 			  SET TTR_PRC_PRESC = 2.25 
			  WHERE TTR_ID = 2';

 EXECUTE IMMEDIATE V_SQL;

 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
 			  SET TTR_PRC_PRESC = 1.5 
			  WHERE TTR_ID = 4';

 EXECUTE IMMEDIATE V_SQL;

 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
 			  SET TTR_PRC_COLAB = 0.6  
			  WHERE TTR_ID = 2';

 EXECUTE IMMEDIATE V_SQL;

 DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS');
 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
