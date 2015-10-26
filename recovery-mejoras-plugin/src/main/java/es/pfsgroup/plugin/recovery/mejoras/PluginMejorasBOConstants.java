package es.pfsgroup.plugin.recovery.mejoras;

public class PluginMejorasBOConstants {
	
	public static final String MEJ_BO_GUARDAR_FICHA_ACEPTACION = "MEJAsuntosManager.guardarFichaAceptacion";

	public static final String MEJ_BO_PUEDE_FINALIZAR_ASUNTO = "MEJAsuntosManager.puedeFinalizarAsunto";

	public static final String MEJ_MGR_CLIENTES_TABS_FAST = "tabs.cliente.fast";
	
	public static final String GET_LIST_TIPO_CONCURSO = "plugin.recovery.mejoras.getListTipoConcurso";
	
	public static final String MEJ_BUSQUEDA_CLIENTES = "plugin.mejoras.findClientesPage";
	
	public static final String MEJ_BUSQUEDA_CLIENTES_DELEGATOR = "plugin.mejoras.findClientesPageDelegator";

	public static final String MEJ_BUSQUEDA_CLIENTES_CARTERIZADO = "plugin.mejoras.findClientesPageCarterizado";
	
	/**
	 * @param id del adjunto del asunto
	 * @return devuelve un objeto de tipo AdjuntoAsunto cuyo id coincide con el par�metro que se le pasa a la entrada
	 * 
	 */
	public static final String MEJ_BO_GET_ADJUNTOASUNTO="plugin.mejoras.devolucionAsunto.getAdjuntoAsuntoById";
	
	/**
	 * @param dto de edici�n de adjuntos
	 * guarda la descripci�n del adjunto del asunto
	 */
	public static final String MEJ_BO_GUARDA_ADJUNTOASUNTO="MEJAsuntosManager.guardaAdjuntoAsunto";
	/**
	 * @param id del objeto AdjuntoExpediente
	 * @return devuelve un objeto de tipo AdjuntoExpediente cuyo id coincide con el par�metro que se le pasa a
	 * la entrada
	 */
	public static final String MEJ_BO_GET_ADJUNTO_EXPEDIENTE = "plugin.mejoras.devolucionAsunto.getAdjuntoExpedienteById";
	
	/**
	 * @param id del objeto AdjuntoContrato
	 * @return devuelve el objeto de tipo AdjuntoContrato que tiene esa id
	 */
	public static final String MEJ_BO_GET_ADJUNTO_CONTRATO= "plugin.mejoras.devolucionAsunto.getAdjuntoContratoById";
	
	/**
	 *  @param dto de edici�n de adjunto
	 * Edita la descripci�n del adjuntoContrato cuyo id se le pasa como par�metro en el dto
	 */
	public static final String MEJ_BO_GUARDA_ADJUNTO_CONTRATO="MEJAsuntosManager.guardaAdjuntoContrato";
	
	/**
	 * @param id del objeto AdjuntoPersona
	 * @return devuelve el objeto de tipo AdjuntoPersona que tiene esa id
	 */
	public static final String MEJ_BO_GET_ADJUNTO_PERSONA="plugin.mejoras.devolucionAsunto.getAdjuntoPersonaById";
	
	/**
	 * @param dto de edici�n de adjunto
	 *  Edita la descripci�n del adjuntoPersona cuyo id se le pasa como par�metro en el dto
	 */
	public static final String MEJ_BO_GUARDA_ADJUNTO_PERSONA="MEJAsuntosManager.guardaAdjuntoPersona";
	
	/**
	 * @param dto de edici�n de adjunto
	 * Edita la descripci�n del adjuntoExpediente cuyo id se le pasa como par�metro en el dto
	 */
	public static final String MEJ_BO_GUARDA_ADJUNTO_EXPEDIENTE ="MEJAsuntosManager.guardaAdjuntoExpediente";
	
	public static final String MEJ_BO_BUSCAR_ACTAS_COMITE = "MEJBusquedaActasComiteManager.buscarActasComites";


