package es.pfsgroup.plugin.rem.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.rest.api.NotificatorApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class ResolucionComiteController {
	
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ResolucionComiteApi resolucionComiteApi;
	
	@Autowired
	private AnotacionApi anotacionApi;
	
	@Autowired
	private ActivoTramiteApi ActivoTramiteApi;
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	
	@Autowired
	NotificatorApi notificatorApi;
	
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
		
		try {

			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);
				
			jsonData = (ResolucionComiteRequestDto) request.getRequestData(ResolucionComiteRequestDto.class);			
			resolucionComiteDto = jsonData.getData();

			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {
						
				errorsList = resolucionComiteApi.validateResolucionPostRequestData(resolucionComiteDto, jsonFields);
				
				if (!Checks.esNulo(errorsList) && errorsList.size() == 0) {
					resol = resolucionComiteApi.saveResolucionComite(resolucionComiteDto);				
					
					//Envío correo/notificación
					if(!Checks.esNulo(resol)){
						ExpedienteComercial eco = expedienteComercialApi.expedienteComercialPorOferta(resol.getOferta().getId());
						if(Checks.esNulo(eco)){
							throw new Exception("No existe el expediente comercial de la oferta.");
						}
						
						List<ActivoTramite> listaTramites = ActivoTramiteApi.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
						if(Checks.esNulo(listaTramites) || listaTramites.size() == 0){
							throw new Exception("No se ha podido recuperar el trámite de la oferta.");
						}
						
						Usuario usu = gestorActivoApi.userFromTarea("T013_CierreEconomico", listaTramites.get(0).getId());
						if(Checks.esNulo(usu)){
							throw new Exception("No se ha podido recuperar el usuario a quién notificar.");
						}
						
						notif = new Notificacion();
						notif.setIdActivo(resol.getOferta().getActivoPrincipal().getId());
						notif.setDestinatario(usu.getId());
						notif.setTitulo(ResolucionComiteApi.NOTIF_RESOL_COMITE_TITEL_MSG + resol.getOferta().getNumOferta());
						notif.setDescripcion(ResolucionComiteApi.NOTIF_RESOL_COMITE_BODY_MSG);
						notif.setFecha(null);
						
						notifrem = anotacionApi.saveNotificacion(notif);
						if(Checks.esNulo(notifrem)){
							errorsList.put("error", "Se ha producido un error al enviar la notificación.");
						}else{
							notif.setPara(usu.getEmail());
							notificatorApi.notificator(resol,notif);
							logger.debug("\tEnviando correo a: " + notif.getPara());
						}
					}
				}
			}
			
			if(!Checks.esNulo(notifrem)){
				model.put("id", jsonFields.get("id"));
				model.put("error", "");
			}else{
				model.put("id", jsonFields.get("id"));
				model.put("error", errorsList);
			}
			
		} catch (JsonMappingException e3) {
			logger.error(e3);
			model.put("id", jsonFields.get("id"));
			model.put("error", "Los datos enviados en la petición no están correctamente formateados. Comprueba que las fecha sean 'yyyy-MM-dd'T'HH:mm:ss'. ");			
		
		} catch (Exception e2) {	
			logger.error(e2);
			model.put("id", jsonFields.get("id"));	
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			
		} catch (Throwable t) {	
			logger.error(t);
			model.put("id", jsonFields.get("id"));	
			model.put("error", "Los datos enviados en la petición no están correctamente formateados. Comprueba que las fecha sean 'yyyy-MM-dd'T'HH:mm:ss'. ");
		
		} finally {
			logger.debug("RESPUESTA: " + model);
		}

		restApi.sendResponse(response, model,request);

	}
	

}