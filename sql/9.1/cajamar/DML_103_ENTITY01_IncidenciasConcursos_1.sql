--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20150802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Concursos
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-726');
	V_TAREA:='CJ004_RevisarDocumentacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar:</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la de la tasaci&oacute;n de cada uno de los bienes. En caso de que sea superior a 6 meses solicite una nueva tasaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la certificaci&oacute;n de cargas de cada uno de los bienes en la ficha del bien. En caso de que tengan una antigüedad superior a 3 meses, solicite las notas simples actualizadas.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si es necesario el informe fiscal en cuyo caso deber&aacute; solicitarlo.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si es necesario solicitar un informe a la oficina sobre la situaci&oacute;n del acreditado, en cuyo caso deber&aacute; solicitarlo.</p><p style="margin-bottom: 10px">A trav&eacute;s del bot&oacute;n "Notificaci&oacute;n" deber&aacute; notificar a la oficina el se&ntilde;alamiento de subasta y los bienes a subastar.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; se&ntilde;alar la fecha en la que hace esta revisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Preparar informe de subasta" y adem&aacute;s:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjuntar tasaciones"</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si solicita informe fiscal, se lanzar&aacute; la tarea "Adjuntar informe fiscal"</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si solicita informe de la oficina, se lanzar&aacute; la tarea "Adjuntar informe oficina" a la oficina.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='CJ004_AdjuntarTasaciones';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá actualizar la información en la ficha del "Bien"  de cada uno de los bienes de la subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-726');
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-724');
	V_TAREA:='H033_presentarObs';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar la fecha de presentaci&oacute;n de las observaciones al plan de liquidaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar auto aprobando plan de liquidación".</p></div>''' ||
	  ' WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='CJ004_AdjuntarTasaciones';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-724');
	
	-- BORRADO DE TAREA (lógico) TRAMITE SUBASTA CONCURSAL
	V_TAREA:='H003_LecturaAceptacionInstrucciones';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_H003_LecturaAcepInstru'',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-707');
	V_TAREA:='H031_registrarPropAnticipadaConvenio';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H031_PrepararInforme';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''comboAtribuciones'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H031_ElevarAComite';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H031_RegistrarRespuestaComite';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''comboResultado'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H031_EscritoEvaluacion';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''comboResultado'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	V_TAREA:='H031_ResolucionJudicial';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''fecha'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio''' ||
	  ' ,TFI_VALIDACION=''valor != null && valor != '''''''' ? true : false''' ||
	  ' WHERE TFI_NOMBRE=''comboRatificacion'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-707');

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-731');
	V_TAREA:='H031_EscritoEvaluacion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
          ' SET DD_PTP_PLAZO_SCRIPT = ''valoresBPMPadre[''''H009_RevisarResultadoInfAdmon'''']!=null && valoresBPMPadre[''''H009_RevisarResultadoInfAdmon''''][''''fecha'''']!=null ? damePlazo(valoresBPMPadre[''''H009_RevisarResultadoInfAdmon''''][''''fecha'''']) + 10*24*60*60*1000L : 10*24*60*60*1000L''' ||
          ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-731');

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