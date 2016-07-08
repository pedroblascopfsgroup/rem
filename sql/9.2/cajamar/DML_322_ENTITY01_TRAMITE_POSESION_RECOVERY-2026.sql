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
		T_TIPO_TAP('CJ015','CJ015_RegistrarSolicitudPosesion' ,'plugin/procedimientos/tramiteDePosesion/registrarSolicitudPosesion' ,'comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe tener un bien asociado al procedimiento</div>''' ,'valores[''CJ015_RegistrarSolicitudPosesion''][''comboPosesion''] == DDSiNo.SI && (valores[''CJ015_RegistrarSolicitudPosesion''][''comboArrendamientoValido''] == null || valores[''CJ015_RegistrarSolicitudPosesion''][''fechaSolicitud''] == null || valores[''CJ015_RegistrarSolicitudPosesion''][''comboOcupado''] == null || valores[''CJ015_RegistrarSolicitudPosesion''][''comboMoratoria''] == null || valores[''CJ015_RegistrarSolicitudPosesion''][''comboViviendaHab''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Los campos <b>Fecha de solicitud de la posesi&oacute;n</b>, <b>Contrato arrendamiento v&aacute;lido</b>, <b>Ocupado</b>, <b>Moratoria</b> y <b>Vivienda Habitual</b> son obligatorios</div>'' : null' ,'valores[''CJ015_RegistrarSolicitudPosesion''][''comboPosesion''] == DDSiNo.NO ? ''noRequierePosesion'' : (valores[''CJ015_RegistrarSolicitudPosesion''][''comboArrendamientoValido''] == DDSiNo.SI ? ''contratoValido'' : (valores[''CJ015_RegistrarSolicitudPosesion''][''comboMoratoria''] == DDSiNo.SI ? ''solicitudMoratoriaLanzamiento'' : (valores[''CJ015_RegistrarSolicitudPosesion''][''comboOcupado''] == DDSiNo.SI ? ''posesionConOcupantes'' : ''posesionSinOcupantes'')))' ,null ,'0','Registrar Solicitud de Posesión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_RegistrarSenyalamientoPosesion' ,null ,null ,null ,null ,null ,'0','Registrar Señalamiento de la Posesión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_RegistrarPosesionYLanzamiento' ,'plugin/procedimientos/tramiteDePosesion/registrarPosesionYLanzamiento' ,'comprobarExisteDocumentoDJP() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento diligencia judicial de la posesi&oacute;n</div>''' ,'valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboOcupado''] == ''02'' && (valores[''CJ015_RegistrarPosesionYLanzamiento''][''fecha''] == null || valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboFuerzaPublica''] == null || valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboLanzamiento''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Los campos <b>Fecha realizaci&oacute;n de la posesi&oacute;n</b>, <b>Necesario Fuerza P&uacute;blica</b> y <b>Lanzamiento Necesario</b> son obligatorios</div>'' : null' ,'valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboOcupado''] == DDSiNo.SI ? ''conOcupantes'' : ''sinOcupantes''' ,null ,'0','Registrar posesión y decisión sobre lanzamiento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_RegistrarSenyalamientoLanzamiento' ,null ,null ,null ,null ,null ,'0','Registrar Señalamiento del Lanzamiento' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_RegistrarLanzamientoEfectuado' ,null ,'comprobarExisteDocumentoDJL() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento diligencia judicial del lanzamiento</div>''' ,null ,null ,null ,'0','Registrar lanzamiento efectuado' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_RegistrarDecisionLlaves' ,null ,null ,null ,'valores[''CJ015_RegistrarDecisionLlaves''][''comboLlaves''] == DDSiNo.SI ? ''requiereLlaves'' : ''noRequiereLlaves''' ,null ,'0','Registrar decisión sobre llaves' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_BPMTramiteGestionLlaves' ,null ,null ,null ,null ,'CJ040' ,'0','Tramite de Gestión de llaves' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_BPMTramiteMoratoriaLanzamiento' ,null ,null ,null ,null ,'CJ011' ,'0','Tramite Moratoria Lanzamiento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_BPMTramiteOcupantes' ,null ,null ,null ,null ,'CJ048' ,'0','Trámite de ocupantes' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_BPMTramiteOcupantes2' ,null ,null ,null ,null ,'CJ048' ,'0','Trámite de ocupantes' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_RegistrarSolicitudDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_LlavesDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_ConfirmarNotificacionDeudor' ,'plugin/procedimientos-bpmHaya-plugin/tramiteDePosesion/confirmarNotificacionDeudor' ,null ,null ,'valores[''CJ015_ConfirmarNotificacionDeudor''][''comboNotificado''] == DDSiNo.SI ? ''Si'' : ''No''' ,null ,'0','Confirmar notificación deudor' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_PresentarSolicitudSenyalamientoPosesion',null ,null ,null ,null ,null ,'0','Presentar solicitud de señalamiento de la posesión' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'1','EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_SolicitarAlquilerSocial' ,'plugin/procedimientos-bpmHaya-plugin/tramiteDePosesion/solicitarAlquilerSocial' ,null ,null ,'valores[''CJ015_SolicitarAlquilerSocial''][''gestionSolicitada''] == DDSiNo.SI ? ''Si'' : ''No''' ,null ,'0','Solicitud alquiler social' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_FormalizacionAlquilerSocial' ,'plugin/cajamar/tramitePosesion/formalizacionAlquilerSocial' ,null ,'valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboLanzamiento''] == DDSiNo.SI && valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha''] == null  && (valores[''CJ015_FormalizacionAlquilerSocial''][''alquilerFormalizado''] == DDSiNo.SI || valores[''CJ015_FormalizacionAlquilerSocial''][''posibleFormalizacion''] == DDSiNo.SI) ? ''Es necesario haber informado de la fecha de lanzamiento en la tarea "Registrar se&ntilde;alamiento del lanzamiento" para finalizar esta tarea.'' : valores[''CJ015_FormalizacionAlquilerSocial''][''alquilerFormalizado''] == DDSiNo.SI ? comprobarExisteDocumento(''CAS'') ? null : ''<div id="permiteGuardar">Debe adjuntar el documento "Contrato de alquiler social".</div>'' : null' ,'valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha''] != null && (valores[''CJ015_FormalizacionAlquilerSocial''][''alquilerFormalizado''] == DDSiNo.SI || valores[''CJ015_FormalizacionAlquilerSocial''][''posibleFormalizacion''] == DDSiNo.SI) ?  ''Si'' : ''No''' ,null ,'0','Formalización alquiler social' ,'0','RECOVERY-2026','0' ,null ,null,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_SuspensionLanzamiento' ,null ,'!comprobarExisteDocumento(''ESCSUS'') ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Debe adjuntar el documento "Escrito de suspensi&oacute;n".</p></div>'' : null' ,null ,'valores[''CJ015_FormalizacionAlquilerSocial''][''alquilerFormalizado''] == DDSiNo.SI ? ''si'' : ''no''' ,null ,'0','Suspensión lanzamiento' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_TramiteOcupantesDesfavorableDecision' ,null ,null ,null ,null ,null ,'0','Tarea de toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_BPMTramiteNotificacion' ,null ,null ,null ,null ,'P400' ,'0','Trámite de notificación' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_AutorizarSuspension' ,null ,null ,null ,'valores[''CJ015_AutorizarSuspension''][''resultado''] == ''ACEPTADO'' ? ''aceptado'' : ''denegado''' ,null ,'0','Autorizar suspensión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_ConfirmarFormalizacion' ,null ,null ,'valores[''CJ015_ConfirmarFormalizacion''][''alquilerFormalizado''] == DDSiNo.SI && !comprobarExisteDocumento(''CAS'') ? ''Debe adjuntar el documento "Contrato de alquiler social".'' : null' ,'valores[''CJ015_ConfirmarFormalizacion''][''alquilerFormalizado''] == DDSiNo.SI ? ''si'' : ''no''' ,null ,'0','Confirmar formalización alquiler social' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ015','CJ015_TramitePosesionDecision' ,null ,null ,null ,null ,null ,'0','Tarea de toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ015_RegistrarSolicitudPosesion','(valores[''CJ067_ConfirmarTestimonio''] != null && valores[''CJ067_ConfirmarTestimonio''][''fechaTestimonio''] != null && valores[''CJ067_ConfirmarTestimonio''][''fechaTestimonio''] != '''') ? damePlazo(valores[''CJ067_ConfirmarTestimonio''][''fechaTestimonio'']) + 3*24*60*60*1000L : 5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_BPMTramiteMoratoriaLanzamiento','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_RegistrarSenyalamientoPosesion','damePlazo(valores[''CJ015_RegistrarSolicitudPosesion''][''fechaSolicitud'']) + 5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_RegistrarPosesionYLanzamiento','damePlazo(valores[''CJ015_RegistrarSenyalamientoPosesion''][''fechaSenyalamiento'']) + 1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_BPMTramiteOcupantes','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_BPMTramiteOcupantes2','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_RegistrarSenyalamientoLanzamiento','damePlazo(valores[''CJ015_RegistrarPosesionYLanzamiento''][''fecha'']) + 5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_RegistrarLanzamientoEfectuado','damePlazo(valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha'']) + 1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_RegistrarDecisionLlaves','( (valores[''CJ015_RegistrarLanzamientoEfectuado''] != null) && (valores[''CJ015_RegistrarLanzamientoEfectuado''][''fecha''] != null) ? damePlazo(valores[''CJ015_RegistrarLanzamientoEfectuado''][''fecha'']) : damePlazo(valores[''CJ015_RegistrarPosesionYLanzamiento''][''fecha''])  )' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_BPMTramiteGestionLlaves','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_BPMTramiteNotificacion','300*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_AutorizarSuspension','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_ConfirmarFormalizacion','damePlazo(valores[''CJ015_SuspensionLanzamiento''][''fechaParalizacion'']) + 30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_ConfirmarNotificacionDeudor','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_PresentarSolicitudSenyalamientoPosesion','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_SolicitarAlquilerSocial','15*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_FormalizacionAlquilerSocial','7*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ015_SuspensionLanzamiento','valores[''CJ015_RegistrarSenyalamientoLanzamiento''] && valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha''] != null ? damePlazo(valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha'']) - 1*24*60*60*1000L : 1*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ015_RegistrarSolicitudPosesion','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px; ">A través de esta tarea deberá de informar si hay una posible posesión o no. En caso de que no sea posible la posesión deberá anotar si existe un contrato de arrendamiento válido vinculado al bien. En caso de que proceda, la fecha de solicitud de la posesión, si el bien se encuentra ocupado o no,  si se ha producido una petición de moratoria y en cualquier caso se deberá informar la condición del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px; ">Una vez rellene esta pantalla y dependiendo de la información registrada se lanzará:</p><p style="margin-bottom: 10px; ">-En caso de haber solicitud de moratoria de posesión se iniciará el trámite para tal efecto.</p><p style="margin-bottom: 10px; ">-En caso de encontrarse el bien con ocupantes, se lanzará el trámite de ocupantes.</p><p style="margin-bottom: 10px; ">-En caso de encontrarse el bien sin ocupantes, se lanzará la tarea "Registrar señalamiento de la posesión".</p><p style="margin-bottom: 10px; ">-En caso de que haya indicado que existe un contrato válido, se lanzará la tarea Confirmar notificación deudor.</p><p style="margin-bottom: 10px; ">-En el caso de que el bien no esté en ninguna de las situaciones expuestas y no haya una posible posesión, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSolicitudPosesion','1','combo' ,'comboPosesion','Posible Posesión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSolicitudPosesion','2','combo' ,'comboArrendamientoValido','Contrato arrendamiento válido' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSolicitudPosesion','3','date' ,'fechaSolicitud','Fecha de solicitud de la posesión' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSolicitudPosesion','4','combo' ,'comboOcupado','Ocupado por persona distinta del demandado' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSolicitudPosesion','5','combo' ,'comboMoratoria','Moratoria' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSolicitudPosesion','6','combo' ,'comboViviendaHab','Vivienda Habitual' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSolicitudPosesion','7','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSenyalamientoPosesion','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="color: rgb(0, 0, 0); font-family: tahoma, arial, helvetica, sans-serif; font-size: 11px; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por completada esta tarea deberá de informar la fecha de señalamiento para la posesión. </span></font></p><p style="color: rgb(0, 0, 0); font-family: tahoma, arial, helvetica, sans-serif; font-size: 11px; margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez completada esta tarea se lanzará la tarea "Registrar posesión y decisión sobre el lanzamiento".</span></font></p></div>' ,null ,null ,null ,null,'3','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSenyalamientoPosesion','1','date' ,'fechaSenyalamiento','Fecha señalamiento para posesión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSenyalamientoPosesion','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarPosesionYLanzamiento','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; informar en primer lugar si el bien se encuentra ocupado, y en caso negativo indicar la fecha de realizaci&oacute;n de la posesi&oacute;n, necesario fuerza p&uacute;blica y si el lanzamiento es necesario o no.</p><p style="margin-bottom: 10px">En caso de haberse producido la posesi&oacute;n deber&aacute; de adjuntar al procedimiento el documento "Diligencia judicial de la posesi&oacute;n"</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzar&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber marcado el bien como ocupado, se lanzar&aacute; el tr&aacute;mite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de Lanzamiento necesario se lanzar&aacute; la tarea "Registrar señalamiento del lanzamiento".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no ser necesario el lanzamiento se lanzar&aacute; la tarea "Registrar decisi&oacute;n sobre llaves".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que el bien sea la vivienda habitual, se lanzar&aacute; la tarea "Solicitud alquiler social".</li></ul></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarPosesionYLanzamiento','1','combo' ,'comboOcupado','Ocupado en la realización de la Diligencia' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarPosesionYLanzamiento','2','date' ,'fecha','Fecha realización de la posesión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarPosesionYLanzamiento','3','combo' ,'comboFuerzaPublica','Necesario Fuerza Pública' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarPosesionYLanzamiento','4','combo' ,'comboLanzamiento','Lanzamiento Necesario' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarPosesionYLanzamiento','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSenyalamientoLanzamiento','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de informar la fecha de señalamiento para el lanzamiento.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Registrar lanzamiento efectivo".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSenyalamientoLanzamiento','1','date' ,'fecha','Fecha señalamiento para el lanzamiento' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarSenyalamientoLanzamiento','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarLanzamientoEfectuado','0','label' ,'titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por completada esta tarea deberá de informar la fecha de lanzamiento efectivo así como dejar indicado si ha sido necesario el uso de la fuerza pública o no.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En caso de haberse producido el lanzamiento deberá de adjuntar al procedimiento el documento “Diligencia judicial del lanzamiento”</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla se lanzará la tarea "Registrar decisión sobre llaves".</span></font></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarLanzamientoEfectuado','1','date' ,'fecha','Fecha lanzamiento efectivo' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarLanzamientoEfectuado','2','combo' ,'comboFuerzaPublica','Necesario Fuerza Pública' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarLanzamientoEfectuado','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarDecisionLlaves','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá dejar constancia de si es necesario realizar una gestión de las llaves por cambio de cerradura, o no.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en el caso de ser necesaria una gestión de las llaves se iniciará el trámite para la gestión de llaves, en caso contrario se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. </p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarDecisionLlaves','1','combo' ,'comboLlaves','Gestión de Llaves','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_RegistrarDecisionLlaves','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_BPMTramiteGestionLlaves','0','label' ,'titulo','Trámite de Gestión de llaves' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_BPMTramiteMoratoriaLanzamiento','0','label' ,'titulo','Trámite de Moratoria de Lanzamiento' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_BPMTramiteOcupantes','0','label' ,'titulo','Trámite de Ocupantes' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_BPMTramiteOcupantes2','0','label' ,'titulo','Trámite de Ocupantes' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_ConfirmarNotificacionDeudor','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; de informar si se notific&oacute; al deudor la subrogaci&oacute;n al contrato de arrendamiento y la fecha de notificaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea en caso de que el deudor est&eacute; notificado se lanzar&aacute; la tarea "Presentar solicitud se&ntilde;alamiento de la posesi&oacute;n". En caso contrario, se lanzar&aacute; el tr&aacute;mite de Notificaci&oacute;n.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_ConfirmarNotificacionDeudor','1','combo' ,'comboNotificado','Deudor notificado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_ConfirmarNotificacionDeudor','2','date' ,'fechaNotificacion','Fecha notificación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_ConfirmarNotificacionDeudor','3','textarea','observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_PresentarSolicitudSenyalamientoPosesion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Puesto que no ha podido confirmar que se ha realizado la notificaci&oacute;n al deudor, deber&aacute; dejar constancia de la fecha en la que presenta la solicitud de señalamiento de la posesi&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzar&aacute; la tarea "Registrar señalamiento de la de la posesi&oacute;n".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_PresentarSolicitudSenyalamientoPosesion','1','date' ,'fechaSenyalamiento','Fecha de señalamiento para posesión' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_PresentarSolicitudSenyalamientoPosesion','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_SolicitarAlquilerSocial','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Deber&aacute; indicar si se ha solicitado la gesti&oacute;n de alquiler social para los ocupantes de la vivienda habitual.</p><p style="margin-bottom: 10px">Se indicar&aacute; la fecha de solicitud de gesti&oacute;n del alquiler social.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de que se haya solicitado la gesti&oacute;n del alquiler social, se lanzar&aacute; la tarea "Formalizaci&oacute;n alquiler social".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_SolicitarAlquilerSocial','1','combo' ,'gestionSolicitada','Solicitado gestión alquiler social' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_SolicitarAlquilerSocial','2','date' ,'fechaSolicitud','Fecha solicitud' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_SolicitarAlquilerSocial','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_FormalizacionAlquilerSocial','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta tarea deber&aacute; indicar si ha formalizado o no el alquiler social. En caso negativo, deber&aacute; indicar en el campo "Es posible la formalizaci&oacute;n" si preve&eacute; que es posible que se firme o si definitivamente no se formalizar&aacute; en ning&uacute;n caso.</p><p style="margin-bottom: 10px">Tenga en cuenta que en caso de haya lanzamiento, deber&aacute; registar primera la fecha de lanzamiento en la tarea correspondiente, antes de finalizar &eacute;sta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul><li>En caso de que se haya formalizado el alquiler social y no haya lanzamiento, deber&aacute; finalizar esta actuaci&oacute;n a trav&eacute;s de la pestaña "Decisiones" indicando el motivo de la finalizaci&oacute;n.</li><li>En caso de que se haya formalizado el alquiler social y haya fijada una fecha para el lanzamiento, se lanzar&aacute; una tarea a la entidad para autorizar la suspensi&oacute;n del lanzamiento.</li><li>En caso de que no se haya formalizado pero s&iacute; sea posible formalizarlo y haya fijada una fecha para el lanzamiento, se lanzar&aacute; una tarea a la entidad para autorizar la suspensi&oacute;n del lanzamiento.</li><li>En caso de que no se formalice el alquiler y no sea posible formalizarlo, deber&aacute; continuar con el lanzamiento.</li></ul></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_FormalizacionAlquilerSocial','1','combo' ,'alquilerFormalizado','Alquiler social formalizado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_FormalizacionAlquilerSocial','2','combo' ,'posibleFormalizacion','Es posible la formalización' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_FormalizacionAlquilerSocial','3','date' ,'fechaFormalizacion','Fecha de formalización' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_FormalizacionAlquilerSocial','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_SuspensionLanzamiento','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; realizar los tr&aacute;mites necesarios para suspender el lanzamiento, as&iacute; como adjuntar el Escrito de suspensi&oacute;n presentado en el juzgado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, y en caso de que hubiera formalizado anteriormente el alquiler social, deber&aacute; finalizar esta actuaci&oacute;n a trav&eacute;s de la pestaña "Decisiones" indicando el motivo de la finalizaci&oacute;n. En caso contrario, se lanzar&aacute; la tarea Confirmar formalizaci&oacute;n del alquiler social.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_SuspensionLanzamiento','1','date' ,'fechaParalizacion','Fecha paralización' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_SuspensionLanzamiento','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_BPMTramiteNotificacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se lanza el Trámite de Notificación.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_AutorizarSuspension','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta tarea, la entidad se deberá confirmar si autoriza la suspensión del lanzamiento propuesta por el gestor.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, y en caso de que la Entidad autorice la suspensión, se lanzará la tarea "Suspensión lanzamiento". En caso contrario, la Entidad deberá indicar cómo proceder.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_AutorizarSuspension','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_AutorizarSuspension','2','combo' ,'resultado','Resultado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDAceptadoDenegado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_AutorizarSuspension','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_ConfirmarFormalizacion','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta tarea deberá indicar si ha formalizado o no el alquiler social. En caso negativo, deberá indicar en el campo "Es posible la formalización" si preveé que es posible que se firme o si definitivamente no se formalizar en ningún caso.</p><p style="margin-bottom: 10px">Tenga en cuenta que en caso de haya lanzamiento, deberá registar primera la fecha de lanzamiento en la tarea correspondiente, antes de finalizar ésta.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:</p><p style="margin-bottom: 10px">-En caso de que se haya formalizado el alquiler social y no haya lanzamiento, deberá finalizar esta actuación a través de la pestaña "Decisiones" indicando el motivo de la finalización.</p><p style="margin-bottom: 10px">-En caso de que se haya formalizado el alquiler social y haya fijada una fecha para el lanzamiento, se lanzará una tarea a la entidad para autorizar la suspensión del lanzamiento.</p><p style="margin-bottom: 10px">-En caso de que no se haya formalizado pero sí sea posible formalizarlo y haya fijada una fecha para el lanzamiento, se lanzará una tarea a la entidad para autorizar la suspensión del lanzamiento.</p><p style="margin-bottom: 10px">-En caso de que no se formalice el alquiler y no sea posible formalizarlo, deberá continuar con el lanzamiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_ConfirmarFormalizacion','1','combo' ,'alquilerFormalizado','Alquiler social formalizado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_ConfirmarFormalizacion','2','date' ,'fecha','Fecha formalización' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ015_ConfirmarFormalizacion','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026')
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