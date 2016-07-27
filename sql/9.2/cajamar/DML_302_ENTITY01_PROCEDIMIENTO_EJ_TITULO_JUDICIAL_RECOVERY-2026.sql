/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Procedimiento Ej. Titulo Judicial
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
    	T_TIPO_TAP('CJ018','CJ018_InterposicionDemanda' ,'plugin/cajamar/ejecucionTituloJudicial/interposicionDemanda' ,'!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : !comprobarExisteDocumentoEDH() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Es necesario adjuntar el Escrito de la demanda completo + copia sellada de la demanda.</p></div>'' : tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'' : null' ,null ,'valores[''CJ018_InterposicionDemanda''][''provisionFondos''] == DDSiNo.SI ? (existeTipoGestor("CENTROPROCURA") ? ''conAnticipo'' : ''conProvision'') : ''sinProvision''' ,null ,'0','Interposición de la demanda de título judicial + Marcado de bienes' ,'0','RECOVERY-2026','0' ,null ,null ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_AutoDespachando' ,null ,'comprobarExisteDocumentoADETJ() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Auto despachando ejecuci&oacute;n (Ejecuci&oacute;n T&iacute;tulo Judicial)" al procedimiento.</div>''' ,null ,'valores[''CJ018_AutoDespachando''][''comboSiNo''] == DDSiNo.SI ? ( valores[''CJ018_AutoDespachando''][''comboBienesRegistrables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''' ,null ,'0','Auto Despachando ejecución + Marcado de bienes decreto embargo','0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_BPMTramiteNotificacion' ,null ,null ,null ,null ,'CJ400' ,'0','Se inicia Trámite de Notificación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_BPMVigilanciaCaducidadAnotacion' ,null ,null ,null ,null ,'CJ062' ,'0','Ejecución de Vigilancia caducidad anotación de embargo' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_ConfirmarNotificacion' ,'plugin/cajamar/ejecucionTituloJudicial/confirmarNotificacion' ,null ,'((valores[''CJ018_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO) && (valores[''CJ018_ConfirmarNotificacion''][''fecha''] == null))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null' ,'valores[''CJ018_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''' ,null ,'0','Confirmar notificacion' ,'0','RECOVERY-2026','0' ,null ,null ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_RegistrarOposicion' ,null ,null ,'((valores[''CJ018_RegistrarOposicion''][''comboSiNo''] == DDSiNo.SI) && ((valores[''CJ018_RegistrarOposicion''][''fecha''] == null || valores[''CJ018_RegistrarOposicion''][''motivo''] == null)))?''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe introducir la fecha y motivo de la oposici&oacute;n</div>'':null' ,'valores[''CJ018_RegistrarOposicion''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''' ,null ,'0','Registrar oposición vista' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_ConfirmarPresentacionImpugnacion' ,null ,null ,null ,null ,null ,'0','Confirmar presentación impugnación' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_HayVista' ,'plugin/cajamar/ejecucionTituloJudicial/confirmarVista' ,null ,'((valores[''CJ018_HayVista''][''comboSiNo''] == DDSiNo.SI) && ((valores[''CJ018_HayVista''][''fechaVista''] == null)))?''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la fecha de la vista</div>'':null' ,'valores[''CJ018_HayVista''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''' ,null ,'0','Confirmar si hay vista' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_RegistrarVista' ,null ,null ,null ,null ,null ,'0','Registrar celebración vista' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_RegistrarResolucion' ,null ,'comprobarExisteDocumentoARETJ() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Auto de resoluci&oacute;n (T&iacute;tulo Judicial)" al procedimiento.</div>''' ,null ,null ,null ,'0','Registrar Resolución' ,'0','RECOVERY-2026','0' ,null ,null ,1,'1' ,'EXTTareaProcedimiento','3',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_ResolucionFirme' ,null ,null ,null ,null ,null ,'0','Resolución firme' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_TituloDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,'814',null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_BPMProvisionFondos' ,null ,null ,null ,null ,'CJ103' ,'0','Provisión de fondos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ018','CJ018_BPMAnticipoFondos' ,null ,null ,null ,null ,'CJ460' ,'0','Se inicia el trámite de anticipo de fondos y pago de suplidos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null)
	);
		V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ018_InterposicionDemanda','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_AutoDespachando','damePlazo(valores[''CJ018_InterposicionDemanda''][''fecha'']) + 60*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_BPMTramiteNotificacion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_BPMVigilanciaCaducidadAnotacion','1275*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_ConfirmarNotificacion','30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_RegistrarOposicion','((valores[''CJ018_ConfirmarNotificacion''][''fecha''] !=null) && (valores[''CJ018_ConfirmarNotificacion''][''fecha''] != '''')) ? damePlazo(valores[''CJ018_ConfirmarNotificacion''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L' ,'1','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_ConfirmarPresentacionImpugnacion','damePlazo(valores[''CJ018_RegistrarOposicion''][''fecha'']) + 5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_HayVista','damePlazo(valores[''CJ018_ConfirmarPresentacionImpugnacion''][''fecha'']) + 10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_RegistrarVista','damePlazo(valores[''CJ018_HayVista''][''fechaVista''])' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_RegistrarResolucion','valores[''CJ018_HayVista''][''comboSiNo''] == DDSiNo.SI ? damePlazo(valores[''CJ018_RegistrarVista''][''fecha'']) + 30*24*60*60*1000L : damePlazo(valores[''CJ018_ConfirmarPresentacionImpugnacion''][''fecha'']) + 30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_ResolucionFirme','damePlazo(valores[''CJ018_RegistrarResolucion''][''fecha'']) + 20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_BPMProvisionFondos','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ018_BPMAnticipoFondos','300*24*60*60*1000L' ,'0','0','RECOVERY-2026')
	); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
	    T_TIPO_TFI('CJ018_InterposicionDemanda','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda. Ind&iacute;quese la plaza y n&uacute;mero de juzgado.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">En el campo "Solicitar provisi&oacute;n de fondos" deber&aacute; indicar si va a solicitar o no provisi&oacute;n de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Auto Despachando ejecuci&oacute;n + Marcado de bienes decreto embargo" y si ha marcado que requiere provisi&oacute;n de fondos, se lanzar&aacute; el "Tr&aacute;mite de solicitud de fondos".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_InterposicionDemanda','1','date' ,'fecha','Fecha de presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_InterposicionDemanda','2','combo' ,'plazaJuzgado','Plaza del juzgado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'damePlaza()' ,'TipoPlaza','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_InterposicionDemanda','3','combo' ,'numJuzgado','Nº de juzgado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'dameNumJuzgado()' ,'TipoJuzgado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_InterposicionDemanda','4','combo' ,'provisionFondos','Solicitar provisión de fondos' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_InterposicionDemanda','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_AutoDespachando','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&oacute;n, el juzgado en el que ha reca&iacute;do la demanda y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de decreto de embargo para cada uno de los bienes en los que proceda en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no as&iacute; como indicar si existen bienes registrables o no, lo que supondr&aacute;, seg&uacute;n su contestaci&oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px">- Si ha sido admitida a tr&aacute;mite la demanda "Confirmar notificaci&oacute;n del requerimiento de pago" al ejecutado y la actuaci&oacute;n "Vigilancia caducidad anotaciones de embargo" si adem&aacute;s indica que existen bienes registrables en el registro.</p><p style="margin-bottom: 10px">- Si no ha sido admitida la demanda se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_AutoDespachando','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_AutoDespachando','2','textproc' ,'nProc','Nº Procedimiento' ,null ,null ,'dameNumAuto()' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_AutoDespachando','3','combo' ,'comboSiNo','Admisión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_AutoDespachando','4','combo' ,'comboBienesRegistrables','Existen bienes registrables' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_AutoDespachando','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_BPMTramiteNotificacion','0','label' ,'titulo','Se inicia Trámite de Notificación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_BPMVigilanciaCaducidadAnotacion','0','label' ,'titulo','Ejecución de Vigilancia caducidad anotación de embargo' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ConfirmarNotificacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez dictado el auto despachando ejecuci&oacute;n, en esta pantalla, debe indicar si la notificaci&oacute;n se ha realizado satisfactoriamente, con lo que deber&aacute; indicar que es positivo, o no.</p><p style="margin-bottom: 10px">Deber&aacute; informar la fecha de notificaci&oacute;n &uacute;nicamente en el supuesto de que &eacute;sta se hubiese efectuado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px">Notificaci&oacute;n positiva: "Registrar oposici&oacute;n vista"</p><p style="margin-bottom: 10px">Notificaci&oacute;n negativa: en este caso se iniciar&aacute; el "Tr&aacute;mite de notificaci&oacute;n".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ConfirmarNotificacion','1','combo' ,'comboSiNo','Resultado notificación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDPositivoNegativo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ConfirmarNotificacion','2','date' ,'fecha','Fecha' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ConfirmarNotificacion','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarOposicion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que en el proceso ha habido oposici&oacute;n por parte del ejecutado, en esta pantalla, debemos informar la fecha de presentaci&oacute;n en el Juzgado del escrito de impugnaci&oacute;n de la oposici&oacute;n presentada por el contrario e indicar el motivo de la oposici&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">En caso de oposici&oacute;n por parte del ejecutado, la siguiente tarea ser&aacute; "Confirmar presentaci&oacute;n impugnaci&oacute;n".</p><p style="margin-bottom: 10px">Si no hay oposici&oacute;n, se abrir&aacute; una tarea en la que se propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarOposicion','1','combo' ,'comboSiNo','Existe oposición' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarOposicion','2','date' ,'fecha','Fecha oposición' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarOposicion','3','text' ,'motivo','Motivo oposición' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarOposicion','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ConfirmarPresentacionImpugnacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que en el proceso ha habido oposici&oacute;n por parte del ejecutado, en esta pantalla, debemos informar la fecha de presentaci&oacute;n en el Juzgado del escrito de impugnaci&oacute;n de la oposici&oacute;n presentada por el contrario.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Confirmar si hay vista".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ConfirmarPresentacionImpugnacion','1','date' ,'fecha','Fecha presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ConfirmarPresentacionImpugnacion','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_HayVista','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez presentada la impugnación de la oposición del ejecutado, en esta pantalla, debemos de señalar si por el Juzgado se ha admitido la celebración de vista.</p><p style="margin-bottom: 10px">El siguiente campo únicamente deberá ser cumplimentado para el supuesto de que se hubiere confirmado la celebración de la vista, debiendo informarse la fecha que el juzgado hubiere señalado para la misma.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene ésta pantalla la siguiente tarea, en el caso que hubiere vista, será "Registrar vista". En caso contrario "Registrar resolución"</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_HayVista','1','combo' ,'comboSiNo','Hay vista' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_HayVista','2','date' ,'fechaVista','Fecha vista' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_HayVista','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarVista','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de informar la fecha de celebraci&oacute;n de la vista.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Registrar resoluci&oacute;n".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarVista','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarVista','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarResolucion','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En esta pantalla se deberá de informar la fecha de notificación de la Resolución que hubiere recaído como consecuencia de la vista celebrada.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificar dicha circunstancia al responsable interno de la misma a través del botón "Anotación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla la siguiente tarea será "Resolución firme".</span></p></div>' ,null ,null ,null ,null,'4','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarResolucion','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarResolucion','2','combo' ,'resultado','Resultado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDFavorable','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_RegistrarResolucion','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ResolucionFirme','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deberá informar la fecha en la que la Resolución adquiere firmeza. En el momento se obtenga el testimonio de firmeza deberá adjuntarlo como documento acreditativo, aunque no tiene caracter obligatorio para la finalización de la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>' ,null ,null ,null ,null,'8','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ResolucionFirme','1','date' ,'fecha','Fecha firmeza' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_ResolucionFirme','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ018_BPMAnticipoFondos','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el trámite anticipo de fondos y pago de suplidos.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026')    
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