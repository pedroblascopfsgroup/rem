package es.pfsgroup.plugin.rem.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.databind.JsonMappingException;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.listener.ActivoGenerarSaltoImpl;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSaltoTarea;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDDevolucionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.service.UpdaterTransitionService;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateOfertaApi;
import net.sf.json.JSONObject;

@Controller
public class ResolucionComiteController {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ResolucionComiteApi resolucionComiteApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private RestApi restApi;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;
	
	@Autowired
	private UpdaterStateOfertaApi updaterStateOfertaApi;
	
	@Autowired 
    private UpdaterTransitionService updaterTransitionService;

	public static final String ACCION_ANULACION_RESOLUCION = "2";
	public static final String ACCION_RESOLUCION_DEVOLUCION = "3";
	public static final String ACCION_PROPUESTA_ANULACION_RESERVA_FIRMADA = "4";
	
	public static final String CODIGO_DEVOLUCION_DENEGADA = "N";
	public static final String CODIGO_DEVOLUCION_APROVADA = "S";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/resolucioncomite")
	public void resolucionComite(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {

		ResolucionComiteRequestDto jsonData = null;
		ResolucionComiteDto resolucionComiteDto = null;
		ResolucionComiteBankia resol = null;
		Notificacion notifrem = null;
		JSONObject jsonFields = null;
		HashMap<String, String> errorsList = null;
		ActivoTramite tramite = null;
		String mensajeDevolucion = "";

		try {

			jsonFields = request.getJsonObject();
			jsonData = (ResolucionComiteRequestDto) request.getRequestData(ResolucionComiteRequestDto.class);
			resolucionComiteDto = jsonData.getData();

			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {

				errorsList = resolucionComiteApi.validateResolucionPostRequestData(resolucionComiteDto, jsonFields);

				if (!Checks.esNulo(errorsList) && errorsList.size() == 0) {
					Oferta ofr = ofertaApi.getOfertaByNumOfertaRem(resolucionComiteDto.getOfertaHRE());
					
					if(!ResolucionComiteController.ACCION_RESOLUCION_DEVOLUCION.equals(resolucionComiteDto.getCodigoAccion())){						
						if (Checks.esNulo(ofr) || (!Checks.esNulo(ofr)
								&& !ofr.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_ACEPTADA))) {
							throw new Exception("No existe la oferta o no esta aceptada.");
						}
					}
					
					ExpedienteComercial eco = expedienteComercialApi.expedienteComercialPorOferta(ofr.getId());
					if (Checks.esNulo(eco)) {
						throw new Exception("No existe el expediente comercial de la oferta.");
					}

					List<ActivoTramite> listaTramites = activoTramiteApi
							.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
					if (Checks.esNulo(listaTramites) || listaTramites.size() == 0) {
						throw new Exception("No se ha podido recuperar el trámite de la oferta.");
					} else {
						tramite = listaTramites.get(0);
						if (Checks.esNulo(tramite)) {
							throw new Exception("No se ha podido recuperar el trámite de la oferta.");
						}
					}

					resolucionComiteDto.setCodigoTipoResolucion(DDTipoResolucion.CODIGO_TIPO_RESOLUCION);
					

					if(ResolucionComiteController.ACCION_PROPUESTA_ANULACION_RESERVA_FIRMADA.equals(resolucionComiteDto.getCodigoAccion())){
						if(DDEstadoResolucion.CODIGO_ERE_APROBADA.equals(resolucionComiteDto.getCodigoResolucion())){
							// SALTO A TAREA ANTERIOR de RESOLUCION EXPEDIENTE
							TareaExterna tareaAnterior = activoTramiteApi.getTareaAnteriorByCodigoTarea(tramite.getId(), ComercialUserAssigantionService.CODIGO_T013_RESOLUCION_EXPEDIENTE);
							
							List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
							for (TareaExterna tarea : listaTareas) {
								if (!Checks.esNulo(tarea)) {
									tareaActivoApi.guardarDatosResolucion(tarea.getId(), resolucionComiteDto.getFechaAnulacion(), resolucionComiteDto.getCodigoResolucion());
									tareaActivoApi.saltoDesdeTareaExterna(tarea.getId(), tareaAnterior.getTareaProcedimiento().getCodigo());
									expedienteComercialApi.updateExpedienteComercialEstadoPrevioResolucionExpediente(eco, ComercialUserAssigantionService.CODIGO_T013_RESPUESTA_BANKIA_ANULACION_DEVOLUCION, tareaAnterior.getTareaProcedimiento().getCodigo(), false);
									break;
								}
							}
						}
						else if(DDEstadoResolucion.CODIGO_ERE_DENEGADA.equals(resolucionComiteDto.getCodigoResolucion())){
							List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
							for (TareaExterna tarea : listaTareas) {
								if (!Checks.esNulo(tarea)) {
									tareaActivoApi.guardarDatosResolucion(tarea.getId(), resolucionComiteDto.getFechaComite(), resolucionComiteDto.getCodigoResolucion());
									tareaActivoApi.saltoPendienteDevolucion(tarea.getId());
									break;
								}
							}
						}
						else{
							errorsList.put("ofertaHRE", "Resolución no soportada");
						}
					}
					else if(ResolucionComiteController.ACCION_RESOLUCION_DEVOLUCION.equals(resolucionComiteDto.getCodigoAccion())){
						//Respuesta de Bankia para avanzar la tarea Respuesta Bankia
						if (CODIGO_DEVOLUCION_APROVADA.equals(resolucionComiteDto.getDevolucion())){
							List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
							for (TareaExterna tarea : listaTareas) {
								if (!Checks.esNulo(tarea)) {
									tareaActivoApi.guardarDatosResolucion(tarea.getId(), resolucionComiteDto.getFechaComite(), DDEstadoResolucion.CODIGO_ERE_APROBADA);
									updaterStateOfertaApi.updaterStateDevolucionReserva(DDDevolucionReserva.CODIGO_SI_SIMPLES, tramite, ofr, eco);
									tareaActivoApi.saltoPendienteDevolucion(tarea.getId());
									break;
								}
							}
						}
						else if (CODIGO_DEVOLUCION_DENEGADA.equals(resolucionComiteDto.getDevolucion())){
							List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
							for (TareaExterna tarea : listaTareas) {
								if (!Checks.esNulo(tarea)) {
									tareaActivoApi.guardarDatosResolucion(tarea.getId(), resolucionComiteDto.getFechaComite(), DDEstadoResolucion.CODIGO_ERE_DENEGADA);
									updaterStateOfertaApi.updaterStateDevolucionReserva(DDDevolucionReserva.CODIGO_NO, tramite, ofr, eco);
									tareaActivoApi.saltoFin(tarea.getId());
									break;
								}
							}
						}
						else{
							errorsList.put("ofertaHRE", "Resolución no soportada");
						}
					}
					else if (ResolucionComiteController.ACCION_ANULACION_RESOLUCION.equals(resolucionComiteDto.getCodigoAccion())
							|| !Checks.esNulo(resolucionComiteDto.getFechaAnulacion())) {
						Usuario gestor = null;
						Usuario supervisor = null;
						
						for (TareaActivo tareaActivo : tramite.getTareas()) {				
							if ("T013_DefinicionOferta".equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
								gestor = tareaActivo.getUsuario();
							}
							if("T013_ResolucionComite".equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
								supervisor = tareaActivo.getSupervisorActivo();
							}
						}
						//notificamos al gestor que ha de anular el expediente
						ResolucionComiteBankiaDto resolDto = null;
						resolDto = resolucionComiteApi.getResolucionComiteBankiaDtoFromResolucionComiteDto(resolucionComiteDto);
						List<ResolucionComiteBankia> listaResol = resolucionComiteApi.getResolucionesComiteByExpedienteTipoRes(resolDto);
						if(listaResol != null && listaResol.size() > 0){
							resol = listaResol.get(0);
							// Envío correo/notificación anulación
							try {
								if(gestor != null){
									notifrem = resolucionComiteApi.notificarAnulacionResolucion(resol, gestor, eco);
								}else if(supervisor != null){
									notifrem = resolucionComiteApi.notificarAnulacionResolucion(resol, supervisor, eco);
								}else{
									errorsList.put("ofertaHRE", "No se ha podido notificar la anulación de la resolución");
								}
							} catch (Exception e) {
								logger.error("No se ha podido notificar la anulación de la resolución", e);
								errorsList.put("ofertaHRE", "No se ha podido notificar la anulación de la resolución");
							}
						}
					}
					else {
						//guardamos la notficacion
						Usuario usu  = gestorActivoApi.userFromTarea("T013_ResolucionComite", tramite.getId());
						if (usu == null) {
							usu = gestorActivoApi.userFromTarea("T013_RatificacionComite", tramite.getId());
							if (usu == null) {
								usu = gestorActivoApi.userFromTarea("T013_RespuestaOfertante", tramite.getId());
							}
						}
						
						resol = resolucionComiteApi.saveOrUpdateResolucionComite(resolucionComiteDto);
						
						//si es venta cartera
						if(eco.getOferta().getVentaDirecta() != null && eco.getOferta().getVentaDirecta()){
							List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
							for (TareaExterna tarea : listaTareas) {
								if (!Checks.esNulo(tarea)) {
									DtoSaltoTarea salto = new DtoSaltoTarea();
									salto.setIdTramite(tramite.getId());
									salto.setPbcAprobado(1);
									salto.setFechaRespuestaComite(resol.getFechaResolucion());
									updaterTransitionService.updateT013_CierreEconomico(salto);									
									
									tareaActivoApi.saltoDesdeTareaExterna(tarea.getId(),ActivoGenerarSaltoImpl.CODIGO_SALTO_CIERRE);
									
									break;
								}
							}
						}

						if (!Checks.esNulo(resolucionComiteDto.getDevolucion())
								&& resolucionComiteDto.getDevolucion().equals("S")) {
							expedienteComercialApi.updateEstadoDevolucionReserva(eco,
									DDEstadoDevolucion.ESTADO_DEVUELTA);
							expedienteComercialApi.updateEstadosResolucionDevolucion(eco, resolucionComiteDto);
							usu = gestorActivoApi.getGestorComercialActual(ofr.getActivoPrincipal(), "GCOM");
							mensajeDevolucion = "El comité sancionador de CaixaBank ha resuelto la resolución "
									+ resol.getEstadoResolucion().getDescripcion()
									+ " devuelta con el importe de la reserva del expediente " + eco.getNumExpediente()
									+ ".\n";
						} else if (!Checks.esNulo(resolucionComiteDto.getDevolucion())
								&& resolucionComiteDto.getDevolucion().equals("N")) {
							expedienteComercialApi.updateEstadoDevolucionReserva(eco,
									DDEstadoDevolucion.ESTADO_NO_PROCEDE);
							expedienteComercialApi.updateEstadosResolucionNoDevolucion(eco, resolucionComiteDto);
							usu = gestorActivoApi.getGestorComercialActual(ofr.getActivoPrincipal(), "GCOM");
							mensajeDevolucion = "El comité sancionador de Caixabank ha resuelto la resolución "
									+ resol.getEstadoResolucion().getDescripcion()
									+ " retenida con el importe de la reserva del expediente " + eco.getNumExpediente()
									+ ".\n";

						}
						
						
						// Envío correo/notificación
						try {
							notifrem = resolucionComiteApi.notificarResolucion(resol, usu, eco, mensajeDevolucion,
									resolucionComiteDto.getDevolucion());
						} catch (Exception e) {
							logger.error("Se ha guardado la resolución pero no se ha podido notificar al usuario", e);
							errorsList.put("ofertaHRE", "Se ha guardado la resolución pero no se ha podido notificar al usuario");
						}
					}
				}
			}

			if (!Checks.esNulo(notifrem)) {
				model.put("id", jsonFields.get("id"));
				model.put("error", null);
			} else {
				model.put("id", jsonFields.get("id"));
				if (errorsList != null && errorsList.size() > 0) {
					model.put("error", errorsList);
				} else {
					model.put("error", null);
				}

			}

		} catch (JsonMappingException e3) {
			logger.error("Error json resolucion comite", e3);
			model.put("id", jsonFields.get("id"));
			model.put("error",
					"Los datos enviados en la petición no están correctamente formateados. Comprueba que las fecha sean 'yyyy-MM-dd'T'HH:mm:ss'. ");
			request.getPeticionRest().setErrorDesc(e3.getMessage());

		} catch (Exception e2) {
			logger.error("Error resolucion comite", e2);
			model.put("id", jsonFields.get("id"));
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			request.getPeticionRest().setErrorDesc(e2.getMessage());

		}

		restApi.sendResponse(response, model, request);

	}

}