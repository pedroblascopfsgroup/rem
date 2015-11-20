--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20151016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=PRODUCTO-180
--## PRODUCTO=SI
--##
--## Finalidad: Actualiza los campos de validacion de la tarea  PCO_RegistrarTomaDec
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
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RegistrarTomaDec'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_RegistrarTomaDec proc_a_iniciar');
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''cambio_proc'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RegistrarTomaDec'')';
    	EXECUTE IMMEDIATE V_SQL;

    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''fecha_envio_doc'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RegistrarTomaDec'')';

		EXECUTE IMMEDIATE V_SQL;
		
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''tipo_problema'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RegistrarTomaDec'')';

		EXECUTE IMMEDIATE V_SQL;
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''Tipo de problema en expediente'' WHERE  TFI_NOMBRE = ''tipo_problema'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RegistrarTomaDec'')';

		EXECUTE IMMEDIATE V_SQL;
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deberá consignar la fecha en la que recibe la documentación, en el campo “Documentación completa y correcta” deberá indicar si la documentación del expediente efectivamente es completa y correcta o no. En caso de no ser completa deberá indicar el problema detectado según sea por Documentos, Requerimientos, Liquidaciones o por requerir nueva documentación al cambiar el tipo de procedimiento a iniciar.</p><p style="margin-bottom: 10px">En el campo "Procedimiento propuesto por la entidad" se le indica el tipo de procedimiento propuesto por la entidad. En caso de estar de acuerdo con dicha propuesta de actuación, deberá consignar en el campo "Procedimiento a iniciar" el mismo tipo de procedimiento, en caso contrario, deberá seleccionar otro procedimiento según su criterio.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>Una vez rellene esta pantalla y en función de la información facilitada podrán darse las siguientes situaciones:</p><p style="margin-bottom: 10px"><li>En caso de haber encontrado un problema en la Documentación, liquidaciones o Requerimientos se iniciará la tarea “Revisar subsanación propuesta” a realizar por la entidad.</li><li>En caso de haber propuesto un cambio de procedimiento se iniciará la tarea “Validar cambio de procedimiento” a realizar por la entidad.</li><li>En caso de no haber encontrado error en la documentación y de haber seleccionado el mismo tipo de procedimiento que el comité se iniciará dicho procedimiento</li></p></div>'' WHERE  TFI_NOMBRE = ''titulo'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RegistrarTomaDec'')';

		EXECUTE IMMEDIATE V_SQL;
    END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_EnviarExpedienteLetrado'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez en disposición de toda la documentación requerida por el expediente de prelitigio, a través de esta pantalla deberá indicar la fecha en que procede al envío de dicha documentación al letrado correspondiente.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez complete esta tarea se dará por terminada la preparación documental del expediente de prelitigio, dando así inicio a la fase judicial.</p></div>'' WHERE  TFI_NOMBRE = ''titulo'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_EnviarExpedienteLetrado'')';

		EXECUTE IMMEDIATE V_SQL;	
	 END IF;
	 
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
    
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