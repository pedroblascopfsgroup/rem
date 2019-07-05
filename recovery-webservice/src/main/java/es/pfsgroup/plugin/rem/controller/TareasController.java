package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.procesosJudiciales.EXTTareaExternaManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.TareaRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class TareasController {

	@Autowired
	private AgendaAdapter agendaAdapter;
	
	@Autowired
	private EXTTareaExternaManager tareaManager;

	@Autowired
	private RestApi restApi;
	
	private final Log logger = LogFactory.getLog(getClass());
	

	/**
	 * Avanza tareas Ejem: IP:8080/pfs/rest/tareas/avanza
	 * HEADERS: Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"4271073","data": {"observaciones":["asdasdasd"], 
	 * "comboFirma": ["01"], 
	 * "motivoNoFirma":["01"], 
	 * "tieneReserva":["0"],
	 * "fechaFirma":["2019-05-09"],
	 * "asistenciaPBC":["0"], 
	 * "obsAsisPBC":["sin asistencia"]}}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/tareas/avanza")
	public void avanzaTarea(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		
		TareaRequestDto jsonData = null;
		Map<String, String[]> datosTarea = new HashMap<String, String[]>();
		JSONObject jsonFields = null;

		boolean resultado = false;
		
		try {

			jsonFields = request.getJsonObject();
			jsonData = (TareaRequestDto) request.getRequestData(TareaRequestDto.class);
			datosTarea = jsonData.getData();

			
			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {
				
				String[] idTarea = new String[1];
				idTarea[0] = jsonData.getIdTarea();
				datosTarea.put("idTarea",idTarea);

				resultado = agendaAdapter.validationAndSave(datosTarea);

				model.put("id", jsonFields.get("id"));
				model.put("data", resultado);
				model.put("error", "null");
			}

		} catch (Exception e) {
			logger.error("Error avance tarea ", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("data", resultado);
			model.put("error", RestApi.REST_MSG_VALIDACION_TAREA+": "+e.getMessage());
		}

		restApi.sendResponse(response, model, request);
	}

}