--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150813
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc02
--## INCIDENCIA_LINK=CMREC-419
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
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Trámite de acuerdo extrajudicial de pagos';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Alberto';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'alberto.campos@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2034';                              -- [PARAMETRO] Teléfono del autor

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
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'CJ005'; -- Código de procedimiento para reemplazar

	/*
    * ARRAY TABLA1: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO(
    		/*DD_TPO_CODIGO................:*/ V_COD_PROCEDIMIENTO,
    		/*DD_TPO_DESCRIPCION...........:*/ 'T. acuerdo extrajudicial pagos - CJ',
    		/*DD_TPO_DESCRIPCION_LARGA.....:*/ 'Trámite de acuerdo extrajudicial de pagos',
    		/*DD_TPO_HTML..................:*/ null,
    		/*DD_TPO_XML_JBPM..............:*/ 'cj_acuerdoExtrajudicialPagos',
    		/*VERSION......................:*/ '0',
    		/*USUARIOCREAR.................:*/ 'DD',
    		/*BORRADO......................:*/ '0',
    		/*DD_TAC_ID(FK)................:*/ 'CO',
    		/*DD_TPO_SALDO_MIN.............:*/ null,
    		/*DD_TPO_SALDO_MAX.............:*/ null,
    		/*FLAG_PRORROGA................:*/ '1',
    		/*DTYPE........................:*/ 'MEJTipoProcedimiento',
    		/*FLAG_DERIVABLE...............:*/ '1',
    		/*FLAG_UNICO_BIEN..............:*/ '0'
    	)
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_RecepcionarComunicacionMediador',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Recepcionar comunicación del mediador',
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
			/*DD_STA_ID(FK)................:*/ 'TGESINC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUINC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_ActualizarCreditos',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Actualizar créditos y certificado de deuda',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGESCHRE',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUCHRE',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_RegistrarFechaReunion',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Registrar fecha reunión',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGERREC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'DIRREC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_RegistrarRecepcionPlanPagos',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoPROPLAPAG() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Propuesta de plan de pagos" al procedimiento.</div>''',
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Registrar recepción plan de pagos',
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
			/*DD_STA_ID(FK)................:*/ 'TGESINC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUINC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_AnalizarPropuesta',
			/*TAP_VIEW.....................:*/ 'plugin/cajamar/tramiteAcuerdoExtrajudicialPagos/analizarPropuesta',
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''CJ005_AnalizarPropuesta''][''comboConformidad''] == ''NO'' ? ''noConforme'' : ''conformeModificacion''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Analizar propuesta',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGEANREC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUANREC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_ElevarComite',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Elevar a comité',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGEANREC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUANREC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_RegistrarRespuestaComite',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Registrar respuesta comité',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGEANREC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUANREC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_ComunicarDecisionMediador',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Comunicar decisión al mediador',
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
			/*DD_STA_ID(FK)................:*/ 'TGESINC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUINC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_CelebracionReunion',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''CJ005_CelebracionReunion''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? valores[''CJ005_CelebracionReunion''][''comboConsentimiento''] == DDSiNo.SI ? ''positivoConConsentimiento'' : ''positivoSinConsentimiento'' : ''negativo''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Celebración reunión',
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
			/*DD_STA_ID(FK)................:*/ 'TGESINC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUINC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_RealizarInformeConcursal',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoINFCON() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea debe adjuntar el documento "Informe concursal" al procedimiento.</div>''',
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Realizar informe concursal',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGEANREC',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUANREC',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_ValorarInformeConcursal',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Valorar informe concursal',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGESCON',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUCON',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_AperturaConcursoConsecutivo',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Apertura concurso consecutivo',
			/*VERSION......................:*/ '0',
			/*USUARIOCREAR.................:*/ 'DD',
			/*BORRADO......................:*/ '0',
			/*TAP_ALERT_NO_RETORNO.........:*/ null,
			/*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
			/*DD_FAP_ID(FK)................:*/ null,
			/*TAP_AUTOPRORROGA.............:*/ '0',
			/*DTYPE........................:*/ 'EXTTareaProcedimiento',
			/*TAP_MAX_AUTOP................:*/ '3',
			/*DD_TGE_ID(FK)................:*/ null,
			/*DD_STA_ID(FK)................:*/ 'TGESHRE',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUHRE',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_DecisionGestorConcursal',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Tarea toma de decisión',
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
			/*DD_STA_ID(FK)................:*/ 'DGESCON',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ null,
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_DecisionGestorHRE',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Tarea toma de decisión',
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
			/*DD_STA_ID(FK)................:*/ 'DGESHRE',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ null,
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'CJ005_BPMSeguimientoCumplimientoAcuerdo',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ 'CJ002',
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Trámite de seguimiento de cumplimiento de acuerdo',
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
			/*TAP_ID(FK)...............:*/ 'CJ005_RecepcionarComunicacionMediador',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '2*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_ActualizarCreditos',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '5*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_RegistrarFechaReunion',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '5*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_RegistrarRecepcionPlanPagos',
			/*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''CJ005_RegistrarFechaReunion''][''fechaReunion'']) - 20*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_AnalizarPropuesta',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '3*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_ElevarComite',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '2*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_RegistrarRespuestaComite',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '5*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_ComunicarDecisionMediador',
			/*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''CJ005_RegistrarFechaReunion''][''fechaReunion'']) - 10*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_CelebracionReunion',
			/*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''CJ005_RegistrarFechaReunion''][''fechaReunion'']) + 1*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_RealizarInformeConcursal',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '3*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_ValorarInformeConcursal',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '5*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_AperturaConcursoConsecutivo',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '60*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'CJ005_BPMSeguimientoCumplimientoAcuerdo',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '300*24*60*60*1000L',
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
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RecepcionarComunicacionMediador',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; indicar la fecha en la que el mediador se ha puesto en contacto con la entidad para tramitar el acuerdo.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Actualizar cr&eacute;ditos y certificado de deuda".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RecepcionarComunicacionMediador',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha comunicación acuerdo',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RecepcionarComunicacionMediador',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'currency',
            /*TFI_NOMBRE.............:*/ 'importe',
            /*TFI_LABEL..............:*/ 'Importe',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RecepcionarComunicacionMediador',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ActualizarCreditos',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta pantalla deber&aacute; actualizar el saldo de los cr&eacute;ditos del deudor y obtener el nuevo certificado de deuda en caso de que sea necesario as&iacute; como indicar si existen cr&eacute;ditos privilegiados o no.</p><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha en la que se realiza la tarea.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar fecha reuni&oacute;n".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ActualizarCreditos',
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
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ActualizarCreditos',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboCreditos',
            /*TFI_LABEL..............:*/ 'Existen créditos privilegiados',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ActualizarCreditos',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarFechaReunion',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; indicar la fecha en la que se fija la reuni&oacute;n con el mediador y la fecha en la que se le notifica al mismo.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute;n la tareas "Celebraci&oacute;n reuni&oacute;n" y "Registrar recepci&oacute;n plan de pagos".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarFechaReunion',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fechaReunion',
            /*TFI_LABEL..............:*/ 'Fecha celebración reunión',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarFechaReunion',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fechaNotificacion',
            /*TFI_LABEL..............:*/ 'Fecha notificación mediador',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDPositivoNegativo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarFechaReunion',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarRecepcionPlanPagos',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; indicar la fecha en la que el mediador le ha facilitado el plan de pagos y adjuntarlo al procedimiento.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute; "Analizar propuesta".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarRecepcionPlanPagos',
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
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarRecepcionPlanPagos',
            /*TFI_ORDEN..............:*/ '2',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AnalizarPropuesta',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Tras analizar la propuesta del plan pagos enviada por el mediador deber&aacute; indicar si est&aacute; conforme o no.</p><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha en la que realiza la tarea.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Elevar a comit&eacute;" si ha indicado conformidad con la propuesta o presenta alguna alternativa. En caso contrario se lanzar&aacute; la tarea "Comunicar decisi&oacute;n al mediador".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AnalizarPropuesta',
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
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AnalizarPropuesta',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboConformidad',
            /*TFI_LABEL..............:*/ 'Conformidad',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNoModificacion',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AnalizarPropuesta',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'propuesta',
            /*TFI_LABEL..............:*/ 'Propuesta alternativa',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AnalizarPropuesta',
            /*TFI_ORDEN..............:*/ '4',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ElevarComite',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar la fecha en la que se eleva al comit&eacute; la propuesta para su evaluaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute; "Registrar respuesta comit&eacute;".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ElevarComite',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ElevarComite',
            /*TFI_ORDEN..............:*/ '2',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarRespuestaComite',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; registrar la decisión del comit&eacute; con respecto a la propuesta del plan de pagos realizada.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, la siguiente tarea ser&aacute; "Comunicar decisi&oacute;n al mediador"</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarRespuestaComite',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarRespuestaComite',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboConformidad',
            /*TFI_LABEL..............:*/ 'Conformidad comité',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RegistrarRespuestaComite',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ComunicarDecisionMediador',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; dejar constancia de la fecha en la que se notifica al mediador la postura de la entidad frente a la propuesta presentada.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:<ul style="list-style-type:square;margin-left:35px;"><li>En caso de conformidad por parte de la entidad o no existan cr&eacute;ditos privilegiados, se lanzar&aacute; la tarea "Celebraci&oacute;n reuni&oacute;n".</li><li>En caso de no conformidad por la entidad y existan cr&eacute;ditos privilegiados finalizar&aacute; el tr&aacute;mite.</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ComunicarDecisionMediador',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ComunicarDecisionMediador',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboEstado',
            /*TFI_LABEL..............:*/ 'Estado',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDEstadoVenta',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ComunicarDecisionMediador',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_CelebracionReunion',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar la fecha en la que se celebra la reuni&oacute;n, su resultado y si ha habido consentimiento o no por parte de la entidad.</p><p style="margin-bottom: 10px">Deber&aacute; notificar a la oficina del resultado de la reuni&oacute;n a trav&eacute;s del bot&oacute;n "Anotaci&oacute;n".</p><p style="margin-bottom: 10px">En caso de que el resultado sea positivo deber&aacute; notificar a Administración contable  (xxxx@cajamar.int).</p><p style="margin-bottom: 10px">En caso de que haya consentimiento deber&aacute; notificar, adem&aacute;s, a An&aacute;lisis de recuperaciones (AnalisisdeRecuperacion@cajamar.int) y Asesor&iacute;a concursal (xxxx@cajamar.int)</p><p style="margin-bottom: 10px">En caso de resultado negativo deber&oacute; enviar una notificaci&oacute;n a Administraci&oacute;n Contable (xxxx@cajamar.int), Asesor&iacute;a concursal (xxxx@cajamar.int), a HRE (xxxx@cajamar.int) y al Staff de consultor&iacute;a (StaffJuridicoConsultoriayContratacion@cajamar.int)</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>Si el resultado ha sido positivo con consentimiento se lanzar&aacute; el "Tr&aacute;mite seguimiento cumplimiento acuerdo".</li><li>Si adem&aacute;s del resultado positivo no ha habido consentimiento, se lanzar&aacute; en paralelo la tarea "Realizar informe concursal".</li><li>Si el resultado de la reuni&oacute;n ha sido negativo, se lanzar&aacute; la tarea "Apertura concurso consecutivo".</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_CelebracionReunion',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_CelebracionReunion',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboResultado',
            /*TFI_LABEL..............:*/ 'Resultado',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDPositivoNegativo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_CelebracionReunion',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboConsentimiento',
            /*TFI_LABEL..............:*/ 'Consentimiento',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_CelebracionReunion',
            /*TFI_ORDEN..............:*/ '4',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RealizarInformeConcursal',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En vista del resultado de la reuni&oacute;n, cuando &eacute;sta sea positiva sin el consentimiento de la caja, deber&aacute; adjuntar al procedimiento un informe concursal para que su supervisor pueda valorar la situaci&oacute;n en la que queda el concurso.</p><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha en la que realiza este informe.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Valorar informe concursal".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RealizarInformeConcursal',
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
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_RealizarInformeConcursal',
            /*TFI_ORDEN..............:*/ '2',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ValorarInformeConcursal',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar la fecha en que revisa el informe concursal realizado por el gestor.</p><p style="margin-bottom: 10px">En el campo Resultado indicar el resultado de esta revisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ValorarInformeConcursal',
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
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ValorarInformeConcursal',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboResultado',
            /*TFI_LABEL..............:*/ 'Resultado',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDPositivoNegativo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_ValorarInformeConcursal',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AperturaConcursoConsecutivo',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que no ha existido acuerdo, estaremos a la espera de la declaraci&oacute;n, por auto del concurso consecutivo.</p><p style="margin-bottom: 10px">Cuando se tenga el auto, se indicar&aacute; la fecha de realizaci&oacute;n de la tarea, as&iacute; como el solicitante del concurso connsecutivo.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AperturaConcursoConsecutivo',
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
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AperturaConcursoConsecutivo',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'text',
            /*TFI_NOMBRE.............:*/ 'solicitante',
            /*TFI_LABEL..............:*/ 'Solicitante',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_AperturaConcursoConsecutivo',
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
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'CJ005_BPMSeguimientoCumplimientoAcuerdo',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se inicia el tr&aacute;mite de seguimiento de cumplimiento de acuerdo.</p></div>',
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
