package es.pfsgroup.plugin.rem.controller;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.excel.ActivosPreciosExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.factory.GenerarPropuestaPreciosFactoryApi;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;
import es.pfsgroup.plugin.rem.propuestaprecios.service.GenerarPropuestaPreciosService;

@Controller
public class PreciosController extends ParadiseJsonController{


	@Autowired
	private PreciosApi preciosApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;	
	
	@Autowired
    private GenericAdapter adapter;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private GenerarPropuestaPreciosFactoryApi generarPropuestaApi;
	
	protected static final Log logger = LogFactory.getLog(PreciosController.class);

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivos(DtoActivoFilter dtoActivoFiltro,
			ModelMap model) {

		try {

			Page page = preciosApi.getActivos(dtoActivoFiltro);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getPropuestas(DtoHistoricoPropuestaFilter dtoPropuestaFiltro, ModelMap model) {
		
		try {

			Page page = preciosApi.getHistoricoPropuestasPrecios(dtoPropuestaFiltro);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelSeleccionManual(DtoActivoFilter dtoActivoFilter, HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoActivoFilter.setStart(excelReportGeneratorApi.getStart());
		dtoActivoFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		@SuppressWarnings("unchecked")
		List<VBusquedaActivosPrecios> listaActivos = (List<VBusquedaActivosPrecios>) preciosApi.getActivos(dtoActivoFilter).getResults();		
		
		// FIXME Se genera una excel básica, pendiente de definir
		ExcelReport report = new ActivosPreciosExcelReport(listaActivos);
		
		excelReportGeneratorApi.generateAndSend(report, response);

	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void createPropuestaPreciosAutom(DtoActivoFilter dtoActivoFilter, String nombrePropuesta, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// Metodo para crear propuestas por peticion automatica
		
		generarPropuesta(dtoActivoFilter,nombrePropuesta,request,response);		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView generarPropuestaManual(DtoActivoFilter dtoActivoFilter, String nombrePropuesta, HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		// Metodo para crear propuestas por peticion manual
		
		try {
			generarPropuesta(dtoActivoFilter,nombrePropuesta,request,response);
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	private void generarPropuesta(DtoActivoFilter dtoActivoFilter, String nombrePropuesta, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		dtoActivoFilter.setStart(excelReportGeneratorApi.getStart());
		dtoActivoFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		//Obtiene la lista de activos buscada por filtros de pantalla
		@SuppressWarnings("unchecked")
		List<VBusquedaActivosPrecios> listaActivos = (List<VBusquedaActivosPrecios>) preciosApi.getActivos(dtoActivoFilter).getResults();
		
		//Genera la propuesta en BBDD y asocia los activos
		PropuestaPrecio propuesta =preciosApi.createPropuestaPreciosManual(listaActivos, nombrePropuesta, dtoActivoFilter.getTipoPropuestaCodigo());
		
		// Se genera excel unificada
		this.generarExcelPropuestaPrecios(propuesta,request,response);
		
	}
	
	/**
	 * Carga el Servicio correspondiente según la entidad, y generará la excel de propuesta de precios para guardarlo en el trabajo asociado
	 * @param propuesta
	 * @param request
	 * @param response
	 */
	private void generarExcelPropuestaPrecios(PropuestaPrecio propuesta, HttpServletRequest request, HttpServletResponse response) {
		GenerarPropuestaPreciosService servicio = generarPropuestaApi.getService(propuesta.getCartera().getCodigo());
		
		ServletContext sc = request.getSession().getServletContext();
		servicio.cargarPlantilla(sc);
		try {
			servicio.rellenarPlantilla(propuesta.getNumPropuesta().toString(), adapter.getUsuarioLogado().getApellidoNombre(), preciosApi.getDatosPropuestaByEntidad(propuesta));

			preciosApi.guardarFileEnTrabajo(servicio.getFile(),propuesta.getTrabajo());
			servicio.vaciarLibros();
			
		} catch (IllegalAccessException ex) {
			logger.error(ex.getMessage());
		} catch (InvocationTargetException ex) {
			logger.error(ex.getMessage());
		}
	}
	
	/****************************************************************************************************************/
	
	/*private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}*/
	
	/**
	 * Método para modificar la plantilla de JSON utilizada en el servlet.
	 * 
	 * @param request
	 * @param binder
	 * @throws Exception
	 */
	 /*******************************************************
	 * NOTA FASE II : Se refactoriza en ParadiseJsonController.java
	 * *******************************************************/
	/*@InitBinder
	protected void initBinder(HttpServletRequest request,  ServletRequestDataBinder binder) throws Exception{
        
	    JsonWriterConfiguratorTemplateRegistry registry = JsonWriterConfiguratorTemplateRegistry.load(request);             
	    registry.registerConfiguratorTemplate(new SojoJsonWriterConfiguratorTemplate(){
	                
	        	 	@Override
	                public SojoConfig getJsonConfig() {
	                    SojoConfig config= new SojoConfig();
                        config.setIgnoreNullValues(true);
                        return config;
	        	 	}
	         }
	   );


	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        dateFormat.setLenient(false);

        binder.registerCustomEditor(Date.class, new ParadiseCustomDateEditor(dateFormat, true));
        
        binder.registerCustomEditor(boolean.class, new CustomBooleanEditor("true", "false", true));
        binder.registerCustomEditor(Boolean.class, new CustomBooleanEditor("true", "false", true));
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(false));
        NumberFormat f = NumberFormat.getInstance(Locale.ENGLISH);
    	f.setGroupingUsed(false);
    	f.setMaximumFractionDigits(2);
        f.setMinimumFractionDigits(2);
        binder.registerCustomEditor(double.class, new CustomNumberEditor(Double.class, f, true));
        binder.registerCustomEditor(Double.class, new CustomNumberEditor(Double.class, f, true));
       
        
        /*binder.registerCustomEditor(Float.class, new CustomNumberEditor(Float.class, true));
        binder.registerCustomEditor(Long.class, new CustomNumberEditor(Long.class, true));
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));

        
        
	}*/

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivosByPropuesta(Long idPropuesta, WebDto webDto,
			ModelMap model) {

		try {

			Page page = preciosApi.getActivosByIdPropuesta(idPropuesta,webDto);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getNumActivosByTipoPrecio(ModelMap model)
	{
		
		try {

			List<VBusquedaNumActivosTipoPrecio> listaCountActivos = preciosApi.getNumActivosByTipoPrecioAndCartera();

			model.put("data", listaCountActivos);
			model.put("totalCount", listaCountActivos.size());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getNumActivosByTipoPrecioAmpliada(ModelMap model)
	{
		
		try {

			List<VBusquedaNumActivosTipoPrecio> listaCountActivos = preciosApi.getNumActivosByTipoPrecioAndEstadoSareb();

			model.put("data", listaCountActivos);
			model.put("totalCount", listaCountActivos.size());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoPropuesta (HttpServletRequest request, HttpServletResponse response) {
        
		DtoAdjunto dtoAdjunto = new DtoAdjunto();
		
		dtoAdjunto.setId(Long.parseLong(request.getParameter("id")));
		dtoAdjunto.setIdTrabajo(Long.parseLong(request.getParameter("idTrabajo")));
	
		
       	FileItem fileItem = trabajoApi.getFileItemAdjunto(dtoAdjunto);
		
       	try { 
       		ServletOutputStream salida = response.getOutputStream(); 
       			
       		response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
       		response.setHeader("Cache-Control", "max-age=0");
       		response.setHeader("Expires", "0");
       		response.setHeader("Pragma", "public");
       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
       		response.setContentType(fileItem.getContentType());
       		
       		// Write
       		FileUtils.copy(fileItem.getInputStream(), salida);
       		salida.flush();
       		salida.close();
       		
       	} catch (Exception e) { 
       		e.printStackTrace();
       	}


	}
}
