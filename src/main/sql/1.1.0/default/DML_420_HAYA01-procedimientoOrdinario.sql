/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Procedimiento Ordinario
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
      T_TIPO_TPO('H024',  'P. ordinario', 'Procedimiento ordinario',  '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>Testimonio Literal sin Finalidad Ejecutiva de la P&oacute;liza de Pr&eacute;stamo Mercantil que sirve de t&iacute;tulo a la presente reclamaci&oacute;n.</li><li>Documento fehaciente de conformidad con el Art. 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por el Banco intervenido por Notario, que acredita haberse practicado la liquidaci&oacute;n en la forma prevista por las partes en la P&oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Informe de Cierre de Préstamo intervenido por Notario.</li><li>Requerimiento de pago a la parte demandada en el domicilio conocido de la cantidad exigible, mediante telegrama.</li></ul></div>', 'procedimientoOrdinario', '0',  'DD', '0',  'DE', '', '', '1',  'MEJTipoProcedimiento', '1',  '0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP('H024',  'H024_ResolucionFirme', '', '', '', '', '', '0',  'Resolución firme', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H024',  'H024_RegistrarResolucion', '', 'comprobarExisteDocumentoREO() ? null : ''Es necesario adjuntar el documento Resolución del Juzgado del P. Ordinario''', '', '', '', '0',  'Registrar resolucion', '0',  'DD', '0',  '', '', '01', '0',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H024',  'H024_RegistrarJuicio', '', '', '', '', '', '0',  'Confirmar celebración juicio', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '0',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H024',  'H024_RegistrarAudienciaPrevia',  '', '', '((valores[''H024_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''H024_RegistrarAudienciaPrevia''][''fechaJuicio''] == null))?''tareaExterna.error.H024_RegistrarAudienciaPrevia.fechaOblgatoria'':null', 'valores[''H024_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',  '', '0',  'Registrar audiencia prévia', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '0',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H024',  'H024_InterposicionDemanda',  'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',  '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (comprobarExisteDocumentoEDO() ? null : ''Es necesario adjuntar el documento Escrito de Demanda del P. Ordinario'')', '', '', '', '0',  'Interposición de la demanda',  '0',  'DD', '0',  '', '', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H024',  'H024_ConfirmarOposicion',  '', 'comprobarExisteDocumentoEOO() ? null : ''Es necesario adjuntar el documento Escrito de Oposición del P. Ordinario.''', '((valores[''H024_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''H024_ConfirmarOposicion''][''fechaOposicion''] == null) || (valores[''H024_ConfirmarOposicion''][''fechaAudiencia''] == null)))?''Debe introducir la fecha de oposición y fecha de audiencia'':null',  '', '', '0',  'Confirmar si existe oposición',  '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '0',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H024',  'H024_ConfirmarNotDemanda', '', '', '((valores[''H024_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''H024_ConfirmarNotDemanda''][''fecha''] == null))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null', 'valores[''H024_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''', '', '0',  'Confirmar notificación de la demanda', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '0',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H024',  'H024_ConfirmarAdmision', 'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',  'comprobarExisteDocumentoADEO() ? null : ''Es necesario adjuntar el documento Auto Despachando Ejecución del P. Ordinario.''', '', 'valores[''H024_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''', '', '0',  'Confirmar admisión de la demanda', '0',  'DD', '0',  '', 'tareaExterna.cancelarTarea', '01', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', 'GUCL', ''),
      T_TIPO_TAP('H024',  'H024_BPMTramiteNotificacion',  '', '', '', '', 'P400', '0',  'Se inicia Trámite de notificación',  '0',  'DD', '0',  '', '', '', '1',  'EXTTareaProcedimiento',  '3',  '', '39', '', '', '')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS('', '', 'H024_InterposicionDemanda',  '5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H024_ConfirmarAdmision', 'damePlazo(valores[''H024_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H024_ConfirmarNotDemanda', 'damePlazo(valores[''H024_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H024_ConfirmarOposicion',  '((valores[''H024_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''H024_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''H024_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H024_RegistrarAudienciaPrevia',  'damePlazo(valores[''H024_ConfirmarOposicion''][''fechaAudiencia''])',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H024_RegistrarJuicio', 'damePlazo(valores[''H024_RegistrarAudienciaPrevia''][''fechaJuicio''])', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H024_RegistrarResolucion', '30*24*60*60*1000L',  '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H024_ResolucionFirme', 'damePlazo(valores[''H024_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L', '0',  '0',  'DD'),
      T_TIPO_PLAZAS('', '', 'H024_BPMTramiteNotificacion',  '300*24*60*60*1000L', '0',  '0',  'DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('H024_InterposicionDemanda', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar fecha de presentaci&oacute;n de la demandae ind&iacute;quese la plaza del juzgado. Se ha de indicar la fecha de cierre de la deuda junto con el principal de la demanda, el capital vencido, juntos con los intereses ordinarios y de demora que se han generado en el cierre.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Confirmar admisi&oacute;n de la demanda&quot;.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_InterposicionDemanda', '1',  'date', 'fecha',  'Fecha de presentación',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_InterposicionDemanda', '2',  'combo',  'plazaJuzgado', 'Plaza del juzgado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'damePlaza()',  'TipoPlaza',  '0',  'DD'),
      T_TIPO_TFI('H024_InterposicionDemanda', '3',  'date', 'fechaCierre', 'Fecha cierre de la déuda', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_InterposicionDemanda', '4',  'number', 'principalDemanda', 'Principal de la demanda',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_InterposicionDemanda', '5',  'number', 'capitalVencido', 'Capital vencido (en el cierre)',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_InterposicionDemanda', '6',  'number', 'interesesOrdinarios', 'Intereses Ordinarios (en el cierre)',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_InterposicionDemanda', '7',  'number', 'interesesDemora', 'Intereses de demora (en el cierre)',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_InterposicionDemanda', '8',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarAdmision',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&iacute;quese la fecha en la que se nos notifica la admisi&oacute;n de la demanda, el juzgado en el que ha reca&iacute;do y el n&uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no, lo que supondr&aacute;, seg&uacute;n su contestaci&oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, si ha sido admitida a tr&aacute;mite la demanda &quot;Confirmar notificaci&oacute;n de la demanda&quot;. Si no ha sido admitida la demanda se le abrir&aacute; tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarAdmision',  '1',  'date', 'fecha',  'Fecha admisión', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarAdmision',  '2',  'combo',  'nPlaza', 'Plaza',  '', '', 'damePlaza()',  'TipoPlaza',  '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarAdmision',  '3',  'combo',  'numJuzgado', 'Juzgado designado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'dameNumJuzgado()', 'TipoJuzgado',  '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarAdmision',  '4',  'textproc', 'numProcedimiento', 'Nº de procedimiento',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  'dameNumAuto()',  '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarAdmision',  '5',  'combo',  'comboResultado', 'Admisión', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarAdmision',  '6',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarNotDemanda',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez dictado el auto de admisi&oacute;n de la demanda, en esta pantalla, debe indicar si la notificaci&oacute;n de la misma se ha realizado satisfactoriamente, con lo que deber&aacute; indicar que es positivo, o no.</p><p style="margin-bottom: 10px">Deber&aacute; consignar la fecha de notificaci&oacute;n &uacute;nicamente en el supuesto de que &eacute;sta se hubiese efectuado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Notificaci&oacute;n positiva: &quot;Confirmar si existe oposici&oacute;n&quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">Notificaci&oacute;n negativa: en este caso se iniciar&aacute; el tr&aacute;mite de notificaci&oacute;n.</li></ul></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarNotDemanda',  '1',  'combo',  'comboResultado', 'Resultado notificación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDPositivoNegativo', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarNotDemanda',  '2',  'date', 'fecha',  'Fecha',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarNotDemanda',  '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarOposicion', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez notificado al demandado el auto de admisi&oacute;n de la demanda, en esta pantalla ha de indicarse si el mismo se ha opuesto o no.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposici&oacute;n, deber&aacute; consignar su fecha de notificaci&oacute;n e indicar la fecha que el juzgado ha designado para la audiencia previa.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Registrar audiencia previa&quot;.</p></div>', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarOposicion', '1',  'combo',  'comboResultado', 'Existe oposición', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarOposicion', '2',  'date', 'fechaOposicion', 'Fecha oposición',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarOposicion', '3',  'date', 'fechaAudiencia', 'Fecha audiencia prévia', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ConfirmarOposicion', '4',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarAudienciaPrevia', '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de consignar la fecha de celebraci&oacute;n de la audiencia previa. En caso de que se suspenda la audiencia se deber&aacute; solicitar pr&oacute;rroga para &eacute;sta tarea, en la que deber&aacute; indicar la nueva fecha de celebraci&oacute;n de la misma.</p><p style="margin-bottom: 10px">Para el supuesto de que se hubiese celebrado: deber&aacute; indicar si el procedimiento a quedado visto para sentencia, y en caso negativo se deber&aacute; consignar la fecha de señalamiento del juicio.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; :</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si queda visto para sentencia: &quot;Registrar resoluci&oacute;n&quot;</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso contrario: &quot;Registrar juicio&quot;</li></ul></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarAudienciaPrevia', '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarAudienciaPrevia', '2',  'combo',  'comboResultado', 'Visto para sentencia', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDSiNo', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarAudienciaPrevia', '3',  'date', 'fechaJuicio',  'Fecha Juicio', '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarAudienciaPrevia', '4',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarJuicio',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Despu&eacute;s de celebrada la audiencia previa, en esta pantalla debemos de consignar la fecha en la que se ha celebrado el juicio del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Registrar resoluci&oacute;n&quot;.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarJuicio',  '1',  'date', 'fecha',  'Fecha',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarJuicio',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarResolucion',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de consignar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do como consecuencia del juicio celebrado. </p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido favorable para los intereses de la entidad o no. </p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a traves del bot&oacute;n &quot;Comunicaci&oacute;n&quot;. Una vez reciba la aceptación del supervisor deber&aacute; gestionar el recurso por medio de la pestaña &quot;Recursos&quot;.</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&aacute; gestionar directamente a trav&eacute;s de la pestaña &quot;Recursos&quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; &quot;Resoluci&oacute;n firme&quot;</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarResolucion',  '1',  'date', 'fecha',  'Fecha resolución', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarResolucion',  '2',  'combo',  'comboResultado', 'Resultado',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', 'DDFavorable',  '0',  'DD'),
      T_TIPO_TFI('H024_RegistrarResolucion',  '3',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ResolucionFirme',  '0',  'label',  'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deber&aacute; consignar la fecha en la que la Resoluci&oacute;n adquiere firmeza.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ResolucionFirme',  '1',  'date', 'fecha',  'Fecha firmeza',  'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',  'valor != null && valor != '''' ? true : false',  '', '', '0',  'DD'),
      T_TIPO_TFI('H024_ResolucionFirme',  '2',  'textarea', 'observaciones',  'Observaciones',  '', '', '', '', '0',  'DD'),
      T_TIPO_TFI('H024_BPMTramiteNotificacion', '0',  'label',  'titulo', 'Se inicia Trámite de notificación',  '', '', '', '', '0',  'DD')
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
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' ||
                      'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' 
                      || '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' 
                      || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') 
                      || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') 
                      || ''',' || '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' 
                      || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') 
                      || ''',' || 'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') 
                      || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') 
                      || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') 
                      || ''',' || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' 
                      || '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' 
                      || ''''|| REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') 
                      || ''',' ||'(select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
                      || ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                      || ''' FROM DUAL';
                    
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