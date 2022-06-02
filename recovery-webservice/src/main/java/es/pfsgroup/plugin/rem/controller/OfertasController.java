package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.PathParam;

import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.plugin.rem.accionesCaixa.CaixaBcReplicationDataHolder;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.oferta.ReplicacionOfertasManager;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.config.ConfigManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.http.client.HttpSimplePostRequest;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.OfertaGridExcelReport;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaAceptacionYRechazo;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.AuditoriaExportaciones;
import es.pfsgroup.plugin.rem.model.DtoDatosBancariosDeposito;
import es.pfsgroup.plugin.rem.model.DtoDeposito;
import es.pfsgroup.plugin.rem.model.DtoExcelFichaComercial;
import es.pfsgroup.plugin.rem.model.DtoHonorariosOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertaGridFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertantesOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.model.DtoVListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VGridBusquedaOfertas;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaVivaRespuestaDto;
import es.pfsgroup.plugin.rem.rest.dto.ReportGeneratorRequest;
import es.pfsgroup.plugin.rem.rest.dto.ReportGeneratorResponse;
import es.pfsgroup.plugin.rem.rest.dto.TareaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.tareasactivo.dao.ActivoTareaExternaDao;
import es.pfsgroup.plugin.rem.thread.ConvivenciaRecovery;
import es.pfsgroup.plugin.rem.thread.EnviarCorreoFichaComercialExcel;
import es.pfsgroup.plugin.rem.utils.EmptyParamDetector;
import net.sf.json.JSONObject;

@Controller
public class OfertasController {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private OfertaDao ofertaDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private RestApi restApi;
		
	@Autowired
	private GenericAdapter genericAdapter;
	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	GenericABMDao genericDao;
		
	@Autowired
	private NotificationOfertaManager notificationOferta;
	
	@Autowired
	private ActivoTareaExternaDao activoTareaExternaDao;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoManager activoManager;
	
	@Autowired
	private AgendaAdapter agendaAdapter;

	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private ConfigManager configManager;
	
	@Autowired 
	private OfertaManager ofertaManager;
	
	@Resource
	private Properties appProperties;

	@Autowired
	private CaixaBcRestClient caixaBcRestClient;

	@Autowired
	private ParticularValidatorApi particularValidatorApi;

	@Autowired
	private ReplicacionOfertasManager replicacionOfertasManager;
	
	@Autowired
	private NotificatorServiceSancionOfertaAceptacionYRechazo notificatorSancionOferta;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	public static final String ERROR_NO_EXISTE_OFERTA_O_TAREA = "El número de oferta es inválido o no existe la tarea.";
	
	private static final String RESPONSE_SUCCESS_KEY = "success";	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	private static final String RESPONSE_ERROR_KEY = "error";
	
