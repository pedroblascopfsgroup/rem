--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hcj
--## INCIDENCIA_LINK=CMREC-402
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
    PAR_TIT_TRAMITE VARCHAR2(75 CHAR)   := 'Trámite de fase común';   -- [PARAMETRO] Título del trámite
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
    V_TAREA VARCHAR(50 CHAR);

    VAR_SEQUENCENAME VARCHAR2(50 CHAR);                 -- Variable para secuencias
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones

    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    V_CODIGO_PLAZAS VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Plazos
    V_CODIGO1_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo1 FK con codigo de TFI Items
    V_CODIGO2_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo2 FK con codigo de TFI Items
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'H009'; -- Código de procedimiento para reemplazar
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
	      T_TIPO_TAP(
	        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
	        /*TAP_CODIGO...................:*/ 'H009_RevisarEjecuciones',
	        /*TAP_VIEW.....................:*/ null,
	        /*TAP_SCRIPT_VALIDACION........:*/ null,
	        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
	        /*TAP_SCRIPT_DECISION..........:*/ null,
	        /*DD_TPO_ID_BPM(FK)............:*/ null,
	        /*TAP_SUPERVISOR,..............:*/ '0',
	        /*TAP_DESCRIPCION,.............:*/ 'Revisar ejecuciones',
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
	        /*DD_STA_ID(FK)................:*/ 'TGESCON',
	        /*TAP_EVITAR_REORG.............:*/ null,
	        /*DD_TSUP_ID(FK)...............:*/ 'SUCON',
	        /*TAP_BUCLE_BPM................:*/ null        
	        ),
	        T_TIPO_TAP(
	        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
	        /*TAP_CODIGO...................:*/ 'H009_RectificarInsinuacionCreditos',
	        /*TAP_VIEW.....................:*/ null,
	        /*TAP_SCRIPT_VALIDACION........:*/ null,
	        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
	        /*TAP_SCRIPT_DECISION..........:*/ null,
	        /*DD_TPO_ID_BPM(FK)............:*/ null,
	        /*TAP_SUPERVISOR,..............:*/ '0',
	        /*TAP_DESCRIPCION,.............:*/ 'Rectificar insinuación de créditos y presentar escrito',
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
	        /*DD_STA_ID(FK)................:*/ 'TGESHRE',
	        /*TAP_EVITAR_REORG.............:*/ null,
	        /*DD_TSUP_ID(FK)...............:*/ 'GESCON',
	        /*TAP_BUCLE_BPM................:*/ null        
	        ),
	        T_TIPO_TAP(
	        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
	        /*TAP_CODIGO...................:*/ 'H009_PresentacionAdenda',
	        /*TAP_VIEW.....................:*/ null,
	        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoRESADE() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento "Resoluci&oacute;n de la adenda"</div>''',
	        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
	        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H009_PresentacionAdenda''][''comboAdenda''] == DDSiNo.SI ? ''si'' : ''no''',
	        /*DD_TPO_ID_BPM(FK)............:*/ null,
	        /*TAP_SUPERVISOR,..............:*/ '0',
	        /*TAP_DESCRIPCION,.............:*/ 'Presentación adenda',
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
	        /*DD_STA_ID(FK)................:*/ 'TGESCON',
	        /*TAP_EVITAR_REORG.............:*/ null,
	        /*DD_TSUP_ID(FK)...............:*/ 'SUCON',
	        /*TAP_BUCLE_BPM................:*/ null        
	        ),
	        T_TIPO_TAP(
	        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
	        /*TAP_CODIGO...................:*/ 'H009_PresentacionJuzgado',
	        /*TAP_VIEW.....................:*/ null,
	        /*TAP_SCRIPT_VALIDACION........:*/ null,
	        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
	        /*TAP_SCRIPT_DECISION..........:*/ null,
	        /*DD_TPO_ID_BPM(FK)............:*/ null,
	        /*TAP_SUPERVISOR,..............:*/ '0',
	        /*TAP_DESCRIPCION,.............:*/ 'Presentación juzgado',
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
	        /*DD_STA_ID(FK)................:*/ 'TGESCON',
	        /*TAP_EVITAR_REORG.............:*/ null,
	        /*DD_TSUP_ID(FK)...............:*/ 'SUCON',
	        /*TAP_BUCLE_BPM................:*/ null        
	        ),
	        T_TIPO_TAP(
	        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
	        /*TAP_CODIGO...................:*/ 'H009_ResolucionJuzgado',
	        /*TAP_VIEW.....................:*/ null,
	        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoRESJUZ() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento "Resoluci&oacute;n juzgado"</div>''',
	        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
	        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H009_ResolucionJuzgado''][''comboAdmitida''] == DDSiNo.SI ? ''si'' : ''no''',
	        /*DD_TPO_ID_BPM(FK)............:*/ null,
	        /*TAP_SUPERVISOR,..............:*/ '0',
	        /*TAP_DESCRIPCION,.............:*/ 'Resolución juzgado',
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
	        /*DD_STA_ID(FK)................:*/ 'TGESCON',
	        /*TAP_EVITAR_REORG.............:*/ null,
	        /*DD_TSUP_ID(FK)...............:*/ 'SUCON',
	        /*TAP_BUCLE_BPM................:*/ null        
	        ),
	        T_TIPO_TAP(
	        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
	        /*TAP_CODIGO...................:*/ 'H009_AnyadirTextosDefinitivos',
	        /*TAP_VIEW.....................:*/ null,
	        /*TAP_SCRIPT_VALIDACION........:*/ null,
	        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
	        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H009_AnyadirTextosDefinitivos''][''comboLiquidacion''] == DDSiNo.SI ? ''si'' : ''no''',
	        /*DD_TPO_ID_BPM(FK)............:*/ null,
	        /*TAP_SUPERVISOR,..............:*/ '0',
	        /*TAP_DESCRIPCION,.............:*/ 'Añadir textos definitivos',
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
	        /*DD_STA_ID(FK)................:*/ 'TGESCON',
	        /*TAP_EVITAR_REORG.............:*/ null,
	        /*DD_TSUP_ID(FK)...............:*/ 'SUCON',
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
          /*TAP_ID(FK)...............:*/ 'H009_RevisarEjecuciones',
          /*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''H009_RegistrarPublicacionBOE''][''fecha'']) + 365*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H009_RectificarInsinuacionCreditos',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '2*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H009_PresentacionAdenda',
          /*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valores[''H009_RegistrarInformeAdmonConcursal''][''fecha'']) + 5*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H009_PresentacionJuzgado',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '1*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H009_ResolucionJuzgado',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '20*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),
        T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H009_AnyadirTextosDefinitivos',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '180*24*60*60*1000L',
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
            /*DD_TAP_ID..............:*/ 'H009_RevisarEjecuciones',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se lanzar&aacute; esta tarea a un año vista desde la fecha de auto de declaraci&oacute;n en el BOE.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; acceder a la pestaña "An&aacute;lisis de contratos" de la ficha del asunto correspondiente y revisar el estado del an&aacute;lisis de las operaciones que forman parte del concurso. Recuerde que dispone de las anotaciones para consultar cualquier detalle que considere oportuno.</p><p style="margin-bottom: 10px">En el campo Fecha deberá de informar la fecha en que haya realizado la revisión de las operaciones.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_RevisarEjecuciones',
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
            /*DD_TAP_ID..............:*/ 'H009_RevisarEjecuciones',
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
            /*DD_TAP_ID..............:*/ 'H009_RevisarInsinuacionCreditos',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboRectificacion',
            /*TFI_LABEL..............:*/ 'Requiere rectificar',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_RectificarInsinuacionCreditos',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Atendiendo a las instrucciones de la entidad, antes de rellenar esta pantalla deber&aacute; rectificar las insinuaciones de cr&eacute;dito realizadas. Para ello deber&aacute; ir a la pestaña "Fase com&uacute;n" de la ficha del asunto correspondiente y proceder a su insinuaci&oacute;n, para lo que deber&aacute; introducir valores en los campos de insinuaci&oacute;n rectificada.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el n&uacute;mero de cr&eacute;ditos rectificados.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar Proyecto de inventario".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_RectificarInsinuacionCreditos',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'number',
            /*TFI_NOMBRE.............:*/ 'numCredito',
            /*TFI_LABEL..............:*/ 'Número de créditos rectificados',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_RectificarInsinuacionCreditos',
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
            /*DD_TAP_ID..............:*/ 'H009_RevisarResultadoInfAdmon',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan demanda o adenda al informe de la Administraci&oacute;n Concursal, al pulsar Aceptar el sistema comprobar&aacute; que el estado de los cr&eacute;ditos insinuados en la pestaña "Fase Com&uacute;n" es en caso de presentar alegaciones "4. Pendiente de demanda incidental" o en caso contrario "6. Reconocido". Para ello debe abrir el asunto correspondiente, ir a la pestaña "Fase Com&uacute;n" y abrir la ficha de cada uno de los cr&eacute;ditos insinuados y cambiar su estado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea:<ul style="list-style-type:square;margin-left:35px;"><li>En caso de no presentar adenda ni demanda y todos los cr&eacute;ditos insinuados han sido correctamente reconocidos la siguiente tarea ser&aacute; "Añadir textos definitivos".</li><li>En caso de haberse presentado adenda se lanzar&aacute; la tarea "Presentaci&oacute;n adenda" al gestor del concurso.</li><li>En caso de indicar que se presentar&aacute; demanda, se lanzar&aacute; el "Tr&aacute;mite de Demanda Incidental".</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_RevisarResultadoInfAdmon',
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
            /*DD_TAP_ID..............:*/ 'H009_RevisarResultadoInfAdmon',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboResultado',
            /*TFI_LABEL..............:*/ 'Resultado',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDFavorable',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_RevisarResultadoInfAdmon',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboAdenda',
            /*TFI_LABEL..............:*/ 'Presentar adenda',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_RevisarResultadoInfAdmon',
            /*TFI_ORDEN..............:*/ '4',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboDemanda',
            /*TFI_LABEL..............:*/ 'Presentar demanda',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_RevisarResultadoInfAdmon',
            /*TFI_ORDEN..............:*/ '5',
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
            /*DD_TAP_ID..............:*/ 'H009_PresentacionAdenda',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; revisar si procede presentar adenda seg&uacute;n informa el letrado del concurso.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>Si ha decidido no presentar adenda, se iniciar&aacute; la tarea "Actualizar estados de los cr&eacute;ditos insinuados".</li><li>Si ha decidido presentar adenda se lanzar&aacute; la tarea "Presentaci&oacute;n en el juzgado".</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_PresentacionAdenda',
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
            /*DD_TAP_ID..............:*/ 'H009_PresentacionAdenda',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboAdendaPre',
            /*TFI_LABEL..............:*/ 'Presentar adenda',
			/*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ 'valores[''H009_RevisarResultadoInfAdmon''][''comboAdenda'']',
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_PresentacionAdenda',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'observacionesGestor',
            /*TFI_LABEL..............:*/ 'Observaciones gestor',
			/*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ 'valores[''H009_RevisarResultadoInfAdmon''][''observaciones'']',
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_PresentacionAdenda',
            /*TFI_ORDEN..............:*/ '4',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboAdenda',
            /*TFI_LABEL..............:*/ 'Confirmar presentar adenda',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_PresentacionAdenda',
            /*TFI_ORDEN..............:*/ '5',
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
            /*DD_TAP_ID..............:*/ 'H009_PresentacionJuzgado',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; informar la fecha en la que presenta en el juzgado la adenda para su admisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, se lanzar&aacute; la tarea "Resoluci&oacute;n juzgado".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_PresentacionJuzgado',
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
            /*DD_TAP_ID..............:*/ 'H009_PresentacionJuzgado',
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
            /*DD_TAP_ID..............:*/ 'H009_ResolucionJuzgado',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deber&aacute; informar si la adenda presentada en el juzgado ha sido admitida o no.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla:<ul style="list-style-type:square;margin-left:35px;"><li>Si la adenda ha sido admitida, se lanzar&aacute; la tarea "Actualizar estados de los cr&eacute;ditos insinuados".</li><li>Si la adenda no ha sido admitida, se lanzar&aacute; el "Tr&aacute;mite de demanda incidental", siendo la siguiente tarea ser&aacute; "Actualizar estados de los cr&eacute;ditos insinuados".</li></ul></p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_ResolucionJuzgado',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboAdmitida',
            /*TFI_LABEL..............:*/ 'Adenda admitida',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_ResolucionJuzgado',
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
            /*DD_TAP_ID..............:*/ 'H009_AnyadirTextosDefinitivos',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea deber&aacute; completarla en el momento que tenga constancia del fin de la fase com&uacute;n e inicio de la siguiente fase.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&aacute; la "Fase de liquidaci&oacute;n" en caso de que lo haya indicado as&iacute; y en caso contrario se iniciar&aacute; la "Fase de convenio".</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_AnyadirTextosDefinitivos',
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
            /*DD_TAP_ID..............:*/ 'H009_AnyadirTextosDefinitivos',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboLiquidacion',
            /*TFI_LABEL..............:*/ 'Fase de liquidación',
			/*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H009_AnyadirTextosDefinitivos',
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
    
    /**
     * TAREAS QUE HAY QUE BORRAR
     */    
    CURSOR CRS_TAREA_BORRAR(P_COD_PROCEDIMIENTO V_COD_PROCEDIMIENTO%TYPE) IS 
		SELECT TAP_CODIGO 
			FROM TAP_TAREA_PROCEDIMIENTO TAP, DD_TPO_TIPO_PROCEDIMIENTO TPO 
			WHERE TPO.DD_TPO_CODIGO = P_COD_PROCEDIMIENTO
				AND TPO.DD_TPO_ID = TAP.DD_TPO_ID
				AND TAP.TAP_CODIGO NOT LIKE 'DL_%'
				AND TAP_CODIGO NOT IN ('H009_RegistrarPublicacionBOE', 'H009_RevisarEjecuciones', 'H009_RegistrarInsinuacionCreditos', 'H009_PresentarEscritoInsinuacion',
										'H009_RevisarInsinuacionCreditos', 'H009_RectificarInsinuacionCreditos', 'H009_RegistrarProyectoInventario', 
										'H009_RegistrarInformeAdmonConcursal', 'H009_RevisarResultadoInfAdmon', 'H009_PresentacionAdenda', 'H009_PresentacionJuzgado',
										'H009_ResolucionJuzgado', 'H009_ActualizarEstadoCreditos', 'H009_AnyadirTextosDefinitivos', 'H009_BPMTramiteDemandaIncidental',
										'H009_BPMTramiteFaseLiquidacion', 'H009_BPMTramiteFaseConvenioV4');

BEGIN
	
	/*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    DBMS_OUTPUT.PUT_LINE('    Generacion de datos BPM: '||PAR_TIT_TRAMITE);

    /*
	 * ---------------------------------------------------------------------------------------------------------
	 * 								ACTUALIZACIONES
	 * ---------------------------------------------------------------------------------------------------------
	 */
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET DD_TPO_DESCRIPCION = ''T. fase común - CJ'', DD_TPO_XML_JBPM = ''cj_faseComun'' WHERE DD_TPO_CODIGO = '''||V_COD_PROCEDIMIENTO||'''';
	
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoBOE() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento BOE</div>'''''' WHERE TAP_CODIGO = ''H009_RegistrarPublicacionBOE''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H009_RegistrarInsinuacionCreditos''''][''''numCreditos''''] == null || valores[''''H009_RegistrarInsinuacionCreditos''''][''''numCreditos''''] == '''''''' || valores[''''H009_RegistrarInsinuacionCreditos''''][''''numCreditos''''] == ''''0'''' ? ''''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'''': (cuentaCreditosInsinuadosExt()!=valores[''''H009_RegistrarInsinuacionCreditos''''][''''numCreditos''''] ? ''''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'''' : null)'' WHERE TAP_CODIGO = ''H009_RegistrarInsinuacionCreditos''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''H009_RevisarInsinuacionCreditos''''][''''comboRectificacion''''] == DDSiNo.SI ? ''''si'''' : ''''no'''''' WHERE TAP_CODIGO = ''H009_RevisarInsinuacionCreditos''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos''''] == null || valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos''''] == '''''''' || valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos''''] == ''''0'''' ? (cuentaCreditosInsinuadosSup() != ''''0'''' ? ''''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'''' : null) : (cuentaCreditosInsinuadosSup()!=valores[''''H009_RevisarInsinuacionCreditos''''][''''numCreditos''''] ? ''''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'''' : null)'' WHERE TAP_CODIGO = ''H009_RevisarInsinuacionCreditos''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = ''Registrar informe provisional de la Administración Concursal'' WHERE TAP_CODIGO = ''H009_RegistrarInformeAdmonConcursal''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = ''Revisar informe provisional de la Administración Concursal'' WHERE TAP_CODIGO = ''H009_RevisarResultadoInfAdmon''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''H009_RevisarResultadoInfAdmon''''][''''comboAdenda''''] == DDSiNo.SI ? ''''adenda'''' : valores[''''H009_RevisarResultadoInfAdmon''''][''''comboDemanda''''] == DDSiNo.SI ? ''''demanda'''' : ''''favorable'''''' WHERE TAP_CODIGO = ''H009_RevisarResultadoInfAdmon''';
	
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H009_RegistrarPublicacionBOE''''][''''fecha'''']) + 24*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RegistrarInsinuacionCreditos'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H009_RegistrarPublicacionBOE''''][''''fecha'''']) + 25*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_PresentarEscritoInsinuacion'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H009_RegistrarPublicacionBOE''''][''''fecha'''']) + 28*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RevisarInsinuacionCreditos'')';
	
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de poder completar esta tarea deber&aacute; esperar a recibir aviso a trav&eacute;s de la herramienta que el expediente digital de todos los contratos del concurso esta ya adjunto al procedimiento en Recovery y puede proceder a su revisi&oacute;n.</p><p style="margin-bottom: 10px">En caso de vencer esta tarea y no haber recibido dicho aviso, deber&aacute; ponerse en contacto con su supervisor de la entidad para informar de dicha situaci&oacute;n a trav&eacute;s de la funci&oacute;n Anotaciones de Recovery.</p><p style="margin-bottom: 10px">Antes de rellenar esta pantalla, para el supuesto que quiera insinuar alg&uacute;n cr&eacute;dito, deber&aacute; ir a la pestaña "Fase com&uacute;n" de la ficha del asunto correspondiente y proceder a su insinuaci&oacute;n para lo que deber&aacute; introducir valores en los campos de insinuaci&oacute;n inicial.</p><p style="margin-bottom: 10px">En la presente pantalla y para el caso del supuesto anterior debe indicar el n&uacute;mero de cr&eacute;ditos insinuados.</p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.<p style="margin-bottom: 10px"></p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Presentar escrito de Insinuaci&oacute;n".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RegistrarInsinuacionCreditos'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentación o envío por correo electrónico de la propuesta de insinuación de créditos a la administración concursal.</p><p style="margin-bottom: 10px">Una vez tenga la notificaci&oacute;n de que el Administrador Concursal ha recibido el Escrito de insinuaci&oacute;n, deber&aacute; adjuntarlo al procedimiento.</p><p style="margin-bottom: 10px">Al aceptar el sistema comprobará que todos los créditos insinuados en la pestaña Fase Común disponen de valores definitivos y que se encuentran en estado "2. Insinuado".</p><p style="margin-bottom: 10px">En esta tarea, aparecerán acumulados los importes de los créditos insinuados.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será, si hemos comunicado nuestros créditos a la Administración concursal mediante correo electrónico, "Revisar insinuaci&oacute;n de cr&eacute;ditos".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_PresentarEscritoInsinuacion'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de rellenar esta pantalla deber&aacute; revisar las insinuaciones realizadas. En caso de que se debieran reqtificar algunas de las insinuaciones, deber&aacute; indicarlo en el campo "Requiere rectificar" y en el campo "N&uacute;mero de cr&eacute;ditos a rectificar deber&aacute; indicar el n&uacute;mero de cr&eacute;ditos insinuados a rectificar.</p><p style="margin-bottom: 10px">En el campo Observaciones infomar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:<ul style="list-style-type:square;margin-left:35px;"><li>Si ha indicado que requiere rectificar la siguiente tarea ser&aacute; "Rectificar insinuaci&oacute;n de cr&eacute;ditos".</li><li>Si ha indicado que no requiere rectificar, la siguiente tarea ser&aacute; "Registrar Proyecto de inventario"</li></ul></p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RevisarInsinuacionCreditos'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''Número de créditos a rectificar'', TFI_ORDEN = 2 WHERE TFI_NOMBRE = ''numCreditos'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RevisarInsinuacionCreditos'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3 WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RevisarInsinuacionCreditos'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&aacute; informar la fecha con la que se nos comunica mediante correo electr&oacute;nico por la Administraci&oacute;n Concursal el proyecto de inventario.</p><p style="margin-bottom: 10px">Igualmente, deberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&oacute;n Concursal. En el caso de que sea favorable, se deber&aacute; esperar a la siguiente tarea sobre el informe presentado por la Administraci&oacute;n Concursal ante el juez.</p><p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&aacute; comprobar si el error ha sido cometido por la Entidad a la hora de elaborar la insinuaci&oacute;n de cr&eacute;ditos. Si la insinuaci&oacute;n ha sido incorrecta deber&aacute; ponerse en contacto con la Administraci&oacute;n Concursal para su aclaraci&oacute;n. Con independencia de que sea aclarada o no la discrepancia con la Administraci&oacute;n Concursal, se deber&aacute; remitir igualmente correo electr&oacute;nico a la Administraci&oacute;n Concursal solicitando su subsanaci&oacute;n para su constancia por escrito, haciendo menci&oacute;n en su caso de la aclaraci&oacute;n efectuada previamente.</p><p style="margin-bottom: 10px">En todo caso, tanto si el proyecto es favorable como desfavorable, deberemos modificar el estado de todos los cr&eacute;ditos al estado "3. Pendiente revisi&oacute;n IAC" para completar esta tarea.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;, en caso de ser favorable "Registrar informe de la administraci&oacute;n concursal" y en caso contrario "Presentar rectificaci&oacute;n".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RegistrarProyectoInventario'')';
	EXECUTE IMMEDIATE 'DELETE FROM '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RevisarResultadoInfAdmon'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para completar esta tarea deberá actualizar el estado de los créditos insinuados en la pestaña "Fase común" de la ficha del Asunto correspondiente a valor "6. Reconocido".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Añadir textos definitivos".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_ActualizarEstadoCreditos'')';
	
	-- BORRADO DE TAREA (lógico)
	FOR REG_TAREA IN CRS_TAREA_BORRAR(V_COD_PROCEDIMIENTO) LOOP
		V_TAREA:= REG_TAREA.TAP_CODIGO;
		EXECUTE IMMEDIATE 'DELETE FROM '||PAR_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID IN (SELECT TAP_ID FROM '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
		EXECUTE IMMEDIATE 'DELETE FROM '||PAR_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID IN (SELECT TAP_ID FROM '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
		EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DL_'||V_TAREA||''', BORRADO=1, FECHABORRAR=SYSDATE, USUARIOBORRAR=''ALBERTO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	END LOOP;

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
