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
--## INSTRUCCIONES: Configurar los gestores en las tareas para CAJAMAR
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

T_TIPO_VALOR('HCJ001','HCJ001_DeclararIVAIGIC','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('HCJ002','HCJ002_ObtenerValidacionComite','TGESCHRE','DIRREC')
,T_TIPO_VALOR('H036','H036_ElevarPropuestaAComite','CJ-TGESEXT','CJ-SUEXT')
,T_TIPO_VALOR('H039','H039_registrarCausaConclusion','TGESCON','SUCON')
,T_TIPO_VALOR('H039','H039_registrarInformeAdmConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('H039','H039_registrarConclusionConcurso','TGESCON','SUCON')
,T_TIPO_VALOR('H039','H039_ConclusionDecision','DGESCON','')
,T_TIPO_VALOR('H021','H021_AutoDeclarandoConcurso','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_BPMTramiteFaseComunOrdinario','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_ConfirmarAdmision','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_ConfirmarNotificacionDemandado','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_RegistrarResolucion','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_RegistrarVista','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_ResolucionDecision','DGESCON','')
,T_TIPO_VALOR('H021','H021_ResolucionFirme','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_RevisionEjecucionesParalizadas','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_SolicitudConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('H021','H021_registrarOposicion','TGESCON','SUCON')
,T_TIPO_VALOR('H035','H035_aperturaLiquidacion','TGESCON','SUCON')
,T_TIPO_VALOR('H035','H035_resolucionFirme','TGESCON','SUCON')
,T_TIPO_VALOR('H035','H035_ResolucionDecision','DGESCON','')
,T_TIPO_VALOR('H031','H031_ContabilizarConvenio','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('H031','H031_ConvenioDecision','DGESCON','')
,T_TIPO_VALOR('H031','H031_ElevarAComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('H031','H031_EscritoEvaluacion','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_PrepararInforme','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_RegistrarRespuestaComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('H031','H031_ResolucionJudicial','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_admisionTramiteConvenio','TGESCON','SUCON')
,T_TIPO_VALOR('H031','H031_registrarPropAnticipadaConvenio','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_ActualizarEstadoCreditos','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_AnyadirTextosDefinitivos','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_BPMTramiteDemandaIncidental','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_BPMTramiteFaseConvenioV4','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_BPMTramiteFaseLiquidacion','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_PresentacionAdenda','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_PresentacionJuzgado','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_PresentarEscritoInsinuacion','TGESHREIN','GESCON')
,T_TIPO_VALOR('H009','H009_RectificarInsinuacionCreditos','TGESHREIN','GESCON')
,T_TIPO_VALOR('H009','H009_RegistrarInformeAdmonConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RegistrarInsinuacionCreditos','TGESHREIN','GESCON')
,T_TIPO_VALOR('H009','H009_RegistrarProyectoInventario','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RegistrarPublicacionBOE','TGESHRE','SUHRE')
,T_TIPO_VALOR('H009','H009_ResolucionJuzgado','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RevisarEjecuciones','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RevisarInsinuacionCreditos','TGESCON','SUCON')
,T_TIPO_VALOR('H009','H009_RevisarResultadoInfAdmon','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_DemandaDecision','DGESCON','')
,T_TIPO_VALOR('H023','H023_admisionOposicionYSenalamientoVista','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_confirmarAdmisionDemanda','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_confirmarOposicion','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_interposicionDemanda','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_registrarResolucion','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_registrarVista','TGESCON','SUCON')
,T_TIPO_VALOR('H023','H023_resolucionFirme','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_ActualizarInsinuacionCreditos','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_ElaborarInformeCancelacion','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_ElevarComite','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('H025','H025_InsinuacionDecision','DGESCON','')
,T_TIPO_VALOR('H025','H025_RegistrarRespuestaComite','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('H025','H025_admisionEscritoOposicion','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_contabilizar','TGADMCON','SUADMCON')
,T_TIPO_VALOR('H025','H025_notificacionDemandaIncidental','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_registrarAllanamiento','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_registrarImporteCuotasAbonar','TGADMCON','SUADMCON')
,T_TIPO_VALOR('H025','H025_registrarOposicion','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_registrarResolucion','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_registrarVista','TGESCON','SUCON')
,T_TIPO_VALOR('H025','H025_resolucionFirme','TGESCON','SUCON')
,T_TIPO_VALOR('H027','H027_AceptarPropuestaAcuerdo','TGEANREC','SUANREC')
,T_TIPO_VALOR('H027','H027_ComprobarSolicitudConcurso','TGESINC','GERREC')
,T_TIPO_VALOR('H027','H027_DecisionSupervisor','DGESINC','')
,T_TIPO_VALOR('H027','H027_ElevarComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('H027','H027_LecturaAceptacionInstrucciones','TGEANREC','SUANREC')
,T_TIPO_VALOR('H027','H027_RealizarAdecuacionContable','TGESOF','GESINC')
,T_TIPO_VALOR('H027','H027_RegistrarAperturaNegociaciones','TGESINC','GERREC')
,T_TIPO_VALOR('H027','H027_RegistrarEntradaEnVigor','TGESINC','GERREC')
,T_TIPO_VALOR('H027','H027_RegistrarPropuestaAcuerdo','TGESINC','GERREC')
,T_TIPO_VALOR('H027','H027_RegistrarPublicacionSolArticulo','TGESINC','GERREC')
,T_TIPO_VALOR('H027','H027_RegistrarResHomologacionJudicial','TGESINC','GERREC')
,T_TIPO_VALOR('H027','H027_RegistrarResultadoAcuerdo','TGESINC','GERREC')
,T_TIPO_VALOR('H029','H029_ResolucionDecision','DGESCON','')
,T_TIPO_VALOR('H029','H029_registrarResolucion','TGESCON','SUCON')
,T_TIPO_VALOR('H041','H041_RegistroPrestamoConvenio','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('H041','H041_registrarConvenio','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('H041','H041_registrarCumplimiento','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('H041','H041_validarFinSeguimiento','TSUCHRE','DIRHRE')
,T_TIPO_VALOR('H041','H041_NotificarDeudor','TGESOF','GESINC')
,T_TIPO_VALOR('H041','H041_ConfirmarResultadoNotificacion','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('H041','H041_ObtenerInformeSemestral','TSUCHRE','DIRHRE')
,T_TIPO_VALOR('H043','H043_ActualizarInsinuacionCreditos','TGESHREIN','GESCON')
,T_TIPO_VALOR('H043','H043_RectificarInsinuacionCreditos','TGESHREIN','GESCON')
,T_TIPO_VALOR('H043','H043_AutoDeclarandoConcurso','TGESCON','SUCON')
,T_TIPO_VALOR('H043','H043_RevisarInsinuacionCreditos','TGESCON','SUCON')
,T_TIPO_VALOR('H043','H043_ReaperturaGesConDecision','DGESCON','GESCON')
,T_TIPO_VALOR('H043','H043_ReaperturaGesHREDecision','DGESHREIN','GESCON')
,T_TIPO_VALOR('H017','H017_AutoApertura','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_RegistrarFechaJunta','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_PresentacionPropuesta','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_ObtenerInformeAdmConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_ElaborarInformeJuntaAcreedores','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_ElevarAComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('H017','H017_RegistrarRespuestaComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('H017','H017_LecturaInstrucciones','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_NotificarInstruccionesProcurador','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_RegistrarCelebracionJunta','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_AdjuntarActaJunta','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_RegistrarSentenciaFirme','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_RevisarEjecucionesParalizadas','TGEANREC','SUANREC')
,T_TIPO_VALOR('H017','H017_BPMFaseLiquidacion','TGESCON','SUCON')
,T_TIPO_VALOR('H017','H017_BPMSeguimientoCumplimientoConvenio','TGESCON','SUCON')
,T_TIPO_VALOR('CJ002','CJ002_RegistrarAcuerdoAprobado','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('CJ002','CJ002_RegistrarCumplimiento','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('CJ002','CJ002_NotificarDeudor','TGESOF','GESINC')
,T_TIPO_VALOR('CJ002','CJ002_ConfirmarResultadoNotificacion','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('CJ002','CJ002_ComunicacionMediador','TGESINC','SUINC')
,T_TIPO_VALOR('CJ002','CJ002_ValidarFinSeguimiento','TSUCHRE','DIRHRE')
,T_TIPO_VALOR('CJ001','CJ001_RegistrarOferta','TGESCON','SUCON')
,T_TIPO_VALOR('CJ001','CJ001_ElaborarInforme','TGESCON','SUCON')
,T_TIPO_VALOR('CJ001','CJ001_ElevarComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ001','CJ001_RegistrarRespuestaComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ001','CJ001_ContactarDeudor','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ001','CJ001_NotificacionPartes','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ001','CJ001_ComunicacionResultado','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ001','CJ001_NotificarAdministradorConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('CJ001','CJ001_PresentarSolicitudJuzgado','TGESCON','SUCON')
,T_TIPO_VALOR('CJ001','CJ001_AdmisionJuzgado','TGERREC','DIRREC')
,T_TIPO_VALOR('CJ001','CJ001_ResolucionFirme','TGERREC','DIRREC')
,T_TIPO_VALOR('CJ001','CJ001_RegistrarFormalizacionVenta','TGERREC','DIRREC')
,T_TIPO_VALOR('CJ001','CJ001_ConfirmarContabilidad','TGERREC','DIRREC')
,T_TIPO_VALOR('CJ001','CJ001_GerenteDecision','DGERREC','')
,T_TIPO_VALOR('CJ004','CJ004_SenyalamientoSubasta','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_PrepararInformeSubasta','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_CelebracionSubasta','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_SolicitarMandamientoPago','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_ConfirmarRecepcionMandamientoDePago','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_BPMTramiteCesionRemate','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_BPMTramiteAdjudicacion','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_CelebracionDecision','DGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_RevisarDocumentacion','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_AdjuntarInformeOficina','TGESOF','GESINC')
,T_TIPO_VALOR('CJ004','CJ004_AdjuntarTasaciones','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_AdjuntarInformeFiscal','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_ValidarInformeDeSubasta','TSUCON','DIRCON')
,T_TIPO_VALOR('CJ004','CJ004_EnviarInstruccionesProcurador','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_CalcularDeudaActualizada','TSUADMCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_ActualizarDeudaJuzgado','TGESCON','SUCON')
,T_TIPO_VALOR('CJ004','CJ004_TareaExterna','TGESCON','SUCON')
,T_TIPO_VALOR('CJ005','CJ005_RecepcionarComunicacionMediador','TGESINC','SUINC')
,T_TIPO_VALOR('CJ005','CJ005_ActualizarCreditos','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('CJ005','CJ005_RegistrarFechaReunion','TGERREC','DIRREC')
,T_TIPO_VALOR('CJ005','CJ005_RegistrarRecepcionPlanPagos','TGESINC','SUINC')
,T_TIPO_VALOR('CJ005','CJ005_AnalizarPropuesta','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ005','CJ005_ElevarComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ005','CJ005_RegistrarRespuestaComite','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ005','CJ005_ComunicarDecisionMediador','TGESINC','SUINC')
,T_TIPO_VALOR('CJ005','CJ005_CelebracionReunion','TGESINC','SUINC')
,T_TIPO_VALOR('CJ005','CJ005_RealizarInformeConcursal','TGEANREC','SUANREC')
,T_TIPO_VALOR('CJ005','CJ005_ValorarInformeConcursal','TGESCON','SUCON')
,T_TIPO_VALOR('CJ005','CJ005_AperturaConcursoConsecutivo','TGESHRE','SUHRE')
,T_TIPO_VALOR('CJ005','CJ005_DecisionGestorConcursal','DGESCON','')
,T_TIPO_VALOR('CJ005','CJ005_DecisionGestorHRE','DGESHRE','')
,T_TIPO_VALOR('CJ006','CJ006_PresentarDeclaracionIncumplimiento','TGESCON','SUCON')
,T_TIPO_VALOR('CJ006','CJ006_AutoReaperturaConcurso','TGESCHRE','SUCHRE')
,T_TIPO_VALOR('CJ006','CJ006_ActualizarInsinuacionCreditos','TGESHREIN','GESCON')
,T_TIPO_VALOR('CJ006','CJ006_RevisarInsinuacionCreditos','TGESCON','SUCON')
,T_TIPO_VALOR('CJ006','CJ006_RectificarInsinuacionCreditos','TGESHREIN','GESCON')
,T_TIPO_VALOR('CJ003','CJ003_RevisarCreditosContingentes','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_aperturaFase','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_InformeLiquidacion','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_decidirPresentarObs','TSUCON','DIRCON')
,T_TIPO_VALOR('H033','H033_presentarObs','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_regInformeTrimestral1','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_PresentarAlegaciones','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_RegistrarAutoConclusion','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_RegistrarAutoPlanLiquidacion','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_RendimientoCuentas','TGESCON','SUCON')
,T_TIPO_VALOR('H033','H033_ResolucionJuzgado','TGESCON','SUCON')
,T_TIPO_VALOR('CJ007','CJ007_AutoAprobacionCostas','TGESCON','SUCON')
,T_TIPO_VALOR('CJ007','CJ007_AutoDecision','DGESCON','')
,T_TIPO_VALOR('CJ007','CJ007_AutoFirme','TGESCON','SUCON')
,T_TIPO_VALOR('CJ007','CJ007_ConfirmarNotificacion','TGESCON','SUCON')
,T_TIPO_VALOR('CJ007','CJ007_Impugnacion','TGESCON','SUCON')
,T_TIPO_VALOR('CJ007','CJ007_JBPMTramiteNotificacion','','')
,T_TIPO_VALOR('CJ007','CJ007_RegistrarCelebracionVista','TGESCON','SUCON')
,T_TIPO_VALOR('CJ007','CJ007_SolicitudTasacion','TGESCON','SUCON')
,T_TIPO_VALOR('CJ007','CJ007_TasacionCostas','TGESCON','SUCON')
,T_TIPO_VALOR('P400','P400_GestionarNotificaciones','TGESCON','SUCON')
,T_TIPO_VALOR('HCJ003','HCJ003_AutorizarPeticionPropuesta','TGESCHRE','DIRREC')
,T_TIPO_VALOR('HCJ003','HCJ003_AutorizacionDecision','DGESCHRE','')

); 
    V_TMP_TIPO T_TIPO_VALOR;
    
BEGIN	
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con DD_TFA_FICHERO_ADJUNTO');  
  -- LOOP Insertando valores en dd_tfa_fichero_adjunto
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.dd_tfa_fichero_adjunto... Empezando a insertar datos en el diccionario');
    
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
                         ' DD_STA_ID = (select dd_sta_id from '||V_ESQUEMA_MASTER||'.Dd_Sta_Subtipo_Tarea_Base where Dd_Sta_Codigo='''||TRIM(V_TMP_TIPO(3))||''')' ||
                         ' ,DD_TSUP_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.Dd_Tge_Tipo_Gestor where dd_tge_codigo='''||TRIM(V_TMP_TIPO(4))||''')' ||
                         ' WHERE TAP_CODIGO = ''' || V_TMP_TIPO(2)|| ''' AND DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO WHERE DD_TPO_CODIGO='''||TRIM(V_TMP_TIPO(1))||''')';
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
			ELSE
        DBMS_OUTPUT.PUT_LINE('NO ENCONTRADO...' || TRIM(V_TMP_TIPO(2)));
			END IF;
      END LOOP;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA ||'.dd_tfa_fichero_adjunto... Insertados datos en el diccionario');

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