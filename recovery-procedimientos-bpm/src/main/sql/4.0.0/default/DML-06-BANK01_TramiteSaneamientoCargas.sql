/*
--##########################################
--## Author: Oscar Dorado
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite Saneamiento de Cargas (P415)
--## INSTRUCCIONES:  Tramite Saneamiento de cargas (P415)
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
      
      T_TIPO_TPO('P415','T. de saneamiento de cargas','Trámite de saneamiento de cargas',null,'tramiteSaneamientoCargas','0','DD','0','TR',null,null,'8','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    
      T_TIPO_TAP('P415','P415_LiquidarCargas',null,null,null,null,null,'0','Liquidar las cargas','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'101',null,null,null),
      T_TIPO_TAP('P415','P415_RegInsCancelacionCargasEconomicas',null,'comprobarEstadoCargasPropuesta() ? ''null'' : ''Todas las cargas deben ser informadas en estado cancelada o rechazada''',null,null,null,'0','Registrar inscripción cancelación de cargas económicas','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'101',null,null,null),
      T_TIPO_TAP('P415','P415_RegInsCancelacionCargasReg',null,'comprobarEstadoCargasCancelacion() ? (comprobarExisteDocumentoEDCINR() ? null : ''Es necesario adjuntar el documento escritura o documento cancelación inscrito y nota registral'') : ''El estado de todas las cargas registrales debe ser estado cancelada''',null,null,null,'0','Registrar inscripción cancelación de cargas registrales','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'101',null,null,null),
      T_TIPO_TAP('P415','P415_RegInsCancelacionCargasRegEco',null,null,null,null,null,'0','Registrar inscripción cancelación de cargas registrales','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'101',null,null,null),
      T_TIPO_TAP('P415','P415_RegistrarPresentacionInscripcion',null,null,null,null,null,'0','Registrar presentación inscripción','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'101',null,null,null),
      T_TIPO_TAP('P415','P415_RegistrarPresentacionInscripcionEco',null,null,null,null,null,'0','Registrar presentación inscripción','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'101',null,null,null),
      T_TIPO_TAP('P415','P415_RevisarEstadoCargas',null,'comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienInscrito() ? ''null'' : ''Para cada una de las cargas, debe especificar el tipo y estado.''): ''Debe tener un bien asociado al procedimiento''',null,'''ambos''',null,'0','Revisar el estado de las cargas','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'101',null,null,null),
      T_TIPO_TAP('P415','P415_PropuestaCancelacionCargas',null,'comprobarExisteDocumentoPCC() ? null : ''Es necesario adjuntar el documento propuesta de cancelación de las cargas''',null,null,null,'1','Tramitar propuesta cancelación de cargas','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'103',null,null,null),
      T_TIPO_TAP('P415','P415_RevisarPropuestaCancelacionCargas',null,null,null,null,null,'1','Revisar propuesta de cancelación de cargas','0','dd','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'103',null,null,null)
    
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
    
        T_TIPO_PLAZAS(null,null,'P415_RegistrarPresentacionInscripcion','damePlazo(valores[''P415_RevisarEstadoCargas''][''fechaCargas''])+30*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P415_RegInsCancelacionCargasReg','damePlazo(valores[''P415_RegistrarPresentacionInscripcion''][''fechaPresentacion''])+30*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P415_PropuestaCancelacionCargas','damePlazo(valores[''P415_RevisarEstadoCargas''][''fechaCargas''])+15*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P415_RevisarPropuestaCancelacionCargas','damePlazo(valores[''P415_PropuestaCancelacionCargas''][''fechaPropuesta''])+15*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P415_RevisarEstadoCargas','5*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P415_LiquidarCargas','damePlazo(valores[''P415_RevisarPropuestaCancelacionCargas''][''fechaRevisar''])+15*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P415_RegInsCancelacionCargasEconomicas','damePlazo(valores[''P415_LiquidarCargas''][''fechaCancelacion''])+15*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P415_RegistrarPresentacionInscripcionEco','damePlazo(valores[''P415_RegInsCancelacionCargasEconomicas''][''fechaInsEco''])+30*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P415_RegInsCancelacionCargasRegEco','damePlazo(valores[''P415_RegistrarPresentacionInscripcion''][''fechaPresentacion''])+30*24*60*60*1000L','0','0','DD')
    
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    
        T_TIPO_TFI('P415_RevisarEstadoCargas','1','date','fechaCargas','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_RevisarEstadoCargas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegistrarPresentacionInscripcion','0','label','titulo','	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá consignar la fecha en que haya presentado la cancelación para la inscripción de todas las cargas registrales no económicas que hayan quedado marcadas en la tarea anterior.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Registrar cancelación de cargas".</p></div>	 ',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegistrarPresentacionInscripcion','1','date','fechaPresentacion','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_RegistrarPresentacionInscripcion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasReg','1','date','fechaInscripcion','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasReg','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_PropuestaCancelacionCargas','1','date','fechaPropuesta','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_PropuestaCancelacionCargas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RevisarPropuestaCancelacionCargas','1','date','fechaRevisar','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_RevisarPropuestaCancelacionCargas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_LiquidarCargas','1','date','fechaLiquidacion','Fecha liquidación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_LiquidarCargas','2','date','fechaRecepcion','Fecha recepción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_LiquidarCargas','3','date','fechaCancelacion','Fecha cancelación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_LiquidarCargas','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasEconomicas','1','date','fechaInsEco','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasEconomicas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegistrarPresentacionInscripcionEco','0','label','titulo','Registrar presentación inscripción',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegistrarPresentacionInscripcionEco','1','date','fechaPresentacion','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_RegistrarPresentacionInscripcionEco','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasRegEco','0','label','titulo','	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien afecto y marcar en las cargas registrales que haya procedido a su cancelación dicha situación en el campo estado de la carga. Una vez hecho esto deberá de consignar en esta tarea la fecha de inscripción de la cancelación de las cargas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Recuerde que en caso de haber cancelado alguna carga deberá de enviar al archivo la escritura de cancelación inscrita de la misma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla se lanzará un atarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>	 ',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasRegEco','1','date','fechaInsReg','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasRegEco','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RevisarEstadoCargas','0','label','titulo','	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá de revisar las cargas anteriores y posteriores registradas en el bien vinculado al procedimiento. En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento. Para cada carga deberá indicar si es de tipo Registral, si es de tipo Económico  y en caso de no existir cargas indicarlo expresamente en el campo destinado a tal efecto. En cualquier cado deberá indicar en la ficha de cargas del bien la fecha en que haya realizado la revisión de las mismas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá indicar la fecha en que se le haya entregado el avalúo de cargas..</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y dependiendo de como hayan quedado las cargas del bien adjudicado se podrán iniciar las siguientes tareas: 
          En caso de haber alguna carga registral y no económica se lanzará la tarea "Registrar presentación de inscripción". 
          En caso de haber alguna carga económica se lanzará la tarea "Tramitar propuesta de cancelación de cargas". 
          En caso de haber quedado el bien en situación "Sin cargas" se lanzará una tarea de tipo decisión por la cual deberá de proponer a la entidad la próxima actuación a realizar. 
        </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; "> 
        En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Señalamiento de subasta" a realizar por el letrado.</p></div>	 ',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasReg','0','label','titulo','	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien afecto y marcar en las cargas registrales que haya procedido a su cancelación dicha situación en el campo estado de la carga. Una vez hecho esto deberá de consignar en esta tarea la fecha de inscripción de la cancelación de las cargas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Recuerde que en caso de haber cancelado alguna carga deberá de enviar al archivo la escritura de cancelación inscrita de la misma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla se lanzará un atarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>	 ',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_PropuestaCancelacionCargas','0','label','titulo','	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá adjuntar al procedimiento el documento con  la propuesta de cancelación de cargas según el formato establecido por la entidad. Desde la pestaña "Cargas" del bien asociado a este trámite, puede generar la propuesta de cancelación de cargas en formato Word, de forma que en caso de ser necesario pueda modificar el documento antes de adjuntarlo al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en que de por concluida la propuesta de cancelación de cargas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Revisar propuesta de cancelación de cargas".</p></div>	 ',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RevisarPropuestaCancelacionCargas','0','label','titulo','	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que se han adjuntado al procedimiento la propuesta de cancelación de cargas económicas, para dar por finalizada esta tarea deberá revisar dicha propuesta e informar de la fecha en que queda aprobada. En caso de necesitar comunicarse con el usuario responsable de la propuesta, recuerde que dispone de la opción de crear anotaciones a través de Recovery.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Liquidar las cargas".</p></div>	 ',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_LiquidarCargas','0','label','titulo','	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por finalizada esta tarea deberá de solicitar a Administración el importe total aprobado para cancelar el total de las cargas registradas del bien asociado y consignar la fecha de solicitud en el campo Fecha solicitud importe. En el campo Fecha recepción importe deberá consignar la fecha en que haya recibido de Administración el importe solicitado. Por último, en el campo "Fecha cancelación de las cargas" consigne la fecha en que haya procedido a la liquidación del total de las cargas aprobadas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Registrar inscripción de las cargas".</p></div>	 ',null,null,null,null,'0','DD'),
        T_TIPO_TFI('P415_RegInsCancelacionCargasEconomicas','0','label','titulo','	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien asociado al procedimiento y marcar en las cargas económicas  el estado en que haya quedado cada una ya sea cancelada o rechazada. Una vez hecho esto deberá de consignar la fecha de inscripción de la cancelación de las cargas, en caso de haberse producido esta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla en caso de que las cargas económicas también sean registrales se lanzará la tarea "Registrar presentación de inscripción", en caso de no haberlas se lanzará una tarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>	 ',null,null,null,null,'0','DD')
    
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TPO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Ya existe el procedimiento '''|| TRIM(V_TMP_TIPO_TPO(1)) ||'''');
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
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||'''  and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''');
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
        -- Comprobamos el dato
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
        -- Comporbamos el dato
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
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
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