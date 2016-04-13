/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-948
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Trámite de Dación en pago
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
      T_TIPO_TPO('P453','T. de circuito de Dacion en pago','T. de circuito de Dacion en pago',null,'tramiteDacionEnPago','0','PRODUCTO-948','0','ACU',null,null,'1','MEJTipoProcedimiento','1','0')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       T_TIPO_TAP('P453','P453_DefinirDocumentacionAportar',null,null,null,null,null,'0','Definir documentación a aportar','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGEA',null,'SADQ',null)
       ,T_TIPO_TAP('P453','P453_AdjuntarDueDiligenceJuridica',null,null,null,null,null,'0','Adjuntar due diligence jurídica','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGEA',null,'SADQ',null)
       ,T_TIPO_TAP('P453','P453_AdjuntarDueDiligenceTecnica',null,null,null,null,null,'0','Adjuntar due diligence técnica','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGEA',null,'SADQ',null)
       ,T_TIPO_TAP('P453','P453_ObtenerAprobacionCN','plugin/procedimientos-bpmHaya-plugin/tramiteDacionEnPago/obtenerAprobacionCN',null,'(valores[''P453_ObtenerAprobacionCN''][''comboObtencionAprobacionCN''] == DDSiNo.SI && valores[''P453_ObtenerAprobacionCN''][''comboRevisionCorrecta''] == null) ? ''El campo revisión correcta es obligatorio'' : null','valores[''P453_ObtenerAprobacionCN''][''comboObtencionAprobacionCN''] == DDSiNo.SI ? ''si'':''no''',null,'0','Obtener aprobación CN','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,'GCN',null)
       ,T_TIPO_TAP('P453','P453_ComunicacionAcreditado',null,null,null,null,null,'0','Comuniación acreditado CN','0','PRODUCTO-948','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_EnviarDesistirWF',null,null,null,null,null,'0','Enviar a desistir WF CN','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_ConfeccionarNegociarSupervisarMinuta',null,null,null,'valores[''P453_ConfeccionarNegociarSupervisarMinuta''][''comboRequiereAutorizacion''] == DDSiNo.SI ? ''si'':''no''',null,'0','Confeccionar, negociar y supervisar minuta','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGEA',null,'SADQ',null)
       ,T_TIPO_TAP('P453','P453_RegistrarValidacionMinutaPorSareb',null,null,null,'valores[''P453_RegistrarValidacionMinutaPorSareb''][''comboResolucion''] == DDFavorable.FAVORABLE ? ''si'':''no''',null,'0','Registrar validacion minuta por Sareb','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'TGEA',null,'SADQ',null)
       ,T_TIPO_TAP('P453','P453_ComunicacionAcreditadoSareb',null,null,null,null,null,'0','Comunicación acreditado Sareb','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_EnviarDesistirWFSareb',null,null,null,null,null,'0','Enviar desistir WF Sareb','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_AcordarFechaFirma','plugin/procedimientos-bpmHaya-plugin/tramiteDacionEnPago/acordarFechaFirma',null,'(valores[''P453_AcordarFechaFirma''][''comboResolucion''] == ''ACE'' && (valores[''P453_AcordarFechaFirma''][''fechaPrevista''] == null || valores[''P453_AcordarFechaFirma''][''comboAsistencia''] == null)) ? ''Hay campos obligatorios pendientes de rellenar'' : (valores[''P453_AcordarFechaFirma''][''fechaFirmaNotaria''] == DDSiNo.SI && valores[''P453_AcordarFechaFirma''][''notario''] == null  ? ''El campo notario es obligatorio'' : null)','valores[''P453_AcordarFechaFirma''][''comboAprobacion''] == ''01'' ? ''si'' : (valores[''P453_AcordarFechaFirma''][''comboResolucion''] == ''ACE'' ? ''si'' : ''no'')',null,'0','Acordar fecha firma','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_FirmarOperacion','plugin/procedimientos-bpmHaya-plugin/tramiteDacionEnPago/firmarOperacion',null,'(valores[''P453_FirmarOperacion''][''formalizada''] == DDSiNo.SI && (valores[''P453_FirmarOperacion''][''fechaReal''] == null || valores[''P453_FirmarOperacion''][''fechaRenovacion''] == null || valores[''P453_FirmarOperacion''][''fechaFin''] == null)) ? ''Hay campos obligatorios pendientes de rellenar'' : null','valores[''P453_FirmarOperacion''][''comboFormalizadaOperacion''] == DDSiNo.SI ? ''si'':''no''',null,'0','Firmar operación','0','PRODUCTO-948','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_ObtenerDocumentacionOriginal',null,null,null,null,null,'0','Obtener documentación original','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_InformarCierreSareb',null,null,null,null,null,'0','Informar cierre Sareb','0','PRODUCTO-948','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_ContabilizarOperacion',null,null,null,null,null,'0','Contabilizar operación','0','PRODUCTO-948','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'805',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_EnviarDesisitirPreviaFirmaOperacion',null,null,null,null,null,'0','Enviar a desisitir previa firma operación','0','PRODUCTO-948','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'803',null,'SDEU',null)
       ,T_TIPO_TAP('P453','P453_BPMTramiteInscripcionDelTitulo',null,null,null,null,'H066','0','Se inicia el trámite de inscripción del título.','0','PRODUCTO-948','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'803',null,null,null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
      T_TIPO_PLAZAS(null,null,'P453_DefinirDocumentacionAportar','2*24*60*60*1000L','0','0','PRODUCTO-948')
      ,T_TIPO_PLAZAS(null,null,'P453_AdjuntarDueDiligenceJuridica','5*24*60*60*1000L','0','0','PRODUCTO-948')
      ,T_TIPO_PLAZAS(null,null,'P453_AdjuntarDueDiligenceTecnica','5*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_ObtenerAprobacionCN','7*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_ComunicacionAcreditado','3*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_EnviarDesistirWF','5*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_ConfeccionarNegociarSupervisarMinuta','20*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_RegistrarValidacionMinutaPorSareb','15*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_ComunicacionAcreditadoSareb','3*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_EnviarDesistirWFSareb','5*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_AcordarFechaFirma','5*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_FirmarOperacion','(valores[''P453_AcordarFechaFirma''] !=null && valores[''P453_AcordarFechaFirma''][''fechaPrevista''] !=null) ? damePlazo(valores[''P453_AcordarFechaFirma''][''fechaPrevista'']) : 5*24*60*60*1000L','0','0','PRODUCTO-948')
      ,T_TIPO_PLAZAS(null,null,'P453_ObtenerDocumentacionOriginal','5*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_InformarCierreSareb','5*24*60*60*1000L','0','0','PRODUCTO-948') 
      ,T_TIPO_PLAZAS(null,null,'P453_ContabilizarOperacion','5*24*60*60*1000L','0','0','PRODUCTO-948')
      ,T_TIPO_PLAZAS(null,null,'P453_EnviarDesisitirPreviaFirmaOperacion','5*24*60*60*1000L','0','0','PRODUCTO-948')
      ,T_TIPO_PLAZAS(null,null,'P453_BPMTramiteInscripcionDelTitulo','300*24*60*60*1000L','0','0','PRODUCTO-948')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
         T_TIPO_TFI('P453_DefinirDocumentacionAportar','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea deberemos definir si es necesario o no:<br>- Adjuntar la Due Diligence Jurídica<br>- Adjuntar la Due Diligence Técnica<br>- Revisión de la operación por el Departamento de Prevención de Blanqueo de Capitales (por entrega dineraria).</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_DefinirDocumentacionAportar','1','combo','comboJuridica','Adjuntar Due Diligence Jurídica','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_DefinirDocumentacionAportar','2','combo','comboTecnica','Adjuntar Due Diligence Técnica','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-948')
		    ,T_TIPO_TFI('P453_DefinirDocumentacionAportar','3','combo','comboValidacionCN','Validación CN','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-948')
		    ,T_TIPO_TFI('P453_DefinirDocumentacionAportar','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')
	    
		    ,T_TIPO_TFI('P453_AdjuntarDueDiligenceJuridica','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada la tarea, debe adjuntar en la pestaña de adjuntos de la Actuación, la due diligence jurídica, que recoja el análisis del activo desde el punto de vista legal y fiscal.</p><p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento. La due se realiza por externo homologado. La contratación de la due se realiza por equipo Adquisiciones dentro de las funciones delegadas con cargo a Sareb.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AdjuntarDueDiligenceJuridica','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AdjuntarDueDiligenceJuridica','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')
	    
        ,T_TIPO_TFI('P453_AdjuntarDueDiligenceTecnica','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada la tarea, debe adjuntar en la pestaña de adjuntos de la Actuación, la due diligence técnica, que recoja el análisis del activo desde el punto de vista técnico o urbanístico.</p><p> En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento. La due se realiza por externo homologado. La contratación de la due se realiza por equipo Adquisiciones dentro de las funciones delegadas con cargo a Sareb.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AdjuntarDueDiligenceTecnica','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AdjuntarDueDiligenceTecnica','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')
	    
        ,T_TIPO_TFI('P453_ObtenerAprobacionCN','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El Gestor de Deuda revisará la Actuación y observará:<br>- Si es necesario obtener la aprobación de Cumplimiento Normativo.<br>- En caso de ser necesaria la aprobación, deberá indicar si se puede continuar con la operación o no supera la revisión de prevención de blanqueo de capitales.<br><br>Además, deberá adjuntar, desde la ficha del Acreditado, la documentación necesaria.<br>En caso de tratarse de una persona física, deberá adjuntar documento de identidad (DNI, pasaporte…).<br>En caso de persona jurídica, deberá adjuntar:<br>- Escritura de constitución con estatutos, u otra con análoga información.<br>- Manifestación de titularidad real.<br>- Poder del apoderado.<br>- DNI del apoderado. <br>En ambos casos deberá adjuntar la documentación que acredite el origen de los fondos y que se precise para el análisis de PBC.<br><br>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.<br>- Si el Gestor observa que todo es correcto, se continuará con la actuación.<br>- Si la operación no supera la revisión por parte del equipo de prevención de blanqueo de capitales, la siguiente tarea será “Comunicación al cliente”, para posteriormente finalizar la actuación.<br></p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ObtenerAprobacionCN','1','date','fechaAviso','Fecha aviso','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ObtenerAprobacionCN','2','combo','comboObtencionAprobacionCN','Obtención aprobación CN','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ObtenerAprobacionCN','3','combo','comboRevisionCorrecta','Revisión correcta',null,null,null,'DDSiNo','0','PRODUCTO-948')
		    ,T_TIPO_TFI('P453_ObtenerAprobacionCN','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')
	   
		    ,T_TIPO_TFI('P453_ComunicacionAcreditado','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se deberá comunicar al Acreditado la finalización de la operación. A continuación, informaremos la fecha de comunicación al Acreditado.</p><p> En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento. A continuación, saltará la tarea "Enviar a desistir WF".</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ComunicacionAcreditado','1','date','fechaComunicacionCliente','Fecha comunicación cliente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
		    ,T_TIPO_TFI('P453_ComunicacionAcreditado','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')

        ,T_TIPO_TFI('P453_EnviarDesistirWF','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF. Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_EnviarDesistirWF','1','date','fechaCierre','Fecha Cierre WF CN cliente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_EnviarDesistirWF','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')

		    ,T_TIPO_TFI('P453_ConfeccionarNegociarSupervisarMinuta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea, deberá adjuntarse el borrador de minuta de Dación.</p><p>El equipo de HRE-Adquisiciones supervisa y valida el borrador de minuta preparado por el despacho jurídico externo una vez negociado.</p><p>En el caso de que se requiera autorización de Sareb, debido a que sea necesario validar ciertas cláusulas de la minuta, susceptibles de revisión por parte de Sareb, se indicará con un Sí en el campo “Requiere autorización de Sareb”.</p><p>En caso de no ser necesario requerir la validación de la minuta por parte de Sareb,  se lanzará la siguiente  tarea “Informar de la fecha firma para la formalización” para formalizar la operación.</p><p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ConfeccionarNegociarSupervisarMinuta','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ConfeccionarNegociarSupervisarMinuta','2','number','numeroPropuesta','Número propuesta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ConfeccionarNegociarSupervisarMinuta','3','combo','comboRequiereAutorizacion','Requiere autorización','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ConfeccionarNegociarSupervisarMinuta','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')
	    
        ,T_TIPO_TFI('P453_RegistrarValidacionMinutaPorSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Si procede, el equipo de FACTORIA DE DACIONES de Sareb (han cambiado de nombre), vía workflow o vía anotación, traslada la respuesta al gestor de adquisiciones”</p><p>En el caso que Sareb:<br>-Autorice la minuta, saltará a la siguiente  tarea “Informar de la fecha firma para la formalización” para formalizar la operación.<br>-Autorice la propuesta, saltará la siguiente tarea “Acordar fecha firma”.<br>-No Autorice la minuta y, por tanto, la resolución sea desfavorable saltará a la tarea “Comunicación al Acreditado Sareb”.</p><p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_RegistrarValidacionMinutaPorSareb','1','date','fechaPropuesta','Fecha propuesta Sareb',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_RegistrarValidacionMinutaPorSareb','2','number','numeroPropuesta','Número propuesta',null,null,'valores[''P453_ConfeccionarNegociarSupervisarMinuta''][''numeroPropuesta'']',null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_RegistrarValidacionMinutaPorSareb','3','combo','comboResolucion','Resolución de Sareb',null,null,null,'DDFavorable','0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_RegistrarValidacionMinutaPorSareb','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')
	   
		,T_TIPO_TFI('P453_ComunicacionAcreditadoSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras resolución desfavorable por parte de Sareb, deberá comunicar al Acreditado la finalización de la operación. A continuación, informaremos la fecha de comunicación al Acreditado.</p><p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.A continuación, saltará la tarea "Enviar a desistir WF Sareb".</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ComunicacionAcreditadoSareb','1','date','fechaComunicacionCliente','Fecha comunicacion cliente','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ComunicacionAcreditadoSareb','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')
	    
        ,T_TIPO_TFI('P453_EnviarDesistirWFSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.</p><p>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_EnviarDesistirWFSareb','1','date','fechaCierreWF','Fecha cierre WF','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
		,T_TIPO_TFI('P453_EnviarDesistirWFSareb','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')

        ,T_TIPO_TFI('P453_AcordarFechaFirma','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En primer lugar, deberá informar si ha obtenido la aprobación de Cumplimiento Normativo, ya que es necesaria su aprobación para fijar la fecha de firma de la operación con el Acreditado.</p><p>Además, debe informar la resolución a la que ha llegado con el Acreditado: <br>- Si ha aceptado la operación, en cuyo caso, deberá informar de la fecha en la que se va a celebrar la firma, quién asistirá a la firma y si se realizará en Notaría, en cuyo caso, deberá especificarse el nombre del notario.<br>- Si ha rechazado la operación, en cuyo caso deberá informar si se desiste la operación o se debe reconsiderar.</p><p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p>Una vez rellene esta tarea:<br>- Si el Acreditado acepta el contrato, se lanzará la tarea  “Firmar operación”.<br>- Si el Acreditado decide desistir la operación, se lanzará la tarea “Enviar a desistir WF previa firma operación”.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AcordarFechaFirma','1','combo','comboAprobacion','Aprobación CN','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AcordarFechaFirma','2','combo','comboResolucion','Resolución con acreditado',null,null,null,'DDResolucionAcreditado','0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AcordarFechaFirma','3','date','fechaPrevista','Fecha prevista de firma',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AcordarFechaFirma','4','date','fechaFirmaNotaria','Firma en notaría','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AcordarFechaFirma','5','text','notario','Notario',null, null, null, null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AcordarFechaFirma','6','combo','comboAsistencia','Asistencia a firma',null,null,null,'DDAsistenciaAFirma','0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_AcordarFechaFirma','7','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')

        ,T_TIPO_TFI('P453_FirmarOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar como finalizada esta tarea, debe informar la fecha en la que se formalizó la operación y adjuntar desde la pestaña de Adjuntos de la Actuación el resto de documentación necesaria para la formalización de la operación.<br>Deberá confirmar las condiciones de la operación.</p><p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p>Una vez formalizada la operación y completada esta tarea, se lanzarán las tareas “Obtener documentación original” y “Contabilizar operación” y se lanzará el Trámite de Inscripción del Título.</p><p>En caso de que no se lleve a cabo la formalización, saltará la tarea “Enviar a desistir WF previa firma operación”.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_FirmarOperacion','1','combo','comboFormalizadaOperacion','Formalizada operacion','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_FirmarOperacion','2','date','fechaPrevista','Fecha Prevista de Firma',null,null,'(valores[''P453_AcordarFechaFirma''] !=null && valores[''P453_AcordarFechaFirma''][''fechaPrevista''] !=null) ? valores[''P453_AcordarFechaFirma''][''fechaPrevista''] : null',null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_FirmarOperacion','3','date','fechaRealFirma','Fecha real de firma','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_FirmarOperacion','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')

        ,T_TIPO_TFI('P453_ObtenerDocumentacionOriginal','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">El Gestor deberá adjuntar la documentación original de la operación.</p><p>Una vez completada esta tarea se procederá a informar del cierre de la operación a Sareb.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ObtenerDocumentacionOriginal','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ObtenerDocumentacionOriginal','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')

        ,T_TIPO_TFI('P453_InformarCierreSareb','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea, se adjuntará en la pestaña de Adjuntos de la actuación toda la documentación obligatoria a Sareb para que éste lleve a cabo su cierre:<br>- Documento justificativo del ingreso en cuenta de Sareb.</p><p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_InformarCierreSareb','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_InformarCierreSareb','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')

        ,T_TIPO_TFI('P453_ContabilizarOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para finalizar con esta tarea, se debe informar de la que fecha en la que ha contabilizado la operación en NOS.</p><p>En el campo observaciones deberá informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ContabilizarOperacion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_ContabilizarOperacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')

        ,T_TIPO_TFI('P453_EnviarDesisitirPreviaFirmaOperacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras rechazo del Acreditado previa firma de la operación, el Gestor de Deuda deberá realizar todas aquellas acciones para cerrar el WF.</p><p>Una vez completada esta tarea, se dará por finalizada la formalización de la operación.</p></div>',null,null,null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_EnviarDesisitirPreviaFirmaOperacion','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-948')
        ,T_TIPO_TFI('P453_EnviarDesisitirPreviaFirmaOperacion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-948')
	   
        ,T_TIPO_TFI('P453_BPMTramiteInscripcionDelTitulo','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se inicia el trámite de inscripción de título</p></div>',null,null,null,null,'0','PRODUCTO-948')
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
        	' DD_TSUP_ID = (SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||                    
            ' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
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
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
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