package es.pfsgroup.plugin.rem.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ProvisionGastosApi;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;


@Controller
public class ProvisionGastosController extends ParadiseJsonController {

	
	@Autowired
	private ProvisionGastosApi provisionGastosApi;
	
	
	
	/**
	 * Método para modificar la plantilla de JSON utilizada en el servlet.
	 * 
	 * @param request
	 * @param binder
	 * @throws Exception
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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAll(DtoProvisionGastosFilter dto, ModelMap model){

		DtoPage page = provisionGastosApi.findAll(dto);
		
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		
		return createModelAndViewJson(model);
		
	}	
	

	
}
