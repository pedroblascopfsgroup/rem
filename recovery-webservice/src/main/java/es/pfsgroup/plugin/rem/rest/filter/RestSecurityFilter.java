package es.pfsgroup.plugin.rem.rest.filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.RequestDto;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import net.sf.json.JSONObject;

/**
 * Filtro para la gestión de las peticiones a la rest-api
 * 
 * @author rllinares
 *
 */
public class RestSecurityFilter implements Filter {

	@Autowired
	private EntidadDao entidadDao;

	@Autowired
	private RestApi restApi;

	private String WORKINGCODE = "2038";

	private Entidad entidad = null;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		logger.debug("rest api iniciada");
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
	}

	@Override
	public void destroy() {
		logger.debug("rest api parada");
	}

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {

		PeticionRest peticion = restApi.crearPeticionObj(request);
		RestRequestWrapper restRequest = null;
		try {

			restRequest = new RestRequestWrapper((HttpServletRequest) request);
			// obtenemos los datos de la peticion
			RequestDto datajson = (RequestDto) restRequest.getRequestData(RequestDto.class);
			logger.debug("Ejecutando request id:".concat(datajson.getId()));
			logger.debug("Datos de la peticion id:".concat(restRequest.getBody()));

			doSessionConfig(response, WORKINGCODE);

			// logamos el operador partiendo del parametro signature
			String signature = ((HttpServletRequest) request).getHeader("signature");
			String id = datajson.getId();
			peticion.setToken(id);
			String ipClient = restApi.getClientIpAddr(((HttpServletRequest) request));

			((HttpServletRequest) request).getHeader("X-Forwarded-For");

			Broker broker = restApi.getBrokerByIp(ipClient);
			if (broker == null) {
				broker = restApi.getBrokerDefault("");
				broker.setIp(ipClient);
			} else {
				peticion.setBroker(broker);
			}

			if (broker != null) {

				if (!restApi.validateSignature(broker, signature, restRequest.getBody())) {
					logger.error("REST: La firma no es correcta");
					peticion.setResult(RestApi.CODE_ERROR);
					peticion.setErrorDesc(RestApi.REST_MSG_INVALID_SIGNATURE);
					// throwUnauthorized(response);
					throwRestException(response, RestApi.REST_MSG_INVALID_SIGNATURE, restRequest.getJsonObject());

				} else {
					if (!restApi.validateId(broker, id)) {
						logger.error("REST: El id de la petición ya se ha ejecutado previamente");
						peticion.setResult(RestApi.CODE_ERROR);
						peticion.setErrorDesc(RestApi.REST_MSG_REPETEAD_REQUEST);
						// throwInvalidId(response);
						throwRestException(response, RestApi.REST_MSG_REPETEAD_REQUEST, restRequest.getJsonObject());

					} else if (!restRequest.getBody().contains("data")) {
						logger.error("REST: Petición no contiene información en el campo data.");
						peticion.setResult(RestApi.CODE_ERROR);
						peticion.setErrorDesc(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
						// throwInvalidRequest(response);
						throwRestException(response, RestApi.REST_MSG_MISSING_REQUIRED_FIELDS,
								restRequest.getJsonObject());

					} else {
						chain.doFilter(restRequest, response);
						peticion.setResult(RestApi.CODE_OK);
					}
				}
			}
			// securityContext.getAuthentication().setAuthenticated(false);
		} catch (Exception e) {
			peticion.setResult("ERROR");
			logger.error(e.getMessage());
			if (e.getMessage() != null && e.getMessage().length() > 200) {

				peticion.setErrorDesc(e.getMessage().substring(0, 199));
			} else {
				peticion.setErrorDesc(e.getMessage());
			}

			throwErrorGeneral(response, e, null);

		} catch (Throwable t) {
			peticion.setResult("ERROR");
			logger.error(t.getMessage());
			if (t.getMessage() != null && t.getMessage().length() > 200) {

				peticion.setErrorDesc(t.getMessage().substring(0, 199));
			} else {
				peticion.setErrorDesc(t.getMessage());
			}

			throwErrorGeneral(response, null, t);
		} finally {
			SecurityContextHolder.clearContext();
			restApi.guardarPeticionRest(peticion);
		}
	}

	/**
	 * Genera el formato de una respuesta de un servicio REST
	 * 
	 * @param errorCode
	 * @param jsonFields
	 * @throws IOException
	 */
	private JSONObject buildJsonResponse(String errorCode, JSONObject jsonFields) throws IOException {
		JSONObject jsonResp = null;
		Object jsonLine = null;
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

		if (!Checks.esNulo(jsonFields)) {

			jsonResp = new JSONObject();
			if (jsonFields.has("id")) {
				jsonResp.accumulate("id", jsonFields.get("id"));
			}
			if (!Checks.esNulo(errorCode)) {
				jsonResp.accumulate("error", errorCode);
			}

			if (jsonFields.has("data") && jsonFields.getJSONObject("data").isArray()) {
				if (!Checks.esNulo(jsonFields.getJSONArray("data")) && jsonFields.isArray()
						&& jsonFields.getJSONArray("data").size() > 0) {

					// Construimos mapa de ids a retornar
					for (int i = 0; i < jsonFields.getJSONArray("data").size(); i++) {
						map = new HashMap<String, Object>();
						jsonLine = jsonFields.getJSONArray("data").get(i);
						if (((JSONObject) jsonLine).containsKey("idInformeMediadorWebcom")) {
							map.put("idInformeMediadorWebcom", ((JSONObject) jsonLine).get("idInformeMediadorWebcom"));
							map.put("idActivoHaya", ((JSONObject) jsonLine).get("idActivoHaya"));
						}
						if (((JSONObject) jsonLine).containsKey("idClienteWebcom")) {
							map.put("idClienteWebcom", ((JSONObject) jsonLine).get("idClienteWebcom"));
							map.put("idClienteRem", ((JSONObject) jsonLine).get("idClienteRem"));
						}
						if (((JSONObject) jsonLine).containsKey("idVisitaWebcom")) {
							map.put("idVisitaWebcom", ((JSONObject) jsonLine).get("idVisitaWebcom"));
							map.put("idVisitaRem", ((JSONObject) jsonLine).get("idVisitaRem"));
						}
						if (((JSONObject) jsonLine).containsKey("idOfertaWebcom")) {
							map.put("idOfertaWebcom", ((JSONObject) jsonLine).get("idOfertaWebcom"));
							map.put("idOfertaRem", ((JSONObject) jsonLine).get("idOfertaRem"));
						}
						if (((JSONObject) jsonLine).containsKey("idActivoHaya")) {
							map.put("idActivoHaya", ((JSONObject) jsonLine).get("idActivoHaya"));
						}
						if (((JSONObject) jsonLine).containsKey("idTrabajoWebcom")) {
							map.put("idTrabajoWebcom", ((JSONObject) jsonLine).get("idTrabajoWebcom"));
							map.put("idTrabajoRem", ((JSONObject) jsonLine).get("idTrabajoRem"));
						}
						if (((JSONObject) jsonLine).containsKey("idNotificacionWebcom")) {
							map.put("idNotificacionWebcom", ((JSONObject) jsonLine).get("idNotificacionWebcom"));
							map.put("idNotificacionRem", ((JSONObject) jsonLine).get("idNotificacionRem"));
						}
						map.put("success", false);

						listaRespuesta.add(map);
					}
					jsonResp.accumulate("data", listaRespuesta);

				} else {
					jsonResp.accumulate("data", jsonFields.getJSONArray("data"));
				}
			}
		}

		return jsonResp;

	}

	/**
	 * Genera una respuesta de error
	 * 
	 * @param res
	 * @throws IOException
	 */
	private void throwRestException(ServletResponse res, String errorCode, JSONObject jsonFields) throws IOException {
		JSONObject jsonResp = null;

		HttpServletResponse response = (HttpServletResponse) res;

		jsonResp = buildJsonResponse(errorCode, jsonFields);

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");

		if (!Checks.esNulo(jsonResp)) {
			PrintWriter out = response.getWriter();
			out.print(jsonResp);
			out.flush();
		} else {

		}

	}

	/**
	 * Error el operador no permitido
	 * 
	 * @param res
	 * @throws IOException
	 */
	@SuppressWarnings("unused")
	private void throwBrokerNotExist(ServletResponse res) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String error = "{\"data\":null,\"error\":\"" + RestApi.REST_MSG_BROKER_NOT_EXIST + "\"}";

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}

	/**
	 * Error de workingcode
	 * 
	 * @param res
	 * @throws IOException
	 */
	private void throwErrorWorkingCodeInvalido(ServletResponse res) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String error = "{\"data\":null,\"error\":\"" + RestApi.REST_MSG_INVALID_WORKINGCODE + "\"}";

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}

	/**
	 * Error general
	 * 
	 * @param res
	 * @param e
	 * @throws IOException
	 */
	private void throwErrorGeneral(ServletResponse res, Exception e, Throwable t) {

		try {
			HttpServletResponse response = (HttpServletResponse) res;

			String descError = "";

			if (e != null && e.getMessage() != null && !e.getMessage().isEmpty()) {
				descError = e.getMessage().toUpperCase();
			}

			if (t != null && t.getMessage() != null && !t.getMessage().isEmpty()) {
				descError = t.getMessage().toUpperCase();
			}
			descError =StringEscapeUtils.escapeXml(descError);

			String error = "{\"data\":null,\"error\":\"".concat(descError).concat("\"}");

			response.reset();
			response.setHeader("Content-Type", "application/json;charset=UTF-8");
			response.getWriter().write(error);
		} catch (Exception ex) {

		}
	}

	/**
	 * Realiza la configuracion de la sesión
	 * 
	 * @param response
	 * @param workingCode
	 * @throws IOException
	 */
	private void doSessionConfig(ServletResponse response, String workingCode) throws IOException {
		// Obtenemos la entidad partiendo del working code y establecemos el
		// contextholder
		// necesario para acceder al esquema de la entidad
		try {
			entidad = entidadDao.findByWorkingCode(workingCode);
		} catch (Exception e) {
			logger.error("Error obteniendo la entidad: ");
		}

		entidad = entidadDao.findByWorkingCode(workingCode);

		if (entidad != null) {
			DbIdContextHolder.setDbId(entidad.getId());
		} else {
			logger.error("El workingcode no pertenece a ninguna entidad");
			throwErrorWorkingCodeInvalido(response);
			return;
		}

		// Realizamos login en la plataforma
		restApi.doLogin(restApi.loadUserRest(entidad));

	}

}