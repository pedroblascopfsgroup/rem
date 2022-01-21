package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
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
import org.springframework.transaction.annotation.Transactional;
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
import es.capgemini.pfs.config.ConfigManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activotrabajo.dao.ActivoTrabajoDao;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.adapter.TrabajoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.excel.ActivosTrabajoExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.TrabajoExcelReport;
import es.pfsgroup.plugin.rem.excel.TrabajoGridExcelReport;
import es.pfsgroup.plugin.rem.factory.GenerarPropuestaPreciosFactoryApi;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ACCION_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ENTIDAD_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.REQUEST_STATUS_CODE;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.AuditoriaExportaciones;
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
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoParticipa;
import es.pfsgroup.plugin.rem.model.VBusquedaTrabajos;
import es.pfsgroup.plugin.rem.model.VGridBusquedaTrabajos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.propuestaprecios.service.GenerarPropuestaPreciosService;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.TareaRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.TrabajoDto;
import es.pfsgroup.plugin.rem.rest.dto.TrabajoRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.TrabajoRespuestaDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoAgendaTrabajo;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoGridFilter;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.utils.EmptyParamDetector;
import net.sf.json.JSONObject;



@Controller
public class TrabajoController extends ParadiseJsonController {
			
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private AgendaAdapter agendaAdapter;

	@Autowired
	private GenericAdapter genericAdapter;
	

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
	private LogTrustEvento trustMe;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private TrabajoDao trabajoDao;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoTrabajoDao activoTrabajoDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ProveedoresDao proveedoresDao;

	@Autowired
	private UsuarioManager usuarioManager;

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ConfigManager configManager;
	
	@Resource
	private Properties appProperties;
	
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";

	private static final String ERROR_DUPLICADOS_CREAR_TRABAJOS = "El fichero contiene registros duplicados";
	private static final String ERROR_GD_NO_EXISTE_CONTENEDOR = "No existe contenedor para este trabajo. Se creará uno nuevo.";
	private static final String COMBO_MODIFICACION_NO = "02";
	private static final String DOC_FINALIZACION_TRABAJO = "Para la finalizacion es necesario adjuntar: ";
	
