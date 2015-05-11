package es.capgemini.pfs.primaria;

/**
 * Constantes para los business operations
 * relacionadas con Persona, Cliente, Contrato, Antecedente, Titulo.
 * @author Andrés Esteban
 *
 */
public final class PrimariaConstantes {

    private PrimariaConstantes() {
        // Para que no moleste el checkstyle
    }

    /*****************************************************************************
     ** PersonaManager.
     ****************************************************************************/

    public static final String BO_PER_MGR_CREAR_ANTECEDENTE_BASE = "personaManager.crearAntecedenteBase";
    public static final String BO_PER_MGR_DELETE = "personaManager.delete";
    public static final String BO_PER_MGR_DELETE_ADJUNTO = "personaManager.deleteAdjunto";
    public static final String BO_PER_MGR_DOWNLOAD_ADJUNTO = "personaManager.downloadAdjunto";
    public static final String BO_PER_MGR_EXPORT_CLIENTES = "personaManager.exportClientes";
    public static final String BO_PER_MGR_FIND_CLIENTES = "personaManager.findClientes";
    public static final String BO_PER_MGR_FIND_CLIENTES_PAGINATED = "personaManager.findClientesPaginated";
    public static final String BO_PER_MGR_GET = "personaManager.get";
    public static final String BO_PER_MGR_GET_BY_CODIGO = "personaManager.getByCodigo";
    public static final String BO_PER_MGR_GET_CLI_ACTIVO = "personaManager.getClienteActivo";
    public static final String BO_PER_MGR_GET_EXPEDIENTE_CON_CNT_PASE_TITULAR = "personaManager.getExpedienteConContratoPaseTitular";
    public static final String BO_PER_MGR_GET_ID_BY_CODIGO = "personaManager.getIdByCodigo";
    public static final String BO_PER_MGR_GET_INGRESOS = "personaManager.getIngresos";
    public static final String BO_PER_MGR_GET_LIST = "personaManager.getList";
    public static final String BO_PER_MGR_GET_LIST_FULL = "personaManager.getListFull";
    public static final String BO_PER_MGR_GET_WITH_CONTRATOS = "personaManager.getWithContratos";
    public static final String BO_PER_MGR_OBTENER_EXPEDIENTE_PROPUESTO_PERSONA = "personaManager.obtenerExpedientePropuestoPersona";
    public static final String BO_PER_MGR_OBTENER_ID_EXPEDIENTE_PROPUESTO_PERSONA = "personaManager.obtenerIdExpedientePropuestoPersona";
    public static final String BO_PER_MGR_SAVE_OR_UPDATE = "personaManager.saveOrUpdate";
    public static final String BO_PER_MGR_UPDATE_SOLVENCIA = "personaManager.updateSolvencia";
    public static final String BO_PER_MGR_UPDATE_UMBRAL = "personaManager.updateUmbral";
    public static final String BO_PER_MGR_UPLOAD = "personaManager.upload";
    public static final String BO_PER_MGR_OBTENER_CONTRATOS_PARA_FUTUROS_CLIENTES = "personaManager.obtenerContratosParaFuturoCliente";

    /*****************************************************************************
     ** ClienteManager.
     ****************************************************************************/

    public static final String BO_CLI_MGR_ASIGNAR_ARQUETIPO = "clienteManager.asginarArquetipo";
    public static final String BO_CLI_MGR_BUSCAR_CLIENTES_POR_CONTRATO = "clienteManager.buscarClientesPorContrato";
    public static final String BO_CLI_MGR_BUSCAR_CLIENTES_TITULARE_POR_CONTRATO = "clienteManager.buscarClientesTitularesPorContrato";
    public static final String BO_CLI_MGR_CAMBIAR_ESTADO_ITINERARIO_CLIENTE = "clienteManager.cambiarEstadoItinerarioCliente";
    public static final String BO_CLI_MGR_CREAR_CLIENTE = "clienteManager.crearCliente";
    public static final String BO_CLI_MGR_ELIMINAR_CLIENTE = "clienteManager.eliminarCliente";
    public static final String BO_CLI_MGR_ELIMINAR_CLI_Y_BPM = "clienteManager.eliminarClienteyBPM";
    public static final String BO_CLI_MGR_FIND_BY_NAME_CLIENTES = "clienteManager.findByNameClientes";
    public static final String BO_CLI_MGR_FIND_CLIENTES = "clienteManager.findClientes";
    public static final String BO_CLI_MGR_FIND_CLIENTES_PAGINATED = "clienteManager.findClientesPaginated";
    public static final String BO_CLI_MGR_GET = "clienteManager.get";
    public static final String BO_CLI_MGR_GET_WITH_CONTRATOS = "clienteManager.getWithContratos";
    public static final String BO_CLI_MGR_GET_WITH_ESTADOS = "clienteManager.getWithEstado";
    public static final String BO_CLI_MGR_RECALCULAR_TIMER_GESTION_VENCIDOS = "clienteManager.recalcularTimersGestionVencidos";
    public static final String BO_CLI_MGR_FIND_CLIENTE_POR_CONTRATO_PASE_ID = "clienteManager.findClienteByContratoPaseId";

