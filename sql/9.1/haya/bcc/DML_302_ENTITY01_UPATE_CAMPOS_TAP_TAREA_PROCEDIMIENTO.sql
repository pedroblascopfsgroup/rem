--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20151104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc11
--## INCIDENCIA_LINK=CMREC-982
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza los campos de validacion de la tareas
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarExpedientePreparar'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_SCRIPT_DECISION PCO_RevisarExpedientePreparar');

    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''PCO_RevisarExpedientePreparar''''][''''agencia_externa''''] == DDSiNo.SI ? ''''fin'''': ''''judicializar'''' ''
					, TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''PCO_RevisarExpedientePreparar''''][''''agencia_externa'''']==DDSiNo.NO && noExisteGestorDocumentacionAsignadoAsunto() ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">En caso de indicar Agencia Externa NO, para completar la tarea debera haber un gestor de la documentación asignado al asunto'''' : null ''
					WHERE TAP_CODIGO = ''PCO_RevisarExpedientePreparar'' ';
					
		EXECUTE IMMEDIATE V_SQL;
		
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_AsignarGestorLiquidacion'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_SCRIPT_DECISION PCO_AsignarGestorLiquidacion');

    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteGestorLiquidacion() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea el asunto debe de tener asignado el tipo de gestor Gestor de liquidación.</div>'''' ''
					WHERE TAP_CODIGO = ''PCO_AsignarGestorLiquidacion'' ';

		EXECUTE IMMEDIATE V_SQL;
		
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarExpedienteAsignarLetrado'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_SCRIPT_DECISION PCO_RevisarExpedienteAsignarLetrado');

    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''PCO_RevisarExpedienteAsignarLetrado''''][''''expediente_correcto''''] == DDSiNo.NO ? ''''reabreExp'''': ''''registrar'''' ''
					, TAP_SCRIPT_VALIDACION = ''comprobarExisteLetrado() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea deberá haber un letrado asignado al asunto.</div>'''' ''
					WHERE TAP_CODIGO = ''PCO_RevisarExpedienteAsignarLetrado'' ';

		EXECUTE IMMEDIATE V_SQL;
		
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );
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