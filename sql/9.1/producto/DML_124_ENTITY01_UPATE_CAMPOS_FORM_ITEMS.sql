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
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarSubsanacion'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_RevisarSubsanacion subsanar');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''Subsanar'', TFI_VALOR_INICIAL = '''' WHERE  TFI_NOMBRE = ''subsanar'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarSubsanacion'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = '''' WHERE  TFI_NOMBRE = ''titulo'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarSubsanacion'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''valores[''''PCO_RegistrarTomaDec''''][''''observaciones'''']'' WHERE  TFI_NOMBRE = ''observaciones_letrado'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarSubsanacion'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = '''' WHERE  TFI_NOMBRE = ''fecha_revision'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarSubsanacion'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = '''' WHERE  TFI_NOMBRE = ''observaciones'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarSubsanacion'')';
    	EXECUTE IMMEDIATE V_SQL;
    	

    END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarSubsanacionCONC'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_RevisarSubsanacionCONC subsanar');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''Subsanar'' WHERE  TFI_NOMBRE = ''subsanar'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarSubsanacionCONC'')';
    	EXECUTE IMMEDIATE V_SQL;

    END IF;
    
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = '''' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''valores[''''PCO_RegistrarTomaDec''''][''''observaciones'''']'' WHERE  TFI_NOMBRE = ''observaciones_letrado'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''valores[''''PCO_RegistrarTomaDec''''][''''tipo_problema'''']'', TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''', TFI_BUSINESS_OPERATION = ''DDTipoProblemaDocPco''  WHERE  TFI_NOMBRE = ''tipo_problema'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = '''', TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' WHERE TFI_NOMBRE = ''fecha_exp_sub'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = '''' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = ''Subsanar incidencia de expediente'' WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'' ';
    	EXECUTE IMMEDIATE V_SQL;

    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacion'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_RevisarNoAceptacion');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''anterior_letrado'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacion'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''nuevo_letrado'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacion'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''asignacion_correcta'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacion'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_ValidarCambioProc'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_ValidarCambioProc');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' WHERE TFI_NOMBRE = ''cambio_aceptado'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_ValidarCambioProc'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacionPost'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_TAREA_PROCEDIMIENTO PCO_RevisarNoAceptacionPost');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/precontencioso/tramite/revisarNoAceptacion'' WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacionPost'' ';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''anterior_letrado'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacionPost'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''nuevo_letrado'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacionPost'')';
    	EXECUTE IMMEDIATE V_SQL;
    	
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TFI_NOMBRE = ''asignacion_correcta'' AND TAP_ID =  ' || 
      		'(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RevisarNoAceptacionPost'')';
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