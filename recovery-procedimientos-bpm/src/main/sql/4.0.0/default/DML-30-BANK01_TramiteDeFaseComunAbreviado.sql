/*
--##########################################
--## Author: Gonzalo Estellés
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Procedimiento F. C. Abreviado.
--## INSTRUCCIONES:  Procedimiento F. C. Abreviado.
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
      T_TIPO_TPO('P412','T. fase común abreviado','T. fase común abreviado',null,'tramiteFaseComunAbreviadoV4','0','dd','0','CO',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('P412','P412_RevisarInsinuacionCreditos',null,null,'valores[''P412_RevisarInsinuacionCreditos''][''numCreditos''] == null || valores[''P412_RevisarInsinuacionCreditos''][''numCreditos''] == '''' || valores[''P412_RevisarInsinuacionCreditos''][''numCreditos''] == ''0'' ? (cuentaCreditosInsinuadosSup() != ''0'' ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : null) : (cuentaCreditosInsinuadosSup()!=valores[''P412_RevisarInsinuacionCreditos''][''numCreditos''] ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)',null,null,'1','Revisar insinuación de créditos','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
      T_TIPO_TAP('P412','P412_ValidarAlegaciones','plugin/procedimientos/tramiteFaseComunAbreviado/validarAlegaciones',null,null,'valores[''P412_ValidarAlegaciones''][''PresentaAlegacionesCombo''] == DDSiNo.SI ? ''OK'' : ''KO''',null,'1','Validar alegaciones','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'40',null,null,null),
      T_TIPO_TAP('P412','P412_ActualizarEstadoCreditos',null,null,'creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos''',null,null,'0','Actualizar estado de los créditos insinuados','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_BPMTramiteAceptacionV4',null,null,null,null,'P404','0','Tramite de Aceptación','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_BPMTramiteDemandaIncidental',null,null,null,null,'P25','0','Tramite de Demanda Incidental','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_BPMTramiteFaseConvenioV4',null,null,null,null,'P408','0','Se inicia la Fase de convenio','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_BPMTramiteFaseLiquidacion',null,null,null,null,'P31','0','Se inicia la Fase de liquidación','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_PresentarEscritoInsinuacion','plugin/procedimientos/tramiteFaseComunAbreviado/presentarEscritoInsinuacionCreditos',null,'creditosDefinitivosDefinidosEInsinuados() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosNoInsinuados''',null,null,'0','Presentar escrito de insinuación','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_PresentarRectificacion',null,null,null,null,null,'0','Presentar rectificación','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_RegistrarInformeAdmonConcursal',null,null,'creditosDefinitivosPendientes() ? ''tareaExterna.procedimiento.tramiteFaseComun.creditosDefinitivosPendientes'': null',null,null,'0','Registrar informe de la administración concursal','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_RegistrarInsinuacionCreditos',null,null,'valores[''P412_RegistrarInsinuacionCreditos''][''numCreditos''] == null || valores[''P412_RegistrarInsinuacionCreditos''][''numCreditos''] == '''' || valores[''P412_RegistrarInsinuacionCreditos''][''numCreditos''] == ''0'' ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'': (cuentaCreditosInsinuadosExt()!=valores[''P412_RegistrarInsinuacionCreditos''][''numCreditos''] ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)',null,null,'0','Registrar insinuación de créditos','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_RegistrarProyectoInventario',null,null,null,'valores[''P412_RegistrarProyectoInventario''][''comFavorable''] == DDSiNo.SI ? ''favorable'' : ''desfavorable''',null,'0','Registrar proyecto de inventario','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_RegistrarPublicacionBOE','plugin/procedimientos/tramiteFaseComunAbreviado/regPublicacionBOE',null,null,null,null,'0','Registrar publicación en el BOE','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'600',null,null,null),
      T_TIPO_TAP('P412','P412_RegistrarResolucionFaseComun',null,null,null,'valores[''P412_RegistrarResolucionFaseComun''][''comboLiquidacion''] == DDSiNo.SI ? ''faseLiquidacion'' : ''faseConvenio''',null,'0','Registrar resolución de fase común','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
      T_TIPO_TAP('P412','P412_RevisarResultadoInfAdmon',null,null,'valores[''P412_RevisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ( creditosDespuesDeIACConDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACDemandaMalDefinidos'' ) : ( creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos'')','valores[''P412_RevisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ''SI'' : ''NO''',null,'0','Revisar informe de la administración concursal','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
       T_TIPO_PLAZAS(null,null,'P412_RegistrarPublicacionBOE','3*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_BPMTramiteAceptacionV4','300*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_RegistrarInsinuacionCreditos','damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fecha'']) + 5*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_RevisarInsinuacionCreditos','damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fecha'']) + 22*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_PresentarEscritoInsinuacion','damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fecha'']) + 30*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_RegistrarProyectoInventario','damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_PresentarRectificacion','damePlazo(valores[''P412_PresentarEscritoInsinuacion''][''fecha'']) + 7*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_RegistrarInformeAdmonConcursal','damePlazo(valores[''P412_RegistrarPublicacionBOE''][''fechaAuto'']) + 45*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_RevisarResultadoInfAdmon','damePlazo(valores[''P412_RegistrarInformeAdmonConcursal''][''fecha'']) + 2*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_RegistrarResolucionFaseComun','180*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_ValidarAlegaciones','damePlazo(valores[''P412_RegistrarInformeAdmonConcursal''][''fecha'']) + 5*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_BPMTramiteDemandaIncidental','300*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_ActualizarEstadoCreditos','1*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_BPMTramiteFaseConvenioV4','300*24*60*60*1000L','0','0','DD'),
       T_TIPO_PLAZAS(null,null,'P412_BPMTramiteFaseLiquidacion','300*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
       T_TIPO_TFI ('P412_RegistrarPublicacionBOE','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá de revisar los datos que aparecen rellenados respecto al nuevo concurso y consignar aquellos datos que aparecen vacíos. Opcionalmente puede consignar los datos de contacto de los administradores concursales designados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar insinuación de créditos"</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','1','date','fecha','Fecha de publicación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','2','date','fechaAuto','Fecha auto declarando concurso','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','3','combo','plazaJuzgado','Plaza del juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','damePlaza()','TipoPlaza','0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','4','combo','nJuzgado','Nº de juzgado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumJuzgado()','TipoJuzgado','0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','5','textproc','nAuto','Nº Auto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumAuto()',null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','6','date','fechaAceptacion','Fecha aceptación del cargo de la Adm. Concursal','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','7','combo','tipoConcurso','Tipo de concurso','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDTipoConcurso','0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','8','text','admNombre','Adm. Nombre',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','9','text','admDireccion','Adm. dirección',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','10','text','admTelefono','Adm. teléfono',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','11','text','admEmail','Adm. email',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','12','text','admNombre2','Adm.2 Nombre',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','13','text','admDireccion2','Adm.2 dirección',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','14','text','admTelefono2','Adm.2 teléfono',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','15','text','admEmail2','Adm.2 email',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','16','text','admNombre3','Auxiliar delegado Nombre',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','17','text','admDireccion3','Auxiliar delegado Dirección',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','18','text','admTelefono3','Auxiliar delegado Teléfono',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','19','text','admEmail3','Auxiliar delegado Email',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarPublicacionBOE','20','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_BPMTramiteAceptacionV4','0','label','titulo','Trámite de Aceptación por parte del gestor',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarInsinuacionCreditos','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de poder completar esta tarea deberá acceder a la pestaña "Fase común" de la ficha del asunto correspondiente y proceder a la insinuación de los créditos, para ello dispone del botón “Agregar calificación”, a través del cual podrá tanto proponer una calificación inicial de los contratos asociados al concurso para posterior revisión por parte de la entidad,  como establecer la calificación definitiva de los contratos asociados al concurso a expensas de que la entidad lo revise.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el número de créditos insinuados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Revisar insinuación de créditos" a realizar por el supervisor del asunto concursal.</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarInsinuacionCreditos','1','currency','numCreditos','Nº de créditos insinuados','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarInsinuacionCreditos','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RevisarInsinuacionCreditos','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de rellenar esta pantalla deberá revisar las insinuaciones realizadas por el letrado, para el supuesto que quiera rectificar alguna de ellas deberá acceder a la pestaña "Fase común" de la ficha del asunto correspondiente y a través del botón "Revisar calificación" proponer los valores que estime en los campos de calificación revisada.</p><p style="margin-bottom: 10px">En la presente pantalla y para el caso del supuesto anterior debe indicar el número de créditos rectificados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Presentar escrito de insinuación de créditos" a realizar por el letrado concursa</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RevisarInsinuacionCreditos','1','currency','numCreditos','Nº de créditos rectificados',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RevisarInsinuacionCreditos','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de poder completar esta tarea, deberá asegurarse que todas las insinuaciones de crédito a presentar a la administración concursal, se encuentran en la pestaña Fase común del asunto correspondiente con valores definitivos y en estado "2. Insinuado".</p><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentación o envío por correo electrónico de la propuesta de insinuación de créditos a la administración concursal.</p><p style="margin-bottom: 10px">En esta tarea, aparecerán acumulados los importes de los créditos insinuados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será, si hemos comunicado nuestros créditos a la Administración concursal mediante correo electrónico, "Revisar proyecto de inventario".</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','1','date','fecha','Fecha presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','2','currency','tCredMasa','Total créditos contra la masa','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameTotalCreditosContraLaMasa()',null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','3','currency','tCredPrivEsp','Total créditos con privilegio especial','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameTotalCreditosConPrivilegioEspecial()',null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','4','currency','tCredPrivGen','Total créditos con privilegio general','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameTotalCreditosConPrivilegioGeneral()',null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','5','currency','tCredOrd','Total créditos ordinarios','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameTotalCreditosOrdinarios()',null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','6','currency','tCredSub','Total créditos subordinados','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameTotalCreditosSubordinados()',null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','7','currency','tCredContigentes','Total créditos contigentes','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameTotalCreditosContingentes()',null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','8','currency','totalCred','Total créditos insinuados',null,null,'dameTotalCreditos()',null,'0','DD'),
       T_TIPO_TFI('P412_PresentarEscritoInsinuacion','9','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarProyectoInventario','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deberá consignar la fecha con la que se nos comunica mediante correo electrónico por la Administración Concursal el proyecto de inventario.</p><p style="margin-bottom: 10px">Igualmente, deberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administración Concursal. En el caso de que sea favorable, se deberá esperar a la siguiente tarea sobre el informe presentado por la Administración Concursal ante el juez.</p><p style="margin-bottom: 10px">En el caso de que sea desfavorable, deberá comprobar si el error ha sido cometido por la Entidad a la hora de elaborar la insinuación de créditos. Si la insinuación ha sido correcta deberá ponerse en contacto con la Administración Concursal para su aclaración. Con independencia de que se aclarada o no la discrepancia con la Administración Concursal, se deberá remitir igualmente correo electrónico a la Administración Concursal solicitando su subsanación para su constancia por escrito, haciendo mención en su caso de la aclaración efectuada previamente.</p><p style="margin-bottom: 10px">En aquellos casos en los que la discrepancia sea relevante deberá informar al supervisor mediante comunicado o notificación para anticipar la posibilidad de que sea  necesario interponer un incidente de impugnación una vez presentado el informe en el Juzgado. En todo caso, tanto si el proyecto es favorable como desfavorable, deberemos modificar el estado de todos los créditos al estado "3. Pendiente revisión IAC" para completar esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será, en caso de ser favorable "Registrar informe de la administración concursal" y en caso contrario "Presentar rectificación".</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarProyectoInventario','1','date','fechaComunicacion','Fecha de comunicación del proyecto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarProyectoInventario','2','combo','comFavorable','Favorable','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
       T_TIPO_TFI('P412_RegistrarProyectoInventario','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_PresentarRectificacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deberá consignar la fecha del envío por correo electrónico del escrito solicitando la rectificación de errores o el complemento de datos en el proyecto de inventario y de la lista de acreedores notificados por la Administración Concursal.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. Una vez rellene esta pantalla la siguiente tarea será "Registrar informe de la administración concursal".</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_PresentarRectificacion','1','date','fecha','Fecha presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_PresentarRectificacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarInformeAdmonConcursal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de recepción del informe de administración concursal en respuesta a nuestra presentación de insinuación de créditos, al pulsar Aceptar el sistema comprobará que los créditos insinuados en la pestaña "Fase Común" disponen de cuantías finales y que se encuentran en estado "3 Pendiente Revisión IAC". Para ello debe abrir el asunto correspondiente, ir a la pestaña Fase Común y abrir la ficha de cada uno de los créditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Revisar informe de la administración concursal".</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarInformeAdmonConcursal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarInformeAdmonConcursal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RevisarResultadoInfAdmon','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones al informe de la Administración Concursal, al pulsar Aceptar el sistema comprobará que el estado de los créditos insinuados en la pestaña Fase Común es, en caso de presentar alegaciones "4. Pendiente de demanda incidental" o en caso contrario "6. Reconocido". Para ello debe abrir el asunto correspondiente, ir a la pestaña "Fase Común" y abrir la ficha de cada uno de los créditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea en caso de no presentar alegaciones será "Registrar resolución de finalización fase común" y en caso de haberse presentado se lanzará la tarea "Validar alegaciones" al supervisor del concurso.</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RevisarResultadoInfAdmon','1','combo','comAlegaciones','Presentar alegaciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
       T_TIPO_TFI('P412_RevisarResultadoInfAdmon','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarResolucionFaseComun','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea deberá completarla en el momento que tenga constancia del fin de la fase común e inicio de la siguiente fase. En el campo "Situación concursal" deberá indicar la situación en la que queda el concurso una vez completada esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciará la Fase de liquidación en caso de que lo haya indicado así, en caso contrario se iniciará la Fase de convenio.</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarResolucionFaseComun','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_RegistrarResolucionFaseComun','2','combo','comboLiquidacion','Fase de liquidación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
       T_TIPO_TFI('P412_RegistrarResolucionFaseComun','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_ValidarAlegaciones','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá revisar si procede presentar alegaciones según informa el letrado del concurso.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, en caso de haber acordado junto al letrado la presentación de alegaciones, se iniciará el trámite de demanda incidental, en caso contrario se iniciará la tarea "Registrar resolución de fase".</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_ValidarAlegaciones','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
       T_TIPO_TFI('P412_ValidarAlegaciones','2','combo','PresentaAlegaciones','Presenta alegaciones','','','valores[''P412_RevisarResultadoInfAdmon''][''comAlegaciones'']','DDSiNo','0','DD'),
       T_TIPO_TFI('P412_ValidarAlegaciones','3','textarea','ObservacionesLetrado','Observaciones letrado',null,null,'valores[''P412_RevisarResultadoInfAdmon''][''observaciones'']',null,'0','DD'),
       T_TIPO_TFI('P412_ValidarAlegaciones','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_ValidarAlegaciones','4','combo','PresentaAlegacionesCombo','Presentar alegaciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
       T_TIPO_TFI('P412_BPMTramiteDemandaIncidental','0','label','titulo','Se inicia Trámite demanda incidental',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_ActualizarEstadoCreditos','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para completar esta tarea deberá actualizar el estado de los créditos insinuados en la pestaña "Fase común" de la ficha del Asunto correspondiente a valor "6. Reconocido".</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar resolución finalización fase común".</p></div>',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_ActualizarEstadoCreditos','1','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_BPMTramiteFaseConvenioV4','0','label','titulo','Se inicia la Fase de convenio',null,null,null,null,'0','DD'),
       T_TIPO_TFI('P412_BPMTramiteFaseLiquidacion','0','label','titulo','Se inicia la Fase de liquidación',null,null,null,null,'0','DD')
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