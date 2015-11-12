--/*
--##########################################
--## AUTOR=Nacho Arcos
--## FECHA_CREACION=20151103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.10-hy-rc01
--## INCIDENCIA_LINK=HR-1457
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar validación de la tarea Seleccionar Procedimiento.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
   
BEGIN
	
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''asuntoConLetrado() ? (asuntoConcursalConGestorExpJudicial() ? (asuntoConcursalConSupExpJudicial() ? null :''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe asignar un supervisor de expediente judicial al asunto desde la pesta&ntilde;a de gestores del asunto.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe asignar un gestor de expediente judicial al asunto desde la pesta&ntilde;a de gestores del asunto.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe asignar un letrado al asunto desde la pesta&ntilde;a de gestores del asunto.</div>''''''' ||
			  ' WHERE TAP_CODIGO = ''H067_seleccionarProcedimiento''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando la validacion de la tarea Seleccionar Procedimiento');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Validacion tarea actualizado.');
    
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
	
EXCEPTION
     
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT; 
