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
import es.pfsgroup.plugin.rem.api.ClienteComercialApi;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
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
		ClienteComercial cliente = null;

		ClienteDto clienteDto = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		JSONObject jsonFields = null;
		HashMap<String, List<String>> errorsList = null;

		try {

			jsonData = (ClienteRequestDto) request.getRequestData(ClienteRequestDto.class);
			List<ClienteDto> listaClienteDto = jsonData.getData();
			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);

			if (Checks.esNulo(jsonFields) && jsonFields.isEmpty()) {
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);

			} else {
				for (int i = 0; i < listaClienteDto.size(); i++) {

					ClienteComercial clc = null;
					map = new HashMap<String, Object>();
					clienteDto = listaClienteDto.get(i);
					cliente = clienteComercialApi.getClienteComercialByIdClienteWebcom(clienteDto.getIdClienteWebcom());
					if (Checks.esNulo(cliente)) {
						errorsList = restApi.validateRequestObject(clienteDto, TIPO_VALIDACION.INSERT);
						if (errorsList.size() == 0) {
							clienteComercialApi.saveClienteComercial(clienteDto);
						}

					} else {
						errorsList = restApi.validateRequestObject(clienteDto, TIPO_VALIDACION.UPDATE);
						if (errorsList.size() == 0) {
							clienteComercialApi.updateClienteComercial(cliente, clienteDto,
									jsonFields.getJSONArray("data").get(i));
						}

					}

					if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
						clc = clienteComercialApi.getClienteComercialByIdClienteWebcom(clienteDto.getIdClienteWebcom());
						map.put("idClienteWebcom", clc.getIdClienteWebcom());
						map.put("idClienteRem", clc.getIdClienteRem());
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
				model.put("error", "null");

			}

		} catch (Exception e) {
			logger.error(e);
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		} finally {
			logger.debug("RESPUESTA: " + model);
			logger.debug("ERRORES: " + errorsList);
		}

		restApi.sendResponse(response, model);
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
		HashMap<String, List<String>> errorsList = null;
		ClienteDto clienteDto = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

		try {

			jsonData = (ClienteRequestDto) request.getRequestData(ClienteRequestDto.class);
			List<ClienteDto> listaClienteDto = jsonData.getData();

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
					map.put("errorMessages", errorsList);
				}
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

		restApi.sendResponse(response, model);
	}

}
