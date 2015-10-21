--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hcj
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las autoprórrogas en las tareas para CAJAMAR
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    
    --Insertando valores en dd_tfa_fichero_adjunto
    TYPE T_TIPO_VALOR IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_VALOR;
    V_TIPO_VALOR T_ARRAY_TFA := T_ARRAY_TFA(

T_TIPO_VALOR('HCJ001','HCJ001_DeclararIVAIGIC','0','0')
,T_TIPO_VALOR('HCJ002','HCJ002_ObtenerValidacionComite','0','0')
,T_TIPO_VALOR('H036','H036_ElevarPropuestaAComite','0','0')
,T_TIPO_VALOR('H039','H039_registrarCausaConclusion','1','3')
,T_TIPO_VALOR('H039','H039_registrarInformeAdmConcursal','1','3')
,T_TIPO_VALOR('H039','H039_registrarConclusionConcurso','1','3')
,T_TIPO_VALOR('H039','H039_ConclusionDecision','0','0')
,T_TIPO_VALOR('H021','H021_AutoDeclarandoConcurso','0','0')
,T_TIPO_VALOR('H021','H021_BPMTramiteFaseComunOrdinario','0','0')
,T_TIPO_VALOR('H021','H021_ConfirmarAdmision','0','0')
,T_TIPO_VALOR('H021','H021_ConfirmarNotificacionDemandado','0','0')
,T_TIPO_VALOR('H021','H021_RegistrarResolucion','1','3')
,T_TIPO_VALOR('H021','H021_RegistrarVista','1','3')
,T_TIPO_VALOR('H021','H021_ResolucionDecision','0','0')
,T_TIPO_VALOR('H021','H021_ResolucionFirme','0','0')
,T_TIPO_VALOR('H021','H021_RevisionEjecucionesParalizadas','1','3')
,T_TIPO_VALOR('H021','H021_SolicitudConcursal','0','0')
,T_TIPO_VALOR('H021','H021_registrarOposicion','0','0')
,T_TIPO_VALOR('H035','H035_aperturaLiquidacion','1','3')
,T_TIPO_VALOR('H035','H035_resolucionFirme','1','3')
,T_TIPO_VALOR('H035','H035_ResolucionDecision','0','0')
,T_TIPO_VALOR('H031','H031_ContabilizarConvenio','0','0')
,T_TIPO_VALOR('H031','H031_ConvenioDecision','0','0')
,T_TIPO_VALOR('H031','H031_ElevarAComite','1','3')
,T_TIPO_VALOR('H031','H031_EscritoEvaluacion','1','3')
,T_TIPO_VALOR('H031','H031_PrepararInforme','1','3')
,T_TIPO_VALOR('H031','H031_RegistrarRespuestaComite','1','3')
,T_TIPO_VALOR('H031','H031_ResolucionJudicial','1','3')
,T_TIPO_VALOR('H031','H031_admisionTramiteConvenio','1','3')
,T_TIPO_VALOR('H031','H031_registrarPropAnticipadaConvenio','1','3')
,T_TIPO_VALOR('H009','H009_ActualizarEstadoCreditos','1','3')
,T_TIPO_VALOR('H009','H009_AnyadirTextosDefinitivos','0','0')
,T_TIPO_VALOR('H009','H009_BPMTramiteDemandaIncidental','0','0')
,T_TIPO_VALOR('H009','H009_BPMTramiteFaseConvenioV4','0','0')
,T_TIPO_VALOR('H009','H009_BPMTramiteFaseLiquidacion','0','0')
,T_TIPO_VALOR('H009','H009_PresentacionAdenda','1','3')
,T_TIPO_VALOR('H009','H009_PresentacionJuzgado','1','3')
,T_TIPO_VALOR('H009','H009_PresentarEscritoInsinuacion','1','3')
,T_TIPO_VALOR('H009','H009_RectificarInsinuacionCreditos','0','0')
,T_TIPO_VALOR('H009','H009_RegistrarInformeAdmonConcursal','0','0')
,T_TIPO_VALOR('H009','H009_RegistrarInsinuacionCreditos','1','3')
,T_TIPO_VALOR('H009','H009_RegistrarProyectoInventario','0','0')
,T_TIPO_VALOR('H009','H009_RegistrarPublicacionBOE','0','0')
,T_TIPO_VALOR('H009','H009_ResolucionJuzgado','1','3')
,T_TIPO_VALOR('H009','H009_RevisarEjecuciones','1','3')
,T_TIPO_VALOR('H009','H009_RevisarInsinuacionCreditos','0','0')
,T_TIPO_VALOR('H009','H009_RevisarResultadoInfAdmon','0','0')
,T_TIPO_VALOR('H023','H023_DemandaDecision','0','0')
,T_TIPO_VALOR('H023','H023_admisionOposicionYSenalamientoVista','1','3')
,T_TIPO_VALOR('H023','H023_confirmarAdmisionDemanda','0','0')
,T_TIPO_VALOR('H023','H023_confirmarOposicion','1','3')
,T_TIPO_VALOR('H023','H023_interposicionDemanda','0','0')
,T_TIPO_VALOR('H023','H023_registrarResolucion','0','0')
,T_TIPO_VALOR('H023','H023_registrarVista','0','0')
,T_TIPO_VALOR('H023','H023_resolucionFirme','0','0')
,T_TIPO_VALOR('H025','H025_ActualizarInsinuacionCreditos','1','3')
,T_TIPO_VALOR('H025','H025_ElaborarInformeCancelacion','1','3')
,T_TIPO_VALOR('H025','H025_ElevarComite','1','3')
,T_TIPO_VALOR('H025','H025_InsinuacionDecision','0','0')
,T_TIPO_VALOR('H025','H025_RegistrarRespuestaComite','1','3')
,T_TIPO_VALOR('H025','H025_admisionEscritoOposicion','0','0')
,T_TIPO_VALOR('H025','H025_contabilizar','1','3')
,T_TIPO_VALOR('H025','H025_notificacionDemandaIncidental','0','0')
,T_TIPO_VALOR('H025','H025_registrarAllanamiento','0','0')
,T_TIPO_VALOR('H025','H025_registrarImporteCuotasAbonar','1','3')
,T_TIPO_VALOR('H025','H025_registrarOposicion','0','0')
,T_TIPO_VALOR('H025','H025_registrarResolucion','0','0')
,T_TIPO_VALOR('H025','H025_registrarVista','1','3')
,T_TIPO_VALOR('H025','H025_resolucionFirme','0','0')
,T_TIPO_VALOR('H027','H027_AceptarPropuestaAcuerdo','1','3')
,T_TIPO_VALOR('H027','H027_ComprobarSolicitudConcurso','1','3')
,T_TIPO_VALOR('H027','H027_DecisionSupervisor','0','0')
,T_TIPO_VALOR('H027','H027_ElevarComite','1','3')
,T_TIPO_VALOR('H027','H027_LecturaAceptacionInstrucciones','0','0')
,T_TIPO_VALOR('H027','H027_RealizarAdecuacionContable','1','0')
,T_TIPO_VALOR('H027','H027_RegistrarAperturaNegociaciones','1','3')
,T_TIPO_VALOR('H027','H027_RegistrarEntradaEnVigor','0','0')
,T_TIPO_VALOR('H027','H027_RegistrarPropuestaAcuerdo','1','3')
,T_TIPO_VALOR('H027','H027_RegistrarPublicacionSolArticulo','0','0')
,T_TIPO_VALOR('H027','H027_RegistrarResHomologacionJudicial','1','3')
,T_TIPO_VALOR('H027','H027_RegistrarResultadoAcuerdo','0','0')
,T_TIPO_VALOR('H029','H029_ResolucionDecision','0','0')
,T_TIPO_VALOR('H029','H029_registrarResolucion','1','3')
,T_TIPO_VALOR('H041','H041_RegistroPrestamoConvenio','1','3')
,T_TIPO_VALOR('H041','H041_registrarConvenio','1','3')
,T_TIPO_VALOR('H041','H041_registrarCumplimiento','1','3')
,T_TIPO_VALOR('H041','H041_validarFinSeguimiento','1','3')
,T_TIPO_VALOR('H041','H041_NotificarDeudor','1','3')
,T_TIPO_VALOR('H041','H041_ConfirmarResultadoNotificacion','1','3')
,T_TIPO_VALOR('H041','H041_ObtenerInformeSemestral','1','3')
,T_TIPO_VALOR('H043','H043_ActualizarInsinuacionCreditos','1','3')
,T_TIPO_VALOR('H043','H043_RectificarInsinuacionCreditos','1','3')
,T_TIPO_VALOR('H043','H043_AutoDeclarandoConcurso','0','0')
,T_TIPO_VALOR('H043','H043_RevisarInsinuacionCreditos','1','3')
,T_TIPO_VALOR('H043','H043_ReaperturaGesConDecision','0','0')
,T_TIPO_VALOR('H043','H043_ReaperturaGesHREDecision','0','0')
,T_TIPO_VALOR('H017','H017_AutoApertura','0','0')
,T_TIPO_VALOR('H017','H017_RegistrarFechaJunta','1','3')
,T_TIPO_VALOR('H017','H017_PresentacionPropuesta','1','3')
,T_TIPO_VALOR('H017','H017_ObtenerInformeAdmConcursal','1','3')
,T_TIPO_VALOR('H017','H017_ElaborarInformeJuntaAcreedores','1','3')
,T_TIPO_VALOR('H017','H017_ElevarAComite','1','3')
,T_TIPO_VALOR('H017','H017_RegistrarRespuestaComite','1','3')
,T_TIPO_VALOR('H017','H017_LecturaInstrucciones','0','0')
,T_TIPO_VALOR('H017','H017_NotificarInstruccionesProcurador','1','3')
,T_TIPO_VALOR('H017','H017_RegistrarCelebracionJunta','0','0')
,T_TIPO_VALOR('H017','H017_AdjuntarActaJunta','1','3')
,T_TIPO_VALOR('H017','H017_RegistrarSentenciaFirme','1','3')
,T_TIPO_VALOR('H017','H017_RevisarEjecucionesParalizadas','1','3')
,T_TIPO_VALOR('H017','H017_BPMFaseLiquidacion','0','0')
,T_TIPO_VALOR('H017','H017_BPMSeguimientoCumplimientoConvenio','0','0')
,T_TIPO_VALOR('CJ002','CJ002_RegistrarAcuerdoAprobado','1','3')
,T_TIPO_VALOR('CJ002','CJ002_RegistrarCumplimiento','1','3')
,T_TIPO_VALOR('CJ002','CJ002_NotificarDeudor','1','3')
,T_TIPO_VALOR('CJ002','CJ002_ConfirmarResultadoNotificacion','1','3')
,T_TIPO_VALOR('CJ002','CJ002_ComunicacionMediador','1','3')
,T_TIPO_VALOR('CJ002','CJ002_ValidarFinSeguimiento','1','3')
,T_TIPO_VALOR('CJ001','CJ001_RegistrarOferta','1','3')
,T_TIPO_VALOR('CJ001','CJ001_ElaborarInforme','1','3')
,T_TIPO_VALOR('CJ001','CJ001_ElevarComite','1','3')
,T_TIPO_VALOR('CJ001','CJ001_RegistrarRespuestaComite','1','3')
,T_TIPO_VALOR('CJ001','CJ001_ContactarDeudor','1','3')
,T_TIPO_VALOR('CJ001','CJ001_NotificacionPartes','1','3')
,T_TIPO_VALOR('CJ001','CJ001_ComunicacionResultado','1','3')
,T_TIPO_VALOR('CJ001','CJ001_NotificarAdministradorConcursal','1','3')
,T_TIPO_VALOR('CJ001','CJ001_PresentarSolicitudJuzgado','1','3')
,T_TIPO_VALOR('CJ001','CJ001_AdmisionJuzgado','1','3')
,T_TIPO_VALOR('CJ001','CJ001_ResolucionFirme','1','3')
,T_TIPO_VALOR('CJ001','CJ001_RegistrarFormalizacionVenta','1','3')
,T_TIPO_VALOR('CJ001','CJ001_ConfirmarContabilidad','1','3')
,T_TIPO_VALOR('CJ001','CJ001_GerenteDecision','1','3')
,T_TIPO_VALOR('CJ004','CJ004_SenyalamientoSubasta','0','0')
,T_TIPO_VALOR('CJ004','CJ004_PrepararInformeSubasta','1','3')
,T_TIPO_VALOR('CJ004','CJ004_CelebracionSubasta','0','0')
,T_TIPO_VALOR('CJ004','CJ004_SolicitarMandamientoPago','0','0')
,T_TIPO_VALOR('CJ004','CJ004_ConfirmarRecepcionMandamientoDePago','0','0')
,T_TIPO_VALOR('CJ004','CJ004_BPMTramiteCesionRemate','0','0')
,T_TIPO_VALOR('CJ004','CJ004_BPMTramiteAdjudicacion','0','0')
,T_TIPO_VALOR('CJ004','CJ004_CelebracionDecision','1','3')
,T_TIPO_VALOR('CJ004','CJ004_RevisarDocumentacion','1','3')
,T_TIPO_VALOR('CJ004','CJ004_AdjuntarInformeOficina','1','3')
,T_TIPO_VALOR('CJ004','CJ004_AdjuntarTasaciones','1','3')
,T_TIPO_VALOR('CJ004','CJ004_AdjuntarInformeFiscal','1','3')
,T_TIPO_VALOR('CJ004','CJ004_ValidarInformeDeSubasta','1','3')
,T_TIPO_VALOR('CJ004','CJ004_EnviarInstruccionesProcurador','1','3')
,T_TIPO_VALOR('CJ004','CJ004_CalcularDeudaActualizada','1','3')
,T_TIPO_VALOR('CJ004','CJ004_ActualizarDeudaJuzgado','1','3')
,T_TIPO_VALOR('CJ004','CJ004_TareaExterna','0','0')
,T_TIPO_VALOR('CJ005','CJ005_RecepcionarComunicacionMediador','1','3')
,T_TIPO_VALOR('CJ005','CJ005_ActualizarCreditos','1','3')
,T_TIPO_VALOR('CJ005','CJ005_RegistrarFechaReunion','1','3')
,T_TIPO_VALOR('CJ005','CJ005_RegistrarRecepcionPlanPagos','1','3')
,T_TIPO_VALOR('CJ005','CJ005_AnalizarPropuesta','1','3')
,T_TIPO_VALOR('CJ005','CJ005_ElevarComite','1','3')
,T_TIPO_VALOR('CJ005','CJ005_RegistrarRespuestaComite','1','3')
,T_TIPO_VALOR('CJ005','CJ005_ComunicarDecisionMediador','1','3')
,T_TIPO_VALOR('CJ005','CJ005_CelebracionReunion','1','3')
,T_TIPO_VALOR('CJ005','CJ005_RealizarInformeConcursal','1','3')
,T_TIPO_VALOR('CJ005','CJ005_ValorarInformeConcursal','1','3')
,T_TIPO_VALOR('CJ005','CJ005_AperturaConcursoConsecutivo','1','3')
,T_TIPO_VALOR('CJ005','CJ005_DecisionGestorConcursal','1','3')
,T_TIPO_VALOR('CJ005','CJ005_DecisionGestorHRE','1','3')
,T_TIPO_VALOR('CJ006','CJ006_PresentarDeclaracionIncumplimiento','1','3')
,T_TIPO_VALOR('CJ006','CJ006_AutoReaperturaConcurso','1','3')
,T_TIPO_VALOR('CJ006','CJ006_ActualizarInsinuacionCreditos','1','3')
,T_TIPO_VALOR('CJ006','CJ006_RevisarInsinuacionCreditos','1','3')
,T_TIPO_VALOR('CJ006','CJ006_RectificarInsinuacionCreditos','1','3')
,T_TIPO_VALOR('CJ003','CJ003_RevisarCreditosContingentes','1','3')
,T_TIPO_VALOR('H033','H033_aperturaFase','1','3')
,T_TIPO_VALOR('H033','H033_InformeLiquidacion','1','3')
,T_TIPO_VALOR('H033','H033_decidirPresentarObs','0','0')
,T_TIPO_VALOR('H033','H033_presentarObs','0','0')
,T_TIPO_VALOR('H033','H033_regInformeTrimestral1','1','3')
,T_TIPO_VALOR('H033','H033_PresentarAlegaciones','1','3')
,T_TIPO_VALOR('H033','H033_RegistrarAutoConclusion','1','3')
,T_TIPO_VALOR('H033','H033_RegistrarAutoPlanLiquidacion','1','3')
,T_TIPO_VALOR('H033','H033_RendimientoCuentas','1','3')
,T_TIPO_VALOR('H033','H033_ResolucionJuzgado','1','3')
,T_TIPO_VALOR('CJ007','CJ007_AutoAprobacionCostas','1','3')
,T_TIPO_VALOR('CJ007','CJ007_AutoDecision','1','3')
,T_TIPO_VALOR('CJ007','CJ007_AutoFirme','1','3')
,T_TIPO_VALOR('CJ007','CJ007_ConfirmarNotificacion','1','3')
,T_TIPO_VALOR('CJ007','CJ007_Impugnacion','1','3')
,T_TIPO_VALOR('CJ007','CJ007_JBPMTramiteNotificacion','0','0')
,T_TIPO_VALOR('CJ007','CJ007_RegistrarCelebracionVista','1','3')
,T_TIPO_VALOR('CJ007','CJ007_SolicitudTasacion','1','3')
,T_TIPO_VALOR('CJ007','CJ007_TasacionCostas','1','3')
,T_TIPO_VALOR('P400','P400_GestionarNotificaciones','0','0')
,T_TIPO_VALOR('HCJ003','HCJ003_AutorizarPeticionPropuesta','0','0')
,T_TIPO_VALOR('HCJ003','HCJ003_AutorizacionDecision','0','0')

); 
V_TMP_TIPO T_TIPO_VALOR;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con TAREAS');  
	-- LOOP Insertando valores en dd_tfa_fichero_adjunto

	DBMS_OUTPUT.PUT_LINE('[INFO] Limpiando datos de tareas');
	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_AUTOPRORROGA = 0, TAP_MAX_AUTOP = 0';
	EXECUTE IMMEDIATE V_MSQL;
  
	FOR I IN V_TIPO_VALOR.FIRST .. V_TIPO_VALOR.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_dd_tfa_fichero_adjunto.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO := V_TIPO_VALOR(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,'||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ' ||
				' WHERE TAP.DD_TPO_ID=TPO.DD_TPO_ID AND TPO.DD_TPO_CODIGO='''||TRIM(V_TMP_TIPO(1))||''' AND TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO(2))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe
			IF V_NUM_TABLAS > 0 THEN				
				--DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.dd_tfa_fichero_adjunto... Ya existe la relacion dd_tfa_codigo='''|| TRIM(V_TMP_TIPO_TFA(1))||''' con el código de actuación='''|| TRIM(V_TMP_TIPO_TFA(4))||'''');
				 V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' || 
                         ' TAP_AUTOPRORROGA = '||V_TMP_TIPO(3)||
                         ' ,TAP_MAX_AUTOP = '||V_TMP_TIPO(4)||
                         ' WHERE TAP_CODIGO = ''' || V_TMP_TIPO(2)|| ''' AND DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO WHERE DD_TPO_CODIGO='''||TRIM(V_TMP_TIPO(1))||''')';
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
			ELSE
        DBMS_OUTPUT.PUT_LINE('NO ENCONTRADO...' || TRIM(V_TMP_TIPO(2)));
			END IF;
      END LOOP;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] TAREAS');

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