    /*****************************************************************************
     ** ContratoManager.
     ****************************************************************************/

    public static final String BO_CNT_MGR_BUSCAR_CONTRATOS = "contratoManager.buscarContratos";
    public static final String BO_CNT_MGR_BUSCAR_CONTRATOS_CLIENTE = "contratoManager.buscarContratosCliente";
    public static final String BO_CNT_MGR_BUSCAR_CONTRATOS_EXPEDIENTE = "contratoManager.buscarContratosExpediente";
    public static final String BO_CNT_MGR_CONTRATOS_DEL_EXPEDIENTE_PARA_TITULOS = "contratoManager.contratosDelExpedienteParaTitulos";
    public static final String BO_CNT_MGR_DELETE_ADJUNTO = "contratoManager.deleteAdjunto";
    public static final String BO_CNT_MGR_DOWNLOAD_ADJUNTO = "contratoManager.downloadAdjunto";
    public static final String BO_CNT_MGR_ELIMINAR_PROCEDIMIENTO_POR_CANCELACION = "contratoManager.eliminarProcedimientoPorCancelacion";
    public static final String BO_CNT_MGR_EXPORT_CONTRATOS = "contratoManager.exportContratos";
    public static final String BO_CNT_MGR_FIND_CONTRATO = "contratoManager.findContrato";
    public static final String BO_CNT_MGR_GET = "contratoManager.get";
    public static final String BO_CNT_MGR_GET_ASUNTOS_CONTRATO = "contratoManager.getAsuntosContrato";
    public static final String BO_CNT_MGR_GET_EXPDIENTES_HISTORICOS_CONTRATO = "contratoManager.getExpedientesHistoricosContrato";
    public static final String BO_CNT_MGR_GET_TITULOS_CNT_PAGINADO = "contratoManager.getTitulosContratoPaginado";
    public static final String BO_CNT_MGR_GET_ULTIMA_FECHA_CARGA = "contratoManager.getUltimaFechaCarga";
    public static final String BO_CNT_MGR_MARCAR_SIN_ACTUACION = "contratoManager.marcarSinActuacion";
    public static final String BO_CNT_MGR_PERSONAS_DE_LOS_CONTRATOS = "contratoManager.personasDeLosContratos";
    public static final String BO_CNT_MGR_SUPERAR_LIMITE_EXPORT = "contratoManager.superaLimiteExport";
    public static final String BO_CNT_MGR_MARCAR_UPLOAD = "contratoManager.upload";
    public static final String BO_CNT_MGR_OBTENER_CONTRATOS_GENERACION_EXPEDIENTE_MANUAL = "contratoManager.obtenerContratosGeneracionExpManual";
    public static final String BO_CNT_MGR_OBTENER_NUMERO_CNT_GENERACION_EXPEDIENTE_MANUAL = "contratoManager.obtenerNumContratosGeneracionExpManual";
    public static final String BO_CNT_MGR_GET_CONTRATOS_BY_ID = "contratoManager.getContratosById";

    /*****************************************************************************
     ** AntecedenteManager.
     ****************************************************************************/

    public static final String BO_ANTECEDENTE_MGR_GET = "antecedenteManager.get";
    public static final String BO_ANTECEDENTE_MGR_SAVE = "antecedenteManager.save";
    public static final String BO_ANTECEDENTE_MGR_SAVE_OR_UPDATE = "antecedenteManager.saveOrUpdate";

    /*****************************************************************************
     ** TituloManager.
     ****************************************************************************/
    public static final String BO_TITULO_MGR_FIND_TITULO_BY_CONTRATO = "antecedenteManager.findTitulobyContrato";
}
