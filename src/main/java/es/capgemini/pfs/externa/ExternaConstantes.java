package es.capgemini.pfs.externa;

/**
 * Constantes para los business operations
 * relacionadas con todo lo referente a Asunto y Procedimientos.
 * @author Andrés Esteban
 *
 */
public final class ExternaConstantes {

    private ExternaConstantes() {
        // Para que no moleste el checkstyle
    }

    /*****************************************************************************
     ** AsuntoManager.
     ****************************************************************************/
    public static final String BO_ASU_MGR_SAVE_OR_UDPATE = "asuntoManager.saveOrUpdateAsunto";
    public static final String BO_ASU_MGR_GENERAR_TAREA_POR_CIERRE_DECISION = "asuntoManager.generarTareasPorCierreDecision";
    public static final String BO_ASU_MGR_CREAR_TAREA_ACEPTAR_ASUNTO = "asuntoManager.crearTareaAceptarAsunto";
    public static final String BO_ASU_MGR_MARCAR_PROCEDIMIENTOS_COMO_DECIDIDOS = "asuntoManager.marcarProcedimientosComoDecidos";
    public static final String BO_ASU_MGR_BORRAR_ASUNTO = "asuntoManager.borrarAsunto";
    public static final String BO_ASU_MGR_CREAR_ASUNTO = "asuntoManager.crearAsunto";

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
    public static final String BO_PRC_MGR_MARCAR_SIN_ACTUACION = "procedimientoManager.marcarSinActuacion";
    public static final String BO_PRC_MGR_SALVAR_PROCEDIMIMENTO = "procedimientoManager.salvarProcedimiento";
    public static final String BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO = "procedimientoManager.saveOrUpdateProcedimiento";
    public static final String BO_PRC_MGR_SAVE_PROCEDIMIENTO = "procedimientoManager.saveProcedimiento";
    public static final String BO_PRC_MGR_SAVE_RECOPILACION_PROCEDIMIENTO = "procedimientoManager.saveRecopilacionProcedimiento";
    public static final String BO_PRC_MGR_DELETE = "procedimientoManager.delete";

}
