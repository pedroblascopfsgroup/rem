package es.capgemini.pfs.interna;

/**
 * Constantes para los business operations relacionadas con todo lo referente a
 * Expediente y Comite.
 * 
 * @author Andrés Esteban
 * 
 */
public final class InternaBusinessOperation {

    private InternaBusinessOperation() {
        // Para que no moleste el checkstyle
    }

    /*****************************************************************************
     ** ComiteManager.
     ****************************************************************************/
    public static final String BO_COMITE_MGR_GET_WITH_SESSIONS = "comiteManager.getWithSessiones";
    public static final String BO_COMITE_MGR_CERRAR_SESION = "comiteManager.cerrarSesion";
    public static final String BO_COMITE_MGR_GET_DTO = "comiteManager.getDto";
    public static final String BO_COMITE_MGR_CREAR_SESION = "comiteManager.crearSesion";
    public static final String BO_COMITE_MGR_GET_SESION_WITH_ASISTENTES = "comiteManager.getWithAsistentes";
    public static final String BO_COMITE_MGR_GET_COMITES = "comiteManager.getComites";
    public static final String BO_COMITE_MGR_GET = "comiteManager.get";
    public static final String BO_COMITE_MGR_GET_ACTA_PDF = "comiteManager.getActaPDF";
    public static final String BO_COMITE_MGR_FIND_COMITES_CURRENT_USER = "comiteManager.findComitesCurrentUser";
    public static final String BO_COMITE_MGR_FIND_SESIONES_COMITE = "comiteManager.findSesionesComiteCerradasCurrentUser";
    public static final String BO_COMITE_MGR_GET_DTO_PARA_SESION = "comiteManager.getDtoParaSesion";
    public static final String BO_COMITE_MGR_VALIDATE_CERRAR_SESION = "comiteManager.validateCerrarSesion";
    public static final String BO_COMITE_MGR_BUSCAR_COMITE_PARA_ELEVAR = "comiteManager.buscarComiteParaElevar";
    public static final String BO_COMITE_MGR_ELEVAR_A_COMITE_SUPERIOR = "comiteManager.elevarAComiteSuperior";
    public static final String BO_COMITE_MGR_BUSCAR_COMITES_DELEGAR = "comiteManager.buscarComitesDelegar";

    /*****************************************************************************
     ** DecisionComiteManager.
     ****************************************************************************/
    public static final String BO_DECISIONN_COMITE_MRG_SAVE = "decisionComiteManager.save";
    public static final String BO_DECISIONN_COMITE_GET = "decisionComiteManager.get";
    public static final String BO_DECISIONN_COMITE_SAVE_OR_UPDATE = "decisionComiteManager.saveOrUpdate";

