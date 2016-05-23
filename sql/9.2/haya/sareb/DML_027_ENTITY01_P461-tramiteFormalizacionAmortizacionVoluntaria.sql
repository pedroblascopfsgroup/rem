/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160513
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1353
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Trámite de Formalizacion Amortizacion Voluntaria
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
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_TIPOACTUACION VARCHAR2(50 CHAR); -- Tipo de actuación a insertar

    --Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('P461','T. de Amortización Voluntaria','T. de Amortización Voluntaria',null,'haya_tramiteFormalizacionAmortizacionVoluntaria','0','PRODUCTO-1353','0','ACU',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       T_TIPO_TAP('P461','P461_obtenerAprobacionCN','plugin/procedimientos-bpmHaya-plugin/tramiteFormalizacionAmortizacionVoluntaria/obtenerAprobacionCN',null,null,'valores[''P461_obtenerAprobacionCN''][''comboObtencionAprobacionCN''] == ''01'' ? valores[''P461_obtenerAprobacionCN''][''comboRevisionCorrecta''] == ''01'' ? ''si'' : ''no'' : ''no''',null,'0','Obtener aprobación CN','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'GCN',null)
	,T_TIPO_TAP('P461','P461_ComunicacionAcreditadoCN',null,null,null,null,null,'0','Comunicación al Acreditado CN','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_enviarDesistirWFCN',null,null,null,null,null,'0','Enviar a desistir WF CN','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_confeccionarEscrituraCancelacion',null, null,null,'valores[''P461_confeccionarEscrituraCancelacion''][''comboRequiereValidacion''] == ''01'' ? ''si'' : ''no''',null,'0','Confeccionar Escritura Cancelación','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_validarBorradorContratoAJ',null,null,null,'valores[''P461_validarBorradorContratoAJ''][''comboValida''] == ''01'' ? ''aprobada'' : ''rechazada''',null,'0','Validar Borrador Contrato AJ','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'TGAJUR',null,'SAJUR',null)
	,T_TIPO_TAP('P461','P461_comunicacionAlAcreditadoAJ',null,null,null,null,null,'0','Comunicación al Acreditado AJ','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_enviarDesistirWFAJ',null,null,null,null,null,'0','Enviar a Desistir WF AJ','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_envioBorradorContratoAlAcreditado',null,null,null,null,null,'0','Envío borrador contrato al Acreditado','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_acordarFechaFirma','plugin/procedimientos-bpmHaya-plugin/tramiteFormalizacionAmortizacionVoluntaria/acordarFechaFirma',null,'valores[''P461_acordarFechaFirma''][''comboAprobacionCN''] !=null && valores[''P461_acordarFechaFirma''][''comboAprobacionCN''] == ''01'' ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La tarea no se podr&aacute; finalizar hasta que el campo Aprobaci&oacute;n sea SI.</div>''','valores[''P461_acordarFechaFirma''][''comboResolucionConAcreditado''] == ''ACEPTADO'' ? ''aceptada'' : ''rechazada'' ',null,'0','Acordar Fecha Firma','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_firmarOperacion','plugin/procedimientos-bpmHaya-plugin/tramiteFormalizacionAmortizacionVoluntaria/firmarOperacion',null,null,'valores[''P461_firmarOperacion''][''comboFormalizadaOp''] == ''01'' ? ''aceptada'' : ''rechazada''',null,'0','Firmar Operación','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_enviarDesistirPreviaFirmaOperacion',null,null,null,null,null,'0','Enviar a Desistir WF Previa Firma Operación','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_obtenerDocumentacionOriginal',null,null,null,null,null,'0','Obtener Documentación Original','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'803',null,'SDEU',null)
	,T_TIPO_TAP('P461','P461_contabilizarOperacion',null,null,null,null,null,'0','Contabilizar la Operación','0','PRODUCTO-1353','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'805',null,'SSDE',null)
	); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
     	 T_TIPO_PLAZAS(null,null,'P461_obtenerAprobacionCN','7*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_ComunicacionAcreditadoCN','3*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_enviarDesistirWFCN','5*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_confeccionarEscrituraCancelacion','2*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_validarBorradorContratoAJ','4*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_comunicacionAlAcreditadoAJ','3*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_enviarDesistirWFAJ','5*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_envioBorradorContratoAlAcreditado','2*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_acordarFechaFirma','5*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_firmarOperacion','(valores[''P461_acordarFechaFirma''] !=null && valores[''P461_acordarFechaFirma''][''fechaPrevistaFirma''] !=null) ? damePlazo(valores[''P461_acordarFechaFirma''][''fechaPrevistaFirma'']) : 30*24*60*60*1000L','0','0','PRODUCTO-1353')
    ,T_TIPO_PLAZAS(null,null,'P461_enviarDesistirPreviaFirmaOperacion','5*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_obtenerDocumentacionOriginal','5*24*60*60*1000L','0','0','PRODUCTO-1353')
	,T_TIPO_PLAZAS(null,null,'P461_contabilizarOperacion','5*24*60*60*1000L','0','0','PRODUCTO-1353')
	); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
     T_TIPO_TFI('P461_obtenerAprobacionCN','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El Gestor de Deuda revisará la Actuación y observará:<br>- Si es necesario obtener la aprobación de Cumplimiento Normativo.<br>- En caso de ser necesaria la aprobación, deberá indicar si se puede continuar con la operación o no supera la revisión de prevención de blanqueo de capitales.<br><br>Además, deberá adjuntar, desde la ficha del Acreditado, la documentación necesaria.<br>En caso de tratarse de una persona física, deberá adjuntar documento de identidad (DNI, pasaporte…).<br>En caso de persona jurídica, deberá adjuntar:<br>- Escritura de constitución con estatutos, u otra con análoga información.<br>- Manifestación de titularidad real.<br>- Poder del apoderado.<br>- DNI del apoderado.<br>En ambos casos deberá adjuntar la documentación que acredite el origen de los fondos y que se precise para el análisis de PBC.<br><br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br><br>- Si el Gestor observa que todo es correcto, se continuará con la actuación.<br><br>- Si la operación no supera la revisión por parte del equipo de prevención de blanqueo de capitales, la siguiente tarea será “Comunicación al Acreditado CN”, para posteriormente finalizar la actuación.</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_obtenerAprobacionCN','1','date','fechaAviso','Fecha Aviso','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_obtenerAprobacionCN','2','combo','comboObtencionAprobacionCN','Obtención aprobación CN','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_obtenerAprobacionCN','3','combo','comboRevisionCorrecta','Revisión correcta',null,null,null,'DDSiNo','0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_obtenerAprobacionCN','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')
	

	,T_TIPO_TFI('P461_ComunicacionAcreditadoCN','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deberá comunicar al Acreditado la finalización de la operación.<br>A continuación, informaremos la fecha de comunicación al Acreditado.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>A continuación, saltará la tarea "Enviar a desistir WF CN".</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_ComunicacionAcreditadoCN','1','date','fechaComunicacionCliente','Fecha comunicación cliente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_ComunicacionAcreditadoCN','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')

	,T_TIPO_TFI('P461_enviarDesistirWFCN','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.<br>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_enviarDesistirWFCN','1','date','fechaCierreWF','Fecha Cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_enviarDesistirWFCN','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')


	,T_TIPO_TFI('P461_confeccionarEscrituraCancelacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deberá adjuntar el borrador del contrato a través de la que se informará al Acreditado de las condiciones de la operación.<br>En el campo "Requiere validación", deberá indicar si la plantilla adjuntada requiere validación por el departamento de Asesoría Jurídica.<br>En caso de Requerir Validación, saltará la tarea: "Validar borrador contrato AJ".<br><br>En caso contrario, saltará la tarea "Envío borrador contrato al Acreditado".</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_confeccionarEscrituraCancelacion','1','date','fechaRecepcion','Fecha Recepción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_confeccionarEscrituraCancelacion','2','combo','comboRequiereValidacion','Requiere validación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_confeccionarEscrituraCancelacion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')
	

	,T_TIPO_TFI('P461_validarBorradorContratoAJ','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deberá revisar que puede realizarse la contabilización de los importes recibidos e indicar la fecha en la que recepciona el mandamiento de pago.<br><br>En caso de que la deuda no quede totalmente cubierta y alguno de los bienes no sea vivienda habitual, se continuará con la averiguación patrimonial. En el supuesto de que el bien o los bienes estuvieran marcados como vivienda habitual, se deberá considerará fallido procesal y no se continuará con la solvencia patrimonial.<br><br>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.<br><br>Una vez finalice esta tarea se lanzará la tarea "Confirmar contabilidad".</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_validarBorradorContratoAJ','1','combo','comboValida','Valida','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_validarBorradorContratoAJ','2','combo','comboAdjuntarNuevoContrato','Adjuntar nuevo contrato','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_validarBorradorContratoAJ','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')

    
	,T_TIPO_TFI('P461_comunicacionAlAcreditadoAJ','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras no superar la validación de Asesoría Jurídica, deberá comunicar al Acreditado la finalización de la operación.<br>A continuación, informaremos la fecha de comunicación al Acreditado.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>A continuación, saltará la tarea "Enviar a desistir WF".</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_comunicacionAlAcreditadoAJ','1','date','fechaComunicacionCliente','Fecha comunicación cliente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_comunicacionAlAcreditadoAJ','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')


	,T_TIPO_TFI('P461_enviarDesistirWFAJ','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.<br>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_enviarDesistirWFAJ','1','date','fechaCierreWF','Fecha cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_enviarDesistirWFAJ','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')
        
	
	,T_TIPO_TFI('P461_envioBorradorContratoAlAcreditado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se informará la fecha en que se enviará el borrador del contrato al Acreditado.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>La siguiente tarea será "Acordar fecha firma".</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_envioBorradorContratoAlAcreditado','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_envioBorradorContratoAlAcreditado','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')
    
	,T_TIPO_TFI('P461_acordarFechaFirma','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En primer lugar, deberá informar si ha obtenido la aprobación de Cumplimiento Normativo, ya que es necesaria su aprobación para fijar la fecha de firma de la operación con el Acreditado.<br>Además, debe informar la resolución a la que ha llegado con el Acreditado:<br><br>- Si ha aceptado la operación, en cuyo caso, deberá informar de la fecha en la que se va a celebrar la firma, quién asistirá a la firma y si se realizará en Notaría, en cuyo caso, deberá especificarse el nombre del notario.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>Una vez rellene esta tarea:<br>- Si el Acreditado acepta el contrato, se lanzará la tarea “Firmar operación”.<br>- Si el Acreditado rechaza el contrato, se lanzará la tarea “Enviar a desistir previa firma operación”.</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_acordarFechaFirma','1','combo','comboAprobacionCN','Aprobación CN','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_acordarFechaFirma','2','combo','comboResolucionConAcreditado','Resolución con acreditado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDAceptadoRechazado','0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_acordarFechaFirma','3','date','fechaPrevistaFirma','Fecha prevista de firma',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_acordarFechaFirma','4','combo','comboFirmaNotaria','Firma en notaría',null,null,null,'DDSiNo','0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_acordarFechaFirma','5','text','notario','Notario',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_acordarFechaFirma','6','text','asistenciaFirmarGestor','Asistencia a firmar por Gestor / Gestoría',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_acordarFechaFirma','7','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')
    
    ,T_TIPO_TFI('P461_firmarOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar como finalizada esta tarea, debe informar la fecha en la que se formalizó la operación y adjuntar desde la pestaña de Adjuntos de la Actuación el resto de documentación necesaria para la formalización de la operación.<br><br>Deberá confirmar las condiciones de la operación.<br><br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br><br>Una vez formalizada la operación y completada esta tarea, se lanzarán las tareas “Obtener documentación original” y “Contabilizar operación”.<br><br>En caso de que no se lleve a cabo la formalización, saltará la tarea “Enviar a desistir WF previa firma operación”.</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_firmarOperacion','1','combo','comboFormalizadaOp','Formalizada operación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_firmarOperacion','2','date','fechaPrevistaFirma','Fecha prevista de firma',null,null,'(valores[''P461_acordarFechaFirma''] !=null && valores[''P461_acordarFechaFirma''][''fechaPrevistaFirma''] !=null) ? valores[''P461_acordarFechaFirma''][''fechaPrevistaFirma''] : null',null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_firmarOperacion','3','date','fechaRealFirma','Fecha real de firma',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_firmarOperacion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')

    
    ,T_TIPO_TFI('P461_enviarDesistirPreviaFirmaOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras rechazo del Acreditado previa firma de la operación, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.<br>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_enviarDesistirPreviaFirmaOperacion','1','date','fechaCierreWF','Fecha cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_enviarDesistirPreviaFirmaOperacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')
	
	
	,T_TIPO_TFI('P461_obtenerDocumentacionOriginal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras rechazo del Acreditado previa firma de la operación, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.<br>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_obtenerDocumentacionOriginal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_obtenerDocumentacionOriginal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')
	
	
	,T_TIPO_TFI('P461_contabilizarOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para finalizar con esta tarea, se debe informar de la que fecha en la que ha contabilizado la operación en NOS.<br><br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1353')
    ,T_TIPO_TFI('P461_contabilizarOperacion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1353')
	,T_TIPO_TFI('P461_contabilizarOperacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1353')
	
	);
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
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
                    'SELECT '||V_ESQUEMA ||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                    '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) || ''' FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TAP_VIEW=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION_JBPM=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_DECISION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' ||
        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
            ' DD_TSUP_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' || 
            ' DD_TPO_ID_BPM=(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(7)) || ''')' || 
        	' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Actualizada la tarea '''|| TRIM(V_TMP_TIPO_TAP(2)) ||''', ' || TRIM(V_TMP_TIPO_TAP(3)));
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' || V_ESQUEMA || '.' ||
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
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
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
                    ''||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
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
        
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TFI_TIPO=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
        	' TFI_NOMBRE=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',' ||
        	' TFI_LABEL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
        	' TFI_ERROR_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',' ||
        	' TFI_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
        	' TFI_VALOR_INICIAL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',' ||
        	' TFI_BUSINESS_OPERATION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || '''' ||
        	' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
	        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Actualizado el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_NOMBRE = '||TRIM(V_TMP_TIPO_TFI(4))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
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
