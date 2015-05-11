package es.capgemini.pfs.comun;

/**
 * Constantes para los business operations
 * relacionadas con clase de uso comun.
 * @author Andrés Esteban
 *
 */
public final class ComunConstantes {

    private ComunConstantes() {
        // Para que no moleste el checkstyle
    }

    /*****************************************************************************
     ** TareaNotificacionManager.
     ****************************************************************************/
    public static final String BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_CLIENTE = "tareaNotificacionManager.borrarTareasAsociadasCliente";
    public static final String BO_TAREA_MGR_GET = "tareaNotificacionManager.get";
    public static final String BO_TAREA_MGR_SAVE_OR_UPDATE = "tareaNotificacionManager.saveOrUpdate";
    public static final String BO_TAREA_MGR_CREAR_TAREA = "tareaNotificacionManager.crearTarea";

    /*****************************************************************************
     ** JBPMProcessManager.
     ****************************************************************************/
    public static final String BO_JBPM_MGR_DESTROY_PROCESS = "JBPMProcessManager.destroyProcess";
    public static final String BO_JBPM_MGR_RECALCULAR_TIMER = "JBPMProcessManager.recalculaTimer";
    public static final String BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS = "JBPMProcessManager.getVariablesToProcess";
    public static final String BO_JBPM_MGR_CREATE_PROCESS = "JBPMProcessManager.crearNewProcess";
    public static final String BO_JBPM_MGR_GET_ACTUAL_NODE = "JBPMProcessManager.getActualNode";
    public static final String BO_JBPM_MGR_SIGNAL_PROCESS = "JBPMProcessManager.signalProcess";
    public static final String BO_JBPM_MGR_DETERMINAR_BBDD = "JBPMProcessManager.determinarBBDD";
    public static final String BO_JBPM_MGR_CREA_O_RECALCULA_TIMER = "JBPMProcessManager.creaORecalculaTimer";

    /*****************************************************************************
     ** OficinaManager.
     ****************************************************************************/
    public static final String BO_OFICINA_MGR_GET = "oficinaManager.get";

    /*****************************************************************************
     ** FavoritosManager.
     ****************************************************************************/
    public static final String BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD_ELIMINADA = "favoritosManager.eliminarFavoritosPorEntidadEliminada";

    /*****************************************************************************
     ** PoliticaManager.
     ****************************************************************************/
    public static final String BO_POLITICA_MGR_INICIALIZAR_POLITICAS_EXPEDIENTE = "politicaManager.inicializaPoliticasExpediente";
    public static final String BO_POLITICA_MGR_MARCAR_POLITICAS_VIGENTES = "politicaManager.marcaPoliticasVigentes";
    public static final String BO_POLITICA_MGR_GET_POLITICA_PROPUESTA_EXPEDIENTE_PERSONA_ESTADO_ITINERARIO = "politicaManager.getPoliticaPropuestaExpedientePersonaEstadoItinerario";
    public static final String BO_POLITICA_MGR_BUSCAR_ULTIMA_POLITICA = "politicaManager.buscarUltimaPolitica";
    public static final String BO_POLITICA_MGR_BUSCAR_POLITICA_VIGENTE = "politicaManager.buscarUltimaPolitica";

}
