--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc02
--## INCIDENCIA_LINK=CMREC-374
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
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Trámite de ejecución notarial';   -- [PARAMETRO] Título del trámite
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
    V_TAREA VARCHAR(50 CHAR);
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'H036'; -- Código de procedimiento para reemplazar
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'H036_DictarInstruccionesSubasta',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ 'valores[''H036_ElevarPropuestaAComite''][''comboResultado''] != null && valores[''H036_ElevarPropuestaAComite''][''comboResultado''] == ''SUS'' ? ''suspender'' : ''continuar''',
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Dictar instrucciones de subasta',
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
			/*DD_STA_ID(FK)................:*/ 'TGCONGE',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'SUCONGE',
			/*TAP_BUCLE_BPM................:*/ null        
		),
		T_TIPO_TAP(
			/*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
			/*TAP_CODIGO...................:*/ 'H036_RecepcionCantidadVenta',
			/*TAP_VIEW.....................:*/ null,
			/*TAP_SCRIPT_VALIDACION........:*/ null,
			/*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
			/*TAP_SCRIPT_DECISION..........:*/ null,
			/*DD_TPO_ID_BPM(FK)............:*/ null,
			/*TAP_SUPERVISOR,..............:*/ '0',
			/*TAP_DESCRIPCION,.............:*/ 'Recepción cantidad por la venta',
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
			/*DD_STA_ID(FK)................:*/ 'TGCON',
			/*TAP_EVITAR_REORG.............:*/ null,
			/*DD_TSUP_ID(FK)...............:*/ 'CJ-SCON',
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
			/*TAP_ID(FK)...............:*/ 'H036_DictarInstruccionesSubasta',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '3*24*60*60*1000L',
			/*VERSION..................:*/ '0',
			/*BORRADO..................:*/ '0',
			/*USUARIOCREAR.............:*/ 'DD'
		),
		T_TIPO_PLAZAS(
			/*DD_JUZ_ID(FK)............:*/ null,
			/*DD_PLA_ID(FK)............:*/ null,
			/*TAP_ID(FK)...............:*/ 'H036_RecepcionCantidadVenta',
			/*DD_PTP_PLAZO_SCRIPT......:*/ '5*24*60*60*1000L',
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
            /*DD_TAP_ID..............:*/ 'H036_registrarSolicitudCertCargas',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboSuspension',
            /*TFI_LABEL..............:*/ 'Suspensión',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_registrarSolicitudCertCargas',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboSolicitud',
            /*TFI_LABEL..............:*/ 'Solicitud certificación registral',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_registrarSolicitudCertCargas',
            /*TFI_ORDEN..............:*/ '4',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboClausula',
            /*TFI_LABEL..............:*/ 'Cláusula abusiva',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_ValidarPropuesta',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboInforme',
            /*TFI_LABEL..............:*/ 'Aceptar informe',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_ValidarPropuesta',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboAutorizacion',
            /*TFI_LABEL..............:*/ 'Motivo autorización',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDMotivoAutorizacion',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_ElevarPropuestaAComite',
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
            /*DD_TAP_ID..............:*/ 'H036_ElevarPropuestaAComite',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboResultado',
            /*TFI_LABEL..............:*/ 'Resultado del Comité',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDResultadoComite',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_ElevarPropuestaAComite',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboSuspension',
            /*TFI_LABEL..............:*/ 'Motivo de suspensión',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDMotivoSuspension',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_ElevarPropuestaAComite',
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
            /*DD_TAP_ID..............:*/ 'H036_DictarInstruccionesSubasta',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez aprobada la propuesta por su supervisor, en esta tarea el gestor de contencioso gesti&oacute;n deber&aacute; dictar las instrucciones de la subasta al letrado.</p><p style="margin-bottom: 10px">El campo Fecha deber&aacute; anotar la fecha en que se realiza esta tarea.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute; "Lectura y confirmaci&oacute;n de instrucciones" en caso de continuar con la subasta o "Suspender subasta" en caso de suspensi&oacute;n de la subasta.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_DictarInstruccionesSubasta',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDResultadoComite',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_DictarInstruccionesSubasta',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'instrucciones',
            /*TFI_LABEL..............:*/ 'Instrucciones',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_DictarInstruccionesSubasta',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboSuspension',
            /*TFI_LABEL..............:*/ 'Solicitar suspensión',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ 'valores[''H036_ElevarPropuestaAComite''][''comboResultado''] != null && valores[''H036_ElevarPropuestaAComite''][''comboResultado''] == ''SUS'' ? DDSiNo.SI : DDSiNo.NO',
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_DictarInstruccionesSubasta',
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
            /*DD_TAP_ID..............:*/ 'H036_RecepcionCantidadVenta',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta tarea deber&aacute; informar la fecha en la que recibe el importe fijado en la celebraci&oacute;n de subasta para la venta del bien.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_RecepcionCantidadVenta',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha recepción',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H036_RecepcionCantidadVenta',
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
				AND TAP.TAP_CODIGO NOT LIKE 'DEL_%'
				AND TAP_CODIGO NOT IN ('H036_entregaActaRequerimiento', 'H036_registrarSolicitudCertCargas', 'H036_registrarRecepcionCertCargas', 'H036_registrarRequerimientoAdeudor',
										'H036_registrarPagoDelDeudor', 'H036_registrarNotificacion', 'H036_registrarAnuncioSubasta', 'H036_PrepararInformeSubasta', 'H036_ValidarPropuesta',
										'H036_ElevarPropuestaAComite', 'H036_RegistrarSolicitudTasacion', 'H036_RegistrarRecepcionTasacion', 'H036_DictarInstruccionesSubasta',
										'H036_LecturaYAceptacionInstrucciones', 'H036_SuspenderSubasta', 'H036_RegistrarEnvioComunicacionAlTitular', 'H036_RegistrarRecepcionComunicacionAlTitular',
										'H036_CelebracionSubasta', 'H036_RegistrarCesionRemate', 'H036_RegistrarLiquidacionPrecioDeRemate', 'H036_BPMTramiteInscripcionDelTitulo',
										'H036_RecepcionCantidadVenta', 'H036_SubastaDecision', 'H036_RegistrarDecision');
    
BEGIN
	
	/*
	 * Actualizaciones 
	 */
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET DD_TPO_DESCRIPCION=''T. de ejecución notarial - HCJ'', DD_TPO_XML_JBPM=''hcj_ejecucionNotarial'' WHERE DD_TPO_CODIGO = '''||V_COD_PROCEDIMIENTO||'''';

	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteEjecucionNotarial/registrarSolicitudCertificacionRegistral'' WHERE TAP_CODIGO = ''H036_registrarSolicitudCertCargas''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = ''Entrega del acta de requerimiento a notario'' WHERE TAP_CODIGO = ''H036_entregaActaRequerimiento''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = ''Validar informe de subasta'' WHERE TAP_CODIGO = ''H036_ValidarPropuesta''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoINFSUBEXT() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Informe Subasta firmada</div>'''''' WHERE TAP_CODIGO = ''H036_ValidarPropuesta''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteEjecucionNotarial/validarInformeSubasta'' WHERE TAP_CODIGO = ''H036_ValidarPropuesta''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''H036_ValidarPropuesta''''][''''comboInforme''''] == DDSiNo.NO ? ''''Rechazada'''' : valores[''''H036_ValidarPropuesta''''][''''conAtribuciones''''] == DDSiNo.SI ? ''''DelegadaConAtribuciones'''' : ''''DelegadaSinAtribuciones'''''' WHERE TAP_CODIGO = ''H036_ValidarPropuesta''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = ''Obtener validación comité'' WHERE TAP_CODIGO = ''H036_ElevarPropuestaAComite''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''(valores[''''H036_ElevarPropuestaAComite''''][''''comboResultado''''] == ''''ACE'''' || valores[''''H036_ElevarPropuestaAComite''''][''''comboResultado''''] == ''''SUS'''') ? ''''Aceptada'''' : ''''Rechazada'''''' WHERE TAP_CODIGO = ''H036_ElevarPropuestaAComite''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = null WHERE TAP_CODIGO = ''H036_ElevarPropuestaAComite''';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoINSEXT()? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Informe de subasta".</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>'''''' WHERE TAP_CODIGO = ''H036_PrepararInformeSubasta''';
	
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H036_registrarAnuncioSubasta''''][''''fechaSubasta'''']) - 15*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_PrepararInformeSubasta'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H036_registrarAnuncioSubasta''''][''''fechaSubasta'''']) - 10*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_ValidarPropuesta'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''7*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_ElevarPropuestaAComite'')';
	
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En el supuesto de que el notario considere que alguna de las cl&aacute;usulas del pr&eacute;stamo hipotecario pudiera tener car&aacute;cter abusivo lo deber&aacute; considerar en esta tarea.</p><p style="margin-bottom: 10px">Bajo este supuesto, deber&aacute; anotarlo en el campo Suspensi&oacute;n. En el campo "Cl&aacute;usula abusiva" seleccionar el tipo de cl&aacute;usula de entre el listado disponible as&iacute; como solicitar la paralizaci&oacute;n del presente procedimiento a su supervisor en tanto en cuanto no recoja la resoluci&oacute;n conforme a los tr&aacute;mites previstos en el art&iacute;culo 695.1 de la LEC.</p><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar la fecha por la que realiza la solicitud de la certificaci&oacute;n registral o bien en la que se notifica la apreciaci&oacute;n de una cl&aacute;usula abusiva.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, la siguiente tarea ser&aacute; "Registrar recepci&oacute;n de certificaci&oacute;n registral".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarSolicitudCertCargas'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 5 WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarSolicitudCertCargas'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar el sujeto a qui&eacute;n se quiere notificar as&iacute; como el resultado de la notificaci&oacute;n. En caso de haber podido notificar tambi&eacute;n deber&aacute; informar la fecha en la que se haya producido dicha notificaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">La tarea no quedar&aacute; finalizada hasta que no est&eacute;n todos los sujetos notificados. En el caso de no haber podido notificar a los sujetos, se iniciar&aacute; una tarea en la que propondr&aacute; seg&uacute;n su criterio la siguiente actuaci&oacute;n al responsable de la entidad.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute; "Registrar anuncio de subasta".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarNotificacion'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar, por un lado, fecha de auto declarando subasta, fecha de registro, la fecha de la subasta y fecha BOP o DG C.A. También deber&aacute; informar si es vivienda Habitual en el campo correspondiente.</p><p style="margin-bottom: 10px">En el campo Observaciones informar de cualquier aspecto relevante que le interesa quede reflejado en ese punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla las siguientes tareas ser&aacute;n:<ul style="list-style-type:square;margin-left:35px;"><li>Se lanzar&aacute; la tarea de "Registrar solicitud de tasaci&oacute;n".</li><li>Se lanzar&aacute; la tarea de "Preparar informe de la propuesta de subasta".</li><li>Se lanzar&aacute; la tarea de "Registrar env&iacute;o comunicaci&oacute;n al titular del dominio".</li></ul></p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarAnuncioSubasta'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores y puja con postores.</p><p style="margin-bottom: 10px">Adem&aacute;s, deber&aacute; adjuntar el informe de subasta, preparar el cuadro de pujas y obtener la tasaci&oacute;n, notas simple e informe fiscal, en caso de que las solicitara en la tarea anterior, as&iacute; como actualizar dicha informaci&oacute;n en la herramienta.</p><p style="margin-bottom: 10px">Una vez hecho esto podr&aacute; generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Validar informe de subasta".</p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_PrepararInformeSubasta'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deber&aacute; revisar y dictaminar sobre la propuesta de instrucciones. En caso de que tenga atribuciones y requiera informar a la entidad del celebramiento de la subasta deber&aacute; notific&aacute;rselo a trav&eacute;s de la herramienta mediante el bot&oacute;n "Anotaci&oacute;n".</p><p style="margin-bottom: 10px">En caso de que no tenga atribuciones para validar el informe de subasta, deber&aacute; señalar el motivo de autorizaci&oacute;n de entre los posibles motivos listados.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea ser&aacute;:<ul style="list-style-type:square;margin-left:35px;"><li>En caso de aceptar el informe y tenga atribuciones, se lanzar&aacute; la tarea de "Dictar instrucciones".</li><li>En caso de aceptar el informe y no tenga atribuciones, se lanzar&aacute; la tarea de "Obtener validaci&oacute;n comit&eacute;".</li><li>Se lanzar&aacute; la tarea "Preparar informe de subasta" en caso de no aceptar el informe.</li></ul></p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_ValidarPropuesta'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 1 WHERE TFI_NOMBRE = ''conAtribuciones'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_ValidarPropuesta'')';
	EXECUTE IMMEDIATE 'DELETE FROM '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE IN (''suspender'', ''delegada'') AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_ValidarPropuesta'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; indicar la fecha en la que el comit&eacute; decide sobre el informe de subasta.</p><p style="margin-bottom: 10px">En caso de que la recomendaci&oacute;n del informe sea suspender subasta, o bien la entidad decida suspenderla, deber&aacute; indicar en el campo "Motivo de suspensi&oacute;n", el motivo por el que se suspende la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">La siguiente tarea será:<ul><li>En el caso que sea la respuesta del comit&eacute; sea " Continuar subasta" o "Suspender subasta", se lanzar&aacute; la siguiente tarea al gestor de contencioso gesti&oacute;n de "Dictar instrucciones".</li><li>En el caso que sea la respuesta del comit&eacute; sea "Rechazar" el informe, se volver&aacute; a la tarea de "Preparar informe de Subasta".</li></ul></p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_ElevarPropuestaAComite'')';
	EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar si se ha celebrado la subasta o no. En caso de haberse celebrado deber&aacute; informar la fecha de celebraci&oacute;n, si la entidad se ha adjudicado el bien o si se lo ha adjudicado un tercero.</p><p style="margin-bottom: 10px">En el caso que no se celebre la subasta, deber&aacute; indicar  el motivo de suspensi&oacute;n  y tomar una decisi&oacute;n para seguir con la actuaci&oacute;n que corresponda.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&aacute;:<ul><li>En caso de haberse adjudicado el bien la entidad sin cesi&oacute;n de remate se lanzar&aacute; el tr&aacute;mite de "Inscripci&oacute;n del T&iacute;tulo".</li><li>En el caso de hab&eacute;rsela adjudicado la Entidad con cesi&oacute;n de remate, se lanzar&aacute la siguiente tarea "Registrar cesi&oacute;n de remate".</li><li>En el caso de haberse adjudicado el bien a un tercero se lanzar&aacute; la siguiente tarea "Recepci&oacute;n cantidad por la venta".</li></ul></p></div>'' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||PAR_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_CelebracionSubasta'')';
	
	-- BORRADO DE TAREA (lógico)
	FOR REG_TAREA IN CRS_TAREA_BORRAR(V_COD_PROCEDIMIENTO) LOOP
		V_TAREA:= REG_TAREA.TAP_CODIGO;
		EXECUTE IMMEDIATE 'DELETE FROM '||PAR_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID IN (SELECT TAP_ID FROM '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
		EXECUTE IMMEDIATE 'DELETE FROM '||PAR_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID IN (SELECT TAP_ID FROM '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
		EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''', BORRADO=1, FECHABORRAR=SYSDATE, USUARIOBORRAR=''ALBERTO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
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
