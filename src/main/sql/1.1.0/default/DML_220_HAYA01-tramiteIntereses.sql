/*
--######################################################################
--## Author: Gonzalo
--## BPM: T. Intereses (H042)
--## Finalidad: Insertar datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    
    CODIGO_PROCEDIMIENTO_ANTIGUO VARCHAR2(10 CHAR) := 'P10'; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
		T_TIPO_TPO('H042','T. de Intereses','Trámite de Intereses',null,'haya_tramiteIntereses','0','DD','0','TR',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    
    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('H042','H042_ElaborarLiquidacion',null,'comprobarExisteDocumentoHCI() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Hoja de c&aacute;lculo de Intereses" al procedimiento.</div>''',null,null,null,'0','Elaborar, enviar Liquidación de intereses','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'800',null,null,null),
		T_TIPO_TAP('H042','H042_ValidarLiquidacionIntereses',null,null,null,null,null,'0','Validación Liquidación de Intereses','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'800',null,null,null),
		T_TIPO_TAP('H042','H042_SolicitarLiquidacion',null,null,null,null,null,'0','Solicitar Liquidación de Intereses','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H042','H042_RegistrarResolucion',null,'comprobarExisteDocumentoREI() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Resoluci&oacute;n del Juzgado (Intereses)" al procedimiento.</div>''',null,null,null,'0','Registrar Resolución','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H042','H042_ConfirmarNotificacion',null,null,'((valores[''H042_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO) && (valores[''H042_ConfirmarNotificacion''][''fecha''] == null))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null','valores[''H042_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',null,'0','Confirmar Notificación','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H042','H042_BPMTramiteNotificacion',null,null,null,null,'P400','0','Se inicia Trámite de Notificación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H042','H042_RegistrarImpugnacion',null,'comprobarExisteDocumentoEII() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Escrito de impugnaci&oacute;n (Intereses)" al procedimiento.</div>''','((valores[''H042_RegistrarImpugnacion''][''comboImpugnacion''] == DDSiNo.SI) && (valores[''H042_RegistrarImpugnacion''][''fecha''] == null)) ? ''Debe introducir la fecha de la impugnaci&oacute;n'': (((valores[''H042_RegistrarImpugnacion''][''comboSiNo''] == DDSiNo.SI) && (valores[''H042_RegistrarImpugnacion''][''fechaVista''] == null))?''Debe introducir la fecha de la vista'':null)','valores[''H042_RegistrarImpugnacion''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Registrar Impugnación','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H042','H042_RegistrarVista',null,null,null,null,null,'0','Registrar Vista','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H042','H042_RegistrarResolucionVista',null,null,null,null,null,'0','Registrar Resolución de la Vista','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H042','H042_ResolucionFirme',null,null,null,null,null,'0','Resolución firme','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'H042_ElaborarLiquidacion','5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_ValidarLiquidacionIntereses','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_SolicitarLiquidacion','damePlazo(valores[''H042_ElaborarLiquidacion''][''fechaLiq'']) + 5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_RegistrarResolucion','damePlazo(valores[''H042_SolicitarLiquidacion''][''fechaPre'']) + 20*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_ConfirmarNotificacion','30*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_BPMTramiteNotificacion','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_RegistrarImpugnacion','((valores[''H042_ConfirmarNotificacion''][''fecha''] !='''') && (valores[''H042_ConfirmarNotificacion''][''fecha''] != null)) ? damePlazo(valores[''H042_ConfirmarNotificacion''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_RegistrarVista','damePlazo(valores[''H042_RegistrarImpugnacion''][''fechaVista''])','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_RegistrarResolucionVista','damePlazo(valores[''H042_RegistrarVista''][''fecha'']) + 30*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H042_ResolucionFirme','damePlazo(valores[''H042_RegistrarResolucionVista''][''fecha'']) + 5*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
			T_TIPO_TFI('H042_ElaborarLiquidacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El Letrado  ha de elaborar la liquidaci&oacute;n de los intereses, para ello en el primer campo debemos de indicar la fecha en la que lo efectuamos. En el segundo campo de la pantalla debemos informar la cantidad de los intereses que hemos calculado.  Los datos de principal, tipo demora, fecha cierre, y Responsabilidad Hipotecaria vendr&aacute;n preinformados.</p><p style="margin-bottom: 10px">Por &uacute;ltimo debemos de indicar la fecha en que ponemos en conocimiento del letrado externo de la Entidad el resultado de la pantalla en la que nos encontramos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_ElaborarLiquidacion','1','date','fechaLiq','Fecha de liquidación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_ElaborarLiquidacion','2','currency','importe','Importe calculado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_ElaborarLiquidacion','3','date','fechaEnv','Fecha de envío','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_ElaborarLiquidacion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_ValidarLiquidacionIntereses','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El supervisor deber&aacute; validar el c&aacute;lculo de la liquidaci&oacute;n de intereses practicada por el letrado para su aprobaci&oacute;n o modificaci&oacute;n en el caso que el c&aacute;lculo no fuera correcto.</p><p style="margin-bottom: 10px">El supervisor deber&aacute; informar de la fecha de entrega por parte del letrado de la estimaci&oacute;n de la liquidaci&oacute;n de intereses.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_ValidarLiquidacionIntereses','1','date','fecha','Fecha de entrega','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_ValidarLiquidacionIntereses','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_SolicitarLiquidacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El letrado, tras la validaci&oacute;n del calculo de intereses por parte del supervisor, en el primer campo de la pantalla debemos de informar la fecha en que tal circunstancia se ha producido, as&iacute; como a continuaci&oacute;n debemos de confirmar la fecha de presentaci&oacute;n en el Juzgado del escrito de solicitud de liquidaci&oacute;n de los intereses que se han producido.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_SolicitarLiquidacion','1','date','fechaRec','Fecha de recepción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_SolicitarLiquidacion','2','date','fechaPre','Fecha de presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_SolicitarLiquidacion','3','currency','intereses','Importe intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_SolicitarLiquidacion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez que por el Juzgado se dicte Resoluci&oacute;n en la que se fijan los intereses solicitados se ha de informar la fecha de notificaci&oacute;n de la misma as&iacute; como la cuant&iacute;a de los intereses fijados por el juzgado.</p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Comunicaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucion','2','currency','importe','Intereses',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucion','3','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_ConfirmarNotificacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez dictado el auto de admisi&oacute;n de la demanda, en esta pantalla, debe indicar si la notificaci&oacute;n de la misma se ha realizado satisfactoriamente, con lo que deber&aacute; indicar que es positivo, o no.</p><p style="margin-bottom: 10px">Deber&aacute; informar la fecha de notificaci&oacute;n &uacute;nicamente en el supuesto de que esta se hubiese efectuado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px">- Notificaci&oacute;n positiva: "Registrar impugnaci&oacute;n".</p><p style="margin-bottom: 10px">- Notificaci&oacute;n negativa: En este caso se iniciar&aacute; el "Tr&aacute;mite de notificaci&oacute;n".</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_ConfirmarNotificacion','1','combo','comboSiNo','Resultado notificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDPositivoNegativo','0','DD'),
			T_TIPO_TFI('H042_ConfirmarNotificacion','2','date','fecha','Fecha',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_ConfirmarNotificacion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_BPMTramiteNotificacion','0','label','titulo','Se inicia Trámite de Notificación',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarImpugnacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla, se ha de informar si se ha producido impugnaci&oacute;n o no junto a la fecha de celebraci&oacute;n de la misma.</p><p style="margin-bottom: 10px">Del mismo modo informar si se va a producir Vista junto a la fecha de celebraci&oacute;n de la misma. Para el supuesto en el que no vaya a ver vista no ser&aacute; obligatorio informar la fecha de celebraci&oacute;n de la misma.</p><p style="margin-bottom: 10px">Para los supuestos en los que se se&ntilde;ale que va haber vista, la siguiente tarea sea "Registrar vista". Para los supuestos en los que no vaya a ver vista la siguiente tarea ser&aacute; toma de decisi&oacute;n sobre la continuidad del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarImpugnacion','1','combo','comboImpugnacion','Hay impuganción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
			T_TIPO_TFI('H042_RegistrarImpugnacion','2','date','fecha','Fecha impugnación',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarImpugnacion','3','combo','comboSiNo','Hay vista','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
			T_TIPO_TFI('H042_RegistrarImpugnacion','4','date','fechaVista','Fecha vista',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarImpugnacion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarVista','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que se ha producido impugnaci&oacute;n de los intereses practicados, y se&ntilde;alada la vista, ahora debemos de informar la celebraci&oacute;n de la misma, para ello se ha de indicar la fecha en el campo establecido para ello.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarVista','1','date','fecha','Fecha vista','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarVista','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucionVista','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&aacute; informar la fecha en la que la Resoluci&oacute;n adquiere firmeza.</p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Comunicaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucionVista','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucionVista','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','DD'),
			T_TIPO_TFI('H042_RegistrarResolucionVista','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_ResolucionFirme','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&aacute; informar la fecha en la que la Resoluci&oacute;n adquiere firmeza.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
			T_TIPO_TFI('H042_ResolucionFirme','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
			T_TIPO_TFI('H042_ResolucionFirme','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT ' ||
                    'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') 
                    || ''',sysdate,' 
                    || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') 
                    || ''',' || '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) 
                    || ''',' || '''' || TRIM(V_TMP_TIPO_TPO(13)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) 
                    || ''' FROM DUAL'; 

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');
    
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' ||
                    	'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' 
                    	|| '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' 
                    	|| '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') 
                    	|| ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') 
                    	|| ''',' || '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' 
                    	|| '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') 
                    	|| ''',' || 'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') 
                    	|| ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') 
                    	|| ''',' || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' 
                    	|| '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' 
                    	|| ''''|| REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') 
                    	|| ''',' ||'(select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
                    	|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                    	|| ''' FROM DUAL';
                    
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');


    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

    /*
     * Desactivamos trámites antiguos si existen
     */
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO||''' AND BORRADO=0 ';
        
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' SET BORRADO=1 WHERE '||V_CODIGO_TPO||' = '''||CODIGO_PROCEDIMIENTO_ANTIGUO||''' AND BORRADO=0 ';
        DBMS_OUTPUT.PUT_LINE('Trámite antiguo desactivado.');
        EXECUTE IMMEDIATE V_SQL; 
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