    /*****************************************************************************
     ** ExpedienteManager.
     ****************************************************************************/
    public static final String BO_EXP_MGR_BAJAR_ADJUNTO = "expedienteManager.bajarAdjunto";
    public static final String BO_EXP_MGR_BUSCAR_AAA = "expedienteManager.buscarAAA";
    public static final String BO_EXP_MGR_BUSCAR_SOLICITUD_CANCELACION_POR_TAREA = "expedienteManager.buscarSolCancPorTarea";
    public static final String BO_EXP_MGR_BUSCAR_SOLICITUD_CANCELACION = "expedienteManager.buscarSolicitudCancelacion";
    public static final String BO_EXP_MGR_CALCULAR_COMITE_EXPEDIENTE = "expedienteManager.calcularComiteExpediente";
    public static final String BO_EXP_MGR_CAMBIAR_ESTADO_ITINERARIO_EXPEDIENTE = "expedienteManager.cambiarEstadoItinerarioExpediente";
    public static final String BO_EXP_MGR_CANCELACION_EXPEDIENTE = "expedienteManager.cancelacionExp";
    public static final String BO_EXP_MGR_CANCELACION_EXPEDIENTE_MANUAL = "expedienteManager.cancelacionExpManual";
    public static final String BO_EXP_MGR_CERRAR_DECISION_POLITICA = "expedienteManager.cerrarDecisionPolitica";
    public static final String BO_EXP_MGR_CONFIRMAR_EXPEDIENTE_AUTOMATICO = "expedienteManager.confirmarExpedienteAutomatico";
    public static final String BO_EXP_MGR_CONGELAR_EXPEDIENTE = "expedienteManager.congelarExpediente";
    public static final String BO_EXP_MGR_CONTRATOS_DE_UN_EXPEDIENTE_SIN_PAGINAR = "expedienteManager.contratosDeUnExpedienteSinPaginar";
    public static final String BO_EXP_MGR_CREAR_DATOS_PARA_DECISION_COMITE_AUTO = "expedienteManager.crearDatosParaDecisionComiteAutomatica";
    public static final String BO_EXP_MGR_CREAR_EXPEDIENTE_AUTO = "expedienteManager.crearExpedienteAutomatico";
    public static final String BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL = "expedienteManager.crearExpedienteManual";
    public static final String BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_ARQ = "expedienteManager.crearExpedienteManualArq";
    public static final String BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_SEGUIMIENTO = "expedienteManager.crearExpedienteManualSeg";
    public static final String BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_SEGUIMIENTO_ARQ = "expedienteManager.crearExpedienteManualSegArq";
    public static final String BO_EXP_MGR_DELETE_ADJUNTO = "expedienteManager.deleteAdjunto";
    public static final String BO_EXP_MGR_DESCONGELAR_EXPEDIENTE = "expedienteManager.desCongelarExpediente";
    public static final String BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_COMPLETAR = "expedienteManager.devolverExpedienteACompletar";
    public static final String BO_EXP_MGR_UPDATE_EXPEDIENTE_CONTRATO = "expedienteManager.updateExpedienteContrato";
    public static final String BO_EXP_MGR_GET_EXPEDIENTE = "expedienteManager.getExpediente";
    public static final String BO_EXP_MGR_SAVE_OR_UPDATE = "expedienteManager.saveOrUpdate";
    public static final String BO_EXP_MGR_SAVE_OR_UPDATE_EXCLUSION_EXPEDIENTE_CLIENTE = "expedienteManager.saveOrUpdateExclusionExpedienteCliente";
    public static final String BO_EXP_MGR_GET_EXPEDINTE_CONTRATO = "expedienteManager.getExpedienteContrato";
    public static final String BO_EXP_MGR_GUARDAR_SOLICITUD_CANCELACION = "expedienteManagerguardarSolicitudCancelacion";
    public static final String BO_EXP_MGR_SIN_EXPEDIENTES_ACTIVOS_DE_UNA_PERSONA = "expedienteManager.sinExpedientesActivosDeUnaPersona";
    public static final String BO_EXP_MGR_FIND_EXPEDIENTES_PAGINATED = "expedienteManager.findExpedientesPaginated";
    public static final String BO_EXP_MGR_FIND_EXPEDIENTES_CONTRATO_POR_ID = "expedienteManager.findExpedientesContratoPorId";
    public static final String CONTRATOS_DE_UN_EXPEDIENET_SIN_PAGINAR = "expedienteManager.contratosDeUnExpedienteSinPaginar";
    public static final String BO_EXP_MGR_FIND_PERSONAS_BY_EXPEDIENET_ID = "expedienteManager.findPersonasByExpedienteId";
    public static final String BO_EXP_MGR_OBTENER_CONTRATOS_GENERACION_EXPEDIENTE = "expedienteManager.obtenerContratosGeneracionExpediente";
    public static final String BO_EXP_MGR_OBTEER_SUPERVISOR_GENERACION_EXPEDIENTE = "expedienteManager.obtenerSupervisorGeneracionExpediente";
    public static final String BO_EXP_MGR_OBTENER_EXPEDIENTE_DE_UNA_PERSONA = "expedienteManager.obtenerExpedientesDeUnaPersona";
    public static final String BO_EXP_MGR_OBTENER_EXPEDIENTE_DE_UNA_PERSONA_PAGINADOS = "expedienteManager.obtenerExpedientesDeUnaPersonaPaginados";
    public static final String BO_EXP_MGR_OBTENER_EXPEDIENTES_DE_UNA_PERSONA_NO_CANCELADOS = "expedienteManager.obtenerExpedientesDeUnaPersonaNoCancelados";
    public static final String BO_EXP_MGR_SET_INSTANCE_CAMBIO_ESTADO_EXPEDIENTE = "expedienteManager.setInstanteCambioEstadoExpediente";
    public static final String BO_EXP_MGR_FIND_TITULOS_EXPEDIENTE = "expedienteManager.findTitulosExpediente";
    public static final String BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_REVISION = "expedienteManager.elevarExpedienteARevision";
    public static final String BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_DECISION_COMITE = "expedienteManager.elevarExpedienteADecisionComite";
    public static final String BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_REVISION = "expedienteManager.devolverExpedienteARevision";
    public static final String BO_EXP_MGR_PUEDE_MOSTRAR_SOLAPA_DECISION_COMITE = "expedienteManager.puedeMostrarSolapaDecisionComite";
    public static final String BO_EXP_MGR_PUEDE_MOSTRAR_SOLAPA_MARCADO_POLITICA = "expedienteManager.puedeMostrarSolapaMarcadoPoliticas";
    public static final String BO_EXP_MGR_SOLICITAR_CANCELACION_EXPEDIENTE = "expedienteManager.solicitarCancelacionExpediente";
    public static final String BO_EXP_MGR_RECHAZAR_CANCELACION_EXPEDIENTE = "expedienteManager.rechazarCancelacionExpediente";
    public static final String BO_EXP_MGR_UPDATE_AAA = "expedienteManager.updateActitudAptitudActuacion";
    public static final String BO_EXP_MGR_UPDATE_AAA_REVISION = "expedienteManager.updateActitudAptitudActuacionRevision";
    public static final String BO_EXP_MGR_FIND_PERSONAS_TIT_CONTRATOS_EXPEDIENTES = "expedienteManager.findPersonasTitContratosExpediente";
    public static final String BO_EXP_MGR_FIND_PERSONAS_CONTRATOS_CON_ADJUNTOS = "expedienteManager.findPersonasContratosConAdjuntos";
    public static final String BO_EXP_MGR_FIND_CONTRATOS_CON_ADJUNTOS = "expedienteManager.findContratosConAdjuntos";
    public static final String BO_EXP_MGR_FIND_CONTRATOS_RIESGO_EXPEDIENTES = "expedienteManager.findContratosRiesgoExpediente";
    public static final String BO_EXP_MGR_TOMAR_DECISION_COMITE = "expedienteManager.tomarDecisionComite";
    public static final String BO_EXP_MGR_TOMAR_DECISION_COMITE_COMPLETO = "expedienteManager.tomarDecisionComiteCompleto";
    public static final String BO_EXP_MGR_UPLOAD = "expedienteManager.upload";
    public static final String BO_EXP_MGR_GET_PROPUESTA_EXPEDIENTE_MANUAL = "expedienteManager.getPropuestaExpedienteManual";
    public static final String BO_EXP_MGR_PROPONER_ACTIVAR_EXPEDIENTE = "expedienteManager.proponerActivarExpediente";
    public static final String BO_EXP_MGR_FIND_EXCLUSION_EXPEDIENTE_CLIENTE_BY_EXPEDIENTE = "expedienteManager.findExclusionExpedienteClienteByExpedienteId";
    public static final String BO_EXP_MGR_SAVE_EXCLUSION_EXPEDIENTE_CLIENTE = "expedienteManager.saveExclusionExpedienteCliente";
    public static final String BO_EXP_MGR_TOMAR_DECISION_CANCELACION = "expedienteManager.tomarDecisionCancelacion";
    public static final String BO_EXP_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE = "expedienteManager.incluirContratosAlExpediente";
    public static final String BO_EXP_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE = "expedienteManager.excluirContratosAlExpediente";
    public static final String BO_EXP_MGR_EXISTE_DECISION_INICIADA = "expedienteManager.existeDecisionIniciada";
    public static final String BO_EXP_MGR_PRORROGA_EXTRA = "expedienteManager.prorrogaExtra";
    public static final String BO_EXP_MGR_FIND_EXPEDIENTES_PARA_EXCEL = "expedienteManager.findExpedientesParaExcel";
    public static final String BO_EXP_MGR_GET_REGLAS_ELEVACION_EXPEDIENTE = "expedienteManager.getReglasElevacionExpediente";
    public static final String BO_EXP_MGR_GET_ENTIDADES_REGLA_ELEVACON_EXPEDIENTE = "expedienteManager.getEntidadReglaElevacionExpediente";
    public static final String BO_EXP_MGR_IS_RECOBRO = "expedienteManager.isRecobro";
    public static final String BO_EXP_MGR_GET_PERSONAS_MARCADO_OBLIGATORIO = "expedienteManager.getPersonasMarcadoObligatorio";
    public static final String BO_EXP_MGR_GET_PERSONAS_MARCADO_OPCIONAL = "expedienteManager.getPersonasMarcadoOpcional";
    public static final String BO_EXP_MGR_GET_PERSONAS_POLITICAS_DEL_EXPEDIENTE = "expedienteManager.getPersonasPoliticasDelExpediente";
	public static final String BO_EXP_MGR_TIENE_EXPEDIENTE_SEGUIMIENTO = "expedienteManager.tieneExpedienteSeguimiento";
	public static final String BO_EXP_MGR_TIENE_EXPEDIENTE_RECUPERACION = "expedienteManager.tieneExpedienteRecuperacion";
	public static final String BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_FORMALIZAR_PROPUESTA = "expedienteManager.elevarExpedienteAFormalizarPropuesta";
    public static final String BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_DECISION_COMITE = "expedienteManager.devolverExpedienteADecisionComite";
    public static final String BO_EXP_MGR_FIND_EXPEDIENTES_PAGINATED_DINAMICO = "expedienteManager.findExpedientesPaginatedDinamico";
    public static final String BO_EXP_MGR_FIND_EXPEDIENTES_RECOBRO_PAGINATED_DINAMICO = "expedienteManager.findExpedientesRecobroPaginatedDinamico";
    public static final String BO_EXP_MGR_FIND_EXPEDIENTES_PARA_EXCEL_DINAMICO = "expedienteManager.findExpedientesParaExcelDinamico";
    public static final String BO_EXP_MGR_FIND_EXPEDIENTES_RECOBRO_PARA_EXCEL_DINAMICO = "expedienteManager.findExpedientesRecobroParaExcelDinamico";
    public static final String BO_EXP_MGR_ELEVAR_EXPEDIENTE_DE_REVISION_A_ENSANCION = "expedienteManager.elevarExpedienteDeREaENSAN";
    public static final String BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_ENSANCION_A_REVISION = "expedienteManager.devolverExpedienteDeENSANaRE";
    public static final String BO_EXP_MGR_ELEVAR_EXPEDIENTE_DE_ENSANCION_A_SANCIONADO = "expedienteManager.elevarExpedienteDeENSANaSANC";
    public static final String BO_EXP_MGR_ELEVAR_EXPEDIENTE_DE_SANCIONADO_A_FORMALIZAR_PROPUESTA = "expedienteManager.elevarExpedienteDeSANCaFP";
    public static final String BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_SANCIONADO_A_COMPLETAR_EXPEDIENTE = "expedienteManager.devolverExpedienteDeSANCaCE";
    public static final String BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_FORMALIZAR_PROPUESTA_A_SANCIONADO = "expedienteManager.devolverExpedienteDeFPaENSAN";
    /*****************************************************************************
     ** PoliticaManager.
     ****************************************************************************/
    public static final String BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA = "politicaManager.buscarPoliticasParaPersona";
    public static final String BO_POL_MGR_GET = "politicaManager.get";
    public static final String BO_POL_MGR_GET_POL_BY_CMP = "politicaManager.getByCmp";
    public static final String BO_POL_MGR_INICIALIZAR_POLITICAS_EXPEDIENTE = "politicaManager.inicializaPoliticasExpediente";
    public static final String BO_POL_MGR_MARCAR_POLITICAS_VIGENTES = "politicaManager.marcaPoliticasVigentes";
    public static final String BO_POL_MGR_GET_POLITICA_PROPUESTA_EXPEDIENTE_PERSONA_ESTADO_ITINERARIO = "politicaManager.getPoliticaPropuestaExpedientePersonaEstadoItinerario";
    public static final String BO_POL_MGR_BUSCAR_ULTIMA_POLITICA = "politicaManager.buscarUltimaPolitica";
    public static final String BO_POL_MGR_BUSCAR_POLITICA_VIGENTE = "politicaManager.buscarPoliticaVigente";
    public static final String BO_POL_MGR_GUARDAR_POLITICA = "politicaManager.guardarPolitica";
    public static final String BO_POL_MGR_BUSCAR_POLITICAS_CICLO_MARCADO_POLITICA = "politicaManager.buscarPoliticasCicloMarcadoPolitica";
    public static final String BO_POL_MGR_BUSCAR_OBJETIVOS_POLITICA = "politicaManager.buscarObjetivosPolitica";
    public static final String BO_POL_MGR_GET_DTO_POLITICA = "politicaManager.getDtoPolitica";
    public static final String BO_POL_MGR_GET_TIPO_POLITICA_LIST = "politicaManager.getTipoPoliticaList";
    public static final String BO_POL_MGR_GET_TIPO_POLITICA_PERSONA_LIST = "politicaManager.getTipoPoliticaPersonaList";
    public static final String BO_POL_MGR_GET_TIPO_MOTIVO = "politicaManager.getMotivoList";
    public static final String BO_POL_MGR_COMPRUEBA_PERMISOS_USUARIO = "politicaManager.compruebaPermisosUsuario";
    public static final String BO_POL_MGR_CERRAR_DECISION_POLITICA = "politicaManager.cerrarDecisionPolitica";
    public static final String BO_POL_MGR_GET_NUM_POLITICAS_GENERADAS = "politicaManager.getNumPoliticasGeneradas";
    public static final String BO_POL_MGR_CERRAR_DECISION_POLITICA_SUPERUSUARIO = "politicaManager.cerrarDecisionPoliticaSuperusuario";
    public static final String BO_POL_MGR_CANCELAR_POLITICA = "politicaManager.cancelarPolitica";
    public static final String BO_POL_MGR_DESHACER_ULTIMAS_POLITICAS = "politicaManager.deshacerUltimasPoliticas";
    public static final String BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA_EXP = "politicaManager.buscarPoliticasParaPersonaExpediente";
    public static final String BO_POL_MGR_GET_TIPOS_POLITICA = "politicaManager.getTiposPolitica";

