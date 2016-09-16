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
import es.pfsgroup.plugin.rem.notificaciones.NotificacionesWsManager;
import es.pfsgroup.plugin.rem.rest.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.rest.dto.NotificacionRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class NotificacionesController {

	@Autowired
	private NotificacionAdapter notificacionAdapter;

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private NotificacionesWsManager notifWsManager;

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
				errorsList = notifWsManager.validateNotificacionRequest(notificacion);
				if (errorsList.size() == 0) {
					Notificacion notificacionBbdd = new Notificacion();
					notificacionBbdd.setIdActivo(notificacion.getIdActivoHaya());
					notificacionBbdd.setDestinatario(notificacion.getIdUsuarioRemAccion());
					notificacionBbdd.setTitulo(notificacion.getTitulo());
					notificacionBbdd.setDescripcion(notificacion.getDescripcion());
					notificacionBbdd.setFecha(notificacion.getFechaRealizacion());
					Notificacion notifrem = notificacionAdapter.saveNotificacion(notificacionBbdd);
					map.put("idNotificacionWebcom", notificacion.getIdNotificacionWebcom());
					map.put("idNotificacionRem", notifrem.getIdsNotificacionCreada().get(0));
					map.put("success", true);
					map.put("errorMessages", errorsList);
				} else {
					map.put("idNotificacionWebcom", notificacion.getIdNotificacionWebcom());
					map.put("success", false);
					map.put("errorMessages", errorsList);
				}
				listaRespuesta.add(map);
			}
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", "");
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
			map.put("success", false);
		}
		return new ModelAndView("jsonView", model);
	}

}
