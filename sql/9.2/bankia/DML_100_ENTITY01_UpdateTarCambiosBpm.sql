--/*
--##########################################
--## AUTOR=Carlos Martos
--## FECHA_CREACION=20160624
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-16
--## PRODUCTO=NO
--## Finalidad: DML - Finaliza las tareas que tengan el t.gestion de llaves en el punto de tareas que van a desaparecer
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** TAR_TAREAS_NOTIFICACIONES ********');

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES... Comprobaciones previas para las tareas a actualizar'); 

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES ' ||
		'WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA ' ||
			'WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '||
				'WHERE TAP_CODIGO = ''P417_RegistrarRecepcionLlaves'' OR TAP_CODIGO = ''P417_RegistrarRecepcionLlavesDepFinal'' OR TAP_CODIGO = ''P417_RegistrarEnvioLlavesDepFinal'')) ' ||
			'AND (TAR_TAREA_FINALIZADA = 0 OR TAR_TAREA_FINALIZADA IS NULL)';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET TAR_TAREA_FINALIZADA = 1, TAR_FECHA_FIN = sysdate, BORRADO = 1, USUARIOMODIFICAR = ''RECOVERY-16'', FECHAMODIFICAR = sysdate  ' ||
    		'WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA ' ||
    			'WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO ' ||
    				'WHERE TAP_CODIGO = ''P417_RegistrarRecepcionLlaves'' OR TAP_CODIGO = ''P417_RegistrarRecepcionLlavesDepFinal'' OR TAP_CODIGO = ''P417_RegistrarEnvioLlavesDepFinal'')) ' ||
				'AND (TAR_TAREA_FINALIZADA = 0 OR TAR_TAREA_FINALIZADA IS NULL)';
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Las tareas que intenta actualizar ya han sido actualizadas');
	END IF;
	
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