    /*****************************************************************************
     ** ObjetivoManager.
     ****************************************************************************/
    public static final String BO_OBJ_MGR_SAVE = "objetivoManager.save";
    public static final String BO_OBJ_MGR_UPDATE = "objetivoManager.update";
    public static final String BO_OBJ_MGR_GUARDAR_OBJETIVO = "objetivoManager.guardarObjetivo";
    public static final String BO_OBJ_MGR_GET_OBJETIVOS_PENDIENTES = "objetivoManager.getObjetivosPendientes";
    public static final String BO_OBJ_MGR_EJECUTAR_FORMULA = "objetivoManager.ejecutarFormula";
    public static final String BO_OBJ_MGR_GET_OBJETIVO = "objetivoManager.getObjetivo";
    public static final String BO_OBJ_MGR_BORRAR_OBJETIVO = "objetivoManager.borrarObjetivo";
    public static final String BO_OBJ_MGR_ACEPTACION_BORRADO = "objetivoManager.aceptarPropuestaBorrado";
    public static final String BO_OBJ_MGR_RECHAZAR_PROPUESTA_BORRADO = "objetivoManager.rechazarPropuestaBorrado";
    public static final String BO_OBJ_MGR_BORRAR_TAREA_OBJETIVO = "objetivoManager.borrarTareaObjetivo";
    public static final String BO_OBJ_MGR_ACEPTAR_PROPUESTA_OBJETIVO = "objetivoManager.aceptarPropuestaObjetivo";
    public static final String BO_OBJ_MGR_RECHAZAR_PROPUESTA_OBJETIVO = "objetivoManager.rechazarPropuestaObjetivo";
    public static final String BO_OBJ_MGR_PRPPONER_CUMPLIMIENTO = "objetivoManager.proponerCumplimiento";
    public static final String BO_OBJ_MGR_ACEPTAR_CUMPLIMIENTO = "objetivoManager.aceptarCumplimiento";
    public static final String BO_OBJ_MGR_RECHAZAR_CUMPLIMIENTO = "objetivoManager.rechazarCumplimiento";
    public static final String BO_OBJ_MGR_BUSCAR_OBJETIVOS_GESTOR = "objetivoManager.buscarObjetivosGestor";
    public static final String BO_OBJ_MGR_OBTENER_CANTIDAD_OBJETIVOS_PENDIENTES = "objetivoManager.obtenerCantidadObjetivosPendientes";
    public static final String BO_OBJ_MGR_REVISAR_OBJETIVO = "objetivoManager.revisarObjetivo";
    public static final String BO_OBJ_MGR_ACEPTAR_PROPUESTA_BORRADO = "objetivoManager.aceptarPropuestaBorrado";
    public static final String BO_OBJ_MGR_PROPONER_CUMPLIMIENTO = "objetivoManager.proponerCumplimiento";

