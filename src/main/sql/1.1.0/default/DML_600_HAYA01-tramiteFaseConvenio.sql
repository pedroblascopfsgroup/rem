/*
--######################################################################
--## Author: Gonzalo
--## BPM: T. Calificacion (H035)
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
    
    CODIGO_PROCEDIMIENTO_ANTIGUO VARCHAR2(10 CHAR) := 'P408'; -- Variable con el código (DD_TPO_ID) del procedimiento antiguo para poder desactivarlo

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
		T_TIPO_TPO('H017','T. fase convenio','T. fase convenio',null,'haya_tramiteFaseConvenioV4','0','DD','0','CO',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('H017','H017_BPMElevarPropuestaSAREB1',null,null,null,null,'H010','0','Elevar Propuesta a Sareb','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_BPMElevarPropuestaSAREB2',null,null,null,null,'H010','0','Elevar Propuesta a Sareb 2','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_BPMTramiteFaseLiquidacion',null,null,null,null,null,'0','Se inicia Trámite fase de liquidación','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_BPMTramiteSegCumplConvenio',null,null,null,null,null,'0','Se inicia Trámite Seguimiento Cumplimiento Convenio','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_BPMtramitePresentacionPropConvenio',null,null,null,null,null,'0','Se inicia Trámite de presentación propuesta de convenio','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_PreparaPropInstSareb',null,null,null,null,null,'0','Preparar Propuesta instrucciones para Sareb','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'800',null,null,null),
		T_TIPO_TAP('H017','H017_RegistrarOposicionAdmon',null,null,'(((valores[''H017_RegistrarOposicionAdmon''][''comboOposicion'']==DDSiNo.SI)&&(valores[''H017_RegistrarOposicionAdmon''][''fechaOposicion''] == null))||((valores[''H017_RegistrarOposicionAdmon''][''comboAdmision'']==DDSiNo.SI) && (valores[''H017_RegistrarOposicionAdmon''][''fechaAdmision'']== null)) )?''tareaExterna.error.faltaAlgunaFecha'':((valores[''H017_RegistrarOposicionAdmon''][''comboAdmision'']==DDSiNo.NO) && (valores[''H017_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI) ? ''tareaExterna.error.combinacionIncoherente'' : (((valores[''H017_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.SI) && (NoExisteConvenioAdmitidoTrasAprovacion()))? ''tareaExterna.procedimiento.tramiteFaseComun.faltaConvAdmitidoTA'':(((valores[''H017_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO)&&(valores[''H017_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.NO)&&(NoExisteConvenioNoAdmitidoTrasAprovacion()))?''tareaExterna.procedimiento.tramiteFaseComun.faltaConvenioNoAdmitidoTrasAprovacion'': null)))','valores[''H017_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO ? ''NOADMISION'' : valores[''H017_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI ? ''SIOPOSICION'' : ''ADMSIOPONO''',null,'0','Registrar oposición y admisión judicial','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_aceptarFinSeguimiento',null,null,null,'valores[''H017_aceptarFinSeguimiento''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI''',null,'0','Aceptar fin de seguimiento','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'800',null,null,null),
		T_TIPO_TAP('H017','H017_actPropuestaConvenio',null,'comprobarExisteDocumentoPCTER() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para poder continuar debe adjuntar el documento "Propuesta Convenio Tercero".</p></div>''',null,'valores[''H017_actPropuestaConvenio''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI''',null,'0','Actualizar propuestas de convenio','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_autoApertura',null,null,null,null,null,'0','Auto apertura','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_decidirSobreFaseConvenio',null,null,null,'valores[''H017_decidirSobreFaseConvenio''][''comboPropio''] == DDSiNo.NO ? (valores[''H017_decidirSobreFaseConvenio''][''comboSeguimiento''] == DDSiNo.NO ? ''terminar'' : ''soloSeguimiento'') : (valores[''H017_decidirSobreFaseConvenio''][''comboSeguimiento''] == DDSiNo.NO ? ''soloPropia'' : ''propiaSeguimiento'')',null,'0','Decidir sobre fase convenio','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_lecturaAceptacionInstrucciones','plugin/procedimientos-bpmHaya/tramiteFaseConvenio/lecturaYaceptacion',null,null,null,null,'0','Lectura y Aceptación de instrucciones','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_realizarValoracionConcurso','plugin/procedimientos-bpmHaya/genericFormOverSize','comprobarExisteDocumentoINFVL() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para poder continuar debe adjuntar el documento "Informe Valoraci&oacute;n Letrado".</p></div>''','valores[''H017_realizarValoracionConcurso''][''comboConvenioPresentado'']==DDSiNo.SI && !existenConveniosDefinidos() ? ''Debe registrar al menos un convenio desde la pesta&nacute;a "Convenios" del asunto.'' : (valores[''H017_realizarValoracionConcurso''][''comboConvenioPresentado'']==DDSiNo.NO && existenConveniosDefinidos() ? ''Se ha definido alg&uacute;n convenio en la pestaña pesta&nacute;a "Convenios" del asunto.'' : null)',null,null,'0','Realizar la valoración del concurso','0','DD','0',null,null,'01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_registrarResolucionOposicion',null,'comprobarExisteDocumentoAUTORE() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para poder continuar debe adjuntar el documento "Autoresoluci&oacute;n".</p></div>''','todosLosConvenioEnEstadoFinal() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noTodosLosConvneiosEstanEnEstadoFinal''','valores[''H017_registrarResolucionOposicion''][''comboResultado''] == DDFavorable.FAVORABLE ? ''SI'' : ''NO''',null,'0','Registrar Resultado Oposición','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_registrarResultado','plugin/procedimientos-bpmHaya/tramiteFaseConvenio/registrarResultadoConvenio',null,'existeNumeroAuto() ? (checkPosturaEnConveniosDeTercerosOConcursado() ? (valores[''H017_registrarResultado''][''comboAlgunConvenio''] == DDSiNo.SI ? (unConvenioAprovadoEnJunta() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noHayConvenioAprovado'' ) : (todosLosConveniosNoAdmitidos() ? null : ''tareaExterna.procedimiento.tramiteFaseConvenio.todosLosConvenioDebenEstarNoAdmitidos'')) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto''','valores[''H017_registrarResultado''][''comboAlgunConvenio''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Registrar resultado junta acreedores','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_registrarResultadoSubsana',null,null,'todosLosConvenioEnEstadoFinal() ? null :''tareaExterna.procedimiento.tramiteFaseComun.noTodosLosConvneiosEstanEnEstadoFinal''','valores[''H017_registrarResultadoSubsana''][''comboSubsana''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Registrar Resultado Subsanación','0','DD','0',null,'tareaExterna.cancelarTarea','01','0','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null),
		T_TIPO_TAP('H017','H017_revisarEjecucionesParalizadas',null,null,null,null,null,'0','Revisar ejecuciones paralizadas','0','DD','0',null,null,'01','1','EXTTareaProcedimiento','3',null,'39',null,'GUCL',null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'H017_autoApertura','3*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_revisarEjecucionesParalizadas','3*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_decidirSobreFaseConvenio','damePlazo(valores[''H017_autoApertura''][''fechaFase'']) + 5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_BPMElevarPropuestaSAREB1','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_BPMtramitePresentacionPropConvenio','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_actPropuestaConvenio','5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_aceptarFinSeguimiento','5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_realizarValoracionConcurso','damePlazo(valores[''H017_autoApertura''][''fechaJunta'']) - 30*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_PreparaPropInstSareb','3*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_BPMElevarPropuestaSAREB2','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_lecturaAceptacionInstrucciones','damePlazo(valores[''H017_autoApertura''][''fechaJunta'']) - 5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_registrarResultado','damePlazo(valores[''H017_autoApertura''][''fechaJunta'']) + 2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_RegistrarOposicionAdmon','damePlazo(valores[''H017_autoApertura''][''fechaJunta'']) + 5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_BPMTramiteSegCumplConvenio','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_registrarResolucionOposicion','15*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_registrarResultadoSubsana','damePlazo(valores[''H017_autoApertura''][''fechaJunta'']) + 30*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H017_BPMTramiteFaseLiquidacion','300*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('H017_autoApertura','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">Informar fecha en la que se nos notifica auto por el que se inicia la fase de convenio, as&iacute; como la fecha en la que se celebrar&aacute; la junta de acreedores.</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px; ">Una vez rellene esta pantalla se iniciar&aacute;n dos tareas, "Decidir sobre fase de convenios", (tarea que deber&aacute; ser completada por el Supervisor asignado a la actuaci&oacute;n), y otra, correspondiente al gestor, denominada "Realizar valoraci&oacute;n del concurso".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_autoApertura','1','date','fechaFase','Fecha auto fase convenio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H017_autoApertura','2','date','fechaJunta','Fecha junta de acreedores','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H017_autoApertura','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_revisarEjecucionesParalizadas','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; acceder a la pesta&ntilde;a "An&aacute;lisis de contratos" de la ficha del asunto correspondiente y revisar el estado del an&aacute;lisis de las operaciones que forman parte del concurso. Recuerde que dispone de las anotaciones para consultar al letrado cualquier detalle que considere oportuno.</p><p style="margin-bottom: 10px; ">En el campo Fecha deber&aacute; de informar la fecha en que haya realizado la revisi&oacute;n de las operaciones.</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_revisarEjecucionesParalizadas','1','date','fecha','Fecha',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_revisarEjecucionesParalizadas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_decidirSobreFaseConvenio','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">En el primer campo ind&iacute;quese si se quiere que el gestor registre una propuesta de convenio de la propia entidad, en el segundo campo ind&iacute;quese si se quiere realizar un seguimiento de los convenios propuestos por terceros que puedan surgir durante la fase convenio. Si ya hubiere Convenio propio de la entidad registrado, o adhesi&oacute;n a otro convenio propio o presentado por otros, no se deber&aacute;n registrar m&aacute;s convenio.</p><p style="margin-bottom: 10px; ">En caso de que no quiera registrar un convenio propio en estos momentos, puede hacerlo cuando quiera hasta la fecha h&aacute;bil por medio del "Tr&aacute;mite de presentaci&oacute;n propuesta de convenio" que le guiar&aacute; para dar de alta el convenio propio en la pesta&ntilde;a "Convenios" de la ficha del asunto correspondiente.</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px; ">Una vez rellene esta pantalla se iniciar&aacute; una tarea por cada una de las decisiones tomadas, en el caso de querer registrar un convenio propio se lanzar&aacute; la tarea de "Elevar Propuesta aSareb" para que decida si debe iniciarse el "Tr&aacute;mite presentaci&oacute;n de propuesta de convenio propio" o en el caso de querer hacer un seguimiento sobre otras propuestas se crear&aacute; la tarea "Actualizar propuesta de convenio".</p><p style="margin-bottom: 10px; ">En caso de no querer registrar ning&uacute;n convenio propio o de terceros, no se lanzar&aacute; ninguna otra tarea respecto al seguimiento de los convenios.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_decidirSobreFaseConvenio','1','combo','comboPropio','Registrar convenio propio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_decidirSobreFaseConvenio','2','combo','comboSeguimiento','Seguimiento de otros convenios','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_decidirSobreFaseConvenio','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_BPMElevarPropuestaSAREB1','0','label','titulo','Se inicia Trámite de Elevar Propuesta a Sareb 1',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_BPMtramitePresentacionPropConvenio','0','label','titulo','Se inicia Trámite de presentación propuesta de convenio',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_actPropuestaConvenio','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">El seguimiento de un convenio de terceros se mantendr&aacute; mientras se introduzca un "No" en el campo "Terminar seguimiento".</p><p style="margin-bottom: 10px; ">Para registrar los convenio propuestos por terceros deber&aacute; abrir la ficha del asunto correspondiente y en la pesta&ntilde;a "Convenios" darlos de alta.</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px; ">Una vez rellene esta pantalla se iniciar&aacute;, en el caso de introducir un "No" esta misma tarea, en el caso de Introducir un "Si" se iniciar&aacute; la tarea "Aceptar fin de seguimiento" a realizar por el supervisor asignado a la actuaci&oacute;n.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_actPropuestaConvenio','1','combo','combo','Terminar seguimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_actPropuestaConvenio','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_aceptarFinSeguimiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">Ind&iacute;quese si acepta el fin de seguimiento de otros convenios propuestos por terceros.</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px; ">Una vez rellene esta pantalla se dar&aacute; por concluido el seguimiento de propuestas de convenio de terceros.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_aceptarFinSeguimiento','1','combo','combo','Fin de seguimiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_aceptarFinSeguimiento','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_realizarValoracionConcurso','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; indicar si se ha presentado alg&uacute;n convenio o no, en caso de contestar afirmativamente deber&aacute; abrir la pesta&ntilde;a "Convenios" de la ficha del asunto correspondiente y comprobar que al menos un convenio haya quedado registrado, en caso de no estarlo ya deber&aacute; proceder a su registro debiendo indicar si es de tipo Ordinario o Anticipado, el estado en el que se encuentra y la postura de la Entidad, as&iacute; como el contenido del mismo respecto de cada tipolog&iacute;a de cr&eacute;ditos. Si el convenio tiene varias alternativas de adhesi&oacute;n deber&aacute;n registrarse todas ellas.</p><p style="margin-bottom: 10px; ">En el campo Informe deber&aacute; introducir el informe que quiere remitir a su supervisor en la entidad. No olvide indicar, en caso de adherirnos a un convenio, si la propuesta de adhesi&oacute;n se refiere exclusivamente a los cr&eacute;ditos ordinarios o por el contrario incluye tambi&eacute;n los privilegiados, as&iacute; como cualquier otro comentario considerado como relevante.</p><p style="margin-bottom: 10px; ">En el campo Fecha indicar la fecha en que da por concluido su informe y procede a terminar la tarea.</p><p style="margin-bottom: 10px; ">Una vez complete esta tarea la siguiente tarea ser&aacute; "Preparar Propuesta instrucciones para Sareb" a realizar por el gestor de deuda.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_realizarValoracionConcurso','1','date','fechaConclusionInforme','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H017_realizarValoracionConcurso','2','combo','comboConvenioPresentado','Se ha presentado algún convenio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_realizarValoracionConcurso','3','label','propInstrucTit','<div align="justify" style="font-size: 8pt; font-family: Arial; margin: 10px;"><p>Informe del letrado:</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_realizarValoracionConcurso','4','htmleditor','informe','Informe','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_realizarValoracionConcurso','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_PreparaPropInstSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">Para dar por completada esta tarea deber&aacute; revisar el informe de valoraci&oacute;n del concurso presentado por el letrado, para ello deber&aacute; abrir la tarea ya completada por el letrado "Realizar valoraci&oacute;n del concurso" donde el letrado a introducido dicho informe. Una vez revisado el informe deber&aacute; de cumplimentar el campo propuesta de instrucciones, donde propondr&aacute; seg&uacute;n su criterio las instrucciones para el concurso al comit&eacute; correspondiente.</p><p style="margin-bottom: 10px; ">En el campo Fecha indicar la fecha en que da por concluido su informe y procede a terminar la tarea.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_PreparaPropInstSareb','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H017_PreparaPropInstSareb','2','label','propInstrucTit','<div align="justify" style="font-size: 8pt; font-family: Arial; margin: 10px;"><p>Propuesta de instrucciones:</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_PreparaPropInstSareb','3','htmleditor','propInstrucciones','Propuesta instrucciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_PreparaPropInstSareb','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_BPMElevarPropuestaSAREB2','0','label','titulo','Se inicia Trámite de Elevar Propuesta a Sareb 2',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_lecturaAceptacionInstrucciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">A trav&eacute;s de esta pantalla el gestor atiende las instrucciones propuestas por el Sareb para la junta de acreedores en la resoluci&oacute;n de Sareb.</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px; ">Una vez rellene esta pantalla se iniciar&aacute; la tarea "Registrar resultado junta de acreedores".</p></div>',null,null,null,null,'1','DD'),
		T_TIPO_TFI('H017_lecturaAceptacionInstrucciones','1','date','fechaJunta','Fecha junta de acreedores',null,null,'valores[''H017_autoApertura''] == null ? '''' : ( valores[''H017_autoApertura''][''fechaJunta''] )',null,'0','DD'),
		T_TIPO_TFI('H017_lecturaAceptacionInstrucciones','2','combo','comboAceptacion','Leído y aceptado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
--		T_TIPO_TFI('H017_lecturaAceptacionInstrucciones','2','htmleditor','propuestaInstrucciones','Instrucciones entidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''H017_registrarResultado''] == null ? '''' : (valores[''H017_registrarResultado''][''propuestaInstrucciones''])',null,'0','DD'),
		T_TIPO_TFI('H017_lecturaAceptacionInstrucciones','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_registrarResultado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">Habi&eacute;ndose celebrado la junta de acreedores, registrar el resultado de la misma. Se ha de informar la fecha de celebraci&oacute;n y observaciones al supervisor si da lugar a ello e indicar si se ha aprobado alguno de los convenios presentados.</p><p style="margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; abrir la pesta&ntilde;a "Convenios" de la ficha del asunto correspondiente y actualizar el estado de los convenios con el correspondiente ya sea "Aprobado en junta" o "No admitido a tr&aacute;mite".</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar oposici&oacute;n y admisi&oacute;n judicial</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_registrarResultado','1','date','fechaJunta','Fecha junta de acreedores',null,null,'valores[''H017_autoApertura''] == null ? '''' : ( valores[''H017_autoApertura''][''fechaJunta''] )',null,'0','DD'),
		T_TIPO_TFI('H017_registrarResultado','2','combo','comboAlgunConvenio','Aprobación de algún convenio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_registrarResultado','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_RegistrarOposicionAdmon','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla debemos indicar tanto si se ha admitido el resultado de la junta de acreedores como si hay oposici&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px">- Si se presenta oposici&oacute;n: "Registrar resoluci&oacute;n oposici&oacute;n"</p><p style="margin-bottom: 10px">- Si no se admite el resultado: "Registrar resultado subsanaci&oacute;n"</p><p style="margin-bottom: 10px">- En caso de que se admita y no haya oposici&oacute;n se termina el tr&aacute;mite en curso por lo que se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_RegistrarOposicionAdmon','1','combo','comboAdmision','Admisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_RegistrarOposicionAdmon','2','date','fechaAdmision','Fecha admisión',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_RegistrarOposicionAdmon','3','combo','comboOposicion','Oposición','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_RegistrarOposicionAdmon','4','date','fechaOposicion','Fecha oposicion',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_RegistrarOposicionAdmon','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_BPMTramiteSegCumplConvenio','0','label','titulo','Se inicia Trámite de Seguimiento de Fase Convenio',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_registrarResolucionOposicion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">Informar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do.</p><p style="margin-bottom: 10px; ">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable o no.</p><p style="margin-bottom: 10px; ">- Para el supuesto de que la resoluci&oacute;n fuera favorable, se lanzar&aacute; el Tramite de Seguimiento de Cumplimiento de Convenio.</p><p style="margin-bottom: 10px; ">- Si la resoluci&oacute;n no fuera favorable para la entidad, se lanzar&aacute; el Tramite de Liquidaci&oacute;n y deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n "Comunicaci&oacute;n". Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px; ">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pesta&ntilde;a "Recursos".</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_registrarResolucionOposicion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H017_registrarResolucionOposicion','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDFavorable','0','DD'),
		T_TIPO_TFI('H017_registrarResolucionOposicion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_registrarResultadoSubsana','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px; ">Informar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do y el resultado de la subsanaci&oacute;n si este es positivo o negativo.</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><p style="margin-bottom: 10px; ">- Si se ha subsanado, se seguir&aacute; con el Tramite de Seguimiento de Cumplimiento del Convenio.</p><p style="margin-bottom: 10px; ">- Si no se ha subsanado se iniciar&aacute; un tr&aacute;mite de liquidaci&oacute;n.</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_registrarResultadoSubsana','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H017_registrarResultadoSubsana','2','combo','comboSubsana','Subsanado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H017_registrarResultadoSubsana','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H017_BPMTramiteFaseLiquidacion','0','label','titulo','Se inicia Trámite fase de liquidación',null,null,null,null,'0','DD')
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