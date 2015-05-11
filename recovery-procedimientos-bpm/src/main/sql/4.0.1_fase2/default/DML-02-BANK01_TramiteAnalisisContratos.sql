/*
--##########################################
--## Author: Gonzalo Estellés
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Procedimiento Analisis de Contratos
--## INSTRUCCIONES:  Creación del Procedimiento de Analisis de Contratos
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 (JoseVI) Adaptadas validaciones de existencia de registros. Si existen se descartan INSERTs
--##        0.3 (JoseVI) Se incluye salida cuando error WHENEVER SQLERROR EXIT
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

    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    V_CODIGO_PLAZAS VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Plazos
    V_CODIGO1_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo1 FK con codigo de TFI Items
    V_CODIGO2_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo2 FK con codigo de TFI Items

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('P402','T. Análisis de Contratos','T. Análisis de Contratos',null,'tramiteAnalisisContratosV4','0','dd','0','CO',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    
        T_TIPO_TAP('P402','P402_AnalisisOperacionesConcurso',null,'analisisDeGarantiasCompletado() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; del asunto correspondiente y determinar para cada operaci&oacute;n del concurso su tipo de garant&iacute;a, ya sea &quot;Garant&iacute;as adicionales o personales&quot; de tipo fiadores, librado, descuento, de tipo Prendas, Pignoraci&oacute;n, IPF, Otros o &quot;Garant&iacute;as reales&quot;. Recuerde que en la pesta&ntilde;a Adjuntos de la ficha del procedimiento correspondiente, deber&iacute;a disponer de toda la documentaci&oacute;n necesaria para el an&aacute;lisis de las operaciones, en caso de no disponer de dicha informaci&oacute;n deber&aacute; remitir una notificaci&oacute;n a su supervisor indicando dicha circunstancia.</p></div>''',null,null,null,'0','Análisis de las operaciones del concurso','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_BPMInicioEJ_A',null,null,null,null,'P405','0','Tramite Inicio Expediente Judicial A P405','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_BPMInicioEJ_B',null,null,null,null,'P405','0','Tramite Inicio Expediente Judicial B P405','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_BPMInicioEJ_C1',null,null,null,null,'P405','0','Tramite Inicio Expediente Judicial C1 P405','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_BPMInicioEJ_C2',null,null,null,null,'P405','0','Tramite Inicio Expediente Judicial C2 P405','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_ComunicadoDecisionEntidadA',null,null,null,null,null,'0','Comunicado Decisión Entidad','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_ComunicadoDecisionEntidadB',null,null,null,null,null,'0','Comunicado Decisión Entidad','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_ComunicadoDecisionEntidadC1',null,null,null,null,null,'0','Comunicado Decisión Entidad','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_ComunicadoDecisionEntidadC2',null,null,null,null,null,'0','Comunicado Decisión Entidad','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_DecidirSobreEjecuciones',null,'garantiasTienenEsNecesarioEjecutar() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente y registrar para cada uno de los contratos en los que se haya registrado resoluci&oacute;n favorable respecto a la no afecci&oacute;n en alguno de sus bienes relacionados, si es necesario iniciar ejecuci&oacute;n o no.</p></div>''',null,'existeEjecucionParalizadaConAfeccionFavorable() ? ''Si'' : ''No''',null,'1','Decidir sobre ejecuciones','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
        T_TIPO_TAP('P402','P402_DictarInstrucciones','plugin/procedimientos/tramiteAnalisisDeContratos/dictarInstruccionesV4',null,'existenInstruccionesEnTarea() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Debe indicar las instrucciones para la empresa de preparaci&oacute;n del expediente</p></div>''',null,null,'1','Dictar instrucciones','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
        T_TIPO_TAP('P402','P402_EsperaFDeclaracionConcurso',null,null,null,null,null,'0','Espera F. auto delcara. concurso - 1 año','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_EstudiarInicioPosEjec',null,'comprobarPropuestaEjecuciones() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; y estudiar las garant&iacute;as de cada uno de los contratos marcados con &quot;Garant&iacute;as adicionales o personales (Prendas, Pignoraci&oacute;n, IPF, otros)&quot;, en base a esto proponer a la entidad a trav&eacute;s de esa misma pantalla de an&aacute;lisis la conveniencia o no de iniciar una ejecuci&oacute;n de garant&iacute;a adicional para cada uno de los contratos.</p></div>''',null,null,null,'0','Estudiar inicio posibles ejecuciones','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_RegResolucionesNoAfeccion',null,'bienesTienenResolucionNoAfeccion() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente y registrar para cada uno de los bienes sobre los que se haya solicitado la no afecci&oacute;n tanto la fecha de resoluci&oacute;n como el resultado de dicha resoluci&oacute;n ya sea Favorable o Desfavorable para los intereses de la entidad.</p></div>''',null,'existeBienResolucionNoAfeccionFavorable() ? ''Si'' : ''No''',null,'0','Registrar resoluciones no afección','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_RegistrarResultadoSolvencias',null,'garantiasTienenResultadoSolvencia() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente y registrar para cada uno de los contratos sobre los que se haya solicitado solvencia, la fecha de recepci&oacute;n de la misma, el resultado ya sea Positivo o Negativo y la decisi&oacute;n de la entidad respecto a si hay que iniciar o continuar ejecuci&oacute;n de las garant&iacute;as. Tenga en cuenta que esta tarea no la podr&aacute; dar por terminada hasta que no haya recibido el resultado de todas las solvencias solicitadas.</p></div>''',null,'existeSolvenciaNegOPosNoIniciarEjecucion() ? ''negOposIniEjec'' : ''posInicEjec''',null,'1','Registrar resultado de solvencia','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
        T_TIPO_TAP('P402','P402_RevisarIniContEjec',null,'garantiasTienenDecisionRevision() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente y registrar en el campo &quot;Decisi&oacute;n Rev.&quot; para cada uno de los contratos con garant&iacute;a hipotecaria y pendientes de revisi&oacute;n la decisi&oacute;n en cuanto a si es necesario iniciar ejecuci&oacute;n o no.</p></div>''',null,'existeContratosConDecisionRevSIEjecIniciada() ? ''SIyEjecIniciada'' : (existeContratosConDecisionRevSIEjecNoIniciada() ? ''SIyNoEjecIniciada'' : ''No'')',null,'1','Revisar inicio o continuacion de ejecuciones','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
        T_TIPO_TAP('P402','P402_RevisarPropuestaLetrado',null,'comprobarInicioEjecuciones() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; acceder a la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; del asunto correspondiente y revisar para los contratos con garant&iacute;a de tipo &quot;Garant&iacute;as adicionales o personales (Prendas, Pignoraci&oacute;n, IPF, otros)&quot; la propuesta introducida por el letrado en la columna &quot;Propuesta ejecuci&oacute;n&quot;. Una vez revisado deber&aacute; consignar, seg&uacute;n su criterio, la columna &quot;Iniciar ejecuci&oacute;n&quot;.</p></div>''',null,'existenGarantiasConDiscrepancia() ? ''discrepancias'' : ''ok''',null,'1','Revisar propuesta letrado','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
        T_TIPO_TAP('P402','P402_RevisarSituacionConcurso',null,null,null,'valores[''P402_RevisarSituacionConcurso''][''comboLiquidacion''] == DDSiNo.SI ? ''Si'' : ''No''',null,'0','Revisar Situación del concurso','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
        T_TIPO_TAP('P402','P402_SolSolvenciaPatrimonial',null,'garantiasTienenSolicitudSolvencia() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; considerar para cada uno de los bienes marcados por el letrado con garant&iacute;as de tipo &quot;Garant&iacute;as adicionales o personales (Fiadores, Librado, Descuento)&quot; en la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente, si es necesario o no Solicitar solvencias, en los casos en que marque que s&iacute; es necesario deber&aacute; introducir la fecha de solicitud de la misma.</p></div>''',null,'existeGarantiaConSolicitudSolvenciaSI() ? ''Si'' : ''No''',null,'1','Solicitar solvencia patrimonial','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
        T_TIPO_TAP('P402','P420_SolicitarNoAfeccionBienes',null,'bienesTienenSolicitudNoAfeccion() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea antes deber&aacute; considerar para cada uno de los contratos marcados por el letrado con garant&iacute;as de tipo Hipotecaria en la pesta&ntilde;a &quot;An&aacute;lisis de contratos&quot; de la ficha del asunto correspondiente, si es necesario o no solicitar la no afecci&oacute;n para cada uno delos bienes relacionados con los contratos. En los casos que considere que s&iacute; es necesario, deber&aacute; indicar dicha circunstancia en cada bien as&iacute; como la fecha de solicitud de la misma.</p></div>''',null,'existeBienConSolicitudNoAfeccionSI() ? ''Si'' : ''No''',null,'0','Solicitar la no afección de los bienes','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
    
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
    
      T_TIPO_PLAZAS(null,null,'P402_AnalisisOperacionesConcurso','valoresBPMPadre[''P412_RegistrarPublicacionBOE''] != null && valoresBPMPadre[''P412_RegistrarPublicacionBOE''][''fecha''] != null && valoresBPMPadre[''P412_RegistrarPublicacionBOE''][''fecha''] != '''' ? damePlazo(valoresBPMPadre[''P412_RegistrarPublicacionBOE''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_EstudiarInicioPosEjec','damePlazo(valores[''P402_AnalisisOperacionesConcurso''][''fecha'']) + 5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_RevisarPropuestaLetrado','damePlazo(valores[''P402_EstudiarInicioPosEjec''][''fecha'']) + 5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_BPMInicioEJ_A','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_ComunicadoDecisionEntidadA','damePlazo(valores[''P402_RevisarPropuestaLetrado''][''fecha'']) + 1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_SolSolvenciaPatrimonial','damePlazo(valores[''P402_AnalisisOperacionesConcurso''][''fecha'']) + 5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_RegistrarResultadoSolvencias','damePlazo(valores[''P402_SolSolvenciaPatrimonial''][''fecha'']) + 30*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_ComunicadoDecisionEntidadB','damePlazo(valores[''P402_RegistrarResultadoSolvencias''][''fecha'']) + 1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_DictarInstrucciones','damePlazo(valores[''P402_RegistrarResultadoSolvencias''][''fecha'']) + 1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_BPMInicioEJ_B','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P420_SolicitarNoAfeccionBienes','damePlazo(valores[''P402_AnalisisOperacionesConcurso''][''fecha'']) + 5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_RegResolucionesNoAfeccion','damePlazo(valores[''P420_SolicitarNoAfeccionBienes''][''fecha'']) + 30*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_DecidirSobreEjecuciones','damePlazo(valores[''P402_RegResolucionesNoAfeccion''][''fecha'']) + 1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_BPMInicioEJ_C1','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_ComunicadoDecisionEntidadC1','damePlazo(valores[''P402_DecidirSobreEjecuciones''][''fecha'']) + 1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_EsperaFDeclaracionConcurso','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_RevisarSituacionConcurso','1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_RevisarIniContEjec','damePlazo(valores[''P402_RevisarSituacionConcurso''][''fecha'']) + 1*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_BPMInicioEJ_C2','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P402_ComunicadoDecisionEntidadC2','damePlazo(valores[''P402_RevisarIniContEjec''][''fecha'']) + 1*24*60*60*1000L','0','0','DD')

    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    
    
        T_TIPO_TFI('P402_AnalisisOperacionesConcurso','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será , dependiendo de la información introducida:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber encontrado alguna garantía adicionales / personales de tipo "Prendas / pignoración / IPF / Otros" en los contratos del concurso, se lanzará la tarea "Estudiar inicio de posibles ejecuciones".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber encontrado alguna garantía adicionales / personales de tipo "Fiadores / Librado / descuento" en los contratos del concurso, se lanzará la tarea "Solicitar solvencias patrimoniales".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber encontrado alguna garantía hipotecaria en los contratos del concurso, se iniciará la tarea "Solicitar la no afección de los bienes".</li></ul></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_AnalisisOperacionesConcurso','1','date','fecha','Fecha fin de análisis','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_AnalisisOperacionesConcurso','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_EstudiarInicioPosEjec','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá indicar la fecha en que da por finalizado el estudio de las operaciones con Garantías adicionales, personales o reales.</p><p style="margin-bottom: 10px">En el campo observaciones realizar un breve informe que avale la recomendación indicada en la pestaña "Análisis de contratos".</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Revisar propuesta letrado" que deberá ser realizar por el supervisor del concurso</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_EstudiarInicioPosEjec','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_EstudiarInicioPosEjec','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarPropuestaLetrado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ante cualquier discrepancia con las propuestas realizadas por el letrado y antes de su decisión definitiva, en caso de duda deberá solventar con el letrado dichas discrepancia. Las instrucciones que se marquen en la columna "Iniciar ejecución" serán definitivas, no modificables y provocarán el inicio de la preparación del expediente judicial por parte de la EDP.</p><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que da por finalizada la revisión de las propuestas del letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. Tenga en cuenta que, en caso de que se deba iniciarse alguna ejecución,  estas observaciones serán trasladadas a la empresa de preparación de expediente judicial para su conocimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzaran tantos trámites de inicio de expediente judicial como ejecuciones haya indicado que se deben iniciar. En caso de haber discrepancia entre la propuesta dada por el letrado y la decisión tomada por la entidad, se lanzará la tarea "Comunicado decisión entidad" a realizar por el letrado.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarPropuestaLetrado','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarPropuestaLetrado','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_BPMInicioEJ_A','0','label','titulo','Se inicia el trámite Inicio Expediente Judicial A P405',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadA','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que ha habido discrepancia entre la propuesta cursada por letrado y la realizada por la entidad, a través de esta tarea se pone en conocimiento dicha circunstancia. Para consultar el resultado final del análisis de las operaciones deberá acceder a la pestaña "Análisis de operaciones" de la ficha del asunto correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que da por finalizada la lectura de las instrucciones dadas por la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido el análisis de los contratos de garantías reales o personales de tipo Prendas, Pignoración, IPF, otros.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadA','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadA','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_SolSolvenciaPatrimonial','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que da por finalizada la solicitud de solvencias.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en caso de haber solicitado alguna solvencia,  la siguiente tarea será "Registrar resultado solvencia" que deberá ser realizada por el supervisor del concurso. En caso contrario se dará por finalizada la revisión de contratos con garantías adicionales o personales de tipo Fiadores, Librado o Descuento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_SolSolvenciaPatrimonial','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_SolSolvenciaPatrimonial','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RegistrarResultadoSolvencias','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que da por terminada la revisión de solvencias y la decisión de actuación sobre los contratos.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, dependiendo de los valores introducidos, podrá ser:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">"Dictar instrucciones" Una tarea de este tipo por cada ejecución que se vaya a iniciar y a completar por el supervisor.</li><li style="margin-bottom: 10px; margin-left: 35px;">"Comunicado decisión entidad "Tarea a realizar por el letrado y lanzada en caso de que haya solvencias negativas que informar al letrado o solvencias positivas con decisión de no ejecutar o continuar por parte de la entidad.</li></ul></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RegistrarResultadoSolvencias','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_RegistrarResultadoSolvencias','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadB','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea se le informa de la decisión tomada por la entidad respecto a los contratos marcados por el letrado con garantías de tipo "Garantías adicionales o personales (Fiadores, Librado, Descuento)", para su consulta deberá acceder a la pestaña "Análisis de contratos" de la ficha del asunto correspondiente. Una vez revisado consigne la fecha en que ha terminado la revisión.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido el análisis de los contratos de garantías reales o personales de tipo Fiadores, Librado o Descuento.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadB','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadB','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_DictarInstrucciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar a la Agencia de preparación de expediente, las instrucciones a seguir para la creación y preparación del nuevo expediente de prelitigio. Tenga en cuenta que las instrucciones que registre en el campo Instrucciones serán recibidas por la empresa de preparación de expediente.</p><p style="margin-bottom: 10px">La operación asociada al nuevo expediente será la que aparece en el campo Contrato.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se iniciar el trámite de inicio expediente judicial.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_DictarInstrucciones','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_DictarInstrucciones','2','text','contrato','Contrato','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameContratoAsignadoATarea()',null,'0','DD'),
        T_TIPO_TFI('P402_DictarInstrucciones','3','label','instrucLabel','<div align="justify" style="font-size: 8pt; font-family: Arial; margin: 10px 0 10px;"><p>A continuación escriba las instrucciones para la empresa de preparación del expediente:</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_DictarInstrucciones','4','htmleditor','instrucciones','Instrucciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,null,null,'0','DD'),
        T_TIPO_TFI('P402_DictarInstrucciones','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_BPMInicioEJ_B','0','label','titulo','Se inicia el trámite Inicio Expediente Judicial B P405',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P420_SolicitarNoAfeccionBienes','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo fecha deberá indicar la fecha en que de por terminada la solicitud de no afección de los bienes.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en caso de haber solicitado alguna desafección de bienes,  la siguiente tarea será "Registrar resultado resoluciones no afección" que deberá ser realizada por el supervisor del concurso, en caso contrario será por finalizada la revisión de contratos con garantías Hipotecarias"</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P420_SolicitarNoAfeccionBienes','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P420_SolicitarNoAfeccionBienes','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RegResolucionesNoAfeccion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que se haya terminado de cargar el resultado sobre la solicitud de no afección de los bienes.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, dependiendo de los valores introducidos, podrá ser:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que haya uno o mas contratos con garantías hipotecarias donde alguno de los bienes ha quedado no afecto se iniciará la tarea "Decidir sobre ejecuciones"</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no haber ningún contrato con garantía hipotecaria donde alguno de los bienes haya quedado no afecto, la actuación se quedará a la espera de que pase un año, momento en el cual el sistema lanzará una tarea automáticamente para revisar la situación del concurso.</li></ul></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RegResolucionesNoAfeccion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_RegResolucionesNoAfeccion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_DecidirSobreEjecuciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que se haya terminado de decidir sobre cada uno de los contratos afectos a este punto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. En caso de haberse indicado el inicio de alguna ejecución, el valor introducido aquí será puesto en conocimiento de la empresa de preparación del expediente judicial.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, dependiendo de los valores introducidos, podrá ser:</p><p style="margin-bottom: 10px"><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Para cada uno de los contratos en los que haya decidido iniciar ejecución se iniciará el trámite de preparación de expediente judicial.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber alguna ejecución paralizada para alguno de los contratos donde se haya obtenido una resolución favorable a la no afección de alguno de sus bienes, se lanzará la tarea "Comunicado decisión entidad" al letrado.</li></ul></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_DecidirSobreEjecuciones','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_DecidirSobreEjecuciones','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_BPMInicioEJ_C1','0','label','titulo','Se inicia el trámite Inicio Expediente Judicial C1 P405',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadC1','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea se le informa de la decisión tomada por la entidad respecto a los contratos marcados por el letrado con garantías hipotecarias, donde alguno de los bienes a resultado no afecto y haya una ejecución paralizada. Para su consulta deberá acceder a la pestaña "Análisis de contratos" de la ficha del asunto correspondiente. Una vez revisado consigne la fecha en que ha terminado la revisión.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido el análisis de los contratos de garantías hipotecarias.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadC1','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadC1','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_EsperaFDeclaracionConcurso','0','label','titulo','Espera F. auto delcara. concurso - 1 año',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_EsperaFDeclaracionConcurso','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarSituacionConcurso','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Habiendo transcurrido un año desde la fecha del auto declarando concurso, y siendo que alguno de los contratos del concurso dispone de garantías reales, a través de esta pantalla deberá indicar la situación en que se encuentra el concurso, ya sea que se ha iniciado la fase de convenio o liquidación o no se haya iniciado ninguna de dichas fases.</p><p style="margin-bottom: 10px">En el campo Fecha deberá indicar la fecha en que revisa el concurso.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no haberse iniciado la fase convenio o de liquidación "Revisar inicio o continuación de ejecuciones hipotecarias" a realizar por el supervisor del concurso.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso contrario se dar por finalizado el análisis de las operaciones con garantía hipotecaria.</li></ul></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarSituacionConcurso','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarSituacionConcurso','2','combo','comboLiquidacion','Liquidación o convenio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P402_RevisarSituacionConcurso','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarIniContEjec','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el campo Fecha deberá consignar la fecha en que se haya terminado de decidir sobre cada uno de los contratos afectos a este punto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. En caso de haberse indicado el inicio de alguna ejecución, el valor introducido aquí será puesto en conocimiento de la empresa de preparación del expediente judicial.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, dependiendo de los valores introducidos, podrá ser:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Para cada uno de los contratos en los que haya decidido iniciar ejecución se iniciará el trámite de preparación de expediente judicial.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber alguna ejecución paralizada para alguno de los contratos donde se haya obtenido una resolución favorable a la no afección de alguno de sus bienes, se lanzará la tarea "Comunicado decisión entidad" al letrado.</li></ul></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarIniContEjec','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_RevisarIniContEjec','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_BPMInicioEJ_C2','0','label','titulo','Se inicia el trámite Inicio Expediente Judicial C2 P405',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadC2','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea se le informa de la decisión tomada por la entidad respecto a los contratos marcados por el letrado con garantías hipotecarias y que estaban a la espera de decisión por parte de la entidad. Para su consulta deberá acceder a la pestaña "Análisis de contratos" de la ficha del asunto correspondiente. Una vez revisado consigne la fecha en que ha terminado la revisión.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta tarea se dará por concluido el análisis de los contratos de garantías hipotecarias.</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadC2','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P402_ComunicadoDecisionEntidadC2','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
    
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TPO||' = '''||V_TMP_TIPO_TPO(1)||''' Descripcion = '''||V_TMP_TIPO_TPO(2)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_TABLENAME||', con codigo '||V_CODIGO_TPO||' = '''||V_TMP_TIPO_TPO(1)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE '||V_CODIGO_TPO||' = '''|| V_TMP_TIPO_TPO(1) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_TABLENAME);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');
        
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
    V_CODIGO_TAP := 'TAP_CODIGO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||''' Descripcion = '''||V_TMP_TIPO_TAP(9)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_TABLENAME||', con codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE '||V_CODIGO_TAP||' = '''|| V_TMP_TIPO_TAP(2) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_TABLENAME);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

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
                      '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
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
    V_CODIGO_PLAZAS := 'TAP_CODIGO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||''' Descripcion = '''||V_TMP_TIPO_PLAZAS(4)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_TABLENAME||', con codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TMP_TIPO_PLAZAS(3) ||''') ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_TABLENAME);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

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
    V_CODIGO1_TFI := 'TAP_CODIGO';
    V_CODIGO2_TFI := 'TFI_NOMBRE';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigos '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' Descripcion = '''||V_TMP_TIPO_TFI(5)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_TABLENAME||', con codigo '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''') AND '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_TABLENAME);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

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
              --DBMS_OUTPUT.PUT_LINE(V_MSQL);
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