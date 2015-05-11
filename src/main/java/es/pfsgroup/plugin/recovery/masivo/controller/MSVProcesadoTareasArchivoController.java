package es.pfsgroup.plugin.recovery.masivo.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;

@Controller
public class MSVProcesadoTareasArchivoController {
	
	public static final String JSP_DOWNLOAD_FILE = "plugin/masivo/download";
	public static final String JSP_ABRIR_PANTALLA = "plugin/masivo/procesadoTareasArchivo";
	public static final String JSP_FICHERO_ERRORES = "plugin/masivo/ficheroErrores";
	public static final String JSON_GRID_ACTUALIZADO = "plugin/masivo/gridActualizadoJSON";
	public static final String JSON_CAMBIO_ESTADO = "plugin/masivo/cambioEstadoJSON";
	public static final String JSON_ID_PROCESO = "plugin/masivo/idProcesoJSON";

	public static final String JSON_DATOS_PROCESOS = "plugin/masivo/datosProcesosJSON";
	public static final String JSON_DATOS_PROCESOS_PAGINATED = "plugin/masivo/datosProcesosPaginatedJSON";
	public static final String PREFIJO_CAMPOS_FILTROS = "filter[";
	

	
	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
	/*
	 * Abre la pantalla de procesado de tareas desde archivo.
	 * CU14.01
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirPantalla(ModelMap model){
		
		List<MSVDDOperacionMasiva> tiposOperacion =apiProxyFactory.proxy(MSVDiccionarioApi.class).dameListaOperacionesDeUsuario();
		model.put("tiposOperacion", tiposOperacion);
		
//		List<MSVPlantillaOperacion> plantillas = apiProxyFactory.proxy(MSVDiccionarioApi.class).dameListaPlantillasUsuario();
//		model.put("plantillas", plantillas);
		
		return JSP_ABRIR_PANTALLA;
	}
	
	/*
	 * Devuelve la pantalla de descarga de ficheros.
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String descargarExcel(Long idTipoOperacion, ModelMap model) throws Exception{
		
		ExcelFileBean excelFileBean = apiProxyFactory.proxy(ExcelManagerApi.class).generaExcelVaciaPorTipoOperacion(idTipoOperacion);
		
		model.put("fileItem", excelFileBean.getFileItem());
		
		return JSP_DOWNLOAD_FILE;
	}

	
	/*
	 * Devuelve un id de Proceso
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String initProcess(Long idTipoOperacion, String nombreFichero, ModelMap model) throws Exception{
		
		MSVDtoAltaProceso dto = new MSVDtoAltaProceso();
		dto.setIdTipoOperacion(idTipoOperacion);
		dto.setDescripcion(nombreFichero);
		
		Long idProceso = apiProxyFactory.proxy(MSVProcesoApi.class).iniciarProcesoMasivo(dto);
		//Long idProceso = 1L;
		


		model.put("idProceso", idProceso);
		model.put("idTipoOperacion", idTipoOperacion);
		model.put("descripcion", nombreFichero);
		
		return JSON_ID_PROCESO;
	}
	

	/*
	 * Devuelve un id de Proceso
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String validarFichero(Long idProceso, ModelMap model) throws Exception{
		
		MSVProcesoMasivo proceso = validarProceso(idProceso);
		
		model.put("proceso", proceso);
		
		return JSON_CAMBIO_ESTADO;
	}
	
	/*
	 * Liberamos un fichero para su procesamiento.
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String liberarFichero(Long idProceso, ModelMap model) throws Exception{
		
		MSVProcesoMasivo proceso = validarProceso(idProceso);
		if (MSVDDEstadoProceso.CODIGO_VALIDADO.equals(proceso.getEstadoProceso().getCodigo())){
			proceso = apiProxyFactory.proxy(MSVProcesoApi.class).liberarFichero(idProceso);
			MSVDDEstadoProceso estadoProceso = proceso.getEstadoProceso();
			
			model.put("idProceso", proceso.getId());
			if(estadoProceso!= null){
				model.put("idEstado", estadoProceso.getId());
				model.put("estado", estadoProceso.getDescripcion());
			}
		} else{
			model.put("proceso", proceso);
		}
		return JSON_CAMBIO_ESTADO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String descargarFicheroErrores(Long idProceso, ModelMap model) throws Exception{
		
		ExcelFileBean excelFileBean = apiProxyFactory.proxy(ExcelManagerApi.class).descargarErrores(idProceso);
		
		model.put("fileItem", excelFileBean.getFileItem());
	
		return JSP_DOWNLOAD_FILE;
	}
	

	/*
	 * Elimina archivos que se hayan cargado y no se deseen procesar
	 * CU 14.10
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String eliminarArchivo(Long idProceso, ModelMap model) throws Exception {
		
		if (idProceso==null) {
			throw new IllegalArgumentException("idProceso no puede ser null");
		}
		
		//método que nos va a devolver un ok/ko en función si la eliminación del proceso ha sido correcta o no
		String eliminadoProceso= apiProxyFactory.proxy(MSVProcesoApi.class).eliminarProceso(idProceso);
//		String eliminadoArchivo = new String("ko");
//		
//		
//		if (eliminadoProceso.equals(new String("ok"))){
//			eliminadoArchivo = apiProxyFactory.proxy(ExcelManagerApi.class).eliminarArchivo(idProceso);   
//		}
	
		
		model.put("eliminadoProceso", eliminadoProceso);
	//	model.put("eliminadoPArchivo", eliminadoArchivo);
		
	    return JSON_GRID_ACTUALIZADO;
		
	}
	
	/*
	 * Mostrar archivos procesados.
	 * 
	 * CU 14.08
	 */ 

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String mostrarProcesos(MSVDtoFiltroProcesos dto, ModelMap model, WebRequest request) throws Exception {
		
		
		if (model==null) {
			throw new IllegalArgumentException("model no puede ser null");
		}
		
		@SuppressWarnings("rawtypes")
		Map enu = request.getParameterMap();
		
		List<GridFilter> filtros = this.creaFiltros(enu);
		dto.setFiltros(filtros);
		
		//llamamos al ProcesoManager
		 Page listaProcesos = apiProxyFactory.proxy(MSVProcesoApi.class).mostrarProcesosPaginated(dto);
		 
		 model.put("data", listaProcesos);
		 
		return JSON_DATOS_PROCESOS_PAGINATED;
	}
	
