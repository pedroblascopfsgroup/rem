package es.pfsgroup.plugin.rem.controller;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.ParadiseCustomDateEditor;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;


@Controller
public class ExpedienteComercialController {

	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private List<ExpedienteAvisadorApi> avisadores;
	
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

	
	
	/**
	 * Método que recupera un conjunto de datos del expediente comercial según su id 
	 * @param id Id del expediente comercial
	 * @param pestana Pestaña del expediente comercial a cargar
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabExpediente(Long id, String tab, ModelMap model) {

		try {
			model.put("data", expedienteComercialApi.getTabExpediente(id, tab));
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings({ "unchecked"})
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosExpedienteById(Long id, WebDto webDto, ModelMap model){

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		ExpedienteComercial expediente = expedienteComercialApi.findOne(id);	
		
		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		
		for (ExpedienteAvisadorApi avisador: avisadores) {
			
			DtoAviso aviso  = avisador.getAviso(expediente, usuarioLogado);
			if (!Checks.esNulo(aviso) && !Checks.esNulo(aviso.getDescripcion())) {
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso'>" + aviso.getDescripcion() + "</div>");
			}
			
        }
		
		model.put("data", avisosFormateados);
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTextosOfertaById(@RequestParam Long id, ModelMap model) {
		
		
	try {
		
		List<DtoTextosOferta> lista  =  expedienteComercialApi.getListTextosOfertaById(id);
		
		model.put("data", lista);
		model.put("success", true);
		
	} catch (Exception e) {
		e.printStackTrace();
		model.put("success", false);
	}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListEntregasReserva(@RequestParam Long id, ModelMap model) {
		
	try {
		
		List<DtoEntregaReserva> lista  =  expedienteComercialApi.getListEntregasReserva(id);
		
		model.put("data", lista);
		model.put("success", true);
		
	} catch (Exception e) {
		e.printStackTrace();
		model.put("success", false);
	}

		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveTextoOferta(DtoTextosOferta dto, @RequestParam Long idEntidad, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.saveTextoOferta(dto, idEntidad));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosBasicosOferta(DtoDatosBasicosOferta dto, @RequestParam Long id, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.saveDatosBasicosOferta(dto, id));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getObservaciones(ModelMap model, Long idExpediente) {
		
		try {
			DtoPage dto = expedienteComercialApi.getListObservaciones(idExpediente);
			
			model.put("data", dto.getResults());
			model.put("totalCount", dto.getTotalCount());
			model.put("success", true);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveObservacion(DtoObservacion dtoObservacion){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = expedienteComercialApi.saveObservacion(dtoObservacion);
			model.put("success", success);			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createObservacion(DtoObservacion dtoObservacion, Long idEntidad){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = expedienteComercialApi.createObservacion(dtoObservacion, idEntidad);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteObservacion(@RequestParam Long id){
		
		ModelMap model = new ModelMap();		
		try {
			boolean success = expedienteComercialApi.deleteObservacion(id);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}
	
	

	
}
