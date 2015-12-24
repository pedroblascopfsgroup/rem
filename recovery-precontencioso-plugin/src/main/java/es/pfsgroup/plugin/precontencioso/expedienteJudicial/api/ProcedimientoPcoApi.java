package es.pfsgroup.plugin.precontencioso.expedienteJudicial.api;

import java.util.List;
import java.util.Map;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ActualizarProcedimientoPcoDtoInfo;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.ProcedimientoPcoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;


public interface ProcedimientoPcoApi {

	public static final String BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID = "plugin.precontencioso.getPrecontenciosoPorProcedimientoId";
	public static final String BO_PCO_COMPROBAR_FINALIZAR_PREPARACION_EXPEDIENTE = "plugin.precontencioso.comprobarFinalizarPreparacionExpedienteJudicialPorProcedimientoId";
	public static final String BO_PCO_FINALIZAR_PREPARACION_EXPEDIENTE_JUDICIAL_POR_PRC_ID = "plugin.precontencioso.finalizarPreparacionExpedienteJudicialPorProcedimientoId";
	public static final String BO_PCO_DEVOLVER_PREPARACION_POR_PRC_ID = "plugin.precontencioso.devolverPreparacionPorProcedimientoId";
	public static final String BO_PCO_ACTUALIZAR_PROCEDIMIENTO_Y_PCO = "plugin.precontencioso.actualizaProcedimientoPco";
	public static final String BO_PCO_CAMBIAR_ESTADO_EXPEDIENTE = "plugin.precontencioso.cambiarEstadoExpediete";
	public static final String BO_PCO_EXPEDIENTE_BY_PRC_ID = "plugin.precontencioso.getPCOByProcedimientoId";
	public static final String BO_PCO_EXPEDIENTE_UPDATE = "plugin.precontencioso.update";
	public static final String BO_PCO_INICIALIZAR = "plugin.precontencioso.inicializarPco";
	public static final String BO_PCO_CREAR_PROCEDIMIENTO_PCO = "plugin.precontencioso.crearProcedimientoPco";
	public static final String BO_PCO_EXPEDIENTE_COMPROBAR_EDICION_EXPEDIENTE = "plugin.precontencioso.isExpedienteEditable";
	public static final String BO_PCO_EXPEDIENTE_VISIBILIDAD_BOTONES_PCO = "plugin.precontencioso.getVisibilidadBotonesPrecontencioso";
	/**
	 * Obtiene el historico de estados de un procedimientoPCO mediante un id procedimiento.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	List<HistoricoEstadoProcedimientoDTO> getEstadosPorIdProcedimiento(Long idProcedimiento);

	/**
	 * Obtiene el procedimiento precontencioso por id procedimiento.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID)
	ProcedimientoPCODTO getPrecontenciosoPorProcedimientoId(Long idProcedimiento);

	@BusinessOperationDefinition(BO_PCO_COMPROBAR_FINALIZAR_PREPARACION_EXPEDIENTE)
	boolean comprobarFinalizarPreparacionExpedienteJudicialPorProcedimientoId(Long idProcedimiento);

	@BusinessOperationDefinition(BO_PCO_FINALIZAR_PREPARACION_EXPEDIENTE_JUDICIAL_POR_PRC_ID)
	boolean finalizarPreparacionExpedienteJudicialPorProcedimientoId(Long idProcedimiento);

	/**
	 * Únicamente los expedientes que se encuentren en estado “Preparado” podrán ser devueltos al estado “Preparación” a través de esta función.
	 * @param idProcedimiento
	 */
	@BusinessOperationDefinition(BO_PCO_DEVOLVER_PREPARACION_POR_PRC_ID)
	void devolverPreparacionPorProcedimientoId(Long idProcedimiento);

	/**
	 * Devuelve el numero de resultados que va a devolver la consulta con el filtro enviado por parametro
	 * @param filtro
	 * @return numero de resultados
	 */
	Integer countBusquedaPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de ProcedimientoPcoGridDTO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de ProcedimientoPcoGridDTO que cumplen dicho filtro.
	 */
	List<ProcedimientoPcoGridDTO> busquedaProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de SolicitudDocumentoPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de SolicitudDocumentoPCO que cumplen dicho filtro.
	 */
	List<ProcedimientoPcoGridDTO> busquedaSolicitudesDocumentoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de LiquidacionPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de LiquidacionPCO que cumplen dicho filtro.
	 */
	List<ProcedimientoPcoGridDTO> busquedaLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de EnvioBurofaxPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de EnvioBurofaxPCO que cumplen dicho filtro.
	 */
	List<ProcedimientoPcoGridDTO> busquedaBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);
	
	@BusinessOperationDefinition(BO_PCO_ACTUALIZAR_PROCEDIMIENTO_Y_PCO)
	void actualizaProcedimiento(ActualizarProcedimientoPcoDtoInfo dto);

    List<Nivel> getNiveles();

    /**
     * Cambia el estado del expediente incluyendo la entrada correspondiente en el histórico
     * @param idProc
     * @param codigoEstado
     */
	@BusinessOperationDefinition(BO_PCO_CAMBIAR_ESTADO_EXPEDIENTE)
	public void cambiarEstadoExpediente(Long idProc, String codigoEstado);
	
	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_BY_PRC_ID)
	public ProcedimientoPCO getPCOByProcedimientoId(Long idProc);
	
	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_UPDATE)
	public void update(ProcedimientoPCO pco);

	@BusinessOperationDefinition(BO_PCO_INICIALIZAR)
	void inicializarPrecontencioso(Procedimiento procedimiento);

	@BusinessOperationDefinition(BO_PCO_CREAR_PROCEDIMIENTO_PCO)
	ProcedimientoPCO crearProcedimientoPco(Procedimiento procedimiento, String codigoEstadoInicial);

	/**
	 * Genera un fichero excel con los campos que se muestran en las búsquedas de elementos judiciales
	 * 
	 * @param filter
	 * @return
	 */
	FileItem generarExcelExportacionElementos(
			FiltroBusquedaProcedimientoPcoDTO filter);
	
	/**
	 * Comprueba si el usuario conectado está asignado al asunto como preparador del expediente judicial, como supervisor del expediente judicial, 
	 * o pertenece a un grupo asignado como estos dos tipos de gestores
	 * @param idProcedimiento
	 * @return
	 */
	public boolean isExpedienteEditable(Long idProcedimiento);	

	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_VISIBILIDAD_BOTONES_PCO)
	public List<String> getVisibilidadBotonesDocumentosPrecontencioso(String seccion, boolean visible);

	boolean mostrarSegunCodigos(Long idProcedimiento, List<String> codigosTiposGestores);
	
}
