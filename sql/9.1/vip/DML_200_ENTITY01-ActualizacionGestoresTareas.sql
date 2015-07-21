--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar los gestores en las tareas para HRE-BCC
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
T_TIPO_VALOR('HC103','HC103_SolicitarProvision','CJ-814','GCONPR')
,T_TIPO_VALOR('HC103','HC103_RevisarSolicitud','CJ-811','CJ-SAREO')
,T_TIPO_VALOR('HC103','HC103_AprobarSolicitudFondos','TGCON','GCONPR')
,T_TIPO_VALOR('HC103','HC103_AprobarSolicitudInsc','TGCON','GCONPR')
,T_TIPO_VALOR('HC103','HC103_ConfirmarSolicitud','TGCON','GCONPR')
,T_TIPO_VALOR('HC103','HC103_RealizarTransferencia','TGCON','GCONPR')
,T_TIPO_VALOR('HC103','HC103_ConfirmarTransferencia','TGCON','GCONPR')
,T_TIPO_VALOR('HC103','HC103_DecisionAprobFondos','TGCON','GCONPR')
,T_TIPO_VALOR('HC103','HC103_DecisionAprobarSolcIns','TGCON','GCONPR')
,T_TIPO_VALOR('H005','H005_SolicitudDecretoAdjudicacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H005','H005_notificacionDecretoAdjudicacionAEntidad','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H005','H005_declararIVAeIGIC','TGCTRGE','SCTRGE')
,T_TIPO_VALOR('H005','H005_notificacionDecretoAdjudicacionAlContrario','CJ-811','CJ-SAREO')
,T_TIPO_VALOR('H005','H005_SolicitudTestimonioDecretoAdjudicacion','CJ-811','CJ-SAREO')
,T_TIPO_VALOR('H005','H005_ConfirmarTestimonio','CJ-811','CJ-SAREO')
,T_TIPO_VALOR('H005','H005_RevisionComAdicional','TGGESTDOC','SGESDOC')
,T_TIPO_VALOR('H005','H005_NotifComAdicional','TGAJUR','SAJUR')
,T_TIPO_VALOR('H005','H005_RegistrarPresentacionEnRegistro','CJ-811','CJ-SAREO')
,T_TIPO_VALOR('H005','H005_RegistrarInscripcionDelTitulo','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H005','H005_RevisarInfoContable','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H005','H005_ConfirmarContabilidad','TGCON','CJ-SCON')
,T_TIPO_VALOR('H001','H001_DemandaCertificacionCargas','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_AutoDespachandoEjecucion','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_RegistrarCertificadoCargas','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_SolicitudOficioJuzgado','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_RegResolucionJuzgado','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_ContactarAcreedorPref','TGCONPR','SUCONPR')
,T_TIPO_VALOR('H001','H001_ConfirmarNotificacionReqPago','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_ConfirmarSiExisteOposicion','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_PresentarAlegaciones','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_RegistrarComparecencia','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_RegistrarResolucion','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_ResolucionFirme','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_ResolucionFirme','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_BPMTramiteSubasta','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_BPMTramiteNotificacion','CJ-814','TGCONPR')
,T_TIPO_VALOR('H001','H001_AutoDespachandoDecision','CJ-819','TGCONPR')
,T_TIPO_VALOR('H001','H001_ResolucionFirmeDecision','CJ-819','TGCONPR')
,T_TIPO_VALOR('H016','H016_CambiarioDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H016','H016_confAdmiDecretoEmbargo','CJ-814','GCONPR')
,T_TIPO_VALOR('H016','H016_confNotifRequerimientoPago','CJ-814','GCONPR')
,T_TIPO_VALOR('H016','H016_interposicionDemandaMasBienes','CJ-814','GCONPR')
,T_TIPO_VALOR('H016','H016_registrarAutoEjecucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H016','H016_registrarDemandaOposicion','CJ-814','GCONPR')
,T_TIPO_VALOR('H016','H016_registrarJuicioComparecencia','CJ-814','GCONPR')
,T_TIPO_VALOR('H016','H016_registrarResolucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H016','H016_resolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_DemandaCertificacionCargas','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_AutoDespachandoEjecucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_RegistrarCertificadoCargas','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_ConfirmarNotificacionReqPago','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_ContactarConDeudor','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_ConfirmarSiExisteOposicion','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_RegistrarComparecencia','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_RegistrarResolucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_ResolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_BPMTramiteSubasta','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_BPMTramiteNotificacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H001','H001_AutoDespachandoDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H001','H001_ResolucionFirmeDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H018','H018_AutoDespachando','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_ConfirmarNotificacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_ConfirmarPresentacionImpugnacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_HayVista','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_InterposicionDemanda','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_RegistrarOposicion','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_RegistrarResolucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_RegistrarVista','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_ResolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H018','H018_TituloDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H020','H020_AutoDespaEjecMasDecretoEmbargo','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_BPMProvisionFondos','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_BPMTramiteNotificacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_BPMVigilanciaCaducidadAnotacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_ConfirmarNotifiReqPago','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_ConfirmarPresentacionImpugnacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_ConfirmarSiExisteOposicion','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_ConfirmarVista','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_InterposicionDemandaMasBienes','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_JudicialDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H020','H020_RegistrarCelebracionVista','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_RegistrarResolucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H020','H020_ResolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_BPMProvisionFondos','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_BPMTramiteNotificacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_ConfirmarAdmision','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_ConfirmarNotDemanda','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_ConfirmarOposicion','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_InterposicionDemanda','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_OrdinarioDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H024','H024_RegistrarAudienciaPrevia','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_RegistrarJuicio','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_RegistrarResolucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H024','H024_ResolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_BPMProvisionFondos','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_BPMtramiteNotificacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_ConfirmarAdmisionDemanda','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_ConfirmarNotifiDemanda','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_InterposicionDemanda','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_RegistrarJuicio','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_RegistrarResolucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_ResolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H026','H026_VerbalDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H028','H028_RegistrarJuicioVerbal','CJ-814','GCONPR')
,T_TIPO_VALOR('H028','H028_RegistrarResolucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H028','H028_ResolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H030','H030_ActualizaDatosAnteriores','CJ-814','GCONPR')
,T_TIPO_VALOR('H030','H030_ActualizarDatosTerceria','CJ-814','GCONPR')
,T_TIPO_VALOR('H030','H030_CertificacionDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H030','H030_RegistrarCertificacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H030','H030_RegistrarInformacionCargasAnt','CJ-814','GCONPR')
,T_TIPO_VALOR('H030','H030_RequerirInfoFalta','CJ-814','GCONPR')
,T_TIPO_VALOR('H030','H030_SolicitarInformacionCargasAnt','CJ-814','GCONPR')
,T_TIPO_VALOR('H030','H030_SolicitudCertificacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H064','H064_ConsignacionDecision','DGCONPR','SUCONPR')
,T_TIPO_VALOR('H064','H064_confirmarRealizacionConsignacion','TGCONPR','SUCONPR')
,T_TIPO_VALOR('H064','H064_presentacionJuzgado','CJ-814','GCONPR')
,T_TIPO_VALOR('H064','H064_resultadoSolicitudConsignacion','TGCONPR','SUCONPR')
,T_TIPO_VALOR('H064','H064_solicitarAutorizacionConsignacionSareb','CJ-814','GCONPR')
,T_TIPO_VALOR('H032','H032_ConfirmarPresImpugnacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H032','H032_RegistrarCelebracionVista','CJ-814','GCONPR')
,T_TIPO_VALOR('H032','H032_RegistrarDecTasacionCostas','CJ-814','GCONPR')
,T_TIPO_VALOR('H032','H032_RegistrarPago','CJ-814','GCONPR')
,T_TIPO_VALOR('H032','H032_RegistrarResolucion','CJ-814','GCONPR')
,T_TIPO_VALOR('H032','H032_RegistrarSolCostasContrario','CJ-814','GCONPR')
,T_TIPO_VALOR('H032','H032_ResolucionDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H032','H032_ResolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H007','H007_AutoAprobacionCostas','CJ-814','GCONGE')
,T_TIPO_VALOR('H007','H007_AutoDecision','CJ-819','GCONGE')
,T_TIPO_VALOR('H007','H007_AutoFirme','CJ-814','GCONGE')
,T_TIPO_VALOR('H007','H007_ConfirmarNotificacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H007','H007_Impugnacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H007','H007_JBPMTramiteNotificacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H007','H007_RegistrarCelebracionVista','CJ-814','GCONGE')
,T_TIPO_VALOR('H007','H007_SolicitudTasacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H007','H007_TasacionCostas','CJ-814','GCONGE')
,T_TIPO_VALOR('H034','H034_AceptacionCargoDepositario','CJ-814','GCONGE')
,T_TIPO_VALOR('H034','H034_AcuerdoDecision','CJ-819','GCONGE')
,T_TIPO_VALOR('H034','H034_AcuerdoEntrega','CJ-814','GCONGE')
,T_TIPO_VALOR('H034','H034_NombramientoDepositario','CJ-814','GCONGE')
,T_TIPO_VALOR('H034','H034_SolicitarNombramiento','CJ-814','GCONGE')
,T_TIPO_VALOR('H034','H034_SolicitarRemocion','CJ-814','GCONGE')
,T_TIPO_VALOR('H038','H038_ActualizarDatos','CJ-814','GCONPR')
,T_TIPO_VALOR('H038','H038_ConfirmarRequerimientoResultado','CJ-814','GCONPR')
,T_TIPO_VALOR('H038','H038_ConfirmarRetenciones','CJ-814','GCONPR')
,T_TIPO_VALOR('H038','H038_GestionarProblemas','CJ-814','GCONPR')
,T_TIPO_VALOR('H038','H038_SolicitarNotificacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H038','H043_SalariosDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H040','H040_RecepcionLlavesDecision','CJ-DECGLL','SPGL')
,T_TIPO_VALOR('H040','H040_RegistrarCambioCerradura','CJ-814','CJ-GESTLLA')
,T_TIPO_VALOR('H040','H040_RegistrarEnvioLlaves','CJ-814','CJ-GESTLLA')
,T_TIPO_VALOR('H040','H040_RegistrarRecepcionLlaves','CJ-104','SPGL')
,T_TIPO_VALOR('H066','H066_BPMTramitePosesion','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_BPMTramiteSaneamientoCargas','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_BPMTramiteSubsanacionEscritura','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_obtenerMinuta','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_registrarEntregaTitulo','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_registrarInscripcionTitulo','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_registrarPresentacionHacienda','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_registrarPresentacionRegistro','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_registrarRecepcionEscritura','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H066','H066_validarMinuta','CJ-811','CJ-SAREO')
,T_TIPO_VALOR('H042','H042_BPMTramiteNotificacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H042','H042_ConfirmarNotificacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H042','H042_ElaborarLiquidacion','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H042','H042_InteresesDecision','CJ-819','GCONGE')
,T_TIPO_VALOR('H042','H042_RegistrarImpugnacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H042','H042_RegistrarResolucion','CJ-814','GCONGE')
,T_TIPO_VALOR('H042','H042_RegistrarResolucionVista','CJ-814','GCONGE')
,T_TIPO_VALOR('H042','H042_RegistrarVista','CJ-814','GCONGE')
,T_TIPO_VALOR('H042','H042_ResolucionFirme','CJ-814','GCONGE')
,T_TIPO_VALOR('H042','H042_SolicitarLiquidacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H042','H042_ValidarLiquidacionIntereses','CJ-814','GCONGE')
,T_TIPO_VALOR('H044','H044_InvestigacionDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H044','H044_RegistrarResultadoInvestigacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H044','H044_RevisarDecision','DGCONGE','GCONPR')
,T_TIPO_VALOR('H044','H044_RevisarInvestigacionYActualizacionDatos','TGCONGE','GCONPR')
,T_TIPO_VALOR('H044','H044_SolicitudInvestigacionJudicial','CJ-814','GCONPR')
,T_TIPO_VALOR('H046','H046_MejoraDecision','CJ-819','GCONGE')
,T_TIPO_VALOR('H046','H046_confirmarDecretoEmbargo','CJ-814','GCONGE')
,T_TIPO_VALOR('H046','H046_registrarAnotacionRegistro','CJ-814','GCONGE')
,T_TIPO_VALOR('H046','H046_solicitudMejoraEmbargo','CJ-814','GCONGE')
,T_TIPO_VALOR('H011','H011_CelebracionVista','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_InstruccionesDecision','CJ-819','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_LecturaInstruccionesMoratoria','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_PresentarConformidadMoratoria','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_RegistrarAdmisionYEmplazamiento','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_RegistrarInformeMoratoria','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_RegistrarResolucion','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_RegistrarSolicitudMoratoria','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_RevisarInformeLetradoMoratoria','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_SolicitarInstrucciones','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H011','H011_nodoEsperaController','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('P400','P400_GestionarNotificaciones','CJ-814','GCONGE')
,T_TIPO_VALOR('H050','H050_AcuerdoPrecinto','CJ-814','GCONPR')
,T_TIPO_VALOR('H050','H050_ConfirmarFechaPrecintoEfectivo','CJ-814','GCONPR')
,T_TIPO_VALOR('H050','H050_PrecintoDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H050','H050_SolicitarPrecinto','CJ-814','GCONPR')
,T_TIPO_VALOR('H052','H052_EntregarNuevoDecreto','CJ-814','GCONGE')
,T_TIPO_VALOR('H052','H052_RegistrarPresentacionEscritoSub','CJ-814','GCONGE')
,T_TIPO_VALOR('H065','H065_entregarNuevaEscrituraPub','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H065','H065_registrarPresentacionEscrituraSub','CJ-814','CJ-GAREO')
,T_TIPO_VALOR('H054','H054_ConfirmarComEmpresario','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H054','H054_EmisionInformeFiscal','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H054','H054_PresentarEscritoJuzgado','CJ-814','GCONGE')
,T_TIPO_VALOR('H054','H054_ValidaBienesTributacion','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H058','H058_BPMProvisionFondos','CJ-814','GCONPR')
,T_TIPO_VALOR('H058','H058_EstConformidadOAlegacion','CJ-814','GCONPR')
,T_TIPO_VALOR('H058','H058_InmueblesDecision','CJ-819','GCONPR')
,T_TIPO_VALOR('H058','H058_ObtencionAvaluo','CJ-814','GCONPR')
,T_TIPO_VALOR('H058','H058_ObtencionTasacionInterna','CJ-814','GCONPR')
,T_TIPO_VALOR('H058','H058_PresentarAlegaciones','CJ-814','GCONPR')
,T_TIPO_VALOR('H058','H058_RegistrarResultado','CJ-814','GCONPR')
,T_TIPO_VALOR('H058','H058_ResolucionFirme','CJ-814','GCONPR')
,T_TIPO_VALOR('H058','H058_SolicitarAvaluo','CJ-814','GCONPR')
,T_TIPO_VALOR('H058','H058_SolitarTasacionInterna','CJ-814','GCONPR')
,T_TIPO_VALOR('H002','H002_SolicitudSubasta','CJ-814','GCONPR')
,T_TIPO_VALOR('H002','H002_SenyalamientoSubasta','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_RevisarDocumentacion','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_AdjuntarNotasSimples','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_AdjuntarTasaciones','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_SolicitarInformeFiscal','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_AdjuntarInformeFiscal','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_PrepararInformeSubasta','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_ValidarInformeDeSubasta','TSUCONGE','SUCONT')
,T_TIPO_VALOR('H002','H002_ObtenerValidacionComite','TGCTRGE','DRECU')
,T_TIPO_VALOR('H002','H002_DictarInstruccionesSubasta','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_SolicitarSuspenderSubasta','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_RegistrarResSuspSubasta','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_DictarInstruccionesDeneSuspension','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_LecturaConfirmacionInstrucciones','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_CelebracionSubasta','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_SolicitarMandamientoPago','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_ConfirmarRecepcionMandamientoDePago','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_RecepcionMandamientoPago','TGCONGE','SUCONGE')
,T_TIPO_VALOR('H002','H002_ConfirmarContabilidad','TGCON','SUCONT')
,T_TIPO_VALOR('H002','H002_BPMTramiteSolSolvenciaPatrimonial','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_BPMTramiteSubasta','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_BPMTramiteCesionRemate','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_BPMTramiteAdjudicacion','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_SuspenderDecision','CJ-814','GCONGE')
,T_TIPO_VALOR('H002','H002_CelebracionDecision','CJ-814','GCONGE')
,T_TIPO_VALOR('HC100','HC100_ComunicarCalculoDeudaAFecha','CJ-814','GCONGE')
,T_TIPO_VALOR('HC100','HC100_RealizarCalculoDeuda','CJ-814','GCONGE')
,T_TIPO_VALOR('HC100','HC100_RegistrarPeticionCalculoDeuda','CJ-814','GCONGE')
,T_TIPO_VALOR('H062','H062_confirmarAnotacionRegistro','CJ-814','GCONPR')
,T_TIPO_VALOR('H062','H062_revisarRegistroEmbargo','CJ-814','GCONPR')
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