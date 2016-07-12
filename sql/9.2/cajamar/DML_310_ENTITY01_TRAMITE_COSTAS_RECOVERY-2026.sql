/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Tramite de costas
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    
    --FALTA CAMBIAR LA RUTA DE LAS JSP
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('CJ007','CJ007_AutoAprobacionCostas' ,null ,'comprobarExisteDocumentoAAC() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar la Auto aprobaci&oacute;n (Costas)</div>''' ,null ,null ,null ,'0','Auto aprobación costas' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_AutoFirme' ,null ,null ,null ,null ,null ,'0','Auto firme' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_ConfirmarNotificacion' ,'plugin/procedimientos-bpmHaya-plugin/tramiteCostas/confirmarNotificacion' ,null ,'((valores[''CJ007_ConfirmarNotificacion''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''CJ007_ConfirmarNotificacion''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null' ,'valores[''CJ007_ConfirmarNotificacion''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''' ,null ,'0','Confirmar notificación' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_Impugnacion' ,'plugin/procedimientos-bpmHaya-plugin/tramiteCostas/impugnacion' ,null ,'((valores[''CJ007_Impugnacion''][''comboImpugnacion''] == DDSiNo.SI) && ((valores[''CJ007_Impugnacion''][''fechaImpugnacion''] == ''''))) ? ''tareaExterna.error.CJ007_Impugnacion.fechasOblgatorias'' : ((valores[''CJ007_Impugnacion''][''comboImpugnacion''] == DDSiNo.SI) && (!comprobarExisteDocumentoEIC())) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el escrito de impugnaci&#243;n (Costas)</div>'' : null' ,'valores[''CJ007_Impugnacion''][''comboImpugnacion''] == DDSiNo.NO ? ''NO'' : (valores[''CJ007_Impugnacion''][''vistaImpugnacion''] != null &&valores[''CJ007_Impugnacion''][''vistaImpugnacion''] != '''' ? ''SI'' : ''SI_NOVISTA'')' ,null ,'0','Impugnación' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_JBPMTramiteNotificacion' ,null ,null ,null ,null ,'P400' ,'0','Se inicia Trámite de notificación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_RegistrarCelebracionVista' ,null ,null ,null ,null ,null ,'0','Registrar celebración vista' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_SolicitudTasacion' ,null ,null ,'(new BigDecimal(valores[''CJ007_SolicitudTasacion''][''cuantiaLetrado''])) > (damePrincipal() * 5 / 100) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Las costas del letrado no pueden superar el 5% del principal</div>'' : null' ,null ,null ,'0','Solicitud de tasación de costas' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_TasacionCostas' ,null ,'comprobarExisteDocumentoTJC() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar la tasaci&oacute;n del juzgado.</div>''' ,'(new BigDecimal(valores[''CJ007_SolicitudTasacion''][''cuantiaLetrado''])) > (damePrincipal() * 5 / 100) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Las costas del letrado no pueden superar el 5% del principal</div>'' : null' ,null ,null ,'0','Tasación de costas' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_AutoDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_RevisionCostas' ,'plugin/procedimientos-bpmHaya-plugin/tramiteCostas/revisionCostas' ,null ,null ,null ,null ,'0','Revisión de costas propuestas por el procurador' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ007','CJ007_PostSolicitudTasacion' ,'plugin/procedimientos-bpmHaya-plugin/tramiteCostas/postSolicitudTasacion' ,null ,null ,null ,null ,'0','Confirmar seguimiento de las costas del procurador' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ007_SolicitudTasacion','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_TasacionCostas','20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_ConfirmarNotificacion','30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_Impugnacion','((valores[''CJ007_ConfirmarNotificacion''][''fecha''] !='''') && (valores[''CJ007_ConfirmarNotificacion''][''fecha''] != null)) ? damePlazo(valores[''CJ007_ConfirmarNotificacion''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_RegistrarCelebracionVista','damePlazo(valores[''CJ007_Impugnacion''][''vistaImpugnacion''])' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_AutoFirme','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_AutoAprobacionCostas','20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_JBPMTramiteNotificacion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_RevisionCostas','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ007_PostSolicitudTasacion','2*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ007_AutoAprobacionCostas','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En esta pantalla, se ha de informar la fecha de notificación del auto dictado en el trámite de tasación de costa y si el resultado ha sido favorable para los intereses de la entidad o no.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificar dicha circunstancia al responsable interno de la misma a través del botón "Anotación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el segundo campo de la pantalla debemos de confirmar o no si el auto ha aprobado la tasación de costas conforme a lo solicitado por el letrado y procurador de la entidad.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene ésta pantalla la siguiente tarea será "Auto firme".</span></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoAprobacionCostas','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoAprobacionCostas','2','combo' ,'comboResultado','Resultado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDFavorable','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoAprobacionCostas','3','combo' ,'comboAprobada','Aprobada' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoAprobacionCostas','4','currency' ,'cuantiaLetrado','Cuantía letrado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'(valores[''CJ007_TasacionCostas''][''cuantiaLetrado''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoAprobacionCostas','5','currency' ,'cuantiaProcurador','Cuantía procurador' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'(valores[''CJ007_TasacionCostas''][''cuantiaProcurador''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoAprobacionCostas','6','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoFirme','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Se deberá informar la fecha en la que el Auto adquiere firmeza.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene ésta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</span></font></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoFirme','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_AutoFirme','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_ConfirmarNotificacion','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez se ha dictado resolución por la que han sido tasadas las costas, en esta pantalla, debe indicar si la notificación de dicha resolución se ha realizado satisfactoriamente, con lo que deberá indicar que es positivo, o no.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Deberá informar la fecha de notificación únicamente en el supuesto de que ésta se hubiese efectuado.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene ésta pantalla la siguiente tarea será:</span></font></p><ul style="color: rgb(0, 0, 0), font-family: Arial; font-size: 8pt; list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Notificación positiva: "Impugnación"</li><li style="margin-bottom: 10px; margin-left: 35px;">Notificación negativa: en este caso se iniciará el trámite de notificación.</li></ul></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_ConfirmarNotificacion','1','combo' ,'comboResultado','Resultado notificación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDPositivoNegativo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_ConfirmarNotificacion','2','date' ,'fecha','Fecha' ,null ,null ,null ,'DDPositivoNegativo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_ConfirmarNotificacion','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_Impugnacion','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En esta pantalla, se ha de confirmar si existe impugnación de la tasación de costas practicada o no, que se reseña en el primer campo de los que aparecen en la misma.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Para el supuesto de confirmación de haberse practicado impugnación se ha de informar la fecha en la que se nos notifica la impugnación presentada del contrario así como la fecha de vista si procede. El campo de fecha de vista, para los supuestos en los que se señale, provocará que la siguiente tarea sea la de convalidar la celebración de la misma. Para los supuestos en los que no se reseñe dicho campo la siguiente tarea será la consignación de la fecha de notificación de la resolución que recaiga con motivo de la impugnación formulada. </span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el desplegable de motivo impugnación se ha de seleccionar el que corresponda de los que aparecen en el mismo.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene ésta pantalla la siguiente tarea será:</span></p><ul style="color: rgb(0, 0, 0), font-family: Arial; font-size: 8pt; list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si hay impugnación y se ha reseñado vista "Registrar celebración vista"</li><li style="margin-bottom: 10px; margin-left: 35px;">Si hay impugnación y no se ha reseñado vista "Registrar  resolución"</li><li style="margin-bottom: 10px; margin-left: 35px;">Si no hay impugnación "Auto aprobación costas"</li></ul></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_Impugnacion','1','combo' ,'comboImpugnacion','Impugnación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_Impugnacion','2','date' ,'fechaImpugnacion','Fecha' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_Impugnacion','3','date' ,'vistaImpugnacion','Fecha vista' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_Impugnacion','4','combo' ,'comboResultado','Motivo impugnación' ,null ,null ,null ,'DDImpugnacion1','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_Impugnacion','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_JBPMTramiteNotificacion','0','label' ,'titulo','Se inicia Trámite de notificación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_RegistrarCelebracionVista','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Después de celebrada la vista, en esta pantalla debemos de informar la fecha en la que se ha celebrado. </span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene ésta pantalla la siguiente tarea será "Auto Aprobación Costas".</span></font></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_RegistrarCelebracionVista','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_RegistrarCelebracionVista','2','textarea' ,'observaciones','Observaciones' ,null ,null,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_SolicitudTasacion','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En esta pantalla debe informar la fecha en la que se presenta en el juzgado el escrito solicitando la tasación de las costas del procedimiento principal e informar de la cuantía del letrado y procurador.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene ésta pantalla la siguiente tarea es "Tasación de costas".</span></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_SolicitudTasacion','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_SolicitudTasacion','2','currency' ,'cuantiaLetrado','Cuantía letrado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_SolicitudTasacion','3','currency' ,'cuantiaProcurador','Cuantía procurador' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_SolicitudTasacion','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_TasacionCostas','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En esta pantalla debemos informar la fecha en la que se nos notifica la tasación de las costas practicada por el juzgado.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el segundo campo debemos introducir la cuantía que ha sido aprobada en la tasación solicitada.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene ésta pantalla la siguiente tarea es "Confirmar notificación".</span></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_TasacionCostas','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_TasacionCostas','2','currency' ,'cuantiaLetrado','Cuantía letrado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'(valores[''CJ007_SolicitudTasacion''][''cuantiaLetrado''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_TasacionCostas','3','currency' ,'cuantiaProcurador','Cuantía procurador' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'(valores[''CJ007_SolicitudTasacion''][''cuantiaProcurador''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_TasacionCostas','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_RevisionCostas','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; revisar los importes introducidos por el letrado en la tarea anterior “Solicitud de tasaci&oacute;n de costas”. En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_RevisionCostas','1','currency' ,'cuantiaLetrado','Cuantía Letrado' ,null ,null ,'(valores[''CJ007_SolicitudTasacion''][''cuantiaLetrado''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_RevisionCostas','2','currency' ,'cuantiaProcurador','Cuantía Procurador' ,null ,null ,'(valores[''CJ007_SolicitudTasacion''][''cuantiaProcurador''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_RevisionCostas','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_PostSolicitudTasacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; revisar los datos introducidos por el letrado tras el Auto de aprobaci&oacute;n de costas. En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_PostSolicitudTasacion','1','date' ,'fecha','Fecha' ,null ,null ,'(valores[''CJ007_AutoAprobacionCostas''][''fecha''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_PostSolicitudTasacion','2','combo' ,'resultado','Resultado' ,null ,null ,'(valores[''CJ007_AutoAprobacionCostas''][''comboResultado''])' ,'DDFavorable','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_PostSolicitudTasacion','3','combo' ,'aprobada','Aprobada' ,null ,null ,'(valores[''CJ007_AutoAprobacionCostas''][''comboAprobada''])' ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_PostSolicitudTasacion','4','currency' ,'cuantiaLetrado','Cuantía Letrado' ,null ,null ,'(valores[''CJ007_AutoAprobacionCostas''][''cuantiaLetrado''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_PostSolicitudTasacion','5','currency' ,'cuantiaProcurador','Cuantía Procurador' ,null ,null ,'(valores[''CJ007_AutoAprobacionCostas''][''cuantiaProcurador''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ007_PostSolicitudTasacion','6','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026')
    );
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
        IF V_NUM_TABLAS > 0 THEN				
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TAP_VIEW=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION_JBPM=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_DECISION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' ||
          ' TAP_DESCRIPCION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',' ||
          ' DD_TPO_ID_BPM=(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(7)) || '''),' ||
          ' TAP_ALERT_VUELTA_ATRAS=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
          ' DD_FAP_ID=(SELECT DD_FAP_ID FROM ' || V_ESQUEMA || '.DD_FAP_FASE_PROCESAL WHERE DD_FAP_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(15)) || '''),' || 
          ' TAP_AUTOPRORROGA=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',' ||
          ' TAP_MAX_AUTOP=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
          ' DD_TSUP_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
        	' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Actualizada la tarea '''|| TRIM(V_TMP_TIPO_TAP(2)) ||''', ' || TRIM(V_TMP_TIPO_TAP(3)));
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' || V_ESQUEMA || '.' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(19)),'''','''''') || ''',' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' ||
		    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
		    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
          END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');


    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
        IF V_NUM_TABLAS > 0 THEN				
	  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET DD_PTP_PLAZO_SCRIPT=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',' ||
            ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''',' ||
            ' FECHAMODIFICAR=sysdate ' ||
        	  ' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Se actualiza el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
        
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TFI_TIPO=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
        	' TFI_NOMBRE=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',' ||
        	' TFI_LABEL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
        	' TFI_ERROR_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',' ||
        	' TFI_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
        	' TFI_VALOR_INICIAL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',' ||
        	' TFI_BUSINESS_OPERATION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
        	' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
	        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Actualizado el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_NOMBRE = '||TRIM(V_TMP_TIPO_TFI(4))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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