    /*****************************************************************************
     ** AnalisisPoliticaManager.
     ****************************************************************************/
    public static final String BO_ANALISIS_POL_MGR_SAVE = "analisisPoliticaManager.save";
    public static final String BO_ANALISIS_POL_MGR_GET_PARCELAS_PERSONAS_PARA_CONSULTA = "analisisPoliticaManager.getParcelasPersonasParaConsulta";
    public static final String BO_ANALISIS_POL_MGR_EDITAR_ANALISIS_PERSONA = "analisisPoliticaManager.editarAnalisisPersona";
    public static final String BO_ANALISIS_POL_MGR_GUARDAR_ANALISIS_PARCELA_PERSONA = "analisisPoliticaManager.guardarAnalisisParcelaPersona";
    public static final String BO_ANALISIS_POL_MGR_GET_PERSONA_OPERACIONES = "analisisPoliticaManager.getPersonasOperaciones";
    public static final String BO_ANALISIS_POL_MGR_EDITAR_ANALISIS_OPERACIONES = "analisisPoliticaManager.editarAnalisisOperaciones";
    public static final String BO_ANALISIS_POL_MGR_GUARDAR_ANALISIS_OPERACIONES = "analisisPoliticaManager.guardarAnalisisOperaciones";
    public static final String BO_ANALISIS_POL_MGR_GUARDAR_ANALISIS_OPERACIONES_MASIVO = "analisisPoliticaManager.guardarAnalisisOperacionesMasivo";
    public static final String BO_ANALISIS_POL_MGR_GUARDAR_ANALISIS_PERSONA_MASIVO = "analisisPoliticaManager.guardarAnalisisPersonaMasivo";
    public static final String BO_ANALISIS_POL_MGR_GUARDAR_GESTIONES_REALIZADAS = "analisisPoliticaManager.guardarGestionesRealizadas";
    public static final String BO_ANALISIS_POL_MGR_GET_ANALISIS_POLITICA = "analisisPoliticaManager.getAnalisisPolitica";
    public static final String BO_ANALISIS_POL_MGR_GET_ANALISIS_POLITICA_BY_ID = "analisisPoliticaManager.getAnalisisPoliticaById";
    public static final String BO_ANALISIS_POL_MGR_GET_ANALISIS_POLITICA_HISTORICO = "analisisPoliticaManager.getAnalisisPoliticaHistorico";
    public static final String BO_ANALISIS_POL_MGR_GET_ANALISIS_POLITICA_HISTORICO_BY_CMP = "analisisPoliticaManager.getAnalisisPoliticaHistoricoByCmp";
    public static final String BO_ANALISIS_POL_MGR_GET_TIPOS_GESTIONES = "analisisPoliticaManager.getTiposGestiones";
    public static final String BO_ANALISIS_POL_MGR_GUARDAR_COMENTARIO_ANALISIS = "analisisPoliticaManager.guardarComentarioAnalisis";
    public static final String BO_ANALISIS_POL_MGR_IS_ANALISIS_POLITICA_COMPLETO = "analisisPoliticaManager.isAnalisisPoliticaCompleto";

