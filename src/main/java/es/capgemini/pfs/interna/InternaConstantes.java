package es.capgemini.pfs.interna;

/**
 * Constantes para los business operations
 * relacionadas con todo lo referente a Expediente y Comite.
 * @author Andrés Esteban
 *
 */
public final class InternaConstantes {

    private InternaConstantes() {
        // Para que no moleste el checkstyle
    }

    /*****************************************************************************
     ** ComiteManager.
     ****************************************************************************/
    public static final String BO_COMITE_MGR_GET_WITH_SESSIONS = "comiteManager.getWithSessiones";
    public static final String BO_COMITE_MGR_CERRAR_SESION = "comiteManager.cerrarSesion";
    public static final String BO_COMITE_MGR_GET_DTO = "comiteManager.getDto";
    public static final String BO_COMITE_MGR_CREAR_SESION = "comiteManager.crearSesion";

    /*****************************************************************************
     ** DecisionComiteManager.
     ****************************************************************************/
    public static final String BO_DECISIONN_COMITE_MRG_SAVE = "decisionComiteManager.save";

    /*****************************************************************************
     ** SesionComiteManager.
     ****************************************************************************/
    public static final String BO_SESION_COMITE_MGR_GET_WITH_ASISTENTES = "sesionComiteManager.getWithAsistentes";

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
    public static final String BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_SEGUIMIENTO = "expedienteManager.crearExpedienteManualSeg";
    public static final String BO_EXP_MGR_DELETE_ADJUNTO = "expedienteManager.deleteAdjunto";
    public static final String BO_EXP_MGR_DESCONGELAR_EXPEDIENTE = "expedienteManager.desCongelarExpediente";
    public static final String BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_COMPLETAR = "expedienteManager.devolverExpedienteACompletar";
    public static final String BO_EXP_MGR_UPDATE_EXPEDIENTE_CONTRATO = "expedienteManager.updateExpedienteContrato";

    //FALTAN

}
