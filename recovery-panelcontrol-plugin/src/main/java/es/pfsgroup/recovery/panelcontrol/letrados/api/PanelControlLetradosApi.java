package es.pfsgroup.recovery.panelcontrol.letrados.api;

import java.util.List;
import java.util.Map;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoCampanya;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoCartera;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoColumnas;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoDetallePanelControlLetrados;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoLetrado;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoLote;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlFiltros;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlLetrados;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.PCDtoQuery;
import es.pfsgroup.recovery.panelcontrol.letrados.manager.model.DDRangoImportePanelControl;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.nivel.model.PCNivel;

public interface PanelControlLetradosApi<DtoDetallePanelControlFiltros> {
	public static final String PANEL_CONTROL_LETRADOS_GET_NIVELES = "plugin.letrados.panelControl.getNiveles";
	public static final String PANEL_CONTROL_LETRADOS_GET_DATOS_POR_JERARQUIA = "plugin.letrados.panelcontrol.getDatosPorJerarquia";
	public static final String PANEL_CONTROL_LETRADOS_GET_DATOS_POR_JERARQUIA_CONF = "plugin.letrados.panelcontrol.getDatosPorJerarquiaV2";
	public static final String GET_ASUNTOS = "plugin.letrados.panelControl.getAsuntos";
	public static final String GET_TAREAS_PANEL_CONTROL = "plugin.letrados.panelControl.getTareasPanelControl";
	public static final String GET_FECHA_REFRESCO = "plugin.letrados.panelcontrol.getFechaRefresco";
	public static final String GET_COLUMNS = "plugin.letrados.panelcontrol.getColumns";
	public static final String INS_MGR_LISTAPROCEDIMIENTOS = "plugin.letrados.panelControl.listaProcedimientos";
	public static final String PTE_MGR_BUSCATAREAS="plugin.letrados.panelControl.buscaTareasProcedimiento";
	public static final String PANEL_CONTROL_LETRADOS_GET_CAMPANYAS = "plugin.letrados.panelControl.buscaCampanyas";
	public static final String PANEL_CONTROL_LETRADOS_GET_LETRADOGESTOR = "plugin.letrados.panelControl.buscaLetradoGestor";
	public static final String PANEL_CONTROL_LETRADOS_GET_CARTERAS="plugin.letrados.panelControl.buscaCarteras";
	public static final String PANEL_CONTROL_LETRADOS_GET_LOTES="plugin.letrados.panelControl.buscaLotesPorCartera";
	public static final String PANEL_CONTROL_LETRADOS_GETLIST_LOTES="plugin.letrados.panelControl.buscaLotes";
	public static final String EXPEDIENTES_EXCEL = "plugin.letrados.panelControl.listadoExpedientesExcel";
	public static final String NUMERO_COLUMNAS_EXCEL = "plugin.letrados.panelControl.getNumeroColumnas";
	public static final String TITULO_COLUMNAS_EXCEL = "plugin.letrados.panelControl.getTituloColumnas";
	public static final String TAREAS_EXCEL = "plugin.letrados.panelControl.listadoTareasExcel";
	public static final String INS_MGR_LISTATIPOSACTUACION = "plugin.letrados.panelControl.listaTiposActuacion";
	public static final String PANEL_CONTROL_LETRADOS_LISTARANGOIMPORTES = "plugin.letrados.panelControl.listaRangoImportes";
	public static final String PANEL_CONTROL_LETRADOS_PLAZAS_BYDESC="plugin.letrados.panelControl.findTipoPlazaByDesc";
	public static final String PANEL_CONTROL_LETRADOS_PAGINA_PLAZA="plugin.letrados.panelControl.findPaginaPlazaByCod";
	public static final String PANEL_CONTROL_LETRADOS_LISTAJUZGADOSPLAZA="plugin.letrados.panelControl.buscaJuzgadosPlaza";
	public static final String PANEL_CONTROL_LETRADOS_PROCEDIMIENTOSIMPLICADOS = "plugin.letrados.panelControl.getProcedimientosImplicados";
	
	@BusinessOperationDefinition(INS_MGR_LISTAPROCEDIMIENTOS)
	//public List<TipoProcedimiento> listaProcedimientos(String codigo);
	public List<TipoProcedimiento> listaProcedimientos();
	
