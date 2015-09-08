--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=2015813
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-401
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite subasta concursal
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H003';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('CJ004','T. de subasta concursal - HCJ','Trámite de subasta concursal - HCJ','','cj_tramiteSubastaConcursal','0','dd','0','AP',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'CJ004',
        /*TAP_CODIGO...................:*/ 'CJ004_RevisarDocumentacion',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Revisar documentación',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ 'TGESCON',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'SUCON',
        /*TAP_BUCLE_BPM................:*/ null        
        ),     
      T_TIPO_TAP('CJ004','CJ004_AdjuntarInformeOficina',null,'valores[''CJ004_AdjuntarInformeOficina''][''comboEdificacion''] == DDSiNo.SI && valores[''CJ004_AdjuntarInformeOficina''][''comboFinalizada''] == DDSiNo.SI && valores[''CJ004_AdjuntarInformeOficina''][''comboDocumentacion''] == DDSiNo.SI ? (comprobarExisteDocumentoCERFIO() ? (comprobarExisteDocumentoLICPRIO() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Licencia primera ocupación.</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Certificado final de obra.</div>'') : null',null,null,null,'0','Adjuntar informe oficina','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TGESOF',null,'GESINC',null),
      T_TIPO_TAP('CJ004','CJ004_AdjuntarTasaciones',null,null,null,null,null,'0','Adjuntar tasaciones','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'TGESCON',null,'SUCON',null),      
      T_TIPO_TAP('CJ004','CJ004_AdjuntarInformeFiscal',null,'comprobarExisteDocumentoIFISCAL() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Informe Fiscal.</div>''',null,null,null,'0','Adjuntar informe fiscal','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'TGESCON',null,'SUCON',null),      
      T_TIPO_TAP('CJ004','CJ004_ValidarInformeDeSubasta',null,'comprobarExisteDocumentoINSUFI() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Informe Subasta Firmado.</div>''',null,'valores[''CJ004_ValidarInformeDeSubasta''][''comboModificacion''] == DDSiNo.SI ? ''Rechazado'' : ''Aceptado'' ',null,'0','Validar informe de subasta','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TSUCON',null,'DIRCON',null),     
      T_TIPO_TAP('CJ004','CJ004_EnviarInstruccionesProcurador',null,'comprobarInformacionCompletaInstrucciones() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''',null,null,null,'0','Enviar instrucciones al procurador','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TGESCON',null,'SUCON',null),     
      T_TIPO_TAP('CJ004','CJ004_CalcularDeudaActualizada',null,'comprobarExisteDocumentoCERDEU() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Certificado de deuda.</div>''',null,null,null,'0','Calcular deuda actualizada','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TSUADMCON',null,'SUCON',null),
      T_TIPO_TAP('CJ004','CJ004_ActualizarDeudaJuzgado',null,null,null,null,null,'0','Actualizar deuda presentada en el juzgado','0','DD','0',null,'tareaExterna.cancelarTarea',null,'0','EXTTareaProcedimiento','3',null,'TGESCON',null,'SUCON',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'CJ004_RevisarDocumentacion','damePlazo(valores[''CJ004_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 30*24*60*60*1000L','0','0','DD'),   
      T_TIPO_PLAZAS(null,null,'CJ004_AdjuntarInformeOficina','damePlazo(valores[''CJ004_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 25*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'CJ004_AdjuntarTasaciones','damePlazo(valores[''CJ004_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 25*24*60*60*1000L','0','0','DD'),      
      T_TIPO_PLAZAS(null,null,'CJ004_AdjuntarInformeFiscal','damePlazo(valores[''CJ004_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 25*24*60*60*1000L','0','0','DD'),     
      T_TIPO_PLAZAS(null,null,'CJ004_ValidarInformeDeSubasta','damePlazo(valores[''CJ004_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 7*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'CJ004_EnviarInstruccionesProcurador','damePlazo(valores[''CJ004_SenyalamientoSubasta''][''fechaSenyalamiento'']) - 1*24*60*60*1000L','0','0','DD'),      
      T_TIPO_PLAZAS(null,null,'CJ004_CalcularDeudaActualizada','7*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'CJ004_ActualizarDeudaJuzgado','5*24*60*60*1000L','0','0','DD')   
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(20000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    	T_TIPO_TFI('CJ004_SenyalamientoSubasta','5','number','tipoSubasta','Edicto. Tipo de subasta',null,null,null,null,'0','DD'),	
    
        T_TIPO_TFI('CJ004_RevisarDocumentacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar:</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la de la tasaci&oacute;n de cada uno de los bienes. En caso de que sea superior a 6 meses solicite una nueva tasaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">-La antigüedad de la certificaci&oacute;n de cargas de cada uno de los bienes en la ficha del bien. En caso de que tengan una antigüedad superior a 3 meses, solicite las notas simples actualizadas.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si es necesario el informe fiscal en cuyo caso deber&aacute; solicitarlo.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si es necesario solicitar un informe a la oficina sobre la situaci&oacute;n del acreditado, en cuyo caso deber&aacute; solicitarlo.</p><p style="margin-bottom: 10px">A trav&eacute;s del bot&oacute;n "Notificaci&oacute;n" deber&aacute; notificar a la oficina el se&ntilde;alamiento de subasta y los bienes a subastar.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; se&ntilde;alar la fecha en la que hace esta revisi&oacute;n.</p>'
        	||'<p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Preparar informe de subasta" y adem&aacute;s:</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si solicita tasaci&oacute;n, se lanzar&aacute; la tarea "Adjuntar tasaciones"</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si solicita informe fiscal, se lanzar&aacute; la tarea "Adjuntar informe fiscal"</p><p style="margin-bottom: 10px; margin-left: 40px;">-Si solicita informe de la oficina, se lanzar&aacute; la tarea "Adjuntar informe oficina" a la oficina.</p><p style="margin-bottom: 10px; margin-left: 40px;">-"Revisar documentaci&oacute;n”.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_RevisarDocumentacion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('CJ004_RevisarDocumentacion','2','combo','comboNota','Solicita nota simple','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_RevisarDocumentacion','3','combo','comboTasacion','Solicita tasación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_RevisarDocumentacion','4','combo','comboInforme','Solicita informe fiscal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_RevisarDocumentacion','5','combo','comboOficina','Solicita informe oficina','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_RevisarDocumentacion','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute;  de proporcionar la siguiente informaci&oacute;n:</p><p style="margin-bottom: 10px; margin-left: 40px;">1. Estado posesorio : Determinar si la oficina tiene conocimiento, indicios o ha verificado al personarse en el propio bien financiado por la entidad, de que en el mismo existan ocupantes con t&iacute;tulo suficiente  (alquileres debidamente constituidos) o ilegalmente. Si los bienes se encuentran en buen estado o consta que se est&eacute;n desarrollando actos vand&aacute;licos as&iacute; como espolios en dichos bienes. Para cotejar lo anterior ser&aacute; preciso personarse en el bien/es que garantizan la operaci&oacute;n.</p>'
        	||'<p style="margin-bottom: 10px; margin-left: 40px;">2. De tratarse de edificaciones  se precisa conocer :</p><p style="margin-bottom: 10px; margin-left: 50px;">A) Si la obra se encuentra finalizada:</p><p style="margin-bottom: 10px; margin-left: 50px;">En el caso que nos conste que la obra se encuentre finalizada se necesita disponer de la siguiente documentaci&oacute;n:</p><p style="margin-bottom: 10px; margin-left: 60px;">a.1.) Certificado Final de Obra.</p><p style="margin-bottom: 10px; margin-left: 60px;">a.2.) Licencia Primera Ocupaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 60px;">Si dicha documentaci&oacute;n no consta en la oficina hay que gestionar su adquisici&oacute;n, y en el caso de no existir hay que conocer fehacientemente porque no existe (por ejemplo si no se le concedi&oacute; la licencia primera ocupaci&oacute;n hay que saber porqu&eacute; , que documentaci&oacute;n se  le requiri&oacute; y no fue aportada). En el caso que tengamos conocimiento que no existe habr&aacute; que verificar con el Ayuntamiento si dicha documentaci&oacute;n fue solicitada.</p><p style="margin-bottom: 10px; margin-left: 60px;">• Rogamos nos inform&eacute;is si se trata de viviendas de Protecci&oacute;n Oficial</p><p style="margin-bottom: 10px; margin-left: 50px;">B) Si la obra no se encuentra finalizada:</p>'
        	||'<p style="margin-bottom: 10px; margin-left: 50px;">Para este caso es preciso que conozcamos el estado constructivo ante el que nos encontramos y el grado de ejecuci&oacute;n de la obra.</p><p style="margin-bottom: 10px; margin-left: 40px;">3. Si en los bienes se desarrolla actividad econ&oacute;mica:</p><p style="margin-bottom: 10px; margin-left: 50px;">Para el supuesto que conste que en el bien/es que garantizan la operaci&oacute;n de financiaci&oacute;n se desarrolla una actividad econ&oacute;mica, se precisa conocer:</p><p style="margin-bottom: 10px; margin-left: 60px;">a.1.) Que actividad se desarrolla.</p><p style="margin-bottom: 10px; margin-left: 60px;">a.2.) N&uacute;mero de empleados.</p><p style="margin-bottom: 10px; margin-left: 40px;">4. As&iacute; como cualquier informaci&oacute;n que estim&eacute;is debamos conocer.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','2','combo','comboOcupantes','Ocupantes','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','3','combo','comboEstadoBien','Estado del bien','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDEstadoBien','0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','4','combo','comboEdificacion','Edificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','5','combo','comboFinalizada','Obra finalizada',null,null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','6','combo','comboVpo','VPO',null,null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','7','combo','comboDocumentacion','Adjunta documentación de la obra',null,null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','8','text','ejecucionObra','Grado de ejecución de la obra',null,null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','9','combo','comboActividad','Desarrollo de actividad económica','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','10','text','actividad','Actividad',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','11','number','numEmpleados','Número empleados',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeOficina','12','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('CJ004_AdjuntarTasaciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; actualizar la informaci&oacute;n en la ficha del "Bien"  de cada uno de los bienes de la subasta.</p><p style="margin-bottom: 10px">En caso de que requiera solicitar el informe fiscal, deber&aacute; dejar constancia de ello en la herramienta y ponerse en contacto con el &aacute;rea Fiscal para que generen el informe.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, la siguiente tarea ser&aacute;, si ha marcado que solicita el informe fiscal, "Solicitar informe fiscal".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarTasaciones','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarTasaciones','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('CJ004_AdjuntarInformeFiscal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; actualizar la informaci&oacute;n en la ficha del "Bien"  de cada uno de los bienes de la subasta y adjuntar el informe fiscal al procedimiento.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeFiscal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('CJ004_AdjuntarInformeFiscal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('CJ004_ValidarInformeDeSubasta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; de revisar y dictaminar sobre el informe de subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de aceptar el informe de subasta, se la tarea de “Enviar instrucciones al procurador”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-Se lanzar&aacute; la tarea “Preparar propuesta informe de subasta” en caso de haber requerido el supervisor la modificaci&oacute;n de las instrucciones para la subasta.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_ValidarInformeDeSubasta','1','combo','comboModificacion','Requiere modificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_ValidarInformeDeSubasta','2','combo','comboSuspension','Solicitar Suspensión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('CJ004_ValidarInformeDeSubasta','3','combo','comboMotivo','Motivo de suspensión',null,null,null,'DDMotivoSuspension','0','DD'),
        T_TIPO_TFI('CJ004_ValidarInformeDeSubasta','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('CJ004_EnviarInstruccionesProcurador','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez que ha sido anunciada la subasta y han sido dictadas las instrucciones por la entidad, antes de dar por completada esta tarea deber&aacute; acceder a la pesta&ntilde;a “Subastas” de la ficha del asunto correspondiente y revisar las instrucciones dadas para cada uno de los bienes a subastar.</p><p style="margin-bottom: 10px">Informando la fecha se confirma haber recibido correctamente las instrucciones del responsable de la entidad, as&iacute; como la aceptaci&oacute;n de las mismas. Para el supuesto de que haya alguna duda al respecto, deber&aacute; ponerse en contacto con el responsable de la entidad para que se revisen o modifiquen dichas instrucciones.</p><p style="margin-bottom: 10px">Antes de dar por finalizada esta tarea deber&aacute; notificar al procurador las instrucciones dictadas por la entidad.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finalizada esta tarea, la siguiente tarea ser&aacute; "Celebraci&oacute;n de subasta".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_EnviarInstruccionesProcurador','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('CJ004_EnviarInstruccionesProcurador','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('CJ004_CelebracionSubasta','3','combo','comboOtorgamiento','Otorgamiento de Escritura',null,null,null,null,'0','DD'),
        
        
        T_TIPO_TFI('CJ004_ConfirmarRecepcionMandamientoDePago','3','combo','combocubierta','Cubierta totalmente la deuda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        
        T_TIPO_TFI('CJ004_CalcularDeudaActualizada','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez celebrada la subasta, el gestor de esta tarea deber&aacute; se&ntilde;alar la cuant&iacute;a de la deuda que falta por cubrir en el campo "Cuant&iacute;a Deuda" y la fecha en que finaliza eseta tarea.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez finalizada esta tarea, la siguiente ser&aacute; "Actualizar deuda presentada en el juzgado" al letrado.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_CalcularDeudaActualizada','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('CJ004_CalcularDeudaActualizada','2','currency','cuantia','Cuantía deuda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''CJ004_ConfirmarRecepcionMandamientoDePago''][''importe'']',null,'0','DD'),
        T_TIPO_TFI('CJ004_CalcularDeudaActualizada','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
        T_TIPO_TFI('CJ004_ActualizarDeudaJuzgado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; comunicar al juzado el certificado de deuda remitido por administraci&oacute;n contable.</p><p style="margin-bottom: 10px">Antes de rellenar esta pantalla,  deber&aacute; ir a la pesta&ntilde;a "Fase com&uacute;n" de la ficha del asunto correspondiente y proceder a la actualizaci&oacute;n de los cr&eacute;ditos insinuados anteriormente.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('CJ004_ActualizarDeudaJuzgado','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('CJ004_ActualizarDeudaJuzgado','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')     
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(100 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGESCON'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON'')' ||
	          ' ,TAP_DESCRIPCION = ''Comunicación con señalamiento de subasta'' ' ||
	          ' ,TAP_SCRIPT_VALIDACION = ''comprobarMinimoBienLote() ? (comprobarExisteDocumentoESRAS() ? (comprobarProvLocFinBien() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de inmueble, provincia, localidad y n&uacute;mero de finca.</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Al menos un bien debe estar asignado a un lote</div>'''' '' ' ||
	          ' ,TAP_VIEW = null' ||
	          ' ,TAP_CODIGO = ''CJ004_SenyalamientoSubasta'' ' ||
			  ' WHERE TAP_CODIGO = ''H003_SenyalamientoSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SenyalamientoSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGESCON'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON'')' ||
	          ' ,TAP_CODIGO = ''CJ004_PrepararInformeSubasta'' ' ||
	          ' ,TAP_DESCRIPCION = ''Preparar informe de subasta'' ' ||
	          ' ,TAP_SCRIPT_VALIDACION = ''comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoINS()? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el informe de subasta</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>'''' ''' ||
			  ' WHERE TAP_CODIGO = ''H003_PrepararPropuestaSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_PrepararInformeSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGESCON'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON'')' ||
			  ' ,TAP_CODIGO = ''CJ004_CelebracionSubasta'' ' ||
			  ' ,TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''CJ004_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? (valores[''''CJ004_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo Decisi&oacute;n suspensi&oacute;n es obligatorio</div>'''' : null) : (comprobarExisteDocumentoACS() ? (validarBienesDocCelebracionSubasta() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe rellenar en cada bien los datos de adjudicaci&oacute;n o de cesi&oacute;n remate</div>'''') :  ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Acta de subasta</div>'''') '' ' ||
	          ' ,TAP_VIEW = ''plugin/cajamar/tramiteSubastaConcursal/celebracionSubasta'' ' ||
			  ' WHERE TAP_CODIGO = ''H003_CelebracionSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_CelebracionSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''DGESCON'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON'')' ||
			  ' ,TAP_CODIGO = ''CJ004_CelebracionDecision'' ' ||		  
	          ' WHERE TAP_CODIGO = ''H003_ConcursalDecision''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_CelebracionDecision actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGESCON'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON'')' ||
	          ' ,TAP_CODIGO = ''CJ004_BPMTramiteAdjudicacion'' ' ||
			  ' WHERE TAP_CODIGO = ''H003_BPMTramiteAdjudicacion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_BPMTramiteAdjudicacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGESCON'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON'')' ||
	          ' ,TAP_CODIGO = ''CJ004_BPMTramiteCesionRemate'' ' ||
			  ' WHERE TAP_CODIGO = ''H003_BPMTramiteCesionRemate''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_BPMTramiteCesionRemate actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGESCON'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON'')' ||
	          ' ,TAP_CODIGO = ''CJ004_SolicitarMandamientoPago'' ' ||
			  ' WHERE TAP_CODIGO = ''H003_SolicitarMandamientoPago''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SolicitarMandamientoPago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGESCON'')' ||
	          ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON'')' ||
	          ' ,TAP_DESCRIPCION = ''Confirmar recepción de mandamiento de pago'' ' ||
	          ' ,TAP_CODIGO = ''CJ004_ConfirmarRecepcionMandamientoDePago'' ' ||
			  ' WHERE TAP_CODIGO = ''H003_ConfirmarRecepcionMandamientoDePago''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES PLAZOS--------------- */
	/* ------------------- --------------------------------- */
	 V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''CJ004_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])-20*24*60*60*1000L'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_PrepararInformeSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de CJ004_PrepararInformeSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''CJ004_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])-3*24*60*60*1000L'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_LecturaAceptacionInstrucciones'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de CJ004_LecturaAceptacionInstrucciones actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''CJ004_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de CJ004_CelebracionSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''CJ004_SenyalamientoSubasta''''][''''fechaSenyalamiento'''']) + 20*24*60*60*1000L'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_SolicitarMandamientoPago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de CJ004_SolicitarMandamientoPago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''CJ004_SenyalamientoSubasta''''][''''fechaSenyalamiento'''']) + 10*24*60*60*1000L'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_ConfirmarRecepcionMandamientoDePago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de CJ004_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez comunicada la subasta, en esta pantalla, deber&aacute; informar de la fecha de notificaci&oacute;n y de la fecha de celebraci&oacute;n de la subasta as&iacute; como el n&uacute;m. de auto de la misma.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; acceder a la pesta&ntilde;a "Subastas" del asunto correspondiente y asociar uno o mas bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta, deber&aacute; indicar a trav&eacute;s de la ficha del bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situaci&oacute;n posesoria.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute;n las siguientes tareas:</p><p style="margin-bottom: 10px; margin-left: 40px;">-"Celebraci&oacute;n subasta".</p><p style="margin-bottom: 10px; margin-left: 40px;">-"Revisar documentaci&oacute;n”.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SenyalamientoSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''Fecha celebración subasta'' ' ||
			  ' WHERE TFI_NOMBRE = ''fechaSenyalamiento'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SenyalamientoSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 6' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_SenyalamientoSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SenyalamientoSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; acceder desde la pesta&ntilde;a Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores y puja con postores. Una vez hecho esto podr&aacute; generar desde la pesta&ntilde;a Subastas el informe para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que haya adjuntado el informe para la subasta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea “Validar informe subasta”.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_PrepararInformeSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_PrepararInformeSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente informaci&oacute;n:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En el campo Celebrada deber&aacute; indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deber&aacute; indicar a trav&eacute;s de la pesta&ntilde;a Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En la ficha del bien se debe recoger el resultado de la  adjudicaci&oacute;n y el valor de la adjudicaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de suspensi&oacute;n de la subasta deber&aacute; indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisi&oacute;n suspensi&oacute;n” deber&aacute; informar quien ha provocado dicha suspensi&oacute;n y en el campo “Motivo suspensi&oacute;n” deber&aacute; indicar el motivo por el cual se ha suspendido.</p>'||
			  '<p style="margin-bottom:10px; margin-left: 40px;">-En caso de haberse adjudicado alguno de los bienes la Entidad, deber&aacute; indicar si ha habido Postores o no en la subasta y en el campo Cesi&oacute;n deber&aacute; indicar si se debe cursar la cesi&oacute;n de remate o no, seg&uacute;n el procedimiento establecido por la entidad.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; adjuntar el acta de subasta al procedimiento a trav&eacute;s de la pesta&ntilde;a "Adjuntos".</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes adjudicados a un tercero, se lanzar&aacute; la tarea “Solicitar mandamiento de pago”.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes con cesi&oacute;n de remate se lanzar&aacute; la tarea "Tr&aacute;mite de Cesi&oacute;n de Remate" por cada uno de ellos.</p>'||
			  '<p style="margin-bottom: 10px; margin-left: 40px;">-En caso de haber uno o m&aacute;s bienes adjudicados a la entidad, se lanzar&aacute; el "Tr&aacute;mite de Adjudicaci&oacute;n" por cada uno de ellos.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de suspensi&oacute;n de la subasta deber&aacute; indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisi&oacute;n suspensi&oacute;n” deber&aacute; informar quien ha provocado dicha suspensi&oacute;n y en el campo “Motivo suspensi&oacute;n” deber&aacute; indicar el motivo por el cual se ha suspendido. En este caso, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px; margin-left: 40px;">-En caso de que se celebre la subasta, adem&aacute;s, de lo indicado anteriormente, se lanzar&aacute; la tarea "Actualizar deuda presentada en el juzgado".</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_CelebracionSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 4 ' ||
			  ' WHERE TFI_NOMBRE = ''comboDecisionSuspension'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_CelebracionSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 5 ' ||
			  ' WHERE TFI_NOMBRE = ''comboMotivoSuspension'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_CelebracionSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 6 ' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_CelebracionSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_CelebracionSubasta actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de informar la fecha de presentaci&oacute;n en el juzgado del escrito solicitando la entrega de las cantidades consignadas.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; "Confirmar recepci&oacute;n mandamiento de pago".</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_SolicitarMandamientoPago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SolicitarMandamientoPago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se ha de informar la fecha y el importe en la que nos han entregado los mandamientos de pago de la cantidad informada por un tercero en concepto de pago del bien adjudicado, as&iacute; como indicar si la deuda queda totalmente cubierta o no.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">En caso de que la deuda no quede totalmente cubierta, se lanzar&aacute; el "tr&aacute;mite solicitud servicio de &iacute;ndices". En caso contrario, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_ConfirmarRecepcionMandamientoDePago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 4' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ004_ConfirmarRecepcionMandamientoDePago'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ConfirmarRecepcionMandamientoDePago actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  BORRADO CAMPOS--------------- */
	/* ------------------- --------------------------------- */
    
	 /* ------------------- --------------------------------- */
	/* --------------  BORRADO TAREAS--------------- */
	/* ------------------- --------------------------------- */
	V_TAREA:='H003_BPMInscripcionDelTitulo';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_BPMInscripcionDelTitulo actualizada.');
	
	V_TAREA:='H003_BPMTramiteConsignacion';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_BPMTramiteConsignacion actualizada.');
	
    V_TAREA:='H003_ValidarInformeDeSubastaYPrepararCuadroDePujas';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO='''||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ValidarInformeDeSubastaYPrepararCuadroDePujas actualizada.');
	
	V_TAREA:='H003_ElevarPropuestaAComite';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ElevarPropuestaAComite actualizada.');
	
	V_TAREA:='H003_SuspenderSubasta';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SuspenderSubasta actualizada.');
	
	V_TAREA:='H003_BPMTramiteTributacion';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_BPMTramiteTributacion actualizada.');
	
	V_TAREA:='H003_SolicitarServicioIndices';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SolicitarServicioIndices actualizada.');
	
	V_TAREA:='H003_ActualizarTasacion';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ActualizarTasacion actualizada.');
	
	V_TAREA:='H003_EsperaPosibleCesionRemate';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_EsperaPosibleCesionRemate actualizada.');
	
	V_TAREA:='H003_RegistrarRespuestaSareb';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_RegistrarRespuestaSareb actualizada.');
	
	V_TAREA:='H003_SolicitarDueDiligence';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SolicitarDueDiligence actualizada.');
	
	V_TAREA:='H003_RegistrarResultadoDueDiligence';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_RegistrarResultadoDueDiligence actualizada.');
	
	V_TAREA:='H003_AdjuntarInformeSubasta';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_AdjuntarInformeSubasta actualizada.');
	
	V_TAREA:='H003_SuspenderSubasta';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_SuspenderSubasta actualizada.');
	
	V_TAREA:='H003_ContactarConDeudorYPrepararInformeSubastaFisc';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO='''||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ContactarConDeudorYPrepararInformeSubastaFisc actualizada.');
	
	V_TAREA:='H003_CumplimentarParteEconomica';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_CumplimentarParteEconomica actualizada.');
	
	V_TAREA:='H003_ValidarPropuesta';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ValidarPropuesta actualizada.');
	
	V_TAREA:='H003_ElevarPropuestaASareb';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ElevarPropuestaASareb actualizada.');
	
	V_TAREA:='H003_ElevarPropuestaASarebIndices';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_ElevarPropuestaASarebIndices actualizada.');
	
	V_TAREA:='H003_RegistrarRespuestaSarebIndices';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_RegistrarRespuestaSarebIndices actualizada.');
	 
	V_TAREA:='H003_RegistrarResolucionSolicitudSuspension';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea CJ004_RegistrarResolucionSolicitudSuspension actualizada.');	
	
	
	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */

	
	-- LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Procedimientos');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' SET ' ||
        		' DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||''''||
        		' ,DD_TPO_DESCRIPCION='''||REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') ||''''||
        		' ,DD_TPO_DESCRIPCION_LARGA='''||REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') ||''''||
        		' ,DD_TPO_XML_JBPM='''||REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''')||''''||
				' WHERE DD_TPO_CODIGO='''|| V_COD_PROCEDIMIENTO ||'''';
        /*V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT ' ||
                    'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                    '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) || ''' FROM DUAL'; 
			*/
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
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
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''')
										|| ''',' ||'(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
										|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
          
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
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

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
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
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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