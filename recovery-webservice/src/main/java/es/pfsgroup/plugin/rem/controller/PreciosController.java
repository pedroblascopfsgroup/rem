package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import javax.servlet.ServletContext;
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
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.framework.paradise.agenda.formulario.dao.impl.ParadiseFormItemDaoImpl;
import es.pfsgroup.framework.paradise.bulkUpload.utils.ExcelGenerarPropuestaPrecios;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.excel.ActivosPreciosExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;


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
	
	@RequestMapping(method = RequestMethod.GET)
	public void generarPropuestaManual(DtoActivoFilter dtoActivoFilter, String nombrePropuesta, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// Metodo para crear propuestas por peticion manual
		
		generarPropuesta(dtoActivoFilter,nombrePropuesta,request,response);
	}
	
	private void generarPropuesta(DtoActivoFilter dtoActivoFilter, String nombrePropuesta, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		dtoActivoFilter.setStart(excelReportGeneratorApi.getStart());
		dtoActivoFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		//Obtiene la lista de activos buscada por filtros de pantalla
		@SuppressWarnings("unchecked")
		List<VBusquedaActivosPrecios> listaActivos = (List<VBusquedaActivosPrecios>) preciosApi.getActivos(dtoActivoFilter).getResults();
		
		//Genera la propuesta en BBDD y asocia los activos
		PropuestaPrecio propuesta =preciosApi.createPropuestaPreciosManual(listaActivos, nombrePropuesta, dtoActivoFilter.getTipoPropuestaCodigo());
		
		// FIXME Se genera una excel básica, pendiente de definir
		/*ExcelReport report = preciosApi.createExcelPropuestaPrecios(listaActivos, dtoActivoFilter.getEntidadPropietariaCodigo(), nombrePropuesta);
		excelReportGeneratorApi.generateAndSend(report, response);*/
		
		// Se genera excel unificada
		this.generarExcelPropuestaUnificada(propuesta,request,response);
		
	}
	
	/**
	 * Carga la plantilla unificada de Propuesta de precios, y la rellena con los datos de la propuesta
	 * @param propuesta
	 * @param request
	 * @param response
	 */
	private void generarExcelPropuestaUnificada(PropuestaPrecio propuesta, HttpServletRequest request, HttpServletResponse response) {
		
		ExcelGenerarPropuestaPrecios excel = new ExcelGenerarPropuestaPrecios();
		
		ServletContext sc = request.getSession().getServletContext();
		excel.cargarPlantilla(sc.getRealPath("plantillas/plugin/LISTADO_ACTIVOS_PROPUESTA_PRECIOS.xls"));
		try {
			excel.rellenarPlantilla(propuesta.getNumPropuesta().toString(), adapter.getUsuarioLogado().getApellidoNombre(), preciosApi.getDatosPropuestaUnificada(propuesta.getId()));
		
			excelReportGeneratorApi.sendReport(excel.getFile(), response);
			excel.vaciarLibros();
			
		} catch (IllegalAccessException ex) {
			logger.error(ex.getMessage());
		} catch (InvocationTargetException ex) {
			logger.error(ex.getMessage());
		} catch (IOException ex) {
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
}
