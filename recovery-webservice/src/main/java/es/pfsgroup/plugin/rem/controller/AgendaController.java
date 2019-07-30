package es.pfsgroup.plugin.rem.controller;

import java.lang.reflect.InvocationTargetException;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.InvalidDataAccessResourceUsageException;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.recibo.model.DDMotivoRechazo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.controller.TareaController;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.TareaExcelReport;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaSoloRechazo;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.impl.UpdaterServiceSancionOfertaResolucionExpediente;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoAgendaMultifuncion;
import es.pfsgroup.plugin.rem.model.DtoReasignarTarea;
import es.pfsgroup.plugin.rem.model.DtoSaltoTarea;
import es.pfsgroup.plugin.rem.model.DtoSolicitarProrrogaTarea;
import es.pfsgroup.plugin.rem.model.DtoTareaFilter;
import es.pfsgroup.plugin.rem.model.DtoTareaGestorSustitutoFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.rest.dto.WSDevolBankiaDto;
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;

@Controller
public class AgendaController extends TareaController {

	@Autowired
	private AgendaAdapter adapter;

	
	@Resource
	Properties appProperties;

    @Autowired
    private ActivoTareaExternaApi activoTareaExternaManagerApi;
	
	@Autowired
	ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private UvemManagerApi uvemManagerApi;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private NotificatorServiceSancionOfertaSoloRechazo notificatorSoloRechazo;

