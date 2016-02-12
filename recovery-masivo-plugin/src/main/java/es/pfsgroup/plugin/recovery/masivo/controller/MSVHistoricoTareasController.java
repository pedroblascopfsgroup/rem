package es.pfsgroup.plugin.recovery.masivo.controller;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVCodigoPostalPlazaApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVHistoricoTareasApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistItemResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoTareaAsuntoDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoTareaDto;
import es.pfsgroup.plugin.recovery.masivo.factories.MSVCodigoPostalPlazaFactory;
import es.pfsgroup.plugin.recovery.mejoras.procuradores.MEJProcuradoresApi;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Controlador para mostrar el historico de tareas y resoluciones
 * 
 * @author Carlos
 * 
 */
@Controller
public class MSVHistoricoTareasController {
	
	public static final String JSON_HIST_TAREAS = "plugin/masivo/procedimientos/historicoTareasJSON";
	public static final String JSON_HIST_RESOLUCIONES = "plugin/masivo/procedimientos/historicoResolucionesJSON";
	public static final String JSON_HIST_TAREAS_ASUNTO = "plugin/masivo/asuntos/listaHistoricoTareasResolucionesJSON";
	public static final String JSP_VENTANA_RESOLUCION_DESDE_TAREA = "plugin/masivo/procedimientos/ventanaDetalleResolucion";
	public static final String JSON_DATOS_RESOLUCION = "plugin/masivo/procedimientos/datosResolucionJSON";

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	MSVCodigoPostalPlazaFactory msvCodigoPostalPlazaFactory;
 
	/**
     * Metodo que devuelve el historico de Tareas
     * @param id Procedimiento
     * @param model
     * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getHistoricoPorTareas(Long idProcedimiento, int limit, int start, ModelMap model) throws IllegalAccessException, InvocationTargetException {
    	    	
    	List<MSVHistoricoTareaDto> historicoTareas = proxyFactory.proxy(MSVHistoricoTareasApi.class).getHistoricoPorTareas(idProcedimiento);
    	PageSql page = getPage(historicoTareas, limit, start);
    	model.put("tareas", page);
        
    	return JSON_HIST_TAREAS;
    }
	
	/**
     * Metodo que devuelve el historico de Resoluciones
     * @param id Procedimiento
     * @param model
     * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getHistoricoPorResoluciones(Long idProcedimiento, int limit, int start, ModelMap model) throws IllegalAccessException, InvocationTargetException {
    	
    	List<MSVHistoricoResolucionDto> historicoResoluciones = proxyFactory.proxy(MSVHistoricoTareasApi.class).getHistoricoPorResolucion(idProcedimiento);
    	PageSql page = getPage(historicoResoluciones, limit, start);
    	model.put("resoluciones", page);
        
    	return JSON_HIST_RESOLUCIONES;
    }
    
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getHistoricoPorTareasAsunto(@RequestParam(value = "id", required = true) Long id, int limit, int start, String sort, ModelMap map) throws IllegalAccessException, InvocationTargetException {
		List<MSVHistoricoTareaAsuntoDto> historico = proxyFactory.proxy(MSVHistoricoTareasApi.class).getHistoricoPorTareasAsunto(id);
		
		PageSql page = getPage(historico, limit, start);		
		map.put("tareas", page);

		return JSON_HIST_TAREAS_ASUNTO;
	}
	
	/**
     * Metodo que devuelve el historico de Resoluciones para los asuntos
     * @param id Procedimiento
     * @param model
     * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getHistoricoPorResolucionesAsunto(Long id, int limit, int start, String sort, ModelMap map, ModelMap model) throws IllegalAccessException, InvocationTargetException {
    	
    	List<MSVHistoricoResolucionDto> historico = proxyFactory.proxy(MSVHistoricoTareasApi.class).getHistoricoPorResolucionAsunto(id);
    	
    	PageSql page = getPage(historico, limit, start);
		
    	model.put("resoluciones", page);
        
    	return JSON_HIST_RESOLUCIONES;
    }
	
	@SuppressWarnings("unchecked")
    @RequestMapping
    public String getDetalleResolucion(Long idInput, ModelMap model) {
    	RecoveryBPMfwkInput input = proxyFactory.proxy(RecoveryBPMfwkInputApi.class).get(idInput);

    	List<MSVHistItemResolucionDto> items = proxyFactory.proxy(MSVHistoricoTareasApi.class).getItemsDetalleInput(input);
    	FileItem adjunto = input.getAdjunto();
    	if (!Checks.esNulo(adjunto)) {
    		model.put("nombreFichero", adjunto.getFileName());
    	}
    	model.put("campos", items);
    	return JSON_DATOS_RESOLUCION;
    }

    
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abreFormularioDinamico(Long idInput, Long idTipoResolucion, ModelMap model){
		
		String html = proxyFactory.proxy(MSVResolucionApi.class).dameAyuda(idTipoResolucion);
		
		RecoveryBPMfwkInput input = proxyFactory.proxy(RecoveryBPMfwkInputApi.class).get(idInput);

		Long idProcedimiento = input.getIdProcedimiento();
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		Long idAsunto = prc.getAsunto().getId();
		
		MSVCodigoPostalPlazaApi msvCodigoPostalPlazaApi = msvCodigoPostalPlazaFactory.getBusinessObject();
		//MSVCodigoPostalPlazaApi msvCodigoPostalPlazaApi = msvGenericFactory.getBusinessObject();
		String codigoPlaza = msvCodigoPostalPlazaApi.obtenerPlazaAPartirDeDomicilio(idAsunto);

		model.put("html", html);
		model.put("idTipoResolucion", idTipoResolucion);
		model.put("idProcedimiento", idProcedimiento);
		model.put("idAsunto", idAsunto);
		model.put("idInput", idInput);
		model.put("codigoTipoProc", prc.getTipoProcedimiento().getCodigo());
		model.put("codigoPlaza", codigoPlaza);
		model.put("tieneProcurador", proxyFactory.proxy(MEJProcuradoresApi.class).pluginProcuradoresIsInstall());
		
		
		return JSP_VENTANA_RESOLUCION_DESDE_TAREA;
	}
    
    private PageSql getPage(Object objetoPaginar, int limit, int start) {
    	PageSql page = new PageSql();
		
		int fromIndex = start;
		int toIndex = start + limit;

		int size = ((List<?>) objetoPaginar).size();

		if (fromIndex < 0 || toIndex < 0) {
			fromIndex = 0;
			toIndex = 25;
		}

		if (((List<?>) objetoPaginar).size() >= start + limit) {
			objetoPaginar = ((List<?>) objetoPaginar).subList(start, start + limit);
		} else
			objetoPaginar = ((List<?>) objetoPaginar).subList(start, ((List<?>) objetoPaginar).size());

		page.setTotalCount(size);
		page.setResults((List<?>) objetoPaginar);
		
		return page;
    }

}
