--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20151001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-832
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite de posesión interina
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas
    
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
    V_TAREA VARCHAR(50 CHAR);
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'H015'; -- Código de procedimiento para reemplazar
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'H015_BPMTramiteNotificacion',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ 'P400',
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Trámite de notificación',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ null,
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ null,
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'H015_AutorizarSuspension',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''H015_AutorizarSuspension''][''resultado''] == ''ACEPTADO'' ? ''aceptado'' : ''denegado''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Autorizar suspensión',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGCTRGE',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'DRECU',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'H015_ConfirmarFormalizacion',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ 'valores[''H015_ConfirmarFormalizacion''][''alquilerFormalizado''] == DDSiNo.SI && !comprobarExisteDocumento(''CAS'') ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Debe adjuntar el documento "Contrato de alquiler social".</p></div>'' : null',
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''H015_ConfirmarFormalizacion''][''alquilerFormalizado''] == DDSiNo.SI ? ''si'' : ''no''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Confirmar formalización alquiler social',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'CJ-811',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-SAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'H015_TramitePosesionDecision',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Tarea de toma de decisión',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ null,
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'CJ-DGAREO',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ null,
			/*TAP_BUCLE_BPM................:*/ null        
		)
	);
    V_TMP_TIPO_TAP T_TIPO_TAP;    
    
    /*
    * ARRAYS TABLA3: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
       T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H015_BPMTramiteNotificacion',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '300*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H015_AutorizarSuspension',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '3*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H015_ConfirmarFormalizacion',
          /*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''H015_SuspensionLanzamiento''][''fechaFormalizacion'']) + 30*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        )
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    /*
    * ARRAYS TABLA4: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_BPMTramiteNotificacion',
        	/*TFI_ORDEN..............:*/ '0',
        	/*TFI_TIPO...............:*/ 'label',
        	/*TFI_NOMBRE.............:*/ 'titulo',
        	/*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Se lanza el Trámite de Notificación.</p></div>',
        	/*TFI_ERROR_VALIDACION...:*/ null,
			/*TFI_VALIDACION.........:*/ null,
			/*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ null,
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_AutorizarSuspension',
        	/*TFI_ORDEN..............:*/ '0',
        	/*TFI_TIPO...............:*/ 'label',
        	/*TFI_NOMBRE.............:*/ 'titulo',
        	/*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta tarea, la entidad se deber&aacute; confirmar si autoriza propuesta del gestor de admisi&oacute;n por el gestor.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, y en caso de que la Entidad autorice la decisi&oacute;n, se lanzar&aacute; la tarea "Lectura de instrucciones moratoria". En caso contrario, la Entidad deber&aacute; indicar c&oacute;mo proceder.</p></div>',
        	/*TFI_ERROR_VALIDACION...:*/ null,
			/*TFI_VALIDACION.........:*/ null,
			/*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ null,
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_AutorizarSuspension',
        	/*TFI_ORDEN..............:*/ '1',
        	/*TFI_TIPO...............:*/ 'date',
        	/*TFI_NOMBRE.............:*/ 'fecha',
        	/*TFI_LABEL..............:*/ 'Fecha',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ null,
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_AutorizarSuspension',
        	/*TFI_ORDEN..............:*/ '2',
        	/*TFI_TIPO...............:*/ 'combo',
        	/*TFI_NOMBRE.............:*/ 'resultado',
        	/*TFI_LABEL..............:*/ 'Resultado',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
			/*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ 'DDAceptadoDenegado',
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_AutorizarSuspension',
        	/*TFI_ORDEN..............:*/ '3',
        	/*TFI_TIPO...............:*/ 'textarea',
        	/*TFI_NOMBRE.............:*/ 'observaciones',
        	/*TFI_LABEL..............:*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
			/*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ null,
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_FormalizacionAlquilerSocial',
        	/*TFI_ORDEN..............:*/ '2',
        	/*TFI_TIPO...............:*/ 'combo',
        	/*TFI_NOMBRE.............:*/ 'posibleFormalizacion',
        	/*TFI_LABEL..............:*/ 'Es posible la formalización',
			/*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
			/*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_ConfirmarFormalizacion',
        	/*TFI_ORDEN..............:*/ '0',
        	/*TFI_TIPO...............:*/ 'label',
        	/*TFI_NOMBRE.............:*/ 'titulo',
        	/*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Tras la suspensi&oacute;n del lanzamiento, deber&aacute; indicar la fecha en la que finalmente formaliza el alquiler social. En caso de que no se llegase a formalizar, deber&aacute;n indicarlo en el campo correspondiente.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, deberá finalizar esta actuaci&oacute;n a trav&eacute;s de la pestaña "Decisiones" indicando el motivo de la finalizaci&oacute;n.</p></div>',
        	/*TFI_ERROR_VALIDACION...:*/ null,
			/*TFI_VALIDACION.........:*/ null,
			/*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ null,
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_ConfirmarFormalizacion',
        	/*TFI_ORDEN..............:*/ '1',
        	/*TFI_TIPO...............:*/ 'combo',
        	/*TFI_NOMBRE.............:*/ 'alquilerFormalizado',
        	/*TFI_LABEL..............:*/ 'Alquiler social formalizado',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_ConfirmarFormalizacion',
        	/*TFI_ORDEN..............:*/ '2',
        	/*TFI_TIPO...............:*/ 'date',
        	/*TFI_NOMBRE.............:*/ 'fecha',
        	/*TFI_LABEL..............:*/ 'Fecha formalización',
			/*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
			/*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ null,
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		),
        T_TIPO_TFI(
        	/*DD_TAP_ID..............:*/ 'H015_ConfirmarFormalizacion',
        	/*TFI_ORDEN..............:*/ '3',
        	/*TFI_TIPO...............:*/ 'textarea',
        	/*TFI_NOMBRE.............:*/ 'observaciones',
        	/*TFI_LABEL..............:*/ 'Observaciones',
			/*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
			/*TFI_VALOR_INICIAL......:*/ null,
			/*TFI_BUSINESS_OPERATION.:*/ null,
			/*VERSION................:*/ '0',
			/*USUARIOCREAR...........:*/ 'DD'
		)	
    ); --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN		
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; de informar si se notific&oacute; al deudor la subrogaci&oacute;n al contrato de arrendamiento y la fecha de notificaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea en caso de que el deudor est&eacute; notificado se lanzar&aacute; la tarea "Presentar solicitud se&ntilde;alamiento de la posesi&oacute;n". En caso contrario, se lanzar&aacute; el tr&aacute;mite de Notificaci&oacute;n.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_ConfirmarNotificacionDeudor'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H015_ConfirmarNotificacionDeudor actualizada.');
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/cajamar/tramitePosesion/formalizacionAlquilerSocial'', TAP_SCRIPT_VALIDACION = NULL, TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H015_RegistrarPosesionYLanzamiento''''][''''comboLanzamiento''''] == DDSiNo.SI && valores[''''H015_RegistrarSenyalamientoLanzamiento''''][''''fecha''''] == null  && (valores[''''H015_FormalizacionAlquilerSocial''''][''''alquilerFormalizado''''] == DDSiNo.SI || valores[''''H015_FormalizacionAlquilerSocial''''][''''posibleFormalizacion''''] == DDSiNo.SI) ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario haber informado de la fecha de lanzamiento en la tarea "Registrar se&ntilde;alamiento del lanzamiento" para finalizar esta tarea.</div>'''' : valores[''''H015_FormalizacionAlquilerSocial''''][''''alquilerFormalizado''''] == DDSiNo.SI ? comprobarExisteDocumento(''''CAS'''') ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>Debe adjuntar el documento "Contrato de alquiler social".</p></div></div>'''' : null'', TAP_SCRIPT_DECISION = ''valores[''''H015_RegistrarSenyalamientoLanzamiento''''][''''fecha''''] != null && (valores[''''H015_FormalizacionAlquilerSocial''''][''''alquilerFormalizado''''] == DDSiNo.SI || valores[''''H015_FormalizacionAlquilerSocial''''][''''posibleFormalizacion''''] == DDSiNo.SI) ?  ''''Si'''' : ''''No'''''' WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''7*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta tarea deber&aacute; indicar si ha formalizado o no el alquiler social. En caso negativo, deber&aacute; indicar en el campo "Es posible la formalizaci&oacute;n" si preve&eacute; que es posible que se firme o si definitivamente no se formalizar&aacute; en ning&uacute;n caso.</p><p style="margin-bottom: 10px">Tenga en cuenta que en caso de haya lanzamiento, deber&aacute; registar primera la fecha de lanzamiento en la tarea correspondiente, antes de finalizar &eacute;sta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul><li>En caso de que se haya formalizado el alquiler social y no haya lanzamiento, deber&aacute; finalizar esta actuaci&oacute;n a trav&eacute;s de la pestaña "Decisiones" indicando el motivo de la finalizaci&oacute;n.</li><li>En caso de que se haya formalizado el alquiler social y haya fijada una fecha para el lanzamiento, se lanzar&aacute; una tarea a la entidad para autorizar la suspensi&oacute;n del lanzamiento.</li><li>En caso de que no se haya formalizado pero s&iacute; sea posible formalizarlo y haya fijada una fecha para el lanzamiento, se lanzar&aacute; una tarea a la entidad para autorizar la suspensi&oacute;n del lanzamiento.</li><li>En caso de que no se formalice el alquiler y no sea posible formalizarlo, deber&aacute; continuar con el lanzamiento.</li></ul></p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3 WHERE TFI_NOMBRE = ''fechaFormalizacion'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 4 WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H015_FormalizacionAlquilerSocial actualizada.');
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''!comprobarExisteDocumento(''''ESCSUS'''') ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>Debe adjuntar el documento "Escrito de suspensi&oacute;n".</p></div>'''' : null'', TAP_SCRIPT_DECISION = ''valores[''''H015_FormalizacionAlquilerSocial''''][''''alquilerFormalizado''''] == DDSiNo.SI ? ''''si'''' : ''''no'''''' WHERE TAP_CODIGO = ''H015_SuspensionLanzamiento''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; realizar los tr&aacute;mites necesarios para suspender el lanzamiento, as&iacute; como adjuntar el Escrito de suspensi&oacute;n presentado en el juzgado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, y en caso de que hubiera formalizado anteriormente el alquiler social, deber&aacute; finalizar esta actuaci&oacute;n a trav&eacute;s de la pestaña "Decisiones" indicando el motivo de la finalizaci&oacute;n. En caso contrario, se lanzar&aacute; la tarea Confirmar formalizaci&oacute;n del alquiler social.</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_SuspensionLanzamiento'')';
	DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H015_SuspensionLanzamiento actualizada.');
	
	/*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    DBMS_OUTPUT.PUT_LINE('    Generacion de datos BPM: '||PAR_TIT_TRAMITE);

    /*
    * LOOP ARRAY BLOCK-CODE: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TARPR;
    V_CODIGO_TAP := 'TAP_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||V_ESQUEMA||'.' || PAR_TABLENAME_TARPR || '........');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||''' Descripcion = '''||V_TMP_TIPO_TAP(9)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TAP||' = '''|| V_TMP_TIPO_TAP(2) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || PAR_TABLENAME_TARPR || ' (' ||
                        'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                        'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                        'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                        'SELECT ' ||
                        'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                        '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                        '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
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
                        '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA || '.DD_TGE_TIPO_GESTION WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                        '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' 
                             ||'(select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || '''),''' 
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
    DBMS_OUTPUT.PUT('    [INSERT] '||V_ESQUEMA||'.' || PAR_TABLENAME_TPLAZ || '....');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||''' Descripcion = '''||V_TMP_TIPO_PLAZAS(4)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TMP_TIPO_PLAZAS(3) ||''') ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || PAR_TABLENAME_TPLAZ || 
                        '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                        'SELECT ' ||
                        'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                        '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                        '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                        '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
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
    DBMS_OUTPUT.PUT('    [INSERT] '||V_ESQUEMA||'.' || PAR_TABLENAME_TFITE || '..........');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigos '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' Descripcion = '''||V_TMP_TIPO_TFI(5)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''') AND '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || PAR_TABLENAME_TFITE || 
                        '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                        'SELECT ' ||
                        'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                        '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
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