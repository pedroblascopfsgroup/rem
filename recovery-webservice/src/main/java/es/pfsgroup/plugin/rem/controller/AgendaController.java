package es.pfsgroup.plugin.rem.controller;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.exception.SQLGrammarException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.InvalidDataAccessResourceUsageException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.agenda.controller.TareaController;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.TareaExcelReport;
import es.pfsgroup.plugin.rem.model.DtoSolicitarProrrogaTarea;
import es.pfsgroup.plugin.rem.model.DtoTareaFilter;
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;

@Controller
public class AgendaController extends TareaController {
	
	@Autowired
	private AgendaAdapter adapter;
	
	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Resource
	Properties appProperties;
	
	@Autowired
	ExcelReportGeneratorApi excelReportGeneratorApi;
	
	
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
        dateFormat.setTimeZone(TimeZone.getDefault());
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

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListTareas(DtoTareaFilter dtoTareaFiltro, ModelMap model) {

		Page p = adapter.getListTareas(dtoTareaFiltro);
		
		model.put("data", p.getResults());
		model.put("totalCount", p.getTotalCount());
		
		return createModelAndViewJson(model);

	}
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getFormularioTarea(Long idTarea, ModelMap model) {

		model.put("data", adapter.getFormularioTarea(idTarea));
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getValidacionPrevia(Long idTarea, ModelMap model) {
		model.put("data", adapter.getValidacionPrevia(idTarea));
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIdActivoTarea(Long idTarea, ModelMap model) {
		model.put("idActivoTarea", adapter.getIdActivoTarea(idTarea));
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIdTrabajoTarea(Long idTarea, ModelMap model) {
		model.put("idTrabajoTarea", adapter.getIdTrabajoTarea(idTarea));
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getNumIdExpediente(Long idTarea, ModelMap model) {
		model.put("idExpediente", adapter.getIdExpediente(idTarea));
		model.put("numExpediente", adapter.getNumExpediente(idTarea));
		return createModelAndViewJson(model);
	}	

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getCodigoTramiteTarea(Long idTarea, ModelMap model) {
		model.put("codigoTramite", adapter.getCodigoTramiteTarea(idTarea));
		return createModelAndViewJson(model);
	}
	

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView detalleTarea(Long idTarea, String subtipoTarea) {
	
		return createModelAndViewJson(new ModelMap("data", adapter.abreTarea(idTarea, subtipoTarea)));
		
	}

    @RequestMapping(method = RequestMethod.POST)
    public ModelAndView save(WebRequest request, ModelMap model) {
                            
            boolean success = false;
			try {
				success = adapter.save(request.getParameterMap());
				
			} catch (InvalidDataAccessResourceUsageException e) {
				// Mensajes concretos para este tipo de excepcion
				model.put("errorValidacionGuardado", getMensajeInvalidDataAccessExcepcion(e));
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				model.put("errorValidacionGuardado", e.getMessage());
			}
    
            model.put("success", success);
    
            return createModelAndViewJson(model);
    }
    
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView tareasPendientes(WebRequest request, ModelMap model){
		boolean success = true;
		model.put("contador", adapter.tareasPendientes());
		model.put("success",success);
		return createModelAndViewJson(model);
	}
	
//	@RequestMapping(method = RequestMethod.GET)
//	public ModelAndView notificacionesPendientes(WebRequest request, ModelMap model){
//		boolean success = true;
//		model.put("contador", adapter.notificacionesPendientes());
//		model.put("success",success);
//		return createModelAndViewJson(model);
//	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView alertasPendientes(WebRequest request, ModelMap model){
		boolean success = true;
		model.put("contador", adapter.alertasPendientes());
		model.put("success",success);
		return createModelAndViewJson(model);	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView avisosPendientes(WebRequest request, ModelMap model){
		boolean success = true;
		model.put("contador", adapter.avisosPendientes());
		model.put("success",success);
		return createModelAndViewJson(model);	
	}
	

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboNombreTarea(Long idTipoTramite,WebDto webDto, ModelMap model){
		
		model.put("data", adapter.getComboNombreTarea(idTipoTramite));
		
		return createModelAndViewJson(model);
		
	}	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAdvertenciaTarea(@RequestParam Long idTarea, ModelMap model){
		
		//TODO: Aquí se generan los distintos textos de avisos para la tarea
		String advertencia = adapter.getAdvertenciaTarea(idTarea);
		String codigoTramite = adapter.getCodigoTramiteTarea(idTarea);
		String codigoTareaProcedimiento = adapter.getCodigoTareaProcedimiento(idTarea);
		
		model.put("codigoTramite", codigoTramite);
		model.put("codigoTareaProcedimiento", codigoTareaProcedimiento);
		model.put("advertenciaExisteTrabajo", advertencia);
		model.put("success", true);
		
		return createModelAndViewJson(model);
		
	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoTareaFilter dtoTareaFilter, HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoTareaFilter.setStart(excelReportGeneratorApi.getStart());
		dtoTareaFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		@SuppressWarnings("unchecked")
		List<DtoResultadoBusquedaTareasBuzones> listaTareas = (List<DtoResultadoBusquedaTareasBuzones>) adapter.getListTareas(dtoTareaFilter).getResults();
		
		ExcelReport report = new TareaExcelReport(listaTareas);
		
		excelReportGeneratorApi.generateAndSend(report, response);

	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTiposProcedimientoAgenda(ModelMap model){
		model.put("data", adapter.getTiposProcedimientoAgenda());
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView generarAutoprorroga(DtoSolicitarProrrogaTarea dtoSolicitarProrroga, ModelMap model){
		model.put("success", adapter.generarAutoprorroga(dtoSolicitarProrroga));
		//model.put("success", true);
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saltoCierreEconomico(Long idTareaExterna, ModelMap model){
		model.put("success", adapter.saltoCierreEconomico(idTareaExterna));
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saltoResolucionExpediente(Long idTareaExterna, ModelMap model){
		model.put("success", adapter.saltoResolucionExpediente(idTareaExterna));
		
		return createModelAndViewJson(model);
	}
	
	private String getMensajeInvalidDataAccessExcepcion(InvalidDataAccessResourceUsageException e){
		
		// En este tipo de excepción se pueden esconder errores del procedure de BBDD de publicacion ACTIVO_PUBLICACION_AUTO
		// Hay que mostrar un mensaje de error concreto para uno de los errores (no cumplir condiciones para publicar)
		Throwable causa = e.getCause();
		String mensajeError = null;
		int contador = 0;
		while (!Checks.esNulo(causa) && Checks.esNulo(mensajeError) && contador < 100){
			if(causa.getMessage().contains("ACTIVO_PUBLICACION_AUTO") && causa.getMessage().contains("ORA-06510")){
				mensajeError = "El activo no cumple todas las condiciones para ser publicado. Revise OK de precios o las reglas de publicación."; 
			}
			causa = causa.getCause();
			contador++;
		}

		// Para el resto de errores, se muestra un mensaje generico
		if(Checks.esNulo(mensajeError))
			mensajeError = "Se ha producido un error con la base de datos al avanzar la tarea. Inténtelo más tarde.";

		return mensajeError;
	}
	
	
}
