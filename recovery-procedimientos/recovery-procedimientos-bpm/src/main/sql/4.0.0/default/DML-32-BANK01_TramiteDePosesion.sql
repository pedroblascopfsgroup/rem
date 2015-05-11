/*
--##########################################
--## Author: Gonzalo Estellés
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite de posesion
--## INSTRUCCIONES:  Tramite de posesion
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
      T_TIPO_TPO('P416','T. de Posesión','Trámite de Posesión',null,'tramiteDePosesionV4','0','dd','0','AP',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       T_TIPO_TAP('P416','P416_BPMTramiteGestionLlaves',null,null,null,null,'P417','0','Tramite de Gestión de llaves','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_BPMTramiteMoratoriaLanzamiento',null,null,null,null,'P418','0','Tramite Moratoria Lanzamiento','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_BPMTramiteOcupantes',null,null,null,null,'P419','0','Trámite de ocupantes','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_BPMTramiteOcupantes2',null,null,null,null,'P419','0','Trámite de ocupantes','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_RegistrarDecisionLlaves',null,null,null,'valores[''P416_RegistrarDecisionLlaves''][''comboLlaves''] == DDSiNo.SI ? ''requiereLlaves'' : ''noRequiereLlaves''',null,'0','Registrar decisión sobre llaves','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_RegistrarLanzamientoEfectuado',null,'comprobarExisteDocumentoDJL() ? null : ''Es necesario adjuntar el documento diligencia judicial del lanzamiento''',null,null,null,'0','Registrar lanzamiento efectuado','0','dd','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_RegistrarPosesionYLanzamiento','plugin/procedimientos/tramiteDePosesion/registrarPosesionYLanzamiento','comprobarExisteDocumentoDJP() ? null : ''Es necesario adjuntar el documento diligencia judicial de la posesión''','valores[''P416_RegistrarPosesionYLanzamiento''][''comboOcupado''] == ''02'' && (valores[''P416_RegistrarPosesionYLanzamiento''][''fecha''] == null || valores[''P416_RegistrarPosesionYLanzamiento''][''comboFuerzaPublica''] == null || valores[''P416_RegistrarPosesionYLanzamiento''][''comboLanzamiento''] == null) ? ''Los campos <b>Fecha realizaci&oacute;n de la posesi&oacute;n</b>, <b>Necesario Fuerza P&uacute;blica</b> y <b>Lanzamiento Necesario</b> son obligatorios'' : (valores[''P416_RegistrarPosesionYLanzamiento''][''comboLanzamiento'']  == ''02'' && valores[''P416_RegistrarPosesionYLanzamiento''][''fechaSolLanza''] == null) ? ''El campo <b>Fecha solicitud de lanzamiento</b> es obligatorio'' : null','valores[''P416_RegistrarPosesionYLanzamiento''][''comboOcupado''] == DDSiNo.SI ? ''conOcupantes'' : (valores[''P416_RegistrarPosesionYLanzamiento''][''comboLanzamiento''] == DDSiNo.SI ? ''hayLanzamiento'' : ''noHayLanzamiento'')',null,'0','Registrar posesión y decisión sobre lanzamiento','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_RegistrarSenyalamientoLanzamiento',null,null,null,null,null,'0','Registrar Señalamiento del Lanzamiento','0','dd','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_RegistrarSenyalamientoPosesion',null,null,null,null,null,'0','Registrar Señalamiento de la Posesión','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null),
       T_TIPO_TAP('P416','P416_RegistrarSolicitudPosesion','plugin/procedimientos/tramiteDePosesion/registrarSolicitudPosesion','comprobarBienAsociadoPrc() ? null : ''Debe tener un bien asociado al procedimiento''','valores[''P416_RegistrarSolicitudPosesion''][''comboPosesion''] == ''01'' && (valores[''P416_RegistrarSolicitudPosesion''][''fechaSolicitud''] == null || valores[''P416_RegistrarSolicitudPosesion''][''comboOcupado''] == null || valores[''P416_RegistrarSolicitudPosesion''][''comboMoratoria''] == null || valores[''P416_RegistrarSolicitudPosesion''][''comboViviendaHab''] == null) ? ''Los campos <b>Fecha de solicitud de la posesi&oacute;n</b>, <b>Ocupado</b>, <b>Moratoria</b> y <b>Vivienda Habitual</b> son obligatorios'' : null','valores[''P416_RegistrarSolicitudPosesion''][''comboMoratoria''] == DDSiNo.SI ? ''solicitudMoratoriaLanzamiento'' : (valores[''P416_RegistrarSolicitudPosesion''][''comboOcupado''] == DDSiNo.SI ? ''posesionConOcupantes'' : (valores[''P416_RegistrarSolicitudPosesion''][''comboPosesion''] == DDSiNo.SI ? ''posesionSinOcupantes'' : ''noRequierePosesion''))',null,'0','Registrar Solicitud de Posesión','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,null,null,null,null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'P416_RegistrarSolicitudPosesion','(valores[''P413_ConfirmarTestimonio''] != null && valores[''P413_ConfirmarTestimonio''][''fechaTestimonio''] != null && valores[''P413_ConfirmarTestimonio''][''fechaTestimonio''] != '''') ? damePlazo(valores[''P413_ConfirmarTestimonio''][''fechaTestimonio'']) + 5*24*60*60*1000L : 5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_BPMTramiteMoratoriaLanzamiento','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_RegistrarSenyalamientoPosesion','damePlazo(valores[''P416_RegistrarSolicitudPosesion''][''fechaSolicitud'']) + 5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_RegistrarPosesionYLanzamiento','damePlazo(valores[''P416_RegistrarSenyalamientoPosesion''][''fechaSenyalamiento'']) + 30*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_BPMTramiteOcupantes','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_BPMTramiteOcupantes2','300*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_RegistrarSenyalamientoLanzamiento','damePlazo(valores[''P416_RegistrarPosesionYLanzamiento''][''fecha'']) + 5*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_RegistrarLanzamientoEfectuado','damePlazo(valores[''P416_RegistrarSenyalamientoLanzamiento''][''fecha'']) + 30*24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_RegistrarDecisionLlaves','((valores[''P416_RegistrarLanzamientoEfectuado''][''fecha''] !='''') && (valores[''P416_RegistrarLanzamientoEfectuado''][''fecha''] != null)) ? damePlazo(valores[''P416_RegistrarLanzamientoEfectuado''][''fecha'']) + 24*60*60*1000L : damePlazo(valores[''P416_RegistrarPosesionYLanzamiento''][''fecha'']) + 24*60*60*1000L','0','0','DD'),
      T_TIPO_PLAZAS(null,null,'P416_BPMTramiteGestionLlaves','300*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI('P416_RegistrarLanzamientoEfectuado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de consignar la fecha de lanzamiento efectivo así como dejar indicado si ha sido necesario el uso de la fuerza pública o no.</p><p style="margin-bottom: 10px">En caso de haberse producido el lanzamiento deberá de adjuntar al procedimiento el documento "Diligencia judicial del lanzamiento"</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Registrar decisión sobre llaves".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSolicitudPosesion','1','combo','comboPosesion','Posible Posesión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarSolicitudPosesion','2','date','fechaSolicitud','Fecha de solicitud de la posesión',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSolicitudPosesion','3','combo','comboOcupado','Ocupado',null,null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarSolicitudPosesion','4','combo','comboMoratoria','Moratoria',null,null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarSolicitudPosesion','5','combo','comboViviendaHab','Vivienda Habitual',null,null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarSolicitudPosesion','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_BPMTramiteMoratoriaLanzamiento','0','label','titulo','Trámite de Moratoria de Lanzamiento',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSenyalamientoPosesion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de consignar la fecha de señalamiento para la posesión.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzará la tarea "Registrar alzamiento efectivo".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSenyalamientoPosesion','1','date','fechaSenyalamiento','Fecha señalamiento para posesión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSenyalamientoPosesion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarPosesionYLanzamiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá consignar en primer lugar si el bien se encuentra ocupado, y en caso negativo indicar la fecha de realización de la posesión, necesario fuerza pública y si el lanzamiento es necesario o no.</p><p style="margin-bottom: 10px">En caso de haberse producido la posesión deberá de adjuntar al procedimiento el documento "Diligencia judicial de la posesión"</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzará:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber marcado el bien como ocupado, se lanzará el trámite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de Lanzamiento necesario se lanzará la tarea "Registrar señalamiento del lanzamiento".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no ser necesario el lanzamiento se lanzará la tarea "Registrar decisión sobre llaves".</li></ul></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarPosesionYLanzamiento','1','combo','comboOcupado','Ocupado en la realización de la Diligencia','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarPosesionYLanzamiento','2','date','fecha','Fecha realización de la posesión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarPosesionYLanzamiento','3','combo','comboFuerzaPublica','Necesario Fuerza Pública','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarPosesionYLanzamiento','4','combo','comboLanzamiento','Lanzamiento Necesario','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarPosesionYLanzamiento','5','date','fechaSolLanza','Fecha solicitud del lanzamiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarPosesionYLanzamiento','6','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_BPMTramiteOcupantes','0','label','titulo','Trámite de Ocupantes',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_BPMTramiteOcupantes2','0','label','titulo','Trámite de Ocupantes',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSenyalamientoLanzamiento','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de consignar la fecha de señalamiento para el lanzamiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Registrar lanzamiento efectivo".</p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSenyalamientoLanzamiento','1','date','fecha','Fecha señalamiento para el lanzamiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSenyalamientoLanzamiento','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarLanzamientoEfectuado','1','date','fecha','Fecha lanzamiento efectivo','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarLanzamientoEfectuado','2','combo','comboFuerzaPublica','Necesario Fuerza Pública','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarLanzamientoEfectuado','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarDecisionLlaves','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá dejar constancia de si es necesario realizar una gestión de las llaves por cambio de cerradura, o no.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en el caso de ser necesaria una gestión de las llaves se iniciará el trámite para la gestión de llaves, en caso contrario se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. </p></div>',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarDecisionLlaves','1','combo','comboLlaves','Gestión de Llaves','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
        T_TIPO_TFI('P416_RegistrarDecisionLlaves','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_BPMTramiteGestionLlaves','0','label','titulo','Trámite de Gestión de llaves',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P416_RegistrarSolicitudPosesion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">A través de esta tarea deberá de informar si hay una posible posesión o no, en caso de que proceda, la fecha de solicitud de la posesión, si el bien se encuentra ocupado o no, si se ha producido una petición de moratoria y en cualquier caso se deberá informar la condición del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px">En caso de que no haya ningún bien vinculado al procedimiento, deberá vincularlo a través de la pestaña Bienes del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de la información registrada se lanzará:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber solicitud de moratoria de posesión se iniciará el trámite para tal efecto.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien con ocupantes, se lanzará el trámite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien sin ocupantes, se lanzará la tarea "Registrar posesión"</li><li style="margin-bottom: 10px; margin-left: 35px;">En el caso de que el bien no esté en ninguna de las situaciones expuestas y no haya una posible posesión, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</li></ul></div>',null,null,null,null,'0','DD')
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