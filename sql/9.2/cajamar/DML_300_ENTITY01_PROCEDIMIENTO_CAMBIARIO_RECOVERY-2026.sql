/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=20160628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Procedimiento Cambiario
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
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    		T_TIPO_TAP('CJ016','CJ016_interposicionDemandaMasBienes','plugin/cajamar/tramiteCambiario/interposicionDemanda','!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : !comprobarExisteDocumentoEDH() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Es necesario adjuntar el Escrito de la demanda completo + copia sellada de la demanda.</p></div>'' : tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'' : null',null,'valores[''CJ016_interposicionDemandaMasBienes''][''provisionFondos''] == DDSiNo.SI ? (existeTipoGestor("CENTROPROCURA") ? ''conanti'' : ''conprovision'') : ''sinprovision''',null,'0','Interposición de la demanda más marcado de bienes','0','RECOVERY-2026','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_confAdmiDecretoEmbargo','plugin/cajamar/tramiteCambiario/confAdmiDecretoEmbargo','comprobarExisteDocumentoEDH() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para poder continuar debe adjuntar el documento "Auto de requerimiento de pago y embargo".</p></div>''',null,'valores[''CJ016_confAdmiDecretoEmbargo''][''comboAdmision''] == DDSiNo.SI ? (valores[''CJ016_confAdmiDecretoEmbargo''][''comboBienes''] ==DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''',null,'0','Confirmar admisión más marcado bienes decreto embargo','0','RECOVERY-2026','0',null,'tareaExterna.cancelarTarea',1,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_BPMVigilanciaCaducidadEmbargos',null,null,null,null,'CJ062','0','Ejecución de vigilancia y caducidad de embargos','0','RECOVERY-2026','0',null,null,null,'0','EXTTareaProcedimiento','0',null,null,null,null,null),
			T_TIPO_TAP('CJ016','CJ016_confNotifRequerimientoPago',null,null,'((valores[''CJ016_confNotifRequerimientoPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''CJ016_confNotifRequerimientoPago''][''fecha''] == null))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null','valores[''CJ016_confNotifRequerimientoPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',null,'0','Confirmar notificación requerimiento de pago','0','RECOVERY-2026','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_BPMTramiteNotificacion',null,null,null,null,'CJ400','0','Ejecución trámite de notificación','0','RECOVERY-2026','0',null,null,null,'0','EXTTareaProcedimiento','0',null,null,null,null,null),
			T_TIPO_TAP('CJ016','CJ016_registrarDemandaOposicion',null,null,'((valores[''CJ016_registrarDemandaOposicion''][''comboOposicion''] == DDSiNo.SI) && ((valores[''CJ016_registrarDemandaOposicion''][''fecha''] == null) || (valores[''CJ016_registrarDemandaOposicion''][''fechaVista''] == null)))?''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Las fechas son obligatorias</div>'' : null','valores[''CJ016_registrarDemandaOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Registrar demanda de oposición','0','RECOVERY-2026','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_registrarJuicioComparecencia',null,null,null,null,null,'0','Registrar juicio y comparecencia','0','RECOVERY-2026','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_registrarResolucion',null,'comprobarExisteDocumentoREC() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para poder continuar debe adjuntar el documento "Resoluci&oacute;n".</p></div>''',null,null,null,'0','Registrar resolución','0','RECOVERY-2026','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_resolucionFirme',null,null,null,null,null,'0','Resolución firme','0','RECOVERY-2026','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_registrarAutoEjecucion',null,'comprobarExisteDocumentoADEC() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para poder continuar debe adjuntar el documento "Auto despachando ejecuci&oacute;n".</p></div>''',null,null,null,'0','Registrar auto despachando ejecución','0','RECOVERY-2026','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_CambiarioDecision',null,null,null,null,null,'0','Tarea toma de decisión','0','RECOVERY-2026','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'814',null,null,null),
			T_TIPO_TAP('CJ016','CJ016_BPMProvisionFondos',null,null,null,null,'CJ103','0','Provisión de fondos','0','RECOVERY-2026','0',null,null,null,'0','EXTTareaProcedimiento','0',null,null,null,null,null),
			T_TIPO_TAP('CJ016','CJ016_BPMAnticipoFondos',null,null,null,null,'CJ460','0','Se inicia el trámite de anticipo de fondos y pago de suplidos','0','RECOVERY-2026','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
	); 
	

	
	
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'CJ016_interposicionDemandaMasBienes','5*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_confAdmiDecretoEmbargo','damePlazo(valores[''CJ016_interposicionDemandaMasBienes''][''fecha'']) + 60*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_BPMVigilanciaCaducidadEmbargos','300*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_confNotifRequerimientoPago','damePlazo(valores[''CJ016_confAdmiDecretoEmbargo''][''fecha'']) + 30*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_BPMTramiteNotificacion','300*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_registrarDemandaOposicion','((valores[''CJ016_confNotifRequerimientoPago''][''fecha''] != null) && (valores[''CJ016_confNotifRequerimientoPago''][''fecha''] != '''')) ? damePlazo(valores[''CJ016_confNotifRequerimientoPago''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_registrarJuicioComparecencia','damePlazo(valores[''CJ016_registrarDemandaOposicion''][''fechaVista''])','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_registrarResolucion','damePlazo(valores[''CJ016_registrarJuicioComparecencia''][''fecha'']) + 30*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_resolucionFirme','damePlazo(valores[''CJ016_registrarResolucion''][''fecha'']) + 20*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_registrarAutoEjecucion','30*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_BPMProvisionFondos','300*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null,null,'CJ016_BPMAnticipoFondos','300*24*60*60*1000L','0','0','RECOVERY-2026')
	); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda y la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, capital no vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">Deber&aacute; adjuntar como documento obligatorio el escrito de la demanda.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pestaña de "Bienes".</p><p style="margin-bottom: 10px">En el campo "Solicitar provisi&oacute;n de fondos" deber&aacute; indicar si va a solicitar o no provisi&oacute;n de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Auto Despachando ejecuci&oacute;n + Marcado de bienes decreto embargo" y si ha marcado que requiere provisi&oacute;n de fondos, se lanzar&aacute; el "Tr&aacute;mite de solicitud de fondos".</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','1','date','fecha','Fecha presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','2','combo','comboPlaza','Plaza del juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false','damePlaza()','TipoPlaza','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','3','date','fechaCierre','Fecha cierre de la deuda',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','4','number','principalDemanda','Principal de la demanda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false','dameTotalLiquidacionPCO()',null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','5','number','capitalVencido','Captital vencido (en el cierre)',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','6','number','interesesOrdinarios','Intereses ordinarios (en el cierre)',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','7','number','interesesDemora','Intereses de demora (en el cierre)',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','8','combo','provisionFondos','Solicitar provisión de fondos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_interposicionDemandaMasBienes','9','textarea','observaciones','Observaciones',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confAdmiDecretoEmbargo','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&oacute;n, el juzgado en el que ha reca&iacute;do la demanda y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de decreto de embargo para cada uno de los bienes en los que proceda en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no as&iacute; como indicar si existen bienes registrables o no, lo que supondr&aacute;, seg&uacute;n su contestaci&oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:<p style="margin-bottom: 10px; margin-left: 40px;">-Si ha sido admitida a tr&aacute;mite la demanda "Confirmar notificaci&oacute;n del requerimiento de pago" al ejecutado y la actuaci&oacute;n "Vigilancia caducidad anotaciones de embargo" si adem&aacute;s indica que existen bienes registrables en el registro.<p style="margin-bottom: 10px; margin-left: 40px;">-Si no ha sido admitida la demanda se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confAdmiDecretoEmbargo','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confAdmiDecretoEmbargo','2','combo','comboPlaza','Plaza del juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false','valores[''CJ016_interposicionDemandaMasBienes''][''comboPlaza'']','TipoPlaza','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confAdmiDecretoEmbargo','3','combo','comboJuzgado','Número de juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false','dameNumJuzgado()','TipoJuzgado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confAdmiDecretoEmbargo','4','textproc','numProcedimiento','Número de procedimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false','dameNumAuto()',null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confAdmiDecretoEmbargo','5','combo','comboAdmision','Admisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confAdmiDecretoEmbargo','6','combo','comboBienes','Existen bienes registrables','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confAdmiDecretoEmbargo','7','textarea','observaciones','Observaciones',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_BPMVigilanciaCaducidadEmbargos','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite Vigilancia y Caducidad de Embargos</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confNotifRequerimientoPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez dictado el auto despachando ejecuci&oacute;n, en esta pantalla, debe indicar si la notificaci&oacute;n del requerimiento de pago se ha realizado satisfactoriamente, con lo que deber&aacute; indicar que es positivo, o no.</p><p style="margin-bottom: 10px">Deber&aacute; informar la fecha de notificaci&oacute;n &uacute;nicamente en el supuesto de que &eacute;sta se hubiese efectuado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:<p style="margin-bottom: 10px; margin-left: 40px;">Notificaci&oacute;n positiva: "Confirmar si existe oposici&oacute;n"<p style="margin-bottom: 10px; margin-left: 40px;">Notificaci&oacute;n negativa: en este caso se iniciar&aacute; el tr&aacute;mite de notificaci&oacute;n.</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confNotifRequerimientoPago','1','combo','comboResultado','Resultado notificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,'DDPositivoNegativo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confNotifRequerimientoPago','2','date','fecha','Fecha',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_confNotifRequerimientoPago','3','textarea','observaciones','Observaciones',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_BPMTramiteNotificacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Ejecuci&oacute;n del tr&aacute;mite de Notificación</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarDemandaOposicion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez notificado al demandado el auto de requerimiento de pago, en esta pantalla ha de indicar si el mismo se ha opuesto o no a la demanda.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposici&oacute;n, deber&aacute; informar la fecha de notificaci&oacute;n y la de celebraci&oacute;n de la vista.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;:<p style="margin-bottom: 10px; margin-left: 40px;">Si ha habido oposici&oacute;n: "Registrar celebraci&oacute;n de la vista"<p style="margin-bottom: 10px; margin-left: 40px;">Si no ha habido oposici&oacute;n: "Registrar auto despachando ejecuci&oacute;n"</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarDemandaOposicion','1','combo','comboOposicion','Existe oposición','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarDemandaOposicion','2','date','fecha','Fecha oposición',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarDemandaOposicion','3','date','fechaVista','Fecha vista',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarDemandaOposicion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarJuicioComparecencia','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de informar la fecha de celebraci&oacute;n de la vista.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar resoluci&oacute;n".</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarJuicioComparecencia','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarJuicioComparecencia','2','textarea','observaciones','Observaciones',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarResolucion','0','label','titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En ésta pantalla se deberá de informar la fecha de notificación de la Resolución que hubiere recaído como consecuencia de la vista celebrada.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificar dicha circunstancia al responsable interno de la misma a través del botón "Anotación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene ésta pantalla la siguiente tarea será "Resolución firme".</span></font></p></div>',null,null,null,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarResolucion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarResolucion','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,'DDFavorable','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarResolucion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_resolucionFirme','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&aacute; informar la fecha en la que la Resoluci&oacute;n adquiere firmeza.  En el momento se obtenga el testimonio de firmeza deber&aacute; adjuntarlo como documento acreditativo, aunque no tiene caracter obligatorio para la finalizaci&oacute;n de la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad..</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_resolucionFirme','1','date','fecha','Fecha firmeza','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_resolucionFirme','2','textarea','observaciones','Observaciones',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarAutoEjecucion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que no se ha presentado demanda de oposici&oacute;n, en esta pantalla, se deber&aacute; informar la fecha de notificaci&oacute;n del auto de despacho de ejecuci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarAutoEjecucion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false',null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_registrarAutoEjecucion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_BPMProvisionFondos','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se inicia el tr&aacute;mite de provisión de fondos</p></div>',null,null,null,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ016_BPMAnticipoFondos','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el trámite anticipo de fondos y pago de suplidos.</p></div>',null,null,null,null,'0','RECOVERY-2026')
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