--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20181213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5017
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: se cambia el label 'Fecha resolución' a 'Fecha sanción' en la tarea T015_ResolucionExpediente
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

BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	UPDATE #ESQUEMA#.TFI_TAREAS_FORM_ITEMS TFI SET
	    TFI.TFI_LABEL = 'Fecha sanción'
	    , TFI.USUARIOMODIFICAR = 'HREOS-5017'
	    , TFI.FECHAMODIFICAR = SYSDATE
	    , TFI.VERSION = VERSION + 1
	    WHERE TFI.TFI_ID = (SELECT TMP.TFI_ID FROM #ESQUEMA#.TFI_TAREAS_FORM_ITEMS TMP
	                        JOIN #ESQUEMA#.TAP_TAREA_PROCEDIMIENTO TAP ON TMP.TAP_ID = TAP.TAP_ID
	                        WHERE TAP.TAP_CODIGO = 'T015_ResolucionExpediente' AND TMP.TFI_NOMBRE = 'fechaResolucion');
	
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