	public static final String ERROR_TRABAJO_NOT_EXISTS = "No existe el trabajo que esta buscando, pruebe con otro Nº de Trabajo";
	public static final String ERROR_TRABAJO_NO_NUMERICO = "El campo introducido es de carácter numérico";
	public static final String ERROR_GENERICO = "La operación no se ha podido realizar";

		
	/**
	 * Método que recupera un trabajo según su id y lo mapea a un DTO
	 * @param id Id del trabajo
	 * @param pestana Pestaña del trabajo a cargar. Dependiendo de la pestaña recibida, cargará un DTO u otro
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findOne(Long id,String pestana, ModelMap model, HttpServletRequest request){

		model.put("data", trabajoApi.getTrabajoById(id, pestana));
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "ficha", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findAll(DtoTrabajoFilter dtoTrabajoFilter, ModelMap model){
		if(activoDao.isActivoMatriz(dtoTrabajoFilter.getIdActivo())) {
			ActivoAgrupacion actgagru = activoDao.getAgrupacionPAByIdActivo(dtoTrabajoFilter.getIdActivo());
			Activo activoM = activoApi.get(activoDao.getIdActivoMatriz(actgagru.getId()));
			dtoTrabajoFilter.setIdActivo(activoM.getId());
		}
		try {
			Page page = trabajoApi.findAll(dtoTrabajoFilter, genericAdapter.getUsuarioLogado());
			
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getBusquedaTrabajosGrid(DtoTrabajoGridFilter dto, ModelMap model){	
		try {
			Page page = trabajoApi.getBusquedaTrabajosGrid(dto, genericAdapter.getUsuarioLogado());			
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
		}		
		return createModelAndViewJson(model);		
	}
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFichaTrabajo(ModelMap model, DtoFichaTrabajo dtoTrabajo, @RequestParam Long id, HttpServletRequest request){
		try {
			Boolean success = trabajoApi.saveFichaTrabajo(dtoTrabajo, id);
			model.put("success", success);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "trabajo", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
		} catch(Exception e) {
			logger.error(e.getMessage());
			model.put("error", e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "trabajo", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveGestionEconomicaTrabajo(DtoGestionEconomicaTrabajo dtoGestionEconomica, @RequestParam Long id, HttpServletRequest request){
		
		ModelMap model = new ModelMap();
		boolean success = false;
		
		try {
			success = trabajoApi.saveGestionEconomicaTrabajo(dtoGestionEconomica, id);
			model.put("success", success);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "gestionEconomica", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
		} catch(Exception e) {
			logger.error(e.getMessage());
			model.put("error", e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "gestionEconomica", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView create(DtoFichaTrabajo dtoTrabajo){

		boolean success = false;
		
		ModelMap model = new ModelMap();

		try {
			
			Long idTrabajo = trabajoApi.create(dtoTrabajo);
			if(new Long(-1L).equals(idTrabajo))
				model.put("warn", "Proceso de creación trabajos en ejecución, espere uno o dos minutos y refresque los trabajos.");
			else
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
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			
			String errores = trabajoApi.upload(webFileItem);			

			model.put("errorMessage", errores);
			model.put("success", errores==null);
		
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);
			model.put("errorMessage", e.getCause());
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
		String nombreDocumento = request.getParameter("nombreDocumento");
		dtoAdjunto.setNombre(nombreDocumento);
		
       	FileItem fileItem = trabajoApi.getFileItemAdjunto(dtoAdjunto);
		
       	try { 

       		if(!Checks.esNulo(fileItem)) {
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
       		}
       		
       	} catch (Exception e) { 
       		logger.error(e.getMessage(),e);
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
	public ModelAndView getListAdjuntos(Long id, ModelMap model, HttpServletRequest request){

		try {
			model.put("data", trabajoApi.getAdjuntos(id));
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "adjuntos", ACCION_CODIGO.CODIGO_VER);

		} catch(GestorDocumentalException gex) {
			logger.info(ERROR_GD_NO_EXISTE_CONTENEDOR);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "adjuntos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		} catch(Exception ex) {
			logger.error(ex.getMessage());
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "adjuntos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivos(DtoActivosTrabajoFilter dto, HttpServletRequest request){
		ModelMap model = new ModelMap();
		try {
			Page page = trabajoApi.getListActivos(dto);
			Trabajo tbj = genericDao.get(Trabajo.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.parseLong(dto.getIdTrabajo())));
			Float participacion = activoTrabajoDao.getImporteParticipacionTotal(tbj.getNumTrabajo());
			model.put("participacion", participacion);
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);		
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSeleccionTarifasTrabajo(DtoGestionEconomicaTrabajo dto,String cartera, String tipoTrabajo, String subtipoTrabajo
			, String codigoTarifa, String descripcionTarifa, String subcarteraCodigo){

		DtoPage page = trabajoApi.getSeleccionTarifasTrabajo(dto, cartera, tipoTrabajo, subtipoTrabajo, codigoTarifa, descripcionTarifa,subcarteraCodigo);
		
		ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTarifasTrabajo(DtoGestionEconomicaTrabajo dto, @RequestParam Long idTrabajo, HttpServletRequest request){

		DtoPage page = trabajoApi.getTarifasTrabajo(dto, idTrabajo);
		
		ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());
		trustMe.registrarSuceso(request, idTrabajo, ENTIDAD_CODIGO.CODIGO_TRABAJO, "tarifas", ACCION_CODIGO.CODIGO_VER);
		
		return createModelAndViewJson(model);
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPresupuestosTrabajo(DtoGestionEconomicaTrabajo dto, @RequestParam Long idTrabajo, HttpServletRequest request){
		ModelMap model = new ModelMap();
		try{
			DtoPage page = trabajoApi.getPresupuestosTrabajo(dto, idTrabajo);
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);
			trustMe.registrarSuceso(request, idTrabajo, ENTIDAD_CODIGO.CODIGO_TRABAJO, "presupuestos", ACCION_CODIGO.CODIGO_VER);
		}catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createTarifaTrabajo(DtoTarifaTrabajo tarifaDto,@RequestParam Long idTrabajo){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.createTarifaTrabajo(tarifaDto, idTrabajo);
			model.put("success", success);
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
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
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
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
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
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
		
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
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
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
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
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
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
		
		if(page == null) {
			model.put("data", null);
			model.put("totalCount", 0);
		}else {
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
		}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramitesTareas(Long idTrabajo, WebDto webDto, ModelMap model, HttpServletRequest request){
		
		List<DtoListadoTramites> tramites = trabajoAdapter.getListadoTramitesTareasTrabajo(idTrabajo, webDto);
		
		// TODO Cambiar si finalmente es posible que un trababjo tenga más de un trámite
		DtoListadoTramites tramite = new DtoListadoTramites(); 
		if(!Checks.estaVacio(tramites)) {
			tramite = tramites.get(0);
		}
		
		model.put("tramite", tramite);
		trustMe.registrarSuceso(request, idTrabajo, ENTIDAD_CODIGO.CODIGO_TRABAJO, "tramitesTareas", ACCION_CODIGO.CODIGO_VER);

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
	public ModelAndView getObservaciones(DtoTrabajoFilter dto, HttpServletRequest request){
		
		DtoPage page = trabajoApi.getObservaciones(dto);
		
		ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());
		trustMe.registrarSuceso(request, Long.parseLong(dto.getIdTrabajo()), ENTIDAD_CODIGO.CODIGO_TRABAJO, "observaciones", ACCION_CODIGO.CODIGO_VER);

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
		
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_TRABAJO, "fotos", ACCION_CODIGO.CODIGO_VER);
		
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
	public ModelAndView uploadFotos(HttpServletRequest request, HttpServletResponse response)
		throws Exception {
		
		ModelMap model = new ModelMap();
		
		try {
			List<WebFileItem> webFileItemList = uploadAdapter.getWebMultipleFileItem(request);
			
			String errores = trabajoApi.uploadFotos(webFileItemList);			

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
	public ModelAndView refreshCacheFotos(@RequestParam Long id, ModelMap model) {
		try {
			boolean success = trabajoAdapter.deleteCacheFotosTrabajo(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("error",e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAdvertenciaCrearTrabajo(@RequestParam Long idActivo, @RequestParam Long idAgrupacion, @RequestParam String codigoSubtipoTrabajo, ModelMap model){
		
		String advertencia="";
		
		
		advertencia = trabajoAdapter.getAdvertenciaCreacionTrabajo(idActivo, idAgrupacion, codigoSubtipoTrabajo);			

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
	public ModelAndView getComboProveedorFilteredCreaTrabajo(String cartera, WebDto webDto, ModelMap model) {
		
		model.put("data", trabajoApi.getComboProveedorFilteredCreaTrabajo(cartera));
		model.put("success", true);

		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoProveedorFiltered(Long idTrabajo, ModelMap model) {
		
		model.put("data", trabajoApi.getComboTipoProveedorFiltered(idTrabajo));
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedorContactoCreaTrabajo(Long idProveedor, WebDto webDto, ModelMap model) {
			
			try {
				model.put("data", trabajoApi.getComboProveedorContacto(idProveedor));
				model.put("success", true);
			} catch (Exception e) {
				model.put("success", false);
				model.put("msg", "Se ha producido un error al ejecutar la petición.");
				logger.error("error obteniendo contactos",e);
			}
			model.put("success", true);

			return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedorContacto(Long idProveedor, ModelMap model) {
		try{
			
			model.put("data", trabajoApi.getComboProveedorContacto(idProveedor));
			model.put("success", true);
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("msg", e.getMessage());
			
		} catch (Exception e) {
			model.put("success", false);
			model.put("msg", "Se ha producido un error al ejecutar la petición.");
			logger.error("error obteniendo contactos",e);
		}
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedorContactoLlaves(Long idProveedor, ModelMap model) {
		try{
			
			model.put("data", trabajoApi.getComboProveedorContactoLlaves(idProveedor));
			model.put("success", true);
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("msg", e.getMessage());
			
		} catch (Exception e) {
			model.put("success", false);
			model.put("msg", "Se ha producido un error al ejecutar la petición.");
			logger.error("error obteniendo contactos",e);
		}
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedorFiltradoManual(Long idTrabajo, ModelMap model){
		
		try {
			model.put("data", trabajoApi.getComboProveedor(idTrabajo));
			model.put("success", true);
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("msg", e.getMessage());
			
		} catch (Exception e) {
			model.put("success", false);
			model.put("msg", "Se ha producido un error al ejecutar la petición.");
			logger.error("error obteniendo proveedores",e);
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
		Usuario responsableTrabajo = trabajo.getUsuarioResponsableTrabajo();
				
		List<DtoUsuario> listaResponsables = new ArrayList<DtoUsuario>();
		
		DtoUsuario dtoGestorActivo = new DtoUsuario();
		DtoUsuario dtoGestorAlquileres = new DtoUsuario();
		DtoUsuario dtoGestorSuelos = new DtoUsuario();
		DtoUsuario dtoGestorEdificaciones = new DtoUsuario();
		DtoUsuario dtoMultiActivo = new DtoUsuario();

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
			if (responsableTrabajo != null && trabajo.getActivosTrabajo().size() > 1 
					&& !responsableTrabajo.equals(gestorSuelos)
					&& !responsableTrabajo.equals(gestorAlquileres)
					&& !responsableTrabajo.equals(gestorActivo)
					&& !responsableTrabajo.equals(gestorEdificaciones)) {			
				BeanUtils.copyProperties(dtoMultiActivo, responsableTrabajo);
				listaResponsables.add(dtoMultiActivo);
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
	public ModelAndView getRecargosProveedor(Long idTrabajo, ModelMap model, HttpServletRequest request){
		
		model.put("data", trabajoApi.getRecargosProveedor(idTrabajo));
		trustMe.registrarSuceso(request, idTrabajo, ENTIDAD_CODIGO.CODIGO_TRABAJO, "recargosProveedor", ACCION_CODIGO.CODIGO_VER);

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
	public ModelAndView getProvisionesSuplidos(Long idTrabajo, ModelMap model, HttpServletRequest request){
		
		model.put("data", trabajoApi.getProvisionSuplidos(idTrabajo));
		trustMe.registrarSuceso(request, idTrabajo, ENTIDAD_CODIGO.CODIGO_TRABAJO, "provisionesSuplidos", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createProvisionSuplido(DtoProvisionSuplido provisionSuplidoDto,@RequestParam Long idEntidad){
		ModelMap model = new ModelMap();
		
		try {
			boolean success = trabajoApi.createProvisionSuplido(provisionSuplidoDto, idEntidad);
			model.put("success", success);
		
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
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
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
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
			
		} catch (JsonViewerException e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoTrabajoGridFilter dto, HttpServletRequest request, HttpServletResponse response) throws Exception {
		dto.setStart(excelReportGeneratorApi.getStart());
		dto.setLimit(excelReportGeneratorApi.getLimit());
		
		List<VGridBusquedaTrabajos> listaTrabajos = (List<VGridBusquedaTrabajos>) trabajoApi.getBusquedaTrabajosGrid(dto, genericAdapter.getUsuarioLogado()).getResults();		
		new EmptyParamDetector().isEmpty(listaTrabajos.size(), "trabajos",  usuarioManager.getUsuarioLogado().getUsername());		
		ExcelReport report = new TrabajoGridExcelReport(listaTrabajos);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	@Transactional()
	public ModelAndView registrarExportacion(DtoTrabajoGridFilter dto, Boolean exportar, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String intervaloTiempo = !Checks.esNulo(appProperties.getProperty("haya.tiempo.espera.export")) ? appProperties.getProperty("haya.tiempo.espera.export") : "300000";
		ModelMap model = new ModelMap();		 
		Boolean isSuperExport = false;
		Boolean permitido = true;
		String filtros = parameterParser(request.getParameterMap());
		Usuario user = usuarioManager.getUsuarioLogado();
		Long tiempoPermitido = System.currentTimeMillis() - Long.parseLong(intervaloTiempo);
		String cuentaAtras = null;
		try {
			Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", user.getId());
			Filter filtroConsulta = genericDao.createFilter(FilterType.EQUALS, "filtros", filtros);
			Filter filtroAccion = genericDao.createFilter(FilterType.EQUALS, "accion", true);
			Order orden = new Order(OrderType.DESC, "fechaExportacion");
			List<AuditoriaExportaciones> listaExportaciones =  genericDao.getListOrdered(AuditoriaExportaciones.class, orden, filtroUsuario, filtroConsulta, filtroAccion);
			
			if(listaExportaciones != null && !listaExportaciones.isEmpty()) {
				Long ultimaExport = listaExportaciones.get(0).getFechaExportacion().getTime();
				permitido = ultimaExport > tiempoPermitido ? false : true;

				double entero = Math.floor((ultimaExport - tiempoPermitido)/60000);
		        if (entero < 2) {
		        	cuentaAtras = "un minuto";
		        } else {
		        	cuentaAtras = Double.toString(entero);
		        	cuentaAtras = cuentaAtras.substring(0, 1) + " minutos";
		        }
			}
			
			if(permitido) {
				int count = trabajoApi.getBusquedaTrabajosGrid(dto, genericAdapter.getUsuarioLogado()).getTotalCount();
				AuditoriaExportaciones ae = new AuditoriaExportaciones();
				ae.setBuscador("trabajos");
				ae.setFechaExportacion(new Date());
				ae.setNumRegistros(Long.valueOf(count));
				ae.setUsuario(user);
				ae.setFiltros(filtros);
				ae.setAccion(exportar);
				genericDao.save(AuditoriaExportaciones.class, ae);
				model.put(RESPONSE_SUCCESS_KEY, true);
				model.put(RESPONSE_DATA_KEY, count);
				for(Perfil pef : user.getPerfiles()) {
					if(pef.getCodigo().equals("SUPEREXPORTTBJ")) {
						isSuperExport = true;
						break;
					}
				}
				if(isSuperExport) {
					model.put("limite", configManager.getConfigByKey("super.limite.exportar.excel.trabajos").getValor());
					model.put("limiteMax", configManager.getConfigByKey("super.limite.maximo.exportar.excel.trabajos").getValor());
				}else {
					model.put("limite", configManager.getConfigByKey("limite.exportar.excel.trabajos").getValor());
					model.put("limiteMax", configManager.getConfigByKey("limite.maximo.exportar.excel.trabajos").getValor());
				}
			} else {
				model.put("msg", cuentaAtras);
			}
		}catch(Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en trabajoController", e);
		}
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("rawtypes")
	private String parameterParser(Map map) {
		StringBuilder mapAsString = new StringBuilder("{");
	    for (Object key : map.keySet()) {
	    	if(!key.toString().equals("buscador") && !key.toString().equals("exportar"))
	    		mapAsString.append(key.toString() + "=" + ((String[])map.get(key))[0] + ",");
	    }
	    mapAsString.delete(mapAsString.length()-1, mapAsString.length());
	    if(mapAsString.length()>0)
	    	mapAsString.append("}");
	    return mapAsString.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView subeListaActivos(HttpServletRequest request, HttpServletResponse response){
		ModelMap model = new ModelMap();
		Page page = null;
		
		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			
			page = trabajoAdapter.getListActivosBySubidaExcel(webFileItem);
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
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosByID(String idActivo, Long idAgrupacion, DtoTrabajoListActivos webDto, ModelMap model) {
		
		if((idActivo == null || idActivo.equals("")) && idAgrupacion == null) {
			model.put("success", false);
		}else {
			if(idAgrupacion != null) {
				Page page = trabajoAdapter.getListActivosCrearTrabajoByAgrupacion(idAgrupacion, webDto);
				
				model.put("data", page.getResults());
				model.put("totalCount", page.getTotalCount());
				model.put("success", true);
			}else {
				try {
					
					Page page = trabajoAdapter.getListActivosById(idActivo,webDto);
					model.put("data", page.getResults());
					model.put("totalCount", page.getTotalCount());
					model.put("success", true);
				} catch (Exception e) {
					logger.error(e.getMessage());
					model.put("success", false);
				}
			}			
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
	@RequestMapping(method = RequestMethod.POST)
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
			if (jsonFields != null) {
				model.put("id", jsonFields.get("id"));
			}
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
		Map<String, Long> mapaGestorSupervisor = new HashMap<String, Long>();
		if (Checks.esNulo(idActivo) && Checks.esNulo(idAgrupacion)) {
			mapaGestorSupervisor.put("GACT", genericAdapter.getUsuarioLogado().getId());
			mapaGestorSupervisor.put("SUPACT", genericAdapter.getUsuarioLogado().getId());
			model.put("data", mapaGestorSupervisor);
		} else {
			if (Checks.esNulo(idActivo) && !Checks.esNulo(idAgrupacion)) {

				mapaGestorSupervisor = trabajoApi.getSupervisorGestor(idAgrupacion);
				model.put("data", mapaGestorSupervisor);

			}
		}

		return new ModelAndView("jsonView", model);

	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboEstadoSegunEstadoGdaOProveedor(Long idTrabajo, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, trabajoApi.getComboEstadoSegunEstadoGdaOProveedor(idTrabajo));

		return new ModelAndView("jsonView", model);
	}

	/**
	 * En base a un número de activo y un código de proveedor, devuelve un listado
	 * de los trabajos pendientes para ese par, e indica el listado de activos sobre
	 * el que aplica el trabajo
	 * 
	 * Petición GET
	 * HEADERS: 
	 * Content-Type: application/json 
	 * signature: token01
	 * idPeticion: 01
	 * 
	 * @param numActivo
	 * @param idProveedorRem
	 * @param model
	 * @param request
	 * @param response
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET, value = "/trabajo/getActuacionesTecnicas")
	public void getActuacionesTecnicas(String id, String numActivo, String idProveedorRem, ModelMap model, RestRequestWrapper request,HttpServletResponse response) {
		Boolean flagnumActivoNoExiste = false;
		Boolean flagidProveedorRemNoExiste = false;
		Boolean flagActivoProveedorRelacionNoExiste = false;
		Boolean flagParametrosANulo = false;
		Long numActivoL = null;
		Long idL = null;
		String error = null;
		String errorDesc = null;
		ArrayList<TrabajoRespuestaDto> actuaciones = new ArrayList<TrabajoRespuestaDto>();
		List<ActivoTrabajo> activosTrabajo = new ArrayList<ActivoTrabajo>();
		if(Checks.esNulo(id) || Checks.esNulo(numActivo) || Checks.esNulo(idProveedorRem)) {
			flagParametrosANulo = true;
		}else{
			try {
				idL = Long.valueOf(id);
			}catch(Exception e){
				logger.error("Error trabajo", e);
				request.getPeticionRest().setErrorDesc(e.getMessage());
				model.put("id", id);
				model.put("error", RestApi.REST_MSG_FORMAT_ERROR );
				model.put("errorDesc", "La id no tiene el formato adecuado" );
				model.put("success", false);
			}
			if(!Checks.esNulo(idL)) {
				try {
					numActivoL = Long.valueOf(numActivo);
				}catch(Exception e){
					logger.error("Error trabajo", e);
					request.getPeticionRest().setErrorDesc(e.getMessage());
					model.put("id", id);
					model.put("error", RestApi.REST_MSG_FORMAT_ERROR );
					model.put("errorDesc", "El numero de activo no tiene el formato adecuado" );
					model.put("success", false);
				}
				if(!Checks.esNulo(numActivoL)) {
					DtoTrabajoFilter filtro = new DtoTrabajoFilter();
					filtro.setNumActivo(numActivoL);
					filtro.setLimit(100);
					filtro.setIsOrigenActuacionesTecnicas(true);
					filtro.setProveedor(idProveedorRem);
					if(Checks.esNulo(activoDao.getActivoByNumActivo(numActivoL))){
						flagnumActivoNoExiste = true;
					}else if(Checks.esNulo(proveedoresDao.getActivoProveedorContactoPorUsernameUsuario(idProveedorRem))){
						flagidProveedorRemNoExiste = true;
					}else{
					
						Page page = trabajoApi.findAll(filtro, genericAdapter.getUsuarioLogado());
				
						
						TrabajoRespuestaDto actuacion;
				
						// Recuperar lista de trabajos por activo
						for (Object obj : page.getResults()) {
							Trabajo trabajo = (Trabajo) obj;
				
							// Comprobación de criterios y generar listado
							try {
								
								if (trabajo.getProveedorContacto().getUsuario().getUsername().equals(idProveedorRem)
										&& DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(trabajo.getTipoTrabajo().getCodigo())) {
				
									activosTrabajo = trabajo.getActivosTrabajo();
				
									if(!Checks.estaVacio(activosTrabajo)) {
										actuacion = new TrabajoRespuestaDto();
										List<Long> activosLista = new ArrayList<Long>();
				
										for (ActivoTrabajo activoTrabajo : activosTrabajo) {
											Activo activo = activoTrabajo.getActivo();
				
											if (!Checks.esNulo(activo)) {
												activosLista.add(activo.getNumActivo());
											}
										}
				
										actuacion.setNumActivo(activosLista);
										actuacion.setNumTrabajo(trabajo.getNumTrabajo());
										actuacion.setFechaRealizacion(trabajo.getFechaEjecucionReal());
										actuacion.setFechaExacta(!Checks.esNulo(trabajo.getFechaHoraConcreta()));
										actuacion.setUrgentePrioridadReq(trabajo.getUrgente());
										// En la ficha HREOS-6228 indican que requiriente corresponde a Tercero y su relación con los campos
										actuacion.setNombreRequiriente(trabajo.getTerceroNombre());
										actuacion.setTelefonoRequiriente(trabajo.getTerceroTel1());
										actuacion.setEmailRequiriente(trabajo.getTerceroEmail());
										actuacion.setDescripcionRequiriente(trabajo.getTerceroContacto()); 
										actuacion.setRiesgoPrioridadReq(trabajo.getRequerimiento());
										actuacion.setFechaPrioridadReq(trabajo.getFechaCompromisoEjecucion());// ACT_TBJ_TRABAJO.TBJ_FECHA_FIN_COMPROMISO
				
										// En la ficha HREOS-6228 indican que mediador se corresponde a contacto
										ActivoProveedorContacto mediador = trabajo.getProveedorContacto();
										if (mediador != null) {
											actuacion.setNombreContacto(mediador.getNombre());
											actuacion.setTelefonoContacto(mediador.getTelefono1());
											actuacion.setEmailContacto(mediador.getEmail());
											actuacion.setDescripcionContacto(mediador.getObservaciones());
				
										}
										actuaciones.add(actuacion);
									}
				
								} // fin trabajo
				
							} catch (NullPointerException e) {
								logger.error("Error trabajo", e);
							}
						}
						
			
					} // fin listado trabajos
					if(Checks.estaVacio(activosTrabajo)) {
						flagActivoProveedorRelacionNoExiste = true;
					}
				}
			}
		}
		
		//El id, tanto en el try como en el catch, lo debe devolver siempre
		try {
			if(flagParametrosANulo) {
				if((Checks.esNulo(id)&&Checks.esNulo(numActivo)) || (Checks.esNulo(id) && Checks.esNulo(idProveedorRem)) || (Checks.esNulo(numActivo) && Checks.esNulo(idProveedorRem))) {
					error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
					errorDesc = "Faltan campos necesiarios";
					throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				}else {
					error = RestApi.REST_NO_PARAM;
					if(Checks.esNulo(id)) {
						errorDesc = "Falta el campo id";
					}else if(Checks.esNulo(numActivo)) {
						errorDesc = "Falta el campo numActivo";
					}else {
						errorDesc = "Falta el campo idProveedorRem";
					}
					throw new Exception(RestApi.REST_NO_PARAM);
				}
			}
			if(flagnumActivoNoExiste || flagidProveedorRemNoExiste) {
				error = RestApi.REST_MSG_UNKNOW_KEY;
				if(flagnumActivoNoExiste) {
					errorDesc ="El Activo " + numActivo + " no existe.";
				}else{
					errorDesc = "El proveedor " + idProveedorRem + " no existe.";
				}
				throw new Exception(RestApi.REST_MSG_UNKNOW_KEY);
			}
			if(flagActivoProveedorRelacionNoExiste) {
				error = RestApi.REST_MSG_NO_RELATED_AT;
				errorDesc = "No existe actuación técnica relacionada entre el activo "+ numActivo +" y la proveedor " + idProveedorRem;
				
				throw new Exception(RestApi.REST_MSG_NO_RELATED_AT);
			}
			if(!Checks.esNulo(idL) && !Checks.esNulo(numActivoL)) {
				model.put("id", 0);
				model.put("id", id);
				model.put("data", actuaciones);
				model.put("error", "null");
				model.put("success", true);
			}
			
		} catch (Exception e) {
			logger.error("Error trabajo", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", id);
			model.put("error", error);
			model.put("errorDesc", errorDesc);
			model.put("success", false);
		}
		restApi.sendResponse(response, model, request);
	}
	
	/**
	 * Avanza trabajos Ejem: IP:8080/pfs/rest/trabajo/avanzaTrabajo
	 * HEADERS: Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"1234","tbjNumTrabajo":"4271073","codTarea":"T013_PosicionamientoYFirma","data": {"observaciones":["asdasdasd"], 
	 *  "comboConflicto": ["02"], 
	 *	"comboRiesgo":["02"], 
	 *	"comite":["29"],
	 *	"fechaEnvio":["2019-05-09"],
	 *	"numExpediente":["164698"], 
	 *	"comiteSuperior":["02"]}}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	
	@RequestMapping(method = RequestMethod.POST, value = "/trabajo/avanzaTrabajo")
	public void avanzaTrabajo( ModelMap model, RestRequestWrapper request, HttpServletResponse response){
		TareaRequestDto jsonData = null;
		Map<String, String[]> datosTarea = new HashMap<String, String[]>();
		JSONObject jsonFields = null;
		Long tareaId = null;
		String id = null;
		String codTarea = "";
		String numTrabajo = "";
		boolean resultado = false;
		String error = null;
		String errorDesc = null;
		
		try {
			jsonFields = request.getJsonObject();
			jsonData = (TareaRequestDto) request.getRequestData(TareaRequestDto.class);
			
			if(Checks.esNulo(jsonFields) || jsonFields.isNullObject() || jsonFields.isEmpty() || Checks.esNulo(jsonData) || Checks.esNulo(jsonData.getId()) || Checks.esNulo(jsonData.getData())) {
				error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
				errorDesc = "Faltan campos";
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				
			}else {
				
				id = jsonData.getId();
				datosTarea = jsonData.getData();
				if(Checks.esNulo(jsonFields.get("id"))){
					error = RestApi.REST_NO_PARAM;
					errorDesc = "Falta el id de llamada.";
					throw new Exception(RestApi.REST_NO_PARAM);					
				}
				try {
					Long.valueOf(id);
				}catch(Exception e){
					error = RestApi.REST_MSG_FORMAT_ERROR;
					errorDesc = "El formato el id no es el correcto.";
					throw new Exception(RestApi.REST_MSG_FORMAT_ERROR);
				}
				if(Checks.esNulo(jsonFields.get("codTarea"))){
					error = RestApi.REST_NO_PARAM;
					errorDesc = "Falta el codigo de la tarea.";
					throw new Exception(RestApi.REST_NO_PARAM);					
				}
				if(!Checks.esNulo(jsonFields.get("tbjNumTrabajo"))) {
					numTrabajo  = jsonFields.get("tbjNumTrabajo").toString();
				}else {
					error = RestApi.REST_NO_PARAM;
					errorDesc = "Falta el numero del trabajo.";
					throw new Exception(RestApi.REST_NO_PARAM);
				}
				try {
					Long.valueOf(numTrabajo);
				}catch(Exception e){
					error = RestApi.REST_MSG_FORMAT_ERROR;
					errorDesc = "El formato el número de trabajo no es el correcto.";
					throw new Exception(RestApi.REST_MSG_FORMAT_ERROR);
				}
				if(Checks.esNulo(trabajoApi.getTrabajoByNumeroTrabajo(Long.valueOf(numTrabajo)))){
					
					error = RestApi.REST_MSG_UNKNOW_JOB;
					errorDesc = "El trabajo " + numTrabajo + " no existe.";
					throw new Exception(RestApi.REST_MSG_UNKNOW_JOB);
				}else {
					if(!Checks.esNulo(jsonFields.get("codTarea"))) {
						codTarea  = jsonFields.get("codTarea").toString();
					}
					tareaId = trabajoApi.getIdTareaBytbjNumTrabajoAndCodTarea(Long.parseLong(numTrabajo), codTarea);
					if(Checks.esNulo(tareaId)) {
						error = RestApi.REST_MSG_VALIDACION_TAREA;
						errorDesc = "La tarea " + codTarea + " no existe.";
						throw new Exception(RestApi.REST_MSG_VALIDACION_TAREA);
						
					}else {
						jsonFields.get("data");
						jsonFields.getJSONObject("data").get("fechaAtPrimaria");
						String comboModificacion = null;
						if(!Checks.esNulo(jsonFields.getJSONObject("data").get("comboModificacion"))) {
							comboModificacion = jsonFields.getJSONObject("data").get("comboModificacion").toString();
							comboModificacion = comboModificacion.substring(2,comboModificacion.length()-2);
						}
					
						if(Checks.esNulo(jsonFields.getJSONObject("data").get("fechaAtPrimaria"))){
							error = RestApi.REST_NO_PARAM;
							errorDesc = "Falta la fecha de at primaria.";
							throw new Exception(RestApi.REST_NO_PARAM);
							
						}else if(!Checks.esNulo(comboModificacion) && COMBO_MODIFICACION_NO.equalsIgnoreCase(comboModificacion) 
								&& Checks.esNulo(jsonFields.getJSONObject("data").get("fechaFinalizacion"))) {
							error = RestApi.REST_NO_PARAM;
							errorDesc = "Falta la fecha de finalización.";
							throw new Exception(RestApi.REST_NO_PARAM);
							
						}						
						SimpleDateFormat format  = new SimpleDateFormat("dd/MM/yyyy");
						format.setLenient(false);
						Date atprimaria = null;
						String stringAtprimaria = jsonFields.getJSONObject("data").get("fechaAtPrimaria").toString();
						stringAtprimaria =stringAtprimaria.substring(2,stringAtprimaria.length()-2);
						try {
							atprimaria = format.parse(stringAtprimaria);

						} catch (Exception ex) {
							error = RestApi.REST_MSG_FORMAT_ERROR;
							errorDesc = "El formato de la fecha de at primaria no es correcto.";
							throw new Exception(RestApi.REST_MSG_FORMAT_ERROR);
							
						}
						Date finalizacion = null;
						if(!Checks.esNulo(jsonFields.getJSONObject("data").get("fechaFinalizacion"))) {
							String stringFinalizacion = jsonFields.getJSONObject("data").get("fechaFinalizacion").toString();
							stringFinalizacion =stringFinalizacion.substring(2,stringFinalizacion.length()-2);
							try {
								finalizacion = format.parse(stringFinalizacion);
							} catch (Exception ex) {
								error = RestApi.REST_MSG_FORMAT_ERROR;
								errorDesc = "El formato de la fecha de finalización no es correcto.";
								throw new Exception(RestApi.REST_MSG_FORMAT_ERROR);
							}
						}
						String[] idTarea = new String[1];
						idTarea[0] = tareaId.toString();
						datosTarea.put("idTarea",idTarea);
		
						
						error = RestApi.REST_MSG_VALIDACION_TAREA;
						errorDesc = "Fallo al avanzar la tarea.";
						
						resultado = agendaAdapter.validationAndSave(datosTarea);
						
						if(!resultado) {
							error = RestApi.REST_MSG_VALIDACION_TAREA;
							errorDesc = "Error al avanzar la " + codTarea + ".";
							throw new Exception(RestApi.REST_MSG_VALIDACION_TAREA);
						}
							
						model.put("id", id);
						model.put("data", resultado);
						model.put("success", true);
						
					}
				}
			}

			//El id, tanto en el try como en el catch, lo debe devolver siempre
		} catch (Exception e) {
			logger.error("Error avance tarea ", e);
			if(!Checks.esNulo(e.getMessage())) {
				errorDesc = errorDesc+" "+e.getMessage();
			}
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", id);
			model.put("error", error);
			model.put("errorDesc", errorDesc);
			model.put("success", false);
		}

		restApi.sendResponse(response, model, request);
		
	}
	

	@RequestMapping(method = RequestMethod.GET)
	//public ModelAndView getHistoricoDeCampos(DtoHistorificadorCampos dto, ModelMap model) {
	public ModelAndView getHistoricoDeCampos(Long idTrabajo, String codPestanya, ModelMap model) {	

		
		/*ModelMap model = new ModelMap();
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());*/
		try {

			DtoPage page = trabajoApi.getListHistoricoDeCampos(idTrabajo, codPestanya);
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboAprobacionComite(WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, trabajoApi.getComboAprobacionComite());

		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAgendaTrabajo(Long idTrabajo, WebDto webDto, ModelMap model) {
		
		try {
			model.put("data", trabajoApi.getListAgendaTrabajo(idTrabajo));
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createAgendaTrabajo(DtoAgendaTrabajo agendaTrabajo, Long idTrabajo){
		
		ModelMap model = new ModelMap();
		
		agendaTrabajo.setIdTrabajo(idTrabajo);
		
		try {
			boolean success = trabajoApi.createAgendaTrabajo(agendaTrabajo);
			model.put("success", success);			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAgendaTrabajo(@RequestParam Long id){
		
		ModelMap model = new ModelMap();
		
		try {

			boolean success = trabajoApi.deleteAgendaTrabajo(id);
			model.put("success", success);
		
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboEstadoTrabajo(WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, trabajoApi.getComboEstadoTrabajo());

		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelActivosTrabajo(Long idTrabajo, HttpServletRequest request, HttpServletResponse response) throws IOException{

		List<VBusquedaActivosTrabajoParticipa> listaActivos = trabajoApi.getListActivosTrabajo(idTrabajo);

		ExcelReport report = new ActivosTrabajoExcelReport(listaActivos);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getPlazoEjecucion(String tipoTrabajo, String subtipoTrabajo,String cartera, String subCartera, WebDto webDto, ModelMap model) {
		
		try {
			model.put("data", trabajoApi.getFechaConcretaParametrizada(tipoTrabajo,subtipoTrabajo,cartera,subCartera));
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAplicaComiteParametrizado(String tipoTrabajo, String subtipoTrabajo,String cartera, String subCartera, WebDto webDto, ModelMap model) {
		try {
			model.put("data", trabajoApi.getAplicaComiteParametrizado(tipoTrabajo,subtipoTrabajo,cartera,subCartera));
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTransicionesEstadoTrabajo(String estadoActual, ModelMap model) {
		
		model.put("data", trabajoApi.getTransicionesEstadoTrabajoByCodigoEstado(estadoActual));
		model.put("success", true);
		
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getProveedorParametrizado(Long idActivo, String tipoTrabajo, String subtipoTrabajo,String cartera, String subCartera, WebDto webDto, ModelMap model) {
		try {
			model.put("data", trabajoApi.getProveedorParametrizado(idActivo,tipoTrabajo,subtipoTrabajo,cartera,subCartera));
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDocumentosFinalizacionTrabajo(Long idTrabajo, ModelMap model) {
		try {
			Map<String, String> tiposDocumentos = trabajoApi.getDocumentosFinalizacionTrabajo(idTrabajo);
			if (tiposDocumentos.isEmpty()) {
				model.put("success", true);
			} else {
				model.put("success", false);
				model.put("data", DOC_FINALIZACION_TRABAJO+tiposDocumentos.get("docs"));
				model.put("size", tiposDocumentos.get("size"));
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		return new ModelAndView("jsonView", model);
	}
	
    @SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
    public ModelAndView getExisteTareaWebServiceHaya(String idTareaHaya, ModelMap model) {
    	model.put("response", trabajoApi.getExisteTareaWebServiceHaya(idTareaHaya));
    	model.put("success", true);
    	return createModelAndViewJson(model);
    }

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView findBuscadorGastos(DtoTrabajoFilter dtoTrabajoFilter, ModelMap model){
		try {
			DtoPage page = trabajoApi.findBuscadorGastos(dtoTrabajoFilter);
			
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			model.put("error", e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboAreaPeticionaria(WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, trabajoApi.getComboAreaPeticionaria());

		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getTrabajoExists(String numTrabajo, ModelMap model) {

		try {
			Long idTrabajo = trabajoApi.getIdByNumTrabajo(Long.parseLong(numTrabajo));
			
			if(!Checks.esNulo(idTrabajo)) {
				model.put("success", true);
				model.put("data", idTrabajo);
			}else {
				model.put("success", false);
				model.put("error", ERROR_TRABAJO_NOT_EXISTS);
			}
		} catch (NumberFormatException e) {
			model.put("success", false);
			model.put("error", ERROR_TRABAJO_NO_NUMERICO);
		} catch(Exception e) {
			logger.error("error obteniendo el activo ",e);
			model.put("success", false);
			model.put("error", ERROR_GENERICO);
		}
		
		return createModelAndViewJson(model);
	}

}

