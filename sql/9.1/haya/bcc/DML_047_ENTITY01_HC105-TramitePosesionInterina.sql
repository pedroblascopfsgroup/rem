--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc02
--## INCIDENCIA_LINK=CMREC-390
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
    PAR_TIT_TRAMITE VARCHAR2(75 CHAR)   := 'Trámite de posesión interina';   -- [PARAMETRO] Título del trámite
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
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'HC105'; -- Código de procedimiento para reemplazar

	/*
    * ARRAY TABLA1: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO(
    		/*DD_TPO_CODIGO................:*/ V_COD_PROCEDIMIENTO,
    		/*DD_TPO_DESCRIPCION...........:*/ 'T. posesión interina - HCJ',
    		/*DD_TPO_DESCRIPCION_LARGA.....:*/ 'Trámite de posesión interina',
    		/*DD_TPO_HTML..................:*/ null,
    		/*DD_TPO_XML_JBPM..............:*/ 'hcj_posesionInterina',
    		/*VERSION......................:*/ '0',
    		/*USUARIOCREAR.................:*/ 'DD',
    		/*BORRADO......................:*/ '0',
    		/*DD_TAC_ID(FK)................:*/ 'TR',
    		/*DD_TPO_SALDO_MIN.............:*/ null,
    		/*DD_TPO_SALDO_MAX.............:*/ null,
    		/*FLAG_PRORROGA................:*/ '1',
    		/*DTYPE........................:*/ 'MEJTipoProcedimiento',
    		/*FLAG_DERIVABLE...............:*/ '1',
    		/*FLAG_UNICO_BIEN..............:*/ '0')
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
			/*TAP_CODIGO...................:*/ 'HC105_SolicitudPosesionInterina',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Solicitud de posesión interina',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_DecretoAdmision',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoDECADM() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Decreto de admisi&oacute;n"</div>''',
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''HC105_DecretoAdmision''][''comboAdmision''] == DDSiNo.SI ? vieneDeTramiteHipotecario() ? valores[''HC105_SolicitudPosesionInterina''][''comboOcupado''] == DDSiNo.SI ? ''admitidoHipotecarioOcupantes'' : ''admitidoHipotecarioSinOcupantes'' : ''admitidoNoHipotecario'' : ''noAdmitido''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Decreto de admisión',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_NotificacionOcupante',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Notificación ocupante',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_RegistrarFechaPosesionInterina',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Registrar fecha de posesión interina',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_RendicionCuentasSecretarioJudicial',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Rendición de cuentas ante el secretario judicial',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_AprobacionRendicionCuentas',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''HC105_AprobacionRendicionCuentas''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''positivo'' : ''negativo''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Aprobación de la rendición de cuentas',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_PresentacionRendicionCuentas',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Presentación de la rendición de cuentas al secretario judicial',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_RegistrarNotificacionRendicionCuentas',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Registrar notificación de rendición de cuentas al ejecutado',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_RegistrarDisconformidadEjecutado',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''HC105_RegistrarDisconformidadEjecutado''][''comboDisconformidad''] == DDSiNo.SI ? ''disconformidad'' : valores[''HC105_PresentacionRendicionCuentas''][''comboPosesion''] == DDSiNo.NO ? ''conformidadContinuaPosesion'' : ''conformidadFinPosesion''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Registrar disconformidad del ejecutado',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_AlegacionesDisconformidad',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''HC105_AlegacionesDisconformidad''][''comboAlegaciones''] == DDSiNo.SI ? ''conAlegaciones'' : valores[''HC105_PresentacionRendicionCuentas''][''comboPosesion''] == DDSiNo.NO ? ''sinAlegacionesContinuaPosesion'' : ''sinAlegacionesFinPosesion''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Alegaciones a la disconformidad',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_ConfirmaFechaVista',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Confirmar fecha vista',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_CelebracionVista',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Celebración vista',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC105_RegistrarResolucion',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''HC105_RegistrarResolucion''][''comboResultado''] == ''MOD'' || (valores[''HC105_RegistrarResolucion''][''comboResultado''] == ''FAV'' && valores[''HC105_PresentacionRendicionCuentas''][''comboPosesion''] == DDSiNo.NO) ? ''favorableContinuaPosesion'' : valores[''HC105_RegistrarResolucion''][''comboResultado''] == ''FAV'' && valores[''HC105_PresentacionRendicionCuentas''][''comboPosesion''] == DDSiNo.SI ? ''favorableFinPosesion'' : ''desfavorable''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Registrar resolución',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-814',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-GAREO',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'HC015_DecisionLetrado',
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
			/*DD_STA_ID(FK)................:*/ 'CJ-819',
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
          /*TAP_ID(FK)...............:*/ 'HC105_SolicitudPosesionInterina',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '(valoresBPMPadre[''H001_ConfirmarNotificacionReqPago''] != null && valoresBPMPadre[''H001_ConfirmarNotificacionReqPago''][''fecha''] != null ? damePlazo(valoresBPMPadre[''H001_ConfirmarNotificacionReqPago''][''fecha'']) : valoresBPMPadre[''H018_ConfirmarNotificacion''] != null && valoresBPMPadre[''H018_ConfirmarNotificacion''][''fecha''] != null ? damePlazo(valoresBPMPadre[''H018_ConfirmarNotificacion''][''fecha'']) : valoresBPMPadre[''H020_ConfirmarNotifiReqPago''] != null && valoresBPMPadre[''H020_ConfirmarNotifiReqPago''][''fecha''] ? damePlazo(valoresBPMPadre[''H020_ConfirmarNotifiReqPago''][''fecha'']) : 0) + 10*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_DecretoAdmision',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '30*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_NotificacionOcupante',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '30*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_RegistrarFechaPosesionInterina',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '30*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_RendicionCuentasSecretarioJudicial',
          /*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''HC105_RegistrarFechaPosesionInterina''][''fecha'']) + 730*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_AprobacionRendicionCuentas',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '30*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_PresentacionRendicionCuentas',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '365*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_RegistrarNotificacionRendicionCuentas',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '30*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_RegistrarDisconformidadEjecutado',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '15*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_AlegacionesDisconformidad',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '9*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_ConfirmaFechaVista',
          /*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''HC105_AlegacionesDisconformidad''][''fecha'']) + 10*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_CelebracionVista',
          /*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''HC105_ConfirmaFechaVista''][''fecha''])',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'HC105_RegistrarResolucion',
          /*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''HC105_ConfirmaFechaVista''][''fecha'']) + 20*24*60*60*1000L',
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
            /*DD_TAP_ID..............:*/ 'HC105_SolicitudPosesionInterina',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; dejar constancia en la herramienta de la fecha de presentaci&oacute;n de la solicitud de posesi&oacute;n interina.</p><p style="margin-bottom: 10px">Antes de dar por terminada esta tarea deber&aacute; señalar si el bien est&aacute; ocupado o no, as&iacute; como el tipo de bien de entre el listado disponible.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la siguiente tarea "Decreto de admisi&oacute;n".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_SolicitudPosesionInterina',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha presentación solicitud',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_SolicitudPosesionInterina',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboOcupado',
            /*TFI_LABEL..............:*/ 'Ocupado',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_SolicitudPosesionInterina',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboBien',
            /*TFI_LABEL..............:*/ 'Tipo de bien',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDTipoBien',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_SolicitudPosesionInterina',
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
            /*DD_TAP_ID..............:*/ 'HC105_DecretoAdmision',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar si se admitido la solicitud de posesi&oacute;n interina o no.</p><p style="margin-bottom: 10px">Tenga en cuenta que para el supuesto de que decida en cualquier momento la finalizaci&oacute;n de la administraci&oacute;n por la satisfacci&oacute;n del derecho de la entidad podr&aacute; realizarlo mediante la finalizaci&oacute;n del tr&aacute;mite solicit&aacute;ndolo a su supervisor</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>Si ha sido admitido, provenimos de un procedimiento hipotecario y el bien est&aacute; ocupado, se lanzar&aacute; la tarea "Notificaci&oacute;n ocupante".</li><li>Si ha sido admitido, provenimos de un procedimiento hipotecario y el bien no est&aacute; ocupado, se lanzar&aacute; la tarea "Registrar fecha de posesi&oacute;n interina".</li><li>Si ha sido admitido y provenimos de un procedimiento ordinario se lanzar&aacute; la tarea "Presentaci&oacute;n de la rendici&oacute;n de cuentas al secretario judicial"</li><li>Si no ha sido admitido, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_DecretoAdmision',
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
            /*DD_TAP_ID..............:*/ 'HC105_DecretoAdmision',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboAdmision',
            /*TFI_LABEL..............:*/ 'Admisión',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_DecretoAdmision',
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
            /*DD_TAP_ID..............:*/ 'HC105_NotificacionOcupante',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; informar de la fecha en la que notifica al ocupante del inmueble objeto de la posesi&oacute;n, de la obligatoriedad de pagar las rentas o los frutos a la entidad, como administrador interino de la propiedad.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar fecha de posesi&oacute;n interna".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_NotificacionOcupante',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha notificación',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_NotificacionOcupante',
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
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarFechaPosesionInterina',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; determina la fecha en la que toma la posesi&oacute;n interina del bien.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Rendici&oacute;n de cuentas ante el secretario judicial".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarFechaPosesionInterina',
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
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarFechaPosesionInterina',
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
            /*DD_TAP_ID..............:*/ 'HC105_RendicionCuentasSecretarioJudicial',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea deber&aacute; dejar constancia de la fecha de presentaci&oacute;n y traslado del escrito de rendici&oacute;n de cuentas al secretario judicial.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar fecha de posesi&oacute;n interna".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RendicionCuentasSecretarioJudicial',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha escrito',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RendicionCuentasSecretarioJudicial',
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
            /*DD_TAP_ID..............:*/ 'HC105_AprobacionRendicionCuentas',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; indicar el resultado de la rendici&oacute;n de cuentas ante el secretario judicial.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar de la fecha en la que se le comunica este resultado.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>Si el resultado es positivo, finalizar&aacute; el tr&aacute;mite.</li><li>Si el resultado es negativo, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_AprobacionRendicionCuentas',
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
            /*DD_TAP_ID..............:*/ 'HC105_AprobacionRendicionCuentas',
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
            /*DD_TAP_ID..............:*/ 'HC105_AprobacionRendicionCuentas',
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
            /*DD_TAP_ID..............:*/ 'HC105_PresentacionRendicionCuentas',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea deber&aacute; dejar constancia de la fecha de presentaci&oacute;n y traslado del escrito de rendici&oacute;n de cuentas al secretario judicial.</p><p style="margin-bottom: 10px">En el supuesto de que finalice la posesi&oacute;n interina del bien, deber&aacute; anotarlo en el campo "Finaliza posesi&oacute;n".</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar notificaci&oacute;n de rendici&oacute;n de cuentas al ejecutado".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_PresentacionRendicionCuentas',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha presentación',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_PresentacionRendicionCuentas',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboPosesion',
            /*TFI_LABEL..............:*/ 'Finaliza posesión',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_PresentacionRendicionCuentas',
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
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarNotificacionRendicionCuentas',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Informar de la fecha en la que el secretario judicial da traslado de la rendici&oacute;n de cuentas presentada por la Entidad, al ejecutado para que se manifieste al respecto de las mismas.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar disconformidad del ejecutado".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarNotificacionRendicionCuentas',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha notificación',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarNotificacionRendicionCuentas',
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
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarDisconformidadEjecutado',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por finalizada esta tarea, deber&aacute; informar si el ejecutado manifiesta conformidad o no conformidad con el escrito de rendici&oacute;n de cuentas.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>En caso de que haya disconformidad, se lanzar&aacute; la tarea "Alegaciones a la disconformidad".</li><li>En caso de que no haya disconformidad y haya indicado que no finaliza la posesi&oacute;n, se lanzar&aacute; la tarea "Presentaci&oacute;n de la rendici&oacute;n de cuentas al secretario judicial".</li><li>En caso de que no haya disconformidad y haya indicado que finaliza la posesi&oacute;n, finalizar&aacute; el tr&aacute;mite.</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarDisconformidadEjecutado',
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
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarDisconformidadEjecutado',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboDisconformidad',
            /*TFI_LABEL..............:*/ 'Disconformidad ejecutado',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarDisconformidadEjecutado',
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
            /*DD_TAP_ID..............:*/ 'HC105_AlegacionesDisconformidad',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; informar si presenta o no alegaciones a la disconformidad manifestada por el ejecutado.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; anotar la fecha en la que finaliza la tarea.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>En caso de presentar alegaciones, se lanzar&aacute; la tarea "Confirmar fecha vista".</li><li>En caso de no presentar alegaciones y continuar con la posesi&oacute;n se lanzar&aacute; la tarea "Presentaci&oacute;n de la rendici&oacute;n de cuentas al secretario judicial".</li><li>En caso de no presentar alegaciones y finalizar la posesi&oacute;n, finalizar&aacute; el tr&aacute;mite.</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_AlegacionesDisconformidad',
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
            /*DD_TAP_ID..............:*/ 'HC105_AlegacionesDisconformidad',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboAlegaciones',
            /*TFI_LABEL..............:*/ 'Presenta alegaciones',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_AlegacionesDisconformidad',
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
            /*DD_TAP_ID..............:*/ 'HC105_ConfirmaFechaVista',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de informar la fecha en la que se ha fijado la celebraci&oacute;n de la vista.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Celebraci&oacute;n vista".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_ConfirmaFechaVista',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha vista',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_ConfirmaFechaVista',
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
            /*DD_TAP_ID..............:*/ 'HC105_CelebracionVista',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Despu&eacute;s de celebrada la vista, en esta pantalla debemos de informar la fecha en la que se ha celebrado.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar resoluci&oacute;n".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_CelebracionVista',
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
            /*DD_TAP_ID..............:*/ 'HC105_CelebracionVista',
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
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarResolucion',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; de informar la fecha de notificaci&oacute;n de la Resoluci&oacute;n que hubiere reca&iacute;do como consecuencia de la vista celebrada.</p><p style="margin-bottom: 10px">Se indicar&aacute; si el resultado de dicha resoluci&oacute;n ha sido o no favorable para los intereses de la entidad o bien es necesario modificar el escrito de rendici&oacute;n de cuentas presentado con anterioridad.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>En caso de que el resultado fuese modificar el escrito o bien fuese favorable y adem&aacute;s contin&uacute;a la posesi&oacute;n, se lanzar&aacute; la tarea "Presentaci&oacute;n de la rendici&oacute;n de cuentas al secretario judicial".</li><li>En el caso de que el resultado fuese favorable y adem&aacute;s finaliza la posesi&oacute;n, finalizar&aacute; el tr&aacute;mite.</li><li>En el caso de que el resultado fuese desfavorable, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarResolucion',
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
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarResolucion',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboResultado',
            /*TFI_LABEL..............:*/ 'Resultado',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDPosesionInterinaResolucion',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'HC105_RegistrarResolucion',
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
     * Desactivamos trámites antiguos si existen
     */
    V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' WHERE '||V_CODIGO_TPO||' = ''P07'' AND BORRADO=0 ';
        
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
	    V_SQL := 'UPDATE '||PAR_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' SET BORRADO=1 WHERE '||V_CODIGO_TPO||' = ''P07'' AND BORRADO=0 ';
        DBMS_OUTPUT.PUT_LINE('Trámite antiguo desactivado.');
        EXECUTE IMMEDIATE V_SQL;        
	END IF;    

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
