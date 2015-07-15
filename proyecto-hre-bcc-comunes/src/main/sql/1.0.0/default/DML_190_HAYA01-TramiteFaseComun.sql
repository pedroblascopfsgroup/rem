/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Tramite Fase Común
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
      T_TIPO_TPO('H009',  'T. fase común Haya',  'T. fase común Haya',  '', 'tramiteFaseComunAbreviadoV4',  '0',  'DD', '0',  'CO', '', '', '1',  'MEJTipoProcedimiento', '1',  '0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H009',  'H009_ValidarAlegaciones',  'plugin/procedimientos/tramiteFaseComunAbreviado/validarAlegaciones', '', '', 'valores[''H009_ValidarAlegaciones''][''PresentaAlegacionesCombo''] == DDSiNo.SI ? ''OK'' : ''KO''',  '', '1',  'Validar alegaciones',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '800', 'SUCL', '', ''),
      T_TIPO_TAP('H009',  'H009_RevisarResultadoInfAdmon',  '', '', 'valores[''H009_RevisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ( creditosDespuesDeIACConDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACDemandaMalDefinidos'' ) : ( creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos'')',  'valores[''H009_RevisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ''SI'' : ''NO''',  '', '0',  'Revisar informe de la administración concursal', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_RevisarInsinuacionCreditos',  '', '', 'valores[''H009_RevisarInsinuacionCreditos''][''numCreditos''] == null || valores[''H009_RevisarInsinuacionCreditos''][''numCreditos''] == '''' || valores[''H009_RevisarInsinuacionCreditos''][''numCreditos''] == ''0'' ? (cuentaCreditosInsinuadosSup() != ''0'' ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : null) : (cuentaCreditosInsinuadosSup()!=valores[''H009_RevisarInsinuacionCreditos''][''numCreditos''] ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)', '', '', '1',  'Revisar insinuación de créditos',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '800', 'SUCL', '', ''),
      T_TIPO_TAP('H009',  'H009_RegistrarResolucionFaseComun',  '', '', '', 'valores[''H009_RegistrarResolucionFaseComun''][''comboLiquidacion''] == DDSiNo.SI ? ''faseLiquidacion'' : ''faseConvenio''', '', '0',  'Registrar resolución de fase común', '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_RegistrarPublicacionBOE', 'plugin/procedimientos/tramiteFaseComunAbreviado/regPublicacionBOE',  '', '', '', '', '0',  'Registrar publicación en el BOE',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_RegistrarProyectoInventario', '', '', '', 'valores[''H009_RegistrarProyectoInventario''][''comFavorable''] == DDSiNo.SI ? ''favorable'' : ''desfavorable''',  '', '0',  'Registrar proyecto de inventario', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_RegistrarInsinuacionCreditos',  '', '', 'valores[''H009_RegistrarInsinuacionCreditos''][''numCreditos''] == null || valores[''H009_RegistrarInsinuacionCreditos''][''numCreditos''] == '''' || valores[''H009_RegistrarInsinuacionCreditos''][''numCreditos''] == ''0'' ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'': (cuentaCreditosInsinuadosExt()!=valores[''H009_RegistrarInsinuacionCreditos''][''numCreditos''] ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)',  '', '', '0',  'Registrar insinuación de créditos',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_RegistrarInformeAdmonConcursal',  '', '', 'creditosDefinitivosPendientes() ? ''tareaExterna.procedimiento.tramiteFaseComun.creditosDefinitivosPendientes'': null',  '', '', '0',  'Registrar informe de la administración concursal', '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_PresentarRectificacion',  '', '', '', '', '', '0',  'Presentar rectificación',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_PresentarEscritoInsinuacion', 'plugin/procedimientos/tramiteFaseComunAbreviado/presentarEscritoInsinuacionCreditos',  '', 'creditosDefinitivosDefinidosEInsinuados() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosNoInsinuados''',  '', '', '0',  'Presentar escrito de insinuación', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_BPMTramiteFaseLiquidacion', '', '', '', '', 'H033', '0',  'Se inicia la Fase de liquidación', '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_BPMTramiteFaseConvenioV4',  '', '', '', '', 'H017', '0',  'Se inicia la Fase de convenio',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_BPMTramiteDemandaIncidental', '', '', '', '', 'H023',  '0',  'Trámite de Demanda Incidental',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_BPMTramiteAceptacionConcurso',  '', '', '', '', 'P404', '0',  'Trámite de Aceptación Concursal',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_ActualizarEstadoCreditos',  '', '', 'creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos''', '', '', '0',  'Actualizar estado de los créditos insinuados', '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_ContactarDeudor',  '', '', '', '', '', '0',  'Contactar con Deudor',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '', '1',  'EXTTareaProcedimiento',  '3',  '', '803', 'SDEU', '', ''),
      T_TIPO_TAP('H009',  'H009_BPMhaya_tramiteElevacionPropSarebLitigiosA', '', '', '', '', 'H012',  '0',  'Trámite de Elevación a Sareb Litigios',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', ''),
      T_TIPO_TAP('H009',  'H009_BPMhaya_tramiteElevacionPropSarebLitigiosB', '', '', '', '', 'H012',  '0',  'Trámite de Elevación a Sareb Litigios',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', '')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS('', '', 'H009_RegistrarPublicacionBOE', '3*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_BPMTramiteAceptacionConcurso',  '300*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_RegistrarInsinuacionCreditos',  'damePlazo(valores[''H009_RegistrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_RevisarInsinuacionCreditos',  'damePlazo(valores[''H009_RegistrarPublicacionBOE''][''fecha'']) + 22*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_PresentarEscritoInsinuacion', 'damePlazo(valores[''H009_RegistrarPublicacionBOE''][''fecha'']) + 28*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_RegistrarProyectoInventario', 'damePlazo(valores[''H009_RegistrarPublicacionBOE''][''fecha'']) + 60*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_PresentarRectificacion',  'damePlazo(valores[''H009_RegistrarProyectoInventario''][''fechaComunicacion'']) + 7*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_RegistrarInformeAdmonConcursal',  'damePlazo(valores[''H009_RegistrarProyectoInventario''][''fechaComunicacion'']) + 10*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_RevisarResultadoInfAdmon',  'damePlazo(valores[''H009_RegistrarInformeAdmonConcursal''][''fecha'']) + 2*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_RegistrarResolucionFaseComun',  '180*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_ValidarAlegaciones',  'damePlazo(valores[''H009_RegistrarInformeAdmonConcursal''][''fecha'']) + 7*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_BPMTramiteDemandaIncidental', '300*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_ActualizarEstadoCreditos',  '1*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_BPMTramiteFaseConvenioV4',  '300*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_BPMTramiteFaseLiquidacion', '300*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_ContactarDeudor', '2*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_BPMhaya_tramiteElevacionPropSarebLitigiosA', '300*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H009_BPMhaya_tramiteElevacionPropSarebLitigiosB', '300*24*60*60*1000L', '0',  '0',  'DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('H009_RevisarInsinuacionCreditos', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de rellenar esta pantalla deber&aacute; revisar las insinuaciones realizadas por el letrado, para el supuesto que quiera rectificar alguna de ellas deber&aacute; acceder a la pestaña "Fase com&uacute;n" de la ficha del asunto correspondiente y a trav&eacute;s del bot&oacute;n "Revisar calificaci&oacute;n" proponer los valores que estime en los campos de calificaci&oacute;n revisada.</p><p style="margin-bottom: 10px">En la presente pantalla y para el caso del supuesto anterior debe indicar el n&uacute;mero de cr&eacute;ditos rectificados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Presentar escrito de insinuaci&oacute;n de cr&eacute;ditos" a realizar por el letrado concursal.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RevisarInsinuacionCreditos', '1',  'currency', 'numCreditos',  'Nº de créditos rectificados',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RevisarInsinuacionCreditos', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_ValidarAlegaciones', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; revisar si procede presentar alegaciones seg&uacute;n informa el letrado del concurso y, a su vez hacerle llegar el informe a Sareb para su conocimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea, en caso de haber acordado junto al letrado la presentaci&oacute;n de alegaciones, se iniciar&aacute; el tr&aacute;mite de demanda incidental, en caso contrario se iniciar&aacute; la tarea "Registrar resoluci&oacute;n de fase".</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_ValidarAlegaciones', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_ValidarAlegaciones', '2',  'combo',  'PresentaAlegaciones',  'Presenta alegaciones', '', '', 'valores[''H009_RevisarResultadoInfAdmon''][''comAlegaciones'']', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H009_ValidarAlegaciones', '3',  'textarea', 'ObservacionesLetrado', 'Observaciones letrado',  '', '', 'valores[''H009_RevisarResultadoInfAdmon''][''observaciones'']',  '', '0',  'DD'),
      T_TIPO_TFI('H009_ValidarAlegaciones', '4',  'combo',  'PresentaAlegacionesCombo', 'Presentar alegaciones',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H009_ValidarAlegaciones', '5',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_ActualizarEstadoCreditos', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para completar esta tarea deber&aacute; actualizar el estado de los cr&eacute;ditos insinuados en la pestaña "Fase com&uacute;n" de la ficha del Asunto correspondiente a valor "6. Reconocido".</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar resoluci&oacute;n finalizaci&oacute;n fase com&uacute;n".</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_ActualizarEstadoCreditos', '1',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_BPMTramiteAceptacionConcurso', '0',  'label',  'titulo', 'Tr&aacute;mite de Aceptaci&oacute;n por parte del gestor', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_BPMhaya_tramiteElevacionPropSarebLitigiosA', '0',  'label',  'titulo', 'Tr&aacute;mite de elevaci&oacute;n a Sareb con litigios', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_BPMhaya_tramiteElevacionPropSarebLitigiosB', '0',  'label',  'titulo', 'Tr&aacute;mite de elevaci&oacute;n a Sareb con litigios', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_BPMTramiteDemandaIncidental',  '0',  'label',  'titulo', 'Se inicia Tr&aacute;mite demanda incidental', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_BPMTramiteFaseConvenioV4', '0',  'label',  'titulo', 'Se inicia la Fase de convenio',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_BPMTramiteFaseLiquidacion',  '0',  'label',  'titulo', 'Se inicia la Fase de liquidaci&oacute;n', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&oacute;n o env&iacute;o por correo electr&oacute;nico de la propuesta de insinuaci&oacute;n de cr&eacute;ditos a la administraci&oacute;n concursal.</p><p style="margin-bottom: 10px">Al aceptar el sistema comprobar&aacute; que todos los cr&eacute;ditos insinuados en la pestaña Fase Com&uacute;n disponen de valores definitivos y que se encuentran en estado "2. Insinuado".</p><p style="margin-bottom: 10px">En esta tarea, aparecer&aacute;n acumulados los importes de los cr&eacute;ditos insinuados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, si hemos comunicado nuestros cr&eacute;ditos a la Administraci&oacute;n concursal mediante correo electr&oacute;nico, "Revisar proyecto de inventario".</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '1',  'date', 'fecha',  'Fecha presentación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '2',  'currency', 'tCredMasa',  'Total créditos contra la masa',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  '', 'dameTotalCreditosContraLaMasa()',  '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '3',  'currency', 'tCredPrivEsp', 'Total créditos con privilegio especial', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  '', 'dameTotalCreditosConPrivilegioEspecial()', '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '4',  'currency', 'tCredPrivGen', 'Total créditos con privilegio general',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  '', 'dameTotalCreditosConPrivilegioGeneral()',  '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '5',  'currency', 'tCredOrd', 'Total créditos ordinarios',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  '', 'dameTotalCreditosOrdinarios()',  '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '6',  'currency', 'tCredSub', 'Total créditos subordinados',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  '', 'dameTotalCreditosSubordinados()',  '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '7',  'currency', 'tCredContigentes', 'Total créditos contigentes', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  '', 'dameTotalCreditosContingentes()',  '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '8',  'currency', 'totalCred',  'Total créditos insinuados',  '', '', 'dameTotalCreditos()',  '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarEscritoInsinuacion',  '9',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarRectificacion', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; consignar la fecha del env&iacute;o por correo electr&oacute;nico del escrito solicitando la rectificaci&oacute;n de errores o el complemento de datos en el proyecto de inventario y de la lista de acreedores notificados por la Administraci&oacute;n Concursal.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento. Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar informe de la administraci&oacute;n concursal".</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarRectificacion', '1',  'date', 'fecha',  'Fecha presentación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_PresentarRectificacion', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarInformeAdmonConcursal', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de recepci&oacute;n del informe de administraci&oacute;n concursal en respuesta a nuestra presentaci&oacute;n de insinuaci&oacute;n de cr&eacute;ditos, al pulsar Aceptar el sistema comprobar&aacute; que los cr&eacute;ditos insinuados en la pestaña "Fase Com&uacute;n" disponen de cuant&iacute;as finales y que se encuentran en estado "3 Pendiente Revisi&oacute;n IAC". Para ello debe abrir el asunto correspondiente, ir a la pestaña Fase Com&uacute;n y abrir la ficha de cada uno de los cr&eacute;ditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Revisar informe de la administraci&oacute;n concursal".</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarInformeAdmonConcursal', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarInformeAdmonConcursal', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarInsinuacionCreditos', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de poder completar esta tarea deber&aacute; esperar a recibir aviso a trav&eacute;s de la herramienta que el expediente digital de todos los contratos del concurso esta ya adjunto al procedimiento en Recovery y puede proceder a su revisi&oacute;n.</p><p style="margin-bottom: 10px">En caso de vencer esta tarea y no haber recibido dicho aviso, deber&aacute; ponerse en contacto con su supervisor de la entidad para informar de dicha situaci&oacute;n a trav&eacute;s de la funci&oacute;n Anotaciones de Recovery. Recuerde que en caso de vencer esta tarea podr&aacute; solicitar una pr&oacute;rroga de la misma.</p><p style="margin-bottom: 10px">Antes de rellenar esta pantalla, para el supuesto que quiera insinuar alg&uacute;n cr&eacute;dito, deber&aacute; ir a la pestaña "Fase com&uacute;n" de la ficha del asunto correspondiente y proceder a su insinuaci&oacute;n para lo que deber&aacute; introducir valores en los campos de insinuaci&oacute;n inicial.</p><p style="margin-bottom: 10px">En la presente pantalla y para el caso del supuesto anterior debe indicar el n&uacute;mero de cr&eacute;ditos insinuados.</p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.<p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Revisar insinuaci&oacute;n de cr&eacute;ditos" a realizar por el supervisor del asunto concursal.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarInsinuacionCreditos', '1',  'currency', 'numCreditos',  'Nº de créditos insinuados',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarInsinuacionCreditos', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarProyectoInventario',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; informar la fecha con la que se nos comunica mediante correo electr&oacute;nico por la Administraci&oacute;n Concursal el proyecto de inventario.</p><p style="margin-bottom: 10px">Igualmente, deberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&oacute;n Concursal. En el caso de que sea favorable, se deber&aacute; esperar a la siguiente tarea sobre el informe presentado por la Administraci&oacute;n Concursal ante el juez.</p><p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&aacute; comprobar si el error ha sido cometido por la Entidad a la hora de elaborar la insinuaci&oacute;n de cr&eacute;ditos. Si la insinuaci&oacute;n ha sido correcta deber&aacute; ponerse en contacto con la Administraci&oacute;n Concursal para su aclaraci&oacute;n. Con independencia de que se aclarada o no la discrepancia con la Administraci&oacute;n Concursal, se deber&aacute; remitir igualmente correo electr&oacute;nico a la Administraci&oacute;n Concursal solicitando su subsanaci&oacute;n para su constancia por escrito, haciendo menci&oacute;n en su caso de la aclaraci&oacute;n efectuada previamente.</p><p style="margin-bottom: 10px">En aquellos casos en los que la discrepancia sea relevante deber&aacute; informar al supervisor mediante comunicado o notificaci&oacute;n para anticipar la posibilidad de que sea necesario interponer un incidente de impugnaci&oacute;n una vez presentado el informe en el Juzgado. En todo caso, tanto si el proyecto es favorable como desfavorable, deberemos modificar el estado de todos los cr&eacute;ditos al estado “3. Pendiente revisi&oacute;n IAC” para completar esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, en caso de ser favorable "Registrar informe de la administraci&oacute;n concursal" y en caso contrario "Presentar rectificaci&oacute;n".</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarProyectoInventario',  '1',  'date', 'fechaComunicacion',  'Fecha de comunicación del proyecto', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarProyectoInventario',  '2',  'combo',  'comFavorable', 'Favorable',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarProyectoInventario',  '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; de revisar los datos que aparecen rellenados respecto al nuevo concurso y consignar aquellos datos que aparecen vac&iacute;os. Opcionalmente puede consignar los datos de contacto de los administradores concursales designados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar insinuaci&oacute;n de cr&eacute;ditos"</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '1',  'date', 'fecha',  'Fecha de publicación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '2',  'date', 'fechaAuto',  'Fecha auto declarando concurso', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '3',  'combo',  'plazaJuzgado', 'Plaza del juzgado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'damePlaza()',  'TipoPlaza',  '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '4',  'combo',  'nJuzgado', 'Nº de juzgado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'dameNumJuzgado()', 'TipoJuzgado',  '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '5',  'textproc', 'nAuto',  'Nº Auto',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'dameNumAuto()',  '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '6',  'date', 'fechaAceptacion',  'Fecha aceptación del cargo de la Adm. Concursal',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '7',  'text', 'admNombre',  'Adm. Nombre',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '8',  'text', 'admDireccion', 'Adm. dirección', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '9',  'text', 'admTelefono',  'Adm. teléfono',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '10', 'text', 'admEmail', 'Adm. email', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '11', 'text', 'admNombre2', 'Adm.2 Nombre', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '12', 'text', 'admDireccion2',  'Adm.2 dirección',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '13', 'text', 'admTelefono2', 'Adm.2 teléfono', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '14', 'text', 'admEmail2',  'Adm.2 email',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '15', 'text', 'admNombre3', 'Auxiliar delegado Nombre', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '16', 'text', 'admDireccion3',  'Auxiliar delegado Dirección',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '17', 'text', 'admTelefono3', 'Auxiliar delegado Teléfono', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '18', 'text', 'admEmail3',  'Auxiliar delegado Email',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarPublicacionBOE',  '19', 'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarResolucionFaseComun', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea deber&aacute; completarla en el momento que tenga constancia del fin de la fase com&uacute;n e inicio de la siguiente fase.<br>En el campo "Situaci&oacute;n concursal" deber&aacute; indicar la situaci&oacute;n en la que queda el concurso una vez completada esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&aacute; la Fase de liquidaci&oacute;n en caso de que lo haya indicado as&iacute;, en caso contrario se iniciar&aacute; la Fase de convenio.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarResolucionFaseComun', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarResolucionFaseComun', '2',  'combo',  'comboLiquidacion', 'Fase de liquidación',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H009_RegistrarResolucionFaseComun', '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RevisarResultadoInfAdmon', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones al informe de la Administraci&oacute;n Concursal, al pulsar Aceptar el sistema comprobar&aacute; que el estado de los cr&eacute;ditos insinuados en la pestaña Fase Com&uacute;n es, en caso de presentar alegaciones "4. Pendiente de demanda incidental" o en caso contrario "6. Reconocido". Para ello debe abrir el asunto correspondiente, ir a la pestaña "Fase Com&uacute;n" y abrir la ficha de cada uno de los cr&eacute;ditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea,<ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;"> En caso de no presentar alegaciones ser&aacute; "Registrar resoluci&oacute;n de finalizaci&oacute;n fase com&uacute;n".</li><li style="margin-bottom: 10px; margin-left: 35px;"> En caso de haberse presentado alegaciones se lanzar&aacute; la tarea “Validar alegaciones” al supervisor del concurso y, el letrado deber&aacute; presentar el informe.</li></ul></p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_RevisarResultadoInfAdmon', '1',  'combo',  'comAlegaciones', 'Presentar alegaciones',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H009_RevisarResultadoInfAdmon', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_ContactarDeudor', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; informar de la fecha en la que se ha puesto en contacto con el deudor. Adem&aacute;s, deber&aacute; comunicar el resultado del acuerdo a su supervisor.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H009_ContactarDeudor', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H009_ContactarDeudor', '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD')
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