package es.capgemini.pfs.comun;

/**
 * Constantes para los business operations
 * relacionadas con clase de uso comun.
 * @author Andrés Esteban
 *
 */
public final class ComunBusinessOperation {

    private ComunBusinessOperation() {
        // Para que no moleste el checkstyle
    }

    /*****************************************************************************
     ** DictionaryManager.
     ****************************************************************************/

    public static final String BO_DICTIONARY_GET_LIST = "dictionaryManager.getList";
    public static final String BO_DICTIONARY_GET_LIST_ORDERED = "dictionaryManager.getListOrdered";
    public static final String BO_DICTIONARY_GET_BY_CODE = "dictionaryManager.getByCode";
    public static final String BO_DICTIONARY_GET_BY_CODE_CLASSNAME = "dictionaryManager.getByCodeClassName";

    /*****************************************************************************
     ** TareaNotificacionManager.
     ****************************************************************************/
    public static final String BO_TAREA_MGR_BORRAR_TAREA_JUSTIFICACION_OBJETIVO = "tareaNotificacionManager.borrarTareaJustificacionObjetivo";
    public static final String BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_CLIENTE = "tareaNotificacionManager.borrarTareasAsociadasCliente";
    public static final String BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_EXPEDIENTE = "tareaNotificacionManager.borrarTareasAsociadasExpediente";
    public static final String BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_EXPEDIENTE_ID = "tareaNotificacionManager.borrarTareasAsociadasExpedienteId";
    public static final String BO_TAREA_MGR_CREAR_ALERTA = "tareaNotificacionManager.crearAlerta";
    public static final String BO_TAREA_MGR_GET = "tareaNotificacionManager.get";
    public static final String BO_TAREA_MGR_SAVE_OR_UPDATE = "tareaNotificacionManager.saveOrUpdate";
    public static final String BO_TAREA_MGR_CREAR_TAREA = "tareaNotificacionManager.crearTarea";
    public static final String BO_TAREA_MGR_CREAR_TAREA_COMUNICACION = "tareaNotificacionManager.crearTareaComunicacion";
    public static final String BO_TAREA_MGR_SAVE_COMUNICACION_BPM = "tareaNotificacionManager.saveComunicacionBPM";
    public static final String BO_TAREA_MGR_SAVE_OR_UPDATE_COMUNICACION_BPM = "tareaNotificacionManager.saveOrUpdateComunicacionBPM";
    public static final String BO_TAREA_MGR_CREAR_PRORROGA = "tareaNotificacionManager.crearProrroga";
    public static final String BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA = "tareaNotificacionManager.borrarNotificacionTarea";
    public static final String BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID = "tareaNotificacionManager.borrarNotificacionTareaById";
    public static final String BO_TAREA_MGR_CREAR_NOTIFICACION = "tareaNotificacionManager.crearNotificacion";
    public static final String BO_TAREA_MGR_BUSCAR_TAREA_SOLICITUD_CANCELADA_EXPEDIENTE = "tareaNotificacionManager.buscarTareaSolCancExp";
    public static final String BO_TAREA_MGR_BUSCAR_NOTIFICAR_SOLICITUD_CANCELACION_RECHAZADA = "tareaNotificacionManager.notificarSolCancelacRechazada";
    public static final String BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA = "tareaNotificacionManager.crearTareaConBPMConEspera";
    public static final String BO_TAREA_MGR_CREAR_TAREA_CON_BPM = "tareaNotificacionManager.crearTareaConBPM";
    public static final String BO_TAREA_MGR_CONTESTAR_PRORROGA = "tareaNotificacionManager.contestarProrroga";
    public static final String BO_TAREA_MGR_ACTUALIZAR_ASUNTOS_PROCEDIMIENTOS = "tareaNotificacionManager.actualizaAsuntosProcedimientos";
    public static final String BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE = "tareaNotificacionManager.getSubtipoTareaByCode";
    public static final String BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO = "tareaNotificacionManager.buscarPlazoTareasDefaultPorCodigo";
    public static final String BO_TAREA_MGR_BUSCAR_TAREAS_ASOCIADAS_A_CLIENTE = "tareaNotificacionManager.buscarTareasAsociadasACliente";
    public static final String BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE_CLIENTE_DEL_USUARIO = "tareaNotificacionManager.buscarTareasPendienteClienteDelUsuario";
    public static final String BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE = "tareaNotificacionManager.buscarTareasPendiente";
    public static final String BO_TAREA_MGR_DELETE = "tareaNotificacionManager.delete";
    public static final String BO_TAREA_MGR_GET_LIST_BY_PROC = "tareaNotificacionManager.getListByProcedimiento";
    public static final String BO_TAREA_MGR_GET_LIST_BY_ASUNTO = "tareaNotificacionManager.getListByAsunto";
    public static final String BO_TAREA_MGR_GET_LIST_BY_PROC_SUBTIPO = "tareaNotificacionManager.getListByProcedimientoSubtipo";
    public static final String BO_TAREA_MGR_GET_LIST_BY_PROC_LIST_SUBTIPO = "tareaNotificacionManager.getListByProcedimientoListSubtipo";
    public static final String BO_TAREA_MGR_GET_NOTIF_ALERTAS = "tareaNotificacionManager.getNotificacionesAlertas";
    public static final String BO_TAREA_MGR_BUSCAR_TAREA_ACTUAL_EXP = "tareaNotificacionManager.buscarTareaActualExpediente";
    public static final String BO_TAREA_MGR_BUSCAR_COM_CLIENTE = "tareaNotificacionManager.buscarComunicacionesCliente";
    public static final String BO_TAREA_MGR_BUSCAR_COM_EXP = "tareaNotificacionManager.buscarComunicacionesExpediente";
    public static final String BO_TAREA_MGR_BUSCAR_COM_ASU = "tareaNotificacionManager.buscarComunicacionesAsunto";
    public static final String BO_TAREA_MGR_BUSCAR_COMUNICACIONES = "tareaNotificacionManager.buscarComunicaciones";
    public static final String BO_TAREA_MGR_OBTENER_PRORROGA_EXP = "tareaNotificacionManager.obtenerProrrogaExpediente";
    public static final String BO_TAREA_MGR_OBTENER_SOL_CANCEL_EXP = "tareaNotificacionManager.obtenerSolicitudCancelacionExpediente";
    public static final String BO_TAREA_MGR_OBTENER_CANT_TAREAS_PENDIENTES = "tareaNotificacionManager.obtenerCantidadDeTareasPendientes";
    public static final String BO_TAREA_MGR_FINALIZAR_NOTIF = "tareaNotificacionManager.finalizarNotificacion";
    public static final String BO_TAREA_MGR_ELIMINAR_TAREAS_INVALIDAS_ELEVACION_EXP = "tareaNotificacionManager.eliminarTareasInvalidasElevacionExpediente";
    public static final String BO_TAREA_MGR_SOL_CANCELACION_EXP = "tareaNotificacionManager.solicitarCancelacionExpediente";
    public static final String BO_TAREA_MGR_PUEDE_RESPONDER = "tareaNotificacionManager.puedeResponder";
    public static final String BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL = "tareaNotificacionManager.buscarTareasParaExcel";
    public static final String BO_TAREA_MGR_PUEDE_MOSTRAR_VR = "tareaNotificacionManager.puedeMostrarVR";
    public static final String BO_TAREA_MGR_BUSCAR_SUBTIPO_TAREA_POR_CODIGO = "tareaNotificacionManager.buscarSubtipoTareaPorCodigo";

