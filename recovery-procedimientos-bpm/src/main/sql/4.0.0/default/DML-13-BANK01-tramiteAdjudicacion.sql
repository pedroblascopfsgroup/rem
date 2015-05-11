/*
--##########################################
--## Author: Roberto
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite Adjudicación (P413)
--## INSTRUCCIONES:  Tramite Adjudicación (P413)
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
      
      T_TIPO_TPO('P413','Trámite de Adjudicación','Trámite de Adjudicación',null,'tramiteAdjudicacionV4','0','DD','0','TR',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('P413','P413_BPMTramiteDePosesion',null,null,null,null,'P416','0','Llamada al BPM de Trámite de Trámite de Posesión','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_BPMTramiteNotificacion',null,null,null,null,'P400','0','Llamada al BPM de Trámite de Trámite de Notificación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_BPMTramiteSaneamientoCargas',null,null,null,null,'P415','0','Llamada al BPM de Trámite de Trámite de Saneamiento de Cargas','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_BPMTramiteSubsanacionEmbargo1',null,null,null,null,'P414','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_BPMTramiteSubsanacionEmbargo2',null,null,null,null,'P414','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_BPMTramiteSubsanacionEmbargo3',null,null,null,null,'P414','0','Llamada al BPM de Trámite de Subsanación de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_ConfirmarTestimonio',null,null,' comprobarGestoriaAsignadaPrc() ? comprobarAdjuntoDecretoFirmeAdjudicacion() ? null : ''Debe adjuntar el Decreto Firme de Adjudicacion.'' : ''Debe asignar la Gestoría encargada de tramitar la adjudicación.'' ','( valores[''P413_ConfirmarTestimonio''][''comboSubsanacion''] == DDSiNo.SI ? ''SI'':''NO'')',null,'0','Confirmar el Testimonio','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_RegistrarEntregaTitulo',null,null,null,null,null,'0','Registrar entrega del título','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_RegistrarInscripcionDelTitulo',null,null,' comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes() ? comprobarAdjuntoDocumentoTestimonioInscritoEnRegistro() ? null : ''Debe adjuntar el Documento de Testimonio inscrito en el Registro.'' : ''Debe asignar la Gestoría encargada del saneamiento de cargas del bien.'' ','( valores[''P413_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''PEN'' ? ''SI'':''NO'')',null,'0','Registrar Inscripción del Título','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_RegistrarPresentacionEnHacienda',null,null,' comprobarAdjuntoDocumentoLiquidacionImpuestos() ? null : ''Debe adjuntar la copia escaneada del Documento de Liquidación de Impuestos.'' ',null,null,'0','Registrar presentación en Hacienda','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_RegistrarPresentacionEnRegistro',null,null,null,null,null,'0','Registrar presentación en Registro','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_SolicitudDecretoAdjudicacion',null,null,'comprobarBienAsociadoPrc() ? null : ''El bien debe estar asociado al trámite, asócielo desde la pestaña de Bienes del procedimiento para poder finalizar esta tarea.''',null,null,'0','Solicitud de Decreto de Adjudicación','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_SolicitudTestimonioDecretoAdjudicacion',null,null,null,null,null,'0','Solicitud de Testimonio del Decreto de Adjudicación','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_notificacionDecretoAdjudicacionAEntidad',null,null,null,'( valores[''P413_notificacionDecretoAdjudicacionAEntidad''][''comboSubsanacion''] == DDSiNo.SI ? ''SI'':''NO'')',null,'0','Notificación del Decreto de Adjudicación a Entidad','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null),
      T_TIPO_TAP('P413','P413_notificacionDecretoAdjudicacionAlContrario',null,null,null,'( valores[''P413_notificacionDecretoAdjudicacionAlContrario''][''comboNotificacion''] == DDSiNo.SI ? ''SI'':''NO'')',null,'0','Notificación del Decreto de Adjudicación al Contrario','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'39',null,null,null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
        T_TIPO_PLAZAS(null,null,'P413_SolicitudDecretoAdjudicacion','valores[''P401_RegistrarActaSubasta''] != null && valores[''P401_RegistrarActaSubasta''][''fecha''] != null ? damePlazo(valores[''P401_RegistrarActaSubasta''][''fecha'']) + 20*24*60*60*1000L:5*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_notificacionDecretoAdjudicacionAEntidad','valores[''P401_RegistrarActaSubasta''] != null && valores[''P401_RegistrarActaSubasta''][''fecha''] != null ? damePlazo(valores[''P401_RegistrarActaSubasta''][''fecha'']) + 30*24*60*60*1000L:30*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_notificacionDecretoAdjudicacionAlContrario','damePlazo(valores[''P413_notificacionDecretoAdjudicacionAEntidad''][''fecha''])+30*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_SolicitudTestimonioDecretoAdjudicacion','damePlazo(valores[''P413_notificacionDecretoAdjudicacionAlContrario''][''fecha''])+20*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_ConfirmarTestimonio','damePlazo(valores[''P413_SolicitudTestimonioDecretoAdjudicacion''][''fecha''])+30*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_RegistrarEntregaTitulo','damePlazo(valores[''P413_ConfirmarTestimonio''][''fechaTestimonio''])+7*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_RegistrarPresentacionEnHacienda','damePlazo(valores[''P413_ConfirmarTestimonio''][''fechaTestimonio''])+30*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_RegistrarPresentacionEnRegistro','valores[''P414_EntregarNuevoDecreto''] != null ? damePlazo(valores[''P414_EntregarNuevoDecreto''][''fechaEnvio''])+10*24*60*60*1000L : damePlazo(valores[''P413_RegistrarPresentacionEnHacienda''][''fechaPresentacion''])+10*24*60*60*1000L ','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_RegistrarInscripcionDelTitulo','damePlazo(valores[''P413_RegistrarPresentacionEnRegistro''][''fechaPresentacion''])+60*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_BPMTramiteSubsanacionEmbargo1','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_BPMTramiteNotificacion','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_BPMTramiteDePosesion','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_BPMTramiteSaneamientoCargas','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_BPMTramiteSubsanacionEmbargo2','300*24*60*60*1000L','0','0','DD'),
        T_TIPO_PLAZAS(null,null,'P413_BPMTramiteSubsanacionEmbargo3','300*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    
      T_TIPO_TFI('P413_ConfirmarTestimonio','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de acceder a la pestaña Gestores del asunto correspondiente y asignar el tipo de gestor "Gestoría adjudicación" según el protocolo que tiene establecido la entidad.</p><p>A través de esta pantalla se ha de marcar la fecha que el Juzgado hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p>Una vez confirmado con el procurador el envío a la gestoría, se deberá consignar dicha fecha en el campo "Fecha envío a Gestoría".</p><p>Con el objeto de evitar calificaciones desfavorables y subsanaciones posteriores que retrasan la inscripción deberá:</p><p>- Obtenido el testimonio, se revisará la fecha de expedición para liquidación de impuestos en plazo, según normativa de CCAA. La verificación de la fecha del título es necesaria y fundamental para que la gestoría pueda realizar la liquidación en plazo.</p><p>- Adicionalmente se revisarán el contenido fundamental y de forma, para evitar subsanaciones posteriores que retrasen la inscripción. Contenido básico para revisar en testimonio decreto de adjudicación y mandamientos:<br>&nbsp;&nbsp;&nbsp;- Datos procesales básicos: (No autos, tipo de procedimiento, cantidad reclamada)<br>&nbsp;&nbsp;&nbsp;- Datos de la Entidad demandante (nombre CIF, domicilio) y cesionaria (en caso de cesión de remate a Fondos de titulización)<br>&nbsp;&nbsp;&nbsp;- Datos de los demandados y titulares registrales.<br>
&nbsp;&nbsp;&nbsp;- Importe de adjudicación y cesión de remate (en su caso).<br>&nbsp;&nbsp;&nbsp;- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores).<br>&nbsp;&nbsp;&nbsp;- Descripción y datos registrales completos de la finca adjudicada.<br>&nbsp;&nbsp;&nbsp;- Declaración en el auto de la firmeza de la resolución<br></p><p>Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p>Para dar por terminada esta tarea deberá de adjuntar al procedimiento correspondiente una copia escaneada del decreto firme de adjudicación.</p>
<p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación el trámite de subsanación de adjudicación, y en caso contrario se lanzará por un lado la tarea "Registrar entrega del título" y por otro el trámite de posesión.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_ConfirmarTestimonio','1','date','fechaTestimonio','Fecha Testimonio','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_ConfirmarTestimonio','2','combo','comboSubsanacion','Requiere Subsanación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('P413_ConfirmarTestimonio','3','date','fechaEnvioGestoria','Fecha Envío a Gestoría','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_ConfirmarTestimonio','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarEntregaTitulo','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de informar de la fecha en que recibe la información sobre los documentos asignados que se le han enviado.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá:</p><p>- Liquidar impuestos en plazo según CCAA. En caso de personas jurídicas existirá una consulta previa realizada sobre la posible liquidación de IVA. Esta información podrá consultarla a través de la ficha de cada uno de los bienes incluidos.</p><p>- Verificar situación ocupacional de la finca para manifestación de libertad arrendamientos de cara a inscripción (LAU).</p><p>- Redactar en su caso, certificado de Libertad de Arrendamiento (por poder de la Entidad), para presentación en el registro junto con el testimonio y los mandamientos.</p><p>- Realizar notificación fehaciente a inquilinos para la inscripción (en casos de inmueble con arrendamiento reconocido)</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>
<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Registrar presentación en hacienda".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarEntregaTitulo','1','date','fechaRecepcion','Fecha de Recepción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarEntregaTitulo','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarPresentacionEnHacienda','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá presentar la liquidación del testimonio en Hacienda, una vez realizado esto deberá adjuntar al procedimiento correspondiente copia escaneada del documento de liquidación de impuestos.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Registrar presentación en el registro".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarPresentacionEnHacienda','1','date','fechaPresentacion','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarPresentacionEnHacienda','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarPresentacionEnRegistro','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá consignar la fecha de presentación en el registro, ya sea del testimonio decreto de adjudicación original o del testimonio decreto de adjudicación una vez subsanados los errores encontrados con anterioridad.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea “Registrar inscripción del título”.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarPresentacionEnRegistro','1','date','fechaPresentacion','Fecha Presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarPresentacionEnRegistro','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarInscripcionDelTitulo','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá indicar la situación en que queda el título ya sea inscrito en el registro o pendiente de subsanación, a través de la ficha del bien correspondiente deberá de actualizar los campos: folio, libro, tomo, inscripción Xa, referencia catastral, porcentaje de propiedad, no de finca -si hubiera cambios Actualizado. Una vez actualizados estos campos deberá de marcar la fecha de actualización en la ficha del bien.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify">
<p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haberse producido una resolución desfavorable y haber marcado el bien en situación “Subsanar”, deberá informar la fecha de envío de decreto para adición y proceder a la remisión de los documentos al Procurador e informa al Letrado.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haber quedado inscrito el bien, deberá informar la fecha en que se haya producido dicha inscripción.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea y una vez obtenido el testimonio inscrito en el registro, deberá adjuntar dicho documento al procedimiento correspondiente.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación el trámite de subsanación de decreto de adjudicación a realizar por el letrado, y en caso contrario se iniciará el trámite de saneamiento de cargas para el bien afecto a este trámite.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarInscripcionDelTitulo','1','combo','comboSituacionTitulo','Título Inscrito en el Registro','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSituacionTitulo','0','DD'),
      T_TIPO_TFI('P413_RegistrarInscripcionDelTitulo','2','date','fechaInscripcion','Fecha Inscripción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarInscripcionDelTitulo','3','date','fechaEnvioDecretoAdicion','Fecha Envío Decreto Adición','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_RegistrarInscripcionDelTitulo','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_BPMTramiteSubsanacionEmbargo1','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_BPMTramiteNotificacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Notificación.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_BPMTramiteDePosesion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Posesión.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_BPMTramiteSaneamientoCargas','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Saneamiento de Cargas.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_BPMTramiteSubsanacionEmbargo2','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_BPMTramiteSubsanacionEmbargo3','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el Trámite de Subsanación de Embargo.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_SolicitudDecretoAdjudicacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que la entidad se ha adjudicado uno o más bienes en la subasta celebrada, a través de esta tarea deberá de consignar la fecha de presentación en el Juzgado del escrito de solicitud del Decreto de Adjudicación. En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento el bien que corresponda.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Notificación decreto de adjudicación a la entidad".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_SolicitudDecretoAdjudicacion','1','date','fechaSolicitud','Fecha Solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_SolicitudDecretoAdjudicacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAEntidad','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de consignar la fecha en la que se notifica por el Juzgado el Decreto de Adjudicación, la entidad adjudicataria de los bienes afectos y en el caso de ser un fondo deberá consignar el fondo que corresponda.</p><p>Deberá revisar que el Decreto es conforme a la subasta celebrada y contiene lo preceptuado para su correcta inscripción en el Registro de la Propiedad, para ello deberá revisar:</p><p>- Datos procesales básicos: (No autos, tipo de procedimiento, cantidad reclamada)</p><p>- Datos de la Entidad demandante (nombre CIF, domicilio) y cesionaria (en caso de cesión de remate a Fondos de titulización)</p><p>- Datos de los demandados y titulares registrales.</p><p>- Importe de adjudicación.</p><p>- Orden de cancelación de la nota marginal y cancelación de la carga objeto de ejecución así como cargas posteriores)</p><p>- Descripción y datos registrales completos de la finca adjudicada.</p><p>- Declaración en el auto de la firmeza de la resolución</p><p>Una vez analizados los puntos descritos, en el campo Requiere subsanación deberá indicar el resultado de dicho análisis.</p><p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se lanzará, en caso de requerir subsanación el trámite de subsanación de adjudicación, en caso contrario se lanzará la tarea "Notificación decreto adjudicación al contrario".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAEntidad','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAEntidad','2','combo','comboEntidadAdjudicataria','Entidad Adjudicataria','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDEntidadAdjudicataria','0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAEntidad','3','textarea','fondo','Fondo','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAEntidad','4','combo','comboSubsanacion','Requiere Subsanación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAEntidad','5','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAlContrario','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla se deberá informar del resultado de la notificación del decreto de adjudicación a la parte ejecutada, en caso de notificación positiva se informará de la fecha de notificación del Decreto de Adjudicación.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará, en caso de notificación negativa a la parte contraria el trámite de notificación, y en caso contrario la tarea “Solicitud de testimonio de decreto de adjudicación”.</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAlContrario','1','combo','comboNotificacion','Notificado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAlContrario','2','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAlContrario','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_SolicitudTestimonioDecretoAdjudicacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá de consignar la Fecha de solicitud del testimonio de decreto de adjudicación.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará, en caso de notificación negativa a la parte contraria el trámite de notificación, y en caso contrario la tarea "Confirmar testimonio decreto de adjudicación".</p></div>',null,null,null,null,'0','DD'),
      T_TIPO_TFI('P413_SolicitudTestimonioDecretoAdjudicacion','1','date','fecha','Fecha Solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
      T_TIPO_TFI('P413_SolicitudTestimonioDecretoAdjudicacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD')
    
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        --Comprobamos el dato
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
        -- Comprobamos el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''' ) and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_TAP(1)) ||''' and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''');
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

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
        -- Comprobamos el dato
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