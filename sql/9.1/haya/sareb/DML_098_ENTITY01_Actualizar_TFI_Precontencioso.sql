--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-352
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
   
BEGIN
	
	-- Tareas PCO_RegistrarAceptacion y PCO_RegistrarAceptacionPost
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar si acepta el Asunto asignado por la entidad o no. En el campo "Conflicto de intereses" deber&aacute; informar la existencia de conflicto o no, que le impida aceptar la direcci&oacute;n de la acci&oacute;n a instar, en caso de que haya conflicto de intereses no se le permitir&aacute; la aceptaci&oacute;n del Asunto. En el campo "Aceptaci&oacute;n del asunto" deber&aacute; indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deber&aacute; marcar, en todo caso, la no aceptaci&oacute;n del asunto".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto".</p></div>''' ||
			  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
			  ' WHERE TAP_CODIGO in (''PCO_RegistrarAceptacion'', ''PCO_RegistrarAceptacionPost'')' ||
			  ' AND BORRADO = 0)' ||
			  ' AND TFI_NOMBRE = ''titulo''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones de PCO_RegistrarAceptacion y PCO_RegistrarAceptacionPost actualizadas.');
   
    -- Tarea PCO_RegistrarTomaDec
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; consignar la fecha en la que recibe la documentaci&oacute;n, en el campo “Confirmar documentaci&oacute;n y procedimiento” deber&aacute; indicar si el procedimiento a iniciar es el correcto y si la documentaci&oacute;n del expediente efectivamente es completa y correcta o no. En caso de no ser todo correcto deber&aacute; indicar el problema detectado seg&uacute;n sea por Documentos, Requerimientos, Liquidaciones o por requerir nueva documentaci&oacute;n al cambiar el tipo de procedimiento a iniciar.</p><p style="margin-bottom: 10px">En el campo "Procedimiento propuesto por la entidad" se le indica el tipo de procedimiento propuesto por la entidad. En caso de estar de acuerdo con dicha propuesta de actuaci&oacute;n, deber&aacute; consignar en el campo "Procedimiento a iniciar" el mismo tipo de procedimiento, en caso contrario, deber&aacute; seleccionar otro procedimiento seg&uacute;n su criterio.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en funci&oacute;n de la informaci&oacute;n facilitada podr&aacute;n darse las siguientes situaciones:</p><p style="margin-bottom: 10px"><ul><li>En caso de haber encontrado un problema en la Documentaci&oacute;n, liquidaciones o Requerimientos se iniciar&aacute; la tarea “Revisar subsanaci&oacute;n propuesta” a realizar por la entidad.</li><li>En caso de haber propuesto un cambio de procedimiento se iniciar&aacute; la tarea “Validar cambio de procedimiento” a realizar por la entidad.</li><li>En caso de no haber encontrado error en la documentaci&oacute;n y de haber seleccionado el mismo tipo de procedimiento que el comit&eacute; se iniciar&aacute; dicho procedimiento</ul></div>''' ||
			  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
			  ' WHERE TAP_CODIGO in (''PCO_RegistrarTomaDec'')' ||
			  ' AND BORRADO = 0)' ||
			  ' AND TFI_NOMBRE = ''titulo''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones de PCO_RegistrarTomaDec actualizadas.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''Confirmar documentación y procedimiento''' ||
			  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
			  ' WHERE TAP_CODIGO in (''PCO_RegistrarTomaDec'')' ||
			  ' AND BORRADO = 0)' ||
			  ' AND TFI_NOMBRE = ''correcto''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Combo documentación de PCO_RegistrarTomaDec actualizadas.');
 
    -- Tareas PCO_RevisarNoAceptacion y PCO_RevisarNoAceptacionPost
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea debe validar la asignaci&oacute;n de letrado. En caso de no serlo, por favor, reasigne convenientemente a trav&eacute;s de la pestaña Gestores del Asunto.</p><p style="margin-bottom: 10px">En el campo Fecha de validaci&oacute;n, indicaremos la fecha en la que validamos la asignaci&oacute;n del letrado del Asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>''' ||
			  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
			  ' WHERE TAP_CODIGO in (''PCO_RevisarNoAceptacion'', ''PCO_RevisarNoAceptacionPost'' )' ||
			  ' AND BORRADO = 0)' ||
			  ' AND TFI_NOMBRE = ''titulo''';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones de PCO_RevisarNoAceptacion y PCO_RevisarNoAceptacionPost actualizadas.');
  
  	-- Tarea H009_RegistrarPublicacionBOE  
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; revisar los datos que aparecen rellenados respecto al nuevo concurso e informar aquellos datos que aparecen vac&iacute;os. Opcionalmente puede informar los datos de contacto de los administradores concursales designados.</p><p style="margin-bottom: 10px">En el campo observaciones infomar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, se iniciar&aacute; el tr&aacute;mite de Preparaci&oacute;n del expediente judicial y se lanzar&aacute; la tarea "Registrar insinuaci&oacute;n de cr&eacute;ditos" del Tr&aacute;mite de Fase Com&uacute;n Haya.</p></div>''' ||
			  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
			  ' WHERE TAP_CODIGO in (''H009_RegistrarPublicacionBOE'')' ||
			  ' AND BORRADO = 0)' ||
			  ' AND TFI_NOMBRE = ''titulo''';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones de H009_RegistrarPublicacionBOE actualizadas.');
   
    -- Tarea PCO_EnviarExpedienteLetrado
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez en disposici&oacute;n de toda la documentaci&oacute;n requerida por el expediente de prelitigio, a trav&eacute;s de esta pantalla deber&aacute; indicar la fecha en que procede al env&iacute;o de dicha documentaci&oacute;n al letrado correspondiente.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez complete esta tarea,  se lanzar&aacute; la tarea “Confirmar documentaci&oacute;n y procedimiento”.</p></div>''' ||
			  ' WHERE TAP_ID in (SELECT TAP_ID FROM ' ||V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO' ||
			  ' WHERE TAP_CODIGO in (''PCO_EnviarExpedienteLetrado'')' ||
			  ' AND BORRADO = 0)' ||
			  ' AND TFI_NOMBRE = ''titulo''';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Instrucciones de PCO_EnviarExpedienteLetrado actualizadas.');
        
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
