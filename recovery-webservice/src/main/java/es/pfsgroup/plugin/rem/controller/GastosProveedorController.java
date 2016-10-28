package es.pfsgroup.plugin.rem.controller;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletOutputStream;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.framework.paradise.utils.ParadiseCustomDateEditor;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionGasto;
import es.pfsgroup.plugin.rem.model.DtoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;


@Controller
public class GastosProveedorController {

	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private ProveedoresApi proveedoresApi;
	
	
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
	
	/**
	 * Método que recupera un trabajo según su id y lo mapea a un DTO
	 * @param id Id del trabajo
	 * @param pestana Pestaña del trabajo a cargar. Dependiendo de la pestaña recibida, cargará un DTO u otro
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findOne(Long id, ModelMap model){

		model.put("data", gastoProveedorApi.findOne(id));
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListGastos(DtoGastosFilter dtoGastosFilter, ModelMap model) {
		try {

//			if (dtoGastosFilter.getSort() == null){
//				
//				dtoGastosFilter.setSort("numFactura");
//
//			}
			//Page page = ofertaApi.getListOfertas(dtoOfertasFilter);
			DtoPage page = gastoProveedorApi.getListGastos(dtoGastosFilter);

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
			
		}
		catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		}catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteGastosProveedor(DtoFichaGastoProveedor dto, @RequestParam Long id,  ModelMap model) {
		
		try {
			boolean success = gastoProveedorApi.deleteGastoProveedor(id);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchProveedorCodigo(@RequestParam String codigoUnicoProveedor) {
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gastoProveedorApi.searchProveedorCodigo(codigoUnicoProveedor));
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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTrabajosGasto(@RequestParam Long idGasto, ModelMap model) {
		
		try {

			List<VBusquedaGastoTrabajos> lista = gastoProveedorApi.getListTrabajosGasto(idGasto);

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
	public ModelAndView updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidad, @RequestParam Long id, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.updateGastoContabilidad(dtoContabilidad, id);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGestionGasto(DtoGestionGasto dtoGestion, @RequestParam Long id, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.updateGestionGasto(dtoGestion, id);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateImpugnacionGasto(DtoImpugnacionGasto dtoImpugnacion, @RequestParam Long id, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.updateImpugnacionGasto(dtoImpugnacion, id);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView asignarTrabajos(Long idGasto, Long[] trabajos, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.asignarTrabajos(idGasto, trabajos);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(@RequestParam Long idGasto, ModelMap model){

		model.put("data", gastoProveedorApi.getAdjuntos(idGasto));
		
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView desasignarTrabajos(Long idGasto, Long[] trabajos, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.desasignarTrabajos(idGasto, trabajos);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}	

	/**
	 * Recibe y guarda un adjunto
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request, HttpServletResponse response)
		throws Exception {
		
		ModelMap model = new ModelMap();
		
		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			String errores = gastoProveedorApi.upload(fileItem);			

			model.put("errores", errores);
			model.put("success", errores==null);
		
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
		//return JsonViewer.createModelAndViewJson(model);

	}
	
	/**
     * delete un adjunto.
     * @param asuntoId long
     * @param adjuntoId long
     */
	@RequestMapping(method = RequestMethod.POST)
    public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto) {
		
		boolean success= false;
		
		try {
			success = gastoProveedorApi.deleteAdjunto(dtoAdjunto);
		} catch(Exception ex) {
			ex.printStackTrace();
		}
    	
    	return createModelAndViewJson(new ModelMap("success", success));

    }
	
	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoGasto (HttpServletRequest request, HttpServletResponse response) {
        
		DtoAdjunto dtoAdjunto = new DtoAdjunto();
		
		dtoAdjunto.setId(Long.parseLong(request.getParameter("id")));
		dtoAdjunto.setIdGasto(Long.parseLong(request.getParameter("idGasto")));
	
		
       	FileItem fileItem = gastoProveedorApi.getFileItemAdjunto(dtoAdjunto);
		
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCodProveedorByUsuario(ModelMap model){
		
		
		
		try {
			Long nif = proveedoresApi.getCodProveedorByUsuarioLogado();
			
			if(Checks.esNulo(nif)) {
				model.put("msg", "No ha sido posible encontrar un proveedor asignado al usuario identificado.");
				model.put("success", false);
			} else {
				model.put("data", nif);
				model.put("success", true);
			}


		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchProveedorCodigoByTipoEntidad(@RequestParam String codigoUnicoProveedor, @RequestParam String codigoTipoProveedor) {
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gastoProveedorApi.searchProveedorCodigoByTipoEntidad(codigoUnicoProveedor,codigoTipoProveedor));
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
	public ModelAndView searchGastoNumHaya(@RequestParam String numeroGastoHaya, @RequestParam String proveedorEmisor, @RequestParam String destinatario) {
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gastoProveedorApi.searchGastoNumHaya(numeroGastoHaya,proveedorEmisor,destinatario));
			model.put("success", true);			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		//return JsonViewer.createModelAndViewJson(new ModelMap("data", adapter.abreTarea(idTarea, subtipoTarea)));
		
	}
	
	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}
	
	

	
}