	private static final String CONSTANTE_GENERAR_EXCEL_REM_API_URL = "rest.client.generate.excel.url.base";
	private static final String CONSTANTE_GENERAR_EXCEL_REM_API_ENDPOINT = "rest.client.generate.excel.endpoint";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoOfertaGridFilter dto, HttpServletRequest request, HttpServletResponse response) throws IOException {
		dto.setStart(excelReportGeneratorApi.getStart());
		dto.setLimit(excelReportGeneratorApi.getLimit());
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		List<VGridBusquedaOfertas> listaOfertas = (List<VGridBusquedaOfertas>) ofertaApi.getBusquedaOfertasGridUsuario(dto).getResults();
		HashMap<Long,String> fechasReunionComite = new HashMap<Long, String>();
		HashMap<Long,String> sancionadores = new HashMap<Long, String>();
		boolean esCarteraLBK = false;
		
		if((usuarioCartera != null  && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(usuarioCartera.getCartera().getCodigo()))
				|| DDCartera.CODIGO_CARTERA_LIBERBANK.equals(dto.getCarteraCodigo())){			
			esCarteraLBK = true;
			for(VGridBusquedaOfertas oferta : listaOfertas){
				List<Long> tareasExternasId = activoTareaExternaDao.getTareasExternasIdByOfertaId(oferta.getId());
				Filter filterTap01 = genericDao.createFilter(FilterType.EQUALS, "codigo", "T013_ResolucionComite");
				Long idResolucionComite = genericDao.get(TareaProcedimiento.class, filterTap01).getId();
				Filter filterTap02 = genericDao.createFilter(FilterType.EQUALS, "codigo", "T015_ResolucionExpediente");
				Long idResolucionExpediente = genericDao.get(TareaProcedimiento.class, filterTap02).getId();
				
				if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getCodigoTipoOferta()) || DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getCodigoTipoOferta())){
					for(Long tareaExternaId : tareasExternasId){
						TareaExterna tareaExterna = activoTareaExternaApi.get(tareaExternaId);
						if(idResolucionComite.equals(tareaExterna.getTareaProcedimiento().getId()) ||
						   idResolucionExpediente.equals(tareaExterna.getTareaProcedimiento().getId())){
							List<TareaExternaValor> valores = activoTareaExternaDao.getByTareaExterna(tareaExterna.getId());
							for(TareaExternaValor valor : valores){
								if(("fechaReunionComite").equals(valor.getNombre())){
									fechasReunionComite.put(oferta.getId(), valor.getValor());
								}
								if(("comiteInternoSancionador").equals(valor.getNombre())){
									sancionadores.put(oferta.getId(), valor.getValor());
								}
							}
						}
					}
				}
			}
		}

		new EmptyParamDetector().isEmpty(listaOfertas.size(), "ofertas",  usuarioManager.getUsuarioLogado().getUsername());		
		ExcelReport report = new OfertaGridExcelReport(listaOfertas, esCarteraLBK, fechasReunionComite, sancionadores);
		excelReportGeneratorApi.generateAndSend(report, response);
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	@Transactional()
	public ModelAndView registrarExportacion(DtoOfertaGridFilter dto, Boolean exportar, String buscador, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
				int count = ofertaApi.getBusquedaOfertasGridUsuario(dto).getTotalCount();
				AuditoriaExportaciones ae = new AuditoriaExportaciones();
				ae.setBuscador(buscador);
				ae.setFechaExportacion(new Date());
				ae.setNumRegistros(Long.valueOf(count));
				ae.setUsuario(user);
				ae.setFiltros(filtros);
				ae.setAccion(exportar);
				genericDao.save(AuditoriaExportaciones.class, ae);
				model.put(RESPONSE_SUCCESS_KEY, true);
				model.put(RESPONSE_DATA_KEY, count);
				for(Perfil pef : user.getPerfiles()) {
					if(pef.getCodigo().equals("SUPEREXPORTOFR")) {
						isSuperExport = true;
						break;
					}
				}
				if(isSuperExport) {
					model.put("limite", configManager.getConfigByKey("super.limite.exportar.excel.ofertas").getValor());
					model.put("limiteMax", configManager.getConfigByKey("super.limite.maximo.exportar.excel.ofertas").getValor());
				}else {
					model.put("limite", configManager.getConfigByKey("limite.exportar.excel.ofertas").getValor());
					model.put("limiteMax", configManager.getConfigByKey("limite.maximo.exportar.excel.ofertas").getValor());
				}
			} else {
				model.put("msg", cuentaAtras);
			}
		}catch(Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en ofertasController", e);
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
	
	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}

	/**
	 * Inserta o actualiza una lista de Ofertas Ejem: IP:8080/pfs/rest/ofertas
	 * HEADERS: Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"111111114111","data": [{
	 * "idOfertaWebcom": "1000", "idVisitaRem": "1", "idClienteRem": "1",
	 * "activosLote": ["6346320", "6346321", "6346322"],
	 * "codEstadoOferta": "04","codTipoOferta": "01", "fechaAccion":
	 * "2016-01-01T10:10:10", "idUsuarioRemAccion": "29468",
	 * "importeContraoferta": null, "idProveedorRemPrescriptor": "1000",
	 * "idProveedorRemCustodio": "1000", "idProveedorRemResponsable": "1000",
	 * "idProveedorRemFdv": "1000" , "importe": "1000.2",
	 * "titularesAdicionales": [{"nombre": "Nombre1", "codTipoDocumento": "15",
	 * "documento":"48594626F"}, {"nombre": "Nombre2", "codTipoDocumento": "15",
	 * "documento":"48594628F"}],
	 * "fechaCreacionOpSf": "2016-01-01T10:10:10"}]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/ofertas")
	public void saveOrUpdateOferta(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		OfertaRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;
		List<OfertaDto> listaOfertaDto = null;

		try {

			jsonFields = request.getJsonObject();
			jsonData = (OfertaRequestDto) request.getRequestData(OfertaRequestDto.class);
			listaOfertaDto = jsonData.getData();

			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {

				ofertaApi.saveOrUpdateOfertas(listaOfertaDto, jsonFields, listaRespuesta);

				model.put("id", jsonFields.get("id"));
				model.put("data", listaRespuesta);
				model.put("error", "null");
			}

		} catch (UserException e) {
			if (jsonFields!=null) {
				model.put("id", jsonFields.get("id"));
			}
			model.put("data", listaRespuesta);
			model.put("error", "null");
		} catch (Exception e) {
			logger.error("Error ofertas", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			if (jsonFields!=null) {
				model.put("id", jsonFields.get("id"));			
			}
			if (listaRespuesta.isEmpty()) {
				model.put("data", e.getMessage());
			} else {
				model.put("data", listaRespuesta);
			}
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			String descError = e.getClass().toString();
			model.put("descError", descError != null ? descError.substring(6) : null);
		}

		restApi.sendResponse(response, model, request);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDetalleOfertaById(Long id, ModelMap model) {

		try {
			model.put("data", ofertaApi.getDetalleOfertaById(id));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getOfertantesByOfertaId(Long ofertaID, ModelMap model) {

		try {
			model.put("data", ofertaApi.getOfertantesByOfertaId(ofertaID));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateOfertantesByOfertaId(DtoOfertantesOferta dtoOfertantesOferta, ModelMap model) {
		try {
			model.put("data", ofertaApi.updateOfertantesByOfertaId(dtoOfertantesOferta));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHonorariosByOfertaId(DtoHonorariosOferta dtoHonorariosOferta, ModelMap model) {

		try {
			model.put("data", ofertaApi.getHonorariosByOfertaId(dtoHonorariosOferta));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHonorariosByActivoOferta(Long idOferta, Long idActivo, ModelMap model) {

		try {
			model.put("data", ofertaApi.getHonorariosActivoByOfertaId(idActivo, idOferta));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioSubtipoProveedorCanal(){
		return createModelAndViewJson(new ModelMap("data", ofertaApi.getDiccionarioSubtipoProveedorCanal()));
	}
	

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelOferta(Long idEco, Long idOferta, HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		List <DtoPropuestaAlqBankia> listaPropuestaAlquilerBankia = ofertaApi.getListPropuestasAlqBankiaFromView(idEco);
		
		File file = excelReportGeneratorApi.generateBankiaReport(listaPropuestaAlquilerBankia, request);
		excelReportGeneratorApi.sendReport(file, response);
		Oferta oferta = ofertaApi.getOfertaById(idOferta);
		notificationOferta.sendNotificationPropuestaOferta(oferta, new FileItem(file));
	}


	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarMailAprobacion(ModelMap model, Long idOferta) {

		try {

			Oferta oferta = ofertaApi.getOfertaById(idOferta);
			String errorCode = notificationOferta.enviarMailAprobacion(oferta);

			if(errorCode == null || errorCode.isEmpty()){
				model.put("success", true);
			}
			else{
				model.put("success", false);
				model.put("errorCode", errorCode);
			}


		}
		catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errorCode", "imposible.bloquear.general");
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView checkPedirDoc(Long idActivo, Long idAgrupacion, Long idExpediente, String dniComprador, String codtipoDoc, ModelMap model) {
		String clienteGD = null;
		try {
			if (!Checks.esNulo(idExpediente)) {
				clienteGD = ofertaManager.getClienteByidExpedienteGD(idExpediente);
			}
			
			if(!Checks.esNulo(clienteGD)) {
				ofertaApi.llamadaMaestroPersonas(dniComprador, clienteGD);
			}else {
				ofertaApi.llamadaMaestroPersonas(dniComprador, OfertaApi.CLIENTE_HAYA);
			}
			
			//model.put("data", ofertaApi.checkPedirDoc(idActivo,idAgrupacion,idExpediente, dniComprador, codtipoDoc));
			model.put("data", false);
			model.put("comprador",ofertaApi.getClienteGDPRByTipoDoc(dniComprador, codtipoDoc));
			model.put("compradorId", expedienteComercialApi.getCompradorIdByDocumento(dniComprador, codtipoDoc));
			model.put("destinoComercial", ofertaApi.getDestinoComercialActivo(idActivo, idAgrupacion, idExpediente));
			model.put("carteraInternacional", ofertaApi.esCarteraInternacional(idActivo, idAgrupacion, idExpediente));
			if (!Checks.esNulo(idActivo)) {
				Activo activo = activoApi.get(idActivo);
				model.put("esHayaHome", activoManager.esActivoHayaHome(activo, null));
			} else if (!Checks.esNulo(idAgrupacion)) {
				model.put("esHayaHome", activoManager.esActivoHayaHome(activoManager.activoByIdAgrupacion(idAgrupacion), null));
			}
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView esCarteraInternacional(Long idActivo, Long idAgrupacion, Long idExpediente, ModelMap model) {

		try {
			model.put("carteraInternacional", ofertaApi.esCarteraInternacional(idActivo, idAgrupacion, idExpediente));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked") 
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getOfertaOrigenByIdExpediente(Long numExpediente, ModelMap model){
		try {
			model.put("data", ofertaApi.getOfertaOrigenByIdExpediente(numExpediente));
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET, value="ofertas/getOfertasVivasActGestoria")
	public void getOfertasVivasActGestoria(@PathParam("id") String id, @PathParam("numActivo") String numActivo, @PathParam("codGestoria") String codGestoria, ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
	  try {
		Usuario usuarioGestoria = null; 
		DtoOfertasFilter filtro = new DtoOfertasFilter();
		Boolean flagParametrosANulo = false;
		Boolean flagnumActivoNoExiste = false;
		Boolean flagcodGestoriaNoExiste = false;
		Boolean flagRelacionNumActivoCodGestoriaNoExiste = false;
		String error = null;
		String errorDesc = null;
		List<OfertaVivaRespuestaDto> ofertasList = new ArrayList<OfertaVivaRespuestaDto>();
		Long numActivoL = null;
		Long idL = null;
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
			
			
				if(Checks.esNulo(idL) || Checks.esNulo(numActivo) || Checks.esNulo(codGestoria)) {
					flagParametrosANulo = true;
				}else if(Checks.esNulo(activoDao.getActivoByNumActivo(numActivoL))){
					flagnumActivoNoExiste = true;
				}else if(Checks.esNulo(genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", codGestoria)))){
					flagcodGestoriaNoExiste = true;
				}else{
				
					usuarioGestoria  = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", codGestoria));
					filtro.setGestoria(usuarioGestoria.getId());
			
					
			
					filtro.setNumActivo(numActivoL);
					filtro.setLimit(100);
					
					
					//Gestoria, comprobar que exista en la BD
					//Oferta relacionada que devuelva algo ofertasVivasActGestoria
					
					
					DtoPage page = ofertaApi.getListOfertasGestoria(filtro);
					
					VGridOfertasActivosAgrupacionIncAnuladas voaa;
					
					
					
					Oferta oferta;
					OfertaVivaRespuestaDto ofr;
					if(!Checks.esNulo(page) && !Checks.esNulo(page.getResults())) {
						for (Object obj : page.getResults()) {
							
								voaa = (VGridOfertasActivosAgrupacionIncAnuladas) obj;
								oferta = ofertaApi.getOfertaById(voaa.getId());
								if(ofertaApi.estaViva(oferta)) {			
									ofr = new OfertaVivaRespuestaDto();
									ofr.setNumOferta(oferta.getNumOferta()); //Número oferta
									ofr.setCodEstadoEco(voaa.getCodigoEstadoExpediente()); //Estado expediente
									// Activos [ini]
									List<Long> listaIds = new ArrayList<Long>();
									for (ActivoOferta activoOfr : oferta.getActivosOferta()) {
										Long activoId = activoOfr.getActivoId();
										listaIds.add(activoId);
									}
									List<Activo> activosLista = activoApi.getListActivosPorID(listaIds);
									List<Long> activoNumLista = new ArrayList<Long>();
									for (Activo activo : activosLista) {
										activoNumLista.add(activo.getNumActivo());
									}
									ofr.setResultado(activoNumLista); //Activos [fin]
									ofertasList.add(ofr);
									
								}
							}
						}
				}
				
				if(Checks.estaVacio(ofertasList)) {
					flagRelacionNumActivoCodGestoriaNoExiste = true;
				}
			}
		}
		//El id, tanto en el try como en el catch, lo debe devolver siempre

		try {
			if(flagParametrosANulo) {
				error = RestApi.REST_NO_PARAM;
				if(Checks.esNulo(idL)) {
					error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
					errorDesc = "Falta el campo id";
					throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				}else if( Checks.esNulo(numActivo)) {
					errorDesc = "Falta el campo numActivo";
				}else {
					errorDesc = "Falta el campo codGestoria";
				}
				throw new Exception(RestApi.REST_NO_PARAM);
			}
			if(flagnumActivoNoExiste || flagcodGestoriaNoExiste) {
				error = RestApi.REST_MSG_UNKNOW_KEY;
				if(flagnumActivoNoExiste) {
					errorDesc = "El activo " + numActivo + " no existe.";
				}else {
					errorDesc = "La gestoria " + codGestoria + " no existe.";
				}
				throw new Exception(RestApi.REST_MSG_UNKNOW_KEY);
			}
			if(flagRelacionNumActivoCodGestoriaNoExiste){
				error = RestApi.REST_MSG_NO_RELATED_OFFER;
				errorDesc = "No existe oferta relacionada con el activo "+ numActivo +" y la gestoria " + codGestoria;
				throw new Exception(RestApi.REST_MSG_NO_RELATED_OFFER);
			}

			if(!Checks.esNulo(idL) && !Checks.esNulo(numActivoL)) {
				model.put("id", 0);
				model.put("id", id);
				model.put("data", ofertasList);
				model.put("error", "null");
				model.put("success", true);
			}
			
		}catch(Exception e) {
			logger.error("Error en OfertasController, metodo getOfertasVivasActGestoria", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", id);
			model.put("error", error);
			model.put("errorDesc", errorDesc );
			model.put("success", false);
		}
		
		restApi.sendResponse(response, model, request);
	  }	
	  catch(Exception e) {
		  logger.error("Error en OfertasController, metodo getOfertasVivasActGestoria", e);
		  request.getPeticionRest().setErrorDesc(e.getMessage());
		  model.put("id", id);
		  model.put("data", null);
		  model.put("error", RestApi.CODE_ERROR);
		  model.put("errorDesc", RestApi.CODE_ERROR );
		  model.put("success", false);
	  }
	}
	
	/**
	 * Avanza Ofertas Ejem: http://172.17.0.2:8080/pfs/rest/ofertas/avanzaOferta
	 * HEADERS: Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {
	 * 			"id":"1234",
	 *			"ofrNumOferta" :"90185574",
	 *			"codTarea"	: "T013_DefinicionOferta",
	 *			"data": {"observaciones":["asdasdasd"],
	 *			"comboConflicto":["02"],
	 *			"comboRiesgo":["02"],
	 *			"comite":["29"],
	 *			"fechaEnvio":["05/06/2019"],
	 *			"numExpediente":["164698"],
	 *			"comiteSuperior":["02"]
	 *			}
	 *	}
	 * 
	 * @param model
	 * @param request
	 * @return model
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/ofertas/avanzaOferta")
	public void avanzaOferta( ModelMap model, RestRequestWrapper request, HttpServletResponse response){
		TareaRequestDto jsonData = null;
		Map<String, String[]> datosTarea = new HashMap<String, String[]>();
		JSONObject jsonFields = null;
		Long tareaId = null;
		String[] idTarea = new String[1];
		boolean resultado = false;
		String ofrNumOferta = "";
		String codTarea = "";
		String id = null;
		String error = null;
		String errorDesc = null;
		
		try {

			jsonFields = request.getJsonObject();
			jsonData = (TareaRequestDto) request.getRequestData(TareaRequestDto.class);
					
			if(jsonFields == null || jsonFields.isNullObject() || jsonFields.isEmpty()
					|| Checks.esNulo(jsonData.getId()) || Checks.esNulo(jsonData.getData())) {
				error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
				errorDesc = "Faltan campos";
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
			} else {				
				
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
				ofrNumOferta = jsonFields.get("ofrNumOferta").toString();
				try {
					Long.valueOf(ofrNumOferta);
				}catch(Exception e){
					error = RestApi.REST_MSG_FORMAT_ERROR;
					errorDesc = "El formato el número de oferta no es el correcto.";
					throw new Exception(RestApi.REST_MSG_FORMAT_ERROR);
				}
				if(Checks.esNulo(ofertaApi.getOfertaByNumOfertaRem(Long.valueOf(ofrNumOferta)))){
					
					error = RestApi.REST_MSG_UNKNOW_OFFER;
					errorDesc = "La oferta " + ofrNumOferta + " no existe";
					throw new Exception(RestApi.REST_MSG_UNKNOW_OFFER);
					
				}else {
					codTarea = jsonFields.get("codTarea").toString();
					
					
					
					
					if(!ofertaDao.tieneTareaActiva(codTarea, ofrNumOferta)) 
					{
						if (ofertaDao.tieneTareaFinalizada(codTarea, ofrNumOferta)) {
							
							error = RestApi.REST_MSG_VALIDACION_TAREA;
							errorDesc = "La tarea " + codTarea + " ya está avanzada en esta oferta.";
							throw new Exception(RestApi.REST_MSG_VALIDACION_TAREA);
							
						}else {
							error = RestApi.REST_MSG_VALIDACION_TAREA;
							errorDesc = "La tarea " + codTarea + " no está activa en esta oferta.";
							throw new Exception(RestApi.REST_MSG_VALIDACION_TAREA);
						}
						
						
						
					}
					
					tareaId = ofertaApi.getIdTareaByNumOfertaAndCodTarea(Long.parseLong(ofrNumOferta.toString()), codTarea);
					
					if(Checks.esNulo(tareaId)) {
						error = RestApi.REST_MSG_VALIDACION_TAREA;
						errorDesc = "La tarea " + codTarea + " no existe.";
						throw new Exception(RestApi.REST_MSG_VALIDACION_TAREA);
					}
					else {
						idTarea[0] = tareaId.toString();
						datosTarea.put("idTarea",idTarea);

						CaixaBcReplicationDataHolder dataHolder = new CaixaBcReplicationDataHolder();
						dataHolder.setIdTarea(tareaId);
						dataHolder.setNumOferta(Long.parseLong(ofrNumOferta));
						dataHolder.setPreviousStateExpedienteBcCod(expedienteComercialApi.getEstadoExpedienteBcFromNumOferta(Long.parseLong(ofrNumOferta)));

						if(!ofertaApi.bloqueoResolucionExpedienteCFV(tareaId)){
							resultado = agendaAdapter.validationAndSave(datosTarea);
						}else{
							error = RestApi.REST_MSG_VALIDACION_TAREA;
							errorDesc = "No se puede anular la tarea " + codTarea + " mientras la reserva esté en estado 'Firmada'.";
							throw new Exception(RestApi.REST_MSG_VALIDACION_TAREA);
						}
						
						if (resultado) {
							error = null;
							errorDesc = null;



						if (particularValidatorApi.esOfertaCaixa(ofrNumOferta)){
								replicacionOfertasManager.callReplicateOferta(dataHolder,Boolean.TRUE);
							}
						}						
						model.put("id", id);
						model.put("ofrNumOferta", ofrNumOferta);
						model.put("codTarea", codTarea);
						model.put("data", resultado);
						model.put("success", resultado);
						
					}
				}
			}

			//El id, tanto en el try como en el catch, lo debe devolver siempre
		} catch (Exception e) {
			logger.error("Error avance tarea ", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", id);
			if(error == null || errorDesc == null) {
				model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
				model.put("descError", e.getMessage());
			}else {
				model.put("error",error);
				model.put("descError", errorDesc);
			}
			model.put("success", false);
		}

		restApi.sendResponse(response, model, request);
	}


	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertasAgrupadas(DtoVListadoOfertasAgrupadasLbk dtoOfertasAgrupadas, ModelMap model){
		{
			try {

				DtoPage page = ofertaApi.getListOfertasAgrupadasLiberbank(dtoOfertasAgrupadas);
				model.put("data", page.getResults());
				model.put("totalCount", page.getTotalCount());
				model.put("success", true);

			} catch (Exception e) {
				logger.error("Error en ofertasController", e);
				model.put("success", false);
			}
			
			
			return createModelAndViewJson(model);
		}
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosOfertasAgrupadas(DtoVListadoOfertasAgrupadasLbk dtoOfertasAgrupadas, ModelMap model){
		{
			try {
				DtoPage page = ofertaApi.getListActivosOfertasAgrupadasLiberbank(dtoOfertasAgrupadas);
				model.put("data", page.getResults());
				model.put("totalCount", page.getTotalCount());
				model.put("success", true);
	

			} catch (Exception e) {
				logger.error("Error en ofertasController", e);
				model.put("success", false);
			}
			
			
			return createModelAndViewJson(model);
		}
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelOfertaCES(DtoOfertasFilter dtoOfertasFilter, HttpServletRequest request, HttpServletResponse response) throws IOException {
		ExcelReport report = ofertaApi.generarExcelOfertasCES(dtoOfertasFilter);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getClaseOferta(Long idExpediente, ModelMap model) {
		ExpedienteComercial eco = expedienteComercialApi.findOne(idExpediente);
		Filter filtroOfertaOfertaDependiente = genericDao.createFilter(FilterType.EQUALS ,"ofertaDependiente.id", eco.getOferta().getId());
		OfertasAgrupadasLbk ofertaDependiente = genericDao.get(OfertasAgrupadasLbk.class, filtroOfertaOfertaDependiente);
		
		String claseOferta = "";
		if(!Checks.esNulo(eco) && DDClaseOferta.CODIGO_OFERTA_PRINCIPAL.equals(eco.getOferta().getClaseOferta().getCodigo())) {
			claseOferta = DDClaseOferta.CODIGO_OFERTA_PRINCIPAL;
		}else if(!Checks.esNulo(eco) && DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE.equals(eco.getOferta().getClaseOferta().getCodigo()) && !Checks.esNulo(ofertaDependiente)  ) {
			claseOferta = DDClaseOferta.CODIGO_OFERTA_DEPENDIENTE;
		}else if(!Checks.esNulo(eco) && DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL.equals(eco.getOferta().getClaseOferta().getCodigo())) {
			claseOferta = DDClaseOferta.CODIGO_OFERTA_INDIVIDUAL;
		}
		model.put("claseOferta", claseOferta);
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView isActivoEnDND(Long idActivo, ModelMap model) {
		Activo activo = activoDao.getActivoById(idActivo);
	
		try {	
			model.put("isDND", activo.getIsDnd());
			model.put("success", true);
		}catch(Exception e) {
			model.put("success", false);
			model.put("error", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView isEpaAlquilado(Long idAgrupacion, ModelMap model) {
		Integer agrupacionEpaAlquilado = ofertaApi.isEpaAlquilado(idAgrupacion);
	
		try {	
			model.put("agrupacionEpaAlquilado", agrupacionEpaAlquilado);
			model.put("success", true);
		}catch(Exception e) {
			model.put("success", false);
			model.put("error", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelBBVA(Long idExpediente, HttpServletRequest request, HttpServletResponse response) throws IOException {

		try {
			 	DtoExcelFichaComercial listaOfertasFilter = ofertaApi.getListOfertasFilter(idExpediente);
				File file = null;
				file = excelReportGeneratorApi.generateBbvaReportGetFile(listaOfertasFilter,request);
				excelReportGeneratorApi.sendReport(file, response);
			

		} catch (Exception e) {
			e.printStackTrace();
 
		}
	}
	
//	@SuppressWarnings("unchecked")
//	@RequestMapping(method = RequestMethod.POST)
//	public ModelAndView generarFichaComercial(ModelMap model, Long idOferta, Long idExpediente, HttpServletRequest request) {
//
//		try {
//
//			Oferta oferta = ofertaApi.getOfertaById(idOferta);
//			DtoExcelFichaComercial dtoExcelFichaComercial = ofertaApi.getListOfertasFilter(idExpediente);
//			String nameFile = excelReportGeneratorApi.generateBbvaReportGetName(dtoExcelFichaComercial,request);
//			String errorCode = notificationOferta.enviarMailFichaComercial(oferta, nameFile,request);
//
//			if(errorCode == null || errorCode.isEmpty()){
//				model.put("success", true);
//			}
//			else{
//				model.put("success", false);
//				model.put("errorCode", errorCode);
//			}
//
//		}
//		catch (Exception e) {
//			e.printStackTrace();
//			model.put("success", false);
//			model.put("errorCode", e.getMessage());
//		}
//
//		return createModelAndViewJson(model);
//
//	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getBusquedaOfertasGrid(DtoOfertaGridFilter dto, ModelMap model) {
		try {
			Page page = ofertaApi.getBusquedaOfertasGridUsuario(dto);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
			
		} catch (Exception e) {			
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error("Error en ofertasController", e);
		}
		return createModelAndViewJson(model);
	}


	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView actualizaEstadoOferta(Long idOferta, String codigoEstado, ModelMap model) {
		try {
			Boolean actualizado = ofertaApi.actualizaEstadoOferta(idOferta, codigoEstado);
			if (actualizado && DDEstadoOferta.CODIGO_PENDIENTE.equals(codigoEstado)){
				Oferta oferta = ofertaApi.getOfertaById(idOferta);
				caixaBcRestClient.callReplicateClient(oferta.getNumOferta(), CaixaBcRestClient.CLIENTE_TITULARES_DATA);
				if (!DDTipoOferta.isTipoAlquilerNoComercial(oferta.getTipoOferta())) {
					ofertaApi.replicateOfertaFlush(oferta);
				}
			}
			model.put(RESPONSE_SUCCESS_KEY, actualizado);

		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
			logger.error("Error en ofertasController", e);
		}
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateReport(ReportGeneratorRequest request, HttpServletResponse response) throws IOException {
		String urlBaseGenerateExcel = appProperties.getProperty(CONSTANTE_GENERAR_EXCEL_REM_API_URL);
		String urlEndpointGenerateExcel = appProperties.getProperty(CONSTANTE_GENERAR_EXCEL_REM_API_ENDPOINT);
		ReportGeneratorResponse report = excelReportGeneratorApi.requestExcel(request, urlBaseGenerateExcel.concat(urlEndpointGenerateExcel));
	 	if(report != null)
	 		excelReportGeneratorApi.downloadExcel(report, response);
	 	
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	@Transactional(readOnly = false)
	public ModelAndView enviarCorreoFichaComercialThread(ReportGeneratorRequest reportGenerator,  HttpServletRequest request, HttpServletResponse response, ModelMap model) throws IOException {
		Thread llamadaAsincrona = new Thread(new EnviarCorreoFichaComercialExcel(reportGenerator.getListId(), reportGenerator.getReportCode(), request.getScheme(), request.getServerName(), usuarioManager.getUsuarioLogado().getUsername()));
		
		llamadaAsincrona.start();
		
		model.put(RESPONSE_SUCCESS_KEY, true);
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView enviarMailAprobacionVenta(ModelMap model, Long idOferta) {

		try {
			Oferta oferta = ofertaApi.getOfertaById(idOferta);
			List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(oferta.getExpedienteComercial().getTrabajo().getId());
			notificatorSancionOferta.sendNotification(listaTramites.get(0),false, oferta, true, false, null);

			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTextosOfertaByActivoOferta(Long idOferta, ModelMap model) {

		try {
			model.put("data", ofertaApi.getListTextosOfertaByOferta(idOferta));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
}