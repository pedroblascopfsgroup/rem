package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.rest.dto.NotificacionRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller
public class NotificacionesController {
	
	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private AnotacionApi anotacionApi;

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ActivoApi activoApi;


	/**
	 * Inserta una notificacion Ejem: IP:8080/pfs/rest/notificaciones HEADERS:
	 * Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"109238120575","data":[{"titulo":"notificaaaaaaaaaaa",
	 * "descripcion":"descipcion notf1qqqqqq"
	 * ,"codTipoNotificacion":"N","idActivoHaya":37153,"idNotificacionWebcom":
	 * 34234343,"idUsuarioRemAccion":29468,"fechaAccion":"2016-01-01T10:10:10",
	 * "fechaRealizacion":"2016-10-01T10:10:10"}]}
	 *
	 * @param model
	 * @param request
	 * @return
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/notificaciones")
	public void saveNotificacion(ModelMap model, RestRequestWrapper request,HttpServletResponse response)
			throws JsonParseException, JsonMappingException, IOException {

		NotificacionRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = null;
		HashMap<String, String> errorsList = null;
		JSONObject jsonFields = null;
		
		try {
			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);
			
			jsonData = (NotificacionRequestDto) request.getRequestData(NotificacionRequestDto.class);		
			
			
			if(Checks.esNulo(jsonFields) && jsonFields.isEmpty()){
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);				
			}
				
			List<NotificacionDto> notificaciones = jsonData.getData();
	
			for (NotificacionDto notificacion : notificaciones) {
				map = new HashMap<String, Object>();
				errorsList = anotacionApi.validateNotifPostRequestData(notificacion, jsonFields);
				
				if (!Checks.esNulo(errorsList) && errorsList.size() == 0) {
					Notificacion notificacionBbdd = new Notificacion();
					Activo activo = activoApi.getByNumActivo(notificacion.getIdActivoHaya());
					Usuario gestor = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
					notificacionBbdd.setIdActivo(activo.getId());
					notificacionBbdd.setIdTareaAppExterna(notificacion.getIdNotificacionWebcom());
					notificacionBbdd.setDestinatario(gestor.getId());
					notificacionBbdd.setTitulo(notificacion.getTitulo());
					notificacionBbdd.setDescripcion(notificacion.getDescripcion());
					if(!Checks.esNulo(notificacion.getFechaRealizacion())){
						notificacionBbdd.setFecha(notificacion.getFechaRealizacion());
					}else{
						notificacionBbdd.setFecha(null);
					}
					
					Notificacion notifrem = anotacionApi.saveNotificacion(notificacionBbdd);
					map.put("idNotificacionWebcom", notificacion.getIdNotificacionWebcom());
					map.put("idNotificacionRem", notifrem.getIdsNotificacionCreada().get(0));
					map.put("success", true);
				} else {
					map.put("idNotificacionWebcom", notificacion.getIdNotificacionWebcom());
					map.put("success", false);
					map.put("invalidFields", errorsList);
				}
				listaRespuesta.add(map);
			}
			
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", "null");
			
		} catch (Exception e) {
			logger.error("Error notificaciones", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			map.put("success", false);
		} finally {
			logger.debug("RESPUESTA: " + model);
		}
		restApi.sendResponse(response,model,request);
	}

}
