package es.pfsgroup.plugin.rem.controller;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomBooleanEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.ParadiseCustomDateEditor;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.excel.ActivosPreciosExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPropuesta;


@Controller
public class PreciosController {


	@Autowired
	private PreciosApi preciosApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;		

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
	public void generarPropuestaManual(DtoActivoFilter dtoActivoFilter, String nombrePropuesta, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		dtoActivoFilter.setStart(excelReportGeneratorApi.getStart());
		dtoActivoFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		//Obtiene la lista de activos buscada por filtros de pantalla
		@SuppressWarnings("unchecked")
		List<VBusquedaActivosPrecios> listaActivos = (List<VBusquedaActivosPrecios>) preciosApi.getActivos(dtoActivoFilter).getResults();
		
		//Genera la propuesta en BBDD y asocia los activos
		PropuestaPrecio propuestaPrecio = preciosApi.createPropuestaPrecios(listaActivos, nombrePropuesta);
		
		// FIXME Se genera una excel básica, pendiente de definir
		ExcelReport report = preciosApi.createExcelPropuestaPrecios(listaActivos, dtoActivoFilter.getEntidadPropietariaCodigo(), nombrePropuesta);
		excelReportGeneratorApi.generateAndSend(report, response);
		
	}
	
	/****************************************************************************************************************/
	
	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}
	
	/**
	 * Método para modificar la plantilla de JSON utilizada en el servlet.
	 * 
	 * @param request
	 * @param binder
	 * @throws Exception
	 */
	@InitBinder
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
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));*/

        
        
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivosByPropuesta(Long idPropuesta,
			ModelMap model) {

		try {

			List<VBusquedaActivosPropuesta> listaActivos = preciosApi.getActivosByIdPropuesta(idPropuesta);

			model.put("data", listaActivos);
			model.put("totalCount", listaActivos.size());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}



}