    /*****************************************************************************
     ** TareaExternaManager.
     ****************************************************************************/
    public static final String BO_TAREA_EXTERNA_MGR_GET = "tareaExternaManager.get";
    public static final String BO_TAREA_EXTERNA_MGR_VUELTA_ATRAS = "tareaExternaManager.vueltaAtras";
    public static final String BO_TAREA_EXTERNA_MGR_SAVE_OR_UPDATE = "tareaExternaManager.saveOrUpdate";
    public static final String BO_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA = "tareaExternaManager.crearTareaExterna";
    public static final String BO_TAREA_EXTERNA_MGR_DETENER = "tareaExternaManager.detener";
    public static final String BO_TAREA_EXTERNA_MGR_ACTIVAR = "tareaExternaManager.activar";
    public static final String BO_TAREA_EXTERNA_MGR_ACTIVAR_ALERTA = "tareaExternaManager.activarAlerta";
    public static final String BO_TAREA_EXTERNA_MGR_OBTENER_TAREA_POR_TOKEN = "tareaExternaManager.obtenerTareaPorToken";
    public static final String BO_TAREA_EXTERNA_MGR_GET_BY_ID_TAREA_NOTIF = "tareaExternaManager.getByIdTareaNotificacion";
    public static final String BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTO = "tareaExternaManager.obtenerTareasPorProcedimiento";
    public static final String BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_USUARIO_POR_PROCEDIMIENTO = "tareaExternaManager.obtenerTareasDeUsuarioPorProcedimiento";
    public static final String BO_TAREA_EXTERNA_MGR_OBTENER_VALORES_TAREA = "tareaExternaManager.obtenerValoresTarea";
    public static final String BO_TAREA_EXTERNA_MGR_GET_TARS_EXTERNA_BY_TAREA_PROC = "tareaExternaManager.getByIdTareaProcedimientoIdProcedimiento";
    public static final String BO_TAREA_EXTERNA_MGR_GET_ACTIVAS_BY_PROC = "tareaExternaManager.getActivasByIdProcedimiento";
    public static final String BO_TAREA_EXTERNA_MGR_BORRAR = "tareaExternaManager.borrar";

