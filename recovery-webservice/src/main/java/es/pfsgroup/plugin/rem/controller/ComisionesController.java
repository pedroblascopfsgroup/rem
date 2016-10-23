package es.pfsgroup.plugin.rem.controller;

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

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastosExpedienteApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ComisionRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller
public class ComisionesController {

	@Autowired
	private GastosExpedienteApi gastosExpedienteApi;

	@Autowired
	private RestApi restApi;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Actualiza una lista de Comisiones para dar aceptación o no a las mismas
	 * Ejem: IP:8080/pfs/rest/comisiones HEADERS: Content-Type -
	 * application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"111111112113","data": [{"idVisitaWebcom": "1",
	 * "idClienteRem": "2", "idActivoHaya": "0", "codEstadoVisita":
	 * "04","codDetalleEstadoVisita": "04", "fecha": "2016-01-01T10:10:10",
	 * "idUsuarioRem": "1", "idProveedorRemPrescriptor": "5045",
	 * "idProveedorRemCustodio": "1010", "idProveedorRemResponsable": "1010",
	 * "idProveedorRemFdv": "1010" , "idProveedorRemVisita": "1010",
	 * "observaciones": "updated1" }]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/comisiones")
	public void updateAceptacionGasto(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		ComisionRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;

		try {
			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);
			
			jsonData = (ComisionRequestDto) request.getRequestData(ComisionRequestDto.class);
			List<ComisionDto> listaComisionDto = jsonData.getData();

			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {
				listaRespuesta = gastosExpedienteApi.updateAceptacionesGasto(listaComisionDto, jsonFields);
				model.put("id", jsonFields.get("id"));
				model.put("data", listaRespuesta);
				model.put("error", "null");
			}

		} catch (Exception e) {
			logger.error(e);
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		} finally {
			logger.debug("RESPUESTA: " + model);
		}

		restApi.sendResponse(response, model);
	}

}
