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

//import org.codehaus.jackson.map.JsonMappingException;
//import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceResolucionComite;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller
public class ResolucionComiteController {
	
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ResolucionComiteApi resolucionComiteApi;
	
	@Autowired
	private AnotacionApi anotacionApi;
	
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
	private NotificatorServiceResolucionComite notificatorApi;
	
    @SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/resolucioncomite")
	public void resolucionComite(ModelMap model, RestRequestWrapper request,HttpServletResponse response) {

		ResolucionComiteRequestDto jsonData = null;
		ResolucionComiteDto resolucionComiteDto = null;
		ResolucionComiteBankia resol = null;
		Notificacion notif = null;
		Notificacion notifrem = null;
		JSONObject jsonFields = null;
		HashMap<String, String> errorsList = null;
		Usuario usu = null;
		Boolean ratificacion = false;
		String cuerpo = "";
		Long unidadGestion = null;
		ActivoTramite tramite = null;
		String mensajeDevolucion="";
		
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
					if(Checks.esNulo(ofr) || (!Checks.esNulo(ofr) && !ofr.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_ACEPTADA))){
						throw new Exception("No existe la oferta o no esta aceptada.");
					}
					
					ExpedienteComercial eco = expedienteComercialApi.expedienteComercialPorOferta(ofr.getId());
					if(Checks.esNulo(eco)){
						throw new Exception("No existe el expediente comercial de la oferta.");
					}
					
					List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
					if(Checks.esNulo(listaTramites) || listaTramites.size() == 0){
						throw new Exception("No se ha podido recuperar el trámite de la oferta.");
					}else{
						tramite = listaTramites.get(0);
						if(Checks.esNulo(tramite)){
							throw new Exception("No se ha podido recuperar el trámite de la oferta.");
						}
					}
					
					
					//Si existe la tarea T013_RatificacionComite, se trata de una ratificación
//					List<TareaProcedimiento> listaTareas = activoTramiteApi.getTareasByIdTramite(tramite.getId());
//					for(int i=0;i< listaTareas.size(); i++){
//						TareaProcedimiento tarea = listaTareas.get(i);						
//						if(!Checks.esNulo(tarea)){
//							if(tarea.getCodigo().equalsIgnoreCase("T013_RatificacionComite")){
//								ratificacion = true;
//								break;
//							}
//						}
//					}
					resolucionComiteDto.setCodigoTipoResolucion(DDTipoResolucion.CODIGO_TIPO_RESOLUCION);
					usu = gestorActivoApi.userFromTarea("T013_ResolucionComite", tramite.getId());					
					if(usu == null){
						usu = gestorActivoApi.userFromTarea("T013_RatificacionComite", tramite.getId());
						if(usu == null){
							usu = gestorActivoApi.userFromTarea("T013_RespuestaOfertante", tramite.getId());
						}
					}

					resol = resolucionComiteApi.saveOrUpdateResolucionComite(resolucionComiteDto);
					
					if(!Checks.esNulo(resolucionComiteDto.getDevolucion()) && resolucionComiteDto.getDevolucion().equals("S")){
						expedienteComercialApi.updateEstadoDevolucionReserva(eco, DDEstadoDevolucion.ESTADO_DEVUELTA);
						expedienteComercialApi.updateEstadosResolucionDevolucion(eco, resolucionComiteDto);
						usu= gestorActivoApi.getGestorComercialActual(ofr.getActivoPrincipal(), "GCOM");
						mensajeDevolucion= "El comité sancionador de bankia ha resuelto la resolución "+resol.getEstadoResolucion().getDescripcion()+" devuelta con el importe de la reserva del expediente "+eco.getNumExpediente()+".\n";
					}else if(!Checks.esNulo(resolucionComiteDto.getDevolucion()) && resolucionComiteDto.getDevolucion().equals("N")){
						expedienteComercialApi.updateEstadoDevolucionReserva(eco, DDEstadoDevolucion.ESTADO_NO_PROCEDE);
						expedienteComercialApi.updateEstadosResolucionNoDevolucion(eco, resolucionComiteDto);
						usu= gestorActivoApi.getGestorComercialActual(ofr.getActivoPrincipal(), "GCOM");
						mensajeDevolucion= "El comité sancionador de bankia ha resuelto la resolución "+resol.getEstadoResolucion().getDescripcion()+" retenida con el importe de la reserva del expediente "+eco.getNumExpediente()+".\n";

					}
										
