/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite Fase Liquidación
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
      T_TIPO_TPO('H033',  'T. fase de liquidación', 'T. fase de liquidación', '', 'haya_tramiteFaseLiquidacion', '0',  'DD', '0',  'CO', '', '', '1',  'MEJTipoProcedimiento', '1',  '0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H033',  'H033_separacionAdministradores', '', '', '', 'valores[''H033_separacionAdministradores''][''comboSeparacion''] == DDSiNo.SI ? ''SI'' : ''NO''',  '', '0',  'Tomar decisión sobre separación de los administradores concursales', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_registrarResolucion', '', '', '', '', '', '0',  'Registrar resolución', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_regResolucionAprovacion', '', '', '', '', '', '0',  'Registrar resolución de aprobación de liquidación',  '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_regInformeTrimestral2', '', 'comprobarExisteDocumentoINFTC() ? null : ''Es necesario adjuntar el documento Informe Trimestral de Cierre.''', '', 'valores[''H033_regInformeTrimestral2''][''comboCierre''] == DDSiNo.SI ? ''SI'' : ''NO''',  '', '0',  'Registrar inf. trimestral administración concursal', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_regInformeTrimestral1', '', '', '', '', '', '0',  'Registrar inf. trimestral administración concursal', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_presentarSeparacion', '', '', '', '', '', '0',  'Presentar solicitud separación de los administradores',  '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_presentarObs',  '', '', '', '', '', '0',  'Presentar observaciones al plan de liquidación', '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_BPMTramiteElevarPropSarebLitigios', '', '', '', '', 'H012',  '0',  'Elevar propuesta Sareb Litigios',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_decidirPresentarObs', '', '', '', 'valores[''H033_decidirPresentarObs''][''comboObservaciones''] == DDSiNo.SI ? ''SI'' : ''NO''', '', '1',  'Decisión sobre presentación de observaciones al plan liquidación', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '40', '', '', ''),
      T_TIPO_TAP('H033',  'H033_aperturaFase',  '', '', '', '', '', '0',  'Registrar resolución de apertura fase liquidación',  '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H033',  'H033_InformeLiquidacion',  '', '', '', '', '', '0',  'Registrar Plan de liquidación de la Administración Concursal', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', '')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS('', '', 'H033_aperturaFase',  '5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_InformeLiquidacion',  'damePlazo(valores[''H033_aperturaFase''][''fecha'']) + 15*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_decidirPresentarObs', 'damePlazo(valores[''H033_InformeLiquidacion''][''fechaNotificacion'']) + 3*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_presentarObs',  'damePlazo(valores[''H033_InformeLiquidacion''][''fechaNotificacion'']) + 15*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_BPMTramiteElevarPropSarebLitigios', '300*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_regResolucionAprovacion', 'damePlazo(valores[''H033_InformeLiquidacion''][''fechaNotificacion'']) + 45*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_regInformeTrimestral1', 'damePlazo(valores[''H033_InformeLiquidacion''][''fechaNotificacion'']) + 90*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_regInformeTrimestral2', 'damePlazo(valores[''H033_regInformeTrimestral1''][''fecha'']) + 90*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_separacionAdministradores', '5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_presentarSeparacion', '10*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H033_registrarResolucion', '10*24*60*60*1000L',  '0',  '0',  'DD')
    ); 
    --damePlazo(valores[''H033_regResolucionAprovacion''][''fecha''])
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('H033_aperturaFase', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de consignar la fecha de Resoluci&oacute;n que hubiere reca&iacute;do.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Registrar plan de liquidaci&oacute;n de la Adm. Concursal&quot;.</p><p style="margin-bottom: 10px">En el campo "Situación concursal" deberá indicar la situación en la que queda el concurso una vez completada esta tarea.</div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_aperturaFase', '1',  'date', 'fecha',  'Fecha resolución', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_aperturaFase', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_InformeLiquidacion', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En esta tarea consignar tanto la fecha adjunta al informe de liquidación de la administración concursal, como la fecha de notificación del propio informe.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones deberá consignar un pequeño resumen sobre las tareas de liquidación contempladas en el plan junto con su valoración acerca de si las mismas pudieran ser perjudiciales para los intereses de la Entidad y proponiendo en que aspectos considera que deberían formularse observaciones así como cualquier aspecto relevante que le interese quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Si únicamente tenemos créditos ordinarios, deberá hacerse esta mención.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será "Decisión sobre presentación de observaciones al plan liquidación", que será cumplimentada por el Supervisor asignado a la actuación.</p></div>', '', '', '', '', '6',  'DD'),
      T_TIPO_TFI('H033_InformeLiquidacion', '1',  'date', 'fechaInforme', 'Fecha de informe', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_InformeLiquidacion', '2',  'date', 'fechaNotificacion',  'Fecha notificación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_InformeLiquidacion', '3',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_decidirPresentarObs',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá indicar si la entidad quiere presentar observaciones al plan de liquidación o no.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será si se ha indicado que sí "Presentación de observaciones al plan de liquidación", en caso contrario "Registrar resolución de aprobación de liquidación"</p></div>', '', '', '', '', '1',  'DD'),
      T_TIPO_TFI('H033_decidirPresentarObs',  '1',  'combo',  'comboObservaciones', 'Presentar observaciones',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H033_decidirPresentarObs',  '2',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_presentarObs', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar la fecha de presentación de las observaciones al plan de liquidac&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Registrar resoluci&oacute;n de aprobaci&oacute;n de liquidaci&oacute;n&quot;.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_presentarObs', '1',  'date', 'fecha',  'Fecha presentación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_presentarObs', '2',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_BPMTramiteElevarPropSarebLitigios',  '0',  'label',  'titulo', 'Se inicia el trámite elevar propuesta Sareb Litigios', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regResolucionAprovacion',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En esta pantalla se deberá de consignar la fecha de notificación de la resolución que decide sobre la aprobación de liquidación, con independencia de si se ha aprobado o no, así como consignar en el campo observaciones si el plan ha sido aprobado con su redacción inicial o si por el contrario se han introducido modificaciones.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será "Registrar decisión seguimiento fase de liquidación".</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regResolucionAprovacion',  '1',  'date', 'fecha',  'Fecha resolución', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regResolucionAprovacion',  '2',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regInformeTrimestral1',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea deber&aacute; consignar la fecha correspondiente al primer informe trimestral de la administraci&oacute;n concursal.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Registrar inf. trimestral administraci&oacute;n concursal&quot;.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regInformeTrimestral1',  '1',  'date', 'fecha',  'Fecha informe',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regInformeTrimestral1',  '2',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regInformeTrimestral2',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar la fecha correspondiente al informe trimestral de la administraci&oacute;n concursal.</p><p style="margin-bottom: 10px">En el campo Informe cierre de cuenta, debe indicar si el informe recibido corresponde al de cierre o no.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si el informe es de cierre se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si el informe no es de cierre la siguiente tarea ser&aacute; &quot;Registrar inf. trimestral administraci&oacute;n concursal&quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si adem&aacute;s de no ser el informe de cierre, ha pasado mas de 1 año desde que se comenz&oacute; el seguimiento, se iniciaran dos tareas &quot;Registrar inf. trimestral administraci&oacute;n concursal&quot; y &quot;Separaci&oacute;n de los administradores&quot;.</li></ul></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regInformeTrimestral2',  '1',  'date', 'fecha',  'Fecha informe',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_regInformeTrimestral2',  '2',  'combo',  'comboCierre',  'Informe cierre de cuenta', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H033_regInformeTrimestral2',  '3',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_separacionAdministradores',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea indicar si se tiene intenci&oacute;n de proceder a una separaci&oacute;n de los administradores concursales.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, si ha indicado intenci&oacute;n de separarse &quot;Presentar solicitud separaci&oacute;n de los administradores&quot; en caso contrario se termina esta parte del tr&aacute;mite.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_separacionAdministradores',  '1',  'combo',  'comboSeparacion',  'Separación de los administradores',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H033_separacionAdministradores',  '2',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_presentarSeparacion',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar la fecha de presentaci&oacute;n de la solicitud de separación de los administradores concursales.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute, &quot;Registrar resoluci&oacuten&quot;.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_presentarSeparacion',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_presentarSeparacion',  '2',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H033_registrarResolucion',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se indicar&aacute; si el resultado de la resoluci&oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a traves del bot&oacute;n &quot;Comunicaci&oacute;n&quot;. Una vez reciba la aceptación del supervisor deber&aacute; gestionar el recurso por medio de la pestaña &quot;Recursos&quot;.</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pestaña &quot;Recursos&quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H033_registrarResolucion',  '1',  'combo',  'comboResultado', 'Resultado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDFavorable',  '0',  'DD'),
      T_TIPO_TFI('H033_registrarResolucion',  '2',  'textarea', 'observaciones',  'Observaciones',  '', 'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD')
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