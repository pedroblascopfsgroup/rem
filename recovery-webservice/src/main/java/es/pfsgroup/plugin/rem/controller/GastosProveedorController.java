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

import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.framework.paradise.utils.ParadiseCustomDateEditor;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoGestionGasto;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;


@Controller
public class GastosProveedorController {

	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	
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
	 * Método que recupera un conjunto de datos del gasto según su id 
	 * @param id Id del gasto
	 * @param pestana Pestaña del gasto a cargar
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabGasto(Long id, String tab, ModelMap model) {

		try {
			model.put("data", gastoProveedorApi.getTabGasto(id, tab));
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createGastosProveedor(DtoFichaGastoProveedor dto, ModelMap model) {
		try {	
			
			GastoProveedor gasto = gastoProveedorApi.createGastoProveedor(dto);
			
			model.put("id", gasto.getId() );
			model.put("success", true );
			
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}		
		
		return createModelAndViewJson(model);
		
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveGastosProveedor(DtoFichaGastoProveedor dto, @RequestParam Long id,  ModelMap model) {
		try {		
			
			boolean respuesta = gastoProveedorApi.saveGastosProveedor(dto, id);
			model.put("success", respuesta );
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchProveedorNif(@RequestParam String nifProveedor) {
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gastoProveedorApi.searchProveedorNif(nifProveedor));
			model.put("success", true);			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		//return JsonViewer.createModelAndViewJson(new ModelMap("data", adapter.abreTarea(idTarea, subtipoTarea)));
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchPropietarioNif(@RequestParam String nifPropietario) {
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gastoProveedorApi.searchPropietarioNif(nifPropietario));
			model.put("success", true);			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		//return JsonViewer.createModelAndViewJson(new ModelMap("data", adapter.abreTarea(idTarea, subtipoTarea)));
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDetalleEconomico(DtoDetalleEconomicoGasto dto, @RequestParam Long id, ModelMap model) {
		try {		
			
			model.put("data", gastoProveedorApi.saveDetalleEconomico(dto, id));
			model.put("success", true);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosGastos(@RequestParam Long idGasto, ModelMap model) {
		
	try {
		
		List<VBusquedaGastoActivo> lista  =  gastoProveedorApi.getListActivosGastos(idGasto);
		
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
	public ModelAndView createGastoActivo(@RequestParam Long idGasto, @RequestParam Long numActivo, @RequestParam Long numAgrupacion, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.createGastoActivo(idGasto, numActivo, numAgrupacion);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGastoActivo(DtoActivoGasto dtoActivoGasto, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.updateGastoActivo(dtoActivoGasto);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteGastoActivo(DtoActivoGasto dtoActivoGasto, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.deleteGastoActivo(dtoActivoGasto);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidad, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.updateGastoContabilidad(dtoContabilidad);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGestionGasto(DtoGestionGasto dtoGestion, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.updateGestionGasto(dtoGestion);
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
