--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150822
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc02
--## INCIDENCIA_LINK=CMREC-416
--## PRODUCTO=NO
--##
--## Finalidad: Adaptar BPM's Haya-Cajamar
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	/*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas

    /*
    * CONFIGURACION: TABLAS
    *---------------------------------------------------------------------
    */    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    PAR_TABLENAME_TPLAZ VARCHAR2(50 CHAR) := 'DD_PTP_PLAZOS_TAREAS_PLAZAS'; -- [PARAMETRO] TABLA para plazos de tareas. Por defecto DD_PTP_PLAZOS_TAREAS_PLAZAS
    PAR_TABLENAME_TFITE VARCHAR2(50 CHAR) := 'TFI_TAREAS_FORM_ITEMS';       -- [PARAMETRO] TABLA para items del form de tareas. Por defecto TFI_TAREAS_FORM_ITEMS

    /*
    * CONFIGURACION: IDENTIDAD SCRIPT
    *---------------------------------------------------------------------
    */
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Trámite de posesión';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Alberto';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'alberto.campos@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2052';                              -- [PARAMETRO] Teléfono del autor

    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR);                          -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16);                            -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

    VAR_SEQUENCENAME VARCHAR2(50 CHAR);                 -- Variable para secuencias
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones

    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    V_CODIGO_PLAZAS VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Plazos
    V_CODIGO1_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo1 FK con codigo de TFI Items
    V_CODIGO2_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo2 FK con codigo de TFI Items
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'CJ015'; -- Código de procedimiento para reemplazar

	/*
    * ARRAY TABLA1: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO(V_COD_PROCEDIMIENTO, 'T. de Posesión - CJ','Trámite de Posesión', null,'cj_tramiteDePosesion',0,'dd',0,'AP', null, null,1,'MEJTipoProcedimiento',1,1)
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_RegistrarSolicitudPosesion','plugin/procedimientos/tramiteDePosesion/registrarSolicitudPosesion','comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe tener un bien asociado al procedimiento</div>''','valores[''CJ015_RegistrarSolicitudPosesion''][''comboPosesion''] == DDSiNo.SI && (valores[''CJ015_RegistrarSolicitudPosesion''][''comboArrendamientoValido''] == null || valores[''CJ015_RegistrarSolicitudPosesion''][''fechaSolicitud''] == null || valores[''CJ015_RegistrarSolicitudPosesion''][''comboOcupado''] == null || valores[''CJ015_RegistrarSolicitudPosesion''][''comboMoratoria''] == null || valores[''CJ015_RegistrarSolicitudPosesion''][''comboViviendaHab''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Los campos <b>Fecha de solicitud de la posesi&oacute;n</b>, <b>Contrato arrendamiento v&aacute;lido</b>, <b>Ocupado</b>, <b>Moratoria</b> y <b>Vivienda Habitual</b> son obligatorios</div>'' : null','valores[''CJ015_RegistrarSolicitudPosesion''][''comboPosesion''] == DDSiNo.NO ? ''noRequierePosesion'' : (valores[''CJ015_RegistrarSolicitudPosesion''][''comboArrendamientoValido''] == DDSiNo.SI ? ''contratoValido'' : (valores[''CJ015_RegistrarSolicitudPosesion''][''comboMoratoria''] == DDSiNo.SI ? ''solicitudMoratoriaLanzamiento'' : (valores[''CJ015_RegistrarSolicitudPosesion''][''comboOcupado''] == DDSiNo.SI ? ''posesionConOcupantes'' : ''posesionSinOcupantes'')))', null,0,'Registrar Solicitud de Posesión',0,'DD',0, null, null, null,1,'EXTTareaProcedimiento',3, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_RegistrarSenyalamientoPosesion', null, null, null, null, null,0,'Registrar Señalamiento de la Posesión',0,'DD',0, null, null, null,1,'EXTTareaProcedimiento',3, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_RegistrarPosesionYLanzamiento','plugin/procedimientos/tramiteDePosesion/registrarPosesionYLanzamiento','comprobarExisteDocumentoDJP() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento diligencia judicial de la posesi&oacute;n</div>''','valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboOcupado''] == ''02'' && (valores[''CJ015_RegistrarPosesionYLanzamiento''][''fecha''] == null || valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboFuerzaPublica''] == null || valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboLanzamiento''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Los campos <b>Fecha realizaci&oacute;n de la posesi&oacute;n</b>, <b>Necesario Fuerza P&uacute;blica</b> y <b>Lanzamiento Necesario</b> son obligatorios</div>'' : (valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboLanzamiento'']  == ''01'' && valores[''CJ015_RegistrarPosesionYLanzamiento''][''fechaSolLanza''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo <b>Fecha solicitud de lanzamiento</b> es obligatorio</div>'' : null','valores[''CJ015_RegistrarPosesionYLanzamiento''][''comboOcupado''] == DDSiNo.SI ? ''conOcupantes'' : ''sinOcupantes''', null,0,'Registrar posesión y decisión sobre lanzamiento',0,'DD',0, null, null, null,1,'EXTTareaProcedimiento',3, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_RegistrarSenyalamientoLanzamiento', null, null, null, null, null,0,'Registrar Señalamiento del Lanzamiento',0,'DD',0, null,'tareaExterna.cancelarTarea', null,0,'EXTTareaProcedimiento',0, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_RegistrarLanzamientoEfectuado', null,'comprobarExisteDocumentoDJL() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento diligencia judicial del lanzamiento</div>''', null, null, null,0,'Registrar lanzamiento efectuado',0,'DD',0, null,'tareaExterna.cancelarTarea', null,1,'EXTTareaProcedimiento',3, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_RegistrarDecisionLlaves', null, null, null,'valores[''CJ015_RegistrarDecisionLlaves''][''comboLlaves''] == DDSiNo.SI ? ''requiereLlaves'' : ''noRequiereLlaves''', null,0,'Registrar decisión sobre llaves',0,'DD',0, null, null, null,0,'EXTTareaProcedimiento',0, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_BPMTramiteGestionLlaves', null, null, null, null,'CJ040',0,'Tramite de Gestión de llaves',0,'DD',0, null, null, null,0,'EXTTareaProcedimiento',0, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_BPMTramiteMoratoriaLanzamiento', null, null, null, null,'CJ011',0,'Tramite Moratoria Lanzamiento',0,'DD',0, null, null, null,0,'EXTTareaProcedimiento',0, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_BPMTramiteOcupantes', null, null, null, null,'CJ048',0,'Trámite de ocupantes',0,'DD',0, null, null, null,0,'EXTTareaProcedimiento',0, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_BPMTramiteOcupantes2', null, null, null, null,'CJ048',0,'Trámite de ocupantes',0,'DD',0, null, null, null,0,'EXTTareaProcedimiento',0, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_RegistrarSolicitudDecision', null, null, null, null, null,0,'Tarea toma de decisión',0,'DD',0, null, null, null,0,'EXTTareaProcedimiento',0, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_LlavesDecision', null, null, null, null, null,0,'Tarea toma de decisión',0,'DD',0, null, null, null,0,'EXTTareaProcedimiento',0, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_ConfirmarNotificacionDeudor','plugin/cajamar/tramiteDePosesion/confirmarNotificacionDeudor', null, null,'valores[''CJ015_ConfirmarNotificacionDeudor''][''comboNotificado''] == DDSiNo.SI ? ''Si'' : ''No''', null,0,'Confirmar notificación deudor',0,'DD',0, null,'tareaExterna.cancelarTarea', null,1,'EXTTareaProcedimiento',3, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_PresentarSolicitudSenyalamientoPosesion', null, null, null, null, null,0,'Presentar solicitud de señalamiento de la posesión',0,'DD',0, null,'tareaExterna.cancelarTarea', null,1,'EXTTareaProcedimiento',3, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_SolicitarAlquilerSocial','plugin/cajamar/tramiteDePosesion/solicitarAlquilerSocial', null, null,'valores[''CJ015_SolicitarAlquilerSocial''][''gestionSolicitada''] == DDSiNo.SI ? ''Si'' : ''No''', null,0,'Solicitud alquiler social',0,'DD',0, null, null, null,1,'EXTTareaProcedimiento',3, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_FormalizacionAlquilerSocial','plugin/cajamar/tramiteDePosesion/formalizacionAlquilerSocial','comprobarExisteDocumentoCAS() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>Debe adjuntar el documento "Contrato de alquiler social".</p></div></div>''', null,'valores[''CJ015_FormalizacionAlquilerSocial''][''alquilerFormalizado''] == DDSiNo.SI ? ''Si'' : ''No''', null,0,'Formalización alquiler social',0,'DD',0, null, null, null,1,'EXTTareaProcedimiento',3, null, null, null, null,''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ015_SuspensionLanzamiento', null, null, null, null, null,0,'Suspensión lanzamiento',0,'DD',0, null, null, null,1,'EXTTareaProcedimiento',3, null, null, null, null,'')
	);
	V_TMP_TIPO_TAP T_TIPO_TAP;    
    
    /*
    * ARRAYS TABLA3: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS('', null,'CJ015_RegistrarSolicitudPosesion','(valores[''CJ005_ConfirmarTestimonio''] != null && valores[''CJ005_ConfirmarTestimonio''][''fechaTestimonio''] != null && valores[''CJ005_ConfirmarTestimonio''][''fechaTestimonio''] != '''') ? damePlazo(valores[''CJ005_ConfirmarTestimonio''][''fechaTestimonio'']) + 3*24*60*60*1000L : 5*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_RegistrarSenyalamientoPosesion','damePlazo(valores[''CJ015_RegistrarSolicitudPosesion''][''fechaSolicitud'']) + 5*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_RegistrarPosesionYLanzamiento','damePlazo(valores[''CJ015_RegistrarSenyalamientoPosesion''][''fechaSenyalamiento'']) + 1*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_RegistrarSenyalamientoLanzamiento','damePlazo(valores[''CJ015_RegistrarPosesionYLanzamiento''][''fecha'']) + 5*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_RegistrarLanzamientoEfectuado','damePlazo(valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha'']) + 1*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_RegistrarDecisionLlaves','( (valores[''CJ015_RegistrarLanzamientoEfectuado''] != null) && (valores[''CJ015_RegistrarLanzamientoEfectuado''][''fecha''] != null) ? damePlazo(valores[''CJ015_RegistrarLanzamientoEfectuado''][''fecha'']) : damePlazo(valores[''CJ015_RegistrarPosesionYLanzamiento''][''fecha''])  )',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_BPMTramiteGestionLlaves','300*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_BPMTramiteMoratoriaLanzamiento','300*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_BPMTramiteOcupantes','300*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_BPMTramiteOcupantes2','300*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_ConfirmarNotificacionDeudor','2*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_PresentarSolicitudSenyalamientoPosesion','3*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_SolicitarAlquilerSocial','15*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_FormalizacionAlquilerSocial','valores[''CJ015_RegistrarSenyalamientoLanzamiento''] && valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha''] != null ? damePlazo(valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha'']) - 2*24*60*60*1000L : 15*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('', null,'CJ015_SuspensionLanzamiento','valores[''CJ015_RegistrarSenyalamientoLanzamiento''] && valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha''] != null ? damePlazo(valores[''CJ015_RegistrarSenyalamientoLanzamiento''][''fecha'']) - 1*24*60*60*1000L : 1*24*60*60*1000L',0,0,'DD')
	); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
        
    /*
    * ARRAYS TABLA4: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI ('CJ015_RegistrarSolicitudPosesion',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">A través de esta tarea deberá de informar si hay una posible posesión o no, en caso de que proceda, la fecha de solicitud de la posesión, si el bien se encuentra ocupado o no, si se ha producido una petición de moratoria y en cualquier caso se deberá informar la condición del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px">En caso de que no haya ningún bien vinculado al procedimiento, deberá vincularlo a través de la pestaña Bienes del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de la información registrada se lanzará:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber solicitud de moratoria de posesión se iniciará el trámite para tal efecto.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien con ocupantes, se lanzará el trámite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien sin ocupantes, se lanzará la tarea "Registrar posesión"</li><li style="margin-bottom: 10px; margin-left: 35px;">En el caso de que el bien no esté en ninguna de las situaciones expuestas y no haya una posible posesión, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</li></ul></div>', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSolicitudPosesion',1,'combo','comboPosesion','Posible Posesión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSolicitudPosesion',2,'combo','comboArrendamientoValido','Contrato arrendamiento válido', null, null, null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSolicitudPosesion',3,'date','fechaSolicitud','Fecha de solicitud de la posesión', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSolicitudPosesion',4,'combo','comboOcupado','Ocupado por persona distinta del demandado', null, null, null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSolicitudPosesion',5,'combo','comboMoratoria','Moratoria', null, null, null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSolicitudPosesion',6,'combo','comboViviendaHab','Vivienda Habitual', null, null, null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSolicitudPosesion',7,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSenyalamientoPosesion',0,'label','titulo','<div align="justify" style="margin-bottom: 30px;"><p style="color: rgb(0, 0, 0); font-family: tahoma, arial, helvetica, sans-serif; font-size: 11px; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por completada esta tarea deberá de informar la fecha de señalamiento para la posesión. </span></font></p><p style="color: rgb(0, 0, 0); font-family: tahoma, arial, helvetica, sans-serif; font-size: 11px; margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez completada esta tarea se lanzará la tarea "Registrar posesión y decisión sobre el lanzamiento".</span></font></p></div>', null, null, null, null,3,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSenyalamientoPosesion',1,'date','fechaSenyalamiento','Fecha señalamiento para posesión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSenyalamientoPosesion',2,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarPosesionYLanzamiento',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; informar en primer lugar si el bien se encuentra ocupado, y en caso negativo indicar la fecha de realizaci&oacute;n de la posesi&oacute;n, necesario fuerza p&uacute;blica y si el lanzamiento es necesario o no.</p><p style="margin-bottom: 10px">En caso de haberse producido la posesi&oacute;n deber&aacute; de adjuntar al procedimiento el documento "Diligencia judicial de la posesi&oacute;n"</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzar&aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber marcado el bien como ocupado, se lanzar&aacute; el tr&aacute;mite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de Lanzamiento necesario se lanzar&aacute; la tarea "Registrar señalamiento del lanzamiento".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no ser necesario el lanzamiento se lanzar&aacute; la tarea "Registrar decisi&oacute;n sobre llaves".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que el bien sea la vivienda habitual, se lanzar&aacute; la tarea "Solicitud alquiler social".</li></ul></div>', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarPosesionYLanzamiento',1,'combo','comboOcupado','Ocupado en la realización de la Diligencia','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarPosesionYLanzamiento',2,'date','fecha','Fecha realización de la posesión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarPosesionYLanzamiento',3,'combo','comboFuerzaPublica','Necesario Fuerza Pública','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', null, null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarPosesionYLanzamiento',4,'combo','comboLanzamiento','Lanzamiento Necesario','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', null, null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarPosesionYLanzamiento',5,'date','fechaSolLanza','Fecha solicitud del lanzamiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarPosesionYLanzamiento',6,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSenyalamientoLanzamiento',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de informar la fecha de señalamiento para el lanzamiento.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Registrar lanzamiento efectivo".</p></div>', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSenyalamientoLanzamiento',1,'date','fecha','Fecha señalamiento para el lanzamiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarSenyalamientoLanzamiento',2,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarLanzamientoEfectuado',0,'label','titulo','<div align="justify" style="margin-bottom: 30px;"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por completada esta tarea deberá de informar la fecha de lanzamiento efectivo así como dejar indicado si ha sido necesario el uso de la fuerza pública o no.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En caso de haberse producido el lanzamiento deberá de adjuntar al procedimiento el documento “Diligencia judicial del lanzamiento”</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla se lanzará la tarea "Registrar decisión sobre llaves".</span></font></p></div>', null, null, null, null,1,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarLanzamientoEfectuado',1,'date','fecha','Fecha lanzamiento efectivo','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarLanzamientoEfectuado',2,'combo','comboFuerzaPublica','Necesario Fuerza Pública','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarLanzamientoEfectuado',3,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarDecisionLlaves',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá dejar constancia de si es necesario realizar una gestión de las llaves por cambio de cerradura o no.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en el caso de ser necesaria una gestión de las llaves se iniciará el trámite para la gestión de llaves, en caso contrario se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. </p></div>', null, null, null, null,1,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarDecisionLlaves',1,'combo','comboLlaves','Gestión de Llaves','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_RegistrarDecisionLlaves',2,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_BPMTramiteGestionLlaves',0,'label','titulo','Trámite de Gestión de llaves', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_BPMTramiteMoratoriaLanzamiento',0,'label','titulo','Trámite de Moratoria de Lanzamiento', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_BPMTramiteOcupantes',0,'label','titulo','Trámite de Ocupantes', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_BPMTramiteOcupantes2',0,'label','titulo','Trámite de Ocupantes', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_ConfirmarNotificacionDeudor',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; de informar si se notific&oacute; al deudor la subrogaci&oacute;n al contrato de arrendamiento y la fecha de notificaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzar&aacute; la tarea "Presentar solicitud señalamiento de la posesi&oacute;n".</p></div>', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_ConfirmarNotificacionDeudor',1,'combo','comboNotificado','Deudor notificado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_ConfirmarNotificacionDeudor',2,'date','fechaNotificacion','Fecha notificación', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_ConfirmarNotificacionDeudor',3,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_PresentarSolicitudSenyalamientoPosesion',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Puesto que no ha podido confirmar que se ha realizado la notificaci&oacute;n al deudor, deber&aacute; dejar constancia de la fecha en la que presenta la solicitud de señalamiento de la posesi&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzar&aacute; la tarea "Registrar señalamiento de la de la posesi&oacute;n".</p></div>', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_PresentarSolicitudSenyalamientoPosesion',1,'date','fechaSenyalamiento','Fecha de señalamiento para posesión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_PresentarSolicitudSenyalamientoPosesion',2,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_SolicitarAlquilerSocial',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Deber&aacute; indicar si se ha solicitado la gesti&oacute;n de alquiler social para los ocupantes de la vivienda habitual.</p><p style="margin-bottom: 10px">Se indicar&aacute; la fecha de solicitud de gesti&oacute;n del alquiler social.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de que se haya solicitado la gesti&oacute;n del alquiler social, se lanzar&aacute; la tarea "Formalizaci&oacute;n alquiler social".</p></div>', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_SolicitarAlquilerSocial',1,'combo','gestionSolicitada','Solicitado gestión alquiler social','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_SolicitarAlquilerSocial',2,'date','fechaSolicitud','Fecha solicitud', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_SolicitarAlquilerSocial',3,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_FormalizacionAlquilerSocial',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta tarea se deber&aacute; confirmar la formalizaci&oacute;n del alquiler social y, en este caso, la fecha de formalizaci&oacute;n as&iacute; como el documento acreditativo correspondiente.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de que se haya formalizado el alquiler social, se lanzar&aacute; la tarea "Suspensi&oacute;n lanzamiento".</p></div>', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_FormalizacionAlquilerSocial',1,'combo','alquilerFormalizado','Alquiler social formalizado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null,'DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ015_FormalizacionAlquilerSocial',2,'date','fechaFormalizacion','Fecha de formalización', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_FormalizacionAlquilerSocial',3,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_SuspensionLanzamiento',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; realizar los tr&aacute;mites necesarios para suspender el lanzamiento. </p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, deber&aacute; finalizar esta actuaci&oacute;n a trav&eacute;s de la pestaña "Decisiones" indicando el motivo de la finalizaci&oacute;n.</p></div>', null, null, null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_SuspensionLanzamiento',1,'date','fechaParalizacion','Fecha paralización','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false', null, null,0,'DD'),
		T_TIPO_TFI ('CJ015_SuspensionLanzamiento',2,'textarea','observaciones','Observaciones', null, null, null, null,0,'DD')
    ); --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila
    V_TMP_TIPO_TFI T_TIPO_TFI;
BEGIN
	/*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    DBMS_OUTPUT.PUT_LINE('    Generacion de datos BPM: '||PAR_TIT_TRAMITE);

    /*
    * LOOP ARRAY BLOCK-CODE: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TPROC;
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TPROC || '......');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TPO||' = '''||V_TMP_TIPO_TPO(1)||''' Descripcion = '''||V_TMP_TIPO_TPO(2)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_TPO||' = '''||V_TMP_TIPO_TPO(1)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TPO||' = '''|| V_TMP_TIPO_TPO(1) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TPROC || ' (' ||
                        'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                        'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                        'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                        'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                        'SELECT ' ||
                        'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',
                             sysdate,' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                             '(SELECT DD_TAC_ID FROM '|| PAR_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                        '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                        '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(15)) 
                        || ''' FROM DUAL'; 

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');


    /*
    * LOOP ARRAY BLOCK-CODE: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TARPR;
    V_CODIGO_TAP := 'TAP_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TARPR || '........');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||''' Descripcion = '''||V_TMP_TIPO_TAP(9)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TAP||' = '''|| V_TMP_TIPO_TAP(2) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TARPR || ' (' ||
                        'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                        'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                        'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                        'SELECT ' ||
                        'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                        '(SELECT DD_TPO_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                        '(SELECT DD_TPO_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                        'sysdate,''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                        '(SELECT DD_TGE_ID FROM ' || PAR_ESQUEMA || '.DD_TGE_TIPO_GESTION WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                        '(SELECT DD_STA_ID FROM ' || PAR_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' 
                             ||'(select dd_tge_id from ' || PAR_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || '''),''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                        || ''' FROM DUAL';

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');



    /*
    * LOOP ARRAY BLOCK-CODE: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TPLAZ;
    V_CODIGO_PLAZAS := 'TAP_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TPLAZ || '....');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||''' Descripcion = '''||V_TMP_TIPO_PLAZAS(4)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TMP_TIPO_PLAZAS(3) ||''') ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TPLAZ || 
                        '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                        'SELECT ' ||
                        'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                        '(SELECT DD_JUZ_ID FROM ' || PAR_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                        '(SELECT DD_PLA_ID FROM ' || PAR_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                        '(SELECT TAP_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''','   ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || 
                        ''', sysdate FROM DUAL'; 

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');



    /*
    * LOOP ARRAY BLOCK-CODE: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TFITE;
    V_CODIGO1_TFI := 'TAP_CODIGO';
    V_CODIGO2_TFI := 'TFI_NOMBRE';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TFITE || '..........');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigos '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' Descripcion = '''||V_TMP_TIPO_TFI(5)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''') AND '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TFITE || 
                        '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                        'SELECT ' ||
                        'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                        '(SELECT TAP_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || 
                        ''',sysdate,0 FROM DUAL';

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');
    
    /*
	 * ---------------------------------------------------------------------------------------------------------
	 * 								ACTUALIZACIONES
	 * ---------------------------------------------------------------------------------------------------------
	 */
	EXECUTE IMMEDIATE 'UPDATE TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO=''' || V_COD_PROCEDIMIENTO || ''') WHERE TAP_CODIGO = ''H025_BPMTramiteCostas''';
	
    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
	
EXCEPTION

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                   TRATAMIENTO DE EXCEPCIONES
    *---------------------------------------------------------------------------------------------------------
    */
    WHEN OTHERS THEN
        /*
        * EXCEPTION: WHATEVER ERROR
        *---------------------------------------------------------------------
        */     
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT('[KO]');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          IF (ERR_NUM = -1427 OR ERR_NUM = -1) THEN
            DBMS_OUTPUT.put_line('[INFO] Ya existen los registros de este script insertados en la tabla '||VAR_CURR_TABLE
                              ||'. Encontrada fila num '||VAR_CURR_ROWARRAY||' de su array.');
            DBMS_OUTPUT.put_line('[INFO] Ejecute el script de limpieza del tramite '||PAR_TIT_TRAMITE||' y vuelva a ejecutar.');
          END IF;
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('SQL que ha fallado:');
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.put_line('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.put_line('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;
END;          
/ 
EXIT;
