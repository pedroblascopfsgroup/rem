--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=recovery_correctivo
--## INCIDENCIA_LINK=BKREC-2381
--## PRODUCTO=NO
--##
--## Finalidad: Campos de la tarea "Celebración vista, registrar informe moratoria, registrar resolución"
--## INSTRUCCIONES: Relanzable
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION DD_PTP_PLAZOS_TAREAS_PLAZAS');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P413_RegistrarPresentacionEnHacienda'')';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''valores[''''P414_EntregarNuevoDecreto''''] == null ? (valores[''''P413_RegistrarPresentacionEnHacienda''''] == null ? 1*24*60*60*1000L : (valores[''''P413_RegistrarPresentacionEnHacienda''''][''''fechaPresentacion''''] == null ? 1*24*60*60*1000L 	: damePlazo(valores[''''P413_RegistrarPresentacionEnHacienda''''][''''fechaPresentacion''''])+10*24*60*60*1000L)) : (valores[''''P414_EntregarNuevoDecreto''''][''''fechaEnvio''''] == null ? 1*24*60*60*1000L : (damePlazo(valores[''''P414_EntregarNuevoDecreto''''][''''fechaEnvio''''])+1*24*60*60*1000L))'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P413_RegistrarPresentacionEnHacienda'')';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[FIN] DD_PTP_PLAZOS_TAREAS_PLAZAS  actualizado');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN] El plazo para esa tarea no existe');
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
