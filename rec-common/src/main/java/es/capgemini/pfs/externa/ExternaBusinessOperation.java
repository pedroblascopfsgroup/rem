package es.capgemini.pfs.externa;

/**
 * Constantes para los business operations
 * relacionadas con todo lo referente a Asunto y Procedimientos.
 * @author Andrés Esteban
 *
 */
public final class ExternaBusinessOperation {

    private ExternaBusinessOperation() {
        // Para que no moleste el checkstyle
    }

    /*****************************************************************************
     ** asuntosManager.
     ****************************************************************************/
    public static final String BO_ASU_MGR_SAVE_OR_UDPATE = "asuntosManager.saveOrUpdateAsunto";
    public static final String BO_ASU_MGR_GENERAR_TAREA_POR_CIERRE_DECISION = "asuntosManager.generarTareasPorCierreDecision";
    public static final String BO_ASU_MGR_CREAR_TAREA_ACEPTAR_ASUNTO = "asuntosManager.crearTareaAceptarAsunto";
    public static final String BO_ASU_MGR_MARCAR_PROCEDIMIENTOS_COMO_DECIDIDOS = "asuntosManager.marcarProcedimientosComoDecidos";
    public static final String BO_ASU_MGR_BORRAR_ASUNTO = "asuntosManager.borrarAsunto";
    public static final String BO_ASU_MGR_CREAR_ASUNTO = "asuntosManager.crearAsunto";
    public static final String BO_ASU_MGR_CREAR_ASUNTO_DTO = "asuntosManager.crearAsuntoDTO";
    public static final String BO_ASU_MGR_GET_ASUNTOS_MISMO_NOMBRE = "asuntosManager.getAsuntosMismoNombre";
    public static final String BO_ASU_MGR_CREAR_PRE_ASUNTO = "asuntosManager.crearPreAsunto";
    public static final String BO_ASU_MGR_GET = "asuntosManager.get";
    public static final String BO_ASU_MGR_ACTUALIZA_ESTADO_ASUNTO = "asuntosManager.actualizaEstadoAsunto";
    public static final String BO_ASU_MGR_OBTENER_ASUNTOS_DE_UNA_PERSONA = "asuntosManager.obtenerAsuntosDeUnaPersona";
    public static final String BO_ASU_MGR_OBTENER_ASUNTOS_DE_UNA_PERSONA_PAGINADOS = "asuntosManager.obtenerAsuntosDeUnaPersonaPaginados";
    public static final String BO_ASU_MGR_OBTENER_ASUNTOS_DE_UN_ASUNTO = "asuntosManager.obtenerAsuntosDeUnAsunto";
    public static final String BO_ASU_MGR_OBTENER_ASUNTOS_DE_UN_EXPEDIENTE = "asuntosManager.obtenerAsuntosDeUnExpediente";
    public static final String BO_ASU_MGR_MODIFICAR_ASUNTO = "asuntosManager.modificarAsunto";
    public static final String BO_ASU_MGR_FIND_ASUNTOS_PAGINATED = "asuntosManager.findAsuntosPaginated";
    public static final String BO_ASU_MGR_FIND_CONTRATOS_TITULOS = "asuntosManager.findContratosTitulos";
    public static final String BO_ASU_MGR_ACEPTAR_ASUNTO = "asuntosManager.aceptarAsunto";
    public static final String BO_ASU_MGR_FIND_EXPEDIENTE_CONTRATOS_POR_ID = "asuntosManager.findExpedienteContratosPorId";
    public static final String BO_ASU_MGR_DEVOLVER_ASUNTO = "asuntosManager.devolverAsunto";
    public static final String BO_ASU_MGR_PUEDO_DEVOLVER_ASUNTO = "asuntosManager.puedoDevolverAsunto";
    public static final String BO_ASU_MGR_TOMAR_DECISIONES_COMITE = "asuntosManager.tomarDecisionComite";
    public static final String BO_ASU_MGR_OBTENER_CONTRATO_DE_ASUNTO_E_HIJOS = "asuntosManager.obtenerContratosDeUnAsuntoYSusHijos";
    public static final String BO_ASU_MGR_ELEVAR_COMITE_ASUNTO = "asuntosManager.elevarComiteAsunto";
    public static final String BO_ASU_MGR_GUARDAR_FICHA_ACEPTACION = "asuntosManager.guardarFichaAceptacion";
    public static final String BO_ASU_MGR_PUEDE_TOMAR_ACCION_ASUNTO = "asuntosManager.puedeTomarAccionAsunto";
    public static final String BO_ASU_MGR_BUSCAR_TAREA_PENDIENTE = "asuntosManager.buscarTareaPendiente";
    public static final String BO_ASU_MGR_ES_GESTOR = "asuntosManager.esGestor";
    public static final String BO_ASU_MGR_ES_SUPERVISOR = "asuntosManager.esSupervisor";
    public static final String BO_ASU_MGR_ES_GESTOR_DECISION = "asuntosManager.esGestorDecision";    
    public static final String BO_ASU_MGR_UPLOAD = "asuntosManager.upload";
    public static final String BO_ASU_MGR_BAJAR_ADJUNTO = "asuntosManager.bajarAdjunto";
    public static final String BO_ASU_MGR_DELETE_ADJUNTO = "asuntosManager.deleteAdjunto";
    public static final String BO_ASU_MGR_PUEDE_VER_DECISIONES_COMITE = "asuntosManager.puedeVerDecisionComite";
    public static final String BO_ASU_MGR_OBTENER_PERSONAS_DE_UN_ASUNTO = "asuntosManager.obtenerPersonasDeUnAsunto";
    public static final String BO_ASU_MGR_GET_EXPEDIENTE_SI_TIENE_ADJUNTO = "asuntosManager.getExpedienteSiTieneAdjuntos";
    public static final String BO_ASU_MGR_GET_EXPEDIENTE_AS_LIST = "asuntosManager.getExpedienteAsList";
    public static final String BO_ASU_MGR_GET_CONTRATOS_QUE_TIENE_ADJUNTO = "asuntosManager.getContratosQueTienenAdjuntos";
    public static final String BO_ASU_MGR_CAMBIAR_GESTOR_ASUNTO = "asuntosManager.cambiarGestorAsunto";
    public static final String BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO_JERARQUICO = "asuntosManager.obtenerActuacionesAsuntoJerarquico";
    public static final String BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO = "asuntosManager.obtenerActuacionesAsunto";
    public static final String BO_ASU_MGR_GET_BIENES_AS_LIST = "asuntosManager.getBienesDeUnAsunto";
    public static final String BO_ASU_MGR_GET_LIST_TIPOS_ASUNTO = "asuntosManager.obtenerListadoTiposDeAsunto";

