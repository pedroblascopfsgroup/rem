/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Procedimiento Ej. Titulo No Judicial
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
    	T_TIPO_TAP('CJ020','CJ020_InterposicionDemandaMasBienes' ,'plugin/cajamar/ejecucionTituloNoJudicial/interposicionDemanda' ,'!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : !comprobarExisteDocumentoEDH() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Es necesario adjuntar el Escrito de la demanda completo + copia sellada de la demanda.</p></div>'' : tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'' : null' ,null ,'valores[''CJ020_InterposicionDemandaMasBienes''][''provisionFondos''] == DDSiNo.SI ? (existeTipoGestor("CENTROPROCURA") ? ''conAnticipo'' : ''conProvision'') : ''sinProvision''' ,null ,'0','Interposición de la demanda + Marcado de bienes' ,'0','RECOVERY-2026','0' ,null,null ,1,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_AutoDespaEjecMasDecretoEmbargo' ,'plugin/cajamar/ejecucionTituloNoJudicial/autoDespachandoEjecucion' ,'comprobarExisteDocumentoADETNJ() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Auto despachando ejecuci&oacute;n (Ejecuci&oacute;n T&iacute;tulo No Judicial)" al procedimiento.</div>''' ,null ,'valores[''CJ020_AutoDespaEjecMasDecretoEmbargo''][''comboAdmisionDemanda''] == DDSiNo.SI ? ( valores[''CJ020_AutoDespaEjecMasDecretoEmbargo''][''bienesEmbargables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''' ,null ,'0','Auto despachando ejecución + Marcado bienes decreto embargo' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_BPMTramiteNotificacion' ,null ,null ,null ,null ,'P400' ,'0','Se inicia Trámite de Notificación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_BPMVigilanciaCaducidadAnotacion' ,null ,null ,null ,null ,'CJ062' ,'0','Ejecución de Vigilancia caducidad anotación de embargo' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_ConfirmarNotifiReqPago' ,null ,null ,'((valores[''CJ020_ConfirmarNotifiReqPago''][''comboConfirmacionReqPago''] == DDPositivoNegativo.POSITIVO) && (valores[''CJ020_ConfirmarNotifiReqPago''][''fecha''] == null))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null' ,'valores[''CJ020_ConfirmarNotifiReqPago''][''comboConfirmacionReqPago''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''' ,null ,'0','Confirmar notificación requerimiento de pago' ,'0','RECOVERY-2026','0' ,null ,null ,1,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_ConfirmarSiExisteOposicion' ,'plugin/cajamar/ejecucionTituloNoJudicial/confirmarSiExisteOposicion' ,null ,'((valores[''CJ020_ConfirmarSiExisteOposicion''][''comboConfirmacion''] == DDSiNo.SI) && ((valores[''CJ020_ConfirmarSiExisteOposicion''][''fecha''] == null)))?''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la fecha</div>'':null' ,'valores[''CJ020_ConfirmarSiExisteOposicion''][''comboConfirmacion''] == DDSiNo.SI ? ''SI'' : ''NO''' ,null ,'0','Confirmar si existe oposición' ,'0','RECOVERY-2026','0' ,null ,null ,1,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_ConfirmarPresentacionImpugnacion' ,null ,'comprobarExisteDocumentoEOETNJ() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Escrito de Oposici&oacute;n (Ejecuci&oacute;n T&iacute;tulo No Judicial)" al procedimiento.</div>''' ,null ,null ,null ,'0','Confirmar presentación impugnación' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_ConfirmarVista' ,'plugin/cajamar/ejecucionTituloNoJudicial/confirmarVista' ,null ,'((valores[''CJ020_ConfirmarVista''][''comboHayVista''] == DDSiNo.SI) && ((valores[''CJ020_ConfirmarVista''][''fechaVista''] == null)))?''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe indicar la fecha</div>'':null' ,'valores[''CJ020_ConfirmarVista''][''comboHayVista''] == DDSiNo.SI ? ''SI'' : ''NO''' ,null ,'0','Confirmar si hay vista' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_RegistrarCelebracionVista' ,null ,null ,null ,null ,null ,'0','Registrar celebración vista' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_RegistrarResolucion' ,null ,'comprobarExisteDocumentoRETNJ() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Resoluci&oacute;n (Ejecuci&oacute;n T&iacute;tulo No Judicial)" al procedimiento.</div>''' ,null ,null ,null ,'0','Registrar resolución' ,'0','RECOVERY-2026','0' ,null ,null ,1,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_ResolucionFirme' ,null ,null ,null ,null ,null ,'0','Resolución firme' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_JudicialDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_BPMProvisionFondos' ,null ,null ,null ,null ,'HC103' ,'0','Provisión de fondos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ020','CJ020_BPMAnticipoFondos' ,null ,null ,null ,null ,'P460' ,'0','Se inicia el trámite de anticipo de fondos y pago de suplidos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null)
	);
		V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ020_InterposicionDemandaMasBienes','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_AutoDespaEjecMasDecretoEmbargo','damePlazo(valores[''CJ020_InterposicionDemandaMasBienes''][''fechaInterposicion'']) + 60*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_BPMTramiteNotificacion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_BPMVigilanciaCaducidadAnotacion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_ConfirmarNotifiReqPago','30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_ConfirmarSiExisteOposicion','((valores[''CJ020_ConfirmarNotifiReqPago''][''fecha''] !='''') && (valores[''CJ020_ConfirmarNotifiReqPago''][''fecha''] != null)) ? damePlazo(valores[''CJ020_ConfirmarNotifiReqPago''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_ConfirmarPresentacionImpugnacion','damePlazo(valores[''CJ020_ConfirmarSiExisteOposicion''][''fecha'']) + 5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_ConfirmarVista','damePlazo(valores[''CJ020_ConfirmarPresentacionImpugnacion''][''fecha'']) + 10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_RegistrarCelebracionVista','damePlazo(valores[''CJ020_ConfirmarVista''][''fechaVista''])' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_RegistrarResolucion','valores[''CJ020_ConfirmarVista''][''comboHayVista''] == DDSiNo.SI ? damePlazo(valores[''CJ020_RegistrarCelebracionVista''][''fecha'']) + 30*24*60*60*1000L : damePlazo(valores[''CJ020_ConfirmarPresentacionImpugnacion''][''fecha'']) + 30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_ResolucionFirme','damePlazo(valores[''CJ020_RegistrarResolucion''][''fechaResolucion'']) + 20*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_BPMProvisionFondos','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ020_BPMAnticipoFondos','300*24*60*60*1000L' ,'0','0','RECOVERY-2026')
	); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
	    T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demanda e ind&iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, capital no vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">Debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pestaña de "Bienes".</p><p style="margin-bottom: 10px">En el campo "Solicitar provisi&oacute;n de fondos" deber&aacute; indicar si va a solicitar o no provisi&oacute;n de fondos.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Auto Despachando ejecuci&oacute;n + Marcado de bienes decreto embargo" y si ha marcado que requiere provisi&oacute;n de fondos, se lanzar&aacute; el "Tr&aacute;mite de solicitud de fondos".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','1','date' ,'fechaInterposicion','Fecha presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','2','combo' ,'nPlaza','Plaza' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'damePlaza()' ,'TipoPlaza','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','3','date' ,'fechaCierre','Fecha cierre' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','4','number' ,'principalDemanda','Principal de la demanda' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'dameTotalLiquidacionPCO()' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','5','number' ,'capitalVencido','Capital vencido (en el cierre)' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','6','number' ,'capitalNoVencido','Capital no vencido (en el cierre)' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','7','number','interesesOrdinarios','Intereses ordinarios (en el cierre)' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','8','number' ,'interesesDemora','Intereses de Demora (en el cierre)' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','9','combo' ,'provisionFondos','Solicitar provisión de fondos','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_InterposicionDemandaMasBienes','10','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_AutoDespaEjecMasDecretoEmbargo','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&oacute;n, el juzgado en el que ha reca&iacute;do la demanda y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de decreto de embargo para cada uno de los bienes en los que proceda en la pesta&ntilde;a de "Bienes".</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no as&iacute; como indicar si existen bienes registrables o no, lo que supondr&aacute;, seg&uacute;n su contestaci&oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px">- Si ha sido admitida a tr&aacute;mite la demanda "Confirmar notificaci&oacute;n del requerimiento de pago" al ejecutado y la actuaci&oacute;n "Vigilancia caducidad anotaciones de embargo" si adem&aacute;s indica que existen bienes registrables en el registro.</p><p style="margin-bottom: 10px">- Si no ha sido admitida la demanda se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_AutoDespaEjecMasDecretoEmbargo','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_AutoDespaEjecMasDecretoEmbargo','2','combo' ,'comboPlaza','Plaza del juzgado' ,null ,null ,'damePlaza()' ,'TipoPlaza','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_AutoDespaEjecMasDecretoEmbargo','3','combo' ,'numJuzgado','Nº Juzgado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'dameNumJuzgado()' ,'TipoJuzgado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_AutoDespaEjecMasDecretoEmbargo','4','textproc' ,'numProcedimiento','Nº de procedimiento' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'dameNumAuto()' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_AutoDespaEjecMasDecretoEmbargo','5','combo' ,'comboAdmisionDemanda','Demanda Admitida' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_AutoDespaEjecMasDecretoEmbargo','6','combo' ,'bienesEmbargables','Existen bienes embargables' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_AutoDespaEjecMasDecretoEmbargo','7','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_BPMTramiteNotificacion','0','label' ,'titulo','Se inicia Trámite de Notificación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_BPMVigilanciaCaducidadAnotacion','0','label' ,'titulo','Ejecución de Vigilancia caducidad anotación de embargo' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarNotifiReqPago','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez dictado el auto despachando ejecución, en esta pantalla, debe indicar si la notificación del requerimiento de pago se ha realizado satisfactoriamente, con lo que deberá indicar que es positivo, o no.</p><p style="margin-bottom: 10px">Deberá informar la fecha de notificación únicamente en el supuesto de que ésta se hubiese efectuado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p style="margin-bottom: 10px">- Notificación positiva: "Confirmar si existe oposición"</p><p style="margin-bottom: 10px">- Notificación negativa: en este caso se iniciará el Trámite de notificación.</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarNotifiReqPago','1','combo' ,'comboConfirmacionReqPago','Resultado notificación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDPositivoNegativo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarNotifiReqPago','2','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarNotifiReqPago','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarSiExisteOposicion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez notificado al demandado el auto de despachando ejecución, en esta pantalla ha de indicar si el mismo se ha opuesto o no a la demanda.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposición, deberá informar la fecha de notificación.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p style="margin-bottom: 10px">- Si no hay oposición: se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p><p style="margin-bottom: 10px">- Si hay oposición: "Confirmar presentación impugnación".</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarSiExisteOposicion','1','combo' ,'comboConfirmacion','Existe oposición' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarSiExisteOposicion','2','date' ,'fecha','Fecha oposición' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarSiExisteOposicion','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarPresentacionImpugnacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que en el proceso ha habido oposición por parte del ejecutado, en esta pantalla, debemos informar la fecha de presentación en el Juzgado del escrito de impugnación de la oposición presentada por el contrario e indicar el motivo de la oposición y adjuntar como documento obligatorio el escrito de oposición.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Confirmar si hay vista".</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarPresentacionImpugnacion','1','date' ,'fecha','Fecha presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarPresentacionImpugnacion','2','text' ,'motivo','Indicar motivo oposición' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarPresentacionImpugnacion','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarVista','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez presentada la impugnación de la oposición del ejecutado, en esta pantalla, debemos de señalar si por el Juzgado se ha admitido la celebración de vista.</p><p style="margin-bottom: 10px">El siguiente campo únicamente deberá ser cumplimentado para el supuesto de que se hubiere confirmado la celebración de la vista, debiendo informarse la fecha que el juzgado hubiere señalado para la misma.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, en el caso que hubiere vista, será "Registrar celebración vista". En caso contrario "Registrar resolución"</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarVista','1','combo' ,'comboHayVista','Hay vista' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarVista','2','date' ,'fechaVista','Fecha vista' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ConfirmarVista','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_RegistrarCelebracionVista','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de informar la fecha de celebración de la vista.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar resolución".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_RegistrarCelebracionVista','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_RegistrarCelebracionVista','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_RegistrarResolucion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deberá de informar la fecha de notificación de la Resolución que hubiere recaído como consecuencia de la vista celebrada.</p><p style="margin-bottom: 10px">Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá comunicar dicha circunstancia al responsable interno de la misma a través del botón "Comunicación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Resolución firme".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_RegistrarResolucion','1','date' ,'fechaResolucion','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_RegistrarResolucion','2','combo' ,'combo','Resultado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDFavorable','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_RegistrarResolucion','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ResolucionFirme','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&aacute; informar la fecha en la que la Resoluci&oacute;n adquiere firmeza. En el momento se obtenga el testimonio de firmeza deber&aacute; adjuntarlo como documento acreditativo, aunque no tiene caracter obligatorio para la finalizaci&oacute;n de la tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ResolucionFirme','1','date' ,'fechaResolucion','Fecha firmeza' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_ResolucionFirme','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ020_BPMAnticipoFondos','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el trámite anticipo de fondos y pago de suplidos.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026')    
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