					//Envío correo/notificación
					if(!Checks.esNulo(resol) && !Checks.esNulo(usu)){
							
						notif = new Notificacion();
						Activo actPpal = eco.getOferta().getActivoPrincipal();
						ActivoAgrupacion agrup = eco.getOferta().getAgrupacion();
						
						//Construimos cuerpo correo/aviso
						cuerpo = ResolucionComiteApi.NOTIF_RESOL_COMITE_BODY_INITMSG.concat("\n");
						if(!Checks.esNulo(eco) && 
						   !Checks.esNulo(eco.getOferta()) &&
						   !Checks.esNulo(eco.getOferta().getNumOferta())){
							cuerpo += "Oferta HRE: " + eco.getOferta().getNumOferta() + ".\n";
						}
						if(!Checks.esNulo(agrup)){
							unidadGestion = agrup.getNumAgrupRem();
							cuerpo += "Lote: " + agrup.getNumAgrupRem() + ".\n";
						}else{
							unidadGestion = actPpal.getNumActivo();
							cuerpo += "Activo: " + actPpal.getNumActivo() + ".\n";
						}												
						if(!Checks.esNulo(resol.getComite()) &&
						   !Checks.esNulo(resol.getComite().getDescripcion())){
							cuerpo +=  "Comité decisor: " + resol.getComite().getDescripcion() + ".\n";
						}
						if(!Checks.esNulo(resol.getEstadoResolucion()) &&
						   !Checks.esNulo(resol.getEstadoResolucion().getDescripcion())){
							cuerpo +=  "Resolución: " + resol.getEstadoResolucion().getDescripcion() + ".\n";
						}
						if(!Checks.esNulo(resolucionComiteDto.getDevolucion())){
							cuerpo += mensajeDevolucion;
						}
						else{
							if(!Checks.esNulo(resol.getMotivoDenegacion()) && 
							   !Checks.esNulo(resol.getMotivoDenegacion().getDescripcion())){
								cuerpo +=  "Motivo denegación: " + resol.getMotivoDenegacion().getDescripcion() + ".\n";
							}
							if(!Checks.esNulo(resol.getFechaAnulacion())){
								cuerpo +=  "Fecha anulación: " + resol.getFechaAnulacion() + ".\n";
							}
							if(!Checks.esNulo(resol.getImporteContraoferta())){
								cuerpo +=  "Importe contraoferta: " + resol.getImporteContraoferta() + ".\n";
							}
						}
						
						cuerpo += ResolucionComiteApi.NOTIF_RESOL_COMITE_BODY_ENDMSG;
								
						notif.setTitulo(ResolucionComiteApi.NOTIF_RESOL_COMITE_TITEL_MSG + resolucionComiteDto.getOfertaHRE() + " del activo/lote " + unidadGestion);
						notif.setDescripcion(cuerpo);
						notif.setIdActivo(actPpal.getId());
						notif.setDestinatario(usu.getId());	
						notif.setFecha(null);
						
						notifrem = anotacionApi.saveNotificacion(notif);
						if(Checks.esNulo(notifrem)){
							errorsList.put("error", "Se ha producido un error al enviar la notificación.");
						}else{
							notif.setPara(usu.getEmail());
							notificatorApi.notificarResolucionBankia(resol,notif);
							logger.debug("\tEnviando correo a: " + notif.getPara());
						}
					}else{
						request.getPeticionRest().setErrorDesc("Se ha guardado la resolución pero no se ha podido notificar al usuario");
						logger.error("Se ha guardado la resolución pero no se ha podido notificar al usuario");
					}
				}
				
			}
			
			if(!Checks.esNulo(notifrem)){
				model.put("id", jsonFields.get("id"));
				model.put("error", null);
			}else{
				model.put("id", jsonFields.get("id"));
				if(errorsList != null && errorsList.size()>0){
					model.put("error", errorsList);
				}else{
					model.put("error", null);
				}
				
			}
			
		} catch (JsonMappingException e3) {
			logger.error("Error json resolucion comite", e3);
			model.put("id", jsonFields.get("id"));
			model.put("error", "Los datos enviados en la petición no están correctamente formateados. Comprueba que las fecha sean 'yyyy-MM-dd'T'HH:mm:ss'. ");
			request.getPeticionRest().setErrorDesc(e3.getMessage());
		
		} catch (Exception e2) {	
			logger.error("Error resolucion comite", e2);
			model.put("id", jsonFields.get("id"));	
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			request.getPeticionRest().setErrorDesc(e2.getMessage());
			
			
		}

		restApi.sendResponse(response, model,request);

	}
	

}