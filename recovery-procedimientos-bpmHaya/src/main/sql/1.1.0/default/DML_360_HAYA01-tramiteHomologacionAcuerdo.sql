/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite Homologación de Acuerdo
--## INSTRUCCIONES:  Verificar esquemas correctos en el Declare
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
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

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('H027',  'T. Homologación de acuerdo',  'Trámite de homologación de acuerdo', '', 'haya_tramiteHomologacionAcuerdo', '0',  'DD', '0',  'CO', '', '', '1',  'MEJTipoProcedimiento', '1',  '0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H027',  'H027_RegistrarResultadoAcuerdo', '', '', '', 'valores[''H027_RegistrarResultadoAcuerdo''][''resultadoAcuerdo''] == DDSiNo.SI ? ''SI'' : ''NO''', '', '0',  'Registrar resultado del acuerdo',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_RegistrarResHomologacionJudicial',  '', '', '', 'valores[''H027_RegistrarResHomologacionJudicial''][''impugnacionEntidad''] == DDSiNo.SI ? ''SI'' : ''NO''',  '', '0',  'Registrar resolución homologación judicial', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_RegistrarPublicacionSolArticulo', '', '', '', '', '', '0',  'Registrar solicitud del artículo 5Bis',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '0',  'EXTTareaProcedimiento',  '0',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_RegistrarPropuestaAcuerdo', '', '', '', '', '', '0',  'Registrar propuesta de acuerdo', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_RegistrarEntradaEnVigor', '', '', '', '', '', '0',  'Registrar entrada en vigor del acuerdo', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_RegistrarAperturaNegociaciones',  '', '', '', '', '', '0',  'Registrar apertura de negociaciones',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_LecturaAceptacionInstrucciones',  '', '', '', '', '', '0',  'Conformar aceptación del acuerdo', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_BPMTramiteElevarPropSarebLitigios', '', '', '', '', 'H012',  '0',  'Elevar propuesta Sareb Litigios',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_BPMTramiteDemandaIncidental', '', '', '', '', 'H023',  '0',  'Iniciar trámite de demanda incidental',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_AceptarPropuestaAcuerdo', '', '', '', 'valores[''H027_AceptarPropuestaAcuerdo''][''aceptarPropuestaAcuerdo''] == DDSiNo.SI ? ''SI'' : ''NO''',  '', '0',  'Decidir sobre propuesta de acuerdo', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H027',  'H027_ConfirmarContabilidad',  '', '', '', '', '', '0',  'Confirmar contabilidad del acuerdo', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', '')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS('', '', 'H027_RegistrarPublicacionSolArticulo', '5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_RegistrarAperturaNegociaciones',  'damePlazo(valores[''H027_RegistrarPublicacionSolArticulo''][''fecha'']) + 5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_RegistrarPropuestaAcuerdo', 'damePlazo(valores[''H027_RegistrarAperturaNegociaciones''][''fecha'']) + 60*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_AceptarPropuestaAcuerdo', 'damePlazo(valores[''H027_RegistrarPropuestaAcuerdo''][''fecha'']) + 10*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_LecturaAceptacionInstrucciones',  'damePlazo(valores[''H027_AceptarPropuestaAcuerdo''][''fecha'']) + 2*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_RegistrarResultadoAcuerdo', 'damePlazo(valores[''H027_LecturaAceptacionInstrucciones''][''fecha'']) + 2*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_RegistrarResHomologacionJudicial',  'damePlazo(valores[''H027_RegistrarPropuestaAcuerdo''][''fecha'']) - 15*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_RegistrarEntradaEnVigor', 'damePlazo(valores[''H027_RegistrarResHomologacionJudicial''][''fecha'']) + 1*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_ConfirmarContabilidad', 'damePlazo(valores[''H027_RegistrarEntradaEnVigor''][''fecha'']) + 5*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_BPMTramiteElevarPropSarebLitigios', '300*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H027_BPMTramiteDemandaIncidental', '300*24*60*60*1000L', '0',  '0',  'DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('H027_RegistrarPublicacionSolArticulo',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; consignar la fecha en que se hayan iniciado las negociaciones con el concursado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; “Registrar apertura de negociaciones” a realizar por el letrado.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarPublicacionSolArticulo',  '1',  'date', 'fecha',  'Fecha publicación de solicitud', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarPublicacionSolArticulo',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarAperturaNegociaciones', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; registrar un acuerdo a trav&eacute;s de la pestaña Acuerdos de la ficha del Asunto correspondiente, en caso de no iniciar ning&uacute;n acuerdo deber&aacute; consignar dicha situaci&oacute;n en el campo Acuerdo. En el campo Intereses entidad deber&aacute; de consignar si el acuerdo planteado es favorable o no para los intereses de la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; “Registrar propuesta de acuerdo” a realizar por el letrado.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarAperturaNegociaciones', '1',  'date', 'fecha',  'Fecha apertura negociaciones', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarAperturaNegociaciones', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarPropuestaAcuerdo',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla, como supervisor del concurso, deber&aacute; validar el acuerdo propuesto por el letrado o en su defecto la no propuesta de acuerdo.  En el campo Fecha deber&aacute; informar la fecha en que dar por revisado la decisi&oacute;n propuesta por el letrado, en el campo Resultado deber&aacute; indicar la conformidad o no con la propuesta realizada por el letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;, en caso de haber aceptado la propuesta del letrado “Lectura y aceptaci&oacute;n de instrucciones de la entidad”, y en caso contrario se crear&aacute; la tarea “Registrar propuesta de acuerdo” a realizar por el letrado.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarPropuestaAcuerdo',  '1',  'date', 'fecha',  'Fecha registro de propuesta de acuerdo', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarPropuestaAcuerdo',  '2',  'combo',  'acuerdoPropuesto', 'Validar acuerdo propuesto',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarPropuestaAcuerdo',  '3',  'combo',  'interesesEntidad', 'Intereses de la entidad',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDFavorable',  '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarPropuestaAcuerdo',  '4',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_AceptarPropuestaAcuerdo',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla, como supervisor del concurso, deber&aacute; validar el acuerdo propuesto por el letrado o en su defecto la no propuesta de acuerdo.  En el campo Fecha deber&aacute; informar la fecha en que dar por revisado la decisi&oacute;n propuesta por el letrado, en el campo Resultado deber&aacute; indicar la conformidad o no con la propuesta realizada por el letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute;, en caso de haber aceptado la propuesta del letrado “Lectura y aceptaci&oacute;n de instrucciones de la entidad”, y en caso contrario se crear&aacute; la tarea “Registrar propuesta de acuerdo” a realizar por el letrado.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_AceptarPropuestaAcuerdo',  '1',  'date', 'fecha',  'Fecha decisión de propuesta de acuerdo', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_AceptarPropuestaAcuerdo',  '2',  'combo',  'interesesEntidad', 'Intereses de la entidad',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'valores[''H027_RegistrarPropuestaAcuerdo''][''interesesEntidad'']',  'DDFavorable',  '0',  'DD'),
      T_TIPO_TFI('H027_AceptarPropuestaAcuerdo',  '3',  'combo',  'aceptarPropuestaAcuerdo',  'Conforme con la propuesta de acuerdo', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H027_AceptarPropuestaAcuerdo',  '4',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_LecturaAceptacionInstrucciones', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que la entidad ya ha tomado una postura frente al acuerdo propuesto, a trav&eacute;s de esta pantalla deber&aacute; indicar la conformidad con dicha postura. En el campo Fecha deber&aacute; consignar la fecha en que de por aceptadas las instrucciones dictadas por la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, en caso de no haber acuerdo se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad. En caso de s&iacute; haber habido acuerdo, sea favorable o no se crear&aacute; la tarea “Registrar resoluci&oacute;n homologaci&oacute;n judicial”.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_LecturaAceptacionInstrucciones', '1',  'date', 'fecha',  'Fecha de acuerdo de la entidad', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_LecturaAceptacionInstrucciones', '2',  'combo',  'resultadoAcuerdo', 'Entidad conforme con el acuerdo',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H027_LecturaAceptacionInstrucciones', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResultadoAcuerdo',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; indicar en el campo “Acuerdo alcanzado” si efectivamente se ha llegado al acuerdo propuesto o no. En el campo “Fecha” deber&aacute; consignar la fecha en que se haya resuelto el acuerdo.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">En caso haberse producido el acuerdo la siguiente tarea ser&aacute; “Registrar resoluci&oacute;n homologaci&oacute;n judicial”, en caso contrario se crear&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResultadoAcuerdo',  '1',  'combo',  'resultadoAcuerdo', 'Acuerdo alcanzado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResultadoAcuerdo',  '2',  'date', 'fecha',  'Fecha de registro de resultado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResultadoAcuerdo',  '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResHomologacionJudicial', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar de la fecha en que se nos haya notificado la resoluci&oacute;n judicial respecto al acuerdo que se ha presentado.</p><p style="margin-bottom: 10px">En el campo Impugnaci&oacute;n entidad deber&aacute; indicar si es necesario impugnar la resoluci&oacute;n o no.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. En caso de haber impugnaci&oacute;n por parte de la entidad, se iniciar&aacute; el tr&aacute;mite de demanda incidental, en caso contrario se crear&aacute; la tarea “Registrar entrada en vigor”.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResHomologacionJudicial', '1',  'date', 'fecha',  'Fecha notificación de resolución judicial',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResHomologacionJudicial', '2',  'combo',  'interesesEntidad', 'Intereses de la entidad',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'valores[''H027_RegistrarPropuestaAcuerdo''][''interesesEntidad'']',  'DDFavorable',  '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResHomologacionJudicial', '3',  'combo',  'impugnacionEntidad', 'La entidad impugna la resolución', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarResHomologacionJudicial', '4',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarEntradaEnVigor',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla se deber&aacute; de consignar la fecha en que entra en vigor el acuerdo aprobado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se crear&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarEntradaEnVigor',  '1',  'date', 'fecha',  'Fecha entrada en vigor del acuerdo', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_RegistrarEntradaEnVigor',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_ConfirmarContabilidad',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; usted indicar la fecha en la que se ha contabilizado el acuerdo.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_ConfirmarContabilidad',  '1',  'date', 'fecha',  'Fecha entrada en vigor del acuerdo', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H027_ConfirmarContabilidad',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_BPMTramiteElevarPropSarebLitigios',  '0',  'label',  'titulo', 'Se inicia el trámite elevar propuesta Sareb Litigios', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H027_BPMTramiteDemandaIncidental',  '0',  'label',  'titulo', 'Se inicia el trámite de demanda incidental', '', '', '', '', '0',  'DD')
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
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,DD_TSUP_ID,TAP_EVITAR_REORG,TAP_BUCLE_BPM) ' ||
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
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(21)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') ||''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
                    
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