    /*****************************************************************************
     ** ProcedimientoManager.
     ****************************************************************************/
    public static final String BO_PRC_MGR_ACEPTAR_PROCEDIMIENTO = "procedimientoManager.aceptarProcedimiento";
    public static final String BO_PRC_MGR_BORRAR_PROCEDIMIENTO = "procedimientoManager.borrarProcedimiento";
    public static final String BO_PRC_MGR_BUSCAR_TAREA_EXTERNA = "procedimientoManager.buscarTareaPendiente";
    public static final String BO_PRC_MGR_CREAR_TAREA_RECOPILAR_DOCUMENTACION = "procedimientoManager.crearTareaRecopilarDocumentacion";
    public static final String BO_PRC_MGR_ES_GESTOR = "procedimientoManager.esGestor";
    public static final String BO_PRC_MGR_ES_SUPERVISOR = "procedimientoManager.esSupervisor";
    public static final String BO_PRC_MGR_FORMULARIO_DEMANDA = "procedimientoManager.formularioDemanda";
    public static final String BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO = "procedimientoManager.getBienesDeUnProcedimiento";
    public static final String BO_PRC_MGR_GET_PERSONAS_AFECTADAS = "procedimientoManager.getPersonasAfectadas";
    public static final String BO_PRC_MGR_GET_PERSONAS_ASOCIADAS_A_CONTRATO_PROCEDIMIENTO = "procedimientoManager.getPersonasAsociadasAContratoProcedimiento";
    public static final String BO_PRC_MGR_GET_PERSONAS_DE_LOS_CONTRATOS_PROCEDIMIMENTO = "procedimientoManager.getPersonasDeLosContratosProcedimiento";
    public static final String BO_PRC_MGR_GET_PROCEDIMIMENTO = "procedimientoManager.getProcedimiento";
    public static final String BO_PRC_MGR_GET_PROCEDIMIMENTOS_DE_EXPEDIENTE = "procedimientoManager.getProcedimientosDeExpediente";
    public static final String BO_PRC_MGR_GUARDAR_PROCEDIMIMENTO = "procedimientoManager.guardarProcedimiento";
    public static final String BO_PRC_MGR_SALVAR_PROCEDIMIMENTO = "procedimientoManager.salvarProcedimiento";
    public static final String BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO = "procedimientoManager.saveOrUpdateProcedimiento";
    public static final String BO_PRC_MGR_SAVE_PROCEDIMIENTO = "procedimientoManager.saveProcedimiento";
    public static final String BO_PRC_MGR_SAVE_RECOPILACION_PROCEDIMIENTO = "procedimientoManager.saveRecopilacionProcedimiento";
    public static final String BO_PRC_MGR_DELETE = "procedimientoManager.delete";
    public static final String BO_PRC_MGR_GET_TIPOS_ACTUACION = "procedimientoManager.getTiposActuacion";
    public static final String BO_PRC_MGR_GET_TIPOS_PROCEDIMIENTO = "procedimientoManager.getTiposProcedimiento";
    public static final String BO_PRC_MGR_GET_TIPOS_RECLAMACION = "procedimientoManager.getTiposReclamacion";
    public static final String BO_PRC_MGR_GET_ESTADOS_PROCEDIMIENTOS = "procedimientoManager.getEstadosProcedimientos";
    public static final String BO_PRC_MGR_BUSCAR_TAREA_PENDIENTE = "procedimientoManager.buscarTareaPendiente";

