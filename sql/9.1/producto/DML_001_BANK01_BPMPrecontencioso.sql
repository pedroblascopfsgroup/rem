/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150728
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-130
--## PRODUCTO=SI
--##
--## Finalidad: Trámite de ejemplo BPM Precontencioso
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    VAR_TIPOACTUACION VARCHAR2(50 CHAR); -- Tipo de actuación a insertar

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('PCO','Preparación de expediente judicial','Preparación de expediente judicial',null,'precontencioso','0','DD','0','PCO',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       T_TIPO_TAP('PCO','PCO_PreTurnadoManual',null,null,null,'valores[''PCO_PreTurnadoManual''][''preTurnado''] == DDSiNo.SI ? (valores[''PCO_PreTurnadoManual''][''automatico''] == DDSiNo.SI ? ''automatico'' : ''manual'') : ''posturnado''',null,'0','Seleccionar tipo de turnado','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_PreTurnado',null,null,null,null,null,'0','Preturnado automatico','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_RegistrarAceptacion',null,null,null,'valores[''PCO_RegistrarAceptacion''][''aceptacion''] == DDSiNo.SI ? ''aceptacion'' : ''no_aceptacion''',null,'0','Registrar aceptación del asunto','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_RevisarNoAceptacion',null,null,null,null,null,'0','Revisar no aceptación del asunto','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_RevisarExpediente',null,null,null,null,null,'0','Revisar expediente a preparar','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_PrepararExpediente',null,null,null,'valores[''PCO_PreTurnadoManual''][''preTurnado''] == DDSiNo.SI ? ''preturnado'' : (valores[''PCO_PreTurnadoManual''][''automatico''] == DDSiNo.SI ? ''automatico'' : ''manual'')',null,'0','Preparar expediente','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_SolicitarDoc','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Solicitar documentación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_PostTurnado',null,null,null,null,null,'0','PostTurnado automatico','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_RegistrarAceptacionPost',null,null,null,'valores[''PCO_RegistrarAceptacionPost''][''aceptacion''] == DDSiNo.SI ? ''aceptacion'' : ''no_aceptacion''',null,'0','Registrar aceptación del asunto','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_RevisarNoAceptacionPost',null,null,null,null,null,'0','Revisar no aceptación del asunto','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_EnviarExpedienteLetrado',null,null,null,null,null,'0','Enviar expediente a letrado','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_RegistrarTomaDec',null,null,null,'valores[''PCO_RegistrarTomaDec''][''correcto''] == DDSiNo.SI ? ''ok'' : (valores[''PCO_RegistrarTomaDec''][''cambio_proc''] == DDSiNo.SI ? ''cambio_proc'' : ''requiere_subsanar'')',null,'0','Registrar toma de decisión','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_RevisarSubsanacion',null,null,null,'valores[''PCO_RegistrarTomaDec''][''correcto''] == DDSiNo.SI ? ''ok'' : (valores[''PCO_RegistrarTomaDec''][''cambio_proc''] == DDSiNo.SI ? ''cambio_proc'' : ''requiere_subsanar'')',null,'0','Revisar subsanacion propuesta','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_IniciarProcJudicial',null,null,null,null,null,'0','Iniciar procedimiento judicial','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_SubsanarIncidenciaExp',null,null,null,null,null,'0','Subsanar incidencia por cambio de procedimiento','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_ValidarCambioProc',null,null,null,'valores[''PCO_ValidarCambioProc''][''cambio_aceptado''] == DDSiNo.NO ? ''no'' : (valores[''PCO_ValidarCambioProc''][''nueva_preparacion''] == DDSiNo.SI ? ''si_nueva_preparacion'' : ''si_sin_nueva_prep'')',null,'0','Validar cambio de procedimiento','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
       T_TIPO_TAP('PCO','PCO_SubsanarCambioProc',null,null,null,null,null,'0','Subsanar por cambio de procedimiento','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),

T_TIPO_TAP('PCO','PCO_RegResultadoExped','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Registrar resultado para expediente','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_RecepcionExped','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Registrar recepción expediente','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_RegResultadoDoc','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Registrar resultado para documento','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_RegEnvioDoc','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Registrar envío del documento','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_RecepcionDoc','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Registrar recepción del documento','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_AdjuntarDoc','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Adjuntar documentación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_GenerarLiq','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Generar liquidación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_ConfirmarLiq','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Confirmar liquidación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_EnviarBurofax','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Enviar burofax','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
T_TIPO_TAP('PCO','PCO_AcuseReciboBurofax','plugin/precontencioso/tramite/preparacion',null,null,null,null,'0','Registrar acuse de recibo de burofax','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'PCO_PreTurnadoManual','1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'PCO_PreTurnado','1*24*60*60*1000L','0','0','DD'),  
      T_TIPO_PLAZAS(null,null,'PCO_RegistrarAceptacion','1*24*60*60*1000L','0','0','DD'), 
      T_TIPO_PLAZAS(null,null,'PCO_RevisarNoAceptacion','1*24*60*60*1000L','0','0','DD'), 
      T_TIPO_PLAZAS(null,null,'PCO_RevisarExpediente','1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'PCO_PrepararExpediente','1*24*60*60*1000L','0','0','DD'),  
      T_TIPO_PLAZAS(null,null,'PCO_SolicitarDoc','1*24*60*60*1000L','0','0','DD'),    
      T_TIPO_PLAZAS(null,null,'PCO_PostTurnado','1*24*60*60*1000L','0','0','DD'), 
      T_TIPO_PLAZAS(null,null,'PCO_RegistrarAceptacionPost','1*24*60*60*1000L','0','0','DD'), 
      T_TIPO_PLAZAS(null,null,'PCO_RevisarNoAceptacionPost','1*24*60*60*1000L','0','0','DD'), 
      T_TIPO_PLAZAS(null,null,'PCO_EnviarExpedienteLetrado','1*24*60*60*1000L','0','0','DD'), 
      T_TIPO_PLAZAS(null,null,'PCO_RegistrarTomaDec','1*24*60*60*1000L','0','0','DD'),   
      T_TIPO_PLAZAS(null,null,'PCO_RevisarSubsanacion','1*24*60*60*1000L','0','0','DD'),  
      T_TIPO_PLAZAS(null,null,'PCO_IniciarProcJudicial','1*24*60*60*1000L','0','0','DD'), 
      T_TIPO_PLAZAS(null,null,'PCO_SubsanarIncidenciaExp','1*24*60*60*1000L','0','0','DD'),   
      T_TIPO_PLAZAS(null,null,'PCO_ValidarCambioProc','1*24*60*60*1000L','0','0','DD'),   
      T_TIPO_PLAZAS(null,null,'PCO_SubsanarCambioProc','1*24*60*60*1000L','0','0','DD'),

T_TIPO_PLAZAS(null,null,'PCO_RegResultadoExped','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_RecepcionExped','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_RegResultadoDoc','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_RegEnvioDoc','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_RecepcionDoc','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_AdjuntarDoc','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_GenerarLiq','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_ConfirmarLiq','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_EnviarBurofax','1*24*60*60*1000L','0','0','DD'),
T_TIPO_PLAZAS(null,null,'PCO_AcuseReciboBurofax','1*24*60*60*1000L','0','0','DD')

    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(

        T_TIPO_TFI('PCO_PreTurnadoManual','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Introduzca el nombre del letrado y del procurador que gestionaran este asunto.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_PreTurnadoManual','1','combo','preTurnado','Preturnado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_PreTurnadoManual','2','combo','automatico','Automático','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_PreTurnadoManual','3','text','letrado','Letrado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_PreTurnadoManual','4','text','procurador','Procurador','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_PreTurnado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Cálculo automático el nombre del letrado y del procurador que gestionaran este asunto.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p>En el campo "Conflicto de intereses" deberá consignar la existencia de conflicto o no, que le impida aceptar la dirección de la acción a instar, en caso de que haya conflicto de intereses no se le permitirá la aceptación del Asunto.</p>En el campo "Aceptación del asunto " deberá indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deberá marcar, en todo caso, la no aceptación del asunto.</p>Una vez rellene esta pantalla la siguiente tarea será "Revisar expediente" en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacion','1','combo','conflicto_intereses','Conflicto intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacion','2','combo','aceptacion','Aceptación  asunto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea debe validar la asignación de letrado dada por el sistema de turnado. En caso de no serlo, por favor, reasigne convenientemente a través de la pestaña Gestores del asunto.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacion','1','date','fecha_validacion','Fecha validación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacion','2','text','anterior_letrado','Anterior letrado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacion','3','text','nuevo_letrado','Letrado asignado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacion','4','combo','asignacion_correcta','Asignación correcta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarExpediente','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deberá revisar la preparación documental que se va a iniciar. A través de la pestaña “Preparación documental” de la actuación, deberá comprobar que están todos los documentos requeridos para la interposición de la demanda o presentación del concurso, que todos los contratos a generar liquidación están incluidos y por último, que todas las personas que se debe notificar están incluidas en el área de gestión de burofaxes.</p>En caso de considerar necesaria la paralización de la preparación del expediente judicial, puede prorrogar esta tarea hasta que estime oportuno a través de la solicitud de una prórroga. De igual modo, en caso de encontrarse en negociación de un acuerdo extrajudicial, regístrelo a través de la pestaña Acuerdos de la ficha del asunto correspondiente.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento. </p>Una vez complete esta tarea se iniciará la preparación del expediente judicial.</p></div>',null,null,null,null,'0','DD'),  
        T_TIPO_TFI('PCO_RevisarExpediente','1','date','fecha_revision','Fecha revisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),  
        T_TIPO_TFI('PCO_RevisarExpediente','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_PrepararExpediente','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Pantalla principal de la preparación del expediente.</p></p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_PrepararExpediente','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_SolicitarDoc','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Cálculo automático el nombre del letrado y del procurador que gestionaran este asunto.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_SolicitarDoc','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_PostTurnado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Cálculo automático el nombre del letrado y del procurador que gestionaran este asunto.</p>PostTurnado</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacionPost','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p>En el campo "Conflicto de intereses" deberá consignar la existencia de conflicto o no, que le impida aceptar la dirección de la acción a instar, en caso de que haya conflicto de intereses no se le permitirá la aceptación del Asunto.</p>En el campo "Aceptación del asunto " deberá indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deberá marcar, en todo caso, la no aceptación del asunto.</p>Una vez rellene esta pantalla la siguiente tarea será "Revisar expediente" en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacionPost','1','combo','conflicto_intereses','Conflicto intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacionPost','2','combo','aceptacion','Aceptación  asunto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacionPost','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarAceptacionPost','4','date','fecha_aceptacion','Fecha de aceptación',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacionPost','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea debe validar la asignación de letrado y procurador dada por el sistema de turnado. En caso de no serlo, por favor, reasigne convenientemente a través de la pestaña Gestores del asunto.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacionPost','1','date','fecha_validacion','Fecha validación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacionPost','2','text','anterior_letrado','Anterior letrado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacionPost','3','text','nuevo_letrado','Letrado asignado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacionPost','4','combo','asignacion_correcta','Asignación correcta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RevisarNoAceptacionPost','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_EnviarExpedienteLetrado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez en disposición de toda la documentación requerida por el expediente de prelitigio, a través de esta pantalla deberá indicar la fecha en que procede al envío de dicha documentación al letrado correspondiente.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p>Una vez complete esta tarea se dará por terminada la preparación documental del expediente de prelitigio, dando así inicio a la fase judicial.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_EnviarExpedienteLetrado','1','date','fecha_envio','Fecha envío','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_EnviarExpedienteLetrado','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deberá consignar la fecha en la que recibe la documentación, en el campo “Documentación completa y correcta” deberá indicar si la documentación del expediente efectivamente es completa y correcta o no. En caso de no ser completa deberá indicar el problema detectado según sea por Documentos, Requerimientos, Liquidaciones o por requerir nueva documentación al cambiar el tipo de procedimiento a iniciar.</p>En el campo "Procedimiento propuesto por la entidad" se le indica el tipo de procedimiento propuesto por la entidad. En caso de estar de acuerdo con dicha propuesta de actuación, deberá consignar en el campo "Procedimiento a iniciar" el mismo tipo de procedimiento, en caso contrario, deberá seleccionar otro procedimiento según su criterio.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>Una vez rellene esta pantalla y en función de la información facilitada podrán darse las siguientes situaciones:</p><li>En caso de haber encontrado un problema en la Documentación, liquidaciones o Requerimientos se iniciará la tarea “Revisar subsanación propuesta” a realizar por la entidad.</li><li>En caso de haber propuesto un cambio de procedimiento se iniciará la tarea “Validar cambio de procedimiento” a realizar por la entidad.</li><li>En caso de no haber encontrado error en la documentación y de haber seleccionado el mismo tipo de procedimiento que el comité se iniciará dicho procedimiento</li></p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','1','date','fecha_recepcion','Fecha recepción documentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','2','combo','correcto','Documentación completa y correcta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','3','date','fecha_envio_doc','Fecha envío documentación para subsanación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','4','text','tipo_problema','Tipo de problema en expediente (Documentación, Requerimiento, Liquidaciones, Cambio de procedimiento)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','5','combo','proc_propuesto','Procedimiento propuesto por la entidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameTipoProcedimientoOriginal()','TipoProcedimiento','0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','6','combo','proc_a_iniciar','Procedimiento a iniciar','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'TipoProcedimiento','0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','7','combo','cambio_proc','Rehacer documentación según nuevo procedimiento propuesto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RegistrarTomaDec','8','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha solicitado subsanación sobre expediente judicial preparado. Para dar por terminada esta tarea deberá de comprobar que realmente hay un problema en la documentación y consignar el resultado en el campo “Resultado” indicando Subsanar en caso de que realmente sea necesario subsanar el problema en la documentación, o indicando Devolver en caso de que no proceda la subsanación.</p>En caso de requerir subsanación, deberá valorar si es necesario que la nueva preparación del expediente la realice el preparador del expediente original o es conveniente que lo realice otro actor, en caso de querer cambiar de preparador, deberá acceder a la pestaña gestores del expediente y registrar el nuevo preparador.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacion','1','textarea','observaciones_letrado','Observaciones letrado',null,null,'valores[''PCO_RegistrarTomaDec''][''observaciones''] ',null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacion','2','date','fecha_revision','Fecha revision','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacion','3','combo','subsanar','Resultado (Subsanar=Sí, Devolver=No)','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_RevisarSubsanacion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_IniciarProcJudicial','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se va a proceder a la generación del Procedimiento Judicial.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarIncidenciaExp','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentación del expediente, antes de dar por finalizada esta tarea deberá resolver el problema informado.</p>Una vez enviada la documentación ya completa al letrado, deberá informar la fecha de envío de dicha documentación.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>Una vez complete esta tarea se lanzará la tarea “Registrar toma de decisión” al letrado asignado al expediente.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarIncidenciaExp','1','textarea','observaciones_letrado','Observaciones letrado',null,null,'valores[''PCO_RegistrarTomaDec''][''observaciones''] ',null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarIncidenciaExp','2','date','fecha_envio','Fecha envío','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarIncidenciaExp','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_ValidarCambioProc','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá validar el cambio del tipo de actuación propuesto por el letrado respecto a la decisión de la entidad.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>En caso de validar el cambio de actuación se iniciará la actuación seleccionada, en caso contrario se lanzará de nuevo la tarea "Registrar decisión" al letrado.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_ValidarCambioProc','1','combo','tipo_proc_letrado','Tipo procedimiento propuesto por el letrado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''PCO_RegistrarTomaDec''][''proc_propuesto'']','TipoProcedimiento','0','DD'),
        T_TIPO_TFI('PCO_ValidarCambioProc','2','combo','tipo_proc_entidad','Tipo procedimiento propuesto por la entidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''PCO_RegistrarTomaDec''][''proc_a_iniciar'']','TipoProcedimiento','0','DD'),
        T_TIPO_TFI('PCO_ValidarCambioProc','3','combo','cambio_aceptado','Cambio aceptado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_ValidarCambioProc','4','combo','nueva_preparacion','Requiere nueva preparación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('PCO_ValidarCambioProc','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarCambioProc','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentación del expediente, antes de dar por finalizada esta tarea deberá resolver el problema informado.</p>Una vez completada la documentación deberá informar la fecha en la que da por subsanado el expediente judicial en preparación.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>Una vez complete esta tarea se lanzará la tarea “Registrar toma de decisión” al letrado asignado al expediente.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarCambioProc','1','textarea','observaciones_letrado','Observaciones letrado',null,null,'valores[''PCO_RegistrarTomaDec''][''observaciones''] ',null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarCambioProc','2','text','tipo_problema','Tipo de problema',null,null,'valores[''PCO_RegistrarTomaDec''][''tipo_problema'']',null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarCambioProc','3','date','fecha exp_subsanado','Fecha expediente subsanado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('PCO_SubsanarCambioProc','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        
T_TIPO_TFI('PCO_RegResultadoExped','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RegResultadoExped','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RecepcionExped','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RecepcionExped','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RegResultadoDoc','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RegResultadoDoc','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RegEnvioDoc','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RegEnvioDoc','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RecepcionDoc','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_RecepcionDoc','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_AdjuntarDoc','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_AdjuntarDoc','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_GenerarLiq','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_GenerarLiq','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_ConfirmarLiq','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_ConfirmarLiq','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_EnviarBurofax','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_EnviarBurofax','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_AcuseReciboBurofax','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>',null,null,null,null,'0','DD'),
T_TIPO_TFI('PCO_AcuseReciboBurofax','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')

    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- Inserción de valores en DD_TAC_TIPO_ACTUACION
    VAR_TABLENAME := 'DD_TAC_TIPO_ACTUACION';
    VAR_TIPOACTUACION := 'PCO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TIPO DE ACTUACION');
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE DD_TAC_CODIGO = '''||VAR_TIPOACTUACION||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;          
    IF V_NUM_TABLAS > 0 THEN                
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Ya existe el tipo de actuación '''|| VAR_TIPOACTUACION ||'''');
    ELSE
        V_MSQL := 'Insert into '||V_ESQUEMA||'.' || VAR_TABLENAME || 
            ' (DD_TAC_ID,DD_TAC_CODIGO,DD_TAC_DESCRIPCION,DD_TAC_DESCRIPCION_LARGA, ' || 
            ' VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ' || 
            '((SELECT MAX(DD_TAC_ID)+1 FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || '),'''||VAR_TIPOACTUACION||''',''Precontencioso'',''Precontencioso'', ' ||
            '0,''DD'',sysdate,null,null,null,null,0)';
        DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || VAR_TABLENAME ||''': '''|| VAR_TIPOACTUACION ||'''');
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
    END IF;

    -- LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TIPO DE PROCEDIMIENTO');
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
                    ''|| V_ESQUEMA ||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                    '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) || ''' FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' || V_ESQUEMA || '.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
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
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    ''|| V_ESQUEMA ||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
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
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    ''|| V_ESQUEMA ||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
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

    --ACTUALIZACION DEL CAMPO TAP_VIEW DE TAP_TAREA_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_VIEW DE TAP_TAREA_PROCEDIMIENTO');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=''plugin/precontencioso/tramite/preparacion'' WHERE TAP_CODIGO IN  ' || 
      '(''PCO_PrepararExpediente'',''PCO_SolicitarDoc'',''PCO_RegResultadoExped'',''PCO_RecepcionExped'',''PCO_RegResultadoDoc'',''PCO_RegEnvioDoc'',''PCO_RecepcionDoc'',''PCO_AdjuntarDoc'',''PCO_GenerarLiq'',''PCO_ConfirmarLiq'',''PCO_EnviarBurofax'',''PCO_AcuseReciboBurofax'')';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_VIEW DE TAP_TAREA_PROCEDIMIENTO');
 
    --ACTUALIZACION DEL CAMPO TAP_VIEW DE TAP_TAREA_PROCEDIMIENTOPCO_RegistrarTomaDec
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_VIEW DE TAP_TAREA_PROCEDIMIENTO PCO_RegistrarTomaDec');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=''plugin/precontencioso/tramite/registrarTomaDec'' WHERE TAP_CODIGO IN  ' || 
      '(''PCO_RegistrarTomaDec'')';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_VIEW DE TAP_TAREA_PROCEDIMIENTO');
 
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS DE TFI_TAREAS_FORM_ITEMS PCO_RegistrarTomaDec');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL=''dameProcedimientoPropuesto()'', TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_RegistrarTomaDec'')) AND TFI_NOMBRE = ''proc_propuesto''';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_VALOR_INICIAL DE TFI_TAREAS_FORM_ITEMS');

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS DE TFI_TAREAS_FORM_ITEMS PCO_RegistrarTomaDec');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_TIPO=''combo'', TFI_BUSINESS_OPERATION=''DDTipoProblemaDocPco'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_RegistrarTomaDec'')) AND TFI_NOMBRE = ''tipo_problema''';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TIPO,  TFI_BUSINESS_OPERATIONDE TFI_TAREAS_FORM_ITEMS');


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
