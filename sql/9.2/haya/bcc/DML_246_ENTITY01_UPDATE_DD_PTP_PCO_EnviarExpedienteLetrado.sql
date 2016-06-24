--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20160624
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2087
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

	VN_COUNT NUMBER;
	VN_TAP_ID NUMBER;

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
  -- Necesitamos el TAP id de la Tarea
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp''';
	EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
	DBMS_OUTPUT.PUT_LINE('[INFO] Buscamos el TAP_ID de PCO_SubsanarIncidenciaExp');
  IF VN_COUNT > 0 THEN
		V_SQL := 'SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'' AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO VN_TAP_ID;
		DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado TAP_ID: '||VN_TAP_ID||'');
    
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
				SET DD_PTP_PLAZO_SCRIPT = ''
				valores[''''PCO_EnviarExpedienteLetrado''''] != null && [''''PCO_EnviarExpedienteLetrado''''][''''fecha_envio''''] != null && [''''PCO_EnviarExpedienteLetrado''''][''''fecha_envio''''] != '''''''' ? damePlazo(valores[''''PCO_EnviarExpedienteLetrado''''][''''fecha_envio''''])+10*24*60*60*1000L : 10*24*60*60*1000L''
				WHERE TAP_ID = 10000000004176';
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] Actulizado DD_PTP_PLAZOS_TAREAS_PLAZAS');
  END IF;

	COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');
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
