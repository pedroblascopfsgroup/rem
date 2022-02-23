package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ClienteComercialApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.ClienteRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller
public class ClientesController {

	@Autowired
	private ClienteComercialApi clienteComercialApi;

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	/**
	 * Inserta o actualiza una lista de clienteComercial Ejem:
	 * IP:8080/pfs/rest/clientes HEADERS: Content-Type - application/json
	 * signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"111111111111","data": [{ "idClienteWebcom": "1",
	 * "razonSocial":"Razon Social", "nombre": "Nombre","apellidos":
	 * "Apellidos", "fechaAccion": "2016-01-01T10:10:10", "idUsuarioRem": "1",
	 * "codTipoDocumento": "01", "documento": "123456789B",
	 * "codTipoDocumentoRepresentante": "01", "documentoRepresentante":
	 * "123456789B", "telefono1": "919876543", "telefono2": "919876543",
	 * "email": "email@email.com", "codTipoPrescriptor": "04",
	 * "idProveedorRemPrescriptor": "5045", "idProveedorRemResponsable": "1010",
	 * "codTipoVia":"CL", "direccion": "Dirección", "numeroCalle":"10",
	 * "escalera":"A", "planta":"7", "puerta":"20", "codMunicipio": "46250",
	 * "codigoPostal": "12312", "codProvincia": "46", "codPedania": "462500000",
	 * "observaciones": "Observaciones","idUsuarioRemAccion":"29468" }]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/clientes")
	public void saveOrUpdateClienteComercial(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		ClienteRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;

		try {
			
			jsonFields = request.getJsonObject();
			jsonData = (ClienteRequestDto) request.getRequestData(ClienteRequestDto.class);
			List<ClienteDto> listaClienteDto = jsonData.getData();

			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {
				listaRespuesta = clienteComercialApi.saveOrUpdate(listaClienteDto, jsonFields);
				model.put("id", jsonFields.get("id"));
				model.put("data", listaRespuesta);
				model.put("error", "null");

				if (listaRespuesta != null && !listaRespuesta.isEmpty())
				for (Map<String, Object> map: listaRespuesta) {
					if (map.containsKey("replicateToBC") && Boolean.TRUE.equals(map.get("replicateToBC")))
						try {
							clienteComercialApi.replicarClienteToBC((Long)map.get("idClienteForBC"), CaixaBcRestClient.ID_CLIENTE);
						}catch (Exception e){
							logger.error("Error replicando cliente a BC", e);
						}
				}
			}

		} catch (Exception e) {
			logger.error("Error cliente", e);
			model.put("id", jsonFields.get("id"));
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			model.put("descError", e.getMessage());
		}

		restApi.sendResponse(response, model,request);
	}

	/**
	 * Elimina una lista de clienteComercial Ejem: IP:8080/pfs/rest/clientes
	 * HEADERS: Content-Type - application/json signature - sdgsdgsdgsdg
	 * 
	 * BODY: {"id":"109238120575","data": [{ "idClienteWebcom": "1",
	 * "idClienteRem": "1"},{ "idClienteWebcom": "2", "idClienteRem": "2"}]}
	 * 
	 * @param model
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.DELETE, value = "/clientes")
	public void deleteClienteComercial(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {

		ClienteRequestDto jsonData = null;
		HashMap<String, String> errorsList = null;
		ClienteDto clienteDto = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = null;	

		try {

			jsonData = (ClienteRequestDto) request.getRequestData(ClienteRequestDto.class);
			List<ClienteDto> listaClienteDto = jsonData.getData();
			listaRespuesta = clienteComercialApi.deleteClienteComercial(listaClienteDto);

			for (int i = 0; i < listaClienteDto.size(); i++) {

				map = new HashMap<String, Object>();
				clienteDto = listaClienteDto.get(i);
				errorsList = restApi.validateRequestObject(clienteDto, TIPO_VALIDACION.UPDATE);

				if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
					clienteComercialApi.deleteClienteComercial(clienteDto);
					map.put("idClienteWebcom", clienteDto.getIdClienteWebcom());
					map.put("idClienteRem", clienteDto.getIdClienteRem());
					map.put("success", true);
				} else {
					map.put("idClienteWebcom", clienteDto.getIdClienteWebcom());
					map.put("idClienteRem", clienteDto.getIdClienteRem());
					map.put("success", false);
					map.put("invalidFields", errorsList);
				}
				listaRespuesta.add(map);

			}

			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", null);

		} catch (Exception e) {
			logger.error("Error cliente", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
			model.put("descError", e.getMessage());
		}

		restApi.sendResponse(response, model,request);
	}

}
