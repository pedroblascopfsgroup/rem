package es.capgemini.pfs.primaria;

/**
 * Constantes para los business operations
 * relacionadas con Persona, Cliente, Contrato, Antecedente, Titulo.
 * @author Andrés Esteban
 *
 */
public final class PrimariaBusinessOperation {

    private PrimariaBusinessOperation() {
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
    public static final String BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO = "personaManager.obtenerCantidadDeVencidosUsuario";
    public static final String BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO = "personaManager.obtenerCantidadDeSeguimientoSistematicoUsuario";
    public static final String BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO = "personaManager.obtenerCantidadDeSeguimientoSintomaticoUsuario";
    public static final String BO_PER_MGR_SAVE_OR_UPDATE = "personaManager.saveOrUpdate";
    public static final String BO_PER_MGR_UPDATE_SOLVENCIA = "personaManager.updateSolvencia";
    public static final String BO_PER_MGR_UPDATE_UMBRAL = "personaManager.updateUmbral";
    public static final String BO_PER_MGR_UPLOAD = "personaManager.upload";
    public static final String BO_PER_MGR_OBTENER_CONTRATOS_PARA_FUTUROS_CLIENTES = "personaManager.obtenerContratosParaFuturoCliente";
    public static final String BO_PER_MGR_OBTENER_NUMERO_CONTRATOS_PARA_FUTUROS_CLIENTES = "personaManager.obtenerNumeroContratosParaFuturoCliente";
    public static final String BO_PER_MGR_OBTENER_CONTRATOS_GENERACION_EXP_MANUAL = "personaManager.obtenerContratosGeneracionExpManual";
    public static final String BO_PER_MGR_OBTENER_NUM_CONTRATOS_GENERACION_EXP_MANUAL = "personaManager.obtenerNumContratosGeneracionExpManual";
    public static final String BO_PER_MGR_GET_BIENES = "personaManager.getBienes";
    public static final String BO_PER_MGR_GET_TIPOS_PERSONAS = "personaManager.getTiposPersonas";
    public static final String BO_PER_MGR_SET_FILE_MANAGER = "personaManager.setFileManager";
    public static final String BO_PER_MGR_OBTENER_ZONA_PERSONA = "personaManager.getZonaPersona";
    public static final String BO_CNT_MGR_CONTADOR_REINCIDENCIAS = "contratoManager.contadorReincidencias";
    
    /*****************************************************************************
     ** ClienteManager.
     ****************************************************************************/

    public static final String BO_CLI_MGR_ASIGNAR_ARQUETIPO = "clienteManager.asginarArquetipo";
    public static final String BO_CLI_MGR_BUSCAR_CLIENTES_POR_CONTRATO = "clienteManager.buscarClientesPorContrato";
    public static final String BO_CLI_MGR_BUSCAR_CLIENTES_TITULARE_POR_CONTRATO = "clienteManager.buscarClientesTitularesPorContrato";
    public static final String BO_CLI_MGR_CAMBIAR_ESTADO_ITINERARIO_CLIENTE = "clienteManager.cambiarEstadoItinerarioCliente";
    public static final String BO_CLI_MGR_CREAR_CLIENTE = "clienteManager.crearCliente";
    public static final String BO_CLI_MGR_CREAR_CLIENTE_W_ESTADO = "clienteManager.crearClienteWestado";
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
    public static final String BO_CLI_MGR_SAVE = "clienteManager.save";
    public static final String BO_CLI_MGR_SAVE_OR_UPDATE = "clienteManager.saveOrUpdate";
    public static final String BO_CLI_MGR_TIENE_CONTRATOS_CLIENTE = "clienteManager.tieneContratosParaGenerarExpediente";
    public static final String BO_CLI_MGR_TIENE_CONTRATOS_ACTIVOS = "clienteManager.tieneContractosActivos";
    public static final String BO_CLI_MGR_TIENE_CONTRATOS_LIBRES = "clienteManager.tieneContratosLibres";

    /*****************************************************************************
     ** ContratoManager.
     ****************************************************************************/

    public static final String BO_CNT_MGR_BUSCAR_CONTRATOS = "contratoManager.buscarContratos";
    public static final String BO_CNT_MGR_BUSCAR_CONTRATOS_CLIENTE = "contratoManager.buscarContratosCliente";
    public static final String BO_CNT_MGR_BUSCAR_CONTRATOS_EXPEDIENTE = "contratoManager.buscarContratosExpediente";
    public static final String BO_CNT_MGR_DELETE_ADJUNTO = "contratoManager.deleteAdjunto";
    public static final String BO_CNT_MGR_DOWNLOAD_ADJUNTO = "contratoManager.downloadAdjunto";
    public static final String BO_CNT_MGR_ELIMINAR_PROCEDIMIENTO_POR_CANCELACION = "contratoManager.eliminarProcedimientoPorCancelacion";
    public static final String BO_CNT_MGR_EXPORT_CONTRATOS = "contratoManager.exportContratos";
    public static final String BO_CNT_MGR_FIND_CONTRATO = "contratoManager.findContrato";
    public static final String BO_CNT_MGR_GET = "contratoManager.get";
    public static final String BO_CNT_MGR_GET_ASUNTOS_CONTRATO = "contratoManager.getAsuntosContrato";
    public static final String BO_CNT_MGR_GET_EXPDIENTES_HISTORICOS_CONTRATO = "contratoManager.getExpedientesHistoricosContrato";
    public static final String BO_CNT_MGR_GET_CONTRATOS_EXPDIENTES_HISTORICOS_CONTRATO = "contratoManager.getContratosExpedientesHistoricosContrato";
    public static final String BO_CNT_MGR_GET_TITULOS_CNT_PAGINADO = "contratoManager.getTitulosContratoPaginado";
    public static final String BO_CNT_MGR_GET_ULTIMA_FECHA_CARGA = "contratoManager.getUltimaFechaCarga";
    public static final String BO_CNT_MGR_MARCAR_SIN_ACTUACION = "contratoManager.marcarSinActuacion";
    public static final String BO_CNT_MGR_PERSONAS_DE_LOS_CONTRATOS = "contratoManager.personasDeLosContratos";
    public static final String BO_CNT_MGR_SUPERAR_LIMITE_EXPORT = "contratoManager.superaLimiteExport";
    public static final String BO_CNT_MGR_MARCAR_UPLOAD = "contratoManager.upload";
    public static final String BO_CNT_MGR_OBTENER_CONTRATOS_GENERACION_EXPEDIENTE_MANUAL = "contratoManager.obtenerContratosGeneracionExpManual";
    public static final String BO_CNT_MGR_OBTENER_CONTRATOS_PERSONA_GENERACION_EXPEDIENTE_MANUAL = "contratoManager.obtenerContratosPersonaParaGeneracionExpManual";
    public static final String BO_CNT_MGR_OBTENER_NUMERO_CNT_GENERACION_EXPEDIENTE_MANUAL = "contratoManager.obtenerNumContratosGeneracionExpManual";
    public static final String BO_CNT_MGR_GET_CONTRATOS_BY_ID = "contratoManager.getContratosById";
    public static final String BO_CNT_MGR_SAVE_OR_UPDATE = "contratoManager.saveOrUpdate";
    public static final String BO_CNT_MGR_BUSCAR_CLIENTES_DE_CONTRATOS = "contratoManager.buscarClientesDeContratos";
    public static final String BO_CNT_MGR_UPLOAD = "contratoManager.upload";
    public static final String BO_CNT_MGR_GET_RECIBOS_DE_CONTRATO = "contratoManager.getRecibosContrato";
    public static final String BO_CNT_MGR_GET_DISPOSICIONES_DE_CONTRATO = "contratoManager.getDisposicionesContrato";
    public static final String BO_CNT_MGR_GET_EFECTOS_DE_CONTRATO = "contratoManager.getEfectosContrato";
    public static final String BO_CNT_MGR_GET_RIESGO = "riesgoOperacionalManager.obtenerRiesgoOperacionalContrato";
    public static final String BO_CNT_MGR_GET_VENCIDOS = "riesgoOperacionalManager.obtenerVencidosByCntId";

    /*****************************************************************************
     ** AntecedenteManager.
     ****************************************************************************/
    public static final String BO_ANTECEDENTE_MGR_GET = "antecedenteManager.get";
    public static final String BO_ANTECEDENTE_MGR_SAVE_OR_UPDATE = "antecedenteManager.saveOrUpdate";
    public static final String BO_ANTECEDENTE_MGR_SAVE_OR_UPDATE_DTO = "antecedenteManager.saveOrUpdateDto";
    public static final String BO_ANTECEDENTE_MGR_FIND_BY_PERSONA_ID = "antecedenteManager.findByPersonaId";

    /*****************************************************************************
     ** AntecedenteExternoManager.
     ****************************************************************************/
    public static final String BO_ANTECEDENTE_EXTERNO_MGR_UPDATE = "antecedenteExternoManager.update";
    public static final String BO_ANTECEDENTE_EXTERNO_MGR_GET_LIST = "antecedenteExternoManager.getList";
    public static final String BO_ANTECEDENTE_EXTERNO_MGR_GET = "antecedenteExternoManager.get";
    public static final String BO_ANTECEDENTE_EXTERNO_MGR_GET_ANTECEDENTE_EXTERNO_PERSONA = "antecedenteExternoManager.getAntecedenteExternoPersona";
    public static final String BO_ANTECEDENTE_EXTERNO_MGR_SAVE_OR_UPDATE = "antecedenteExternoManager.saveOrUpdate";
    public static final String BO_ANTECEDENTE_EXTERNO_MGR_SAVE = "antecedenteExternoManager.save";
    public static final String BO_ANTECEDENTE_EXTERNO_MGR_DELETE = "antecedenteExternoManager.delete";

    /*****************************************************************************
     ** TituloManager.
     ****************************************************************************/
    public static final String BO_TITULO_MGR_FIND_TITULO_BY_CONTRATO = "tituloManager.findTituloByContrato";
    public static final String BO_TITULO_MGR_FIND_TITULOS_BY_CONTRATO = "tituloManager.findTitulosByContrato";
    public static final String BO_TITULO_MGR_FIND_TITULOS_EXPEDIENTE = "tituloManager.findTitulosExpediente";
    public static final String BO_TITULO_MGR_GET_DTO = "tituloManager.getDto";
    public static final String BO_TITULO_MGR_SAVE_TITULO = "tituloManager.saveTitulo";
    public static final String BO_TITULO_MGR_SAVE_TITULO_DTO = "tituloManager.saveTituloDTO";
    public static final String BO_TITULO_MGR_FIND_TITULO_BY_CONTRATO_DTO = "tituloManager.findTituloByContratoDto";
    public static final String BO_TITULO_MGR_GET_TITULO = "tituloManager.getTitulo";
    public static final String BO_TITULO_MGR_DELETE_TITULO = "tituloManager.deleteTitulo";

    /*****************************************************************************
     ** SimulacionManager.
     ****************************************************************************/
    public static final String BO_SIMULACCION_MGR_SIMULAR = "simulacionManager.simular";

    /*****************************************************************************
     ** MetricaManager.
     ****************************************************************************/
    public static final String BO_METRICA_MGR_GET_METRICA = "metricaManager.getMetrica";
    public static final String BO_METRICA_MGR_CARGA_METRICA = "metricaManager.cargarMetrica";
    public static final String BO_METRICA_MGR_DESCARGA_METRICA = "metricaManager.descargarMetrica";
    public static final String BO_METRICA_MGR_ACTIVA_METRICA = "metricaManager.activarMetrica";
    public static final String BO_METRICA_MGR_BORRAR_METRICA_ACTIVA = "metricaManager.borrarMetricaActiva";
    public static final String BO_METRICA_MGR_GET_METRICAS_TIPOS_PERSONA = "metricaManager.getMetricasTiposPersona";
    public static final String BO_METRICA_MGR_GET_METRICAS_SEGMENTOS = "metricaManager.getMetricasSegmentos";

    /*****************************************************************************
     ** AlertaManager.
     ****************************************************************************/
    public static final String BO_ALERTA_MGR_GET_DTO_ALERTAS_ACTIVAS = "alertaManager.getDtoAlertasActivas";

    /*****************************************************************************
     ** SegmentoManager.
     ****************************************************************************/
    public static final String BO_SEGMENTO_MGR_GET_SEGMENTOS = "segmentoManager.getSegmentos";
    public static final String BO_SEGMENTO_MGR_GET_SEGMENTOS_BY_CODIGOS = "segmentoManager.getSegmentosByCodigos";

    /*****************************************************************************
     ** BienManager.
     ****************************************************************************/
    public static final String BO_BIEN_MGR_GET = "bienManager.get";
    public static final String BO_BIEN_MGR_GET_LIST = "bienManager.getList";
    public static final String BO_BIEN_MGR_GET_LIST_FULL = "bienManager.getListFull";
    public static final String BO_BIEN_MGR_SAVE_OR_UPDATE = "bienManager.saveOrUpdate";
    public static final String BO_BIEN_MGR_CREATE_OR_UPDATE = "bienManager.createOrUpdate";
    public static final String BO_BIEN_MGR_DELETE = "bienManager.delete";
    public static final String BO_BIEN_MGR_VERIFICAR_BIEN = "bienManager.verificarBien";

    /*****************************************************************************
     ** TipoProductoManager.
     ****************************************************************************/
    public static final String BO_TIPO_PRODUC_MGR_GET_TIPOS_PRODUCTOS = "tipoProductoManager.getTiposProducto";
    public static final String BO_TIPO_PRODUC_MGR_FIND_BY_CODIGO = "tipoProductoManager.findByCodigo";
    public static final String BO_TIPO_PRODUC_MGR_TIPOS_PRODUCTOS_BY_CODIGO = "tipoProductoManager.getTiposProductoByCodigos";

    /*****************************************************************************
     ** TipoProductoEntidadManager.
     ****************************************************************************/
    public static final String BO_TIPO_PRODUC_ENT_MGR_GET_TIPOS_PRODUCTOS = "tipoProductoEntidadManager.getTiposProductoEntidad";
    
    
    /*****************************************************************************
     ** TelecobroManager.
     ****************************************************************************/
    public static final String BO_TELECOBRO_MGR_GET_TAREA_TELECOBRO = "telecobroManager.getTareaTelecobro";
    public static final String BO_TELECOBRO_MGR_GET_TAREA_TELECOBRO_DECISION = "telecobroManager.getTareaTelecobroDecision";
    public static final String BO_TELECOBRO_MGR_GET_SUBTIPO_TAREA_TELECOBRO = "telecobroManager.getSubtipoTareaTelecobro";
    public static final String BO_TELECOBRO_MGR_GET_MOTIVOS_TELECOBRO = "tipoProductoManager.getMotivosExclusionTelecobro";
    public static final String BO_TELECOBRO_MGR_CREAR_SOLICITUD_EXCLUSION_TELECOBRO = "tipoProductoManager.crearSolicitudExclusionTelecobro";
    public static final String BO_TELECOBRO_MGR_ACEPTAR_SOL_EXCLUSION_TELECOBRO = "tipoProductoManager.aceptarSolicitudExclusionTelecobro";
    public static final String BO_TELECOBRO_MGR_RECHAZAR_SOL_EXCLUSION_TELECOBRO = "tipoProductoManager.rechazarSolicitudExclusionTelecobro";

    /*****************************************************************************
     ** PersonaGrupoManager.
     ****************************************************************************/
    public static final String BO_PERSONA_GRUPO_MGR_GET_PERSONA_GRUPO = "personaGrupoManager.getPersonasGrupo";

    /*****************************************************************************
     ** IngresoManager.
     ****************************************************************************/
    public static final String BO_INGRESO_MGR_GET_INGRESO = "ingresoManager.getIngreso";
    public static final String BO_INGRESO_MGR_SAVE_OR_UPDATE = "ingresoManager.saveOrUpdateIngreso";
    public static final String BO_INGRESO_MGR_CREATE_OR_UPDATE = "ingresoManager.createOrUpdate";
    public static final String BO_INGRESO_MGR_SAVE_INGRESO = "ingresoManager.saveIngreso";
    public static final String BO_INGRESO_MGR_DELETE_INGRESO = "ingresoManager.deleteIngreso";
    public static final String BO_INGRESO_MGR_GET_TIPO_INGRESO_BY_ID = "ingresoManager.getTipoIngreso";
    public static final String BO_INGRESO_MGR_GET_TIPO_INGRESO_BY_CODIGO = "ingresoManager.getTipoIngresoByCodigo";
    public static final String BO_INGRESO_MGR_GET_LIST_TIPO_INGRESO = "ingresoManager.getListTipoIngreso";
    public static final String BO_INGRESO_MGR_SAVE_OR_UPDATE_TIPO_INGRESO = "ingresoManager.saveOrUpdateTipoIngreso";
    public static final String BO_INGRESO_MGR_DELETE_TIPO_INGRESO = "ingresoManager.deleteTipoIngreso";

    /*****************************************************************************
     ** CirbeManager.
     ****************************************************************************/
    public static final String BO_CIRBE_MGR_GET_FECHAS_EXTRAC_PERSONA = "cirbeManager.getFechasExtraccionPersona";
    public static final String BO_CIRBE_MGR_GET_FECHAS_ACTUALIZACION_PERSONA = "cirbeManager.getFechasActualizacionPersona";
    public static final String BO_CIRBE_MGR_GET_FECHAS_EXTRAC_PERSONA_DESDE = "cirbeManager.getFechasExtraccionPersonaDesde";
    public static final String BO_CIRBE_MGR_GET_FECHAS_EXTRAC_PERSONA_HASTA = "cirbeManager.getFechasExtraccionPersonaHasta";
    public static final String BO_CIRBE_MGR_GET_CIRBE_DATA = "cirbeManager.getCirbeData";
    public static final String BO_CIRBE_MGR_GET_FECHA_CIRBE = "cirbeManager.getFechaCirbe";
    public static final String BO_CIRBE_MGR_REFREZCAR_LISTAS = "cirbeManager.refrescarListas";
    public static final String BO_CIRBE_MGR_ACTUALIZAR_FECHAS_SELECCIONADAS = "cirbeManager.actualizarFechasSeleccionadas";

    /*****************************************************************************
     ** ScoringManager.
     ****************************************************************************/
    public static final String BO_SCORING_MGR_SIMULAR = "scoringManager.simular";
    public static final String BO_SCORING_MGR_SIMULAR_CHECK = "scoringManager.simularCheck";
    public static final String BO_SCORING_MGR_CALCULAR_INDICES = "scoringManager.calcularIndices";
    public static final String BO_SCORING_MGR_GET_SCORING_PERSONA = "scoringManager.getScoringPersona";
    public static final String BO_SCORING_MGR_GET_FECHAS_PUNTUACION_TOTAL = "scoringManager.getFechasPuntuacionTotal";
    public static final String BO_SCORING_MGR_GET_FECHAS_INICIO = "scoringManager.calcularParaFechasInicio";

    /*****************************************************************************
     ** ScoringManager.
     ****************************************************************************/
    public static final String BO_METRICA_CSV_MGR_CARGAR = "scoringManager.cargar";
    public static final String BO_METRICA_CSV_MGR_DESCARGAR = "scoringManager.descargar";

}
