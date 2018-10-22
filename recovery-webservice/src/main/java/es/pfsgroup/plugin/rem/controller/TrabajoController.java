package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.NonUniqueObjectException;
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
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.adapter.TrabajoAdapter;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.TrabajoExcelReport;
import es.pfsgroup.plugin.rem.factory.GenerarPropuestaPreciosFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoActivoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoGestionEconomicaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoListadoTramites;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoPresupuestosTrabajo;
import es.pfsgroup.plugin.rem.model.DtoProvisionSuplido;
import es.pfsgroup.plugin.rem.model.DtoRecargoProveedor;
import es.pfsgroup.plugin.rem.model.DtoTarifaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoTrabajoListActivos;
import es.pfsgroup.plugin.rem.model.DtoUsuario;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.TrabajoFoto;
import es.pfsgroup.plugin.rem.model.VBusquedaTrabajos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.propuestaprecios.service.GenerarPropuestaPreciosService;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.TrabajoDto;
import es.pfsgroup.plugin.rem.rest.dto.TrabajoRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import net.sf.json.JSONObject;



@Controller
public class TrabajoController extends ParadiseJsonController {
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private ActivoAdapter adapter;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private TrabajoAdapter trabajoAdapter;
	
	@Autowired
	List<TrabajoAvisadorApi> avisadores;
	
	@Autowired
	ExcelReportGeneratorApi excelReportGeneratorApi;
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private PreciosApi preciosApi;
	
	@Autowired
	private UpdaterStateApi updaterStateApi;
	
