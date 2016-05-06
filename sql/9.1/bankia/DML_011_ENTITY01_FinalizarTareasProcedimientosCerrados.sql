--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=HR-1912
--## PRODUCTO=NO
--## Finalidad: Finalizar las tareas cuyo procedimiento esté en estado "Cerrado" p "Cancelado"
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** TAR_TAREAS_NOTIFICACIONES ********'); 
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET TAR_FECHA_FIN = SYSDATE, TAR_TAREA_FINALIZADA = 1' ||
		' WHERE TAR_FECHA_FIN IS NULL AND (TAR_TAREA_FINALIZADA = 0 OR TAR_TAREA_FINALIZADA IS NULL)' ||
		' AND PRC_ID IN (SELECT PRC_ID FROM ' ||V_ESQUEMA|| '.PRC_PROCEDIMIENTOS WHERE DD_EPR_ID IN'||
		' (SELECT DD_EPR_ID FROM ' ||V_ESQUEMA_M|| '.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO IN (''04'',''05'')))';

	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES');

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