    /*****************************************************************************
     ** DecisionProcedimientoManager.
     ****************************************************************************/
    public static final String BO_DEC_PRC_MGR_GET_LIST = "decisionProcedimientoManager.getList";
    public static final String BO_DEC_PRC_MGR_GET = "decisionProcedimientoManager.get";
    public static final String BO_DEC_PRC_MGR_GET_INSTANCE = "decisionProcedimientoManager.getInstance";
    public static final String BO_DEC_PRC_MGR_CREAR_PROPUESTA = "decisionProcedimientoManager.crearPropuesta";
    public static final String BO_DEC_PRC_MGR_CREATE_OR_UPDATE = "decisionProcedimientoManager.createOrUpdate";
    public static final String BO_DEC_PRC_MGR_GET_PROCEDIMIENTOS_DERIVADOS = "decisionProcedimientoManager.getProcedimientosDerivados";
    public static final String BO_DEC_PRC_MGR_ACEPTAR_PROPUESTA = "decisionProcedimientoManager.aceptarPropuesta";
    public static final String BO_DEC_PRC_MGR_RECHAZAR_PROPUESTA = "decisionProcedimientoManager.rechazarPropuesta";

    /*****************************************************************************
     ** JuzgadosManager.
     ****************************************************************************/
    public static final String BO_JUZGADO_MGR_GET_JUZGADOS_BY_PLAZA = "juzgadosManager.getJuzgadosByPlaza";

    /*****************************************************************************
     ** AcuerdoManager.
     ****************************************************************************/
    public static final String BO_ACUERDO_MGR_GET_ACUERDO_BY_ID = "acuerdoManager.getAcuerdoById";
    public static final String BO_ACUERDO_MGR_GET_ACUERDO_DEL_ASUNTO = "acuerdoManager.getAcuerdosDelAsunto";
    public static final String BO_ACUERDO_MGR_GET_ACTUACIONES_REALIZADAS_ACUERDO = "acuerdoManager.getActuacionesRealizadasAcuerdo";
    public static final String BO_ACUERDO_MGR_ACEPTAR_ACUERDO = "acuerdoManager.aceptarAcuerdo";
    public static final String BO_ACUERDO_MGR_RECHAZAR_ACUERDO = "acuerdoManager.rechazarAcuerdo";
    public static final String BO_ACUERDO_MGR_FINALIZAR_ACUERDO = "acuerdoManager.finalizarAcuerdo";
    public static final String BO_ACUERDO_MGR_GUARDAR_ACUERDO = "acuerdoManager.guardarAcuerdo";
    public static final String BO_ACUERDO_MGR_PROPONER_ACUERDO = "acuerdoManager.proponerAcuerdo";
    public static final String BO_ACUERDO_MGR_CANCELAR_ACUERDO = "acuerdoManager.cancelarAcuerdo";
    public static final String BO_ACUERDO_MGR_ACTUALIZACIONES_REALIZADAS_ACUERDO = "acuerdoManager.getActuacionAcuerdo";
    public static final String BO_ACUERDO_MGR_SAVE_ACTUACIONES_REALIZADAS_ACUERDO = "acuerdoManager.saveActuacionesRealizadasAcuerdo";
    public static final String BO_ACUERDO_MGR_GUARDAR_ANALISIS_ACUERDO = "acuerdoManager.guardarAnalisisAcuerdo";
    public static final String BO_ACUERDO_MGR_GET_ACTUALIZACIONES_A_EXPLORAR_ACUERDO_BY_ID = "acuerdoManager.getActuacionesAExplorarAcuerdoById";
    public static final String BO_ACUERDO_MGR_GET_ACTUALIZACIONES_A_EXPLORAR_ACUERDO = "acuerdoManager.getActuacionesAExplorarAcuerdo";
    public static final String BO_ACUERDO_MGR_SAVE_ACTUACIONES_A_EXPLORAR_ACUERDO = "acuerdoManager.saveActuacionAExplorarAcuerdo";
    public static final String BO_ACUERDO_MGR_PUEDE_EDITAR = "acuerdoManager.puedeEditar";