    @Autowired
    private ActivoAdapter activoAdapter;
	
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
		
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String RESPONSE_SUCCESS_KEY = "success";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListTareas(DtoTareaFilter dtoTareaFiltro, ModelMap model, Boolean btnGesSustituto) {
		Page p = adapter.getListTareas(dtoTareaFiltro);
		model.put("data", p.getResults());
		// avisos
		if (dtoTareaFiltro.getCodigoTipoTarea() != null && dtoTareaFiltro.getCodigoTipoTarea().equals("3")) {
			model.put("totalCount", adapter.avisosPendientes());
		} else if (dtoTareaFiltro.getCodigoTipoTarea() != null && dtoTareaFiltro.getCodigoTipoTarea().equals("1")
				&& dtoTareaFiltro.getEsAlerta() != null && dtoTareaFiltro.getEsAlerta()) {
			// alerta
			model.put("totalCount", adapter.alertasPendientes());
		} else {
			// tarea
			model.put("totalCount", adapter.tareasPendientes());
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getFormularioTarea(Long idTarea, ModelMap model) {
		try{
			model.put("data", adapter.getFormularioTarea(idTarea));
		}catch(Exception e){
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error(e.getMessage(),e);
		}
		
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getValidacionPrevia(Long idTarea, ModelMap model) {
		try{
			model.put("data", adapter.getValidacionPrevia(idTarea));
		}catch(Exception e){
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error(e.getMessage(),e);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIdActivoTarea(Long idTarea, ModelMap model) {
		model.put("idActivoTarea", adapter.getIdActivoTarea(idTarea));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIdTrabajoTarea(Long idTarea, ModelMap model) {
		model.put("idTrabajoTarea", adapter.getIdTrabajoTarea(idTarea));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getNumIdExpediente(Long idTarea, ModelMap model) {
		model.put("idExpediente", adapter.getIdExpediente(idTarea));
		model.put("numExpediente", adapter.getNumExpediente(idTarea));
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getTipoTituloActivoByIdTarea(Long idTarea, ModelMap model) {
		model.put("tipoTituloActivo", adapter.getTipoTituloActivoByIdTarea(idTarea));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getCodigoTramiteTarea(Long idTarea, ModelMap model) {
		model.put("codigoTramite", adapter.getCodigoTramiteTarea(idTarea));
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView detalleTarea(Long idTarea, String subtipoTarea) throws IllegalAccessException, InvocationTargetException {
		
		DtoAgendaMultifuncion objetoNotificacionAct = (DtoAgendaMultifuncion) adapter.abreTarea(idTarea, subtipoTarea);

		return createModelAndViewJson(new ModelMap("data",objetoNotificacionAct ));

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView save(WebRequest request, ModelMap model) {

		boolean success = false;
		try {
			success = adapter.save(request.getParameterMap());

		} catch (InvalidDataAccessResourceUsageException e) {
			// Mensajes concretos para este tipo de excepcion
			model.put("errorValidacionGuardado", getMensajeInvalidDataAccessExcepcion(e));

		} catch (Exception e) {
			e.printStackTrace();
			model.put("errorValidacionGuardado", e.getMessage());
		}

		model.put("success", success);

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView tareasPendientes(WebRequest request, ModelMap model) {
		boolean success = true;
		model.put("contador", adapter.tareasPendientes());
		model.put("success", success);
		return createModelAndViewJson(model);
	}

	// @RequestMapping(method = RequestMethod.GET)
	// public ModelAndView notificacionesPendientes(WebRequest request, ModelMap
	// model){
	// boolean success = true;
	// model.put("contador", adapter.notificacionesPendientes());
	// model.put("success",success);
	// return createModelAndViewJson(model);
	// }

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView alertasPendientes(WebRequest request, ModelMap model) {
		boolean success = true;
		model.put("contador", adapter.alertasPendientes());
		model.put("success", success);
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView avisosPendientes(WebRequest request, ModelMap model) {
		boolean success = true;
		model.put("contador", adapter.avisosPendientes());
		model.put("success", success);
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboNombreTarea(Long idTipoTramite, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getComboNombreTarea(idTipoTramite));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAdvertenciaTarea(@RequestParam Long idTarea, ModelMap model) {

		// TODO: Aquí se generan los distintos textos de avisos para la tarea
		String advertencia = adapter.getAdvertenciaTarea(idTarea);
		String codigoTramite = adapter.getCodigoTramiteTarea(idTarea);
		String codigoTareaProcedimiento = adapter.getCodigoTareaProcedimiento(idTarea);

		model.put("codigoTramite", codigoTramite);
		model.put("codigoTareaProcedimiento", codigoTareaProcedimiento);
		model.put("advertenciaExisteTrabajo", advertencia);
		model.put("success", true);

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAdvertenciaTareaComercial(@RequestParam Long idTarea, ModelMap model) {

		// TODO: Aquí se generan los distintos textos de avisos para la tarea
		String advertencia = adapter.getAdvertenciaTareaComercial(idTarea);

		model.put("textoAdvertencia", advertencia);
		model.put("success", true);

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoTareaFilter dtoTareaFilter, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		dtoTareaFilter.setStart(excelReportGeneratorApi.getStart());
		dtoTareaFilter.setLimit(excelReportGeneratorApi.getLimit());

		@SuppressWarnings("unchecked")
		List<DtoResultadoBusquedaTareasBuzones> listaTareas = (List<DtoResultadoBusquedaTareasBuzones>) adapter
				.getListTareas(dtoTareaFilter).getResults();

		ExcelReport report = new TareaExcelReport(listaTareas);

		excelReportGeneratorApi.generateAndSend(report, response);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTiposProcedimientoAgenda(ModelMap model) {
		model.put("data", adapter.getTiposProcedimientoAgenda());

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView generarAutoprorroga(DtoSolicitarProrrogaTarea dtoSolicitarProrroga, ModelMap model) {
		model.put("success", adapter.generarAutoprorroga(dtoSolicitarProrroga));
		// model.put("success", true);

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saltoCierreEconomico(Long idTareaExterna, ModelMap model) {
		model.put("success", adapter.saltoCierreEconomico(idTareaExterna));

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saltoResolucionExpediente(Long idTareaExterna, ModelMap model) {
		model.put("success", adapter.saltoResolucionExpediente(idTareaExterna));

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saltoResolucionExpedienteByIdExp(Long idExpediente, ModelMap model) {

		ExpedienteComercial eco = null;
		Oferta oferta;
		List<ActivoTramite> listaTramites = null;
		Boolean salto = false;
		final String CODIGO_T013 = "T013";
		final String CODIGO_T017 = "T017";

		try {

			if (Checks.esNulo(idExpediente)) {
				throw new JsonViewerException("No se ha informado el expediente comercial.");

			} else {
				eco = expedienteComercialApi.findOne(idExpediente);
				if (Checks.esNulo(eco)) {
					throw new JsonViewerException("No existe el expediente comercial.");
				}
				
				listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
				if (Checks.esNulo(listaTramites)
						|| (!Checks.esNulo(listaTramites) && listaTramites.size() == 0 || (!Checks.esNulo(listaTramites)
								&& listaTramites.size() > 0 && Checks.esNulo(listaTramites.get(0))))) {
					throw new JsonViewerException("No se ha podido recuperar el trámite del expediente comercial.");
				}

				List<TareaExterna> listaTareas = activoTramiteApi
						.getListaTareaExternaActivasByIdTramite(listaTramites.get(0).getId());
				
				ActivoTramite tramite = listaTramites.get(0);
				for (int i = 0; i < listaTareas.size(); i++) {
					TareaExterna tarea = listaTareas.get(i);
					if (!Checks.esNulo(tarea)) {
						String codigo = tarea.getTareaProcedimiento().getTipoProcedimiento().getCodigo();
						if(CODIGO_T013.equals(codigo)) {
							salto = adapter.saltoResolucionExpediente(tarea.getId());

						}else if(CODIGO_T017.equals(codigo)) {
							if(DDEstadosExpedienteComercial.RESERVADO.equals(eco.getEstado().getCodigo())) {
								salto = adapter.saltoResolucionExpedienteApple(tarea.getId());
							}else {
								for (TareaExterna tareasFin : listaTareas) {
									salto = adapter.saltoFin(tareasFin.getId());
								} 
								expedienteComercialApi.updateEstadoExpedienteComercial(eco, DDEstadosExpedienteComercial.ANULADO);
								oferta = eco.getOferta();
								ofertaApi.rechazarOferta(oferta);
								ofertaApi.descongelarOfertas(eco);
								DDMotivoRechazoOferta motivoRechazo = genericDao.get(DDMotivoRechazoOferta.class, 
										genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoRechazoOferta.CODIGO_OTROS));
								oferta.setMotivoRechazo(motivoRechazo);
								eco.setFechaVenta(null);
								//Actualizar el estado comercial de los activos de la oferta
								ofertaApi.updateStateDispComercialActivosByOferta(oferta);
								//Actualizar el estado de la publicación de los activos de la oferta (desocultar activos)
								ofertaApi.desocultarActivoOferta(oferta);
								
								ofertaApi.darDebajaAgrSiOfertaEsLoteCrm(oferta);
								notificatorSoloRechazo.notificatorFinTareaConValores(tramite, null);
								Activo activo = tramite.getActivo();
								if(!Checks.esNulo(activo)) {
									activoApi.actualizarOfertasTrabajosVivos(activo);
									activoAdapter.actualizarEstadoPublicacionActivo(tramite.getActivo().getId(), true);
								}
							}
						}
						expedienteComercialApi.finalizarTareaValidacionClientes(eco);
						if(!salto) {
							salto = adapter.saltoResolucionExpediente(tarea.getId());
						}
						break;
					}
				}								
			}
			model.put("success", salto);

		} catch (JsonViewerException e) {
			
			model.put("success", salto);
			model.put("msgError", e.getMessage());

		} catch (Exception e) {
			logger.error("Error al saltar a resolución expediente", e);
			model.put("success", salto);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView anulacionDevolucionReservaByIdExp(Long idExpediente, ModelMap model) {

		ExpedienteComercial eco = null;
		List<ActivoTramite> listaTramites = null;
		Boolean salto = false;
		WSDevolBankiaDto dto = null;
		try {

			if (Checks.esNulo(idExpediente)) {
				throw new JsonViewerException("No se ha informado el expediente comercial.");

			} else {
				eco = expedienteComercialApi.findOne(idExpediente);
				if (Checks.esNulo(eco)) {
					throw new JsonViewerException("No existe el expediente comercial.");
				}

				listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
				if (Checks.esNulo(listaTramites)
						|| (!Checks.esNulo(listaTramites) && listaTramites.isEmpty() || (!Checks.esNulo(listaTramites)
								&& !listaTramites.isEmpty() && Checks.esNulo(listaTramites.get(0))))) {
					throw new JsonViewerException("No se ha podido recuperar el trámite del expediente comercial.");
				}
				List<TareaExterna> listaTareas = activoTramiteApi
						.getListaTareaExternaActivasByIdTramite(listaTramites.get(0).getId());
				if(listaTareas != null && listaTareas.size() > 0){
					for (TareaExterna tarea : listaTareas) {
						if (!Checks.esNulo(tarea) && ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION.equals(tarea.getTareaProcedimiento().getCodigo())) {
							//Salto a tarea anterior y llamada a UVEM cosem1: 4
							TareaExterna tareaSalto = activoTramiteApi.getTareaAnteriorByCodigoTarea(listaTramites.get(0).getId(), ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE);
							salto = adapter.saltoTareaByCodigo(tarea.getId(), tareaSalto.getTareaProcedimiento().getCodigo());
							if(salto){
								//Se entiende que cuando salta a la tarea anterior a Resolución Expendiente, la reserva y el expediente han llegado en los siguientes estados
								expedienteComercialApi.updateExpedienteComercialEstadoPrevioResolucionExpediente(eco, ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_DEVOLUCION, tareaSalto.getTareaProcedimiento().getCodigo(), true);
								dto = uvemManagerApi.notificarDevolucionReserva(eco.getOferta().getNumOferta().toString(), UvemManagerApi.MOTIVO_ANULACION.NO_APLICA,
										UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.NO_APLICA, UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.ANULACION_PROPUESTA_ANULACION_RESERVA_FIRMADA);
								beanUtilNotNull.copyProperties(eco, dto);
							}
							else{
								logger.error("Error al saltar a tarea anterior a Resolución Expediente");
								throw new Exception();
							}
							break;
						}
						else{
							throw new JsonViewerException("No se encuentra en la tarea para realizar esta acción");
						}
					}
				}
			}
			model.put("success", salto);

		} catch (JsonViewerException e) {
			model.put("success", salto);
			model.put("msgError", e.getMessage());

		} catch (Exception e) {
			logger.error("Error al saltar", e);
			model.put("success", salto);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	@Transactional(readOnly = false)
	public ModelAndView solicitarAnulacionDevolucionReservaByIdExp(Long idExpediente, ModelMap model) {

		ExpedienteComercial eco = null;
		List<ActivoTramite> listaTramites = null;
		Boolean salto = false;
		WSDevolBankiaDto dto = null;
		String valorComboMotivoAnularReserva = null;
		try {

			if (Checks.esNulo(idExpediente)) {
				throw new JsonViewerException("No se ha informado el expediente comercial.");

			} else {
				eco = expedienteComercialApi.findOne(idExpediente);
				if (Checks.esNulo(eco)) {
					throw new JsonViewerException("No existe el expediente comercial.");
				}

				listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
				if (Checks.esNulo(listaTramites)
						|| (!Checks.esNulo(listaTramites) && listaTramites.isEmpty() || (!Checks.esNulo(listaTramites)
								&& !listaTramites.isEmpty() && Checks.esNulo(listaTramites.get(0))))) { 
					throw new JsonViewerException("No se ha podido recuperar el trámite del expediente comercial.");
				}

				List<TareaExterna> listaTareas = activoTramiteApi
						.getListaTareaExternaActivasByIdTramite(listaTramites.get(0).getId());
				
				List<TareaExterna> listaTareas2 = activoTramiteApi
						.getListaTareaExternaByIdTramite(listaTramites.get(0).getId());
				if (listaTareas != null && listaTareas.size() > 0) {
					
					for (TareaExterna tarea : listaTareas2) {
						if (ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE.equals(tarea.getTareaProcedimiento().getCodigo())) {
							List<TareaExternaValor> valores = activoTareaExternaManagerApi.obtenerValoresTarea(tarea.getId());
							for(TareaExternaValor valor :  valores) {
								if(UpdaterServiceSancionOfertaResolucionExpediente.MOTIVO_ANULACION_RESERVA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
									valorComboMotivoAnularReserva= valor.getValor();
									break;
								}
							}
							if (!Checks.esNulo(valorComboMotivoAnularReserva)) break;
						}
					}
					for (TareaExterna tarea : listaTareas) {
						if (!Checks.esNulo(tarea) && ComercialUserAssigantionService.CODIGO_T013_PENDIENTE_DEVOLUCION
								.equals(tarea.getTareaProcedimiento().getCodigo())) {
							// Salto a la tarea Respuesta Bankia Anulacion
							// Devolucion y llamada UVEM cosem1: 6
							if(Checks.esNulo(eco.getDevolAutoNumber())) eco.setDevolAutoNumber(false);
							
							if (!eco.getDevolAutoNumber()) {
								salto = adapter.saltoTareaByCodigo(tarea.getId(), ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION);
								//llamar al ws
								dto = uvemManagerApi.notificarDevolucionReserva(eco.getOferta().getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionPorCodigoMotivoAnulacionReserva(valorComboMotivoAnularReserva),
								UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.DEVOLUCION_RESERVA, UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.SOLICITUD_ANULACION_PROPUESTA_ANULACION_RESERVA_FIRMADA);
								
								eco.setCorrecw(dto.getCorrecw());
								eco.setComoa3(dto.getComoa3());
								genericDao.save(ExpedienteComercial.class, eco);
								
							}else {
								dto = uvemManagerApi.notificarDevolucionReserva(eco.getOferta().getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionPorCodigoMotivoAnulacionReserva(valorComboMotivoAnularReserva),
										UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.DEVOLUCION_RESERVA, UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.ANULACION_PROPUESTA_ANULACION_RESERVA_FIRMADA);
								
								eco.setCorrecw(dto.getCorrecw());
								eco.setComoa3(dto.getComoa3());
								genericDao.save(ExpedienteComercial.class, eco);
								Long correcw = eco.getCorrecw();
								Long comoa3 = eco.getComoa3();
								
								if (correcw == 0 && comoa3 == 0) {
									throw new JsonViewerException("No se puede anular la devoluci&oacute;n.");
								}else {
									TareaExterna tareaSalto = activoTramiteApi.getTareaAnteriorByCodigoTarea(listaTramites.get(0).getId(), ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE);
									salto = adapter.saltoTareaByCodigo(tarea.getId(), tareaSalto.getTareaProcedimiento().getCodigo());
								}
							}
							
							break;
						} else {
							throw new JsonViewerException("No se encuentra en la tarea para realizar esta acción");
						}
					}
				}
			}
			model.put("success", salto);

		} catch (JsonViewerException e) {
			model.put("success", salto);
			model.put("msgError", e.getMessage());

		} catch (Exception e) {
			logger.error("Error al saltar", e);
			model.put("success", salto);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView anularSolicitudAnulacionDevolucionReservaByIdExp(Long idExpediente, ModelMap model) {

		ExpedienteComercial eco = null;
		List<ActivoTramite> listaTramites = null;
		Boolean salto = false;

		try {

			if (Checks.esNulo(idExpediente)) {
				throw new JsonViewerException("No se ha informado el expediente comercial.");

			} else {
				eco = expedienteComercialApi.findOne(idExpediente);
				if (Checks.esNulo(eco)) {
					throw new JsonViewerException("No existe el expediente comercial.");
				}

				listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
				if (Checks.esNulo(listaTramites)
						|| (!Checks.esNulo(listaTramites) && listaTramites.isEmpty() || (!Checks.esNulo(listaTramites)
								&& !listaTramites.isEmpty() && Checks.esNulo(listaTramites.get(0))))) {
					throw new JsonViewerException("No se ha podido recuperar el trámite del expediente comercial.");
				}

				List<TareaExterna> listaTareas = activoTramiteApi
						.getListaTareaExternaActivasByIdTramite(listaTramites.get(0).getId());
				if (listaTareas != null && listaTareas.size() > 0) {
					for (TareaExterna tarea : listaTareas) {
						if (!Checks.esNulo(tarea)
								&& ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION
										.equals(tarea.getTareaProcedimiento().getCodigo())) {
							// Salto a la tarea Pendiente Devolucion y llamada
							// UVEM cosem1: 7
							salto = adapter.saltoPendienteDevolucion(tarea.getId());
							if (salto) {
								WSDevolBankiaDto dto = uvemManagerApi.notificarDevolucionReserva(eco.getOferta().getNumOferta().toString(),
										UvemManagerApi.MOTIVO_ANULACION.NO_APLICA,
										UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.NO_APLICA,
										UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.ANULAR_SOLICITUD_ANULACION_PROPUESTA_ANULACION_RESERVA_FIRMADA);
								
								beanUtilNotNull.copyProperties(eco, dto);
							} else {
								logger.error("Error al saltar a tarea anterior a Resolución Expediente");
								throw new Exception();
							}
							break;
						} else {
							throw new JsonViewerException("No se encuentra en la tarea para realizar esta acción");
						}
					}
				}
			}
			model.put("success", salto);

		} catch (JsonViewerException e) {
			model.put("success", salto);
			model.put("msgError", e.getMessage());

		} catch (Exception e) {
			logger.error("Error al saltar", e);
			model.put("success", salto);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView anularTramite(Long idTramite, ModelMap model) {
		Boolean anulado = false;
		try {
			if (Checks.esNulo(idTramite)) {
				throw new JsonViewerException("No se ha informado el expediente comercial.");
			} else {
				anulado = adapter.anularTramite(idTramite);
			}
			model.put("success", anulado);
			
		} catch (JsonViewerException jve) {
			model.put("success", anulado);
			model.put("msgError", jve.getMessage());
		} catch (Exception e) {
			logger.error("Error al anular el trámite", e);
			model.put("success", anulado);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView anularTramiteAlquiler(Long idTramite, String motivo, ModelMap model) {
		Boolean anulado = false;
		try {
			if (Checks.esNulo(idTramite)) {
				throw new JsonViewerException("No se ha informado el expediente comercial.");
			} else {
				anulado = adapter.anularTramiteAlquiler(idTramite, motivo);
			}
			ActivoTramite tramite = activoTramiteApi.get(idTramite);
			activoApi.actualizarOfertasTrabajosVivos(tramite.getActivo());
			model.put("success", anulado);
			
		} catch (JsonViewerException jve) {
			model.put("success", anulado);
			model.put("msgError", jve.getMessage());
		} catch (Exception e) {
			logger.error("Error al anular el trámite", e);
			model.put("success", anulado);
		}	
		
		return createModelAndViewJson(model);
	}

	private String getMensajeInvalidDataAccessExcepcion(InvalidDataAccessResourceUsageException e) {

		// En este tipo de excepción se pueden esconder errores del procedure de
		// BBDD de publicacion ACTIVO_PUBLICACION_AUTO
		// Hay que mostrar un mensaje de error concreto para uno de los errores
		// (no cumplir condiciones para publicar)
		Throwable causa = e.getCause();
		String mensajeError = null;
		int contador = 0;
		while (!Checks.esNulo(causa) && Checks.esNulo(mensajeError) && contador < 100) {
			if (causa.getMessage().contains("ACTIVO_PUBLICACION_AUTO") && causa.getMessage().contains("ORA-06510")) {
				mensajeError = "El activo no cumple todas las condiciones para ser publicado. Revise OK de precios o las reglas de publicación.";
			}
			causa = causa.getCause();
			contador++;
		}

		// Para el resto de errores, se muestra un mensaje generico
		if (Checks.esNulo(mensajeError))
			mensajeError = "Se ha producido un error con la base de datos al avanzar la tarea. Inténtelo más tarde.";

		return mensajeError;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView reasignarTarea(DtoReasignarTarea dtoReasignarTarea, ModelMap model) {
		model.put("success", adapter.reasignarTarea(dtoReasignarTarea));
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView lanzarTareaAdministrativa(DtoSaltoTarea dto, ModelMap model) {

		boolean success = false;
		try {
			
			success = adapter.lanzarTareaAdministrativa(dto);

		} catch (Exception e) {
			logger.error("Error lanzarTareaAdministrativa: ", e);
			model.put("errorValidacionGuardado", e.getMessage());
		}

		model.put("success", success);

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListTareasGestorSustituto(ModelMap model, DtoTareaGestorSustitutoFilter dto) {
		
		try{
			
			Page page = adapter.getListTareasGS(dto);
			
			model.put("succes", true);
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			
		}catch (Exception e){
			logger.error("Error obteniendo tareas gestor sustituto", e);
			model.put("succes", false);
		}
		return createModelAndViewJson(model);
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIdActivoByNumActivo(Long idNumAct, ModelMap model) {
		model.put("idActivoTarea", adapter.getIdActivoByNumActivo(idNumAct));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIdAgrByNumAgr(Long idNumAgr, ModelMap model) {
		model.put("idAgrTarea", adapter.getIdAgrByNumAgr(idNumAgr));
		return createModelAndViewJson(model);
	}
}