	private List<GridFilter> creaFiltros(Map<String,String[]> enu) {

		List<GridFilter> filtros = new ArrayList<GridFilter>();
		boolean hayMasFiltros = true;
		int i = 0;
		while(hayMasFiltros){
			
			Map<String,String[]> camposFiltrado = this.getCamposFiltrado(enu, PREFIJO_CAMPOS_FILTROS + i);
			if (camposFiltrado.size() > 0){
				GridFilter filtro = new GridFilter();

				filtro.setCampoFiltrado(camposFiltrado.get(PREFIJO_CAMPOS_FILTROS + i + "][field]")[0]);
				filtro.setTipo(camposFiltrado.get(PREFIJO_CAMPOS_FILTROS + i + "][data][type]")[0]);
				if(camposFiltrado.get(PREFIJO_CAMPOS_FILTROS + i + "][data][comparison]") != null)
					filtro.setComparacion(camposFiltrado.get(PREFIJO_CAMPOS_FILTROS + i + "][data][comparison]")[0]);
				List<String> valoresFiltrado = Arrays.asList(camposFiltrado.get(PREFIJO_CAMPOS_FILTROS + i + "][data][value]"));
				filtro.setValoresFiltrado(valoresFiltrado);
				
				filtros.add(filtro);
				i++;
			}else{
				hayMasFiltros = false;
			}
				
		}
		
		return filtros;
	}


	@RequestMapping
	public String uploadFile(ModelMap model){
		
		//Set valores = model.entrySet();
		return JSON_ID_PROCESO;
	}
	
	private Map<String, String[]> getCamposFiltrado(Map<String,String[]> entrada, String cadenaBusqueda) {
		Map<String, String[]> salida = new HashMap<String,String[]>();
		if(entrada != null && entrada.size() >0){
			for (Map.Entry<String, String[]> entry : entrada.entrySet()) {
			    String key = entry.getKey();
			    if (key.startsWith(cadenaBusqueda)){
			    	salida.put(key, entry.getValue());
			    }
			}
		}
		return salida;
	}
	

	private MSVProcesoMasivo validarProceso(Long idProceso) throws Exception {
		Boolean valido=apiProxyFactory.proxy(ExcelManagerApi.class).validarArchivo(idProceso);
		MSVDtoAltaProceso dto= new MSVDtoAltaProceso();
		dto.setIdProceso(idProceso);
		if(valido){
			dto.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_VALIDADO);
		}else{
			dto.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_ERROR);
		}
		MSVProcesoMasivo proceso=apiProxyFactory.proxy(MSVProcesoApi.class).modificarProcesoMasivo(dto);
		return proceso;
	}

}