	/**
	 * busca gestores por descripcion y despacho
	 * @param dto de b�squeda de despachos
	 * @return lista paginada de gestorDespacho
	 */
	public static final String MEJ_BO_GESTOR_BY_DESC_Y_DESPACHO="MEJGestorDespachoManager.buscarPorDescYDespacho";
	
	/**
	 * devuelve la p�gina donde est� el gestor cuyo id coincide con el valor que se le pasa como par�metro
	 * @param id del gestorDespacho
	 * @return integer n�mero de la p�gina 
	 */
	public static final String MEJ_BO_PAGINA_GESTOR="MEJGestorDespachoManager.getPaginaGestor";
	
	
	/**
	 * devuelve true si el procedimiento est� paralizado
	 * @param id del procedimiento
	 */
	public static final String MEJ_BO_PROCEDIMIENTO_PARALIZADO="plugin.mejoras.procedimientoManager.procedimientoParalizado";
	
	public static final String MEJ_BO_ASUNTO_BUTTONS_LEFT="plugin.mejoras.web.asuntos.buttons.left";
	
	public static final String MEJ_BO_ASUNTO_BUTTONS_RIGHT="plugin.mejoras.web.asuntos.buttons.right";
	
	public static final String MEJ_BO_CLIENTE_BUTTONS_RIGHT="plugin.mejoras.web.clientes.consulta.buttons.right";
	
	public static final String MEJ_BO_CLIENTE_BUTTONS_LEFT="plugin.mejoras.web.clientes.consulta.buttons.left";
	
	public static final String MEJ_BO_EXPEDIENTE_BUTTONS_RIGHT="plugin.mejoras.web.expediente.buttons.right";
	
	public static final String MEJ_BO_EXPEDIENTE_BUTTONS_LEFT="plugin.mejoras.web.expediente.buttons.left";
	
	public static final String MEJ_BO_TAREAS_PTES_BUTTONS_RIGHT="plugin.mejoras.web.tareas.buttons.tareasPendientes.right";
	
	public static final String MEJ_BO_TAREAS_PTES_BUTTONS_LEFT="plugin.mejoras.web.tareas.buttons.tareasPendientes.left";
	
	public static final String MEJ_BO_PANEL_TAREAS_BUTTONS_RIGHT="plugin.mejoras.web.tareas.buttons.panelTareas.right";
	
	public static final String MEJ_BO_PANEL_TAREAS_BUTTONS_LEFT="plugin.mejoras.web.tareas.buttons.panelTareas.left";
	
	public static final String MEJ_BO_TAR_ESPERA_BUTTONS_RIGHT="plugin.mejoras.web.tareas.buttons.tareasEspera.right";
	
	public static final String MEJ_BO_TAR_ESPERA_BUTTONS_LEFT="plugin.mejoras.web.tareas.buttons.tareasEspera.left";
	
	public static final String MEJ_BO_NOTIFICACION_BUTTONS_RIGHT="plugin.mejoras.web.tareas.buttons.notificacion.right";
	
	public static final String MEJ_BO_NOTIFICACION_BUTTONS_LEFT="plugin.mejoras.web.tareas.buttons.notificacion.left";
	
	public static final String MEJ_BO_ALERTAS_BUTTONS_RIGHT="plugin.mejoras.web.tareas.buttons.alertas.right";
	
	public static final String MEJ_BO_ALERTAS_BUTTONS_LEFT="plugin.mejoras.web.tareas.buttons.alertas.left";
	
	public static final String MEJ_BO_ASUNTO_CONSULTA_BUTTONS_LEFT="plugin.mejoras.web.asuntos.consultaAsunto.buttons.left";
	
	public static final String MEJ_BO_ASUNTO_CONSULTA_BUTTONS_RIGHT="plugin.mejoras.web.asuntos.consultaAsunto.buttons.right";
	
	public static final String MEJ_BO_MAPA_GLOBAL_BUTTONS_LEFT="plugin.mejoras.web.analisis.mapaGlobal.buttons.left";
	
	public static final String MEJ_BO_MAPA_GLOBAL_BUTTONS_RIGHT="plugin.mejoras.web.analisis.mapaGlobal.buttons.right";
	