    /*****************************************************************************
     ** EmbargoProcedimientoManager.
     ****************************************************************************/
    public static final String BO_EMBARGO_PRC_MGR_GET_LIST = "embargoProcedimientoManager.getList";
    public static final String BO_EMBARGO_PRC_MGR_GET = "embargoProcedimientoManager.get";
    public static final String BO_EMBARGO_PRC_MGR_GET_BY_ID_BIEN = "embargoProcedimientoManager.getByIdBien";
    public static final String BO_EMBARGO_PRC_MGR_GET_INSTANCE = "embargoProcedimientoManager.getInstance";
    public static final String BO_EMBARGO_PRC_MGR_CREATE_OR_UPDATE = "embargoProcedimientoManager.createOrUpdate";

    /*****************************************************************************
     ** ProcedimientoDerivadoManager.
     ****************************************************************************/
    public static final String BO_PRC_DERIVADO_MGR_GET_LIST = "procedimientoDerivadoManager.getList";
    public static final String BO_PRC_DERIVADO_MGR_GET = "procedimientoDerivadoManager.get";
    public static final String BO_PRC_DERIVADO_MGR_CREATE_OR_UPDATE = "procedimientoDerivadoManager.createOrUpdate";

    /*****************************************************************************
     ** HistoricoProcedimientoManager.
     ****************************************************************************/
    public static final String BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO = "historicoProcedimientoManager.getListByProcedimiento";

    /*****************************************************************************
     ** DespachoExternoManager.
     ****************************************************************************/
    public static final String BO_DESPACHO_EXT_MGR_GET_DESPACHOS_EXTERNOS = "despachoExternoManager.getDespachosExternos";
    public static final String BO_DESPACHO_EXT_MGR_GET_GESTORES_DESPACHO = "despachoExternoManager.getGestoresDespacho";
    public static final String BO_DESPACHO_EXT_MGR_GET_SUPERVISORES_DESPACHO = "despachoExternoManager.getSupervisoresDespacho";
    public static final String BO_DESPACHO_EXT_MGR_GET_ALL_SUPERVISORES = "despachoExternoManager.getAllSupervisores";

    /*****************************************************************************
     ** CobroPagoManager.
     ****************************************************************************/
    public static final String BO_COBRO_PAGO_MGR_GET_LIST = "cobroPagoManager.getList";
    public static final String BO_COBRO_PAGO_MGR_GET_LIST_BY_ASUNTO_ID = "cobroPagoManager.getListbyAsuntoId";
    public static final String BO_COBRO_PAGO_MGR_GET_INSTANCE = "cobroPagoManager.getInstance";
    public static final String BO_COBRO_PAGO_MGR_GET = "cobroPagoManager.get";
    public static final String BO_COBRO_PAGO_MGR_CREATE_OR_UPDATE = "cobroPagoManager.createOrUpdate";
    public static final String BO_COBRO_PAGO_MGR_GET_SUBTIPOS_COBROS_PAGOS_BY_TIPO = "cobroPagoManager.getSubtiposCobroPagoByTipo";
    public static final String BO_COBRO_PAGO_MGR_GET_PROCEDIMIENTOS_POR_ASUNTO = "cobroPagoManager.getProcedimientosPorAsunto";
    public static final String BO_COBRO_PAGO_MGR_DELETE = "cobroPagoManager.delete";

    /*****************************************************************************
     ** PlazoTareaExternaPlazaManager.
     ****************************************************************************/
    public static final String BO_PLAZO_TAREA_EXT_PLAZA_MGR_GET_BY_TIPO_TAREA_PLAZA_JUSZADO = "plazoTareaExternaPlazaManager.getByTipoTareaTipoPlazaTipoJuzgado";
    public static final String BO_PLAZO_TAREA_EXT_PLAZA_MGR_GET = "plazoTareaExternaPlazaManager.get";

    /*****************************************************************************
     ** ProcedimientoManager.
     ****************************************************************************/
    public static final String BO_ACTOR_MGR_GET_LIST = "actorManager.getList";
    public static final String BO_ACTOR_MGR_SAVE = "actorManager.save";

    /*****************************************************************************
     ** RecursoManager.
     ****************************************************************************/
    public static final String BO_RECURSO_GET = "recursoManager.get";
    public static final String BO_RECURSO_GET_INSTANCE = "recursoManager.getInstance";
    public static final String BO_RECURSO_CREATE_OR_UPDATE = "recursoManager.createOrUpdate";
	
}