    /*****************************************************************************
     ** ProrrogaManager.
     ****************************************************************************/
    public static final String BO_PRORR_MGR_SAVE = "prorrogaManager.save";
    public static final String BO_PRORR_MGR_SAVE_OR_UPDATE = "prorrogaManager.saveOrUpdate";
    public static final String BO_PRORR_MGR_GET = "prorrogaManager.get";
    public static final String BO_PRORR_MGR_OBTENER_CAUSAS = "prorrogaManager.obtenerCausas";
    public static final String BO_PRORR_MGR_OBTENER_RESPUESTAS = "prorrogaManager.obtenerRespuestas";
    public static final String BO_PRORR_MGR_CREAR_NUEVA_PRORROGA = "prorrogaManager.crearNuevaProrroga";
    public static final String BO_PRORR_MGR_RESPONDER_PRORROGA = "prorrogaManager.responderProrroga";
    public static final String BO_PRORR_MGR_OBTENER_DECISION_PRORROGA = "prorrogaManager.obtenerDecisionProrroga";
    public static final String BO_PRORR_MGR_OBTENER_PLAZO = "prorrogaManager.obtenerPlazo";

    /*****************************************************************************
     ** EventoManager.
     ****************************************************************************/
    public static final String BO_EVENTO_MGR_EVENTOS_EXPEDIENTE = "eventoManager.getEventosExpediente";
    public static final String BO_EVENTO_MGR_EVENTOS_PERSONA = "eventoManager.getEventosPersona";
    public static final String BO_EVENTO_MGR_EVENTOS_ASUNTO = "eventoManager.getEventosAsunto";
    public static final String BO_EVENTO_MGR_HISTORICO_EVENTOS = "eventoManager.getHistoricoEventos";
    
}