	@BusinessOperationDefinition (INS_MGR_LISTATIPOSACTUACION)
	public List<DDTipoActuacion> listaTiposActuacion ();
	
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_GET_NIVELES)
	public List<PCNivel> getDDNiveles();

	@BusinessOperationDefinition(GET_ASUNTOS)
	public Page getAsuntos(DtoDetallePanelControlLetrados dto);
	
	@BusinessOperationDefinition(GET_TAREAS_PANEL_CONTROL)
	public Page generaDatosStore(DtoDetallePanelControlLetrados dto);
	/**
	 * Obtiene la última fecha de regresco de la vista materializada resumen
	 * @return String que indica la fecha en fomrato dd/mm/yyyy hh:mm
	 */
	@BusinessOperationDefinition(GET_FECHA_REFRESCO)
	public String getFechaRefresco();

	/**
	 * Obtiene las columnas para el store de grid dinámico de tareas/asuntos
	 * @param tipo
	 * @return
	 */
	@BusinessOperationDefinition(GET_COLUMNS)
	public List<DtoColumnas> getColumns(String tipo);

	/**
	 * @param id del procedimiento
	 * @return lista de todas las tareas que pertenecen a ese procedimiento
	 */
	@BusinessOperationDefinition(PTE_MGR_BUSCATAREAS)
	public List<TareaProcedimiento> buscaTareas (String codigo);

	/**
	 * Obtiene todas las campanyas
	 * @return lista campanyas
	 */
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_GET_CAMPANYAS)
	public List<DtoCampanya> getDDCampanyas();
	
	/**
	 * Obtiene las diferentes carteras de la vista del panel de control
	 * @return
	 */
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_GET_CARTERAS)
	public List<DtoCartera> getCarteras();
	
	/**
	 * 
	 * @param cartera
	 * @return Obtiene los diferentes lotes para una cartera dada que existen en la vista del panel de control
	 */
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_GET_LOTES)
	public List<DtoLote> getLotesPorCartera(String cartera);

	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_GET_DATOS_POR_JERARQUIA)
	public List<DtoPanelControlLetrados> getDatosPorJerarquia(DtoPanelControlFiltros dto);
	
	
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_GET_DATOS_POR_JERARQUIA_CONF)
	public Page getDatosPorJerarquiaV2(DtoPanelControlFiltros dto);
	
	
	
	
	/**
	 * Obtiene todos los letrados
	 * @return lista letrados
	 */
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_GET_LETRADOGESTOR)
	public List<DtoLetrado> getDDLetradoGestor();

	/**
	 * Obtiene todos los letrados
	 * @return lista letrados
	 */
	@BusinessOperationDefinition(EXPEDIENTES_EXCEL)
	public List<Map<String, Object>> getAsuntosListadoExcel(DtoDetallePanelControlLetrados dto);
	
	@BusinessOperationDefinition(NUMERO_COLUMNAS_EXCEL)
	public int getNumeroColumnas(String tipo);

	@BusinessOperationDefinition(TITULO_COLUMNAS_EXCEL)
	public List<String> getTituloColumnas(String tipo);

	@BusinessOperationDefinition(TAREAS_EXCEL)
	public List<Map<String, Object>> getTareasListadoExcel(DtoDetallePanelControlLetrados dto);

	/**
	 * Obtiene los rango de los importes para rellenar el combo del panel de control
	 * @return lista de importes
	 */
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_LISTARANGOIMPORTES)
	List<DDRangoImportePanelControl> listaRangoImportes();
	
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_PLAZAS_BYDESC)
	Page buscarPorDescripcion(PCDtoQuery dto);
	
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_PAGINA_PLAZA)
	Integer findPaginaPlazaByCod(String codigo);
	
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_LISTAJUZGADOSPLAZA)
	List<TipoJuzgado> buscaJuzgadosPlaza(String codigo);
	
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_PROCEDIMIENTOSIMPLICADOS)
	List<TipoProcedimiento> getProcedimientosImplicados();
	
	@BusinessOperationDefinition(PANEL_CONTROL_LETRADOS_GETLIST_LOTES)
	List<DtoLote> getListLotes();
	


}
