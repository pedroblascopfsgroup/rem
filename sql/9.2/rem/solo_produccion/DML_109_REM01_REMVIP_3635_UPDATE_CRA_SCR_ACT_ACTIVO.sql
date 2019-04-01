--/*
--##########################################
--## AUTOR=OSCAR DIESTRE PÉREZ
--## FECHA_CREACION=20190325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3635
--## PRODUCTO=NO
--##
--## Finalidad: Actualización ACT_ACTIVO. Cambia activos a cartera y subcartera Cajamar
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3635'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    
BEGIN	

	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
				 USING (
					SELECT AUX.ACT_NUM_ACTIVO_ANT
					FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_TANGO AUX
					WHERE 1 = 1
				       ) T2 
						ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO_ANT) 
						WHEN MATCHED THEN UPDATE SET 
							T1.DD_CRA_ID = 1,
							T1.DD_SCR_ID = 2

						'; 

	EXECUTE IMMEDIATE V_SQL;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] Activos cambiados de cartera y subcartera ');
		
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