	@Autowired
	private GenerarPropuestaPreciosFactoryApi generarPropuestaApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private TrabajoDao trabajoDao;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String ERROR_DUPLICADOS_CREAR_TRABAJOS = "El fichero contiene registros duplicados";

		
	/**
	 * Método que recupera un trabajo según su id y lo mapea a un DTO
	 * @param id Id del trabajo
	 * @param pestana Pestaña del trabajo a cargar. Dependiendo de la pestaña recibida, cargará un DTO u otro
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findOne(Long id,String pestana, ModelMap model){

		model.put("data", trabajoApi.getTrabajoById(id, pestana));
		
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findAll(DtoTrabajoFilter dtoTrabajoFilter, ModelMap model){

		Page page = trabajoApi.findAll(dtoTrabajoFilter, genericAdapter.getUsuarioLogado());
		
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		
		return createModelAndViewJson(model);
		
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFichaTrabajo(ModelMap model, DtoFichaTrabajo dtoTrabajo, @RequestParam Long id){
		try {
			Boolean success = trabajoApi.saveFichaTrabajo(dtoTrabajo, id);
			model.put("success", success);
			
		} catch(Exception e) {
			logger.error(e.getMessage());
			model.put("error", e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveGestionEconomicaTrabajo(DtoGestionEconomicaTrabajo dtoGestionEconomica, @RequestParam Long id){
		
		boolean success = false;
		
		try {
			
			success = trabajoApi.saveGestionEconomicaTrabajo(dtoGestionEconomica, id);
			
		} catch(Exception e) {
			logger.error(e.getMessage());
		}
		
		return createModelAndViewJson(new ModelMap("success", success));
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView create(DtoFichaTrabajo dtoTrabajo){

		boolean success = false;
		
		ModelMap model = new ModelMap();
		
		try {
			
			Long idTrabajo = trabajoApi.create(dtoTrabajo);
			dtoTrabajo.setIdTrabajo(idTrabajo);
			success = true;
			
		} catch(NonUniqueObjectException e) {
			logger.error(e.getMessage(),e);
			model.put("error", ERROR_DUPLICADOS_CREAR_TRABAJOS);
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
		}
		
		model.put("success", success);
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
			
			String errores = trabajoApi.upload(fileItem);			

			model.put("errores", errores);
			model.put("success", errores==null);
		
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
	}
	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoTrabajo (HttpServletRequest request, HttpServletResponse response) {
        
		DtoAdjunto dtoAdjunto = new DtoAdjunto();
		
		dtoAdjunto.setId(Long.parseLong(request.getParameter("id")));
		dtoAdjunto.setIdEntidad(Long.parseLong(request.getParameter("idTrabajo")));
	
		
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
       		logger.error(e.getMessage());
       	}

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
			success = trabajoApi.deleteAdjunto(dtoAdjunto);
		} catch(Exception ex) {
			logger.error(ex.getMessage());
		}
    	
    	return createModelAndViewJson(new ModelMap("success", success));

    }
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(Long id, ModelMap model){

		model.put("data", trabajoApi.getAdjuntos(id));
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivos(DtoActivosTrabajoFilter dto){

		Page page = trabajoApi.getListActivos(dto);
		
		ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSeleccionTarifasTrabajo(DtoGestionEconomicaTrabajo dto,String cartera, String tipoTrabajo, String subtipoTrabajo
			, String codigoTarifa, String descripcionTarifa){

		DtoPage page = trabajoApi.getSeleccionTarifasTrabajo(dto, cartera, tipoTrabajo, subtipoTrabajo, codigoTarifa, descripcionTarifa);
		
		ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTarifasTrabajo(DtoGestionEconomicaTrabajo dto, @RequestParam Long idTrabajo){

		DtoPage page = trabajoApi.getTarifasTrabajo(dto, idTrabajo);
		
		ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		
		return createModelAndViewJson(model);
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPresupuestosTrabajo(DtoGestionEconomicaTrabajo dto, @RequestParam Long idTrabajo){

		DtoPage page = trabajoApi.getPresupuestosTrabajo(dto, idTrabajo);
		
		ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		
		return createModelAndViewJson(model);
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createTarifaTrabajo(DtoTarifaTrabajo tarifaDto,@RequestParam Long idTrabajo){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.createTarifaTrabajo(tarifaDto, idTrabajo);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createPresupuestoTrabajo(DtoPresupuestosTrabajo presupuestoDto,@RequestParam Long idTrabajo){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.createPresupuestoTrabajo(presupuestoDto, idTrabajo);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView savePresupuestoTrabajo(DtoPresupuestosTrabajo presupuestoDto){

		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.savePresupuestoTrabajo(presupuestoDto);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePresupuestoTrabajo(@RequestParam Long id){

		
		
		ModelMap model = new ModelMap();
		
		try {

			boolean success = trabajoApi.deletePresupuestoTrabajo(id);
			model.put("success", success);
		
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveTarifaTrabajo(DtoTarifaTrabajo tarifaDto){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.saveTarifaTrabajo(tarifaDto);
			model.put("success", success);			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteTarifaTrabajo(@RequestParam Long id){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.deleteTarifaTrabajo(id);
			model.put("success", success);			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosAgrupacion(DtoAgrupacionFilter filtro, Long id, ModelMap model){

		Page page = trabajoApi.getListActivosAgrupacion(filtro, id); 
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramitesTareas(Long idTrabajo, WebDto webDto, ModelMap model){
		
		List<DtoListadoTramites> tramites = trabajoAdapter.getListadoTramitesTareasTrabajo(idTrabajo, webDto);
		
		// TODO Cambiar si finalmente es posible que un trababjo tenga más de un trámite
		DtoListadoTramites tramite = new DtoListadoTramites(); 
		if(!Checks.estaVacio(tramites)) {
			tramite = tramites.get(0);
		}
		
		model.put("tramite", tramite);
		
		return createModelAndViewJson(model);
	}

	@SuppressWarnings({ "unchecked"})
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosTrabajoById(Long id, WebDto webDto, ModelMap model){

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		Trabajo trabajo = trabajoApi.findOne(id);	
		
		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		
		for (TrabajoAvisadorApi avisador: avisadores) {
			
			if ( avisador.getAviso(trabajo, usuarioLogado) != null 
					&&  avisador.getAviso(trabajo, usuarioLogado).getDescripcion() != null) {
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso red'>" + avisador.getAviso(trabajo, usuarioLogado).getDescripcion() + "</div>");
			}
			
        }
		
		model.put("data", avisosFormateados);
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getObservaciones(DtoTrabajoFilter dto){
		
		DtoPage page = trabajoApi.getObservaciones(dto);
		
		ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());
		
		return createModelAndViewJson(model);
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveObservacion(DtoObservacion dtoObservacion){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.saveObservacion(dtoObservacion);
			model.put("success", success);			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createObservacion(DtoObservacion dtoObservacion, Long idEntidad){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.createObservacion(dtoObservacion, idEntidad);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteObservacion(@RequestParam Long id){
		
		ModelMap model = new ModelMap();		
		try {
			boolean success = trabajoApi.deleteObservacion(id);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoTrabajo(DtoActivoTrabajo activoTrabajo, String idEntidad){
		
		ModelMap model = new ModelMap();
		
		activoTrabajo.setIdTrabajo(idEntidad);
		
		try {
			boolean success = trabajoApi.saveActivoTrabajo(activoTrabajo);
			model.put("success", success);			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFotosById(Long id, Boolean solicitanteProveedor, WebDto webDto, ModelMap model, HttpServletRequest request, HttpServletResponse response){
		
		try {
			List<TrabajoFoto> listaTrabajoFoto = trabajoAdapter.getListFotosTrabajoById(id, solicitanteProveedor);
		
		

			List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();
	
			if (listaTrabajoFoto != null) {
				
				for (int i = 0; i < listaTrabajoFoto.size(); i++) 
				{
					
					DtoFoto fotoDto = new DtoFoto();

					try {
	
						BeanUtils.copyProperty(fotoDto, "path", "/pfs/trabajo/getFotoTrabajoById.htm?idFoto=" + listaTrabajoFoto.get(i).getId());

						BeanUtils.copyProperties(fotoDto, listaTrabajoFoto.get(i));
	
					} catch (IllegalAccessException e) {
						logger.error(e.getMessage());
					} catch (InvocationTargetException e) {
						logger.error(e.getMessage());
					}
					
					listaFotos.add(fotoDto);
					
				}

			}
			
			model.put("data", listaFotos);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
		
		
		
		
		return new ModelAndView("jsonView", model);
	}
	
	/**
	 * Recibe y guarda una foto
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFoto(HttpServletRequest request, HttpServletResponse response)
		throws Exception {
		
		ModelMap model = new ModelMap();
		
		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			String errores = trabajoApi.uploadFoto(fileItem);			

			model.put("errores", errores);
			model.put("success", errores!=null);
		
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
	} 
	
	@RequestMapping(method = RequestMethod.GET)
	public void getFotoTrabajoById (Long idFoto, HttpServletRequest request, HttpServletResponse response) {
		
		FileItem fileItem = trabajoAdapter.getFotoTrabajoById(idFoto).getAdjunto().getFileItem();

		
       	try { 
       		ServletOutputStream salida = response.getOutputStream(); 
       		
       		response.setHeader("Content-disposition", "inline");
       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
       		response.setHeader("Cache-Control", "max-age=0");
       		response.setHeader("Expires", "0");
       		response.setHeader("Pragma", "public");
       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
       		
       		if (fileItem.getContentType() != null) {
       			response.setContentType(fileItem.getContentType());
       		} else {
       			response.setContentType("Content-type: image/jpeg");
       		}
       		
       		// Write
       		FileUtils.copy(fileItem.getInputStream(), salida);
       		salida.flush();
       		salida.close();
       		
       	} catch (Exception e) { 
       		logger.error(e.getMessage());
       	}

	}
	

	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateFotosById(DtoFoto dtoFoto, ModelMap model){
		
		try {
			boolean success = trabajoAdapter.saveFoto(dtoFoto);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		model.put("success", true);
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteFotosTrabajoById(@RequestParam Long[] id, ModelMap model){
		
		try {
			boolean success = trabajoAdapter.deleteFotosTrabajoById(id);
			model.put("success", success);
			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAdvertenciaCrearTrabajo(@RequestParam Long idActivo, @RequestParam String codigoSubtipoTrabajo, ModelMap model){
		
		String advertencia="";
		
		
		advertencia = trabajoAdapter.getAdvertenciaCrearTrabajo(idActivo, codigoSubtipoTrabajo, null);			

		model.put("advertencia", advertencia);
		model.put("success", true);
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedor(Long idTrabajo, ModelMap model){
		
		model.put("data", trabajoApi.getComboProveedor(idTrabajo));
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedorFiltered(Long idTrabajo, String codigoTipoProveedor, ModelMap model) {
		
		model.put("data", trabajoApi.getComboProveedorFiltered(idTrabajo, codigoTipoProveedor));
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoProveedorFiltered(Long idTrabajo, ModelMap model) {
		
		model.put("data", trabajoApi.getComboTipoProveedorFiltered(idTrabajo));
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedorContacto(Long idProveedor, ModelMap model) {
		try{
			
			model.put("data", trabajoApi.getComboProveedorContacto(idProveedor));
			model.put("success", true);
			
		} catch (JsonViewerException e) {
			model.put("success", false);
			model.put("msg", e.getMessage());
			
		} catch (Exception e) {
			model.put("success", false);
			model.put("msg", "Se ha producido un error al ejecutar la petición.");
		}
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboResponsableTrabajo(Long idTrabajo, ModelMap model) {
		
		Trabajo trabajo = trabajoDao.get(idTrabajo);
		
		Activo activo = trabajo.getActivo();
		
		Usuario gestorActivo = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
		Usuario gestorAlquileres = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
		Usuario gestorSuelos = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_SUELOS);
		Usuario gestorEdificaciones = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_EDIFICACIONES);
		
		List<DtoUsuario> listaResponsables = new ArrayList<DtoUsuario>();
		
		DtoUsuario dtoGestorActivo = new DtoUsuario();
		DtoUsuario dtoGestorAlquileres = new DtoUsuario();
		DtoUsuario dtoGestorSuelos = new DtoUsuario();
		DtoUsuario dtoGestorEdificaciones = new DtoUsuario();
		
		try {
			if(!Checks.esNulo(gestorActivo)){
				BeanUtils.copyProperties(dtoGestorActivo, gestorActivo);
				listaResponsables.add(dtoGestorActivo);
			}
			if(!Checks.esNulo(gestorAlquileres)){
				BeanUtils.copyProperties(dtoGestorAlquileres, gestorAlquileres);
				listaResponsables.add(dtoGestorAlquileres);
			}
			if(!Checks.esNulo(gestorSuelos)){
				BeanUtils.copyProperties(dtoGestorSuelos, gestorSuelos);
				listaResponsables.add(dtoGestorSuelos);
			}
			if(!Checks.esNulo(gestorEdificaciones)){
				BeanUtils.copyProperties(dtoGestorEdificaciones, gestorEdificaciones);
				listaResponsables.add(dtoGestorEdificaciones);
			}
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		model.put("data", listaResponsables);
		
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPresupuestoById(Long id, ModelMap model){

		model.put("data", trabajoApi.getPresupuestoById(id));
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getRecargosProveedor(Long idTrabajo, ModelMap model){
		
		model.put("data", trabajoApi.getRecargosProveedor(idTrabajo));
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createRecargoProveedor(DtoRecargoProveedor recargoDto,@RequestParam Long idEntidad){
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.createRecargoProveedor(recargoDto, idEntidad);
			model.put("success", success);
		
	} catch (Exception e) {
		logger.error(e.getMessage());
		model.put("success", false);		
	}
	
	return createModelAndViewJson(model);
	
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveRecargoProveedor(DtoRecargoProveedor recargoDto){
		
		ModelMap model = new ModelMap();
		
		try {
		
			boolean success = trabajoApi.saveRecargoProveedor(recargoDto);
			model.put("success", success);	
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
	
	return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteRecargoProveedor(@RequestParam Long idRecargo){
		
		ModelMap model = new ModelMap();
		
		try {			
		
			boolean success = trabajoApi.deleteRecargoProveedor(idRecargo);
			model.put("success", success);	
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getProvisionesSuplidos(Long idTrabajo, ModelMap model){
		
		model.put("data", trabajoApi.getProvisionSuplidos(idTrabajo));
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createProvisionSuplido(DtoProvisionSuplido provisionSuplidoDto,@RequestParam Long idEntidad){
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.createProvisionSuplido(provisionSuplidoDto, idEntidad);
			model.put("success", success);
		
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
	
		return createModelAndViewJson(model);
	
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveProvisionSuplido(DtoProvisionSuplido provisionSuplidoDto){
		
		ModelMap model = new ModelMap();
		
		try {
		
			boolean success = trabajoApi.saveProvisionSuplido(provisionSuplidoDto);
			model.put("success", success);	
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
	
	return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteProvisionSuplido(@RequestParam Long idProvisionSuplido){
		
		ModelMap model = new ModelMap();
		
		try {			
		
			boolean success = trabajoApi.deleteProvisionSuplido(idProvisionSuplido);
			model.put("success", success);	
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoTrabajoFilter dtoTrabajoFilter, HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoTrabajoFilter.setStart(excelReportGeneratorApi.getStart());
		dtoTrabajoFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		@SuppressWarnings("unchecked")
		List<VBusquedaTrabajos> listaTrabajos = (List<VBusquedaTrabajos>) trabajoApi.findAll(dtoTrabajoFilter, genericAdapter.getUsuarioLogado()).getResults();
		
		ExcelReport report = new TrabajoExcelReport(listaTrabajos);

		excelReportGeneratorApi.generateAndSend(report, response);

	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosByProceso(Long idProceso, DtoTrabajoListActivos webDto, ModelMap model){

		try {

			Page page = trabajoAdapter.getListActivosByProceso(idProceso, webDto);
			if(!Checks.esNulo(page)) {
				model.put("data", page.getResults());
				model.put("totalCount", page.getTotalCount());
				model.put("success", true);
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	/**
	 * Inserta una lista de Trabajos Ejem: IP:8080/pfs/rest/trabajo
	 * HEADERS:
	 * Content-Type - application/json
	 * signature - sdgsdgsdgsdg
	 * 
	 * BODY:
	 * {"id":"111111113112","data": [{"idTrabajoWebcom": "1", "idActivoHaya": "0", "codTipoTrabajo": "03","codSubtipoTrabajo": "26", "fechaAccion": "2016-01-01T10:10:10", "idUsuarioRem": "1", "descripcion": "Descripción del trabajo", "idApiResponsable": "5045", "nombreContacto": "Contacto", "telefonoContacto": "987654321", "emailContacto": "prueba@dominio.es",  "descripcionContacto": "El contacto esta disponible de lunes a viernes de 8:00 a 14:00 horas.", "nombreRequiriente": "Nombre requiremente", "telefonoRequiriente": "987654321", "emailRequiriente": "prueba@dominio.es", "descripcionRequiriente": "Para contactar con el requirente preguntar por Juan.", "fechaHoraConcretaRequiriente": "2016-01-01T10:10:10",  "fechaTopeRequiriente": "2016-01-01T10:10:10", "urgentePrioridadRequiriente": true, "riesgoPrioridadRequiriente": true}]}	 *  
	 *
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/trabajo")
	public void saveTrabajosWS(ModelMap model, RestRequestWrapper request,HttpServletResponse response) {		
		TrabajoRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = null;
		JSONObject jsonFields = null;
		
		try {
			
			jsonFields = request.getJsonObject();
			jsonData = (TrabajoRequestDto) request.getRequestData(TrabajoRequestDto.class);
			List<TrabajoDto> listaTrabajoDto = jsonData.getData();			

			if(Checks.esNulo(jsonFields) && jsonFields.isEmpty()){
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				
			}else{
				listaRespuesta = trabajoApi.createTrabajos(listaTrabajoDto);			
				model.put("id", jsonFields.get("id"));	
				model.put("data", listaRespuesta);
				model.put("error", "null");
			}

		} catch (Exception e) {
			logger.error("Error trabajo", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));	
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			
		}

		restApi.sendResponse(response, model,request);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void createPropuestaPreciosFromTrabajo(DtoTrabajoFilter dtoTrabajoFilter, String nombrePropuesta, HttpServletRequest request, HttpServletResponse response) {
		
		DtoActivosTrabajoFilter dtoActivosTrabajo = new DtoActivosTrabajoFilter();
		dtoActivosTrabajo.setIdTrabajo(dtoTrabajoFilter.getIdTrabajo());
		
		PropuestaPrecio propuesta = preciosApi.createPropuestaPreciosFromTrabajo(Long.parseLong(dtoTrabajoFilter.getIdTrabajo()), nombrePropuesta);
		// Se genera excel unificada si se ha creado la propuesta
		if(!Checks.esNulo(propuesta))
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

			servicio.rellenarPlantilla(propuesta.getNumPropuesta().toString(), genericAdapter.getUsuarioLogado().getApellidoNombre(), preciosApi.getDatosPropuestaByEntidad(propuesta));
			
			excelReportGeneratorApi.sendReport(servicio.getFile(), response);
			preciosApi.guardarFileEnTrabajo(servicio.getFile(),propuesta.getTrabajo());
			servicio.vaciarLibros();
			
		} catch (IOException ex) {
			logger.error(ex.getMessage());
		} catch (IllegalAccessException ex) {
			logger.error(ex.getMessage());
		} catch (InvocationTargetException ex) {
			logger.error(ex.getMessage());
		}
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView comprobarCreacionPropuesta(@RequestParam Long idTrabajo, ModelMap model){
		
		String advertencia = preciosApi.puedeCreasePropuestaFromTrabajo(idTrabajo);
		if(Checks.esNulo(advertencia)) {		
			model.put("success", true);
		}
		else {
			model.put("mensaje", advertencia);
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView comprobarActivosEnOtrasPropuesta(@RequestParam Long idTrabajo, ModelMap model){
	
		String advertencia = preciosApi.tieneTrabajoActivosEnPropuestasEnTramitacion(idTrabajo);
		
		if(!Checks.esNulo(advertencia)) {
			model.put("advertencia", advertencia);
		}	
		model.put("success", true);
		
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void downloadTemplateActivosTrabajo(HttpServletRequest request, HttpServletResponse response) {

		try {
			trabajoApi.downloadTemplateActivosTrabajo(request,response,"LACT");
		} catch (Exception ex) {
			logger.error(ex.getMessage());
		}

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView recalcularParticipacion(@RequestParam Long idTrabajo, ModelMap model){

		try {
			updaterStateApi.recalcularParticipacion(idTrabajo);
			model.put("success", true);
		} catch (Exception ex) {
			logger.error(ex.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getSupervisorGestorTrabajo(Long idActivo, Long idAgrupacion, ModelMap model) {
		Map<String,Long> mapaGestorSupervisor= new HashMap<String, Long>();
		if(Checks.esNulo(idActivo) && Checks.esNulo(idAgrupacion)){
			mapaGestorSupervisor.put("GACT", genericAdapter.getUsuarioLogado().getId());
			mapaGestorSupervisor.put("SUPACT", genericAdapter.getUsuarioLogado().getId());
			model.put("data", mapaGestorSupervisor);
		}
		else{
			if(Checks.esNulo(idActivo) && !Checks.esNulo(idAgrupacion)){
				
				mapaGestorSupervisor=  trabajoApi.getSupervisorGestor(idAgrupacion);
				model.put("data", mapaGestorSupervisor);
				
			}
		}

		return new ModelAndView("jsonView", model);

	}
	
}