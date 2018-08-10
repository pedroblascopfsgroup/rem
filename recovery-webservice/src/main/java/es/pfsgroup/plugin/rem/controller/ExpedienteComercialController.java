package es.pfsgroup.plugin.rem.controller;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ExpedienteComercialAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.adapter.TrabajoAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.excel.ActivosExpedienteExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoBloqueosFinalizacion;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoCondicionesActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoHstcoSeguroRentas;
import es.pfsgroup.plugin.rem.model.DtoFormalizacionFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoInformeJuridico;
import es.pfsgroup.plugin.rem.model.DtoListadoTramites;
import es.pfsgroup.plugin.rem.model.DtoModificarCompradores;
import es.pfsgroup.plugin.rem.model.DtoNotarioContacto;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoObtencionDatosFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoSeguroRentas;
import es.pfsgroup.plugin.rem.model.DtoTanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoTanteoYRetractoOferta;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;


@Controller
public class ExpedienteComercialController extends ParadiseJsonController{

	protected static final Log logger = LogFactory.getLog(ActivoController.class);
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private List<ExpedienteAvisadorApi> avisadores;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private TrabajoAdapter trabajoAdapter;
	
	@Autowired
	private ExpedienteComercialAdapter expedienteComercialAdapter;
	
	@Autowired
	ExcelReportGeneratorApi excelReportGeneratorApi;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;
	
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
			Object data = expedienteComercialApi.getTabExpediente(id, tab);
			model.put("data", data);
			model.put("success", true);
		} catch (Exception e) {
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
		avisosFormateados.setId(id.toString());
		
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
	public ModelAndView getListEntregasReserva(@RequestParam Long id,WebDto dto, ModelMap model) {
		
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
			
		}catch (JsonViewerException e) {
			e.printStackTrace();
			model.put("msg", e.getMessage());
			model.put("success", false);
		}
		
		catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveSeguroRentasExpediente(DtoSeguroRentas dto, @RequestParam Long id, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.saveSeguroRentasExpediente(dto, id));
			
		}catch (JsonViewerException e) {
			e.printStackTrace();
			model.put("msg", e.getMessage());
			model.put("success", false);
		}
		
		catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOfertaTanteoYRetracto(DtoTanteoYRetractoOferta dto, @RequestParam Long id, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.saveOfertaTanteoYRetracto(dto, id));
			
		}catch (JsonViewerException e) {
			e.printStackTrace();
			model.put("msg", e.getMessage());
			model.put("success", false);
		}
		
		catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionesExpediente(DtoCondiciones dto, @RequestParam Long id, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.saveCondicionesExpediente(dto, id));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}

