package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.adapter.TareaAdapter;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.http.client.HttpSimplePostRequest;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.ExpedienteAdapter;
import es.pfsgroup.plugin.rem.adapter.ExpedienteComercialAdapter;
import es.pfsgroup.plugin.rem.adapter.TrabajoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.GdprApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteVentaApi;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.excel.ActivosExpedienteExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.OfertaAgrupadaListadoActivosExcelReport;
import es.pfsgroup.plugin.rem.excel.PlantillaDistribucionPrecios;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.gestorDocumental.manager.GestorDocumentalAdapterManager;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ACCION_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ENTIDAD_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.REQUEST_STATUS_CODE;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.DtoAccionAprobacionCaixa;
import es.pfsgroup.plugin.rem.model.DtoActivosAlquiladosGrid;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoActualizacionRenta;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAuditoriaDesbloqueo;
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
import es.pfsgroup.plugin.rem.model.DtoFormalizacionResolucion;
import es.pfsgroup.plugin.rem.model.DtoGarantiasExpediente;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoGastoRepercutido;
import es.pfsgroup.plugin.rem.model.DtoGridFechaArras;
import es.pfsgroup.plugin.rem.model.DtoHistoricoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoHstcoSeguroRentas;
import es.pfsgroup.plugin.rem.model.DtoInformeJuridico;
import es.pfsgroup.plugin.rem.model.DtoListadoTramites;
import es.pfsgroup.plugin.rem.model.DtoModificarCompradores;
import es.pfsgroup.plugin.rem.model.DtoNotarioContacto;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoObtencionDatosFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoOrigenLead;
import es.pfsgroup.plugin.rem.model.DtoPlusvaliaVenta;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.DtoScreening;
import es.pfsgroup.plugin.rem.model.DtoSeguroRentas;
import es.pfsgroup.plugin.rem.model.DtoSlideDatosCompradores;
import es.pfsgroup.plugin.rem.model.DtoTanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoTanteoYRetractoOferta;
import es.pfsgroup.plugin.rem.model.DtoTestigos;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.DtoTipoDocExpedientes;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.VListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.VReportAdvisoryNotes;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadFinanciera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteProblemasVentaDto;
import net.minidev.json.JSONObject;

