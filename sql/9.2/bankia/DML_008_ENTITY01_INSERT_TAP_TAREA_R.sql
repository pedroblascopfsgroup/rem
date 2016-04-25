--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.3
--## INCIDENCIA_LINK=BKREC-1598
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
-- P32_BPMtramiteArchivo
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P32_BPMtramiteArchivo''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la tarea P32_BPMtramiteArchivo');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE) VALUES('||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, (select DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=''P32''), ''P32_BPMtramiteArchivo'', (select DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=''P33''), 0, ''Se inicia el Tr&aacute;mite de archivo'', 0, ''DD'', SYSDATE, 0, (select DD_FAP_ID from '||V_ESQUEMA||'.DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO=''01''), ''EXTTareaProcedimiento'')';
	  	EXECUTE IMMEDIATE V_MSQL;

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, (SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''P32_BPMtramiteArchivo''), ''300*24*60*60*1000L'', 0, ''DD'', SYSDATE, 0)';
	  	EXECUTE IMMEDIATE V_MSQL;

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P32_BPMtramiteArchivo''), 0, ''label'', ''titulo'', ''Se inicia el Tr&aacute;mite de archivo'', 0, ''DD'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('Tarea P32_BPMtramiteArchivo insertada');
	END IF;
	
-- P32_transformacionAbreviado	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P32_transformacionAbreviado''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la tarea P32_transformacionAbreviado');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, DD_FAP_ID, DD_STA_ID, DTYPE) Values ('||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=''P32''), ''P32_transformacionAbreviado'', 0, ''Auto de transformación en abreviado o declaración de falta o sobreseimiento'', ''valores[''''P32_transformacionAbreviado''''][''''comboTransformacion''''] == ''''1'''' ? ''''abreviado'''' : ''''noAbreviado'''''', 0, ''DD'', SYSDATE, 0, ''tareaExterna.cancelarTarea'', (select DD_FAP_ID from '||V_ESQUEMA||'.DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO=''01''), (select DD_STA_ID from '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO=''39''), ''EXTTareaProcedimiento'')';
	  	EXECUTE IMMEDIATE V_MSQL;

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P32_transformacionAbreviado''), ''damePlazo(valores[''''P32_declaracionImputados''''][''''fecha'''']) + 60*24*60*60*1000L'', 0, ''DD'', SYSDATE, 0)';
	  	EXECUTE IMMEDIATE V_MSQL;

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P32_transformacionAbreviado''), 0, ''label'', ''titulo'', ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&'||'aacute; indicar la fecha en la que se nos notifica la fecha del auto de transformaci&oacute;n, as&iacute; como indicar si se ha declarado por el juzgado o si se ha declarado falta o el sobreseimiento del proceso y se continua por el procedimineto abreviado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, si se ha indicado Abreviado &quot;Escrito calificaci&oacute;n provisional&quot;. y si se ha indicado Falta o sobreseimiento se lanza autom&aacute;ticamente el T. de recurso de reforma o apelaci&oacute;n.</p></div>'', 0, ''DD'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P32_transformacionAbreviado''), 1, ''date'', ''fecha'', ''Fecha'', ''valor != null && valor != '''''''' ? true : false'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', 0, ''DD'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P32_transformacionAbreviado''), 2, ''combo'', ''comboTransformacion'', ''Resultado'', ''DDAutoTransformacion'', ''valor != null && valor != '''''''' ? true : false'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', 0, ''DD'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P32_transformacionAbreviado''), 3, ''textarea'', ''observaciones'', ''Observaciones'', 0, ''DD'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('Tarea P32_transformacionAbreviado insertada');
	END IF;

-- P32_BPMtramiteArchivo_2
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P32_BPMtramiteArchivo_2''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la tarea P32_BPMtramiteArchivo_2');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE) Values ('||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=''P32''), ''P32_BPMtramiteArchivo_2'', (select DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=''P33''), 0, ''Se inicia Tr&aacute;mite de recurso de reforma o apelaci&oacute;n'', 0, ''DD'', SYSDATE, 0, (select DD_FAP_ID from '||V_ESQUEMA||'.DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO=''01''), ''EXTTareaProcedimiento'')';
	  	EXECUTE IMMEDIATE V_MSQL;

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P32_BPMtramiteArchivo_2''), ''300*24*60*60*1000L'', 0, ''DD'', SYSDATE, 0)';
	  	EXECUTE IMMEDIATE V_MSQL;

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values ('||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P32_BPMtramiteArchivo_2''), 0, ''label'', ''titulo'', ''Se inicia Tr&aacute;mite de recurso de reforma o apelaci&oacute;n'', 0, ''DD'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('Tarea P32_BPMtramiteArchivo_2 insertada');
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
  	