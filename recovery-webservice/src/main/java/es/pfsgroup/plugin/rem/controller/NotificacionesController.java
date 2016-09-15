package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.pfsgroup.framework.paradise.agenda.adapter.NotificacionAdapter;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.rem.rest.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.rest.dto.NotificacionRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class NotificacionesController {

	@Autowired
	private NotificacionAdapter notificacionAdapter;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Inserta una notificacion Ejem: IP:8080/pfs/rest/notificaciones HEADERS:
	 * Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"109238120575","data":[{"titulo":"titulo notif1"
	 * ,"descripcion":"descipcion notf1"
	 * ,"fechaRealizacion":"2016-01-01T10:10:10","codTipoNotificacion":"NOTIF",
	 * "idActivoHaya":3142424,"idNotificacionRem":4343423434,
	 * "idNotificacionWebcom":34234343,"idUsuarioRemAccion":56,
	 * "idUsuarioDestinoRem":1},{"titulo":"titulo notif2","descripcion":
	 * "descipcion notf2"
	 * ,"fechaRealizacion":"2016-01-01T10:10:10","codTipoNotificacion":"NOTIF",
	 * "idActivoHaya":3142424,"idNotificacionRem":4343423434,
	 * "idNotificacionWebcom":34234343,"idUsuarioRemAccion":56,
	 * "idUsuarioDestinoRem":1}]}
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
	public ModelAndView saveNotificacion(ModelMap model, RestRequestWrapper request)
			throws JsonParseException, JsonMappingException, IOException {

		NotificacionRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = null;
		List<String> errorsList = null;

		try {
			jsonData = (NotificacionRequestDto) request.getRequestData(NotificacionRequestDto.class);

			List<NotificacionDto> notificaciones = jsonData.getData();

			for (NotificacionDto notificacion : notificaciones) {
				map = new HashMap<String, Object>();
				errorsList = new ArrayList<String>();
				Notificacion notificacionBbdd = new Notificacion();
				notificacionBbdd.setIdActivo(notificacion.getIdActivoHaya());
				notificacionBbdd.setDestinatario(notificacion.getIdUsuarioDestinoRem());
				notificacionBbdd.setTitulo(notificacion.getTitulo());
				notificacionBbdd.setDescripcion(notificacion.getDescripcion());
				notificacionBbdd.setFecha(notificacion.getFechaRealizacion());
				Notificacion notifrem = notificacionAdapter.saveNotificacion(notificacionBbdd);
				map.put("idNotificacionWebcom", notificacion.getIdNotificacionWebcom());
				map.put("idNotificacionRem", "falta");
				map.put("success", true);
				map.put("errorMessages", errorsList);
				listaRespuesta.add(map);
			}
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", "");
		} catch (Exception e) {
			logger.error(e);
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		}
		listaRespuesta.add(map);
		return new ModelAndView("jsonView", model);
	}
}
