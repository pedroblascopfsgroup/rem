/*
--##########################################
--## AUTOR=Carlos Martos
--## FECHA_CREACION=20160406
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-946
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Trámite de Venta de Credito
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
      T_TIPO_TPO('P455','T. de circuito de Venta de Crédito','T. de circuito de Venta de Crédito',null,'tramiteVentaDeCredito','0','PRODUCTO-946','0','ACU',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       T_TIPO_TAP('P455','P455_ObtenerAprobacionCN','plugin/procedimientos-bpmHaya-plugin/tramiteVentaDeCredito/obtenerAprobacionCN',null,'(valores[''P455_ObtenerAprobacionCN''][''obtencionAprobacion''] == DDSiNo.SI && valores[''P455_ObtenerAprobacionCN''][''revisionCorrecta''] == null) ? ''El campo revisión correcta es obligatorio'' : null','valores[''P455_ObtenerAprobacionCN''][''obtencionAprobacion''] == DDSiNo.SI ? ''Si'' : ''No''',null,'0','Obtener aprobación CN','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_ComunicacionAcreditadoCN',null,null,null,null,null,'0','Comunicación al acreditado CN','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_EnviarDesistirWFCN',null,null,null,null,null,'0','Enviar a desistir WF CN','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_ConfeccionarBorradorContratoAcreditado',null,null,null,'valores[''P455_ConfeccionarBorradorContratoAcreditado''][''requiereValidacion''] == DDSiNo.SI ? ''Si'' : ''No''',null,'0','Confeccionar borrador contrato acreditado','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_ValidarBorradorContratoAJ',null,null,null,'valores[''P455_ValidarBorradorContratoAJ''][''valida''] == ''01'' ? ''Aprobada'' : ''Rechazada''',null,'0','Validar borrador contrato AJ','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'TAJUR',null,null,null)
       ,T_TIPO_TAP('P455','P455_ComunicacionAcreditadoAJ',null,null,null,null,null,'0','Comunicación al acreditado AJ','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'TAJUR',null,null,null)
       ,T_TIPO_TAP('P455','P455_EnviarDesistirWFAJ',null,null,null,null,null,'0','Enviar a desistir WF AJ','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_EnvioBorradorContratoAcreditado',null,null,null,null,null,'0','Envío borrador contrato al Acreditado','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)      
       ,T_TIPO_TAP('P455','P455_PeticionEscriturasCaracterEjecutivo',null,null,'(valores[''P455_PeticionEscriturasCaracterEjecutivo''][''adjuntarEscrituras''] == DDSiNo.NO && valores[''P455_PeticionEscriturasCaracterEjecutivo''][''aceptacionAcreditado''] == null) ? ''Es necesario rellenar el campo aceptacion del acreditado'' : null','valores[''P455_PeticionEscriturasCaracterEjecutivo''][''adjuntarEscrituras''] == DDSiNo.SI ? ''si'' : ((valores[''P455_PeticionEscriturasCaracterEjecutivo''][''aceptacionAcreditado''] != null && valores[''P455_PeticionEscriturasCaracterEjecutivo''][''aceptacionAcreditado''] == DDSiNo.SI) ? ''si'':''no'')',null,'0','Peticion Escrituras con Caracter Ejecutivo','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_EnviarDesistirWFEscrituras',null,null,null,null,null,'0','Enviar a desistir WF Escrituras','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_AcordarFechaFirma','plugin/procedimientos-bpmHaya-plugin/tramiteVentaDeCredito/acordarFechaFirma',null,'(valores[''P455_AcordarFechaFirma''][''comboAprobacion''] == ''02'' && valores[''P455_AcordarFechaFirma''][''comboRechazo''] == null) ? ''El campo acción del rechazo es obligatorio'' : (valores[''P455_AcordarFechaFirma''][''comboAprobacion''] == ''01'' && (valores[''P455_AcordarFechaFirma''][''fechaPrevista''] == null || valores[''P455_AcordarFechaFirma''][''comboAsistencia''] == null) ? ''Hay campos obligatorios pendientes de rellenar'' : (valores[''P455_AcordarFechaFirma''][''firmaNotario''] == DDSiNo.SI && valores[''P455_AcordarFechaFirma''][''notario''] == null  ? ''El campo notario es obligatorio'' : null))','valores[''P455_AcordarFechaFirma''][''comboAprobacion''] == ''01'' ? ''Aceptada'' : (valores[''P455_AcordarFechaFirma''][''comboResolucion''] == ''ACE'' ? ''Aceptada'' : (valores[''P455_AcordarFechaFirma''][''comboRechazo''] == ''RECON'' ? ''Reconsiderar'' : ''Desistir''))',null,'0','Acordar fecha firma','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_RevisarPropuesta',null,null,null,null,null,'0','Revisar propuesta','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_ElevarSareb',null,null,null,null,null,'0','Elevar a Sareb','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'805',null,null,null)
       ,T_TIPO_TAP('P455','P455_RegistrarResolucionSareb',null,null,null,'valores[''P455_RegistrarResolucionSareb''][''comboResolucion''] == ''01'' ? ''Aprobada'' : ''Rechazada''',null,'0','Registrar resolución Sareb','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'805',null,null,null)
       ,T_TIPO_TAP('P455','P455_ComunicacionAcreditadoSareb',null,null,null,null,null,'0','Comunicación al Acreditado Sareb','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'805',null,null,null)
       ,T_TIPO_TAP('P455','P455_EnviarDesistirWFSareb',null,null,null,null,null,'0','Enviar a desistir WF Sareb','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_PrepararContrato',null,null,null,'valores[''P455_PrepararContrato''][''requiereValidacion''] == DDSiNo.SI ? ''Si'' : ''No''',null,'0','Preparar contrato','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'805',null,null,null)
       ,T_TIPO_TAP('P455','P455_ValidacionContratoAJ',null,null,null,'valores[''P455_ValidacionContratoAJ''][''valida''] == ''01'' ? ''Validado'' : ''NoValidado''',null,'0','Validación contrato AJ','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'TAJUR',null,null,null)
       ,T_TIPO_TAP('P455','P455_EnvioContratoAcreditado',null,null,null,null,null,'0','Envío del contrato al acreditado','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_FirmarOperacion','plugin/procedimientos-bpmHaya-plugin/tramiteVentaDeCredito/firmarOperacion',null,'(valores[''P455_FirmarOperacion''][''formalizada''] == DDSiNo.SI && valores[''P455_FirmarOperacion''][''fechaReal''] == null) ? ''Es necesario rellenar el campo fecha real de firma'' : null','valores[''P455_FirmarOperacion''][''formalizada''] == ''01'' ? ''Aceptada'' : ''Rechazada''',null,'0','Firmar operación','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_EnviarDesistirPreviaFirmaOperacion',null,null,null,null,null,'0','Enviar a desistir WF previa firma operación','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_InformarCierreSareb',null,null,null,null,null,'0','Informar cierre a Sareb','0','PRODUCTO-946','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ,T_TIPO_TAP('P455','P455_ContabilizarOperacion',null,null,null,null,null,'0','Contabilizar Operacion','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'805',null,null,null)
       ,T_TIPO_TAP('P455','P455_ObtenerDocumentacionOriginal',null,null,null,null,null,'0','Obtener documentación original','0','PRODUCTO-946','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
       ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'P455_ObtenerAprobacionCN','7*24*60*60*1000L','0','0','PRODUCTO-946')
      ,T_TIPO_PLAZAS(null,null,'P455_ComunicacionAcreditadoCN','3*24*60*60*1000L','0','0','PRODUCTO-946')
      ,T_TIPO_PLAZAS(null,null,'P455_EnviarDesistirWFCN','5*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_ConfeccionarBorradorContratoAcreditado','2*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_ValidarBorradorContratoAJ','4*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_ComunicacionAcreditadoAJ','3*24*60*60*1000L','0','0','PRODUCTO-946')
      ,T_TIPO_PLAZAS(null,null,'P455_EnviarDesistirWFAJ','5*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_EnvioBorradorContratoAcreditado','2*24*60*60*1000L','0','0','PRODUCTO-946')
      ,T_TIPO_PLAZAS(null,null,'P455_PeticionEscriturasCaracterEjecutivo','5*24*60*60*1000L','0','0','PRODUCTO-946')
      ,T_TIPO_PLAZAS(null,null,'P455_EnviarDesistirWFEscrituras','5*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_AcordarFechaFirma','5*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_RevisarPropuesta','15*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_ElevarSareb','1*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_RegistrarResolucionSareb','15*24*60*60*1000L','0','0','PRODUCTO-946')  
      ,T_TIPO_PLAZAS(null,null,'P455_ComunicacionAcreditadoSareb','3*24*60*60*1000L','0','0','PRODUCTO-946')
      ,T_TIPO_PLAZAS(null,null,'P455_EnviarDesistirWFSareb','5*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_PrepararContrato','3*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_ValidacionContratoAJ','7*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_EnvioContratoAcreditado','2*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_FirmarOperacion','damePlazo(valores[''P455_AcordarFechaFirma''][''fechaPrevista''])','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_EnviarDesistirPreviaFirmaOperacion','5*24*60*60*1000L','0','0','PRODUCTO-946') 
      ,T_TIPO_PLAZAS(null,null,'P455_InformarCierreSareb','5*24*60*60*1000L','0','0','PRODUCTO-946')  
      ,T_TIPO_PLAZAS(null,null,'P455_ObtenerDocumentacionOriginal','2*24*60*60*1000L','0','0','PRODUCTO-946') 
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
         T_TIPO_TFI('P455_ObtenerAprobacionCN','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El Gestor de Deuda revisará la Actuación y observará:<br>- Si es necesario obtener la aprobación de Cumplimiento Normativo.<br>- En caso de ser necesaria la aprobación, deberá indicar si se puede continuar con la operación o no supera la revisión de prevención de blanqueo de capitales.<br><br>Además, deberá adjuntar, desde la ficha del Acreditado, la documentación necesaria.<br>En caso de tratarse de una persona física, deberá adjuntar documento de identidad (DNI, pasaporte…).<br>En caso de persona jurídica, deberá adjuntar:<br>- Escritura de constitución con estatutos, u otra con análoga información.<br>- Manifestación de titularidad real.<br>- Poder del apoderado.<br>- DNI del apoderado. <br>En ambos casos deberá adjuntar la documentación que acredite el origen de los fondos y que se precise para el análisis de PBC.<br><br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br><br>- Si el Gestor observa que todo es correcto, se continuará con la actuación.<br>- Si la operación no supera la revisión por parte del equipo de prevención de blanqueo de capitales, la siguiente tarea será “Comunicación al Acreditado CN”, para posteriormente finalizar la actuación.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ObtenerAprobacionCN','1','date','fechaAviso','Fecha aviso','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ObtenerAprobacionCN','2','combo','obtencionAprobacion','Obtención aprobación CN','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_ObtenerAprobacionCN','3','combo','revisionCorrecta','Revisión correcta',null,null,null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_ObtenerAprobacionCN','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
		,T_TIPO_TFI('P455_ComunicacionAcreditadoCN','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deberá comunicar al Acreditado la finalización de la operación.<br>A continuación, informaremos la fecha de comunicación al Acreditado.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>A continuación, saltará la tarea "Enviar a desistir WF CN".</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ComunicacionAcreditadoCN','1','date','fechaComunicacion','Fecha comunicación cliente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ComunicacionAcreditadoCN','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
        ,T_TIPO_TFI('P455_EnviarDesistirWFCN','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.<br>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnviarDesistirWFCN','1','date','fechaComunicacion','Fecha cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnviarDesistirWFCN','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
        ,T_TIPO_TFI('P455_ConfeccionarBorradorContratoAcreditado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deberá adjuntar el borrador del contrato a través de la que se informará al Acreditado de las condiciones de la operación.<br>En el campo "Requiere validación", deberá indicar si la plantilla adjuntada requiere validación por el departamento de Asesoría Jurídica.<br>En caso de Requerir Validación, saltará la tarea: " Validar borrador contrato AJ". <br>En caso contrario, saltará la tarea "Envío borrador contrato al Acreditado".</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ConfeccionarBorradorContratoAcreditado','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ConfeccionarBorradorContratoAcreditado','2','combo','requiereValidacion','Requiere validación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_ConfeccionarBorradorContratoAcreditado','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	   
		,T_TIPO_TFI('P455_ValidarBorradorContratoAJ','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se revisará el borrador del contrato para el Acreditado, incluido en la pestaña de Adjuntos.<br>A continuación, deberá informar el campo "Valida" si o no, en función de que la valoración sea positiva o negativa.<br>Si la valoración ha sido positiva, deberá informar si se adjunta el contrato con modificaciones o no se ha modificado el contrato recibido.<br>En caso de que se realicen modificaciones al contrato, deberá incluirlo en la pestaña de Adjuntos.<br>En caso de que se considere Válido el contrato, la siguiente tarea será " Envío borrador contrato al Acreditado".<br>En caso contrario, la siguiente tarea será "Comunicación al Acreditado AJ" para dar posteriormente por finalizada la operación.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ValidarBorradorContratoAJ','1','combo','valida','Valida','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_ValidarBorradorContratoAJ','2','combo','adjuntarNuevoContrato','Adjuntar nuevo contrato','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_ValidarBorradorContratoAJ','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
		,T_TIPO_TFI('P455_ComunicacionAcreditadoAJ','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras no superar la validación de Asesoría Jurídica, deberá comunicar al Acreditado la finalización de la operación.<br>A continuación, informaremos la fecha de comunicación al Acreditado.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>A continuación, saltará la tarea "Enviar a desistir WF AJ".</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ComunicacionAcreditadoAJ','1','date','fechaComunicacion','Fecha comunicación cliente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ComunicacionAcreditadoAJ','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
        ,T_TIPO_TFI('P455_EnviarDesistirWFAJ','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.<br>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnviarDesistirWFAJ','1','date','fechaComunicacion','Fecha cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnviarDesistirWFAJ','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
		,T_TIPO_TFI('P455_EnvioBorradorContratoAcreditado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se informará la fecha en que se enviará el borrador del contrato al Acreditado. <br> En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>La siguiente tarea será "Acordar fecha firma".</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnvioBorradorContratoAcreditado','1','date','Fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnvioBorradorContratoAcreditado','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
        
        ,T_TIPO_TFI('P455_PeticionEscriturasCaracterEjecutivo','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El Gestor deberá indicar si se adjuntan las escrituras con carácter ejecutivo a la operación:<br>- En caso afirmativo, deberán adjuntarse desde la pestaña Adjuntos de la actuación.<br>- En caso negativo, deberá acordar con el Acreditado si acepta o no la firma sin las escrituras.</p>Una vez rellene esta tarea:<br>- Si el Gestor adjunta las Escrituras, o en caso de no adjuntarlas el Acreditado acepta, se continuará con la operación.<br>- Si el Gestor no adjunta las escrituras y el Acreditado no acepta continuar con la operación, se lanzará la tarea “Enviar a desistir WF Escrituras”.</p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-946')
		,T_TIPO_TFI('P455_PeticionEscriturasCaracterEjecutivo','1','combo','adjuntarEscrituras','Adjuntar Escrituras','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')     
		,T_TIPO_TFI('P455_PeticionEscriturasCaracterEjecutivo','2','combo','aceptacionAcreditado','Aceptación del Acreditado sin escrituras',null,null,null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_PeticionEscriturasCaracterEjecutivo','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')

		,T_TIPO_TFI('P455_EnviarDesistirWFEscrituras','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras rechazo de la firma por parte del Acreditado ya que no se adjuntan escrituras, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.</p>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-946')
    	,T_TIPO_TFI('P455_EnviarDesistirWFEscrituras','1','combo','adjuntarNuevoContrato','Adjuntar nuevo contrato','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_EnviarDesistirWFEscrituras','2','date','fechaCierreWFEscrituras','Fecha Cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
		,T_TIPO_TFI('P455_EnviarDesistirWFEscrituras','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
        ,T_TIPO_TFI('P455_AcordarFechaFirma','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En primer lugar, deberá informar si ha obtenido la aprobación de Cumplimiento Normativo, ya que es necesaria su aprobación para fijar la fecha de firma de la operación con el Acreditado.<br>Además, debe informar la resolución a la que ha llegado con el Acreditado: <br>- Si ha aceptado la operación, en cuyo caso, deberá informar de la fecha en la que se va a celebrar la firma, quién asistirá a la firma y si se realizará en Notaría, en cuyo caso, deberá especificarse el nombre del notario.<br>- Si ha rechazado la operación, en cuyo caso deberá informar si se desiste la operación o se debe reconsiderar.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>Una vez rellene esta tarea:<br>- Si el Acreditado acepta el contrato, se lanzarán las tareas “Preparar contrato” y “Firmar operación”.<br>- Si el Acreditado decide desistir la operación, se lanzará la tarea “Enviar a desistir WF previa firma operación”.<br>- Si el Acreditado rechaza el contrato, planteando una modificación del mismo, se lanzará la tarea “Revisar propuesta”.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_AcordarFechaFirma','1','combo','comboAprobacion','Aprobación CN','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_AcordarFechaFirma','2','combo','comboResolucion','Resolución con acreditado',null,null,null,'DDResolucionAcreditado','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_AcordarFechaFirma','3','combo','comboRechazo','Acción del rechazo',null,null,null,'DDAccionRechazo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_AcordarFechaFirma','4','date','fechaPrevista','Fecha prevista de firma',null, null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_AcordarFechaFirma','5','combo','firmaNotario','Firma en Notaría','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_AcordarFechaFirma','6','text','notario','Notario',null,null,null,null,'0','PRODUCTO-946')
		,T_TIPO_TFI('P455_AcordarFechaFirma','7','combo','comboAsistencia','Asistencia a firma por',null,null,null,'DDAsistenciaAFirma','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_AcordarFechaFirma','8','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	   
		,T_TIPO_TFI('P455_RevisarPropuesta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">La propuesta ha sido rechazada por el cliente y se debe reconsiderar la propuesta para lograr satisfacer al Acreditado.<br>Una vez recogidas las nuevas condiciones, deberá elevar la propuesta a Sareb para su validación.En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_RevisarPropuesta','1','date','Fecha','fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_RevisarPropuesta','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
        ,T_TIPO_TFI('P455_ElevarSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, debe notificar a Sareb la operación propuesta para su decisión. <br>Debe informar de la fecha en que remite la propuesta a Sareb y el número de la propuesta.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ElevarSareb','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ElevarSareb','2','number','numeroPropuesta','Número propuesta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
		,T_TIPO_TFI('P455_ElevarSareb','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	   
		,T_TIPO_TFI('P455_RegistrarResolucionSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Sareb, vía Workflow, traslada la respuesta, y el gestor indica en qué fecha recibió la respuesta y la resolución.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>En el caso que Sareb que:<br>-No apruebe las nuevas condiciones, se lanzará la tarea “Comunicación al Acreditado Sareb”. <br>-Si aprueba la operación, se lanzará de nuevo la tarea " Confeccionar borrador contrato Acreditado" para iniciar el circuito de formalización.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_RegistrarResolucionSareb','1','number','numeroPropuesta','Número propuesta',null,null,'(valores[''P455_ElevarSareb''] !=null && valores[''P455_ElevarSareb''][''numeroPropuesta''] !=null) ? valores[''P455_ElevarSareb''][''numeroPropuesta''] : null',null,'0','PRODUCTO-946')
		,T_TIPO_TFI('P455_RegistrarResolucionSareb','2','date','fechaPropuesta','Fecha propuesta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_RegistrarResolucionSareb','3','combo','comboResolucion','Resolución Sareb',null,null,null,'DDFavorable','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_RegistrarResolucionSareb','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
		,T_TIPO_TFI('P455_ComunicacionAcreditadoSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras resolución desfavorable por parte de Sareb, deberá comunicar al Acreditado la finalización de la operación.<br>A continuación, informaremos la fecha de comunicación al Acreditado.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>A continuación, saltará la tarea "Enviar a desistir WF Sareb".</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ComunicacionAcreditadoSareb','1','date','fechaComunicacion','Fecha comunicación cliente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ComunicacionAcreditadoSareb','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
        ,T_TIPO_TFI('P455_EnviarDesistirWFSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.<br>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnviarDesistirWFSareb','1','date','fechaComunicacion','Fecha cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnviarDesistirWFSareb','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
		,T_TIPO_TFI('P455_PrepararContrato','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se revisarán las condiciones de la operación y se redactará el contrato, que deberá incluirse en la pestaña de Adjuntos. <br>En el campo "Requiere validación", deberá indicar si el contrato adjuntado requiere validación por el departamento de Asesoría Jurídica.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>En caso de Requerir Validación, saltará la tarea: "Validación Contrato AJ". <br>En caso contrario, saltará la tarea "Envío del contrato al Acreditado".</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_PrepararContrato','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','(valores[''P455_ElevarSareb''] !=null && valores[''P455_ElevarSareb''][''numeroPropuesta''] !=null) ? valores[''P455_ElevarSareb''][''numeroPropuesta''] : null',null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_PrepararContrato','2','combo','requiereValidacion','Requiere validación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_PrepararContrato','3','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
		,T_TIPO_TFI('P455_ValidacionContratoAJ','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se revisará el contrato incluido en la pestaña de Adjuntos.<br>A continuación, deberá informar el campo "Valida" si o no, en función de que la valoración sea positiva o negativa.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>En caso de que se considere Válido el contrato, la siguiente tarea será "Envío del contrato al Acreditado".<br>En caso contrario, la siguiente tarea será "Preparar contrato" para que el Gestor de Deuda correspondiente compruebe las condiciones.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ValidacionContratoAJ','1','combo','valida','Valida','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_ValidacionContratoAJ','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
		
		,T_TIPO_TFI('P455_EnvioContratoAcreditado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se envía el contrato al Acreditado para su validación, informándole de la fecha de la firma de formalización. <br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnvioContratoAcreditado','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','(valores[''P455_ElevarSareb''] !=null && valores[''P455_ElevarSareb''][''numeroPropuesta''] !=null) ? valores[''P455_ElevarSareb''][''numeroPropuesta''] : null',null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnvioContratoAcreditado','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
		
		,T_TIPO_TFI('P455_FirmarOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar como finalizada esta tarea, debe informar la fecha en la que se formalizó la operación y adjuntar desde la pestaña de Adjuntos de la Actuación el resto de documentación necesaria para la formalización de la operación.</p>Deberá confirmar las condiciones de la operación.</p>Una vez formalizada la operación y completada esta tarea, se lanzarán las tareas “Obtener documentación original” y “Contabilizar operación”.</p>En caso de que no se lleve a cabo la formalización, saltará la tarea “Enviar a desistir WF previa firma operación”.</p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_FirmarOperacion','1','combo','formalizada','Formalizada operación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-946')
		,T_TIPO_TFI('P455_FirmarOperacion','2','date','fechaPrevista','Fecha prevista de firma',null,null,'(valores[''P455_AcordarFechaFirma''] !=null && valores[''P455_AcordarFechaFirma''][''fechaPrevista''] !=null) ? valores[''P455_AcordarFechaFirma''][''fechaPrevista''] : null',null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_FirmarOperacion','3','date','fechaReal','Fecha real de firma',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_FirmarOperacion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
		 
        ,T_TIPO_TFI('P455_EnviarDesistirPreviaFirmaOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras rechazo del Acreditado previa firma de la operación, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnviarDesistirPreviaFirmaOperacion','1','date','fechaCierre','Fecha cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_EnviarDesistirPreviaFirmaOperacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	
        ,T_TIPO_TFI('P455_InformarCierreSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no. En el campo "Conflicto de intereses" deberá consignar la existencia de conflicto o no, que le impida aceptar la dirección de la acción a instar, en caso de que haya conflicto de intereses no se le permitirá la aceptación del Asunto. En el campo "Aceptación del asunto " deberá indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deberá marcar, en todo caso, la no aceptación del asunto.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>Una vez rellene esta pantalla la siguiente tarea será "Revisar asignación de letrado”  en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado, en caso de haber aceptado el asunto se dará por terminada esta actuación.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_InformarCierreSareb','1','date','fechaCierre','Fecha cierre Sareb','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_InformarCierreSareb','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')

		,T_TIPO_TFI('P455_ObtenerDocumentacionOriginal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez formalizada la operación, el gestor de deuda debe recopilar toda la documentación firmada.<br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ObtenerDocumentacionOriginal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
        ,T_TIPO_TFI('P455_ObtenerDocumentacionOriginal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
		,T_TIPO_TFI('P455_ContabilizarOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para finalizar con esta tarea, se debe informar de la que fecha en la que ha contabilizado la operación en NOS.</p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-946')
    	,T_TIPO_TFI('P455_ContabilizarOperacion','1','date','Fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-946')
		,T_TIPO_TFI('P455_ContabilizarOperacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-946')
	    
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
        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || ''')' || 
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
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
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