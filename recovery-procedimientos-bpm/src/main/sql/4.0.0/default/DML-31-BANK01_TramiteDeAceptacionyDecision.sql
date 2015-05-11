/*
--##########################################
--## Author: Gonzalo Estellés
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite ACeptación y Decisión Litigios (P420)
--## INSTRUCCIONES:  Tramite ACeptación y Decisión Litigios
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
      T_TIPO_TPO('P420','T. de aceptación y decisión','T. de aceptación y decisión',null,'aceptacionYdecisionV4','0','dd','0','03',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    
        T_TIPO_TAP('P420','P420_registrarProcedimiento','plugin/procedimientos/aceptacionYdecision/decisionV4',null,'valores[''P420_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.NO && (valores[''P420_registrarProcedimiento''][''fechaEnvio'']==null || valores[''P420_registrarProcedimiento''][''observaciones'']==null) ? ''Debe indicar la fecha de env&iacute;o de la documentaci&oacute;n y el problema en el campo observaciones'' : (valores[''P420_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.SI && valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==null ? ''Debe indicar el tipo de procedimiento a iniciar'' : null)','valores[''P420_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.NO ? ''requiereSubsanacion'' :
        ((valores[''P420_registrarProcedimiento''][''tipoPropuestoEntidad'']==null || valores[''P420_registrarProcedimiento''][''tipoPropuestoEntidad'']=='''' || valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==valores[''P420_registrarProcedimiento''][''tipoPropuestoEntidad'']) ? 
        ((valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P01'')?''hipotecario'' : (
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P02'')?''monitorio'':(
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P03'')?''ordinario'':(
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P17'')?''cambiario'':(
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P32'')?''abreviado'':(
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P16'')?''etj'':(
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P15'')?''etnj'':(
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P04'')?''verbal'': 
         valores[''P420_registrarProcedimiento''][''tipoProcedimiento''])))))))):''cambioDocumento'')',null,'0','Registrar toma de decisión','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
        T_TIPO_TAP('P420','P420_validarCambioProcedimiento','plugin/procedimientos/aceptacionYdecision/validacionTipoProcedimientoPropuestoLetradoV4',null,null,'valores[''P420_validarCambioProcedimiento''][''comboValidacion''] == DDSiNo.NO ? ''No'' : ( 
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P01'') ? ''hipotecario'' : (
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P02'') ? ''monitorio'' : (
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P03'') ? ''ordinario'' : (
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P17'') ? ''cambiario'' : (
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P32'') ? ''abreviado'' : (
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P16'') ? ''etj'' : (
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P15'') ? ''etnj'' : (
         (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P04'') ? ''verbal'' : valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']))))))))',null,'1','Validar cambio de procedimiento','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
        T_TIPO_TAP('P420','P420_validarNoAceptacion','plugin/procedimientos/aceptacionYdecision/validarNoAceptacionV4',null,null,null,null,'1','Validar la no aceptación del Asunto','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
        T_TIPO_TAP('P420','P420_SubsanarErrDocumentacion','plugin/procedimientos/aceptacionYdecision/subsanacionErrorDocV4',null,null,null,null,'0','Subsanar error en documentación','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'600',null,null,null),
        T_TIPO_TAP('P420','P420_BPMAbreviado',null,null,null,null,'P32','0','Tramite Abreviado','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMAceptacionYdecision',null,null,null,null,'P420','0','Tramite de Aceptación y decisión','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMCambiario',null,null,null,null,'P17','0','Tramite Cambiario','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMETJ',null,null,null,null,'P16','0','Tramite Ej. de Título Judicial','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMETNJ',null,null,null,null,'P15','0','Tramite Ej. de Título No Judicial','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMFaseComunAbreviado',null,null,null,null,'P412','0','Tramite Fase Común Abreviado','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMFaseComunOrdinario',null,null,null,null,'P24','0','Tramite Fase Común Ordinario','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMHipotecario',null,null,null,null,'P01','0','Tramite Hipotecario','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMMonitorio',null,null,null,null,'P02','0','Tramite monitorio','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMOrdinario',null,null,null,null,'P03','0','Tramite Ordinario','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMSolicitudConcurso',null,null,null,null,'P55','0','Tramite Solicitud Concurso Necesario','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_BPMVerbal',null,null,null,null,'P04','0','Tramite Verbal','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P420','P420_registrarAceptacion','plugin/procedimientos/aceptacionYdecision/aceptacionV4',null,null,'valores[''P420_registrarAceptacion''][''comboConflicto''] == DDSiNo.SI || valores[''P420_registrarAceptacion''][''comboAceptacion''] == DDSiNo.NO ?  ''noAceptacion'' : ''aceptacion''',null,'0','Registrar aceptación del asunto','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
    
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
        T_TIPO_PLAZAS(null,null,'P420_registrarAceptacion','3*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_validarNoAceptacion','1*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_registrarProcedimiento','2*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_validarCambioProcedimiento','2*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_SubsanarErrDocumentacion','damePlazo(valores[''P420_registrarProcedimiento''][''fechaEnvio''])+10*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMAceptacionYdecision','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMHipotecario','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMMonitorio','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMOrdinario','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMCambiario','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMAbreviado','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMETJ','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMETNJ','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMVerbal','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMFaseComunOrdinario','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMFaseComunAbreviado','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P420_BPMSolicitudConcurso','300*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('P420_registrarAceptacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p><p style="margin-bottom: 10px">En el campo "Conflicto de intereses" deberá consignar la existencia de conflicto o no, que le impida aceptar la dirección de la acción a instar, en caso de que haya conflicto de intereses no se le permitirá la aceptación del Asunto.</p><p style="margin-bottom: 10px">En el campo "Aceptación del asunto " deberá indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deberá marcar, en todo caso, la no aceptación del asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar recepción de la documantación" en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_registrarAceptacion','1','currency','principal','Principal',null,null,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()',null,'0','DD'),
      T_TIPO_TFI('P420_registrarAceptacion','2','combo','comboConflicto','Conflicto de intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('P420_registrarAceptacion','3','combo','comboAceptacion','Aceptación del asunto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('P420_registrarAceptacion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_SubsanarErrDocumentacion','2','date','fechaEnvio','Fecha envío','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P420_SubsanarErrDocumentacion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMAceptacionYdecision','0','label','titulo','Se inicia el trámite de Aceptación y decisión P420',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMHipotecario','0','label','titulo','Se inicia el trámite hipotecario P01',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMMonitorio','0','label','titulo','Se inicia el trámite monitorio P02',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMOrdinario','0','label','titulo','Se inicia el trámite ordinario P03',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMCambiario','0','label','titulo','Se inicia el trámite cambiario P17',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMAbreviado','0','label','titulo','Se inicia el trámite Abreviado P32',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMETJ','0','label','titulo','Se inicia el trámite Ej. de Título Judicial P16',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMETNJ','0','label','titulo','Se inicia el trámite Ej. de Título No Judicial P15',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMVerbal','0','label','titulo','Se inicia el trámite Verbal P04',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMFaseComunOrdinario','0','label','titulo','Se inicia el trámite Fase Común Ordinario P24',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMFaseComunAbreviado','0','label','titulo','Se inicia el trámite Fase Común Abreviado P412',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_BPMSolicitudConcurso','0','label','titulo','Se inicia el trámite Solicitud Concurso Necesario P55',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_validarNoAceptacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla debe validar la no aceptación del asunto por parte del letrado asignado, a continuación se le muestra los datos introducidos por el letrado.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea primero deberá reasignar el asunto a un nuevo letrado a través del botón "Cambiar gestor/supervisor" en la ficha del Asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez termine esta tarea se lanzará automáticamente un nuevo trámite de aceptación y decisión al letrado que haya reasignado el Asunto.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_validarNoAceptacion','1','currency','principal','Principal',null,null,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()',null,'0','DD'),
      T_TIPO_TFI('P420_validarNoAceptacion','2','combo','comboConflicto','Conflicto de intereses',null,null,'valores[''P420_registrarAceptacion''][''comboConflicto'']','DDSiNo','0','DD'),
      T_TIPO_TFI('P420_validarNoAceptacion','3','combo','comboAceptacion','Aceptación del asunto',null,null,'valores[''P420_registrarAceptacion''][''comboAceptacion'']','DDSiNo','0','DD'),
      T_TIPO_TFI('P420_validarNoAceptacion','4','textarea','observacionesLetrado','Observaciones letrado',null,null,'valores[''P420_registrarAceptacion''][''observaciones'']',null,'0','DD'),
      T_TIPO_TFI('P420_validarNoAceptacion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_registrarProcedimiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deberá consignar la fecha en la que recibe la documentación, en el campo “Documentación completa y correcta” deberá indicar si la documentación del expediente efectivamente es completa y correcta o no. En caso de no ser completa deberá indicar el problema en el campo Observaciones y la fecha en la que haya devuelto el expediente a la EDP. Es muy importante que revise la documentación e indique el problema encontrado en caso de error.</p><p style="margin-bottom: 10px">En el campo "Procedimiento propuesto por la entidad" se le indica el tipo de procedimiento propuesto por la entidad. En caso de estar de acuerdo con dicha propuesta de actuación, deberá consignar en el campo "Procedimiento a iniciar" el mismo tipo de procedimiento, en caso contrario, deberá seleccionar otro procedimiento según su criterio, el cual será propuesto al supervisor asignado a este asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de haber encontrado un problema en la documentación se iniciará la tarea “Subsanar error en documentación” a realizar por la empresa de preparación documental. En caso de no haber encontrado error en la documentación y de haber seleccionado el mismo tipo de procedimiento que el comité se iniciará dicho procedimiento, en caso de haber seleccionado un procedimiento distinto al propuesto por la entidad, se iniciará una tarea en la que el supervisor deberá validar el cambio de procedimiento que haya propuesto.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_registrarProcedimiento','1','date','fecha','Fecha recepción documentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P420_registrarProcedimiento','2','combo','comboDocCompleta','Documentación completa y correcta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('P420_registrarProcedimiento','3','date','fechaEnvio','Fecha envío documentación para subsanación',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_registrarProcedimiento','4','combo','tipoPropuestoEntidad','Procedimiento propuesto por la entidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameTipoProcedimientoOriginal()','TipoProcedimiento','0','DD'),
      T_TIPO_TFI('P420_registrarProcedimiento','5','combo','tipoProcedimiento','Procedimiento a iniciar','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,null,'TipoProcedimiento','0','DD'),
      T_TIPO_TFI('P420_registrarProcedimiento','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_validarCambioProcedimiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá validar el cambio del tipo de actuación propuesto por el letrado respecto a la decisión de la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">En caso de validar el cambio de actuación se iniciará la actuación seleccionada, en caso contrario se lanzará de nuevo la tarea "Registrar decisión" al letrado.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_validarCambioProcedimiento','1','combo','tipoProcedimiento','Tipo procedimiento propuesto por el letrado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'valores[''P420_registrarProcedimiento''] == null ? '''' : (valores[''P420_registrarProcedimiento''][''tipoProcedimiento''])',null,'0','DD'),
      T_TIPO_TFI('P420_validarCambioProcedimiento','2','combo','tipoPropuestoEntidad','Tipo procedimiento propuesto por la entidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'valores[''P420_registrarProcedimiento''] == null ? '''' : (valores[''P420_registrarProcedimiento''][''tipoPropuestoEntidad''])',null,'0','DD'),
      T_TIPO_TFI('P420_validarCambioProcedimiento','3','combo','comboValidacion','Solicitud aceptada','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != ''''? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('P420_validarCambioProcedimiento','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_SubsanarErrDocumentacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentación del expediente, antes de dar por finalizada esta tarea deberá resolver el problema informado.</p><p style="margin-bottom: 10px">Una vez enviada la documentación ya completa al letrado, deberá informar la fecha de envío de dicha documentación.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez complete esta tarea se lanzará la tarea “Registrar toma de decisión” al letrado asignado al expediente.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P420_SubsanarErrDocumentacion','1','textarea','observacionesLetrado','Observaciones letrado',null,null,'valores[''P420_registrarProcedimiento''][''observaciones'']',null,'0','DD')
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
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
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
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
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