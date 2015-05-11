/*
--##########################################
--## Author: Gonzalo Estellés
--## Adaptado a BP : Carlos Pérez
--## Finalidad: Procedimiento Tramite fase convenio V4	.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(      
	  T_TIPO_TPO('P408','T. fase convenio','T. fase convenio',null,'tramiteFaseConvenioV4','0','DD','0','CO',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('P408','P408_BPMtramitePresentacionPropConvenio',null,null,null,null,'P35','0','Se inicia Trámite de presentación propuesta de convenio','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_realizarValoracionConcurso',null,null,null,null,null,'0','Realizar la valoración del concurso','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_BPMTramiteFaseLiquidacion',null,null,null,null,'P31','0','Se inicia Trámite fase de liquidación','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_RegistrarOposicionAdmon',null,null,'(((valores[''P408_RegistrarOposicionAdmon''][''comboOposicion'']==DDSiNo.SI)&&(valores[''P408_RegistrarOposicionAdmon''][''fechaOposicion''] == ''''))||((valores[''P408_RegistrarOposicionAdmon''][''comboAdmision'']==DDSiNo.SI) && (valores[''P408_RegistrarOposicionAdmon''][''fechaAdmision'']=='''')) )?''tareaExterna.error.faltaAlgunaFecha'':((valores[''P408_RegistrarOposicionAdmon''][''comboAdmision'']==DDSiNo.NO) && (valores[''P408_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI) ? ''tareaExterna.error.combinacionIncoherente'' : (((valores[''P408_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.SI) && (NoExisteConvenioAdmitidoTrasAprovacion()))? ''tareaExterna.procedimiento.tramiteFaseComun.faltaConvAdmitidoTA'':(((valores[''P408_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO)&&(valores[''P408_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.NO)&&(NoExisteConvenioNoAdmitidoTrasAprovacion()))?''tareaExterna.procedimiento.tramiteFaseComun.faltaConvenioNoAdmitidoTrasAprovacion'': null)))','valores[''P408_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO ? ''NOADMISION'' : valores[''P408_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI ? ''SIOPOSICION'' : ''ADMSIOPONO''',null,'0','Registrar oposición y admisión judicial','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_actPropuestaConvenio',null,null,null,'valores[''P408_actPropuestaConvenio''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI'' ',null,'0','Actualizar propuestas de convenio','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_autoApertura',null,null,null,null,null,'0','Auto apertura','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_lecturaAceptacionInstrucciones','plugin/procedimientos/tramiteFaseConvenio/lecturaYaceptacionV4',null,' checkPosturaEnConveniosDeTercerosOConcursado() ?  null  : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura''','valores[''P408_lecturaAceptacionInstrucciones''][''comboAceptacion''] == DDSiNo.SI ? ''SI'' : ''NO'' ',null,'0','Aceptación de instrucciones','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_registrarResolucionOposicion',null,null,'todosLosConvenioEnEstadoFinal() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noTodosLosConvneiosEstanEnEstadoFinal'' ',null,null,'0','Registrar resolución oposición','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_registrarResultado','plugin/procedimientos/tramiteFaseConvenio/registrarResultadoConvenioV4',null,' existeNumeroAuto() ? ( checkPosturaEnConveniosDeTercerosOConcursado() ? ((valores[''P408_registrarResultado''][''algunConvenio''] == DDSiNo.SI) ? ( unConvenioAprovadoEnJunta() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noHayConvenioAprovado'' ) : (todosLosConveniosNoAdmitidos() ? null : ''tareaExterna.procedimiento.tramiteFaseConvenio.todosLosConvenioDebenEstarNoAdmitidos'')) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto'' ','valores[''P408_registrarResultado''][''comboAlgunConvenio''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Registrar resultado junta acreedores','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_registrarResultadoSubsana',null,null,'todosLosConvenioEnEstadoFinal() ? null :''tareaExterna.procedimiento.tramiteFaseComun.noTodosLosConvneiosEstanEnEstadoFinal''','valores[''P408_registrarResultadoSubsana''][''comboSubsana''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Registrar resultado subsanación','0','DD','0',null,'tareaExterna.cancelarTarea','01','1','EXTTareaProcedimiento','3',null,'39',null,null,null),
		T_TIPO_TAP('P408','P408_elevarAcomitePropuesta',null,null,null,null,null,'1','Elevar a comité la propuesta de instrucciones','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
		T_TIPO_TAP('P408','P408_registrarResultadoComite',null,null,null,'(valores[''P408_registrarResultadoComite''][''comboResultado''] == ''CONCEDIDO'' ? ''Concedido'':(valores[''P408_registrarResultadoComite''][''comboResultado''] == ''CONCONMOD'' ? ''ConcedidoConModificaciones'' :(valores[''P408_registrarResultadoComite''][''comboResultado''] == ''MODIFICAR'' ? ''Modificar'':''Denegado'')))',null,'1','Registrar el resultado del comité','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
		T_TIPO_TAP('P408','P408_aceptarFinSeguimiento',null,null,null,'valores[''P408_aceptarFinSeguimiento''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI'' ',null,'1','Aceptar fin de seguimiento','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'40',null,null,null),
		T_TIPO_TAP('P408','P408_decidirSobreFaseComun',null,null,null,'valores[''P408_decidirSobreFaseComun''][''comboPropio''] == DDSiNo.NO ? (valores[''P408_decidirSobreFaseComun''][''comboSeguimiento''] == DDSiNo.NO ? ''terminar'' : ''soloSeguimiento'') : (valores[''P408_decidirSobreFaseComun''][''comboSeguimiento''] == DDSiNo.NO ? ''soloPropia'' : ''propiaSeguimiento'')',null,'1','Decidir sobre fase convenio','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'40',null,null,null)
	  ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'P408_autoApertura','3*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_decidirSobreFaseComun','damePlazo(valores[''P408_autoApertura''][''fechaFase'']) + 5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_actPropuestaConvenio','5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_aceptarFinSeguimiento','5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_BPMtramitePresentacionPropConvenio','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_lecturaAceptacionInstrucciones','damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) - 5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_registrarResultado','damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) + 2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_RegistrarOposicionAdmon','damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) + 10*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_registrarResolucionOposicion','damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) + 10*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_registrarResultadoSubsana','damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) + 30*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_BPMTramiteFaseLiquidacion','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_elevarAcomitePropuesta','damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) - 25*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_registrarResultadoComite','damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) - 10*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'P408_realizarValoracionConcurso','damePlazo(valores[''P408_autoApertura''][''fechaJunta'']) - 30*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('P408_registrarResultado','2','combo','comboAlgunConvenio','Aprobación de algún convenio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_registrarResultado','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_RegistrarOposicionAdmon','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla debemos indicar tanto si se ha admitido el resultado de la junta de acreedores como si hay oposición.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p>- Si se presenta oposición: "Registrar resolución oposición"</p><p>- Si no se admite el resultado: "Registrar resultado subsanación"</p><p>- En caso de que se admita y no haya oposición se termina el trámite en curso por lo que se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_RegistrarOposicionAdmon','1','combo','comboAdmision','Admisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_RegistrarOposicionAdmon','2','date','fechaAdmision','Fecha admisión',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_RegistrarOposicionAdmon','3','combo','comboOposicion','Oposición','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_RegistrarOposicionAdmon','4','date','fechaOposicion','Fecha oposicion',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_RegistrarOposicionAdmon','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResolucionOposicion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar la fecha de notificación de la Resolución que hubiere recaído.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se indicará si el resultado de dicha resolución ha sido favorable o no.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá comunicar dicha circunstancia al responsable interno de la misma a través del botón "Comunicación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá abrir la pestaña "Convenios" de la ficha del asunto correspondiente y registrar el estado que corresponda, ya sea "Aprobación judicial" o "No aprobado".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla se termina el trámite en curso por lo que se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResolucionOposicion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResolucionOposicion','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','DD'),
		T_TIPO_TFI('P408_registrarResolucionOposicion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultadoSubsana','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar la fecha de notificación de la Resolución que hubiere recaído y el resultado de la subsanación si este es positivo o negativo.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><p>- Si se ha subsanado, una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p><p>- Si no se ha subsanado se iniciará un trámite de liquidación.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultadoSubsana','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultado','1','date','fechaJunta','Fecha junta de acreedores',null,null,'valores[''P408_autoApertura''] == null ? '''' : ( valores[''P408_autoApertura''][''fechaJunta''] )',null,'0','DD'),
		T_TIPO_TFI('P408_aceptarFinSeguimiento','1','combo','combo','Fin de seguimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_aceptarFinSeguimiento','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_BPMtramitePresentacionPropConvenio','0','label','titulo','Se inicia Trámite de presentación propuesta de convenio',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_lecturaAceptacionInstrucciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla el gestor atiende las instrucciones propuestas por el comité para la junta de acreedores.</p><p>Para el caso que se entienda que en las instrucciones dadas por el comité existe algún error, no deberá aceptar las mismas, explicando el motivo en el campo "Observaciones" o enviando un comunicado al supervisor. En este caso, deberá esperar a recibir, por parte del supervisor, las instrucciones que procedan.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se iniciará la tarea "Registrar resultado junta de acreedores".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_lecturaAceptacionInstrucciones','1','date','fechaJunta','Fecha junta de acreedores',null,null,'valores[''P408_autoApertura''] == null ? '''' : ( valores[''P408_autoApertura''][''fechaJunta''] )',null,'0','DD'),
		T_TIPO_TFI('P408_lecturaAceptacionInstrucciones','2','htmleditor','propuestaInstrucciones','Instrucciones entidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''P408_registrarResultado''] == null ? '''' : (valores[''P408_registrarResultado''][''propuestaInstrucciones''])',null,'0','DD'),
		T_TIPO_TFI('P408_lecturaAceptacionInstrucciones','3','combo','comboAceptacion','Leído y aceptado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_lecturaAceptacionInstrucciones','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_decidirSobreFaseComun','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el primer campo indíquese si se quiere que el gestor registre una propuesta de convenio de la propia entidad, en el segundo campo indíquese si se quiere realizar un seguimiento de los convenios propuestos por terceros que puedan surgir durante la fase convenio. Si ya hubiere Convenio propio de la entidad registrado, o adhesión a otro convenio propio o presentado por otros, no se deberán registrar más convenio.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"><p>En caso de que no quiera registrar un convenio propio en estos momentos, puede hacerlo cuando quiera hasta la fecha hábil por medio del "Trámite de presentación propuesta de convenio" que le guiará para dar de alta el convenio propio en la pestaña "Convenios" de la ficha del asunto correspondiente.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciará una tarea por cada una de las decisiones tomadas, en el caso de querer registrar un convenio propio se iniciará un "Trámite presentación de propuesta de convenio propia" o en el caso de querer hacer un seguimiento sobre otras propuestas se creará la tarea "Actualizar propuesta de convenio".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En caso de no querer registrar ningún convenio propio o de terceros, no se lanzará ninguna otra tarea respecto al seguimiento de los convenios.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_decidirSobreFaseComun','1','combo','comboPropio','Registrar convenio propio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_decidirSobreFaseComun','2','combo','comboSeguimiento','Seguimiento de otros convenios','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_decidirSobreFaseComun','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_actPropuestaConvenio','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El seguimiento de un convenio de terceros se mantendrá mientras se introduzca un "No" en el campo "Terminar seguimiento".</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para registrar los convenio propuestos por terceros deberá abrir la ficha del asunto correspondiente y en la pestaña "Convenios" darlos de alta.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciará, en el caso de introducir un "No" esta misma tarea, en el caso de Introducir un "Si" se iniciará la tarea "Aceptar fin de seguimiento" a realizar por el supervisor asignado a la actuación.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_actPropuestaConvenio','1','combo','combo','Terminar seguimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_actPropuestaConvenio','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_autoApertura','2','date','fechaJunta','Fecha junta de acreedores','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('P408_autoApertura','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_autoApertura','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha en la que se nos notifica auto por el que se inicia la fase de convenio, así como la fecha en la que se celebrará la junta de acreedores.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.
		Una vez rellene esta pantalla se iniciarán dos tareas, "Decidir sobre fase de convenios", (tarea que deberá ser completada por el Supervisor asignado a la actuación), y otra, correspondiente al gestor, denominada "Realizar valoración del concurso".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_autoApertura','1','date','fechaFase','Fecha auto fase convenio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Habiéndose celebrado la junta de acreedores, registrar el resultado de la misma. Se ha de consignar la fecha de celebración y observaciones al supervisor si da lugar a ello e indicar si se ha aprobado alguno de los convenios presentados.</p><br><p>Para dar por terminada esta tarea deberá abrir la pestaña "Convenios" de la ficha del asunto correspondiente y actualizar el estado de los convenios con el correspondiente ya sea "Aprobado en junta" o "No admitido a trámite".</p><br><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><br><p>Una vez rellene esta pantalla la siguiente tarea será "Registrar oposición y admisión judicial".</p><br><p>En el campo "Situación concursal" deberá indicar la situación en la que queda el concurso una vez completada esta tarea.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultadoSubsana','2','combo','comboSubsana','Subsanado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_registrarResultadoSubsana','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_BPMTramiteFaseLiquidacion','0','label','titulo','Se inicia Trámite fase de liquidación',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_elevarAcomitePropuesta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá revisar el informe de valoración del concurso presentado por el letrado, para ello deberá abrir la tarea ya completada por el letrado "Realizar valoración del concurso" donde el letrado a introducido dicho informe. Una vez revisado el informe deberá de cumplimentar el campo propuesta de instrucciones, donde propondrá según su criterio las instrucciones para el concurso al comité correspondiente.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha en que da por concluido su informe y procede a terminar la tarea.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Al dar por terminada esta tarea se creará la tarea "Registrar resultado comité" a completar por el comité correspondiente.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_elevarAcomitePropuesta','1','date','fechaElevacion','Fecha elevación a comité','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('P408_elevarAcomitePropuesta','2','htmleditor','propuestaInstrucciones','Propuesta de instrucciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultadoComite','1','date','fechaAprobacion','Fecha de obtención de aprobación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultadoComite','2','htmleditor','propuestaInstrucciones','Instrucciones propuestas','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''P408_elevarAcomitePropuesta''] == null ? '''' : (valores[''P408_elevarAcomitePropuesta''][''propuestaInstrucciones''])',null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultadoComite','3','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDResultadoComiteConcursal','0','DD'),
		T_TIPO_TFI('P408_realizarValoracionConcurso','1','date','fechaConclusionInforme','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('P408_realizarValoracionConcurso','2','combo','comboConvenioPresentado','Se ha presentado algún convenio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_realizarValoracionConcurso','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_registrarResultadoComite','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez celebrado el Comité deberá consignar la fecha en que haya resuelto sobre la propuesta y el resultado de la misma. En el campo "Instrucciones propuestas" podrá modificar si así fuera necesario, las instrucciones propuestas por el supervisor de manera que estas lleguen al letrado.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez cumplimentada esta tarea y dependiendo del resultado del comité, la siguiente tarea será:</p><p>- Concedido, en cuyo caso la siguiente tarea será "Lectura y aceptación de instrucciones" a completar por el letrado concursal.</p><p>- Concedido con modificaciones, el convenio ha sido modificado por el comité y por tanto la siguiente tarea será "Lectura y aceptación de instrucciones" a completar por el letrado concursal.</p><p>- Modificar, el convenio requiere de algunas modificaciones las cuales deben ser realizadas por el supervisor, en este caso la siguiente tarea volvería a ser "Elevar a comité propuesta de instrucciones" a realizar por el supervisor del concurso.</p><p>- Denegada, en cuyo caso se abrirá una tarea en la que el letrado concursal deberá proponer, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_realizarValoracionConcurso','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá indicar si se ha presentado algún convenio o no, en caso de contestar afirmativamente deberá abrir la pestaña "Convenios" de la ficha del asunto correspondiente y comprobar que al menos un convenio haya quedado registrado, en caso de no estarlo ya deberá proceder a su registro debiendo indicar si es de tipo Ordinario o Anticipado, el estado en el que se encuentra y la postura de la Entidad, así como el contenido del mismo respecto de cada tipología de créditos. Si el convenio tiene varias alternativas de adhesión deberán registrarse todas ellas.</p><br><p>En el campo Informe deberá introducir el informe que quiere remitir a su supervisor en la entidad. No olvide indicar, en caso de adherirnos a un convenio, si la propuesta de adhesión se refiere exclusivamente a los créditos ordinarios o por el contrario incluye también los privilegiados, así como cualquier otro comentario considerado como relevante.</p><br><p>En el campo Fecha indicar la fecha en que da por concluido su informe y procede a terminar la tarea.</p><br><p>Una vez complete esta tarea la siguiente tarea será "Elevar a comité propuesta de instrucciones" a realizar por el supervisor del concurso.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('P408_realizarValoracionConcurso','3','htmleditor','informe','Informe','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('P408_aceptarFinSeguimiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Indíquese si acepta el fin de seguimiento de otros convenios propuestos por terceros.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez rellene esta pantalla se dará por concluido el seguimiento de propuestas de convenio de terceros.</p></div>',null,null,null,null,'0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TPO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... Ya existe el procedimiento '''|| TRIM(V_TMP_TIPO_TPO(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
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
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');
    
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||'''');
        ELSE
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
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(19)),'''','''''') || ''',' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
                    
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
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
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(1)) ||'''');
        ELSE
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
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
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
          END IF;
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