    /*****************************************************************************
     ** TareaProcedimientoManager.
     ****************************************************************************/
    public static final String BO_TAREA_PROC_MGR_GET = "tareaProcedimientoManager.get";
    public static final String BO_TAREA_PROC_MGR_GET_BY_COD_TIPO_PROC = "tareaProcedimientoManager.getByCodigoTipoProcedimiento";
    public static final String BO_TAREA_PROC_MGR_GET_BY_COD_TAREA_TIPO_PROC = "tareaProcedimientoManager.getByCodigoTareaIdTipoProcedimiento";

    /*****************************************************************************
     ** JBPMProcessManager.
     ****************************************************************************/
    public static final String BO_JBPM_MGR_ADD_VARIABLES_TO_PROCESS = "JBPMProcessManager.addVariablesToProcess";
    public static final String BO_JBPM_MGR_ACTIVAR_PROCESOS_BPM = "JBPMProcessManager.activarProcesosBPM";
    public static final String BO_JBPM_MGR_PARALIZAR_PROCESOS_BPM = "JBPMProcessManager.paralizarProcesosBPM";
    public static final String BO_JBPM_MGR_RECALCULAR_TIMER = "JBPMProcessManager.recalculaTimer";
    public static final String BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS = "JBPMProcessManager.getVariablesToProcess";
    public static final String BO_JBPM_MGR_CREATE_PROCESS = "JBPMProcessManager.crearNewProcess";
    public static final String BO_JBPM_MGR_GET_ACTUAL_NODE = "JBPMProcessManager.getActualNode";
    public static final String BO_JBPM_MGR_SIGNAL_PROCESS = "JBPMProcessManager.signalProcess";
    public static final String BO_JBPM_MGR_SIGNAL_PROCESS_OR_TOKENS = "JBPMProcessManager.signalProcessOrTokens";
    public static final String BO_JBPM_MGR_SIGNAL_TOKEN = "JBPMProcessManager.signalToken";
    public static final String BO_JBPM_MGR_DETERMINAR_BBDD = "JBPMProcessManager.determinarBBDD";
    public static final String BO_JBPM_MGR_CREA_O_RECALCULA_TIMER = "JBPMProcessManager.creaORecalculaTimer";
    public static final String BO_JBPM_MGR_DESTROY_PROCESS = "JBPMProcessManager.destroyProcess";
    public static final String BO_JBPM_MGR_GET_PROCESS_VARIABLES = "JBPMProcessManager.getProcessVariable";
    public static final String BO_JBPM_MGR_HAS_TRANSITION_TOKEN = "JBPMProcessManager.hasTransitionToken";
    public static final String BO_JBPM_MGR_OBTENER_FECHA_FIN_PROCESO = "JBPMProcessManager.obtenerFechaFinProceso";
    public static final String BO_JBPM_MGR_APLAZAR_PROCESOS_BPM = "JBPMProcessManager.aplazarProcesosBPM";
    public static final String BO_JBPM_MGR_FINALIZAR_PROC = "JBPMProcessManager.finalizarProcedimiento";
    public static final String BO_JBPM_MGR_EVALUA_SCRIPT = "JBPMProcessManager.evaluaScript";
    public static final String BO_JBPM_MGR_EVALUA_SCRIPT_POR_CONTEXTO  = "JBPMProcessManager.evaluaScriptPorContexto";
    public static final String BO_JBPM_MGR_EVALUA_SCRIPT_RECOBRO = "JBPMProcessManager.evaluaScriptRecobro";
    public static final String BO_JBPM_MGR_CREA_MAP_VALORES = "JBPMProcessManager.creaMapValores";
    public static final String BO_JBPM_MGR_CREA_PROCEDIMIENTO_HIJO = "JBPMProcessManager.creaProcedimientoHijo";
    public static final String BO_JBPM_MGR_LANZAR_BPM_ASOC_PROC = "JBPMProcessManager.lanzaBPMAsociadoAProcedimiento";
    public static final String BO_JBPM_MGR_GET_FIXE_BOOLEAN_VALUE = "JBPMProcessManager.getFixeBooleanValue";
    public static final String BO_JBPM_MGR_START_JOB_EXECUTOR = "JBPMProcessManager.startJobExecutor";
    public static final String BO_JBPM_MGR_STOP_JOB_EXECUTOR = "JBPMProcessManager.stopJobExecutor";
    public static final String BO_JBPM_MGR_GET_CONTEXTO_SCRIPT = "JBPMProcessManager.getContextoParaScript";

