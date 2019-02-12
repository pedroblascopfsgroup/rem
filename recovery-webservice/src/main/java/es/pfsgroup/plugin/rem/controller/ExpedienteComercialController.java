package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.ExpedienteComercialAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.adapter.TrabajoAdapter;
import es.pfsgroup.plugin.rem.api.ClienteComercialApi;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.excel.ActivosExpedienteExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoBloqueosFinalizacion;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoCondicionesActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoExpedienteHistScoring;
import es.pfsgroup.plugin.rem.model.DtoExpedienteScoring;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoFormalizacionFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoHistoricoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoHstcoSeguroRentas;
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
import es.pfsgroup.plugin.rem.model.DtoTipoDocExpedientes;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;

@Controller
public class ExpedienteComercialController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(ExpedienteComercialController.class);
	public static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";

	public static final String CONSTANTE_CARTERA_HAYA = "Haya";
	
	public static final String ERROR_EXPEDIENTE_NOT_EXISTS = "No existe el expediente que esta buscando, pruebe con otro Nº de Expediente";
	public static final String ERROR_OFERTA_NOT_EXISTS = "No existe la oferta que esta buscando, pruebe con otro Nº de Oferta";
	public static final String ERROR_CAMPO_NO_NUMERICO = "El campo introducido es de carácter numérico";
	public static final String ERROR_NO_ASOCIADO_GDPR = "No se ha encontrado un documento GDPR asociado a este comprador";
	public static final String ERROR_NO_EXISTE_PERSONA_HAYA = "No existe persona Haya";
	public static final String ERROR_NO_EXISTE_NUM_DOCUMENTO = "No existe número de documento";
	public static final String ERROR_GENERICO = "La operación no se ha podido realizar";
	public static final String CAMPO_EXPEDIENTE = "E";
	public static final String CAMPO_OFERTA = "O";

	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_ERROR_MESSAGE_KEY = "errorMessage";
	private static final String RESPONSE_MESSAGE_KEY = "msg";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ClienteComercialApi clienteComercialApi;

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

	@Resource
	private Properties appProperties;

	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;
	
	@Autowired
	private ClienteComercialDao clienteComercialDao;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabExpediente(Long id, String tab, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getTabExpediente(id, tab));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings({ "unchecked" })
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosExpedienteById(Long id, WebDto webDto, ModelMap model) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		ExpedienteComercial expediente = expedienteComercialApi.findOne(id);

		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		avisosFormateados.setId(id.toString());

		for (ExpedienteAvisadorApi avisador : avisadores) {
			DtoAviso aviso = avisador.getAviso(expediente, usuarioLogado);
			if (!Checks.esNulo(aviso) && !Checks.esNulo(aviso.getDescripcion())) {
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + "<div class='div-aviso red'>"
						+ aviso.getDescripcion() + "</div>");
			}
		}

		model.put(RESPONSE_DATA_KEY, avisosFormateados);

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTextosOfertaById(@RequestParam Long id, ModelMap model) {
		try {
			List<DtoTextosOferta> lista = expedienteComercialApi.getListTextosOfertaById(id);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListEntregasReserva(@RequestParam Long id, WebDto dto, ModelMap model) {
		try {
			List<DtoEntregaReserva> lista = expedienteComercialApi.getListEntregasReserva(id);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveTextoOferta(DtoTextosOferta dto, @RequestParam Long idEntidad, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveTextoOferta(dto, idEntidad));

		} catch (Exception e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosBasicosOferta(DtoDatosBasicosOferta dto, @RequestParam Long id, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveDatosBasicosOferta(dto, id));

		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveSeguroRentasExpediente(DtoSeguroRentas dto, @RequestParam Long idSeguroRentas,
			ModelMap model) {
		try {

			model.put("success", expedienteComercialApi.saveSeguroRentasExpediente(dto, idSeguroRentas));

		} catch (JsonViewerException e) {
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
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveOfertaTanteoYRetracto(dto, id));

		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionesExpediente(DtoCondiciones dto, @RequestParam Long id, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveCondicionesExpediente(dto, id));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getObservaciones(ModelMap model, WebDto dto, Long idExpediente) {
		try {
			DtoPage page = expedienteComercialApi.getListObservaciones(idExpediente, dto);

			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveObservacion(ModelMap model, DtoObservacion dtoObservacion) {
		try {
			boolean success = expedienteComercialApi.saveObservacion(dtoObservacion);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createObservacion(ModelMap model, DtoObservacion dtoObservacion, Long idEntidad) {
		try {
			boolean success = expedienteComercialApi.createObservacion(dtoObservacion, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteObservacion(ModelMap model, @RequestParam Long id) {
		try {
			boolean success = expedienteComercialApi.deleteObservacion(id);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivosExpediente(ModelMap model, Long idExpediente) {
		try {
			DtoPage dto = expedienteComercialApi.getActivosExpedienteVista(idExpediente);
			model.put(RESPONSE_DATA_KEY, dto.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, dto.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSubtipoDocumentosExpedientes(ModelMap model, Long idExpediente, String valorCombo) {

		try {
			List <DtoTipoDocExpedientes> dto= expedienteComercialApi.getSubtipoDocumentosExpedientes(idExpediente, valorCombo);

			model.put("data", dto);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTipoDocumentoExpediente(ModelMap model, String tipoExpediente) {

		try {
			List<DtoTipoDocExpedientes> dto = expedienteComercialApi.getTipoDocumentoExpediente(tipoExpediente);

			model.put("data", dto);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoExpediente(HttpServletRequest request, HttpServletResponse response) {
		Long id = Long.parseLong(request.getParameter("id"));
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		String nombreDocumento = request.getParameter("nombreDocumento");

		try {
			FileItem fileItem = dl.getFileItem(id, nombreDocumento);
			ServletOutputStream salida = response.getOutputStream();

			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
			response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Expires", "0");
			response.setHeader("Pragma", "public");
			response.setDateHeader("Expires", 0); // prevents caching at the proxy
			response.setContentType(fileItem.getContentType());

			// Write
			FileUtils.copy(fileItem.getInputStream(), salida);
			salida.flush();
			salida.close();

		} catch (Exception e) {
			logger.error("Error en ExpedienteComercialController", e);
		}
	}
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoExpedienteGDPR (HttpServletRequest request, HttpServletResponse response, ModelMap model) {

				String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
				Downloader dl = downloaderFactoryApi.getDownloader(key);
				String nombreDocumento = request.getParameter("nombreAdjunto");
				Long idDocRestClient = Long.parseLong(request.getParameter("idDocRestClient"));
				
   			
       	try {
       		    FileItem fileItem = dl.getFileItem( idDocRestClient , nombreDocumento);
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
        
    		}catch(Exception e) {
    			logger.error("Error en ExpedienteComercialController", e);
		    }	
       	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView existeDocumentoGDPR(HttpServletRequest request, ModelMap model) {
		
		 String  idDocRestClient =  request.getParameter("idDocRestClient");
		 String  idDocAdjunto    = 	request.getParameter("idDocAdjunto");
		 String  nombreDocumento =  request.getParameter("nombreAdjunto");
		 try {
				if(!Checks.esNulo(idDocAdjunto ) && !Checks.esNulo(nombreDocumento) ) {
					if(!Checks.esNulo(idDocRestClient)) {
						model.put("success", true);
					} else {
						model.put("success", false);
						model.put("error", ERROR_NO_EXISTE_NUM_DOCUMENTO);
					}
					
				} else {
					model.put("success", false);
					model.put("error", ERROR_NO_ASOCIADO_GDPR );
					
				}
			} catch(Exception e) {
				logger.error("error obteniendo id Persona Haya ",e);
				model.put("success", false);
				model.put("error", ERROR_GENERICO);
			}
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(Long idExpediente, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialAdapter.getAdjuntosExpedienteComercial(idExpediente));
		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
		} catch (Exception e) {
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntosComprador(String docCliente, Long idExpediente, ModelMap model) {
		
		String idPersonaHaya = null;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		ClienteComercial clienteCom = genericDao.get(ClienteComercial.class, filtro);
			if(!Checks.esNulo(clienteCom)) {
				idPersonaHaya = clienteCom.getIdPersonaHaya();
			} else {
				TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente));

				if(!Checks.esNulo(tmpClienteGDPR)) {
					idPersonaHaya = String.valueOf(tmpClienteGDPR.getIdPersonaHaya());
				}
			} 
			
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialAdapter.getAdjuntoExpedienteComprador(idPersonaHaya, docCliente, idExpediente));
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDocumentoComprador(String docCliente, Long idEntidad, HttpServletRequest request) {
		
		String idPersonaHaya = null;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		ClienteComercial clienteCom = genericDao.get(ClienteComercial.class, filtro);
			if(!Checks.esNulo(clienteCom)) {
				idPersonaHaya = clienteCom.getIdPersonaHaya();
			} else {
				TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente));

				if(!Checks.esNulo(tmpClienteGDPR)) {
					idPersonaHaya = String.valueOf(tmpClienteGDPR.getIdPersonaHaya());
				}
			} 
			
			
		ModelMap model = new ModelMap();
		
		try {
			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			List<DtoAdjunto> listaAdjuntos = expedienteComercialAdapter.getAdjuntoExpedienteComprador(idPersonaHaya, docCliente, idEntidad);
			if(listaAdjuntos.size() <= 0) {
				String errores = expedienteComercialAdapter.uploadDocumentoComprador(fileItem, idPersonaHaya);
				model.put("errores", errores);
				model.put(RESPONSE_SUCCESS_KEY, errores==null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error(e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView eliminarDocumentoAdjuntoComprador(String docCliente) {
		
		String idPersonaHaya = null;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		ClienteComercial clienteCom = genericDao.get(ClienteComercial.class, filtro);
			if(!Checks.esNulo(clienteCom)) {
				idPersonaHaya = clienteCom.getIdPersonaHaya();
			} else {
				TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente));

				if(!Checks.esNulo(tmpClienteGDPR)) {
					idPersonaHaya = String.valueOf(tmpClienteGDPR.getIdPersonaHaya());
				}
			} 
			
		
		ModelMap model = new ModelMap();
		
		List<DtoAdjunto> listaAdjuntos = null;
		try {
			listaAdjuntos = expedienteComercialAdapter.getAdjuntoExpedienteComprador(idPersonaHaya, docCliente, null);							
		} catch (GestorDocumentalException e) {
			e.printStackTrace();
		}
		
		Filter filtroDoc = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", listaAdjuntos.get(0).getId());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		AdjuntoComprador adjComprador = genericDao.get(AdjuntoComprador.class, filtroDoc, filtroBorrado);

		boolean success = expedienteComercialAdapter.deleteAdjuntoComprador(adjComprador, null);
		model.put(RESPONSE_SUCCESS_KEY, success);

		return createModelAndViewJson(model);
	}

	/**
	 * Recibe y guarda un adjunto
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		try {
			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);

			String errores = expedienteComercialAdapter.uploadDocumento(fileItem, null, null);
			model.put("errores", errores);
			model.put(RESPONSE_SUCCESS_KEY, errores == null);

		} catch (GestorDocumentalException eGd) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errores", eGd.getMessage());
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errores", e.getMessage());
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAdjunto(ModelMap model, DtoAdjunto dtoAdjunto) {
		boolean success = expedienteComercialAdapter.deleteAdjunto(dtoAdjunto);
		model.put(RESPONSE_SUCCESS_KEY, success);

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramitesTareas(Long idExpediente, WebDto webDto, ModelMap model) {
		ExpedienteComercial expediente = expedienteComercialApi.findOne(idExpediente);
		List<DtoListadoTramites> tramites = trabajoAdapter
				.getListadoTramitesTareasTrabajo(expediente.getTrabajo().getId(), webDto);

		DtoListadoTramites tramite = new DtoListadoTramites();
		if (!Checks.estaVacio(tramites)) {
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
			DtoPage dto = expedienteComercialApi.getPosicionamientosExpediente(idExpediente);
			model.put(RESPONSE_DATA_KEY, dto.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, dto.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComparecientesExpediente(ModelMap model, Long idExpediente) {
		try {
			DtoPage dto = expedienteComercialApi.getComparecientesExpediente(idExpediente);

			model.put(RESPONSE_DATA_KEY, dto.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, dto.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSubsanacionesExpediente(ModelMap model, Long idExpediente) {
		try {
			DtoPage dto = expedienteComercialApi.getSubsanacionesExpediente(idExpediente);
			model.put(RESPONSE_DATA_KEY, dto.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, dto.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getContactosNotario(ModelMap model, Long idProveedor) {
		try {
			List<DtoNotarioContacto> lista = expedienteComercialApi.getContactosNotario(idProveedor);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHonorarios(ModelMap model, Long idExpediente) {
		try {
			List<DtoGastoExpediente> list = expedienteComercialApi.getHonorarios(idExpediente, null);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoCondiciones(ModelMap model, Long idExpediente) {
		try {
			List<DtoHistoricoCondiciones> list = expedienteComercialApi.getHistoricoCondiciones(idExpediente);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
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
	 * Recupera la lista de compradores para la pestanya Compradores /PBC de un
	 * expediente
	 * 
	 * @param idExpediente
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCompradoresExpediente(Long idExpediente, WebDto dto, ModelMap model) {
		
		try {
			Page page = expedienteComercialApi.getCompradoresByExpediente(idExpediente, dto);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCompradorById(VBusquedaDatosCompradorExpediente dto, ModelMap model) {
		try {
			VBusquedaDatosCompradorExpediente vistaConExp = expedienteComercialApi.getDatosCompradorById(dto.getId(),
					dto.getIdExpedienteComercial());
			if (!Checks.esNulo(vistaConExp)) {
				if (!Checks.esNulo(dto.getCesionDatos())) {
					vistaConExp.setCesionDatos(dto.getCesionDatos());
				}
				if (!Checks.esNulo(dto.getComunicacionTerceros())) {
					vistaConExp.setComunicacionTerceros(dto.getComunicacionTerceros());
				}
				if (!Checks.esNulo(dto.getTransferenciasInternacionales())) {
					vistaConExp.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
				}
				DtoModificarCompradores comprador = expedienteComercialApi.vistaADtoModCompradores(vistaConExp);
				model.put(RESPONSE_DATA_KEY, comprador);
				model.put(RESPONSE_SUCCESS_KEY, true);
			} else {
				VBusquedaDatosCompradorExpediente vistaSinExp = expedienteComercialApi.getDatCompradorById(dto.getId());
				if (!Checks.esNulo(vistaSinExp)) {
					if (!Checks.esNulo(dto.getCesionDatos())) {
						vistaSinExp.setCesionDatos(dto.getCesionDatos());
					}
					if (!Checks.esNulo(dto.getComunicacionTerceros())) {
						vistaSinExp.setComunicacionTerceros(dto.getComunicacionTerceros());
					}
					if (!Checks.esNulo(dto.getTransferenciasInternacionales())) {
						vistaSinExp.setTransferenciasInternacionales(dto.getTransferenciasInternacionales());
					}
					if (!Checks.esNulo(dto.getIdExpedienteComercial())) {
						vistaSinExp.setIdExpedienteComercial(dto.getIdExpedienteComercial());
					}
					DtoModificarCompradores comprador = expedienteComercialApi.vistaCrearComprador(vistaSinExp); 
					model.put(RESPONSE_DATA_KEY, comprador);
					model.put(RESPONSE_SUCCESS_KEY, true);
				}
			}
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFichaComprador(ModelMap model, VBusquedaDatosCompradorExpediente vDatosComprador, @RequestParam Long id) {
		try {
			boolean success = expedienteComercialApi.saveFichaComprador(vDatosComprador);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView marcarCompradorPrincipal(@RequestParam Long idComprador,
			@RequestParam Long idExpedienteComercial, ModelMap model) {
		try {
			boolean success = expedienteComercialApi.marcarCompradorPrincipal(idComprador, idExpedienteComercial);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveReserva(DtoReserva dto, @RequestParam Long id, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveReserva(dto, id));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveHonorario(ModelMap model, DtoGastoExpediente dtoGastoExpediente) {
		try {
			boolean success = expedienteComercialApi.saveHonorario(dtoGastoExpediente);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFichaExpediente(DtoFichaExpediente dto, @RequestParam Long id, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveFichaExpediente(dto, id));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveEntregaReserva(DtoEntregaReserva dto, @RequestParam Long idEntidad, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveEntregaReserva(dto, idEntidad));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateEntregaReserva(DtoEntregaReserva dto, @RequestParam Long idEntidad, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.updateEntregaReserva(dto, idEntidad));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteEntregaReserva(DtoEntregaReserva dto, @RequestParam Long idEntrega, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.deleteEntregaReserva(idEntrega));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createComprador(ModelMap model, VBusquedaDatosCompradorExpediente vDatosComprador,
			Long idExpediente) {
		try {
			boolean success = expedienteComercialApi.createComprador(vDatosComprador, idExpediente);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView consultarComiteSancionador(@RequestParam Long idExpediente, ModelMap model) {
		try {
			model.put("codigo", expedienteComercialApi.consultarComiteSancionador(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("msgError", e.getMessage());
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createPosicionamiento(DtoPosicionamiento dto, @RequestParam Long idEntidad, ModelMap model) {
		try {
			boolean success = expedienteComercialApi.createPosicionamiento(dto, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView savePosicionamiento(DtoPosicionamiento dto, ModelMap model) {
		try {
			boolean success = expedienteComercialApi.savePosicionamiento(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePosicionamiento(DtoPosicionamiento dto, ModelMap model) {
		try {
			boolean success = expedienteComercialApi.deletePosicionamiento(dto.getIdPosicionamiento());
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView buscarNumeroUrsus(@RequestParam String numeroDocumento, @RequestParam String tipoDocumento,
			String idExpediente, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY,
					expedienteComercialApi.buscarNumeroUrsus(numeroDocumento, tipoDocumento, idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, "Servicio no disponible");
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView buscarDatosClienteNumeroUrsus(@RequestParam String numeroUrsus,
			@RequestParam String idExpediente, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY,
					expedienteComercialApi.buscarDatosClienteNumeroUrsus(numeroUrsus, idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("msgError", e.getMessage());
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView buscarClientesUrsus(@RequestParam String numeroDocumento, @RequestParam String tipoDocumento,
			String idExpediente, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY,
					expedienteComercialApi.buscarClientesUrsus(numeroDocumento, tipoDocumento, idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("msgError", e.getMessage());
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboProveedoresExpediente(@RequestParam(required = false) String codigoTipoProveedor,
			@RequestParam(required = false) String nombreBusqueda, @RequestParam(required = false) String idActivo,
			WebDto dto, ModelMap model) {
		try {
			Page proveedores = expedienteComercialApi.getComboProveedoresExpediente(codigoTipoProveedor, nombreBusqueda,
					idActivo, dto);
			model.put(RESPONSE_DATA_KEY, proveedores.getResults());
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createHonorario(ModelMap model, DtoGastoExpediente dto, Long idEntidad) {
		try {
			boolean success = expedienteComercialApi.createHonorario(dto, idEntidad);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createHistoricoCondiciones(ModelMap model, DtoHistoricoCondiciones dto, Long idEntidad,
			Boolean idEntidadPk) {
		try {
			if (idEntidadPk) {
				boolean success = expedienteComercialApi.createHistoricoCondiciones(dto, idEntidad);
				model.put(RESPONSE_SUCCESS_KEY, success);
			} else {
				model.put(RESPONSE_MESSAGE_KEY, "Hay 10 registros insertados");
				model.put(RESPONSE_SUCCESS_KEY, false);
			}

		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteHonorario(ModelMap model, @RequestParam Long id) {
		try {
			boolean success = expedienteComercialApi.deleteHonorario(id);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteCompradorExpediente(ModelMap model, @RequestParam Long idExpediente,
			@RequestParam Long idComprador) {
		try {
			boolean success = expedienteComercialApi.deleteCompradorExpediente(idExpediente, idComprador);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActivoExpediente(DtoActivosExpediente dto, @RequestParam Long idEntidad, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.updateActivoExpediente(dto, idEntidad));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getBloqueosFormalizacion(ModelMap model, DtoBloqueosFinalizacion dto) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getBloqueosFormalizacion(dto));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createBloqueoFormalizacion(ModelMap model, DtoBloqueosFinalizacion dto,
			@RequestParam(value = "idEntidad") Long idExpediente, @RequestParam(value = "idEntidadPk") Long idActivo) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.createBloqueoFormalizacion(dto, idActivo));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteBloqueoFormalizacion(ModelMap model, DtoBloqueosFinalizacion dto) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.deleteBloqueoFormalizacion(dto));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateBloqueoFormalizacion(ModelMap model, DtoBloqueosFinalizacion dto) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.updateBloqueoFormalizacion(dto));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView obtencionDatosPrestamo(ModelMap model, DtoObtencionDatosFinanciacion dto) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.obtencionDatosPrestamo(dto));

		} catch (JsonViewerException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("msgError", e.getMessage());
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFormalizacionFinanciacion(ModelMap model, DtoFormalizacionFinanciacion dto) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getFormalizacionFinanciacion(dto));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFormalizacionFinanciacion(ModelMap model, DtoFormalizacionFinanciacion dto) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveFormalizacionFinanciacion(dto));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuarios(Long idTipoGestor, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getComboUsuarios(idTipoGestor));

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
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestores(Long idExpediente, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getGestores(idExpediente));

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoGestorFiltered(Long idExpediente, WebDto webDto, ModelMap model) {

		model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getComboTipoGestor(idExpediente));
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboActivos(Long idExpediente, WebDto webDto, ModelMap model) {
		model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getComboActivos(idExpediente));

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivoExpedienteCondiciones(Long idActivo, Long idExpediente, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getCondicionesActivoExpediete(idExpediente, idActivo));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoExpedienteCondiciones(ModelMap model, @RequestParam(value = "id") Long ecoId,
			DtoCondicionesActivoExpediente condiciones) {
		try {
			condiciones.setEcoId(ecoId);
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.guardarCondicionesActivoExpediente(condiciones));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getBloqueosActivo(ModelMap model, Long idExpediente, Long idActivo) {
		try {
			List<DtoGastoExpediente> list = expedienteComercialApi.getHonorarios(idExpediente, null);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTanteosActivo(ModelMap model, Long idExpediente, Long idActivo) {
		try {
			List<DtoTanteoActivoExpediente> list = expedienteComercialApi.getTanteosPorActivoExpediente(idExpediente,
					idActivo);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteTanteo(ModelMap model, @RequestParam(value = "id") Long idTanteo) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.deleteTanteoActivo(idTanteo));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveTanteo(ModelMap model, DtoTanteoActivoExpediente tanteo,
			@RequestParam(value = "idEntidad") Long idActivo,
			@RequestParam(value = "idEntidadPk") Long idExpedienteComercial) {
		try {
			tanteo.setIdActivo(idActivo);
			tanteo.setEcoId(idExpedienteComercial);
			expedienteComercialApi.guardarTanteoActivo(tanteo);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFechaEmisionInfJuridico(ModelMap model, Long id, Long idActivo) {
		try {
			DtoInformeJuridico dto = expedienteComercialApi.getFechaEmisionInfJuridico(id, idActivo);
			model.put(RESPONSE_DATA_KEY, dto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFechaEmisionInfJuridico(ModelMap model, DtoInformeJuridico dto,
			@RequestParam(value = "id") Long id, @RequestParam(value = "idActivo") Long idActivo) {
		dto.setIdActivo(idActivo);
		dto.setIdExpediente(id);

		try {
			expedienteComercialApi.guardarInformeJuridico(dto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView bloqueoExpediente(ModelMap model, Long idExpediente) {
		try {
			String errorCode = expedienteComercialApi.validaBloqueoExpediente(idExpediente);

			if (errorCode == null || errorCode.isEmpty()) {
				expedienteComercialApi.bloquearExpediente(idExpediente);
				model.put(RESPONSE_SUCCESS_KEY, true);

			} else {
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put("errorCode", errorCode);
			}

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorCode", "imposible.bloquear.general");
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView desbloqueoExpediente(ModelMap model, Long idExpediente, String motivoCodigo,
			String motivoDescLibre) {
		try {
			String errorCode = expedienteComercialApi.validaDesbloqueoExpediente(idExpediente);

			if (errorCode == null || errorCode.isEmpty()) {
				expedienteComercialApi.desbloquearExpediente(idExpediente, motivoCodigo, motivoDescLibre);
				model.put(RESPONSE_SUCCESS_KEY, true);

			} else {
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put("errorCode", errorCode);
			}

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorCode", "imposible.bloquear.general");
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void getExcelActivosExpediente(Long idExpediente, HttpServletRequest request, HttpServletResponse response) {
		try {
			DtoPage dto = expedienteComercialApi.getActivosExpediente(idExpediente);
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(idExpediente);
			List<DtoActivosExpediente> dtosActivos = (List<DtoActivosExpediente>) dto.getResults();

			ExcelReport report = new ActivosExpedienteExcelReport(dtosActivos, expedienteComercial.getNumExpediente());
			excelReportGeneratorApi.generateAndSend(report, response);

		} catch (IOException e) {
			logger.error("Error en ExpedienteComercialController", e);
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarTitularesUvem(ModelMap model, Long idExpediente) {
		try {
			expedienteComercialApi.enviarTitularesUvem(idExpediente);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put("errorUvem", true);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put("errorUvem", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarHonorariosUvem(ModelMap model, Long idExpediente) {
		try {
			expedienteComercialApi.enviarHonorariosUvem(idExpediente);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put("errorUvem", true);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put("errorUvem", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarCondicionantesEconomicosUvem(ModelMap model, Long idExpediente) {
		try {
			expedienteComercialApi.enviarCondicionantesEconomicosUvem(idExpediente);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put("errorUvem", true);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put("errorUvem", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getExpedienteExists(String numBusqueda, String campo, ModelMap model) {

		try {
			Long idExpediente = expedienteComercialApi.getIdByNumExpOrNumOfr(Long.parseLong(numBusqueda), campo);

			if (!Checks.esNulo(idExpediente)) {
				model.put("success", true);
				model.put("data", idExpediente);
				if (CAMPO_EXPEDIENTE.equals(campo)) {
					model.put("numExpediente", numBusqueda);
				} else {
					model.put("numExpediente", expedienteComercialApi.getNumExpByNumOfr(Long.parseLong(numBusqueda)));
				}
			} else {
				model.put("success", false);
				if (CAMPO_EXPEDIENTE.equals(campo)) {
					model.put("error", ERROR_EXPEDIENTE_NOT_EXISTS);
				} else {
					model.put("error", ERROR_OFERTA_NOT_EXISTS);
				}
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", ERROR_CAMPO_NO_NUMERICO);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", ERROR_GENERICO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoCalculo(Long idExpediente, WebDto webDto, ModelMap model) {

		model.put("data", expedienteComercialApi.getComboTipoCalculo(idExpediente));
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarCorreoComercializadora(String cuerpoEmail, Long idExpediente, ModelMap model) {

		try {
			boolean success = expedienteComercialApi.enviarCorreoComercializadora(cuerpoEmail, idExpediente);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarCorreoAsegurador(Long idExpediente, ModelMap model) {

		try {
			boolean success = expedienteComercialApi.enviarCorreoAsegurador(idExpediente);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoScoring(ModelMap model, Long idScoring) {

		try {
			List<DtoExpedienteHistScoring> list = expedienteComercialApi.getHistoricoScoring(idScoring);
			model.put("data", list);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveExpedienteScoring(DtoExpedienteScoring dto, @RequestParam Long id, ModelMap model) {
		try {

			model.put("success", expedienteComercialApi.saveExpedienteScoring(dto, id));

		} catch (JsonViewerException e) {
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
	public ModelAndView enviarCorreoGestionLlaves(Long idExpediente, ModelMap model) {

		try {
			boolean success = expedienteComercialApi.enviarCorreoGestionLlaves(idExpediente, null, 1);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getEstadoExpedienteComercial(ModelMap model, @RequestParam(value = "esVenta") String idEstado) {

		try {
			List<DtoDiccionario> list = expedienteComercialApi.getComboExpedienteComercialByEstado(idEstado);
			model.put("data", list);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView checkEstadoOcupadoTramite(ModelMap model, Long idTramite) {
		try {
			boolean success = expedienteComercialApi.checkEstadoOcupadoTramite(idTramite);

			model.put("success", success);
		} catch (Exception e) {
			model.put("success", false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteTmpClienteByDocumento(ModelMap model, String docCliente) {
		try {
			clienteComercialDao.deleteTmpClienteByDocumento(docCliente);
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

}
