/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Procedimiento Cambiario
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


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    
    --FALTA CAMBIAR LA RUTA DE LAS JSP
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('CJPCO','CJPCO_PreTurnadoManual' ,null ,null ,null ,'valores[''CJPCO_PreTurnadoManual''][''preTurnado''] == DDSiNo.SI ? (valores[''CJPCO_PreTurnadoManual''][''automatico''] == DDSiNo.SI ? ''automatico'' : ''manual'') : ''posturnado''' ,null ,'0','Seleccionar tipo de turnado' ,'0','RECOVERY-2026','1' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_PreTurnado' ,null ,null ,null ,null ,null ,'0','Preturnado automatico' ,'0','RECOVERY-2026','1' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RegistrarAceptacion' ,null ,null ,null ,'valores[''CJPCO_RegistrarAceptacion''][''aceptacion''] == DDSiNo.SI ? ''aceptacion'' : ''no_aceptacion''' ,null ,'0','Registrar aceptación del asunto' ,'0','RECOVERY-2026','1' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RevisarNoAceptacion' ,'plugin/precontencioso/tramite/revisarNoAceptacion' ,null ,null ,null ,null ,'0','Revisar no aceptación del asunto' ,'0','RECOVERY-2026','1' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RevisarExpediente' ,null ,null ,null ,null ,null ,'0','Revisar expediente a preparar' ,'0','RECOVERY-2026','1' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_PrepararExpediente' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,'dameTipoAsunto()' ,null ,'0','Preparar expediente' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_SolicitarDoc' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Solicitar documentación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_PostTurnado' ,null ,null ,null ,null ,null ,'0','PostTurnado automatico' ,'0','RECOVERY-2026','1' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RegistrarAceptacionPost' ,'plugin/precontencioso/tramite/registrarAceptacionAsunto' ,null ,'valores[''CJPCO_RegistrarAceptacionPost''][''conflicto_intereses'']==DDSiNo.NO && valores[''CJPCO_RegistrarAceptacionPost''][''fecha_aceptacion''] == null  ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">En caso de indicar Conflicto Intereses NO, para completar la tarea debera rellenar el campo Fecha de Aceptación'' : null ' ,'valores[''CJPCO_RegistrarAceptacionPost''][''aceptacion''] == DDSiNo.SI ? ''aceptacion'' : ''no_aceptacion''' ,null ,'0','Registrar aceptación del asunto' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RevisarNoAceptacionPost' ,'plugin/precontencioso/tramite/revisarNoAceptacion' ,null ,null ,null ,null ,'0','Revisar no aceptación del asunto' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_EnviarExpedienteLetrado' ,null ,null ,null ,null ,null ,'0','Enviar expediente a letrado' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RegistrarTomaDec' ,'plugin/precontencioso/tramite/registrarTomaDec' ,null ,null ,'valores[''CJPCO_RegistrarTomaDec''][''correcto''] == DDSiNo.SI ? ''ok'' : (valores[''CJPCO_RegistrarTomaDec''][''tipo_problema''] == ''CPR'' ? ''cambio_proc'' : ''requiere_subsanar'')' ,null ,'0','Confirmar documentación y procedimiento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RevisarSubsanacion' ,null ,null ,null ,'valores[''CJPCO_RevisarSubsanacion''][''subsanar''] == DDSiNo.SI ? ''subsanar'' : ''devolver'' ' ,null ,'0','Revisar subsanacion propuesta' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_IniciarProcJudicial' ,null ,null ,null ,null ,null ,'0','Iniciar procedimiento judicial' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_SubsanarIncidenciaExp' ,'plugin/precontencioso/tramite/subsanarIncidenciaExp' ,null ,null ,null ,null ,'0','Subsanar incidencia de expediente' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_ValidarCambioProc' ,'plugin/precontencioso/tramite/validarCambioProc' ,null ,null ,'valores[''CJPCO_ValidarCambioProc''][''cambio_aceptado''] == DDSiNo.NO ? ''no'' : (valores[''CJPCO_ValidarCambioProc''][''nueva_preparacion''] == DDSiNo.SI ? ''si_nueva_preparacion'' : ''si_sin_nueva_prep'')' ,null ,'0','Validar cambio de procedimiento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_SubsanarCambioProc' ,null ,null ,null ,null ,null ,'0','Subsanar por cambio de procedimiento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RegResultadoExped' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Registrar resultado para expediente' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RecepcionExped' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Registrar recepción expediente' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RegResultadoDoc' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Registrar resultado para documento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RegEnvioDoc' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Registrar envío del documento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RecepcionDoc' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Registrar recepción del documento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_AdjuntarDoc' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Adjuntar documentación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_GenerarLiq' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Generar liquidación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_ConfirmarLiq' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Confirmar liquidación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_EnviarBurofax' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Enviar burofax' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_AcuseReciboBurofax' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Registrar acuse de recibo de burofax' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RegResultadoDocG' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'0','Registrar resultado para documento (Gestoría)' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_DecTipoProcAutomatica' ,'dameTipoAsunto()' ,null ,null ,null ,null ,'0','Decisión TipoProcedimiento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_AsignacionGestores' ,null ,null ,null ,'existenGestoresCorrectos() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El asunto debe tener asignado Letrado, Supervisor del asunto, Director unidad de litigio y Preparador documental.</div>''' ,null ,'1','Asignación de Gestores' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RevisarExpDigCONC' ,null ,null ,null ,'valores[''CJPCO_RevisarExpDigCONC''][''docCompleta''] == DDSiNo.SI ?  ''ok'' : ''requiere_subsanar''' ,null ,'0','Revisar Expediente Digital' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RevisarSubsanacionCONC' ,null ,null ,null ,'valores[''CJPCO_RevisarSubsanacionCONC''][''subsanar''] == DDSiNo.SI ? ''subsanar'' : ''devolver''' ,null ,'1','Revisar Subsanación Propuesta' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_ResolverIncidenciaExpCONC' ,null ,null ,null ,null ,null ,'0','Resolver Incidencia en Expediente' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_VisarLiq' ,'plugin/precontencioso/tramite/preparacion' ,null ,null ,null ,null ,'1','Visar factura' ,'0','RECOVERY-2026','1' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RevisarExpedientePreparar' ,'plugin/precontencioso/tramite/revisarExpedientePreparar' ,'compruebaRiesgoOperacional() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea todos los contratos del asunto deben tener asignado un Riego Operacional.</div>''' ,'valores[''CJPCO_RevisarExpedientePreparar''][''gestion'']==''JUDICIALIZAR'' && noExisteGestorDocumentacionAsignadoAsunto() ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">En caso de indicar en el campo Gesti&oacute;n el valor "Judicializar", para completar la tarea deber&aacute; haber un Gestor de la Documentaci&oacute;n asignado al asunto'' : null ' ,'valores[''CJPCO_RevisarExpedientePreparar''][''gestion''] != ''JUDICIALIZAR'' ? ''fin'': ''judicializar''' ,null ,'0','Revisar expediente a preparar' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_AsignarGestorLiquidacion' ,null ,'comprobarExisteGestorLiquidacion() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea el asunto debe de tener asignado el tipo de gestor Gestor de liquidación.</div>'' ' ,null ,null ,null ,'0','Asignar gestor de liquidación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_RevisarExpedienteAsignarLetrado' ,'plugin/precontencioso/tramite/revisarExpedienteAsignarLetrado' ,'comprobarExisteLetrado() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea deberá haber un letrado asignado al asunto.</div>'' ' ,null ,'valores[''CJPCO_RevisarExpedienteAsignarLetrado''][''expediente_correcto''] == DDSiNo.NO ? ''reabreExp'': ''registrar'' ' ,null ,'0','Revisar expediente y Asignar letrado' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_PreasignarProcurador' ,null ,'asuntoConProcuradorPrecontencioso() == ''0'' ? ''Error: Debe asignar un procurador al asunto'' : null' ,null ,null ,null ,'0','Preasignar procurador' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_ConfirmarProcurador' ,null ,'asuntoConProcuradorPrecontencioso() == ''0'' ? ''Error: Debe asignar un procurador al asunto'' : null' ,null ,null ,null ,'0','Confirmar procurador' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_BPMTramiteEnvioDemanda' ,null ,null ,null ,null ,'CJ106' ,'0','Se inicia el trámite envío de la demanda' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJPCO','CJPCO_ValidarAsignacion' ,null ,null ,null ,null ,null ,'0','Validar asignación' ,'0','RECOVERY-2026','1' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJPCO_PreTurnado','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RegistrarAceptacion','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_PreTurnadoManual','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RevisarNoAceptacion','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RevisarExpediente','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_PrepararExpediente','45*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_SolicitarDoc','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_PostTurnado','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RegistrarAceptacionPost','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RevisarNoAceptacionPost','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_EnviarExpedienteLetrado','dameFechaFinalizacionTareasPrecedentes() + 2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RegistrarTomaDec','dameFechaUltimoEnvioExp() + 7*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RevisarSubsanacion','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_IniciarProcJudicial','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_SubsanarIncidenciaExp','valores[''CJPCO_EnviarExpedienteLetrado''] != null && valores[''CJPCO_EnviarExpedienteLetrado''][''fecha_envio''] != null && valores[''CJPCO_EnviarExpedienteLetrado''][''fecha_envio''] != '''' ? damePlazo(valores[''CJPCO_EnviarExpedienteLetrado''][''fecha_envio''])+10*24*60*60*1000L : 10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_ValidarCambioProc','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_SubsanarCambioProc','damePlazo(valores[''CJPCO_EnviarExpedienteLetrado''][''fecha_envio''])+10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RegResultadoExped','dameFechaSolicitudExpediente() + 2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RecepcionExped','dameFechaResultadoArchivo() + 15*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RegResultadoDoc','dameFechaSolicitudDocumentos() + 2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RegEnvioDoc','dameFechaSolicitudDocumentos() + 2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RecepcionDoc','dameFechaEnvio() + 2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_AdjuntarDoc','10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_GenerarLiq','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_ConfirmarLiq','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_EnviarBurofax','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_AcuseReciboBurofax','10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RegResultadoDocG','dameFechaSolicitudDocumentos() + 2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_DecTipoProcAutomatica','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_AsignacionGestores','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RevisarExpDigCONC','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RevisarSubsanacionCONC','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_ResolverIncidenciaExpCONC','10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_VisarLiq','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RevisarExpedientePreparar','10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_AsignarGestorLiquidacion','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_RevisarExpedienteAsignarLetrado','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_PreasignarProcurador','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_ConfirmarProcurador','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJPCO_BPMTramiteEnvioDemanda','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
	    T_TIPO_PLAZAS(null ,null ,'CJPCO_ValidarAsignacion','1*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJPCO_PreTurnadoManual','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Introduzca el nombre del letrado y del procurador que gestionaran este asunto.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PreTurnadoManual','1','combo' ,'preTurnado','Preturnado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PreTurnadoManual','2','combo' ,'automatico','Automático' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PreTurnadoManual','3','text' ,'letrado','Letrado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PreTurnadoManual','4','text' ,'procurador','Procurador' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PreTurnado','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Cálculo automático el nombre del letrado y del procurador que gestionaran este asunto.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p><p style="margin-bottom: 10px">En el campo "Conflicto de intereses" deberá consignar la existencia de conflicto o no, que le impida aceptar la dirección de la acción a instar, en caso de que haya conflicto de intereses no se le permitirá la aceptación del Asunto.</p><p style="margin-bottom: 10px">En el campo "Aceptación del asunto " deberá indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deberá marcar, en todo caso, la no aceptación del asunto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Revisar expediente" en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacion','1','combo' ,'conflicto_intereses','Conflicto intereses' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacion','2','combo' ,'aceptacion','Aceptación  asunto' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacion','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea debe validar la asignación de letrado dada por el sistema de turnado. En caso de no serlo, por favor, reasigne convenientemente a través de la pestaña Gestores del asunto.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacion','1','date' ,'fecha_validacion','Fecha validación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacion','2','text' ,'anterior_letrado','Anterior letrado' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacion','3','text' ,'nuevo_letrado','Letrado asignado' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacion','4','combo' ,'asignacion_correcta','Asignación correcta' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacion','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpediente','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deberá revisar la preparación documental que se va a iniciar. A través de la pestaña “Preparación documental” de la actuación, deberá comprobar que están todos los documentos requeridos para la interposición de la demanda o presentación del concurso, que todos los contratos a generar liquidación están incluidos y por último, que todas las personas que se debe notificar están incluidas en el área de gestión de burofaxes.</p>En caso de considerar necesaria la paralización de la preparación del expediente judicial, puede prorrogar esta tarea hasta que estime oportuno a través de la solicitud de una prórroga. De igual modo, en caso de encontrarse en negociación de un acuerdo extrajudicial, regístrelo a través de la pestaña Acuerdos de la ficha del asunto correspondiente.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento. </p>Una vez complete esta tarea se iniciará la preparación del expediente judicial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpediente','1','date' ,'fecha_revision','Fecha revisión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpediente','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PrepararExpediente','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Pantalla principal de la preparación del expediente.</p></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PrepararExpediente','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SolicitarDoc','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Cálculo automático el nombre del letrado y del procurador que gestionaran este asunto.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SolicitarDoc','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PostTurnado','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Cálculo automático el nombre del letrado y del procurador que gestionaran este asunto.</p>PostTurnado</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacionPost','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p>En el campo "Conflicto de intereses" deberá consignar la existencia de conflicto o no, que le impida aceptar la dirección de la acción a instar, en caso de que haya conflicto de intereses no se le permitirá la aceptación del Asunto.</p>En el campo "Aceptación del asunto " deberá indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deberá marcar, en todo caso, la no aceptación del asunto.</p>Una vez rellene esta pantalla la siguiente tarea será "Revisar expediente" en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacionPost','1','combo' ,'conflicto_intereses','Conflicto intereses' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacionPost','2','combo' ,'aceptacion','Aceptación  asunto' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'valores[''PCO_RegistrarAceptacionPost''][''conflicto_intereses''] == DDSiNo.SI ? DDSiNo.NO : null' ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacionPost','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarAceptacionPost','4','date' ,'fecha_aceptacion','Fecha de aceptación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacionPost','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea debe validar la asignación de letrado y procurador dada por el sistema de turnado. En caso de no serlo, por favor, reasigne convenientemente a través de la pestaña Gestores del asunto.</p>En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacionPost','1','date' ,'fecha_validacion','Fecha validación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacionPost','2','text' ,'anterior_letrado','Anterior letrado' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacionPost','3','text' ,'nuevo_letrado','Letrado asignado' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacionPost','4','combo' ,'asignacion_correcta','Asignación correcta' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarNoAceptacionPost','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_EnviarExpedienteLetrado','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez en disposición de toda la documentación requerida por el expediente de prelitigio, a través de esta pantalla deberá indicar la fecha en que procede al envío de dicha documentación al letrado correspondiente.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez complete esta tarea se dará por terminada la preparación documental del expediente de prelitigio, dando así inicio a la fase judicial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_EnviarExpedienteLetrado','1','date' ,'fecha_envio','Fecha envío' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_EnviarExpedienteLetrado','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deberá consignar la fecha en la que recibe la documentación, en el campo “Documentación completa y correcta” deberá indicar si la documentación del expediente efectivamente es completa y correcta o no. En caso de no ser completa deberá indicar el problema detectado según sea por Documentos, Requerimientos, Liquidaciones o por requerir nueva documentación al cambiar el tipo de procedimiento a iniciar.</p>En el campo "Procedimiento propuesto por la entidad" se le indica el tipo de procedimiento propuesto por la entidad. En caso de estar de acuerdo con dicha propuesta de actuación, deberá consignar en el campo "Procedimiento a iniciar" el mismo tipo de procedimiento, en caso contrario, deberá seleccionar otro procedimiento según su criterio.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>Una vez rellene esta pantalla y en función de la información facilitada podrán darse las siguientes situaciones:</p><li>En caso de haber encontrado un problema en la Documentación, liquidaciones o Requerimientos se iniciará la tarea “Revisar subsanación propuesta” a realizar por la entidad.</li><li>En caso de haber propuesto un cambio de procedimiento se iniciará la tarea “Validar cambio de procedimiento” a realizar por la entidad.</li><li>En caso de no haber encontrado error en la documentación y de haber seleccionado el mismo tipo de procedimiento que el comité se iniciará dicho procedimiento</li></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','1','date' ,'fecha_recepcion','Fecha recepción documentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','2','combo' ,'correcto','Documentación completa y correcta' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','3','date' ,'fecha_envio_doc','Fecha envío documentación para subsanación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','4','combo' ,'tipo_problema','Tipo de problema en expediente (Documentación, Requerimiento, Liquidaciones, Cambio de procedimiento)' ,null ,null ,null ,'DDTipoProblemaDocPco','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','5','combo' ,'proc_propuesto','Procedimiento propuesto por la entidad' ,null ,null ,'(valores[''CJPCO_RevisarExpedientePreparar''] !=null && valores[''CJPCO_RevisarExpedientePreparar''][''proc_iniciar''] !=null) ? valores[''CJPCO_RevisarExpedientePreparar''][''proc_iniciar''] : dameProcedimientoPropuesto()' ,'TipoProcedimiento','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','6','combo' ,'proc_a_iniciar','Procedimiento a iniciar' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'TipoProcedimiento','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','7','currency' ,'importeDemanda','Importe de la demanda' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','8','combo' ,'partidoJudicial','Partido judicial' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'TipoPlaza','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegistrarTomaDec','9','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha solicitado subsanación sobre expediente judicial preparado. Para dar por terminada esta tarea deberá de comprobar que realmente hay un problema en la documentación y consignar el resultado en el campo “Resultado” indicando Subsanar en caso de que realmente sea necesario subsanar el problema en la documentación, o indicando Devolver en caso de que no proceda la subsanación.</p>En caso de requerir subsanación, deberá valorar si es necesario que la nueva preparación del expediente la realice el preparador del expediente original o es conveniente que lo realice otro actor, en caso de querer cambiar de preparador, deberá acceder a la pestaña gestores del expediente y registrar el nuevo preparador.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacion','1','textarea' ,'observaciones_letrado','Observaciones letrado' ,null ,null ,'valores[''CJPCO_RegistrarTomaDec''][''observaciones'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacion','2','date' ,'fecha_revision','Fecha revision' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacion','3','combo' ,'subsanar','Subsanar' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacion','4','textarea','observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_IniciarProcJudicial','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se va a proceder a la generación del Procedimiento Judicial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarIncidenciaExp','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentación del expediente, antes de dar por finalizada esta tarea deberá resolver el problema informado.</p>Una vez enviada la documentación ya completa al letrado, deberá informar la fecha de envío de dicha documentación.<p></p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.<p></p>Una vez complete esta tarea se lanzará la tarea "Confirmar documentación y procedimiento” al letrado asignado al expediente.<p></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarIncidenciaExp','1','textarea' ,'observaciones_letrado','Observaciones letrado' ,null ,null ,'valores[''CJPCO_RevisarSubsanacion''][''observaciones_letrado'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarIncidenciaExp','2','combo' ,'tipo_problema','Tipo de problema en expediente' ,null ,null ,'valores[''CJPCO_RegistrarTomaDec''][''tipo_problema'']' ,'DDTipoProblemaDocPco','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarIncidenciaExp','3','date' ,'fecha_exp_sub','Fecha expediente subsanado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarIncidenciaExp','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarCambioProc','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá validar el cambio del tipo de actuación propuesto por el letrado respecto a la decisión de la entidad.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>En caso de validar el cambio de actuación se iniciará la actuación seleccionada, en caso contrario se lanzará de nuevo la tarea "Registrar decisión" al letrado.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarCambioProc','1','combo' ,'tipo_proc_letrado','Tipo procedimiento propuesto por el letrado' ,null ,null ,'valores[''CJPCO_RegistrarTomaDec''][''proc_a_iniciar'']' ,'TipoProcedimiento','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarCambioProc','2','combo' ,'tipo_proc_entidad','Tipo procedimiento propuesto por la entidad' ,null ,null ,'(valores[''CJPCO_RevisarExpedientePreparar''] !=null && valores[''CJPCO_RevisarExpedientePreparar''][''proc_iniciar''] !=null) ? valores[''CJPCO_RevisarExpedientePreparar''][''proc_iniciar''] : dameProcedimientoPropuesto()' ,'TipoProcedimiento','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarCambioProc','3','combo' ,'nueva_preparacion','Requiere nueva preparación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarCambioProc','4','combo' ,'cambio_aceptado','Cambio aceptado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarCambioProc','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarCambioProc','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentación del expediente, antes de dar por finalizada esta tarea deberá resolver el problema informado.</p>Una vez completada la documentación deberá informar la fecha en la que da por subsanado el expediente judicial en preparación.<p></p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.<p></p>Una vez complete esta tarea se lanzará la tarea “Confirmar documentación y cambio de procedimiento” al letrado asignado al expediente.<p></p></div>' ,null ,null ,'valores[''CJPCO_RegistrarTomaDec''][''observaciones'']' ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarCambioProc','1','textarea' ,'observaciones_letrado','Observaciones letrado' ,null ,null ,'valores[''CJPCO_RegistrarTomaDec''][''observaciones'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarCambioProc','2','text' ,'tipo_problema','Tipo de problema' ,null ,null ,'valores[''CJPCO_RegistrarTomaDec''][''observaciones'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarCambioProc','3','date' ,'fecha exp_subsanado','Fecha expediente subsanado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'valores[''CJPCO_RegistrarTomaDec''][''observaciones'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_SubsanarCambioProc','4','textarea' ,'observaciones','Observaciones' ,null ,null ,'valores[''CJPCO_RegistrarTomaDec''][''observaciones'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegResultadoExped','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegResultadoExped','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RecepcionExped','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RecepcionExped','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegResultadoDoc','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegResultadoDoc','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegEnvioDoc','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegEnvioDoc','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RecepcionDoc','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RecepcionDoc','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AdjuntarDoc','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AdjuntarDoc','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_GenerarLiq','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_GenerarLiq','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ConfirmarLiq','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ConfirmarLiq','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_EnviarBurofax','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_EnviarBurofax','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AcuseReciboBurofax','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AcuseReciboBurofax','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegResultadoDocG','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RegResultadoDocG','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_DecTipoProcAutomatica','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Calcula tipo de asunto.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_DecTipoProcAutomatica','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AsignacionGestores','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que se ha iniciado la preparaci&oacute;n de un nuevo expediente judicial, a trav&eacute;s de esta tarea deber&aacute; indicar el tipo de procedimiento a lanzar una vez termine la preparaci&oacute;n de dicho expediente.</p><p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Para poder dar por completada esta tarea, deber&aacute; asignar los siguiente Gestores a trav&eacute;s de la pesta&ntilde;a Gestores de este Asunto:</p><ul><li>Letrado</li><li>Supervisor del asunto</li><li>Preparador documental</li><li>Director del litigio</li></ul><p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Una vez termine esta tarea se lanzar&aacute; autom&aacute;ticamente correspondientes a la propia preparaci&oacute;n del expediente judicial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AsignacionGestores','1','combo' ,'procPropuesto','Procedimiento a iniciar' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'TipoProcedimiento','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AsignacionGestores','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpDigCONC','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que la empresa de preparaci&oacute;n del expediente digital, ha dado por finalizada dicha preparaci&oacute;n. Antes de dar por completada esta tarea deber&aacute; revisar la pesta&ntilde;a Adjuntos del Asunto correspondiente y comprobar que toda la documentaci&oacute;n que requiere est&aacute; disponible.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que d&eacute; por finalizada la revisi&oacute;n del expediente digital.</p><p style="margin-bottom: 10px">En el campo “Documentaci&oacute;n completa y correcta” deber&aacute; indicar si la documentaci&oacute;n del expediente efectivamente es completa y correcta o no. En caso de no ser completa deber&aacute; indicar el problema detectado según sea por Documentos o por Liquidaciones.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en funci&oacute;n de la informaci&oacute;n facilitada podr&aacute;n darse las siguientes situaciones:</p><p style="margin-bottom: 10px"><ul><li>En caso de haber encontrado un problema en la Documentaci&oacute;n, o liquidaciones se iniciar&aacute; la tarea “Revisar subsanaci&oacute;n propuesta” a realizar por la entidad.</li><li>En caso de no haber encontrado error en la documentaci&oacute;n se dar&aacute; por finalizada esta actuaci&oacute;n.</ul></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpDigCONC','1','combo' ,'docCompleta','Documentación completa y correcta' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpDigCONC','2','date', 'fecha_revision','Fecha de revisión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpDigCONC','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacionCONC','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha solicitado subsanación sobre expediente judicial preparado. Para dar por terminada esta tarea deberá de comprobar que realmente hay un problema en la documentación y consignar el resultado en el campo “Resultado” indicando Subsanar en caso de que realmente sea necesario subsanar el problema en la documentación, o indicando Devolver en caso de que no proceda la subsanación.</p>En caso de requerir subsanación, deberá valorar si es necesario que la nueva preparación del expediente la realice el preparador del expediente original o es conveniente que lo realice otro actor, en caso de querer cambiar de preparador, deberá acceder a la pestaña gestores del expediente y registrar el nuevo preparador.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacionCONC','1','textarea' ,'observaciones_letrado','Observaciones letrado' ,null ,null ,'valores[''CJPCO_RevisarExpDigCONC''][''observaciones'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacionCONC','2','date' ,'fecha_revision','Fecha de revisión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacionCONC','3','combo' ,'subsanar','Resultado (Subsanar=Sí, Devolver=No)' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarSubsanacionCONC','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ResolverIncidenciaExpCONC','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentación del expediente, antes de dar por finalizada esta tarea deberá resolver el problema informado.</p>Una vez enviada la documentación ya completa al letrado, deberá informar la fecha de envío de dicha documentación.</p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p>Una vez complete esta tarea se lanzará la tarea "Revisión del expediente digital" al letrado asignado al expediente.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ResolverIncidenciaExpCONC','1','textarea' ,'observaciones_letrado','Observaciones letrado' ,null ,null ,'valores[''CJPCO_RevisarExpDigCONC''][''observaciones'']' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ResolverIncidenciaExpCONC','2','date' ,'fecha_exp_sub','Fecha expediente subsanado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ResolverIncidenciaExpCONC','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_VisarLiq','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tarea especial.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_VisarLiq','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedientePreparar','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por terminada esta tarea, deberá realizar un estudio de las operaciones incluidas en el asunto y de la solvencia de los deudores para determinar si la recuperación de la deuda se hará por la vía judicial, a través de una agencia externa o directamente se quiere marcar la no gestión del asunto.<br/>En el campo “Fecha fin revisión” deberá indicar la fecha en la que finaliza este estudio.<br/>En caso de que decida asignar el asunto a una agencia externa, deberá indicarlo en el Terminal Financiero de la entidad y seleccionar “Agencia externa” en el campo selector “Gestión”. En caso de indicar Gestión "Judicializar" deberá indicar en el selector de procedimiento el tipo de procedimiento a iniciar una vez termine la preparación del expediente judicial.<br/>En caso de considerar necesaria la paralización de la preparación del expediente judicial, puede prorrogar esta tarea hasta que estime oportuno a través de la solicitud de una prórroga. De igual modo, en caso de encontrarse en negociación de un acuerdo extrajudicial, regístrelo a través de la pestaña Acuerdos de la ficha del asunto correspondiente.<br/>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.<br/>Una vez rellene esta pantalla y si ha marcado Gestión “Agencia externa” o "Sin gestión" se finalizará el trámite, en caso de haber indicado "Judicializar" se lanzará la tarea “Asignar gestor de liquidación. </p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedientePreparar','1','date' ,'fecha_fin_revision','Fecha fin revisión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedientePreparar','2','combo' ,'gestion','Gestión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDTipoGestionRevisarExpJudicial','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedientePreparar','3','combo' ,'proc_iniciar','Procedimiento propuesto' ,null ,null ,null ,'TipoProcedimiento','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedientePreparar','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AsignarGestorLiquidacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de asignar al asunto afecto a esta preparación del expediente judicial, el gestor de liquidación que se va a ocupar de obtener tanto las liquidaciones como los acuses de recibo.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla comenzará con la preparación del expediente judicial a través de la pantalla de “Prep. Documental”.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_AsignarGestorLiquidacion','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedienteAsignarLetrado','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; añadir el letrado al que asigna el expediente judicial en la pestaña "Gestores" del expediente.</p><p style="margin-bottom: 10px">En el campo Fecha, indicar la fecha en la completa la tarea.</p><p style="margin-bottom: 10px">En el campo "Motivo de asignaci&oacute;n a Letrado" deber&aacute; elegir una de entre las opciones disponibles.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul><li>En caso de que no esté conforme con la finalizaci&oacute;n del expediente, la pestaña de Preparaci&oacute;n Documental volver&aacute; a estar disponible y el Gestor de Documentaci&oacute;n deber&aacute; realizar los cambios que le indique el supervisor.</li><li>En caso de que haya indicado que est&aacute; conforme con la finalizaci&oacute;n del expediente, se lanzar&aacute; la tarea "Registrar aceptaci&oacute;n asunto" al letrado asignado.</li></ul></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedienteAsignarLetrado','1','date' ,'fecha_revision','Fecha de revisión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedienteAsignarLetrado','2','combo' ,'motivo_asignacion','Motivo de asignación a Letrado' ,null ,null ,null ,'DDMotivoAsignacionLetrado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedienteAsignarLetrado','3','combo' ,'expediente_correcto','Expediente correcto' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_RevisarExpedienteAsignarLetrado','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PreasignarProcurador','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá asignar al asunto de referencia el procurador que estime oportuno. Tenga en cuenta que antes de que se inicie el procedimiento judicial, le aparecerá de nuevo una tarea donde se le pedirá que confirme el procurador asignado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_PreasignarProcurador','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ConfirmarProcurador','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá confirmar que el procurador asignado al asunto de referencia es correcto.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ConfirmarProcurador','1','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_BPMTramiteEnvioDemanda','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se inicia el trámite de envío de la demanda</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarAsignacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Instrucciones pendientes de definir</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarAsignacion','1','currency' ,'importeDemanda','Importe de la demanda' ,null ,null ,'(valores[''CJPCO_RegistrarTomaDec''] !=null && valores[''CJPCO_RegistrarTomaDec''][''importeDemanda''] !=null) ? valores[''CJPCO_RegistrarTomaDec''][''importeDemanda''] : null' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarAsignacion','2','combo' ,'proc_a_iniciar','Procedimiento a iniciar' ,null ,null ,'(valores[''CJPCO_RegistrarTomaDec''] !=null && valores[''CJPCO_RegistrarTomaDec''][''proc_a_iniciar''] !=null) ? valores[''CJPCO_RegistrarTomaDec''][''proc_a_iniciar''] : null' ,'TipoProcedimiento','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarAsignacion','3','combo' ,'partidoJudicial','Partido judicial' ,null ,null ,'(valores[''CJPCO_RegistrarTomaDec''] !=null && valores[''CJPCO_RegistrarTomaDec''][''partidoJudicial''] !=null) ? valores[''CJPCO_RegistrarTomaDec''][''partidoJudicial''] : null' ,'TipoPlaza','0','RECOVERY-2026'),
		T_TIPO_TFI('CJPCO_ValidarAsignacion','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026')
    );
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
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
          ' TAP_DESCRIPCION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',' ||
          ' DD_TPO_ID_BPM=(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(7)) || '''),' ||
          ' TAP_ALERT_VUELTA_ATRAS=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
          ' DD_FAP_ID=(SELECT DD_FAP_ID FROM ' || V_ESQUEMA || '.DD_FAP_FASE_PROCESAL WHERE DD_FAP_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(15)) || '''),' || 
          ' TAP_AUTOPRORROGA=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',' ||
          ' TAP_MAX_AUTOP=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
          ' DD_TSUP_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
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
	  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET DD_PTP_PLAZO_SCRIPT=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',' ||
            ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''',' ||
            ' FECHAMODIFICAR=sysdate ' ||
        	  ' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Se actualiza el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
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
        	' TFI_BUSINESS_OPERATION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
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