    /*****************************************************************************
     ** OficinaManager.
     ****************************************************************************/
    public static final String BO_OFICINA_MGR_GET = "oficinaManager.get";
    public static final String BO_OFICINA_MGR_BUSCAR_POR_CODIGO = "oficinaManager.buscarPorCodigo";
    public static final String BO_OFICINA_MGR_BUSCAR_POR_CODIGO_OFICINA = "oficinaManager.buscarPorCodigoOficina";

    /*****************************************************************************
     ** FavoritosManager.
     ****************************************************************************/
    public static final String BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD_ELIMINADA = "favoritosManager.eliminarFavoritosPorEntidadEliminada";
    public static final String BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD = "favoritosManager.eliminarFavoritosUsuarioPorEntidad";
    public static final String BO_FAVORITOS_MGR_SAVE_OR_UPDATE = "favoritosManager.saveOrUpdate";
    public static final String BO_FAVORITOS_MGR_MANTENER_FAVORITOS = "favoritosManager.mantenerFavoritos";

    /*****************************************************************************
     ** MapaGlobalOficinaManager.
     ****************************************************************************/
    public static final String BO_MAPA_GLOB_OFI_MGR_FIND_DD_CRITERIO_ANALISIS_BY_CODIGO = "mapaGlobalOficinaManager.findDDCriterioAnalisisByCodigo";
    public static final String BO_MAPA_GLOB_OFI_MGR_GET_CRITERIOS_ANALISIS = "mapaGlobalOficinaManager.getCriteriosAnalisis";
    public static final String BO_MAPA_GLOB_OFI_MGR_BUSCAR = "mapaGlobalOficinaManager.buscar";
    public static final String BO_MAPA_GLOB_OFI_MGR_EXPORTAR_A_CSV = "mapaGlobalOficinaManager.exportarACsv";
    public static final String BO_MAPA_GLOB_OFI_MGR_CONTAR_REGISTROS_POR_FASE = "mapaGlobalOficinaManager.contarRegistrosPorFase";
}