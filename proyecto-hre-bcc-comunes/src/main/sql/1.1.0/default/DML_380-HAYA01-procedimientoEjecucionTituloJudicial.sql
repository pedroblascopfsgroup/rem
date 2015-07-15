/*
--######################################################################
--## Author: Gonzalo
--## BPM: P. ETJ (Ejecución de Título Judicial) (H018)
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
    
    CODIGO_PROCEDIMIENTO_ANTIGUO VARCHAR2(10 CHAR) := 'P16'; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO('H018','P. Ej. de Título Judicial','Procedimiento Ejecución de Título Judicial','<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>Sentencia/Auto dictado en el procedimiento.</li><li>Providencia en laque se declare la firmeza del titulo judicial ejecutado.</li><li>Notas simples en el caso de encontrarse inmuebles susceptibles embargo.</li></ul></div>','haya_ejecucionTituloJudicial','0','DD','0','EJ',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    
    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('H018','H018_InterposicionDemanda','plugin/procedimientos-bpmHaya/ejecucionTituloJudicial/interposicionDemanda','!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'' : null)',null,null,null,'0','Interposición de la demanda de título judicial + Marcado de bienes','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_AutoDespachando',null,'comprobarExisteDocumentoADETJ() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Auto despachando ejecuci&oacute;n (Ejecuci&oacute;n T&iacute;tulo Judicial)" al procedimiento.</div>''',null,'valores[''H018_AutoDespachando''][''comboSiNo''] == DDSiNo.SI ? ( valores[''H018_AutoDespachando''][''comboBienesRegistrables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''',null,'0','Auto Despachando ejecución + Marcado de bienes decreto embargo','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_BPMTramiteNotificacion',null,null,null,null,'P400','0','Se inicia Trámite de Notificación','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_BPMVigilanciaCaducidadAnotacion',null,null,null,null,'H062','0','Ejecución de Vigilancia caducidad anotación de embargo','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_ConfirmarNotificacion',null,null,'((valores[''H018_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO) && (valores[''H018_ConfirmarNotificacion''][''fecha''] == null))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null','valores[''H018_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',null,'0','Confirmar notificacion','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_RegistrarOposicion',null,null,'((valores[''H018_RegistrarOposicion''][''comboSiNo''] == DDSiNo.SI) && ((valores[''H018_RegistrarOposicion''][''fecha''] == null || valores[''H018_RegistrarOposicion''][''motivo''] == null)))?''Debe introducir la fecha y motivo de la oposici&oacute;n'':null','valores[''H018_RegistrarOposicion''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Registrar oposición vista','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_ConfirmarPresentacionImpugnacion',null,null,null,null,null,'0','Confirmar presentación impugnación','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_HayVista',null,null,'((valores[''H018_HayVista''][''comboSiNo''] == DDSiNo.SI) && ((valores[''H018_HayVista''][''fechaVista''] == null)))?''Debe indicar la fecha de la vista'':null','valores[''H018_HayVista''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Confirmar si hay vista','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_RegistrarVista',null,null,null,null,null,'0','Registrar celebración vista','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_RegistrarResolucion',null,'comprobarExisteDocumentoARETJ() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Auto de resoluci&oacute;n (T&iacute;tulo Judicial)" al procedimiento.</div>''',null,null,null,'0','Registrar Resolución','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H018','H018_ResolucionFirme',null,null,null,null,null,'0','Resolución firme','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'H018_InterposicionDemanda','5*24*60*60*1000L','0','0','DD'),
--		T_TIPO_PLAZAS(null,null,'H018_AutoDespachando_old','60*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_AutoDespachando','damePlazo(valores[''H018_InterposicionDemanda''][''fecha'']) + 60*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_BPMTramiteNotificacion','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_BPMVigilanciaCaducidadAnotacion','1275*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_ConfirmarNotificacion','30*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_RegistrarOposicion','((valores[''H018_ConfirmarNotificacion''][''fecha''] !='''') && (valores[''H018_ConfirmarNotificacion''][''fecha''] != null)) ? damePlazo(valores[''H018_ConfirmarNotificacion''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_ConfirmarPresentacionImpugnacion','damePlazo(valores[''H018_RegistrarOposicion''][''fecha'']) + 5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_HayVista','damePlazo(valores[''H018_ConfirmarPresentacionImpugnacion''][''fecha'']) + 10*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_RegistrarVista','damePlazo(valores[''H018_HayVista''][''fechaVista''])','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_RegistrarResolucion','valores[''H018_HayVista''][''comboSiNo''] == DDSiNo.SI ? damePlazo(valores[''H018_RegistrarVista''][''fecha'']) + 30*24*60*60*1000L : damePlazo(valores[''H018_ConfirmarPresentacionImpugnacion''][''fecha'']) + 30*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H018_ResolucionFirme','damePlazo(valores[''H018_RegistrarResolucion''][''fecha'']) + 20*24*60*60*1000L','0','0','DD')
--		T_TIPO_PLAZAS(null,null,'H018_RegistrarAnotacion','nVecesTareaExterna == 0 ? 30*24*60*60*1000L : 23*7*24*60*60*1000L','0','0','DD'),
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('H018_InterposicionDemanda','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda. Ind&iacute;quese la plaza y n&uacute;mero de juzgado.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Auto Despachando ejecuci&oacute;n + marcado de bienes decreto embargo"</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_InterposicionDemanda','1','date','fecha','Fecha de presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H018_InterposicionDemanda','2','combo','plazaJuzgado','Plaza del juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','damePlaza()','TipoPlaza','0','DD'),
		T_TIPO_TFI('H018_InterposicionDemanda','3','combo','numJuzgado','Nº de juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumJuzgado()','TipoJuzgado','0','DD'),
--		T_TIPO_TFI('H018_InterposicionDemanda','4','number','principalDemanda','Principal de la demanda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H018_InterposicionDemanda','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
--		T_TIPO_TFI('H018_AutoDespachando_old','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&oacute;n y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de decreto de embargo para cada uno de los bienes en los que proceda en la pestaña de &quot;Bienes&quot;.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no, lo que supondr&aacute;, seg&uacute;n su contestaci&oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;, si ha sido admitida a tr&aacute;mite la demanda &quot;Confirmar notificaci&oacute;n del requerimiento de pago&quot; al ejecutado, y &quot;Registrar anotaci&oacute;n en el registro&quot;. Si no ha sido admitida la demanda se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
--		T_TIPO_TFI('H018_AutoDespachando_old','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
--		T_TIPO_TFI('H018_AutoDespachando_old','2','textproc','nProc','Nº Procedimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumAuto()',null,'0','DD'),
--		T_TIPO_TFI('H018_AutoDespachando_old','3','combo','comboSiNo','Admisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
--		T_TIPO_TFI('H018_AutoDespachando_old','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_AutoDespachando','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&oacute;n, el juzgado en el que ha reca&iacute;do la demanda y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de decreto de embargo para cada uno de los bienes en los que proceda en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no as&iacute; como indicar si existen bienes registrables o no, lo que supondr&aacute;, seg&uacute;n su contestaci&oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px">- Si ha sido admitida a tr&aacute;mite la demanda "Confirmar notificaci&oacute;n del requerimiento de pago" al ejecutado y la actuaci&oacute;n "Vigilancia caducidad anotaciones de embargo" si adem&aacute;s indica que existen bienes registrables en el registro.</p><p style="margin-bottom: 10px">- Si no ha sido admitida la demanda se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_AutoDespachando','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H018_AutoDespachando','2','textproc','nProc','Nº Procedimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumAuto()',null,'0','DD'),
		T_TIPO_TFI('H018_AutoDespachando','3','combo','comboSiNo','Admisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H018_AutoDespachando','4','combo','comboBienesRegistrables','Existen bienes registrables','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H018_AutoDespachando','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_BPMTramiteNotificacion','0','label','titulo','Se inicia Trámite de Notificación',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_BPMVigilanciaCaducidadAnotacion','0','label','titulo','Ejecución de Vigilancia caducidad anotación de embargo',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_ConfirmarNotificacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez dictado el auto despachando ejecuci&oacute;n, en esta pantalla, debe indicar si la notificaci&oacute;n se ha realizado satisfactoriamente, con lo que deber&aacute; indicar que es positivo, o no.</p><p style="margin-bottom: 10px">Deber&aacute; informar la fecha de notificaci&oacute;n &uacute;nicamente en el supuesto de que &eacute;sta se hubiese efectuado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px">Notificaci&oacute;n positiva: "Registrar oposici&oacute;n vista"</p><p style="margin-bottom: 10px">Notificaci&oacute;n negativa: en este caso se iniciar&aacute; el "Tr&aacute;mite de notificaci&oacute;n".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_ConfirmarNotificacion','1','combo','comboSiNo','Resultado notificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDPositivoNegativo','0','DD'),
		T_TIPO_TFI('H018_ConfirmarNotificacion','2','date','fecha','Fecha',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_ConfirmarNotificacion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarOposicion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que en el proceso ha habido oposici&oacute;n por parte del ejecutado, en esta pantalla, debemos informar la fecha de presentaci&oacute;n en el Juzgado del escrito de impugnaci&oacute;n de la oposici&oacute;n presentada por el contrario e indicar el motivo de la oposici&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">En caso de oposici&oacute;n por parte del ejecutado, la siguiente tarea ser&aacute; "Confirmar presentaci&oacute;n impugnaci&oacute;n".</p><p style="margin-bottom: 10px">Si no hay oposici&oacute;n, se abrir&aacute; una tarea en la que se propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarOposicion','1','combo','comboSiNo','Existe oposición','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H018_RegistrarOposicion','2','date','fecha','Fecha oposición',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarOposicion','3','text','motivo','Motivo oposición',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarOposicion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_ConfirmarPresentacionImpugnacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que en el proceso ha habido oposici&oacute;n por parte del ejecutado, en esta pantalla, debemos informar la fecha de presentaci&oacute;n en el Juzgado del escrito de impugnaci&oacute;n de la oposici&oacute;n presentada por el contrario.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Confirmar si hay vista".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_ConfirmarPresentacionImpugnacion','1','date','fecha','Fecha presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H018_ConfirmarPresentacionImpugnacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_HayVista','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez presentada la impugnaci&oacute;n de la oposici&oacute;n del ejecutado, en esta pantalla, debemos de se&ntilde;alar si por el Juzgado se ha admitido la celebraci&oacute;n de vista.</p><p style="margin-bottom: 10px">El siguiente campo &uacute;nicamente deber&aacute; ser cumplimentado para el supuesto de que se hubiere confirmado la celebraci&oacute;n de la vista, debiendo informaese la fecha que el juzgado hubiere se&ntilde;alado para la misma.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea, en el caso que hubiere vista, ser&aacute; "Registrar vista". En caso contrario "Registrar resoluci&oacute;n"</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_HayVista','1','combo','comboSiNo','Hay vista','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H018_HayVista','2','date','fechaVista','Fecha vista',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_HayVista','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarVista','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de informar la fecha de celebraci&oacute;n de la vista.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Registrar resoluci&oacute;n".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarVista','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarVista','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarResolucion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En &eacute;sta pantalla se deber&aacute; de informar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do como consecuencia de la vista celebrada.</p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Comunicaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Resoluci&oacute;n firme".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarResolucion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H018_RegistrarResolucion','2','combo','resultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','DD'),
		T_TIPO_TFI('H018_RegistrarResolucion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_ResolucionFirme','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&aacute; informar la fecha en la que la Resoluci&oacute;n adquiere firmeza. En el momento se obtenga el testimonio de firmeza deber&aacute; adjuntarlo como documento acreditativo, aunque no tiene caracter obligatorio para la finalizaci&oacute;n de la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H018_ResolucionFirme','1','date','fecha','Fecha firmeza','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H018_ResolucionFirme','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
--		T_TIPO_TFI('H018_RegistrarAnotacion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
--		T_TIPO_TFI('H018_RegistrarAnotacion','2','combo','repetir','Activar alerta periódica','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
--		T_TIPO_TFI('H018_RegistrarAnotacion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
--		T_TIPO_TFI('H018_RegistrarAnotacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se ha de consignar la fecha de anotaci&oacute;n de los embargos trabados en el Registro de la Propiedad correspondiente.</p><p style="margin-bottom: 10px">Para el supuesto de la existencia de embargo de varios bienes y que estos se encuentren inscritos en diferentes Registros de la Propiedad, se deber&aacute; consignar en esta pantalla &uacute;nicamente el de la anotaci&oacute;n del primero de ellos. Se deber&aacute; abrir la pestaña de &quot;Bienes&quot; para introducir la fecha de anotaci&oacute;n en el Registro de la Propiedad de cada uno de los bienes embargados.</p><p style="margin-bottom: 10px">El siguiente campo deber&aacute; de mantenerse como afirmativo siempre que existan bienes no apremiados por la entidad, lo que permitir&aacute; que la herramienta nos genere una alerta para solicitar la pr&oacute;rroga de la anotaci&oacute;n de los embargos en el Registro.</p><p style="margin-bottom: 10px">Para el supuesto de que se trate de embargo de bien mueble, &uacute;nicamente se deber&aacute; consignar el primer campo para el supuesto de que el mismo sea inscribible en el Registro de Bienes Muebles.<p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
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