@Controller
public class ExpedienteComercialController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(ExpedienteComercialController.class);
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";

	private static final String ERROR_EXPEDIENTE_NOT_EXISTS = "No existe el expediente que esta buscando, pruebe con otro Nº de Expediente";
	private static final String ERROR_OFERTA_NOT_EXISTS = "No existe la oferta que esta buscando, pruebe con otro Nº de Oferta";
	private static final String ERROR_CAMPO_NO_NUMERICO = "El campo introducido es de carácter numérico";
	private static final String ERROR_NO_ASOCIADO_GDPR = "No se ha encontrado un documento GDPR asociado a este comprador";
	private static final String ERROR_GENERICO = "La operación no se ha podido realizar";
	private static final String ERROR_NO_EXISTE_NUM_DOCUMENTO = "No existe número de documento";
	public static final String CAMPO_EXPEDIENTE = "E";

	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_ERROR_MESSAGE_KEY = "errorMessage";
	private static final String RESPONSE_MESSAGE_KEY = "msg";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	private static final String RESPONSE_ERROR_CONNECT = "No se puede conectar al servidor remoto en entornos previos";

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

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

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

	@Autowired
	private LogTrustEvento trustMe;

	@Autowired
	private GdprApi gdprManager;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteAdapter expedienteAdapter;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
	
	@Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
	@Autowired
	private GestorDocumentalAdapterManager gestorDocumentalAdapterManager;
	
	@Autowired
	private FuncionesTramitesApi funcionesTramitesApi;
	
	@Autowired
	private TramiteVentaApi tramiteVentaApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabExpediente(Long id, String tab, ModelMap model, HttpServletRequest request) {

		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getTabExpediente(id, tab));
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, tab,
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, tab,
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings({ "unchecked" })
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosExpedienteById(Long id, WebDto webDto, ModelMap model) {

		try {
			DtoAviso avisosFormateados = expedienteComercialApi.getAvisosExpedienteById(id);
			model.put(RESPONSE_DATA_KEY, avisosFormateados);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTextosOfertaById(@RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {
			List<DtoTextosOferta> lista = expedienteComercialApi.getListTextosOfertaById(id);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "textosOferta",
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "textosOferta",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListEntregasReserva(@RequestParam Long id, WebDto dto, ModelMap model,
			HttpServletRequest request) {
		try {
			List<DtoEntregaReserva> lista = expedienteComercialApi.getListEntregasReserva(id);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "entregasReserva",
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "entregasReserva",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
	public ModelAndView saveDatosBasicosOferta(DtoDatosBasicosOferta dto, @RequestParam Long id, ModelMap model,
			HttpServletRequest request) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveDatosBasicosOferta(dto, id));
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "datosBasicosOferta",
					ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Error err) {
			model.put(RESPONSE_MESSAGE_KEY, err.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", err);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "datosBasicosOferta",
					ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);

		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "datosBasicosOferta",
					ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "datosBasicosOferta",
					ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
	public ModelAndView saveCondicionesExpediente(DtoCondiciones dto, @RequestParam Long id, ModelMap model,
			HttpServletRequest request) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveCondicionesExpediente(dto, id));
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "condiciones",
					ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "condiciones",
					ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView savePlusvaliaVenta(DtoPlusvaliaVenta dto, @RequestParam Long id, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.savePlusvaliaVenta(dto, id));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getObservaciones(ModelMap model, WebDto dto, Long idExpediente, HttpServletRequest request) {
		try {
			DtoPage page = expedienteComercialApi.getListObservaciones(idExpediente, dto);

			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "observaciones",
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "observaciones",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
	public ModelAndView getActivosExpediente(ModelMap model, Long idExpediente, HttpServletRequest request) {
		try {
			DtoPage dto = expedienteComercialApi.getActivosExpedienteVista(idExpediente);
			model.put(RESPONSE_DATA_KEY, dto.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, dto.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "activos",
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "activos",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSubtipoDocumentosExpedientes(ModelMap model, Long idExpediente, String valorCombo) {

		try {
			List<DtoTipoDocExpedientes> dto = expedienteComercialApi.getSubtipoDocumentosExpedientes(idExpediente,
					valorCombo);

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
		ServletOutputStream salida = null;
		try {

			FileItem fileItem = dl.getFileItem(id, nombreDocumento);
			salida = response.getOutputStream();
			if (fileItem != null) {
				response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the proxy
				response.setContentType(fileItem.getContentType());

				// Write
				FileUtils.copy(fileItem.getInputStream(), salida);
			}

		} catch (UserException ex) {
			try {
				salida.write(ex.toString().getBytes(Charset.forName("UTF-8")));
			} catch (IOException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			logger.error("Error en ExpedienteComercialController", e);
		} finally {
			try {
				salida.flush();
				salida.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoExpedienteGDPR(HttpServletRequest request, HttpServletResponse response, ModelMap model) {

		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		String nombreDocumento = request.getParameter("nombreAdjunto");
		Long idDocRestClient = Long.parseLong(request.getParameter("idDocRestClient"));

		try {
			FileItem fileItem = dl.getFileItem(idDocRestClient, nombreDocumento);
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

		} catch (Exception e) {
			logger.error("Error en ExpedienteComercialController", e);
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView existeDocumentoGDPR(HttpServletRequest request, ModelMap model) {

		String idDocRestClient = request.getParameter("idDocRestClient");
		String idDocAdjunto = request.getParameter("idDocAdjunto");
		String nombreDocumento = request.getParameter("nombreAdjunto");
		try {
			if (!Checks.esNulo(idDocAdjunto) && !Checks.esNulo(nombreDocumento)) {
				if (!Checks.esNulo(idDocRestClient) && gestorDocumentalAdapterApi.modoRestClientActivado()) {
					model.put("success", true);
				} else if (!Checks.esNulo(idDocAdjunto) && !gestorDocumentalAdapterApi.modoRestClientActivado()) {
					model.put("success", true);
				} else {
					model.put("success", false);
					model.put("error", ERROR_NO_EXISTE_NUM_DOCUMENTO);
				}

			} else {
				model.put("success", false);
				model.put("error", ERROR_NO_ASOCIADO_GDPR);

			}
		} catch (Exception e) {
			logger.error("error obteniendo id Persona Haya ", e);
			model.put("success", false);
			model.put("error", ERROR_GENERICO);
		}
		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(Long idExpediente, ModelMap model, HttpServletRequest request) {

		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialAdapter.getAdjuntosExpedienteComercial(idExpediente));
			trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "adjuntos",
					ACCION_CODIGO.CODIGO_VER);

		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "adjuntos",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);

		} catch (Exception e) {
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "adjuntos",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntosComprador(String docCliente, Long idExpediente, ModelMap model) {

		try {
			String idPersonaHaya = gdprManager.obtenerIdPersonaHaya(docCliente);
			model.put(RESPONSE_DATA_KEY,
					expedienteComercialAdapter.getAdjuntoExpedienteComprador(idPersonaHaya, docCliente, idExpediente));
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDocumentoComprador(String docCliente, Long idEntidad, HttpServletRequest request) {
		ModelMap model = new ModelMap();
		try {

			if (!Checks.esNulo(docCliente)) {
				String idPersonaHaya = gdprManager.obtenerIdPersonaHaya(docCliente);

				WebFileItem fileItem = uploadAdapter.getWebFileItem(request);

				expedienteComercialAdapter.uploadDocumentoComprador(fileItem, idPersonaHaya, docCliente);
				model.put(RESPONSE_SUCCESS_KEY, true);
			}
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errores", e.getMessage());
			logger.error("error subiendo documento persona", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView eliminarDocumentoAdjuntoComprador(String docCliente) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		Comprador comprador = genericDao.get(Comprador.class, filtro);
		ModelMap model = new ModelMap();

		List<DtoAdjunto> listaAdjuntos = null;
		try {
			String idPersonaHaya = gdprManager.obtenerIdPersonaHaya(docCliente);
			listaAdjuntos = expedienteComercialAdapter.getAdjuntoExpedienteComprador(idPersonaHaya, docCliente, null);
		} catch (Exception e) {
			logger.error("Error en ExpedienteComercialController", e);
		}

		Filter filtroDoc;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			filtroDoc = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", listaAdjuntos.get(0).getId());
		} else {
			filtroDoc = genericDao.createFilter(FilterType.EQUALS, "id", listaAdjuntos.get(0).getId());
		}
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		AdjuntoComprador adjComprador = genericDao.get(AdjuntoComprador.class, filtroDoc, filtroBorrado);

		boolean success = expedienteComercialAdapter.deleteAdjuntoComprador(adjComprador, comprador);
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

			String errores = expedienteComercialAdapter.uploadDocumento(fileItem);
			model.put("errores", errores);
			model.put(RESPONSE_SUCCESS_KEY, errores == null);

		} catch (GestorDocumentalException eGd) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", eGd.getMessage());
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", e.getMessage());
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
	public ModelAndView getTramitesTareas(Long idExpediente, WebDto webDto, ModelMap model,
			HttpServletRequest request) {

		ExpedienteComercial expediente = expedienteComercialApi.findOne(idExpediente);
		List<DtoListadoTramites> tramites = trabajoAdapter.getListadoTramitesTareasTrabajo(expediente.getTrabajo().getId(), webDto);

		DtoListadoTramites tramite = new DtoListadoTramites();
		if (!Checks.estaVacio(tramites)) {
			tramite = tramites.get(0);
			tramite = expedienteComercialApi.ponerTareasCarteraCorrespondiente(tramite, expediente);
		}
		
	
		model.put("tramite", tramite);
		trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "tamitesTareas", ACCION_CODIGO.CODIGO_VER);

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
	public ModelAndView getPosicionamientosExpediente(Long idExpediente, WebDto webDto, ModelMap model,
			HttpServletRequest request) {

		try {
			DtoPage dto = expedienteComercialApi.getPosicionamientosExpediente(idExpediente);
			model.put(RESPONSE_DATA_KEY, dto.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, dto.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL,
					"posicionamiento", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "posicionamiento",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
	public ModelAndView getSubsanacionesExpediente(ModelMap model, Long idExpediente, HttpServletRequest request) {
		try {
			DtoPage dto = expedienteComercialApi.getSubsanacionesExpediente(idExpediente);
			model.put(RESPONSE_DATA_KEY, dto.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, dto.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "subsanaciones",
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "subsanaciones",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
	public ModelAndView getHonorarios(ModelMap model, Long idExpediente, HttpServletRequest request) {
		try {
			List<DtoGastoExpediente> list = expedienteComercialApi.getHonorarios(idExpediente, null);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "honorarios",
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "honorarios",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
	public ModelAndView getCompradoresExpediente(Long idExpediente, WebDto dto, ModelMap model,
			HttpServletRequest request) {

		try {
			Page page = expedienteComercialApi.getCompradoresByExpediente(idExpediente, dto);
			Float participacion = expedienteComercialApi.getPorcentajeCompra(idExpediente);
			model.put("porcentajeCompra", participacion);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "compradores",
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "compradores",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCompradorById(DtoModificarCompradores dto, ModelMap model) {
		try {
			DtoModificarCompradores comprador = null;
			String clienteGD = null;
			if (!Checks.esNulo(dto.getId())) {
				VBusquedaDatosCompradorExpediente vistaConExp = expedienteComercialApi
						.getDatosCompradorById(dto.getId(), dto.getIdExpedienteComercial());
				if (!Checks.esNulo(vistaConExp)) {
					comprador = expedienteComercialApi.vistaADtoModCompradores(vistaConExp);
					if ("0".equals(comprador.getNumeroConyugeUrsus())) {
						comprador.setNumeroConyugeUrsus(null);
					}
					if (!Checks.esNulo(vistaConExp.getIdExpedienteComercial())) {
						ExpedienteComercial expediente =genericDao.get(ExpedienteComercial.class,
								genericDao.createFilter(FilterType.EQUALS, "id", vistaConExp.getIdExpedienteComercial()));
						
						if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta())
								&& !Checks.esNulo(expediente.getOferta().getActivoPrincipal())) {
							Activo activo = expediente.getOferta().getActivoPrincipal();
							clienteGD = gestorDocumentalAdapterManager.getClienteByCarteraySubcarterayPropietario(activo.getCartera(), activo.getSubcartera(), activo.getPropietarioPrincipal());
						}
						
						if (!Checks.esNulo(clienteGD)) {
							ofertaApi.llamadaMaestroPersonas(vistaConExp.getIdExpedienteComercial(), clienteGD);
						}else {
							ofertaApi.llamadaMaestroPersonas(vistaConExp.getIdExpedienteComercial(), OfertaApi.CLIENTE_HAYA);
						}
						comprador.setIsExpedienteAprobado(funcionesTramitesApi.isTramiteAprobado(expediente));
						comprador.setMotivoEdicionCompradores(expediente.getMotivoEdicionCompradores());
					}
				} else {
					VBusquedaDatosCompradorExpediente vistaSinExp = expedienteComercialApi
							.getDatCompradorById(dto.getId());
					if (!Checks.esNulo(vistaSinExp)) {
						if (!Checks.esNulo(dto.getIdExpedienteComercial())) {
							vistaSinExp.setIdExpedienteComercial(dto.getIdExpedienteComercial());
						}
						comprador = expedienteComercialApi.vistaCrearComprador(vistaSinExp);
					}
				}
			} else {
				VBusquedaDatosCompradorExpediente vistaSinComprador = new VBusquedaDatosCompradorExpediente();
				vistaSinComprador.setIdExpedienteComercial(dto.getIdExpedienteComercial());
				vistaSinComprador.setNumDocumento(dto.getNumDocumento());
				vistaSinComprador.setCodTipoDocumento(dto.getCodTipoDocumento());
				comprador = expedienteComercialApi.vistaCrearComprador(vistaSinComprador);
				comprador.setTransferenciasInternacionales(null);

			}
			if (!dto.isVisualizar()) {
				comprador.setNumeroClienteUrsus(null);
				comprador.setNumeroClienteUrsusBh(null);
			}
			
			
			model.put(RESPONSE_DATA_KEY, comprador);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	// La vista hace de webdto del modelo de sencha
	public ModelAndView saveFichaComprador(ModelMap model, VBusquedaDatosCompradorExpediente vDatosComprador,
			@RequestParam Long id) {
		try {
			boolean success = false;
			if (Checks.esNulo(vDatosComprador.getId())) {
				this.createComprador(model, vDatosComprador, vDatosComprador.getIdExpedienteComercial());
				success = true;
			} else {
				success = expedienteComercialApi.saveFichaCompradorAndSendToBC(vDatosComprador);
			}

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
	public ModelAndView saveReserva(DtoReserva dto, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {
			boolean success = expedienteComercialApi.saveReserva(dto, id);
			model.put(RESPONSE_SUCCESS_KEY, success);

			if(success &&
					(dto.getFechaPropuestaProrrogaArras() != null ||
					 dto.getFechaVigenciaArras() != null ||
					 dto.getFechaComunicacionCliente() != null)
			  ){
				Oferta oferta = expedienteComercialApi.findOne(id).getOferta();
				if (!DDTipoOferta.isTipoAlquilerNoComercial(oferta.getTipoOferta())) {
					ofertaApi.replicateOfertaFlush(oferta);
				}
			}

			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "reserva",
					ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "reserva",
					ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveHonorario(ModelMap model, DtoGastoExpediente dtoGastoExpediente) {
		try {
			boolean success = false;
		
			if(dtoGastoExpediente.getId() != null) {
				 success = expedienteComercialApi.cumpleCondicionesCrearHonorario(Long.valueOf(dtoGastoExpediente.getId()));
				if(success) {
				 success = expedienteComercialApi.saveHonorario(dtoGastoExpediente);
				}
			}
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
	public ModelAndView saveFichaExpediente(DtoFichaExpediente dto, @RequestParam Long id, ModelMap model,
			HttpServletRequest request) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveFichaExpediente(dto, id));
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "ficha",
					ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "ficha",
					ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
			Long idExpedienteComercial) {
		try {
			boolean success = expedienteComercialApi.createCompradorAndSendToBC(vDatosComprador, idExpedienteComercial);
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
			expedienteComercialApi.sendPosicionamientoToBc(idEntidad, false);
			if (!success) {
				model.put("msgError", "Ya existe un posicionamiento vigente");
			}
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
			Long idEntidad = expedienteComercialApi.getExpedienteByPosicionamiento(dto.getIdPosicionamiento());
			expedienteComercialApi.sendPosicionamientoToBc(idEntidad, success);
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
	public ModelAndView buscarProblemasVentaClienteUrsus(@RequestParam String numeroUrsus,
			@RequestParam String idExpediente, ModelMap model) {
		try {
			List<DatosClienteProblemasVentaDto> list = expedienteComercialApi
					.buscarProblemasVentaClienteUrsus(numeroUrsus, idExpediente);
			model.put("data", list);
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
			
			boolean success = expedienteComercialApi.cumpleCondicionesCrearHonorario(idEntidad);
			if(success) {
				success = expedienteComercialApi.createHonorario(dto, idEntidad);
			}
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
			model.put(RESPONSE_SUCCESS_KEY, true);
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.obtencionDatosPrestamo(dto));

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
	public ModelAndView getFormalizacionFinanciacion(ModelMap model, DtoFormalizacionFinanciacion dto,
			HttpServletRequest request) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getFormalizacionFinanciacion(dto));
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, Long.parseLong(dto.getId()), ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL,
					"formalizacion", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, Long.parseLong(dto.getId()), ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL,
					"formalizacion", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFormalizacionFinanciacion(ModelMap model, DtoFormalizacionFinanciacion dto,
			HttpServletRequest request) {
		try {

			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveFormalizacionFinanciacion(dto));
			trustMe.registrarSuceso(request, Long.parseLong(dto.getId()), ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL,
					"formalizacion", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, Long.parseLong(dto.getId()), ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL,
					"formalizacion", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
	public ModelAndView getGestores(Long idExpediente, WebDto webDto, ModelMap model, HttpServletRequest request) {
		model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getGestores(idExpediente));
		trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "gestores",
				ACCION_CODIGO.CODIGO_VER);

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
	public ModelAndView saveActivosExpedienteCondiciones(ModelMap model, @RequestParam(value = "id") Long ecoId,
			DtoCondicionesActivoExpediente condiciones) {
		try {
			condiciones.setEcoId(ecoId);
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.guardarCondicionesActivosExpediente(condiciones));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
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
	public ModelAndView getTanteosActivo(ModelMap model, Long idExpediente, Long idActivo, HttpServletRequest request) {
		try {
			List<DtoTanteoActivoExpediente> list = expedienteComercialApi.getTanteosPorActivoExpediente(idExpediente,
					idActivo);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "tanteos",
					ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpediente, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "tanteos",
					ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
			@RequestParam(value = "idEntidadPk") Long idExpedienteComercial, HttpServletRequest request) {
		try {
			tanteo.setIdActivo(idActivo);
			tanteo.setEcoId(idExpedienteComercial);
			expedienteComercialApi.guardarTanteoActivo(tanteo);
			model.put(RESPONSE_SUCCESS_KEY, true);
			trustMe.registrarSuceso(request, idExpedienteComercial, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL,
					"tanteo", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
			trustMe.registrarError(request, idExpedienteComercial, ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL, "tanteo",
					ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
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
	@RequestMapping(method = RequestMethod.GET)
	public void getExcelActivosExpediente(Long idExpediente, HttpServletRequest request, HttpServletResponse response) {
		try {
			DtoPage dto = expedienteComercialApi.getActivosExpedienteExcel(idExpediente, true);
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(idExpediente);
			List<DtoActivosExpediente> dtosActivos = (List<DtoActivosExpediente>) dto.getResults();

			ExcelReport report = new ActivosExpedienteExcelReport(dtosActivos, expedienteComercial.getNumExpediente());
			excelReportGeneratorApi.generateAndSend(report, response);

		} catch (IOException e) {
			logger.error("Error en ExpedienteComercialController", e);
		}
	}

	@RequestMapping(method = RequestMethod.GET)
	public void getExcelPlantillaDistribucionPrecios(Long idExpediente, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			DtoPage dto = expedienteComercialApi.getActivosExpedienteExcel(idExpediente, false);
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(idExpediente);
			List<DtoActivosExpediente> dtosActivos = (List<DtoActivosExpediente>) dto.getResults();

			ExcelReport report = new PlantillaDistribucionPrecios(dtosActivos, expedienteComercial.getNumExpediente());
			excelReportGeneratorApi.generateAndSend(report, response);

		} catch (IOException e) {
			logger.error("Error en ExpedienteComercialController", e);
		}
	}

	@RequestMapping(method = RequestMethod.GET)
	public void getAdvisoryNoteExpediente(HttpServletRequest request, HttpServletResponse response, Long idExpediente)
			throws Exception {
		try {
			Oferta oferta = ofertaApi.getOfertaByIdExpediente(idExpediente);
			DDSubcartera subcartera = oferta.getActivoPrincipal().getSubcartera();
			List<VReportAdvisoryNotes> listaAN = expedienteComercialApi.getAdvisoryNotesByOferta(oferta);
			
			if(!Checks.estaVacio(listaAN)) {
				File file = null;
				if(subcartera.getCodigo().equals(DDSubcartera.CODIGO_APPLE_INMOBILIARIO) || subcartera.getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB)) {
					file = excelReportGeneratorApi.getAdvisoryNoteReport(listaAN, request,DDSubcartera.CODIGO_APPLE_INMOBILIARIO);
				}else if(subcartera.getCodigo().equals(DDSubcartera.CODIGO_JAGUAR)) {
					file = excelReportGeneratorApi.getAdvisoryNoteReport(listaAN, request,DDSubcartera.CODIGO_JAGUAR);
				}else if(subcartera.getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB)) {
					file = excelReportGeneratorApi.getAdvisoryNoteReportArrow(listaAN, request);
				}
 
				excelReportGeneratorApi.sendReport(file, response);
			}

		} catch (Exception e) {
			e.printStackTrace();

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

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getExpedienteByIdOferta(Long numOferta, ModelMap model) {
		try {
			model.put("data", expedienteComercialApi.getExpedienteComercialByOferta(numOferta));
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIsExpedienteGencat(Long idExpediente, ModelMap model) {
		try {
			boolean tieneBloqueoGencat = activoTramiteApi.tieneTramiteGENCATVigenteByIdActivo(idExpediente);
			model.put("data", tieneBloqueoGencat);
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivosPropagables(ModelMap model, @RequestParam(value = "idExpediente") Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getActivosPropagables(Long.valueOf(idExpediente)));
		} catch (Exception e) {
			logger.error("error en expedienteComercialController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getComprobarCompradores(ModelMap model,
			@RequestParam(value = "idExpediente") Long idExpediente) {
		Boolean hayProblemasUrsus = expedienteComercialApi.hayDiscrepanciasClientesURSUS(Long.valueOf(idExpediente));

		try {
			model.put(RESPONSE_DATA_KEY, hayProblemasUrsus);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en expedienteComercialController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView discrepanciasVeracidadDatosComprador(ModelMap model, DtoSlideDatosCompradores dto)
			throws Exception {
		Boolean hayProblemasUrsus = expedienteComercialApi.modificarDatosUnCompradorProblemasURSUS(dto);
		try {
			model.put(RESPONSE_DATA_KEY, hayProblemasUrsus);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en expedienteComercialController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView existeComprador(String numDocumento, ModelMap model) {
		try {
			boolean existe = expedienteComercialApi.existeComprador(numDocumento);
			model.put("data", existe);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void exportarListadoActivosOfertaPrincipal(Long idExpediente, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(idExpediente);
		Long idOferta = expedienteComercial.getOferta().getId();

		if (!Checks.esNulo(idOferta)) {
			List<VListadoOfertasAgrupadasLbk> listaActivosPorAgrupacion = expedienteComercialAdapter
					.getListActivosAgrupacionById(idOferta);

			if (!Checks.estaVacio(listaActivosPorAgrupacion)) {
				ExcelReport report = new OfertaAgrupadaListadoActivosExcelReport(listaActivosPorAgrupacion);

				excelReportGeneratorApi.generateAndSend(report, response);
			}
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView esOfertaDependiente(Long numOferta, ModelMap model) {
		try {
			Oferta oferta = null;
			if (!Checks.esNulo(numOferta)) {
				oferta = ofertaApi.getOfertaById(numOferta);
				if (Checks.esNulo(oferta)) {
					oferta = ofertaApi.getOfertaByNumOfertaRem(numOferta);
				}
			}

			if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getId())) {
				model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.esOfertaDependiente(oferta.getId()));
				model.put(RESPONSE_ERROR_KEY, false);
			} else {
				model.put(RESPONSE_SUCCESS_KEY, false);
				model.put(RESPONSE_ERROR_KEY, true);
			}

		} catch (Exception e) {
			e.printStackTrace();
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchOfertaCodigo(@RequestParam String numOferta, @RequestParam String id,
			@RequestParam String esAgrupacion) {
		ModelMap model = new ModelMap();

		try {
			model.put(RESPONSE_SUCCESS_KEY, true);
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.searchOfertaCodigo(numOferta, id, esAgrupacion));

		} catch (JsonViewerException jve) {
			logger.error("Error en expedienteComercialController", jve);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, jve.getMessage());
		} catch (Exception e) {
			logger.error("Error en expedienteComercialController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestorPrescriptor(Long idExpediente, ModelMap model) {
		try {
			List<DtoDiccionario> list = expedienteComercialApi.calcularGestorComercialPrescriptor(idExpediente);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getGestorPrescriptor)", e);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView doCalculateComiteByExpedienteId(Long idExpediente, ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.doCalculateComiteByExpedienteId(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getGestorPrescriptor)", e);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getOrigenLead(ModelMap model, Long idExpediente, HttpServletRequest request) {
		try {
			DtoOrigenLead origenLead = expedienteComercialApi.getOrigenLeadList(idExpediente);
			model.put(RESPONSE_DATA_KEY, origenLead);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAuditoriaDesbloqueo(ModelMap model, Long idExpediente, HttpServletRequest request) {
		try {
			List<DtoAuditoriaDesbloqueo> auditoriaDesbloqueo = expedienteComercialApi.getAuditoriaDesbloqueoList(idExpediente);
			model.put(RESPONSE_DATA_KEY, auditoriaDesbloqueo);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getAuditoriaDesbloqueo)", e);
			}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView activarCompradorExpediente(ModelMap model, @RequestParam Long idCompradorExpediente, @RequestParam Long idExpediente) {
		try {
			boolean success = expedienteComercialApi.activarCompradorExpediente(idCompradorExpediente, idExpediente);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController::activarCompradorExpediente", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView insertarRegistroAuditoriaDesbloqueo(ModelMap model, Long expedienteId, String comentario, Long usuId, HttpServletRequest request) {
		try {
			expedienteComercialApi.insertarRegistroAuditoriaDesbloqueo(expedienteId, comentario, usuId);
			model.put(RESPONSE_SUCCESS_KEY, true);
		}catch(Exception e){
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getAuditoriaDesbloqueo)", e);
		}
		return createModelAndViewJson(model);
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivosAlquilados(Long idExpediente) {
		
		ModelMap model = new ModelMap();
		
		try {
			List<DtoActivosAlquiladosGrid> list = expedienteComercialApi.getActivosAlquilados(idExpediente);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getGestorPrescriptor)", e);
		}
		return createModelAndViewJson(model);
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCierreEconomicoFinalizado(ModelMap model, Long expedienteId ,HttpServletRequest request) {
		try {
			Boolean isCierreEconomicoFinalizado = expedienteComercialApi.finalizadoCierreEconomico(expedienteId);
			model.put(RESPONSE_SUCCESS_KEY, true);
			model.put(RESPONSE_DATA_KEY, isCierreEconomicoFinalizado);
		}catch(Exception e){
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getCierreEconomicoFinalizado)", e);

		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActivosAlquilados(DtoActivosAlquiladosGrid dto) {
		
		ModelMap model = new ModelMap();
		
		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.updateActivosAlquilados(dto));

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}
		return createModelAndViewJson(model);
	}



	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView sacarBulk(ModelMap model, @RequestParam Long idExpediente) {
		try {
			boolean success = expedienteComercialApi.sacarBulk(idExpediente);
			model.put(RESPONSE_SUCCESS_KEY, success);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController::sacarBulk", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView contrasteListas(ModelMap model,@RequestParam Long numOferta, Long idExpediente) {
		try {
			String endpoint = expedienteAdapter.getContrasteListasREM3Endpoint();
			if (!TareaAdapter.DEV.equals(endpoint) && endpoint != null) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("codigoOferta", numOferta);
				params.put("idExpediente", idExpediente);
				HttpSimplePostRequest request = new HttpSimplePostRequest(endpoint, params);
				JSONObject resp = request.post(JSONObject.class);
				model.put(RESPONSE_DATA_KEY, resp);
			} else {
				JSONObject resp = new JSONObject() {{
					put("success", false);
					put("descError", RESPONSE_ERROR_CONNECT);
				}};
				model.put(RESPONSE_DATA_KEY, resp);
			}
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController::contrasteListas", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView lanzarDatosPbc(ModelMap model,@RequestParam Long numOferta) {
		try {
			String endpoint = expedienteAdapter.getlanzarDatosPbcREM3Endpoint();
			if (!TareaAdapter.DEV.equals(endpoint) && endpoint != null) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("codigoOferta", numOferta);
				HttpSimplePostRequest request = new HttpSimplePostRequest(endpoint, params);
				JSONObject resp = request.post(JSONObject.class);
				model.put(RESPONSE_DATA_KEY, resp);
			} else {
				JSONObject resp = new JSONObject() {{
					put("success", false);
					put("descripcion", RESPONSE_ERROR_CONNECT);
				}};
				model.put(RESPONSE_DATA_KEY, resp);
			}
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController::lanzarDatosPbc", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView recalcularHonorarios(ModelMap model, Long idExpediente) {
		try {
			expedienteComercialApi.recalcularHonorarios(idExpediente);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (JsonViewerException e) {
			model.put("error", true);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getUltimaFechaPropuesta(ModelMap model, Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getFechaUltimaPropuestaSinContestar(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getConfirmacionBCFechaFirmaArras(ModelMap model, Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getUltimaPropuestaEnviada(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getUltimoPosicionamientoSinContestar(ModelMap model, Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getUltimoPosicionamientoSinContestar(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getConfirmacionBCPosicionamiento(ModelMap model, Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getUltimoPosicionamientoEnviado(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFechaArras(Long idExpediente) {

		ModelMap model = new ModelMap();

		try {
			List<DtoGridFechaArras> list = expedienteComercialApi.getFechaArras(idExpediente);
			model.put(RESPONSE_DATA_KEY, list);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getGestorPrescriptor)", e);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFechaArras(DtoGridFechaArras dto) {

		ModelMap model = new ModelMap();

		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveFechaArras(dto));
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getGestorPrescriptor)", e);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateFechaArras(DtoGridFechaArras dto) {

		ModelMap model = new ModelMap();

		try {
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.updateFechaArras(dto));
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController (getGestorPrescriptor)", e);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getUltimaResolucionComiteBC(ModelMap model, Long idExpediente) {
		try {
			List<DtoRespuestaBCGenerica> dtoRespuestaBCGenericaList = expedienteComercialApi.getListResolucionComiteBC(idExpediente);
			model.put(RESPONSE_DATA_KEY, (dtoRespuestaBCGenericaList != null && !dtoRespuestaBCGenericaList.isEmpty()) ? dtoRespuestaBCGenericaList.get(0) : null);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getValoresTareaBloqueo(ModelMap model, Long idTarea, String codTarea) {
		try {
			DtoScreening dto = (DtoScreening) expedienteComercialApi.devolverValoresTEB(idTarea, codTarea);
			model.put(RESPONSE_DATA_KEY, dto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView bloqueoScreening(ModelMap model,Long numOferta, String motivo, String observaciones) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", numOferta);
			Oferta oferta = genericDao.get(Oferta.class, filtro);
			expedienteComercialApi.tareaBloqueoScreening(expedienteComercialApi.dataToDtoScreeningBloqueo(  oferta.getNumOferta(),  motivo,  observaciones));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView desBloqueoScreening(ModelMap model,Long numOferta, String motivo, String observaciones) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", numOferta);
			Oferta oferta = genericDao.get(Oferta.class, filtro);
			expedienteComercialApi.tareaDesbloqueoScreening(expedienteComercialApi.dataToDtoScreeningDesBloqueo( oferta.getNumOferta(),  motivo,  observaciones));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView haPasadoSeguroRentas(ModelMap model,Long idTarea) {
		try {
			model.put(RESPONSE_DATA_KEY, tramiteAlquilerApi.haPasadoSeguroDeRentas(idTarea));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getEntidadFinancieraFiltro(ModelMap model, WebDto webDto, Long idExpediente) {
		try {
			List<DDEntidadFinanciera> lista = expedienteComercialApi.getListEntidadFinanciera(idExpediente);
			model.put(RESPONSE_DATA_KEY, lista);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSancionesBk(ModelMap model, WebDto webDto, Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getListHistoricoSancionesBC(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActualizacionRenta(ModelMap model, WebDto webDto, Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getActualizacionRenta(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView deleteActualizacionRenta(ModelMap model, WebDto webDto, Long id) {
		try {
			expedienteComercialApi.deleteActualizacionRenta(id);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView addActualizacionRenta(DtoActualizacionRenta dto, @RequestParam Long idExpediente, ModelMap model,HttpServletRequest request) {
		try {
			expedienteComercialApi.addActualizacionRenta(idExpediente, dto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActualizacionRenta(DtoActualizacionRenta dto, @RequestParam Long id, ModelMap model,HttpServletRequest request) {
		try {
			expedienteComercialApi.updateActualizacionRenta(id, dto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFormalizacionResolucion(ModelMap model, DtoFormalizacionResolucion dto,
			HttpServletRequest request) {
		try {

			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveFormalizacionResolucion(dto));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView haPasadoAceptacionCliente(ModelMap model,Long idTramite) {
		try {
			model.put(RESPONSE_DATA_KEY, tramiteAlquilerApi.haPasadoAceptacionCliente(idTramite));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getValoresTareaElevarSancion(ModelMap model, Long idTarea) {
		try {
			DtoAccionAprobacionCaixa dto = (DtoAccionAprobacionCaixa) expedienteComercialApi.devolverValoresTEB(idTarea, ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_ELEVAR_SANCION);
			model.put(RESPONSE_DATA_KEY, dto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveGarantiasExpediente(DtoGarantiasExpediente dto, @RequestParam Long id, ModelMap model,
			HttpServletRequest request) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.saveGarantiasExpediente(dto, id));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTestigos(Long id, ModelMap model) {
		try{
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getTestigos(id));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("error en ExpedienteComercialController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getInfoCaminosAlquilerNoComercial(Long idExpediente, ModelMap model, HttpServletRequest request) {
		try {
			model.put(RESPONSE_DATA_KEY, tramiteAlquilerNoComercialApi.getInfoCaminosAlquilerNoComercial(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getValoresTareaBloqueoScreeningAlquiler(ModelMap model, Long idTarea) {
		try {
			DtoScreening dto = (DtoScreening) expedienteComercialApi.devolverValoresTEB(idTarea, ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCREENING);
			model.put(RESPONSE_DATA_KEY, dto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createGastoRepercutido(Long idExpediente, DtoGastoRepercutido dto, ModelMap model, HttpServletRequest request) {
		try {
			expedienteComercialApi.createGastoRepercutido(dto, idExpediente);
			model.put(RESPONSE_SUCCESS_KEY, true);
		}catch(DataIntegrityViolationException e){
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, "No puede haber más de un gasto repercutido del mismo tipo");
		}catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGastosRepercutidosList(Long idExpediente,  ModelMap model, HttpServletRequest request) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getGastosRepercutidosList(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveTestigos(DtoTestigos dtoTestigos,  @RequestParam Long idEntidad, ModelMap model) {
		try{
			model.put(RESPONSE_DATA_KEY, dtoTestigos);
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.saveTestigos(dtoTestigos, idEntidad));
		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);
		} catch (Exception e) {
			logger.error("error en ExpedienteComercialController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getValoresTareaBloqueoScreeningAlquilerNoComercial(ModelMap model, Long idTarea) {
		try {
			DtoScreening dto = (DtoScreening) expedienteComercialApi.devolverValoresTEB(idTarea, ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCREENING);
			model.put(RESPONSE_DATA_KEY, dto);
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteGastoRepercutido(Long id,  ModelMap model, HttpServletRequest request) {
		try {
			expedienteComercialApi.deleteGastoRepercutido(id);
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getScoringGarantias(ModelMap model, Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getScoringGarantias(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getCamposAnulacionInformados(Long idExpediente, ModelMap model) {

		ExpedienteComercial eco = null;
		boolean response = false;

		try {

			if (Checks.esNulo(idExpediente)) {
				throw new JsonViewerException("No se ha informado el expediente comercial.");

			} else {
				eco = expedienteComercialApi.findOne(idExpediente);
				if (Checks.esNulo(eco)) {
					throw new JsonViewerException("No existe el expediente comercial.");
				}
				response = funcionesTramitesApi.tieneRellenosCamposAnulacion(eco);
			}
			model.put("success", response);

		} catch (JsonViewerException e) {
			
			model.put("success", response);
			model.put("msgError", e.getMessage());

		} catch (Exception e) {
			logger.error("Error al saltar a resolución expediente", e);
			model.put("success", response);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getResultadoRatingScoring(ModelMap model) {
		
		model.put(RESPONSE_DATA_KEY, expedienteComercialApi.getDDRatingScoringOrderByCodC4c());
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getDatosDocPostVenta(ModelMap model, Long idExpediente) {
		try {
			model.put(RESPONSE_DATA_KEY, tramiteVentaApi.getDatosDocPostventa(idExpediente));
			model.put(RESPONSE_SUCCESS_KEY, true);

		} catch (Exception e) {
			model.put("error", false);
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteTestigos(DtoTestigos dtoTestigos, ModelMap model) {
		try{
			model.put(RESPONSE_DATA_KEY, dtoTestigos);
			model.put(RESPONSE_SUCCESS_KEY, expedienteComercialApi.deleteTestigos(dtoTestigos));
		} catch (JsonViewerException e) {
			model.put(RESPONSE_MESSAGE_KEY, e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.warn("Error controlado en ExpedienteComercialController", e);
		} catch (Exception e) {
			logger.error("error en ExpedienteComercialController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}
}
