package es.pfsgroup.plugin.rem.controller;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionGasto;
import es.pfsgroup.plugin.rem.model.DtoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;


@Controller
public class GastosProveedorController extends ParadiseJsonController {

	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private ProveedoresApi proveedoresApi;
	
	@Autowired
	private List<GastoAvisadorApi> avisadores;
	
	
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
			model.put("succes", true);
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

			DtoPage page = gastoProveedorApi.getListGastos(dtoGastosFilter);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("exception", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView existeGasto(DtoFichaGastoProveedor dto, ModelMap model) {
		try {	
			
			boolean existeGasto = gastoProveedorApi.existeGasto(dto);
			
			model.put("existeGasto", existeGasto);
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
	public ModelAndView searchProveedoresByNif(DtoProveedorFilter dto, ModelMap model) {
	
		try {
			model.put("data", gastoProveedorApi.searchProveedoresByNif(dto));
			model.put("success", true);			
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

		try {
			model.put("data", gastoProveedorApi.getAdjuntos(idGasto));
		
		} catch (Exception e) {
			model.put("msg", e.getMessage());
			model.put("success", false);
		}
		
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
	public ModelAndView getNifProveedorByUsuario(ModelMap model){
		
		
		
		try {
			String nifProveedor = proveedoresApi.getNifProveedorByUsuarioLogado();
			
			if(Checks.esNulo(nifProveedor)) {
				model.put("msg", "No ha sido posible encontrar un proveedor asignado al usuario identificado.");
				model.put("data", -1);
				model.put("success", false);
			} else {
				model.put("data", nifProveedor);
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView autorizarGastos(Long[] idsGasto, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.autorizarGastos(idsGasto);
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
	public ModelAndView rechazarGastos(Long[] idsGasto, String motivoRechazo, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.rechazarGastos(idsGasto, motivoRechazo);
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
	public ModelAndView autorizarGasto(Long idGasto, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.autorizarGasto(idGasto, true);
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
	public ModelAndView rechazarGasto(Long idGasto, String motivoRechazo, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.rechazarGasto(idGasto, motivoRechazo);
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
	
	@SuppressWarnings({ "unchecked"})
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosGastoById(Long id, WebDto webDto, ModelMap model){

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		GastoProveedor gasto = gastoProveedorApi.findOne(id);	
		
		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		
		for (GastoAvisadorApi avisador: avisadores) {
			
			DtoAviso aviso  = avisador.getAviso(gasto, usuarioLogado);
			if (!Checks.esNulo(aviso) && !Checks.esNulo(aviso.getDescripcion())) {
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso'>" + aviso.getDescripcion() + "</div>");
			}
			
        }
		
		model.put("data", avisosFormateados);
		
		return createModelAndViewJson(model);
		
	}
}