@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getObservaciones(ModelMap model, WebDto dto, Long idExpediente) {
		
		try {
			DtoPage page = expedienteComercialApi.getListObservaciones(idExpediente, dto);
			
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivosExpediente(ModelMap model, Long idExpediente) {
		
		try {
			DtoPage dto= expedienteComercialApi.getActivosExpediente(idExpediente);
			
			model.put("data", dto.getResults());
			model.put("totalCount", dto.getTotalCount());
			model.put("success", true);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoExpediente (HttpServletRequest request, HttpServletResponse response) {
		Long id = Long.parseLong(request.getParameter("id"));
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		String nombreDocumento = request.getParameter("nombreDocumento");
		
       	try {
       		FileItem fileItem = dl.getFileItem(id,nombreDocumento);
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
	public ModelAndView getListAdjuntos(Long idExpediente, ModelMap model){

		try {
			model.put("data", expedienteComercialAdapter.getAdjuntosExpedienteComercial(idExpediente));
		} catch (Exception e) {
			logger.error("error en ExpedienteComercialController", e);
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
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
			
			String errores = expedienteComercialAdapter.uploadDocumento(fileItem, null, null);
			model.put("errores", errores);
			model.put("success", errores==null);
		
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errores", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	/**
     * Borra un adjunto del expediente comercial
     * @param asuntoId long
     * @param adjuntoId long
     */
	@RequestMapping(method = RequestMethod.POST)
    public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto) {
		
		boolean success= false;
		
		try {
			success = expedienteComercialAdapter.deleteAdjunto(dtoAdjunto);
		} catch(Exception ex) {
			ex.printStackTrace();
		}
    	
    	return createModelAndViewJson(new ModelMap("success", success));
    }
	
	/**
	 * Recupera los tramites asociados al expediente comercial
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramitesTareas(Long idExpediente, WebDto webDto, ModelMap model) {
		
		ExpedienteComercial expediente = expedienteComercialApi.findOne(idExpediente);
		List<DtoListadoTramites> tramites = trabajoAdapter.getListadoTramitesTareasTrabajo(expediente.getTrabajo().getId(), webDto);
		
		// TODO Cambiar si finalmente es posible que un trababjo tenga más de un trámite
		DtoListadoTramites tramite = new DtoListadoTramites(); 
		if(!Checks.estaVacio(tramites)) {
			tramite = tramites.get(0);
		}
		
		model.put("tramite", tramite);
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getTareaDefinicionDeOferta(Long idExpediente, WebDto webDto, ModelMap model) {

		try {
			String codigo = expedienteComercialApi.getTareaDefinicionDeOferta(idExpediente, webDto);
		
			model.put("codigo", codigo);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("codigo", "null");
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPosicionamientosExpediente(Long idExpediente, WebDto webDto, ModelMap model) {
		
		try {
			DtoPage dto= expedienteComercialApi.getPosicionamientosExpediente(idExpediente);
			
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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComparecientesExpediente(ModelMap model, Long idExpediente) {
		
		try {
			DtoPage dto= expedienteComercialApi.getComparecientesExpediente(idExpediente);
			
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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSubsanacionesExpediente(ModelMap model, Long idExpediente) {
		
		try {
			DtoPage dto= expedienteComercialApi.getSubsanacionesExpediente(idExpediente);
			
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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getContactosNotario(ModelMap model, Long idProveedor) {
		
		try {
			List<DtoNotarioContacto> lista = expedienteComercialApi.getContactosNotario(idProveedor);
			
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
	public ModelAndView getHonorarios(ModelMap model, Long idExpediente) {
		
		try {
			List<DtoGastoExpediente> list = expedienteComercialApi.getHonorarios(idExpediente, null);
			
			model.put("data", list);
			model.put("success", true);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHstcoSeguroRentas(ModelMap model, Long idExpediente) {
		
		try {
			List<DtoHstcoSeguroRentas> list = expedienteComercialApi.getHstcoSeguroRentas(idExpediente);
			model.put("data", list);
			model.put("success", true);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	/**
	 * Recupera la lista de compradores para la pestanya Compradores /PBC de un expediente
	 * @param idExpediente
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCompradoresExpediente(Long idExpediente, WebDto dto, ModelMap model) {

		try {
			
			Page page = expedienteComercialApi.getCompradoresByExpediente(idExpediente, dto);
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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCompradorById(VBusquedaDatosCompradorExpediente dto, ModelMap model ) {
		
		try {
			VBusquedaDatosCompradorExpediente vista = expedienteComercialApi.getDatosCompradorById(dto.getId(), dto.getIdExpedienteComercial());
			
			DtoModificarCompradores comprador = expedienteComercialApi.vistaADtoModCompradores(vista);
			
			model.put("data", comprador);
			//model.put("success", true);
		}catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFichaComprador(VBusquedaDatosCompradorExpediente vDatosComprador, @RequestParam Long id, ModelMap model){
		
//		ModelMap model = new ModelMap();
		
		try {
			boolean success = expedienteComercialApi.saveFichaComprador(vDatosComprador);
			model.put("success", success);			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView marcarCompradorPrincipal(@RequestParam Long idComprador, @RequestParam Long idExpedienteComercial, ModelMap model){
		
		try {
			boolean success = expedienteComercialApi.marcarCompradorPrincipal(idComprador, idExpedienteComercial);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveReserva(DtoReserva dto, @RequestParam Long id, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.saveReserva(dto, id));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveHonorario(DtoGastoExpediente dtoGastoExpediente){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = expedienteComercialApi.saveHonorario(dtoGastoExpediente);
			model.put("success", success);	
			
		} catch (JsonViewerException jve) {
			model.put("msg", jve.getMessage());	
			model.put("success", false);	
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFichaExpediente(DtoFichaExpediente dto, @RequestParam Long id, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.saveFichaExpediente(dto, id));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveEntregaReserva(DtoEntregaReserva dto, @RequestParam Long idEntidad, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.saveEntregaReserva(dto, idEntidad));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateEntregaReserva(DtoEntregaReserva dto, @RequestParam Long idEntidad, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.updateEntregaReserva(dto, idEntidad));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteEntregaReserva(DtoEntregaReserva dto, @RequestParam Long idEntrega, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.deleteEntregaReserva(idEntrega));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createComprador(VBusquedaDatosCompradorExpediente vDatosComprador, Long idExpediente){
		
		ModelMap model = new ModelMap();
		
		try {
			boolean success = expedienteComercialApi.createComprador(vDatosComprador, idExpediente);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView consultarComiteSancionador(@RequestParam Long idExpediente, ModelMap model) {
		try {		
			model.put("codigo", expedienteComercialApi.consultarComiteSancionador(idExpediente));
			model.put("success", true);
			
		} catch (JsonViewerException jve) {
			model.put("success", false);
			model.put("msgError", jve.getMessage());
			
		} catch (Exception e) {
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createPosicionamiento(DtoPosicionamiento dto, @RequestParam Long idEntidad, ModelMap model) {

		try {
			boolean success = expedienteComercialApi.createPosicionamiento(dto, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView savePosicionamiento(DtoPosicionamiento dto, ModelMap model) {

		try {
			boolean success = expedienteComercialApi.savePosicionamiento(dto);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePosicionamiento(DtoPosicionamiento dto, ModelMap model) {

		try {
			boolean success = expedienteComercialApi.deletePosicionamiento(dto.getIdPosicionamiento());
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView buscarNumeroUrsus(@RequestParam String numeroDocumento,@RequestParam String tipoDocumento, String idExpediente, ModelMap model) {
		try {		
			model.put("data", expedienteComercialApi.buscarNumeroUrsus(numeroDocumento, tipoDocumento, idExpediente));
			model.put("success", true);
			
		} catch (JsonViewerException e) {
			model.put("success", false);
			model.put("msg", e.getMessage());
			
		}	catch (Exception e) {
			model.put("success", false);
			model.put("msg", "Servicio no disponible");
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView buscarDatosClienteNumeroUrsus(@RequestParam String numeroUrsus,@RequestParam String idExpediente, ModelMap model) {
		try {		
			model.put("data", expedienteComercialApi.buscarDatosClienteNumeroUrsus(numeroUrsus,idExpediente));
			model.put("success", true);
			
		} catch (JsonViewerException e) {
			model.put("success", false);
			model.put("msgError", e.getMessage());
			
		}	catch (Exception e) {
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView buscarClientesUrsus(@RequestParam String numeroDocumento,@RequestParam String tipoDocumento,String idExpediente, ModelMap model) {
		try {		
			model.put("data", expedienteComercialApi.buscarClientesUrsus(numeroDocumento, tipoDocumento, idExpediente));
			model.put("success", true);
			
		}  catch (JsonViewerException e) {
			model.put("success", false);
			model.put("msgError", e.getMessage());
			
		} catch (Exception e) {
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedoresExpediente(@RequestParam(required = false) String codigoTipoProveedor, @RequestParam(required = false) String nombreBusqueda, @RequestParam(required = false) String idActivo,WebDto dto, ModelMap model) {
		
		try {
			Page proveedores = expedienteComercialApi.getComboProveedoresExpediente(codigoTipoProveedor, nombreBusqueda, idActivo, dto);
			model.put("data", proveedores.getResults());
			model.put("success", true);
		}catch (JsonViewerException e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("msg", e.getMessage());
		}		
		catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createHonorario(DtoGastoExpediente dto, Long idEntidad) {
		ModelMap model = new ModelMap();
		try {
			boolean success = expedienteComercialApi.createHonorario(dto, idEntidad);
			model.put("success", success);

		} catch (JsonViewerException jve) {
			model.put("msg", jve.getMessage());	
			model.put("success", false);	
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteHonorario(@RequestParam Long id){
		
		ModelMap model = new ModelMap();		
		try {
			boolean success = expedienteComercialApi.deleteHonorario(id);
			model.put("success", success);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteCompradorExpediente(@RequestParam Long idExpediente, @RequestParam Long idComprador){
		
		ModelMap model = new ModelMap();		
		try {
			boolean success = expedienteComercialApi.deleteCompradorExpediente(idExpediente, idComprador);
			model.put("success", success);
			
		}
		catch (JsonViewerException e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("msg", e.getMessage());
		}catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActivoExpediente(DtoActivosExpediente dto, @RequestParam Long idEntidad, ModelMap model) {
		try {		
			
			model.put("success", expedienteComercialApi.updateActivoExpediente(dto, idEntidad));
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}


	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getBloqueosFormalizacion(ModelMap model, DtoBloqueosFinalizacion dto) {
		try {
			model.put("data", expedienteComercialApi.getBloqueosFormalizacion(dto));
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createBloqueoFormalizacion(ModelMap model, DtoBloqueosFinalizacion dto, @RequestParam(value = "idEntidad") Long idExpediente,
			@RequestParam(value = "idEntidadPk") Long idActivo) {
		try {
			model.put("success", expedienteComercialApi.createBloqueoFormalizacion(dto, idActivo));
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteBloqueoFormalizacion(ModelMap model, DtoBloqueosFinalizacion dto) {
		try {
			model.put("success", expedienteComercialApi.deleteBloqueoFormalizacion(dto));
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateBloqueoFormalizacion(ModelMap model, DtoBloqueosFinalizacion dto) {
		try {
			model.put("success", expedienteComercialApi.updateBloqueoFormalizacion(dto));
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView obtencionDatosPrestamo(ModelMap model, DtoObtencionDatosFinanciacion dto) {
		try {
			model.put("success", expedienteComercialApi.obtencionDatosPrestamo(dto));
		} catch (JsonViewerException e) {
			model.put("success", false);
			model.put("msgError", e.getMessage());
		} catch (Exception e) {
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFormalizacionFinanciacion(ModelMap model, DtoFormalizacionFinanciacion dto) {
		try {
			model.put("data", expedienteComercialApi.getFormalizacionFinanciacion(dto));
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFormalizacionFinanciacion(ModelMap model, DtoFormalizacionFinanciacion dto) {
		try {
			model.put("success", expedienteComercialApi.saveFormalizacionFinanciacion(dto));
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuarios(Long idTipoGestor, WebDto webDto, ModelMap model) {

		model.put("data", expedienteComercialApi.getComboUsuarios(idTipoGestor));

		return new ModelAndView("jsonView", model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView insertarGestorAdicional(Long idExpediente, Long usuarioGestor, Long tipoGestor, WebDto webDto,
			ModelMap model) {

		try {
			GestorEntidadDto dto = new GestorEntidadDto();
			dto.setIdEntidad(idExpediente);
			dto.setIdUsuario(usuarioGestor);
			dto.setIdTipoGestor(tipoGestor);

			boolean success = expedienteComercialApi.insertarGestorAdicional(dto);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestores(Long idExpediente, WebDto webDto, ModelMap model) {

		model.put("data", expedienteComercialApi.getGestores(idExpediente));

		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoGestorFiltered(Long idExpediente, WebDto webDto, ModelMap model){
		
		model.put("data", expedienteComercialApi.getComboTipoGestor(idExpediente));
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboActivos(Long idExpediente, WebDto webDto, ModelMap model){
		
		model.put("data", expedienteComercialApi.getComboActivos(idExpediente));
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivoExpedienteCondiciones(Long idActivo,Long idExpediente, ModelMap model){
		try {
			model.put("data", expedienteComercialApi.getCondicionesActivoExpediete(idExpediente, idActivo));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoExpedienteCondiciones(@RequestParam(value="id",required=true) Long ecoId,DtoCondicionesActivoExpediente condiciones) {

		ModelMap model = new ModelMap();

		try {
			condiciones.setEcoId(ecoId);
			model.put("data", expedienteComercialApi.guardarCondicionesActivoExpediente(condiciones));
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getBloqueosActivo(ModelMap model, Long idExpediente,Long idActivo) {
		
		try {
			List<DtoGastoExpediente> list = expedienteComercialApi.getHonorarios(idExpediente, null);
			
			model.put("data", list);
			model.put("success", true);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTanteosActivo(ModelMap model, Long idExpediente,Long idActivo) {
		
		try {
			List<DtoTanteoActivoExpediente> list = expedienteComercialApi.getTanteosPorActivoExpediente(idExpediente, idActivo);
			
			model.put("data", list);
			model.put("success", true);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}	
		
		return new ModelAndView("jsonView", model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteTanteo(@RequestParam(value = "id") Long idTanteo) {

		ModelMap model = new ModelMap();
		boolean resultado = false;

		try {
			resultado = expedienteComercialApi.deleteTanteoActivo(idTanteo);
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		model.put("success", resultado);
		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveTanteo(DtoTanteoActivoExpediente tanteo, @RequestParam(value = "idEntidad") Long idActivo,
			@RequestParam(value = "idEntidadPk") Long idExpedienteComercial) {

		ModelMap model = new ModelMap();

		try {
			tanteo.setIdActivo(idActivo);
			tanteo.setEcoId(idExpedienteComercial);
			expedienteComercialApi.guardarTanteoActivo(tanteo);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFechaEmisionInfJuridico(ModelMap model, Long id, Long idActivo) {
		
		try {
			DtoInformeJuridico dto = expedienteComercialApi.getFechaEmisionInfJuridico(id, idActivo);
			
			model.put("data", dto);
			model.put("success", true);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}		
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFechaEmisionInfJuridico(DtoInformeJuridico dto, @RequestParam(value = "id") Long id, @RequestParam(value = "idActivo") Long idActivo) {
		
		dto.setIdActivo(idActivo);
		dto.setIdExpediente(id);
		
		ModelMap model = new ModelMap();

		try {
			expedienteComercialApi.guardarInformeJuridico(dto);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView bloqueoExpediente(ModelMap model, Long idExpediente) {
		
		try {
			
			String errorCode = expedienteComercialApi.validaBloqueoExpediente(idExpediente);
			
			if(errorCode == null || errorCode.isEmpty()){
				expedienteComercialApi.bloquearExpediente(idExpediente);
				model.put("success", true);
			}else{
				model.put("success", false);
				model.put("errorCode", errorCode);
			}			
			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errorCode", "imposible.bloquear.general");
		}		
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView desbloqueoExpediente(ModelMap model, Long idExpediente, String motivoCodigo, String motivoDescLibre) {
		
		try {
			
			String errorCode = expedienteComercialApi.validaDesbloqueoExpediente(idExpediente);
			
			if(errorCode == null || errorCode.isEmpty()){
				expedienteComercialApi.desbloquearExpediente(idExpediente,motivoCodigo,motivoDescLibre);
				model.put("success", true);
			}else{
				model.put("success", false);
				model.put("errorCode", errorCode);
			}			
			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errorCode", "imposible.bloquear.general");
		}		
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void getExcelActivosExpediente(Long idExpediente, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		DtoPage dto= expedienteComercialApi.getActivosExpediente(idExpediente);
		ExpedienteComercial expedienteComercial= expedienteComercialApi.findOne(idExpediente);
		List<DtoActivosExpediente> dtosActivos= (List<DtoActivosExpediente>) dto.getResults();
		
		ExcelReport report = new ActivosExpedienteExcelReport(dtosActivos, expedienteComercial.getNumExpediente());
		excelReportGeneratorApi.generateAndSend(report, response);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarTitularesUvem(ModelMap model, Long idExpediente) {
		
		try {
			
			expedienteComercialApi.enviarTitularesUvem(idExpediente);
			model.put("success", true);			
			
		} catch (JsonViewerException jve) {
			jve.printStackTrace();
			model.put("errorUvem", true);
			model.put("msg", jve.getMessage());
			model.put("success", false);
		}
		catch (Exception e) {
			e.printStackTrace();
			model.put("errorUvem", false);
			model.put("msg", e.getMessage());
			model.put("success", false);
		}		
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarHonorariosUvem(ModelMap model, Long idExpediente) {
		
		try {
			expedienteComercialApi.enviarHonorariosUvem(idExpediente);
			model.put("success", true);			
			
		} catch (JsonViewerException jve) {
			jve.printStackTrace();
			model.put("errorUvem", true);
			model.put("msg", jve.getMessage());
			model.put("success", false);
		}
		catch (Exception e) {
			e.printStackTrace();
			model.put("errorUvem", false);
			model.put("msg", e.getMessage());
			model.put("success", false);
		}		
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarCondicionantesEconomicosUvem(ModelMap model, Long idExpediente) {
		
		try {
			expedienteComercialApi.enviarCondicionantesEconomicosUvem(idExpediente);
			model.put("success", true);			
			
		} catch (JsonViewerException jve) {
			jve.printStackTrace();
			model.put("errorUvem", true);
			model.put("msg", jve.getMessage());
			model.put("success", false);
		}
		catch (Exception e) {
			e.printStackTrace();
			model.put("errorUvem", false);
			model.put("msg", e.getMessage());
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoCalculo(Long idExpediente, WebDto webDto, ModelMap model){
		
		model.put("data", expedienteComercialApi.getComboTipoCalculo(idExpediente));
		return new ModelAndView("jsonView", model);
	}
	
}