	public static final String MEJ_BO_ANALISIS_EXT_BUTTONS_LEFT="plugin.mejoras.web.analisisExterna.buttons.left";
	
	public static final String MEJ_BO_ANALISIS_EXT_BUTTONS_RIGHT="plugin.mejoras.web.analisisExterna.buttons.right";
	
	public static final String MEJ_BO_GENERAR_AUTOPRORROGA="plugin.mejoras.tareaNotificacion.generarAutoprorroga";

	public static final String MEJ_BO_LISTA_COMUNICACIONES_ASU = "plugin.mejoras.tareaNotificacion.listaComunicacionesAsunto";
	
	public static final String MEJ_BO_ASUNTO_BUTTONS_LEFT_FAST = "entidad.asunto.buttons.left.fast";
	
	public static final String MEJ_BO_ASUNTO_BUTTONS_RIGHT_FAST = "entidad.asunto.buttons.right.fast";
	
	public static final String MEJ_MGR_ASUNTO_TABS_FAST = "tabs.asunto.fast";

	public static final String MEJ_BO_CLIENTE_BUTTONS_LEFT_FAST = "entidad.cliente.buttons.left.fast";
	
	public static final String MEJ_BO_CLIENTE_BUTTONS_RIGHT_FAST = "entidad.cliente.buttons.right.fast";

	public static final String MEJ_MGR_CONTRATO_BUTTONS_RIGHT_FAST = "entidad.contrato.buttons.right.fast";
	
	public static final String MEJ_MGR_CONTRATO_BUTTONS_LEFT_FAST = "entidad.contrato.buttons.left.fast";
	
	public static final String MEJ_MGR_CONTRATO_TABS_FAST = "tabs.contrato.fast";
	
	public static final String MEJ_BO_EXPEDIENTE_BUTTONS_RIGHT_FAST="entidad.expediente.buttons.right.fast";
	
	public static final String MEJ_BO_EXPEDIENTE_BUTTONS_LEFT_FAST="entidad.expediente.buttons.left.fast";

	public static final String MEJ_MGR_EXPEDIENTE_TABS_FAST = "tabs.expediente.fast";

	public static final String MEJ_MGR_EXPEDIENTE_TABS_BUSQUEDA = "plugin.mejoras.web.expedientes.busqueda.tabs";
	
	public static final String MEJ_BO_PROCEDIMIENTO_BUTTONS_RIGHT_FAST="entidad.procedimiento.buttons.right.fast";
	
	public static final String MEJ_BO_PROCEDIMIENTO_BUTTONS_LEFT_FAST="entidad.procedimiento.buttons.left.fast";

	public static final String MEJ_MGR_PROCEDIMIENTO_TABS_FAST = "tabs.procedimiento.fast";
	
	public static final String MEJ_TIPO_PROCEDIMIENTO_BLOQUEADO = "P22";

	public static final String BO_PER_MGR_FIND_CLIENTES_EXCEL =  "plugin.mejoras.findClientesExcel";

	public static final String MEJ_BUSQUEDA_CLIENTES_EXCEL_DELEGATOR = "plugin.mejoras.findClientesExcelDelegator";

	public static final String BO_PER_MGR_FIND_CLIENTES_EXCEL_CARTERIZADO =  "plugin.mejoras.findClientesExcelCarterizado";
	
    /**
     * Excluye el contrato del expediente.
     * @param dto DtoExclusionContratoExpediente
     */
	public static final String MEJ_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE =  "plugin.mejoras.excluirContratosAlExpediente";
	

    /**
     * Incluye el contrato del expediente.
     * @param dto DtoInclusionExclusionContratoExpediente
     */
	public static final String MEJ_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE =  "plugin.mejoras.incluirContratosAlExpediente";

	public static final String BO_EVENTO_BORRAR_TAREA_ASUNTO = "plugin.mejoras.borrarTareaAsunto";
	
	public static final String MEJ_BO_PERMITE_PRORROGAS = "plugin.mejoras.tareaNotificacion.permiteProrrogas";

	public static final String BO_CNT_MGR_SUPERAR_LIMITE_EXPORT_CLIENTES = "plugin.mejoras.superaLimiteExport";

}
