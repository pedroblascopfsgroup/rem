--/*
--##########################################
--## AUTOR=Carlos Pérez
--## FECHA_CREACION=20160119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=CMREC-1834
--## PRODUCTO=NO
--## Finalidad: DML para actualizar las instrucciones de algunas tareas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

   
BEGIN
	
	V_SQL := 'select count(1) from cm01.tfi_tareas_form_items tfi inner join CM01.TAP_TAREA_PROCEDIMIENTO tap on tfi.tap_id = tap.tap_id where tap.tap_codigo = ''H031_ResolucionJudicial'' and tfi_nombre = ''titulo''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
					  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; registrar el estado en el que queda el convenio anticipado, para ello deber&aacute; abrir la pestaña "Convenios" de la ficha del asunto correspondiente e introducir el estado correcto en el campo "Estado" ya sea "Aprobaci&oacute;n judicial" o "No aprobado".</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; notificar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Anotaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pestaña "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pestaña "Recursos".</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; si el informe ha sido favorable "Registrar resoluci&oacute;n convenio" y en caso contrario se iniciar&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>''' ||
					  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
					  ' WHERE TAP_CODIGO = ''H031_ResolucionJudicial''' ||
					  ' AND BORRADO = 0)' ||
					  ' AND TFI_NOMBRE = ''titulo''';
		    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones actualizadas.');
		    
		    COMMIT;
     ELSE
	     DBMS_OUTPUT.PUT_LINE('[ERROR] No existe el registro a modificar.');
     END IF;
        
   
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
