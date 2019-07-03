package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.PathParam;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
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
import es.pfsgroup.plugin.rem.excel.OfertasExcelReport;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.DtoHonorariosOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertantesOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaVivaRespuestaDto;
import es.pfsgroup.plugin.rem.rest.dto.TareaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.tareasactivo.dao.ActivoTareaExternaDao;
import net.sf.json.JSONObject;

@Controller
public class OfertasController {

	@Autowired
	private OfertaApi ofertaApi;
	
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
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ProveedoresDao proveedoresDao;
	
	@Autowired
	private AgendaAdapter agendaAdapter;
	
	private final static String CLIENTE_HAYA = "HAYA";
	public static final String ERROR_NO_EXISTE_OFERTA_O_TAREA = "El número de oferta es inválido o no existe la tarea.";

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertas(DtoOfertasFilter dtoOfertasFilter, ModelMap model) {
		try {
			dtoOfertasFilter.setSort("voferta.fechaCreacion");
			dtoOfertasFilter.setDir("DESC");
			
			DtoPage page = ofertaApi.getListOfertasUsuario(dtoOfertasFilter);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ofertasController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoOfertasFilter dtoOfertasFilter, HttpServletRequest request, HttpServletResponse response) throws IOException {
		dtoOfertasFilter.setStart(excelReportGeneratorApi.getStart());
		dtoOfertasFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		String dtoCarteraCodigo = dtoOfertasFilter.getCarteraCodigo();
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		List<VOfertasActivosAgrupacion> listaOfertas = (List<VOfertasActivosAgrupacion>) ofertaApi.getListOfertasUsuario(dtoOfertasFilter).getResults();
		HashMap<Long,String> fechasReunionComite = new HashMap<Long, String>();
		HashMap<Long,String> sancionadores = new HashMap<Long, String>();
		
		if((!Checks.esNulo(usuarioCartera) && (DDCartera.CODIGO_CARTERA_LIBERBANK).equals(usuarioCartera.getCartera().getCodigo()))
				|| (!Checks.esNulo(dtoCarteraCodigo) && (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(dtoCarteraCodigo)))){
			for(VOfertasActivosAgrupacion oferta : listaOfertas){
				List<Long> TareasExternasId = activoTareaExternaDao.getTareasExternasIdByOfertaId(oferta.getId());
				Filter filterTap01 = genericDao.createFilter(FilterType.EQUALS, "codigo", "T013_ResolucionComite");
				Long idResolucionComite = genericDao.get(TareaProcedimiento.class, filterTap01).getId();
				Filter filterTap02 = genericDao.createFilter(FilterType.EQUALS, "codigo", "T015_ResolucionExpediente");
				Long idResolucionExpediente = genericDao.get(TareaProcedimiento.class, filterTap02).getId();
				
				//01->Venta, 02->Alquiler
				if(("01").equals(oferta.getCodigoTipoOferta())){
					for(Long tareaExternaId : TareasExternasId){
						TareaExterna tareaExterna = activoTareaExternaApi.get(tareaExternaId);
						if((idResolucionComite).equals(tareaExterna.getTareaProcedimiento().getId())){
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
				}else if(("02").equals(oferta.getCodigoTipoOferta())){
					for(Long tareaExternaId : TareasExternasId){
						TareaExterna tareaExterna = activoTareaExternaApi.get(tareaExternaId);
						if((idResolucionExpediente).equals(tareaExterna.getTareaProcedimiento().getId())){
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
		
		ExcelReport report = new OfertasExcelReport(listaOfertas, dtoCarteraCodigo, usuarioCartera, fechasReunionComite, sancionadores);

		excelReportGeneratorApi.generateAndSend(report, response);
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
	 * "documento":"48594628F"}]}]}
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
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", "null");
		} catch (Exception e) {
			logger.error("Error ofertas", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
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

		try {
			ofertaApi.llamadaMaestroPersonas(dniComprador, OfertaApi.CLIENTE_HAYA);
			//model.put("data", ofertaApi.checkPedirDoc(idActivo,idAgrupacion,idExpediente, dniComprador, codtipoDoc));
			model.put("data", false);
			model.put("comprador",ofertaApi.getClienteGDPRByTipoDoc(dniComprador, codtipoDoc));
			model.put("compradorId", expedienteComercialApi.getCompradorIdByDocumento(dniComprador, codtipoDoc));
			model.put("destinoComercial", ofertaApi.getDestinoComercialActivo(idActivo, idAgrupacion, idExpediente));
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
	public void getOfertasVivasActGestoria(@PathParam("idLlamada") Long idLlamada, @PathParam("numActivo") Long numActivo, @PathParam("codGestoria") String codGestoria, ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
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
		
		if(Checks.esNulo(idLlamada) || Checks.esNulo(numActivo) || Checks.esNulo(codGestoria)) {
			flagParametrosANulo = true;
		}else if(Checks.esNulo(activoDao.getActivoByNumActivo(numActivo))){
			flagnumActivoNoExiste = true;
		}else if(Checks.esNulo(genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", codGestoria)))){
			flagcodGestoriaNoExiste = true;
		}else{
		
			usuarioGestoria  = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", codGestoria));
			filtro.setGestoria(usuarioGestoria.getId());
	
			
	
			filtro.setNumActivo(numActivo);
			filtro.setLimit(100);
			
			
			//Gestoria, comprobar que exista en la BD
			//Oferta relacionada que devuelva algo ofertasVivasActGestoria
			
			
			DtoPage page = ofertaApi.getListOfertasGestoria(filtro);
			
			VOfertasActivosAgrupacion voaa;
			
			
			
			Oferta oferta;
			OfertaVivaRespuestaDto ofr;
			if(!Checks.esNulo(page) && !Checks.esNulo(page.getResults())) {
				for (Object obj : page.getResults()) {
					
						voaa = (VOfertasActivosAgrupacion) obj;
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
		//El idLlamada, tanto en el try como en el catch, lo debe devolver siempre

		try {
			if(flagParametrosANulo) {
				error = RestApi.REST_NO_PARAM;
				if(Checks.esNulo(idLlamada)) {
					error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
					errorDesc = "Falta el campo idLlamada";
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

			model.put("id", 0);
			model.put("idLlamada", idLlamada);
			model.put("data", ofertasList);
			model.put("error", "null");
			model.put("success", true);
			
		}catch(Exception e) {
			logger.error("Error en OfertasController, metodo getOfertasVivasActGestoria", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("idLlamada", idLlamada);
			model.put("error", error);
			model.put("errorDesc", errorDesc );
			model.put("success", false);
		}
		
		restApi.sendResponse(response, model, request);
	  }	
	  catch(Exception e) {
		  logger.error("Error en OfertasController, metodo getOfertasVivasActGestoria", e);
		  request.getPeticionRest().setErrorDesc(e.getMessage());
		  model.put("idLlamada", idLlamada);
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
		Long idLlamada = null;
		String error = null;
		String errorDesc = null;
		
		try {

			jsonFields = request.getJsonObject();
			jsonData = (TareaRequestDto) request.getRequestData(TareaRequestDto.class);
			
			if(Checks.esNulo(jsonFields)) {
				error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
				errorDesc = "Faltan campos";
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
			}else if (jsonFields.isNullObject()) {
				error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
				errorDesc = "Faltan campos";
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else if(jsonFields.isEmpty()) {
				error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
				errorDesc = "Faltan campos";
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
			}else if(Checks.esNulo(jsonData)) {
				error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
				errorDesc = "Faltan campos";
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
			} else if(Checks.esNulo(jsonData.getIdLlamada()) || Checks.esNulo(jsonData.getData())){
				error = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
				errorDesc = "Faltan campos";
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
			}else {
				
				
				idLlamada = jsonData.getIdLlamada();
				datosTarea = jsonData.getData();
				
				
				if(Checks.esNulo(jsonFields.get("idLlamada"))){
					error = RestApi.REST_NO_PARAM;
					errorDesc = "Falta el id de llamada.";
					throw new Exception(RestApi.REST_NO_PARAM);					
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
					tareaId = ofertaApi.getIdTareaByNumOfertaAndCodTarea(Long.parseLong(ofrNumOferta.toString()), codTarea);
					
					if(Checks.esNulo(tareaId)) {
						error = RestApi.REST_MSG_VALIDACION_TAREA;
						errorDesc = "La tarea " + codTarea + " no existe.";
						throw new Exception(RestApi.REST_MSG_VALIDACION_TAREA);
					}
					else {
						idTarea[0] = tareaId.toString();
						
						error = RestApi.REST_MSG_VALIDACION_TAREA;
						errorDesc = "La tarea " + codTarea + " no existe.";
						
						datosTarea.put("idTarea",idTarea);
						resultado = agendaAdapter.validationAndSave(datosTarea);
						
						if(resultado) {
							model.put("idLlamada", idLlamada);
							model.put("ofrNumOferta", ofrNumOferta);
							model.put("codTarea", codTarea);
							model.put("data", resultado);
							model.put("success", true);
						}
						
					}
				}
			}

			//El idLlamada, tanto en el try como en el catch, lo debe devolver siempre
		} catch (Exception e) {
			logger.error("Error avance tarea ", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("idLlamada", idLlamada);
			model.put("error",error);
			model.put("descError", errorDesc);
			model.put("success", false);
		}

		restApi.sendResponse(response, model, request);
	}

}